//
//  ContentView.swift
//  TurboKiller
//
//  Created by NicoTech Studio on 2026/9/16.
//

import AppKit
import SwiftUI

@MainActor
struct ContentView: View {
    @ObservedObject var model: TurboKillerModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if model.hardware == .intelMac {
                HStack(spacing: 10) {
                    Image(systemName: statusIcon)

                    Text(statusTitle)
                        .font(.subheadline.weight(.medium))
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let requiredAction = model.requiredAction {
                    requiredActionView(requiredAction)
                }

                if let errorMessage = model.errorMessage ?? model.statusReadError {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)

                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.red.opacity(0.08))
                    )
                }

                Button {
                    Task {
                        await model.toggleTurboBoost()
                    }
                } label: {
                    HStack {
                        if model.isBusy {
                            ProgressView()
                                .controlSize(.small)

                            Text("Working…")
                        } else {
                            Image(systemName: toggleIcon)
                            Text(toggleTitle)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .fixedSize(horizontal: false, vertical: true)
                .disabled(
                    model.turboBoostStatus == .unavailable ||
                    model.isBusy ||
                    model.isRefreshing ||
                    !model.helperReady
                )

            } else {
                Label {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("TurboKiller is designed for Intel Macs only.")
                            .font(.subheadline.weight(.medium))
                        Text("Turbo Boost control is only available on supported Intel Macs.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "info.circle")
                }
                .fixedSize(horizontal: false, vertical: true)
            }

            Divider()

            HStack {
                if #available(macOS 14.0, *) {
                    SettingsLink {
                        Label("Settings…", systemImage: "gearshape")
                    }
                    .keyboardShortcut(",", modifiers: .command)
                } else {
                    Button {
                        NSApp.sendAction(
                            Selector(("showSettingsWindow:")),
                            to: nil,
                            from: nil
                        )
                    } label: {
                        Label("Settings…", systemImage: "gearshape")
                    }
                    .keyboardShortcut(",", modifiers: .command)
                }

                Spacer()

                Button("Quit TurboKiller") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
        }
        .padding(16)
        .frame(width: 340)

    }

    // MARK: - Required actions

    @ViewBuilder
    private func requiredActionView(
        _ action: TurboKillerRequiredAction
    ) -> some View {
        switch action {
        case .approvePrivilegedHelper:
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "gearshape.2.fill")
                        .foregroundStyle(.orange)

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Background helper approval required")
                            .font(.caption.weight(.semibold))

                        Text(
                            "TurboKiller needs permission to run its privileged helper in the background. Allow TurboKiller in System Settings, then return here."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }

                HStack {
                    Button("Open System Settings") {
                        TurboKillerHelperManager.openSystemSettings()
                    }

                    Button("Check Again") {
                        Task {
                            await model.prepareHelper()
                        }
                    }
                }
                .controlSize(.small)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.orange.opacity(0.08))
            )
        case .approveKernelExtension:
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "lock.shield.fill")
                        .foregroundStyle(.orange)

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Approval required")
                            .font(.caption.weight(.semibold))

                        Text(
                            "macOS blocked the Turbo Boost kernel extension. Open System Settings → Privacy & Security and allow it, then try again."
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }

                Button("Open System Settings") {
                    openSystemSettings()
                }
                .controlSize(.small)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.orange.opacity(0.08))
            )

        case .restartRequired:
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "restart.circle.fill")
                    .foregroundStyle(.orange)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Restart required")
                        .font(.caption.weight(.semibold))

                    Text(
                        "macOS has approved the kernel extension, but your Mac must be restarted once before TurboKiller can use it."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.orange.opacity(0.08))
            )
        }
    }

    private func openSystemSettings() {
        let settingsURL = URL(
            fileURLWithPath: "/System/Applications/System Settings.app"
        )

        NSWorkspace.shared.open(settingsURL)
    }

    // MARK: - Turbo Boost status

    private var statusIcon: String {
        switch model.turboBoostStatus {
        case .unavailable:
            "questionmark.circle"

        case .enabled:
            "bolt.circle.fill"

        case .disabled:
            "bolt.slash.circle.fill"
        }
    }

    private var statusTitle: LocalizedStringResource {
        switch model.turboBoostStatus {
        case .unavailable:
            "Turbo Boost status unavailable"

        case .enabled:
            "Turbo Boost is enabled"

        case .disabled:
            "Turbo Boost is disabled"
        }
    }

    // MARK: - Toggle button

    private var toggleTitle: LocalizedStringResource {
        model.turboBoostStatus == .disabled
            ? "Restore Turbo Boost"
            : "Kill Turbo Boost"
    }

    private var toggleIcon: String {
        model.turboBoostStatus == .disabled
            ? "bolt.fill"
            : "bolt.slash.fill"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: TurboKillerModel())
    }
}
