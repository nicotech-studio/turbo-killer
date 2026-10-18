# TurboKiller

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Português (Portugal)](README.pt-PT.md) | [Italiano](README.it.md) | [Русский](README.ru.md) | [Türkçe](README.tr.md) | [Bahasa Indonesia](README.id.md) | [Tiếng Việt](README.vi.md) | [العربية](README.ar.md) | [עברית](README.he.md)

[![Latest release](https://img.shields.io/github/v/release/nicotech-studio/turbo-killer?display_name=tag&sort=semver&style=flat-square)](https://github.com/nicotech-studio/turbo-killer/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/nicotech-studio/turbo-killer/total?style=flat-square)](https://github.com/nicotech-studio/turbo-killer/releases)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-000000?style=flat-square&logo=apple&logoColor=white)
![Intel Mac](https://img.shields.io/badge/Mac-Intel-0071C5?style=flat-square&logo=intel&logoColor=white)
[![GPL-2.0](https://img.shields.io/github/license/nicotech-studio/turbo-killer?style=flat-square)](LICENSE)

TurboKiller는 Intel Mac용 무료 오픈 소스 메뉴 막대 앱입니다.

더 조용하고 발열이 적은 환경을 원할 때 Turbo Boost를 끄고, 최대 성능이 필요하면 다시 켤 수 있습니다. 끄면 부하가 큰 작업의 처리 속도가 낮아질 수 있습니다.

## 다운로드 및 시스템 요구 사항

[최신 버전 다운로드](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [공식 사이트](https://turbokiller.nicotech.cc)

- Intel Mac, macOS 13 이상. Apple Silicon은 지원하지 않습니다.
- 시스템 무결성 보호(SIP)를 비활성화할 필요가 없습니다.
- 아직 실험 단계입니다. 일부 Intel Mac에서 검증했지만 모든 구성의 호환성을 보장하지는 않습니다.

## 설치

1. 다운로드한 DMG를 열고 TurboKiller를 응용 프로그램으로 드래그합니다.
2. TurboKiller를 실행합니다. macOS가 차단하면 **시스템 설정 → 개인정보 보호 및 보안 → 그래도 열기**를 선택합니다.
3. 요청되면 **일반 → 로그인 항목 및 확장 프로그램**에서 백그라운드 실행을 허용합니다.
4. 확장 프로그램 승인이나 재시동을 요청하면 시스템 안내를 따릅니다.

업데이트할 때는 이전 App을 종료한 뒤 응용 프로그램의 복사본을 교체하세요.

## 사용

- 발열과 팬 소음을 줄이고 싶으면 메뉴 막대에서 **Turbo Boost 비활성화**를 선택합니다.
- 최대 성능이 필요하면 **Turbo Boost 복원**을 선택합니다.
- 작업 후 표시 상태를 확인하세요. 오류가 나면 스위치를 연속으로 누르지 마세요.

App과 백그라운드 구성 요소는 Developer ID로 서명되어 있지만 현재 버전은 **Apple 공증을 받지 않았습니다**. 공식 저장소에서만 다운로드하고 SIP는 활성화 상태로 유지하세요.

## 릴리스 노트 · 1.2.0

- 메뉴 막대의 바람 아이콘을 유지하고 단색 배지로 Turbo Boost 켜짐, 꺼짐, 상태 알 수 없음을 표시합니다.
- 상태와 조작에 집중한 간결한 창입니다. 지원되지 않는 Mac에서는 안내를 대신 표시하며 설정과 종료는 항상 사용할 수 있습니다.
- 앱, 웹사이트, README 및 이 릴리스 노트에서 17개 현지화 버전을 지원하며 오른쪽에서 왼쪽 레이아웃의 아랍어와 히브리어를 포함합니다.
- 시작, 잠자기 해제, 조작 후 및 백그라운드에서 주기적으로 상태를 갱신합니다.

[릴리스 노트](docs/releases/1.2.0/ko.md)

## 피드백

작동하지 않으면 Mac 모델, macOS 버전, 전체 오류 메시지 또는 스크린샷과 함께 [Issues](https://github.com/nicotech-studio/turbo-killer/issues)에 알려 주세요. 정상 작동한 구성에 대한 보고도 환영합니다.

## 개발자 안내

SwiftUI App은 XPC로 권한이 있는 백그라운드 Helper와 통신합니다. Helper는 포함된 과거 커널 확장을 로드하거나 언로드하여 Turbo Boost를 제어합니다. 표시는 시스템의 실제 로드 상태에 기반하며 전체 확장 번들을 SHA-256으로 검증합니다.

Xcode에서 `TurboKiller.xcodeproj`를 열어 빌드합니다. 포함된 과거 확장 번들은 변경하지 마세요. 필수 파일, 테스트 및 패키징 방법은 [무결성 유지보수 문서](LegacyKextIntegrity.swift)를 참조하세요.

## 지원

TurboKiller가 도움이 되었다면 개발을 지원할 수 있습니다:

<a href="https://ko-fi.com/hello_nico_chan"><img src="https://storage.ko-fi.com/cdn/kofi3.png?v=3" height="36" alt="Ko-fi에서 후원하기"></a>

## 라이선스

[GPL-2.0](LICENSE). 포함된 구성 요소의 출처와 라이선스는 [서드 파티 고지](THIRD_PARTY_NOTICES.md)를 참조하세요. 수정 빌드는 수정본임을 명시하고 공식 릴리스로 오인되지 않도록 해야 합니다.
