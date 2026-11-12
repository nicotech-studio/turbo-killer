# TurboKiller

[English](README.md) | [简体中文](docs/readme/zh-CN.md) | [繁體中文](docs/readme/zh-TW.md) | [日本語](docs/readme/ja.md) | [한국어](docs/readme/ko.md) | [Deutsch](docs/readme/de.md) | [Français](docs/readme/fr.md) | [Español](docs/readme/es.md) | [Português (Brasil)](docs/readme/pt-BR.md) | [Português (Portugal)](docs/readme/pt-PT.md) | [Italiano](docs/readme/it.md) | [Русский](docs/readme/ru.md) | [Türkçe](docs/readme/tr.md) | [Bahasa Indonesia](docs/readme/id.md) | [Tiếng Việt](docs/readme/vi.md) | [العربية](docs/readme/ar.md) | [עברית](docs/readme/he.md)

[![Latest release](https://img.shields.io/github/v/release/nicotech-studio/turbo-killer?display_name=tag&sort=semver&style=flat-square)](https://github.com/nicotech-studio/turbo-killer/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/nicotech-studio/turbo-killer/total?style=flat-square)](https://github.com/nicotech-studio/turbo-killer/releases)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-000000?style=flat-square&logo=apple&logoColor=white)
![Intel Mac](https://img.shields.io/badge/Mac-Intel-0071C5?style=flat-square&logo=intel&logoColor=white)
[![GPL-2.0](https://img.shields.io/github/license/nicotech-studio/turbo-killer?style=flat-square)](LICENSE)

TurboKiller is a free, open-source menu bar app for Intel Macs.

Turn off Turbo Boost when you want a quieter, cooler Mac, and turn it back on when you need full performance. Disabling it can reduce performance on demanding tasks.

## Download and requirements

[Download the latest release](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [Website](https://turbokiller.nicotech.cc)

- Intel Mac with macOS 13 or later. Apple silicon is not supported.
- No need to disable System Integrity Protection (SIP).
- Still experimental: tested on some Intel Macs, but not guaranteed on every configuration.

## Install

1. Open the downloaded DMG and drag TurboKiller to Applications.
2. Open TurboKiller. If macOS blocks it, go to **System Settings → Privacy & Security → Open Anyway**.
3. If prompted, allow TurboKiller to run in the background under **General → Login Items & Extensions**.
4. Follow any additional system-extension approval or restart prompts.

To check for updates, open **Settings → About → Check for Updates…**.

## Use

- Choose **Disable Turbo Boost** from the menu bar when you prefer lower heat and fan noise.
- Choose **Restore Turbo Boost** when you need full performance again.
- Check the displayed status after an operation. If it reports an error, do not repeatedly click the switch.

The App and its background helper are Developer ID signed, but this release is **not Apple-notarized**. Download only from the official repository and keep SIP enabled.

## Release notes · 1.3.1

- Check for updates automatically or from Settings. When an update is available, review the release notes and install it in the App.

[Release notes](docs/releases/1.3.1.md)

## Release notes · 1.3.0

- See the latest sample-average CPU frequency in the menu bar and compact popover.
- View the last 5 minutes, 15 minutes or hour, with pale red/blue backgrounds showing Turbo Boost enabled/disabled and a base-frequency reference when reliably detected.
- Choose 1, 2, 5 or 10-second sampling (default 2). Settings also control the menu bar number and background history recording.
- Keep up to one hour of history in memory for the current session. Sleep, pauses and missing data leave gaps.

[Release notes](docs/releases/1.3.0/en.md)

## Feedback

If it does not work on your Mac, [open an issue](https://github.com/nicotech-studio/turbo-killer/issues) with your Mac model, macOS version and the complete error or a screenshot. Successful compatibility reports are welcome too.

## For developers

The SwiftUI menu bar App communicates with a privileged background helper over XPC. The helper loads or unloads a bundled legacy kernel extension to control Turbo Boost. The displayed state comes from the system's actual loaded-extension state, and the full extension bundle is checked with SHA-256.

Open `TurboKiller.xcodeproj` in Xcode to build. Preserve the historical extension bundle unchanged; see [bundle integrity and tests](LegacyKextIntegrity.swift) for the required files and packaging checks.

To prepare a release, see [building and publishing updates](docs/development/updates.md).

## Support

If TurboKiller is useful to you, you can support its development:

<a href="https://ko-fi.com/hello_nico_chan"><img src="https://storage.ko-fi.com/cdn/kofi3.png?v=3" height="36" alt="Support me on Ko-fi"></a>

## License

[GPL-2.0](LICENSE). See [third-party notices](THIRD_PARTY_NOTICES.md) for bundled components. Modified builds should clearly identify themselves and not imply that they are official TurboKiller releases.
