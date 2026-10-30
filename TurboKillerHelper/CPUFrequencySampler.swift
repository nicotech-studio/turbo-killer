import Darwin
import Foundation

/// All state, including pipe callbacks, belongs to this queue. Only the signed
/// app can reach this service; clients can choose one of four fixed intervals.
final class CPUFrequencySampler: @unchecked Sendable {
    private let queue = DispatchQueue(label: "cc.nicotech.TurboKiller.frequency")
    private var process: Process?
    private var stream = CPUFrequencyPlistStream()
    private var interval = 0
    private var pending: ((NSNumber, String) -> Void)?
    private var requestID = UUID()
    private var lastRequest: TimeInterval = 0
    private var watchdog: DispatchSourceTimer?

    func nextSample(intervalMilliseconds: Int, reply: @escaping (NSNumber, String) -> Void) {
        queue.async { [self] in
            guard [1000, 2000, 5000, 10000].contains(intervalMilliseconds) else {
                reply(-1, "Unsupported frequency sampling interval.")
                return
            }
            if interval != intervalMilliseconds || process == nil {
                stopOnQueue(message: "Frequency sampling restarted.")
                do { try launch(intervalMilliseconds: intervalMilliseconds) }
                catch { reply(-1, "CPU frequency sampling could not start."); return }
            }
            pending?(-1, "Frequency sampling request replaced.")
            pending = reply
            lastRequest = ProcessInfo.processInfo.systemUptime
            let id = UUID()
            requestID = id
            queue.asyncAfter(deadline: .now() + .milliseconds(intervalMilliseconds + 4000)) { [self] in
                guard requestID == id, pending != nil else { return }
                stopOnQueue(message: "CPU frequency sampling timed out.")
            }
        }
    }

    func stop(reply: @escaping (NSNumber, String) -> Void) {
        queue.async { [self] in
            stopOnQueue(message: "CPU frequency sampling stopped.")
            reply(0, "")
        }
    }

    private func launch(intervalMilliseconds: Int) throws {
        let child = Process()
        let stdout = Pipe()
        let stderr = Pipe()
        child.executableURL = URL(fileURLWithPath: "/usr/bin/powermetrics")
        child.arguments = ["--samplers", "cpu_power", "--format", "plist",
                           "--buffer-size", "0", "--sample-rate", String(intervalMilliseconds)]
        child.environment = ["PATH": "/usr/bin:/bin:/usr/sbin:/sbin", "LC_ALL": "C"]
        child.standardOutput = stdout
        child.standardError = stderr
        stdout.fileHandleForReading.readabilityHandler = { [weak self, weak child] handle in
            let data = handle.availableData
            if data.isEmpty { handle.readabilityHandler = nil; return }
            guard let self, let child else { return }
            self.queue.async {
                guard self.process === child else { return }
                do {
                    for frame in try self.stream.append(data) {
                        let reading = try CPUFrequencyReading.parse(plist: frame, endingAt: Date())
                        // A sleep/wake interval must never be presented as a fresh sample.
                        guard reading.end.timeIntervalSince(reading.start) <= Double(self.interval) / 1000 * 2 else {
                            continue
                        }
                        let payload = try JSONEncoder().encode(reading)
                        let callback = self.pending
                        self.pending = nil
                        callback?(0, String(decoding: payload, as: UTF8.self))
                    }
                } catch {
                    self.stopOnQueue(message: "CPU frequency data is unavailable on this Mac.")
                }
            }
        }
        // Drain stderr independently so a failed tool cannot fill a pipe.
        stderr.fileHandleForReading.readabilityHandler = { handle in
            if handle.availableData.isEmpty { handle.readabilityHandler = nil }
        }
        child.terminationHandler = { [weak self] child in
            self?.queue.async { [weak self] in
                guard let self, self.process === child else { return }
                self.stopOnQueue(message: "CPU frequency sampling ended unexpectedly.")
            }
        }
        try child.run()
        process = child
        interval = intervalMilliseconds
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now() + 5, repeating: 5)
        timer.setEventHandler { [weak self] in
            guard let self, ProcessInfo.processInfo.systemUptime - self.lastRequest > 30 else { return }
            self.stopOnQueue(message: "Frequency monitoring client disconnected.")
        }
        watchdog = timer
        timer.resume()
    }

    private func stopOnQueue(message: String) {
        watchdog?.cancel()
        watchdog = nil
        let child = process
        process = nil
        interval = 0
        stream = CPUFrequencyPlistStream()
        requestID = UUID()
        (child?.standardOutput as? Pipe)?.fileHandleForReading.readabilityHandler = nil
        (child?.standardError as? Pipe)?.fileHandleForReading.readabilityHandler = nil
        if let child, child.isRunning {
            child.terminate()
            queue.asyncAfter(deadline: .now() + 2) {
                if child.isRunning { kill(child.processIdentifier, SIGKILL) }
            }
        }
        let callback = pending
        pending = nil
        callback?(-1, message)
    }
}
