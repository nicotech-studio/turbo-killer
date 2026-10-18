import AppKit
import SwiftUI

struct TurboKillerMenuBarLabel: View {
    @ObservedObject var model: TurboKillerModel

    var body: some View {
        Image(nsImage: TurboKillerStatusImage.image(for: model.turboBoostStatus))
            .accessibilityLabel(Text("TurboKiller"))
            .accessibilityValue(Text(statusDescription))
            .help(Text(statusDescription))
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
