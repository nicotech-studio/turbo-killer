import AppKit
import Combine
import Sparkle
import SwiftUI

@main
struct TurboKillerApp: App {
    @NSApplicationDelegateAdaptor(TurboKillerAppDelegate.self) private var delegate

    var body: some Scene {
        MenuBarExtra {
            ContentView(model: delegate.model)
                .task {
                    await delegate.model.refreshStatus()
                    if delegate.model.hardware == .intelMac && !delegate.model.helperReady {
                        await delegate.model.prepareHelper()
                    }
                }
        } label: {
            TurboKillerMenuBarLabel(model: delegate.model)
        }
        .menuBarExtraStyle(.window)

        Settings {
            let updater = delegate.updaterController.updater
            SettingsView(
                monitor: delegate.model.frequencyMonitor,
                checkForUpdates: AnyView(CheckForUpdatesButton(updater: updater)),
                automaticUpdateChecks: AnyView(AutomaticUpdateChecksToggle(updater: updater))
            )
        }
    }
}

@MainActor
final class TurboKillerAppDelegate: NSObject, NSApplicationDelegate {
    let model = TurboKillerModel()
    let updaterController = SPUStandardUpdaterController(
        startingUpdater: false,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )

    func applicationDidFinishLaunching(_ notification: Notification) {
        updaterController.startUpdater()
        model.startMonitoring()
        Task { await model.connectExistingHelper() }
    }

    func applicationWillTerminate(_ notification: Notification) {
        model.stopMonitoring()
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        model.stopMonitoring()
        Task {
            await model.frequencyMonitor.shutdown()
            sender.reply(toApplicationShouldTerminate: true)
        }
        return .terminateLater
    }
}

private struct CheckForUpdatesButton: View {
    let updater: SPUUpdater
    @State private var canCheck = false

    var body: some View {
        Button("Check for Updates…", action: updater.checkForUpdates)
            .disabled(!canCheck)
            .onReceive(updater.publisher(for: \.canCheckForUpdates)) { canCheck = $0 }
    }
}

private struct AutomaticUpdateChecksToggle: View {
    let updater: SPUUpdater
    @State private var automaticallyChecks: Bool

    init(updater: SPUUpdater) {
        self.updater = updater
        _automaticallyChecks = State(initialValue: updater.automaticallyChecksForUpdates)
    }

    var body: some View {
        Toggle("Automatically check for updates", isOn: $automaticallyChecks)
            .onChange(of: automaticallyChecks) { updater.automaticallyChecksForUpdates = $0 }
    }
}
