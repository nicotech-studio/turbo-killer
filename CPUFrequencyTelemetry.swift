import Foundation
import CoreFoundation

/// Intel powermetrics' processor-wide average execution frequency, in Hz.
/// This is an interval average, not the nominal clock or a per-core maximum.
nonisolated struct CPUFrequencyReading: Codable, Equatable, Sendable {
    let start: Date
    let end: Date
    let hertz: Double

    static func parse(plist data: Data, endingAt end: Date) throws -> Self {
        guard let root = try PropertyListSerialization.propertyList(
            from: data, format: nil
        ) as? [String: Any],
              let processor = root["processor"] as? [String: Any],
              let frequency = processor["freq_hz"] as? NSNumber,
              let elapsed = root["elapsed_ns"] as? NSNumber,
              CFGetTypeID(frequency) != CFBooleanGetTypeID(),
              CFGetTypeID(elapsed) != CFBooleanGetTypeID()
        else { throw CPUFrequencyTelemetryError.invalidSample }
        let seconds = elapsed.doubleValue / 1_000_000_000
        let reading = Self(start: end.addingTimeInterval(-seconds), end: end,
                           hertz: frequency.doubleValue)
        guard reading.isValid else { throw CPUFrequencyTelemetryError.invalidSample }
        return reading
    }

    var isValid: Bool {
        hertz.isFinite && hertz > 0 && hertz < 20_000_000_000 &&
        start.timeIntervalSince1970.isFinite && end.timeIntervalSince1970.isFinite &&
        end > start && end.timeIntervalSince(start) <= 60
    }
}

nonisolated enum CPUFrequencyTelemetryError: Error {
    case invalidSample
    case oversizedOutput
}

/// `powermetrics -f plist` emits NUL-separated property lists; pipe reads may
/// split a frame anywhere or contain several frames at once.
nonisolated struct CPUFrequencyPlistStream {
    private var buffer = Data()
    static let maximumFrameSize = 1_048_576

    mutating func append(_ data: Data) throws -> [Data] {
        buffer.append(data)
        var frames: [Data] = []
        while let separator = buffer.firstIndex(of: 0) {
            let frame = Data(buffer[..<separator])
            guard frame.count <= Self.maximumFrameSize else {
                throw CPUFrequencyTelemetryError.oversizedOutput
            }
            if !frame.isEmpty { frames.append(frame) }
            buffer.removeSubrange(...separator)
        }
        guard buffer.count <= Self.maximumFrameSize else {
            throw CPUFrequencyTelemetryError.oversizedOutput
        }
        return frames
    }
}
