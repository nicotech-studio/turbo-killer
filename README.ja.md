# TurboKiller

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Português (Portugal)](README.pt-PT.md) | [Italiano](README.it.md) | [Русский](README.ru.md) | [Türkçe](README.tr.md) | [Bahasa Indonesia](README.id.md) | [Tiếng Việt](README.vi.md) | [العربية](README.ar.md) | [עברית](README.he.md)

[![Latest release](https://img.shields.io/github/v/release/nicotech-studio/turbo-killer?display_name=tag&sort=semver&style=flat-square)](https://github.com/nicotech-studio/turbo-killer/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/nicotech-studio/turbo-killer/total?style=flat-square)](https://github.com/nicotech-studio/turbo-killer/releases)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-000000?style=flat-square&logo=apple&logoColor=white)
![Intel Mac](https://img.shields.io/badge/Mac-Intel-0071C5?style=flat-square&logo=intel&logoColor=white)
[![GPL-2.0](https://img.shields.io/github/license/nicotech-studio/turbo-killer?style=flat-square)](LICENSE)

TurboKiller は Intel Mac 向けの無料・オープンソースのメニューバーアプリです。

静かさや発熱の低減を優先するときは Turbo Boost をオフにし、フルパフォーマンスが必要なときは元に戻せます。オフにすると、負荷の高い処理は遅くなる場合があります。

## ダウンロードと動作環境

[最新版をダウンロード](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [公式サイト](https://turbokiller.nicotech.cc)

- Intel Mac、macOS 13 以降。Apple シリコンには対応していません。
- システム整合性保護（SIP）を無効にする必要はありません。
- まだ実験段階です。一部の Intel Mac で検証済みですが、すべての構成での動作は保証されません。

## インストール

1. ダウンロードした DMG を開き、TurboKiller を「アプリケーション」にドラッグします。
2. TurboKiller を開きます。macOS にブロックされた場合は、**システム設定 → プライバシーとセキュリティ → このまま開く**を選びます。
3. 求められた場合は、**一般 → ログイン項目と機能拡張**でバックグラウンド実行を許可します。
4. 機能拡張の承認や再起動を求められた場合は、システムの指示に従ってください。

更新時は旧 App を終了してから、「アプリケーション」のコピーを置き換えてください。

## 使い方

- 発熱やファンノイズを抑えたいときは、メニューバーで **Turbo Boost を無効にする**を選びます。
- フルパフォーマンスが必要なときは、**Turbo Boost を復元**を選びます。
- 操作後は表示状態を確認してください。エラーが出た場合はスイッチを連打しないでください。

App とバックグラウンドコンポーネントは Developer ID 署名済みですが、現在のバージョンは **Apple 未公証**です。公式リポジトリからのみダウンロードし、SIP は有効のまま使用してください。

## リリースノート · 1.2.0

- メニューバーの風アイコンを固定し、単色のバッジで Turbo Boost の有効・無効・状態不明を表示。
- 状態と操作に集中したコンパクトな画面。非対応の Mac では説明を表示し、設定と終了は常に利用可能。
- アプリ、ウェブサイト、README、本リリースノートで17のローカライズに対応。右から左のレイアウトを備えたアラビア語とヘブライ語を含む。
- 起動時、スリープ解除時、操作後、バックグラウンドでの定期的な状態更新。

[リリースノート](docs/releases/1.2.0/ja.md)

## フィードバック

動作しない場合は、Mac のモデル、macOS バージョン、エラー全文またはスクリーンショットを添えて [Issues](https://github.com/nicotech-studio/turbo-killer/issues) へご報告ください。動作した構成の報告も歓迎します。

## 開発者向け

SwiftUI の App は XPC 経由で特権バックグラウンド Helper と通信します。Helper が同梱の歴史的なカーネル拡張をロード・アンロードして Turbo Boost を制御します。表示はシステムの実際のロード状態に基づき、拡張全体を SHA-256 で検証します。

Xcode で `TurboKiller.xcodeproj` を開いてビルドします。同梱の歴史的な拡張は変更せず保持してください。必要なファイル、テスト、パッケージ作成については[完全性の保守資料](LegacyKextIntegrity.swift)を参照してください。

## サポート

TurboKiller が役に立った場合は、開発をご支援いただけます：

<a href="https://ko-fi.com/hello_nico_chan"><img src="https://storage.ko-fi.com/cdn/kofi3.png?v=3" height="36" alt="Ko-fi でサポート"></a>

## ライセンス

[GPL-2.0](LICENSE)。同梱コンポーネントの出典とライセンスは[サードパーティ通知](THIRD_PARTY_NOTICES.md)を参照してください。改変版はその旨を明記し、公式リリースと誤認されないようにしてください。
