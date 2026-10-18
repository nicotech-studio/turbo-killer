# TurboKiller

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Português (Portugal)](README.pt-PT.md) | [Italiano](README.it.md) | [Русский](README.ru.md) | [Türkçe](README.tr.md) | [Bahasa Indonesia](README.id.md) | [Tiếng Việt](README.vi.md) | [العربية](README.ar.md) | [עברית](README.he.md)

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

To update, quit the old App before replacing it in Applications.

## Use

- Choose **Disable Turbo Boost** from the menu bar when you prefer lower heat and fan noise.
- Choose **Restore Turbo Boost** when you need full performance again.
- Check the displayed status after an operation. If it reports an error, do not repeatedly click the switch.

The App and its background helper are Developer ID signed, but this release is **not Apple-notarized**. Download only from the official repository and keep SIP enabled.

## Release notes · 1.2.0

- A fixed wind icon with a monochrome badge shows whether Turbo Boost is enabled, disabled, or its state is unknown.
- A compact popover focuses on status and control. Unsupported Macs show an explanation instead; Settings and Quit remain available.
- 17 localizations across the app, website, README and these notes, including Arabic and Hebrew with right-to-left layouts.
- Status refreshes at launch, on wake, after operations and periodically in the background.

[Release notes](docs/releases/1.2.0/en.md)

## Feedback

If it does not work on your Mac, [open an issue](https://github.com/nicotech-studio/turbo-killer/issues) with your Mac model, macOS version and the complete error or a screenshot. Successful compatibility reports are welcome too.

## For developers

The SwiftUI menu bar App communicates with a privileged background helper over XPC. The helper loads or unloads a bundled legacy kernel extension to control Turbo Boost. The displayed state comes from the system's actual loaded-extension state, and the full extension bundle is checked with SHA-256.

Open `TurboKiller.xcodeproj` in Xcode to build. Preserve the historical extension bundle unchanged; see [bundle integrity and tests](LegacyKextIntegrity.swift) for the required files and packaging checks.

## Support

If TurboKiller is useful to you, you can support its development:

<a href="https://ko-fi.com/hello_nico_chan"><img src="https://storage.ko-fi.com/cdn/kofi3.png?v=3" height="36" alt="Support me on Ko-fi"></a>

## License

[GPL-2.0](LICENSE). See [third-party notices](THIRD_PARTY_NOTICES.md) for bundled components. Modified builds should clearly identify themselves and not imply that they are official TurboKiller releases.
