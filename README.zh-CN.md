# TurboKiller

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Português (Portugal)](README.pt-PT.md) | [Italiano](README.it.md) | [Русский](README.ru.md) | [Türkçe](README.tr.md) | [Bahasa Indonesia](README.id.md) | [Tiếng Việt](README.vi.md) | [العربية](README.ar.md) | [עברית](README.he.md)

[![最新版本](https://img.shields.io/github/v/release/nicotech-studio/turbo-killer?display_name=tag&sort=semver&style=flat-square)](https://github.com/nicotech-studio/turbo-killer/releases/latest)
[![下载量](https://img.shields.io/github/downloads/nicotech-studio/turbo-killer/total?style=flat-square)](https://github.com/nicotech-studio/turbo-killer/releases)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-000000?style=flat-square&logo=apple&logoColor=white)
![Intel Mac](https://img.shields.io/badge/Mac-Intel-0071C5?style=flat-square&logo=intel&logoColor=white)
[![GPL-2.0](https://img.shields.io/github/license/nicotech-studio/turbo-killer?style=flat-square)](LICENSE)

TurboKiller 是一款面向 Intel Mac 的免费开源菜单栏工具。

希望电脑更安静、温度更低时，关闭 Turbo Boost；需要完整性能时，再一键恢复。关闭后，较重任务的运行速度可能下降。

## 下载与系统要求

[下载最新版本](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [官网](https://turbokiller.nicotech.cc)

- Intel Mac，macOS 13 或更高版本。不支持 Apple 芯片。
- 无需关闭系统完整性保护（SIP）。
- 目前仍处于实验阶段，已在部分 Intel Mac 上验证，不保证所有配置兼容。

## 安装

1. 打开下载的 DMG，将 TurboKiller 拖入“应用程序”。
2. 打开 TurboKiller。如被 macOS 拦截，前往 **系统设置 → 隐私与安全性 → 仍要打开**。
3. 如有提示，在 **通用 → 登录项与扩展** 中允许 TurboKiller 在后台运行。
4. 如系统还要求批准扩展或重启，请按提示操作。

升级时，先退出旧 App，再替换“应用程序”中的副本。

## 使用

- 希望降低发热和风扇噪音时，在菜单栏选择 **关闭 Turbo Boost**。
- 需要完整性能时，选择 **恢复 Turbo Boost**。
- 操作后确认界面状态。如有报错，不要连续点击开关。

App 和后台组件已使用 Developer ID 签名，但当前版本 **未通过 Apple 公证**。请仅从官方仓库下载，并保持 SIP 开启。

## 发布说明 · 1.2.0

- 菜单栏保留固定风形图标，通过单色角标区分 Turbo Boost 已开启、已关闭和状态未知。
- 精简弹窗，聚焦状态与操作；不支持的 Mac 改为显示说明，底部始终保留设置和退出。
- App、官网、README 和本版本说明共支持 17 个本地化版本，包含从右到左布局的阿拉伯语和希伯来语。
- 启动、唤醒、操作后及后台定时刷新状态。

[发布说明](docs/releases/1.2.0/zh-CN.md)

## 问题反馈

如无法使用，请在 [Issues](https://github.com/nicotech-studio/turbo-killer/issues) 提供 Mac 型号、macOS 版本及完整报错或截图。也欢迎分享成功运行的配置。

## 开发者说明

应用使用 SwiftUI，通过 XPC 与具有管理员权限的后台 Helper 通信。Helper 加载或卸载内置的历史内核扩展来控制 Turbo Boost；界面读取系统中的实际加载状态，并对完整扩展包进行 SHA-256 校验。

使用 Xcode 打开 `TurboKiller.xcodeproj` 即可构建。历史扩展包应保持原样；所需文件、测试和打包注意事项见[完整性维护文档](LegacyKextIntegrity.swift)。

## 支持

如果 TurboKiller 对你有帮助，可以支持它的后续开发：

<a href="https://ko-fi.com/hello_nico_chan"><img src="https://storage.ko-fi.com/cdn/kofi3.png?v=3" height="36" alt="在 Ko-fi 上支持我"></a>

## 许可证

[GPL-2.0](LICENSE)。内置组件的来源和授权见[第三方声明](THIRD_PARTY_NOTICES.md)。修改后的版本应明确标识，不应让用户误以为是官方发行版。
