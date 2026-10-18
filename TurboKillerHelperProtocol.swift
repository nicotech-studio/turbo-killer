import Foundation

nonisolated enum TurboKillerHelperCompatibility {
    // Older helpers verified only the executable and would retain incomplete
    // installations. Force the existing repair flow to replace those helpers.
    static let version = "complete-kext-bundle-v1"
}

@objc protocol TurboKillerHelperProtocol {
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
