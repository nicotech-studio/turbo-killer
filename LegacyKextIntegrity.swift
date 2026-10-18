import CryptoKit
import Foundation

/// The signature exception applies to the complete historical bundle, not just
/// its executable. In particular, Info.plist~ is NOT disposable editor debris:
/// omitting it changes the ad-hoc CDHash from f5b755... to b39ac3... and causes
/// Bad code signature on the tested macOS 15 system.
nonisolated enum LegacyKextIntegrity {
    static let expectedFiles: [String: String] = [
        "Contents/MacOS/DisableTurboBoost":
            "f81f003ccd5827122a41c39bddb78e4ffff37d84718a647dbd5fc3c6a92f987c",
        "Contents/Info.plist":
            "1de21bfa5521f32055f6b91a56552aa062e412ba517f9968a9bd2076cc1eee28",
        "Contents/Info.plist~":
            "a8aac919a47fb74339ac09366161efb90cc22dba0926d23413bd0ec615ffff06"
    ]

    private static let expectedDirectories: Set<String> = [
        "Contents", "Contents/MacOS"
    ]

    enum VerificationError: LocalizedError {
        case invalidEntry(String)
        case missingEntries

        var errorDescription: String? {
            switch self {
            case .invalidEntry(let path):
                return "Historical Kext integrity check failed: \(path)"
            case .missingEntries:
                return "Historical Kext bundle is incomplete."
            }
        }
    }

    static func isValid(at bundleURL: URL) -> Bool {
        do {
            try verify(at: bundleURL)
            return true
        } catch {
            return false
        }
    }

    /// Reject missing/modified/extra files and symlinks. Checking only the
    /// executable would also incorrectly reuse a pre-fix installation.
    static func verify(at bundleURL: URL) throws {
        let manager = FileManager.default
        let attributes = try manager.attributesOfItem(atPath: bundleURL.path)
        guard attributes[.type] as? FileAttributeType == .typeDirectory else {
            throw VerificationError.invalidEntry(bundleURL.path)
        }

        // Enumerate each level explicitly so unreadable directories throw,
        // rather than silently skipping entries during recursive enumeration.
        var pending = [""]
        var seenFiles = Set<String>()
        var seenDirectories = Set<String>()

        while let directory = pending.popLast() {
            let directoryURL = directory.isEmpty
                ? bundleURL
                : bundleURL.appendingPathComponent(directory)

            for name in try manager.contentsOfDirectory(atPath: directoryURL.path) {
                let path = directory.isEmpty ? name : "\(directory)/\(name)"
                let url = bundleURL.appendingPathComponent(path)
                let attributes = try manager.attributesOfItem(atPath: url.path)
                let type = attributes[.type] as? FileAttributeType

                if type == .typeDirectory, expectedDirectories.contains(path) {
                    seenDirectories.insert(path)
                    pending.append(path)
                } else if type == .typeRegular, let expectedHash = expectedFiles[path] {
                    let hash = SHA256.hash(data: try Data(contentsOf: url))
                        .map { String(format: "%02x", $0) }
                        .joined()
                    guard hash == expectedHash else {
                        throw VerificationError.invalidEntry(path)
                    }
                    seenFiles.insert(path)
                } else {
                    throw VerificationError.invalidEntry(path)
                }
            }
        }

        guard seenFiles == Set(expectedFiles.keys),
              seenDirectories == expectedDirectories else {
            throw VerificationError.missingEntries
        }
    }
}
