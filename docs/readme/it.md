# TurboKiller

[English](../../README.md) | [简体中文](zh-CN.md) | [繁體中文](zh-TW.md) | [日本語](ja.md) | [한국어](ko.md) | [Deutsch](de.md) | [Français](fr.md) | [Español](es.md) | [Português (Brasil)](pt-BR.md) | [Português (Portugal)](pt-PT.md) | [Italiano](it.md) | [Русский](ru.md) | [Türkçe](tr.md) | [Bahasa Indonesia](id.md) | [Tiếng Việt](vi.md) | [العربية](ar.md) | [עברית](he.md)

Disattiva Turbo Boost per un Mac più silenzioso e ripristinalo quando ti servono tutte le prestazioni.

## Scarica

[Scarica](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [TurboKiller](https://turbokiller.nicotech.cc/?lang=it)

No. TurboKiller richiede un Mac Intel compatibile con macOS 13 o successivo.

No. Mantieni attiva la protezione dell’integrità di sistema e segnala i problemi senza cambiare le impostazioni di sicurezza.

## Installa

1. Apri il DMG e trascina TurboKiller in Applicazioni.
2. Apri l’app. Se viene bloccata: Impostazioni di Sistema → Privacy e sicurezza → Apri comunque.
3. Consenti l’esecuzione in background se richiesta e segui le istruzioni per approvare l’estensione o riavviare.

Esci da TurboKiller e sostituisci l’app in Applicazioni con quella di TurboKiller-1.2.0.dmg. Segui le eventuali richieste di autorizzazione o riavvio.

L’app e il servizio sono firmati con Developer ID. Questa versione non è autenticata da Apple e macOS potrebbe bloccarne il primo avvio. Scarica solo dal repository ufficiale. Esci dall’app precedente prima di sostituirla.

## Come si usa

Scegli “Disattiva Turbo Boost” per ridurre calore e rumore delle ventole e “Ripristina Turbo Boost” quando ti servono prestazioni. La disattivazione può rallentare le attività impegnative. Verifica lo stato dopo ogni modifica; in caso di errore, non fare clic ripetutamente.

Stato visibile sull’icona del vento nella barra dei menu

## Note di rilascio · 1.3.0

- La barra dei menu e il pannello compatto mostrano la frequenza CPU media dell’ultimo intervallo di campionamento.
- Consulta gli ultimi 5 minuti, 15 minuti o un’ora. Gli sfondi rosso/blu chiaro indicano Turbo Boost attivo/disattivo, con una linea della frequenza base quando identificata in modo affidabile.
- Scegli intervalli di 1, 2, 5 o 10 secondi (predefinito: 2). Le impostazioni controllano anche il numero nella barra dei menu e la registrazione in background.
- Fino a un’ora di cronologia resta in memoria per la sessione. Stop, pause e dati mancanti lasciano spazi vuoti.

[Note di rilascio](../../docs/releases/1.3.0/it.md)

## Feedback

Ancora sperimentale, testato su alcuni Mac Intel. La compatibilità con tutte le configurazioni hardware e macOS non è garantita. Segnala problemi su GitHub con modello del Mac, versioni di macOS e dell’app ed errore completo o schermata. Sono benvenute anche le conferme di compatibilità.

[Segnala un problema](https://github.com/nicotech-studio/turbo-killer/issues/new?template=report.it.yml)

## Per sviluppatori

L’app SwiftUI della barra dei menu comunica tramite XPC con un servizio privilegiato che carica o scarica l’estensione del kernel legacy inclusa. Lo stato riflette il caricamento dell’estensione, senza misurare la frequenza della CPU. Apri TurboKiller.xcodeproj in Xcode per compilare. Conserva invariato il bundle storico dell’estensione.

[SHA-256](../../LegacyKextIntegrity.swift)

## Sostieni

TurboKiller è gratuito e open source. Se ti è utile, puoi offrirmi un caffè.

[Offrimi un caffè](https://ko-fi.com/hello_nico_chan)

## Licenza

[GPL-2.0](../../LICENSE) · [Note di terze parti](../../THIRD_PARTY_NOTICES.md)
