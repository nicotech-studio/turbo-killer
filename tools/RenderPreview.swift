import AppKit
import SwiftUI

@main
struct RenderTurboKiller {
    @MainActor
    static func main() async throws {
        let output = URL(fileURLWithPath: CommandLine.arguments[1])
        try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
        let state: TurboBoostStatus = .disabled
        let model = TurboKillerModel(hardware: .intelMac, controller: PreviewController(state: state), helperReady: true)
        await model.refreshStatus()
        let language = Bundle.main.preferredLocalizations.first ?? "en"
        let direction: LayoutDirection = ["ar", "he"].contains(language) ? .rightToLeft : .leftToRight
        let view = ContentView(model: model)
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .dark)
        save(view, to: output.appendingPathComponent("app.png"))
        let unsupported = TurboKillerModel(hardware: .appleSilicon, controller: PreviewController(state: .unavailable))
        save(ContentView(model: unsupported)
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .dark), to: output.appendingPathComponent("unsupported.png"))
        save(SettingsView()
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .dark), to: output.appendingPathComponent("settings.png"))
        let images: [TurboBoostStatus] = [.enabled, .disabled, .unavailable]
        for (index, status) in images.enumerated() {
            let img = TurboKillerStatusImage.image(for: status)
            let rep = NSBitmapImageRep(data: img.tiffRepresentation!)!
            try rep.representation(using: .png, properties: [:])!.write(to: output.appendingPathComponent("icon-\(index).png"))
        }
    }

    @MainActor
    static func save<V: View>(_ view: V, to url: URL) {
        let hosting = NSHostingView(rootView: view.padding(0).background(Color(nsColor: .windowBackgroundColor)))
        let size = hosting.fittingSize
        let window = NSWindow(contentRect: NSRect(origin: .zero, size: size), styleMask: [.borderless], backing: .buffered, defer: false)
        window.contentView = hosting
        window.appearance = NSAppearance(named: .darkAqua)
        hosting.frame = NSRect(origin: .zero, size: size)
        window.displayIfNeeded()
        hosting.layoutSubtreeIfNeeded()
        let rep = hosting.bitmapImageRepForCachingDisplay(in: hosting.bounds)!
        hosting.cacheDisplay(in: hosting.bounds, to: rep)
        try! rep.representation(using: .png, properties: [:])!.write(to: url)
    }
}

struct PreviewController: TurboBoostControlling {
    let state: TurboBoostStatus
    func currentStatus() async throws -> TurboBoostStatus { state }
    func setTurboBoostEnabled(_ enabled: Bool) async throws {}
}
