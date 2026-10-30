import Foundation
import Darwin

enum SampleFailure: Error { case unavailable }

actor ControlledFrequencySource: CPUFrequencyReadingSource {
    var requests: [(Int, CheckedContinuation<CPUFrequencyReading, Error>)] = []
    var stopCount = 0
    func read(interval: Int) async throws -> CPUFrequencyReading {
        try await withCheckedThrowingContinuation { requests.append((interval, $0)) }
    }
    func stop() async {
        stopCount += 1
        let waiting = requests
        requests = []
        for request in waiting { request.1.resume(throwing: SampleFailure.unavailable) }
    }
    func reply(_ reading: CPUFrequencyReading) { requests.removeFirst().1.resume(returning: reading) }
    func fail() { requests.removeFirst().1.resume(throwing: SampleFailure.unavailable) }
    var count: Int { requests.count }
    var requestedInterval: Int? { requests.last?.0 }
}

@main
struct FrequencyTests {
    @MainActor
    static func main() async throws {
        let now = Date()
        precondition(CPUBaseFrequency.nominalHertz(
            brandString: "Intel(R) Core(TM) i7-9750H CPU @ 2.60GHz", reportedHertz: 2_600_000_000
        ) == 2_600_000_000)
        precondition(CPUBaseFrequency.nominalHertz(
            brandString: "Intel(R) CPU @ 2600MHz", reportedHertz: 2_599_999_950
        ) == 2_600_000_000)
        for (brand, frequency) in [
            ("Intel(R) CPU @ 2.60GHz", 4_500_000_000.0),
            ("Intel(R) CPU @ 2.60GHz", 0.0),
            ("Intel(R) CPU @ 2.60GHz", Double.nan),
            ("Intel(R) CPU", 2_600_000_000.0),
            ("Apple CPU @ 2.60GHz", 2_600_000_000.0),
            ("Intel(R) CPU @ 99GHz", 99_000_000_000.0)
        ] {
            precondition(CPUBaseFrequency.nominalHertz(brandString: brand, reportedHertz: frequency) == nil)
        }
        print("PASS: base frequency requires corroborated Intel nominal data; missing, inconsistent and unsupported values stay hidden")
        func plist(_ root: [String: Any]) throws -> Data {
            try PropertyListSerialization.data(fromPropertyList: root, format: .xml, options: 0)
        }
        let raw = try plist(["processor": ["freq_hz": 2_400_000_000.0], "elapsed_ns": 2_000_000_000])
        let reading = try CPUFrequencyReading.parse(plist: raw, endingAt: now)
        precondition(reading.hertz == 2_400_000_000 && reading.start == now.addingTimeInterval(-2))
        for invalid: [String: Any] in [
            ["processor": ["freq_hz": 0], "elapsed_ns": 1_000_000_000],
            ["processor": ["freq_hz": -1], "elapsed_ns": 1_000_000_000],
            ["processor": ["freq_hz": true], "elapsed_ns": 1_000_000_000],
            ["processor": ["freq_hz": 2_400_000_000.0], "elapsed_ns": 0],
            ["processor": ["freq_hz": 2_400_000_000.0], "elapsed_ns": 120_000_000_000],
            ["GPU": ["freq_hz": 2_400_000_000.0], "elapsed_ns": 1_000_000_000]
        ] {
            do {
                _ = try CPUFrequencyReading.parse(plist: plist(invalid), endingAt: now)
                preconditionFailure("Accepted an invalid CPU sample")
            } catch { }
        }
        print("PASS: processor-wide Hz and elapsed time parse; invalid, idle, GPU and wake samples rejected")

        var stream = CPUFrequencyPlistStream()
        let partial = try stream.append(raw.prefix(13))
        precondition(partial.isEmpty)
        var tail = Data(raw.dropFirst(13)); tail.append(0); tail.append(raw); tail.append(0)
        let frames = try stream.append(tail)
        precondition(frames == [raw, raw])
        do {
            _ = try stream.append(Data(repeating: 1, count: CPUFrequencyPlistStream.maximumFrameSize + 1))
            preconditionFailure("Unbounded stream")
        } catch { }
        print("PASS: fragmented and batched NUL frames parse; oversized output is bounded")

        let suite = "TurboKiller.FrequencyTests.\(UUID())"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set(99, forKey: "frequencySamplingInterval")
        let source = ControlledFrequencySource()
        let monitor = CPUFrequencyMonitor(defaults: defaults, source: source)
        precondition(monitor.interval == 2 && monitor.showInMenuBar && monitor.recordInBackground)
        monitor.setInterval(0)
        precondition(monitor.interval == 2)
        monitor.observeStatus(.enabled, at: now.addingTimeInterval(-3))
        monitor.observeStatus(.disabled, at: now.addingTimeInterval(-1))
        monitor.accept(reading, now: now)
        let bands = monitor.bands(from: now.addingTimeInterval(-2), to: now)
        precondition(bands.count == 2 && bands[0].status == .enabled && bands[1].status == .disabled)
        precondition(bands[0].end == now.addingTimeInterval(-1))
        precondition(monitor.status(at: now.addingTimeInterval(50)) == .unavailable)
        monitor.observeStatus(.unavailable, at: now)
        precondition(monitor.status(at: now) == .unavailable)
        monitor.accept(reading, now: now)
        precondition(monitor.samples.count == 1)
        print("PASS: historical backgrounds split at confirmed changes; stale state is unknown; duplicate samples are ignored")

        monitor.accept(.init(start: now.addingTimeInterval(8), end: now.addingTimeInterval(10), hertz: 2e9), now: now.addingTimeInterval(10))
        precondition(monitor.samples[0].segment != monitor.samples[1].segment)
        monitor.setRecordInBackground(false)
        monitor.accept(.init(start: now.addingTimeInterval(10), end: now.addingTimeInterval(12), hertz: 2e9), now: now.addingTimeInterval(12))
        precondition(monitor.samples.count == 2)
        monitor.setHistoryVisible(true)
        monitor.accept(.init(start: now.addingTimeInterval(12), end: now.addingTimeInterval(14), hertz: 2e9), now: now.addingTimeInterval(14))
        precondition(monitor.samples.count == 3)
        monitor.accept(.init(start: now.addingTimeInterval(4000), end: now.addingTimeInterval(4002), hertz: 2e9), now: now.addingTimeInterval(4002))
        precondition(monitor.samples.count == 1)
        print("PASS: gaps split lines; background recording obeys settings; history expires after one hour")

        monitor.setHistoryVisible(false)
        monitor.setInterval(5)
        monitor.setShowInMenuBar(false)
        let restored = CPUFrequencyMonitor(defaults: defaults, source: source)
        precondition(restored.interval == 5 && !restored.showInMenuBar && !restored.recordInBackground)
        restored.start()
        restored.setHelperAvailable(true)
        for _ in 0..<10 { await Task.yield() }
        let initialRequests = await source.count
        precondition(initialRequests == 0)
        restored.setPopoverVisible(true)
        await wait { await source.count == 1 }
        let firstInterval = await source.requestedInterval
        precondition(firstInterval == 5)
        restored.setInterval(1)
        await wait { await source.count == 2 }
        let changedInterval = await source.requestedInterval
        precondition(changedInterval == 1)
        let fresh = CPUFrequencyReading(start: Date().addingTimeInterval(-1), end: Date(), hertz: 2.5e9)
        await source.reply(fresh)
        for _ in 0..<10 { await Task.yield() }
        precondition(restored.current == nil)
        await source.reply(fresh)
        await wait { await MainActor.run { restored.current != nil } }
        precondition(restored.samples.isEmpty)
        await wait { await source.count == 1 }
        await source.fail()
        await wait { await MainActor.run { restored.samplingFailed } }
        precondition(restored.current == nil)
        restored.sleep()
        precondition(!restored.isSampling)
        restored.wake()
        await wait { await source.count == 1 }
        await restored.shutdown()
        precondition(!restored.isSampling && restored.current == nil)
        print("PASS: demand controls sampling; settings persist; stale in-flight replies cannot overwrite new settings; errors clear readings; sleep/stop clean up")

        let sampler = CPUFrequencySampler()
        let invalidStatus: Int = await withCheckedContinuation { continuation in
            sampler.nextSample(intervalMilliseconds: 7) { status, _ in continuation.resume(returning: status.intValue) }
        }
        precondition(invalidStatus != 0)
        let stoppedStatus: Int = await withCheckedContinuation { continuation in
            sampler.stop { status, _ in continuation.resume(returning: status.intValue) }
        }
        precondition(stoppedStatus == 0)
        print("PASS: helper rejects arbitrary sampling intervals; stop is idempotent")
        if getuid() != 0 {
            let deniedStatus: Int = await withCheckedContinuation { continuation in
                sampler.nextSample(intervalMilliseconds: 1000) { status, _ in
                    continuation.resume(returning: status.intValue)
                }
            }
            precondition(deniedStatus != 0)
            print("PASS: unprivileged powermetrics exit returns an error without hanging the sampler")
        }
        print("All frequency regression checks passed. No privileged sampling, helper installation or Turbo Boost changes performed.")
    }

    static func wait(_ condition: () async -> Bool) async {
        for _ in 0..<1000 {
            if await condition() { return }
            try? await Task.sleep(for: .milliseconds(2))
        }
        preconditionFailure("Timed out waiting for test condition")
    }
}
