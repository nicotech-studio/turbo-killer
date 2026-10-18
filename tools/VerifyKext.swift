import Foundation

@main
struct VerifyKext {
    static func main() throws {
        guard CommandLine.arguments.count == 2 else {
            throw NSError(domain: "VerifyKext", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Usage: verify-kext /path/to/DisableTurboBoost.64bits.kext"
            ])
        }

        let url = URL(fileURLWithPath: CommandLine.arguments[1])
        try LegacyKextIntegrity.verify(at: url)
        print("Historical Kext bundle verified: \(url.path)")
    }
}
