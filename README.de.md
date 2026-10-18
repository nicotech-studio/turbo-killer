# TurboKiller

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Português (Portugal)](README.pt-PT.md) | [Italiano](README.it.md) | [Русский](README.ru.md) | [Türkçe](README.tr.md) | [Bahasa Indonesia](README.id.md) | [Tiếng Việt](README.vi.md) | [العربية](README.ar.md) | [עברית](README.he.md)

Deaktiviere Turbo Boost für einen leiseren Mac und stelle es wieder her, wenn du volle Leistung brauchst.

## Herunterladen

[Herunterladen](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [TurboKiller](https://turbokiller.nicotech.cc/?lang=de)

Nein. TurboKiller benötigt einen kompatiblen Intel-Mac mit macOS 13 oder neuer.

Nein. Lass den Systemintegritätsschutz aktiviert und melde Probleme, statt Sicherheitseinstellungen zu ändern.

## Installieren

1. Öffne das DMG und ziehe TurboKiller in Programme.
2. Öffne die App. Falls sie blockiert wird: Systemeinstellungen → Datenschutz & Sicherheit → Dennoch öffnen.
3. Erlaube bei Nachfrage den Hintergrundbetrieb. Folge den Anweisungen zur Genehmigung der Erweiterung oder zum Neustart.

Beende TurboKiller und ersetze die App in Programme durch die Version aus TurboKiller-1.2.0.dmg. Folge gegebenenfalls den Genehmigungs- oder Neustartaufforderungen.

App und Hintergrunddienst sind mit Developer ID signiert. Diese Version ist nicht von Apple notarisiert; macOS kann den ersten Start blockieren. Lade nur aus dem offiziellen Repository herunter. Beende vor einem Update die alte App.

## Verwendung

Wähle „Turbo Boost deaktivieren“ für weniger Wärme und Lüftergeräusche und „Turbo Boost wiederherstellen“ für volle Leistung. Anspruchsvolle Aufgaben können bei deaktiviertem Turbo Boost langsamer laufen. Prüfe nach dem Umschalten den Status; wiederhole fehlgeschlagene Aktionen nicht fortlaufend.

Status direkt am Wind-Symbol in der Menüleiste

## Versionshinweise · 1.2.0

- Festes Wind-Symbol mit monochromem Statusabzeichen für aktiviertes, deaktiviertes oder unbekanntes Turbo Boost.
- Kompaktes Fenster mit Status und Steuerung; auf nicht unterstützten Macs erscheint stattdessen ein Hinweis. Einstellungen und Beenden bleiben verfügbar.
- 17 Sprachversionen für App, Website, README und diese Versionshinweise, einschließlich Arabisch und Hebräisch mit Rechts-nach-links-Layout.
- Statusaktualisierung beim Start, nach dem Ruhezustand, nach Aktionen und regelmäßig im Hintergrund.

[Versionshinweise](docs/releases/1.2.0/de.md)

## Rückmeldung

Experimentell und auf einigen Intel-Macs getestet. Nicht jede Hardware- und macOS-Konfiguration ist kompatibel. Melde Probleme mit Mac-Modell, macOS-Version, App-Version und vollständiger Fehlermeldung oder Bildschirmfoto auf GitHub. Auch erfolgreiche Tests sind willkommen.

[Problem melden](https://github.com/nicotech-studio/turbo-killer/issues/new?template=report.de.yml)

## Für Entwickler

Die SwiftUI-Menüleisten-App kommuniziert über XPC mit einem privilegierten Hintergrunddienst. Dieser lädt oder entlädt die mitgelieferte ältere Kernelerweiterung. Der Status zeigt den Ladezustand der Erweiterung, keine gemessene CPU-Frequenz. Öffne TurboKiller.xcodeproj in Xcode zum Bauen. Bewahre das historische Erweiterungsbundle unverändert auf.

[SHA-256](LegacyKextIntegrity.swift)

## Unterstützen

TurboKiller ist kostenlos und quelloffen. Wenn es dir hilft, kannst du mir einen Kaffee spendieren.

[Spendiere mir einen Kaffee](https://ko-fi.com/hello_nico_chan)

## Lizenz

[GPL-2.0](LICENSE) · [Hinweise zu Drittanbietern](THIRD_PARTY_NOTICES.md)
