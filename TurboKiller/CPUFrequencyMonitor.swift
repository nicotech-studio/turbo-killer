import Combine
import Foundation

protocol CPUFrequencyReadingSource: Sendable {
    func read(interval: Int) async throws -> CPUFrequencyReading
    func stop() async
}

nonisolated struct HelperCPUFrequencySource: CPUFrequencyReadingSource {
    func read(interval: Int) async throws -> CPUFrequencyReading {
        try await TurboKillerHelperClient.readCPUFrequency(interval: interval)
    }
    func stop() async { await TurboKillerHelperClient.stopCPUFrequency() }
}

struct CPUFrequencyPoint: Identifiable {
    let id = UUID()
    let reading: CPUFrequencyReading
    let segment: Int
}

struct CPUFrequencyStatusObservation {
    let date: Date
    let status: TurboBoostStatus
}

struct CPUFrequencyBand: Identifiable {
    let id = UUID()
    let start: Date
    let end: Date
    let status: TurboBoostStatus
}

@MainActor
final class CPUFrequencyMonitor: ObservableObject {
    let baseFrequencyHertz: Double?
    static let allowedIntervals = [1, 2, 5, 10]
    static let retention: TimeInterval = 3600
    static let statusValidity: TimeInterval = 45

    @Published private(set) var interval: Int
    @Published private(set) var showInMenuBar: Bool
    @Published private(set) var recordInBackground: Bool
    @Published private(set) var current: CPUFrequencyReading?
    @Published private(set) var samples: [CPUFrequencyPoint] = []
    @Published private(set) var observations: [CPUFrequencyStatusObservation] = []
    @Published private(set) var samplingFailed = false
    @Published private(set) var helperAvailable = false
    @Published private(set) var isSampling = false

    private let defaults: UserDefaults
    private let source: any CPUFrequencyReadingSource
    private var task: Task<Void, Never>?
    private var cleanupTask: Task<Void, Never>?
    private var generation = UUID()
    private var segment = 0
    private var started = false
    private var popoverVisible = false
    private var historyVisible = false
    private var suspended = false

    init(defaults: UserDefaults = .standard,
         source: any CPUFrequencyReadingSource = HelperCPUFrequencySource(),
         baseFrequencyHertz: Double? = CPUBaseFrequency.current) {
        self.defaults = defaults
        self.source = source
        self.baseFrequencyHertz = baseFrequencyHertz
        let savedInterval = defaults.integer(forKey: "frequencySamplingInterval")
        interval = Self.allowedIntervals.contains(savedInterval) ? savedInterval : 2
        showInMenuBar = defaults.object(forKey: "showCPUFrequencyInMenuBar") as? Bool ?? true
        recordInBackground = defaults.object(forKey: "recordCPUFrequencyInBackground") as? Bool ?? true
    }

    func setInterval(_ seconds: Int) {
        guard Self.allowedIntervals.contains(seconds), seconds != interval else { return }
        interval = seconds
        defaults.set(seconds, forKey: "frequencySamplingInterval")
        restart()
    }

    func setShowInMenuBar(_ value: Bool) {
        showInMenuBar = value
        defaults.set(value, forKey: "showCPUFrequencyInMenuBar")
        reconcile()
    }

    func setRecordInBackground(_ value: Bool) {
        recordInBackground = value
        defaults.set(value, forKey: "recordCPUFrequencyInBackground")
        reconcile()
    }

    func setHelperAvailable(_ value: Bool) {
        guard helperAvailable != value else { return }
        helperAvailable = value
        reconcile()
    }

    func setPopoverVisible(_ value: Bool) { popoverVisible = value; reconcile() }
    func setHistoryVisible(_ value: Bool) { historyVisible = value; reconcile() }

    func start() { started = true; reconcile() }
    func stop() { started = false; reconcile() }
    func shutdown() async {
        started = false
        cancelTask()
        await cleanupTask?.value
        await source.stop()
    }
    func sleep() { suspended = true; reconcile() }
    func wake() {
        suspended = false
        observeStatus(.unavailable)
        restart()
    }

    func observeStatus(_ status: TurboBoostStatus, at date: Date = Date()) {
        observations.append(.init(date: date, status: status))
        prune(at: date)
    }

    func status(at date: Date) -> TurboBoostStatus {
        guard let latest = observations.last(where: { $0.date <= date }),
              date.timeIntervalSince(latest.date) <= Self.statusValidity else { return .unavailable }
        return latest.status
    }

    /// Color only sampled intervals with a recently confirmed state. Split at
    /// observations (including unknown while toggling), never recolor history.
    func bands(from start: Date, to end: Date) -> [CPUFrequencyBand] {
        var result: [CPUFrequencyBand] = []
        for point in samples where point.reading.end >= start && point.reading.start <= end {
            let lo = max(start, point.reading.start)
            let hi = min(end, point.reading.end)
            guard lo < hi else { continue }
            var cuts = [lo, hi]
            for observation in observations {
                for date in [observation.date, observation.date.addingTimeInterval(Self.statusValidity)]
                where date > lo && date < hi { cuts.append(date) }
            }
            cuts.sort()
            for (a, b) in zip(cuts, cuts.dropFirst()) where a < b {
                let state = status(at: a.addingTimeInterval(b.timeIntervalSince(a) / 2))
                if let last = result.last, last.status == state,
                   abs(last.end.timeIntervalSince(a)) < 0.05 {
                    result[result.count - 1] = .init(start: last.start, end: b, status: state)
                } else { result.append(.init(start: a, end: b, status: state)) }
            }
        }
        return result
    }

    /// Also used by deterministic model tests and offscreen previews.
    func accept(_ reading: CPUFrequencyReading, now: Date = Date()) {
        guard reading.isValid,
              reading.end <= now.addingTimeInterval(1),
              now.timeIntervalSince(reading.end) <= Double(interval) + 3,
              reading.end.timeIntervalSince(reading.start) <= Double(interval) * 2,
              current.map({ reading.end > $0.end }) ?? true else { return }
        current = reading
        samplingFailed = false
        prune(at: now)
        guard recordInBackground || historyVisible else { return }
        if let previous = samples.last,
           reading.start.timeIntervalSince(previous.reading.end) > Double(interval) / 2 {
            segment += 1
        }
        samples.append(.init(reading: reading, segment: segment))
        if samples.count > 3602 { samples.removeFirst(samples.count - 3602) }
    }

    private func prune(at date: Date) {
        let cutoff = date.addingTimeInterval(-Self.retention)
        samples.removeAll { $0.reading.end < cutoff }
        // Retain the observation preceding the boundary for band construction.
        if let index = observations.lastIndex(where: { $0.date < cutoff }), index > 0 {
            observations.removeFirst(index)
        }
        if observations.count > 15000 { observations.removeFirst(observations.count - 15000) }
    }

    private var shouldSample: Bool {
        started && helperAvailable && !suspended &&
        (showInMenuBar || recordInBackground || popoverVisible || historyVisible)
    }

    private func restart() {
        cancelTask()
        reconcile()
    }

    private func cancelTask() {
        generation = UUID()
        task?.cancel()
        task = nil
        current = nil
        segment += 1
        isSampling = false
    }

    private func reconcile() {
        guard shouldSample else {
            let wasSampling = task != nil
            cancelTask()
            if wasSampling { cleanupTask = Task { await source.stop() } }
            return
        }
        guard task == nil else { return }
        let id = generation
        let cleanup = cleanupTask
        isSampling = true
        task = Task { [weak self, source] in
            // A rapid close/reopen or sleep/wake must not let an old stop
            // request tear down the newly started sampling process.
            await cleanup?.value
            while !Task.isCancelled {
                guard let self, self.generation == id else { break }
                let seconds = self.interval
                do {
                    let reading = try await source.read(interval: seconds)
                    guard !Task.isCancelled, self.generation == id else { break }
                    guard reading.isValid,
                          reading.end.timeIntervalSince(reading.start) <= Double(seconds) * 2,
                          abs(Date().timeIntervalSince(reading.end)) <= Double(seconds) + 3 else {
                        throw CPUFrequencyTelemetryError.invalidSample
                    }
                    self.accept(reading)
                } catch {
                    guard !Task.isCancelled, self.generation == id else { break }
                    self.current = nil
                    self.samplingFailed = true
                    self.segment += 1
                    // Back off when unsupported or disconnected; do not busy-loop.
                    try? await Task.sleep(for: .seconds(max(seconds, 5)))
                }
            }
        }
    }
}
