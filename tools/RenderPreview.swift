import AppKit
import SwiftUI

@main
struct RenderTurboKiller {
    @MainActor
    static func main() async throws {
        let output = URL(fileURLWithPath: CommandLine.arguments[1])
        try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
        let state: TurboBoostStatus = .disabled
        let suite = "cc.nicotech.TurboKiller.FrequencyPreview.\(UUID())"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        let monitor = CPUFrequencyMonitor(defaults: defaults, source: PreviewFrequencySource(), baseFrequencyHertz: 2_600_000_000)
        let model = TurboKillerModel(hardware: .intelMac, controller: PreviewController(state: state), helperReady: true,
                                    frequencyMonitor: monitor)
        monitor.start()
        await model.refreshStatus()
        let now = Date()
        for index in 0..<450 {
            let end = now.addingTimeInterval(Double(index - 449) * 2)
            if index % 15 == 0 {
                model.frequencyMonitor.observeStatus(index < 225 ? .enabled : .disabled,
                    at: end.addingTimeInterval(-2))
            }
            let ghz = index < 225 ? 3.0 + sin(Double(index) * 0.3) * 0.4 : 2.1 + sin(Double(index) * 0.2) * 0.3
            model.frequencyMonitor.accept(.init(start: end.addingTimeInterval(-2), end: end, hertz: ghz * 1e9), now: end)
        }
        let language = Bundle.main.preferredLocalizations.first ?? "en"
        let direction: LayoutDirection = ["ar", "he"].contains(language) ? .rightToLeft : .leftToRight
        let view = ContentView(model: model)
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .dark)
        save(view, to: output.appendingPathComponent("app.png"))
        save(ContentView(model: model)
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .light), to: output.appendingPathComponent("app-light.png"), appearance: .aqua)
        save(TurboKillerMenuBarLabel(model: model).padding(.horizontal, 8).padding(.vertical, 2)
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .light), to: output.appendingPathComponent("menu-bar-light.png"), appearance: .aqua)
        let unsupported = TurboKillerModel(hardware: .appleSilicon, controller: PreviewController(state: .unavailable))
        save(ContentView(model: unsupported)
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .dark), to: output.appendingPathComponent("unsupported.png"))
        save(SettingsView(monitor: model.frequencyMonitor)
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .dark), to: output.appendingPathComponent("settings.png"))
        save(FrequencySettingsView(monitor: model.frequencyMonitor)
            .frame(width: 520, height: 430)
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .dark), to: output.appendingPathComponent("monitoring-settings.png"))
        save(FrequencyHistoryView(monitor: model.frequencyMonitor)
            .frame(width: 700, height: 390)
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .dark), to: output.appendingPathComponent("frequency-history.png"))
        save(FrequencyHistoryView(monitor: model.frequencyMonitor)
            .frame(width: 700, height: 390)
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .light), to: output.appendingPathComponent("frequency-history-light.png"), appearance: .aqua)
        save(FrequencyHistoryView(monitor: model.frequencyMonitor)
            .frame(width: 540, height: 390)
            .environment(\.locale, Locale(identifier: language))
            .environment(\.layoutDirection, direction)
            .environment(\.colorScheme, .light), to: output.appendingPathComponent("frequency-history-narrow.png"), appearance: .aqua)
        let images: [TurboBoostStatus] = [.enabled, .disabled, .unavailable]
        for (index, status) in images.enumerated() {
            let img = TurboKillerStatusImage.image(for: status)
            let rep = NSBitmapImageRep(data: img.tiffRepresentation!)!
            try rep.representation(using: .png, properties: [:])!.write(to: output.appendingPathComponent("icon-\(index).png"))
        }
    }

    @MainActor
    static func save<V: View>(_ view: V, to url: URL, appearance: NSAppearance.Name = .darkAqua) {
        let hosting = NSHostingView(rootView: view.padding(0)
            .environment(\.controlActiveState, .active)
            .background(Color(nsColor: .windowBackgroundColor)))
        let size = hosting.fittingSize
        let window = NSWindow(contentRect: NSRect(origin: .zero, size: size), styleMask: [.borderless], backing: .buffered, defer: false)
        window.contentView = hosting
        window.appearance = NSAppearance(named: appearance)
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

struct PreviewFrequencySource: CPUFrequencyReadingSource {
    func read(interval: Int) async throws -> CPUFrequencyReading {
        try await Task.sleep(for: .seconds(86400))
        throw CancellationError()
    }
    func stop() async {}
}
