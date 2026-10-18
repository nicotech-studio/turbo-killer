import AppKit
import SwiftUI

@main
struct TurboKillerApp: App {
    @NSApplicationDelegateAdaptor(TurboKillerAppDelegate.self) private var delegate

    var body: some Scene {
        MenuBarExtra {
            ContentView(model: delegate.model)
                .task {
                    await delegate.model.refreshStatus()
                    if delegate.model.hardware == .intelMac {
                        await delegate.model.prepareHelper()
                    }
                }
        } label: {
            TurboKillerMenuBarLabel(model: delegate.model)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
        }
    }
}

@MainActor
final class TurboKillerAppDelegate: NSObject, NSApplicationDelegate {
    let model = TurboKillerModel()

    func applicationDidFinishLaunching(_ notification: Notification) {
        model.startMonitoring()
    }

    func applicationWillTerminate(_ notification: Notification) {
        model.stopMonitoring()
    }
}
