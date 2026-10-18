# TurboKiller

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Português (Portugal)](README.pt-PT.md) | [Italiano](README.it.md) | [Русский](README.ru.md) | [Türkçe](README.tr.md) | [Bahasa Indonesia](README.id.md) | [Tiếng Việt](README.vi.md) | [العربية](README.ar.md) | [עברית](README.he.md)

[![最新版本](https://img.shields.io/github/v/release/nicotech-studio/turbo-killer?display_name=tag&sort=semver&style=flat-square)](https://github.com/nicotech-studio/turbo-killer/releases/latest)
[![下載次數](https://img.shields.io/github/downloads/nicotech-studio/turbo-killer/total?style=flat-square)](https://github.com/nicotech-studio/turbo-killer/releases)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-000000?style=flat-square&logo=apple&logoColor=white)
![Intel Mac](https://img.shields.io/badge/Mac-Intel-0071C5?style=flat-square&logo=intel&logoColor=white)
[![GPL-2.0](https://img.shields.io/github/license/nicotech-studio/turbo-killer?style=flat-square)](LICENSE)

TurboKiller 是一款適用於 Intel Mac 的免費開源選單列工具。

希望電腦更安靜、溫度更低時，關閉 Turbo Boost；需要完整效能時，再一鍵恢復。關閉後，較繁重工作的執行速度可能下降。

## 下載與系統需求

[下載最新版本](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [官網](https://turbokiller.nicotech.cc)

- Intel Mac，macOS 13 或更新版本。不支援 Apple 晶片。
- 無需關閉系統完整性保護（SIP）。
- 目前仍處於實驗階段，已在部分 Intel Mac 上驗證，不保證所有組態相容。

## 安裝

1. 開啟下載的 DMG，將 TurboKiller 拖入「應用程式」。
2. 開啟 TurboKiller。如被 macOS 阻擋，前往 **系統設定 → 隱私權與安全性 → 仍要開啟**。
3. 如有提示，在 **一般 → 登入項目與擴充功能** 中允許 TurboKiller 在背景執行。
4. 如系統還要求核准擴充功能或重新啟動，請依提示操作。

更新時，先退出舊 App，再替換「應用程式」中的副本。

## 使用

- 希望降低發熱和風扇噪音時，在選單列選擇 **關閉 Turbo Boost**。
- 需要完整效能時，選擇 **恢復 Turbo Boost**。
- 操作後確認介面狀態。如有錯誤，不要連續點擊開關。

App 和背景元件已使用 Developer ID 簽署，但目前版本 **未通過 Apple 公證**。請僅從官方儲存庫下載，並保持 SIP 開啟。

## 版本說明 · 1.2.0

- 選單列保留固定風形圖示，透過單色角標區分 Turbo Boost 已開啟、已關閉與狀態未知。
- 精簡彈出視窗，聚焦狀態與操作；不支援的 Mac 改為顯示說明，底部始終保留設定與結束。
- App、官網、README 與本版本說明共支援 17 個在地化版本，包含由右至左版面的阿拉伯語與希伯來語。
- 啟動、喚醒、操作後及背景定時更新狀態。

[版本說明](docs/releases/1.2.0/zh-TW.md)

## 問題回報

如無法使用，請在 [Issues](https://github.com/nicotech-studio/turbo-killer/issues) 提供 Mac 型號、macOS 版本及完整錯誤訊息或截圖。也歡迎分享成功運作的組態。

## 開發者說明

應用程式使用 SwiftUI，透過 XPC 與具有管理員權限的背景 Helper 通訊。Helper 載入或卸載內建的歷史核心延伸模組來控制 Turbo Boost；介面讀取系統中的實際載入狀態，並對完整套件進行 SHA-256 驗證。

使用 Xcode 開啟 `TurboKiller.xcodeproj` 即可建置。歷史套件應保持原樣；所需檔案、測試與打包注意事項見[完整性維護文件](LegacyKextIntegrity.swift)。

## 支持

如果 TurboKiller 對你有幫助，可以支持後續開發：

<a href="https://ko-fi.com/hello_nico_chan"><img src="https://storage.ko-fi.com/cdn/kofi3.png?v=3" height="36" alt="在 Ko-fi 上支持我"></a>

## 授權條款

[GPL-2.0](LICENSE)。內建元件的來源與授權見[第三方聲明](THIRD_PARTY_NOTICES.md)。修改後的版本應明確標示，不應讓使用者誤以為是官方發行版。
