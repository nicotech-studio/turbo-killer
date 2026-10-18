# TurboKiller

[English](../../README.md) | [简体中文](zh-CN.md) | [繁體中文](zh-TW.md) | [日本語](ja.md) | [한국어](ko.md) | [Deutsch](de.md) | [Français](fr.md) | [Español](es.md) | [Português (Brasil)](pt-BR.md) | [Português (Portugal)](pt-PT.md) | [Italiano](it.md) | [Русский](ru.md) | [Türkçe](tr.md) | [Bahasa Indonesia](id.md) | [Tiếng Việt](vi.md) | [العربية](ar.md) | [עברית](he.md)

Desactiva Turbo Boost para tener un Mac más silencioso y restáuralo cuando necesites todo el rendimiento.

## Descargar

[Descargar](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [TurboKiller](https://turbokiller.nicotech.cc/?lang=es)

No. TurboKiller requiere un Mac con Intel compatible y macOS 13 o posterior.

No. Mantén activa la protección de integridad del sistema e informa de los problemas sin cambiar la configuración de seguridad.

## Instalar

1. Abre el DMG y arrastra TurboKiller a Aplicaciones.
2. Abre la app. Si se bloquea: Ajustes del Sistema → Privacidad y seguridad → Abrir igualmente.
3. Permite la ejecución en segundo plano si se solicita y sigue las indicaciones para autorizar la extensión o reiniciar.

Cierra TurboKiller y reemplaza la app en Aplicaciones por la de TurboKiller-1.2.0.dmg. Sigue las solicitudes de autorización o reinicio si aparecen.

La app y su servicio están firmados con Developer ID. Esta versión no está notarizada por Apple y macOS puede bloquear el primer inicio. Descarga solo desde el repositorio oficial. Cierra la app anterior antes de reemplazarla.

## Uso

Elige «Desactivar Turbo Boost» para reducir calor y ruido del ventilador y «Restaurar Turbo Boost» para recuperar el rendimiento. Desactivarlo puede ralentizar tareas exigentes. Comprueba el estado después de cambiarlo; si hay un error, no hagas clic repetidamente.

Estado visible en el icono de viento de la barra de menús

## Notas de la versión · 1.2.0

- Icono de viento fijo con un indicador monocromo de Turbo Boost activado, desactivado o desconocido.
- Ventana compacta con estado y control; en los Mac no compatibles muestra un aviso en su lugar. Ajustes y Salir permanecen disponibles.
- 17 versiones lingüísticas para la app, la web, el README y estas notas, incluidos árabe y hebreo con diseño de derecha a izquierda.
- Actualización del estado al iniciar, al despertar, después de las operaciones y periódicamente en segundo plano.

[Notas de la versión](../../docs/releases/1.2.0/es.md)

## Comentarios

Todavía experimental, probado en algunos Mac con Intel. No se garantiza compatibilidad con todas las configuraciones de hardware y macOS. Informa de problemas en GitHub con el modelo de Mac, las versiones de macOS y de la app, y el error completo o una captura. También agradecemos los informes de compatibilidad satisfactoria.

[Informar de un problema](https://github.com/nicotech-studio/turbo-killer/issues/new?template=report.es.yml)

## Para desarrolladores

La app SwiftUI de la barra de menús se comunica por XPC con un servicio privilegiado que carga o descarga la extensión del kernel heredada incluida. El estado refleja la carga de la extensión, no una medición de frecuencia de la CPU. Abre TurboKiller.xcodeproj en Xcode para compilar. Conserva intacto el paquete histórico de la extensión.

[SHA-256](../../LegacyKextIntegrity.swift)

## Apoyar

TurboKiller es gratis y de código abierto. Si te resulta útil, puedes invitarme a un café.

[Invítame a un café](https://ko-fi.com/hello_nico_chan)

## Licencia

[GPL-2.0](../../LICENSE) · [Avisos de terceros](../../THIRD_PARTY_NOTICES.md)
