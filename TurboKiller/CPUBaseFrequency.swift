import Darwin
import Foundation

/// The Intel brand string contains the advertised nominal frequency on many
/// Intel Macs. Confirm it against the system's static clock information rather
/// than assuming a deprecated hw.cpufrequency reading is always a base clock.
nonisolated enum CPUBaseFrequency {
    static var current: Double? {
        #if arch(x86_64)
        var hertz: UInt64 = 0
        var size = MemoryLayout<UInt64>.size
        guard sysctlbyname("hw.cpufrequency", &hertz, &size, nil, 0) == 0,
              size == MemoryLayout<UInt64>.size else { return nil }
        var brandSize = 0
        guard sysctlbyname("machdep.cpu.brand_string", nil, &brandSize, nil, 0) == 0,
              brandSize > 0, brandSize <= 4096 else { return nil }
        var brand = [CChar](repeating: 0, count: brandSize)
        let result = brand.withUnsafeMutableBytes {
            sysctlbyname("machdep.cpu.brand_string", $0.baseAddress, &brandSize, nil, 0)
        }
        guard result == 0, brand.last == 0 else { return nil }
        return nominalHertz(brandString: String(cString: brand), reportedHertz: Double(hertz))
        #else
        return nil
        #endif
    }

    static func nominalHertz(brandString: String, reportedHertz: Double) -> Double? {
        guard brandString.hasPrefix("Intel"), reportedHertz.isFinite, reportedHertz > 0,
              let expression = try? NSRegularExpression(
                pattern: #"@\s*([0-9]+(?:\.[0-9]+)?)\s*(GHz|MHz)\s*$"#,
                options: .caseInsensitive),
              let match = expression.firstMatch(in: brandString,
                range: NSRange(brandString.startIndex..., in: brandString)),
              let valueRange = Range(match.range(at: 1), in: brandString),
              let unitRange = Range(match.range(at: 2), in: brandString),
              let value = Double(brandString[valueRange]) else { return nil }
        let hertz = value * (brandString[unitRange].lowercased() == "ghz" ? 1e9 : 1e6)
        guard hertz >= 100_000_000, hertz < 20_000_000_000,
              abs(hertz - reportedHertz) <= max(10_000_000, hertz * 0.005) else { return nil }
        return hertz
    }
}
