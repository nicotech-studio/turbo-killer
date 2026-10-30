import AppKit
import SwiftUI

struct TurboKillerMenuBarLabel: View {
    @ObservedObject var model: TurboKillerModel
    @ObservedObject private var monitor: CPUFrequencyMonitor

    init(model: TurboKillerModel) {
        self.model = model
        self.monitor = model.frequencyMonitor
    }

    var body: some View {
        Image(nsImage: TurboKillerStatusImage.menuBarImage(
            for: model.turboBoostStatus,
            frequency: model.hardware == .intelMac && monitor.showInMenuBar
                ? monitor.current.map { ($0.hertz / 1_000_000_000).formatted(.number.precision(.fractionLength(2))) + " GHz" } ?? "— GHz"
                : nil
        ))
            .accessibilityLabel(Text("TurboKiller"))
            .accessibilityValue(accessibilityDescription)
            .help(Text(statusDescription))
    }

    private var accessibilityDescription: Text {
        var description = Text(statusDescription)
        if model.hardware == .intelMac && monitor.showInMenuBar {
            description = description + Text(verbatim: " · ") + Text("CPU Frequency") + Text(verbatim: ": ")
            description = description + Text(verbatim: monitor.current.map {
                ($0.hertz / 1_000_000_000).formatted(.number.precision(.fractionLength(2))) + " GHz"
            } ?? "— GHz")
        }
        return description
    }

    private var statusDescription: LocalizedStringResource {
        guard model.hardware == .intelMac else {
            return "TurboKiller is designed for Intel Macs only."
        }
        switch model.turboBoostStatus {
        case .enabled: return "Turbo Boost is enabled"
        case .disabled: return "Turbo Boost is disabled"
        case .unavailable: return "Turbo Boost status unavailable"
        }
    }
}

/// One fixed-size, monochrome template image. The wind never moves or mirrors;
/// only the small badge at its physical bottom-right changes with state.
@MainActor
enum TurboKillerStatusImage {
    private static let enabled = makeImage(badge: "bolt.fill")
    private static let disabled = makeImage(badge: "bolt.slash.fill")
    private static let unavailable = makeImage(badge: "questionmark")

    static func image(for status: TurboBoostStatus) -> NSImage {
        switch status {
        case .enabled: enabled
        case .disabled: disabled
        case .unavailable: unavailable
        }
    }

    /// Keep an explicit text size in the native status item at every display
    /// scale, alongside the original 22 × 18 pt icon.
    static func menuBarImage(for status: TurboBoostStatus, frequency: String?) -> NSImage {
        let icon = image(for: status)
        guard let frequency else { return icon }
        let text = NSMutableAttributedString(string: frequency, attributes: [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .regular),
            // A template uses alpha as its mask. Dynamic labelColor can bake
            // reduced opacity into the glyphs, making only the text look gray.
            // The opaque mask lets macOS choose the final menu-bar color.
            .foregroundColor: NSColor.black
        ])
        if let range = frequency.range(of: "GHz") {
            text.addAttribute(.font, value: NSFont.systemFont(ofSize: 10),
                              range: NSRange(range, in: frequency))
        }
        let textSize = text.size()
        let size = NSSize(width: icon.size.width + 4 + ceil(textSize.width), height: icon.size.height)
        let image = NSImage(size: size, flipped: false) { _ in
            icon.draw(at: .zero, from: .zero, operation: .sourceOver, fraction: 1)
            text.draw(at: NSPoint(x: icon.size.width + 4, y: floor((size.height - textSize.height) / 2)))
            return true
        }
        image.isTemplate = true
        return image
    }

    private static func makeImage(badge: String) -> NSImage {
        let size = NSSize(width: 22, height: 18)
        let image = NSImage(size: size, flipped: false) { _ in
            let configuration = NSImage.SymbolConfiguration(
                pointSize: 16, weight: .medium
            )
            NSImage(systemSymbolName: "wind", accessibilityDescription: nil)?
                .withSymbolConfiguration(configuration)?
                .draw(in: NSRect(x: 0, y: 2, width: 18, height: 16))
            let badgeRect = NSRect(x: 11, y: 0, width: 11, height: 11)
            if let badgeImage = NSImage(
                systemSymbolName: badge, accessibilityDescription: nil
            )?.withSymbolConfiguration(NSImage.SymbolConfiguration(
                pointSize: 11, weight: .semibold
            )) {
                // A transparent halo follows the badge's strokes, keeping
                // the underlying wind recognizable without adding a color.
                for dx in [-0.8, 0.0, 0.8] {
                    for dy in [-0.8, 0.0, 0.8] {
                        badgeImage.draw(
                            in: badgeRect.offsetBy(dx: dx, dy: dy), from: .zero,
                            operation: .destinationOut, fraction: 1
                        )
                    }
                }
                badgeImage.draw(in: badgeRect)
            }
            return true
        }
        image.isTemplate = true
        return image
    }
}
