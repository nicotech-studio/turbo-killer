import Foundation

nonisolated enum TurboKillerHelperCompatibility {
    // Force repair of older helpers before invoking the telemetry selectors.
    static let version = "cpu-frequency-v2"
}

@objc protocol TurboKillerHelperProtocol {
    func readCPUFrequency(
        intervalMilliseconds: NSNumber,
        withReply reply: @escaping (NSNumber, String) -> Void
    )

    func stopCPUFrequency(withReply reply: @escaping (NSNumber, String) -> Void)

    func healthCheck(
        withReply reply: @escaping (NSNumber, String) -> Void
    )

    func prepareTurboBoostKext(
        withReply reply: @escaping (NSNumber, String) -> Void
    )

    func loadTurboBoostKext(
        withReply reply: @escaping (NSNumber, String) -> Void
    )

    func unloadTurboBoostKext(
        withReply reply: @escaping (NSNumber, String) -> Void
    )
}
