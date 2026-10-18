import Foundation

/// Standalone regression suite; no root privileges or Kext loading required.
@main
struct LegacyKextIntegrityTests {
    static func main() throws {
        guard CommandLine.arguments.count == 2 else {
            fatalError("Pass the path to the complete historical Kext bundle.")
        }
        let source = URL(fileURLWithPath: CommandLine.arguments[1])
        try LegacyKextIntegrity.verify(at: source)
        let manager = FileManager.default
        let temporary = manager.temporaryDirectory
            .appendingPathComponent("TurboKillerIntegrityTests-\(UUID().uuidString)")
        try manager.createDirectory(at: temporary, withIntermediateDirectories: false)
        defer { try? manager.removeItem(at: temporary) }
        var count = 0

        func test(
            _ name: String,
            valid: Bool = false,
            mutate: (URL) throws -> Void
        ) throws {
            let fixture = temporary.appendingPathComponent(name + ".kext")
            try manager.copyItem(at: source, to: fixture)
            try mutate(fixture)
            guard LegacyKextIntegrity.isValid(at: fixture) == valid else {
                fatalError("FAIL: \(name)")
            }
            count += 1
            print("PASS: \(name)")
        }

        try test("complete-bundle", valid: true) { _ in }
        for path in LegacyKextIntegrity.expectedFiles.keys.sorted() {
            try test("missing-" + path.replacingOccurrences(of: "/", with: "-")) { fixture in
                try manager.removeItem(at: fixture.appendingPathComponent(path))
            }
            try test("modified-" + path.replacingOccurrences(of: "/", with: "-")) { fixture in
                let url = fixture.appendingPathComponent(path)
                var bytes = try Data(contentsOf: url)
                bytes.append(0)
                try bytes.write(to: url)
            }
        }
        try test("extra-file") { fixture in
            try Data("unexpected".utf8).write(to: fixture.appendingPathComponent("Contents/extra"))
        }
        try test("extra-directory") { fixture in
            try manager.createDirectory(at: fixture.appendingPathComponent("Contents/extra"), withIntermediateDirectories: false)
        }
        try test("symlink-file") { fixture in
            let path = "Contents/Info.plist~"
            let url = fixture.appendingPathComponent(path)
            try manager.removeItem(at: url)
            try manager.createSymbolicLink(at: url, withDestinationURL: source.appendingPathComponent(path))
        }
        try test("symlink-directory") { fixture in
            let path = "Contents/MacOS"
            let url = fixture.appendingPathComponent(path)
            try manager.removeItem(at: url)
            try manager.createSymbolicLink(at: url, withDestinationURL: source.appendingPathComponent(path))
        }
        let rootLink = temporary.appendingPathComponent("root-link.kext")
        try manager.createSymbolicLink(at: rootLink, withDestinationURL: source)
        precondition(!LegacyKextIntegrity.isValid(at: rootLink), "Root symlink must be rejected")
        count += 1
        print("PASS: symlink-root")
        precondition(!LegacyKextIntegrity.isValid(at: temporary.appendingPathComponent("missing.kext")))
        count += 1
        print("PASS: missing-bundle")
        print("All \(count) integrity regression checks passed.")
    }
}
