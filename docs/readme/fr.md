# TurboKiller

[English](../../README.md) | [简体中文](zh-CN.md) | [繁體中文](zh-TW.md) | [日本語](ja.md) | [한국어](ko.md) | [Deutsch](de.md) | [Français](fr.md) | [Español](es.md) | [Português (Brasil)](pt-BR.md) | [Português (Portugal)](pt-PT.md) | [Italiano](it.md) | [Русский](ru.md) | [Türkçe](tr.md) | [Bahasa Indonesia](id.md) | [Tiếng Việt](vi.md) | [العربية](ar.md) | [עברית](he.md)

Désactivez Turbo Boost pour un Mac plus silencieux et rétablissez-le lorsque vous avez besoin de toutes ses performances.

## Télécharger

[Télécharger](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [TurboKiller](https://turbokiller.nicotech.cc/?lang=fr)

Non. TurboKiller nécessite un Mac Intel compatible sous macOS 13 ou ultérieur.

Non. Gardez la protection de l’intégrité du système activée et signalez les problèmes sans modifier les réglages de sécurité.

## Installer

1. Ouvrez le DMG et glissez TurboKiller dans Applications.
2. Ouvrez l’app. Si elle est bloquée : Réglages Système → Confidentialité et sécurité → Ouvrir quand même.
3. Autorisez l’exécution en arrière-plan si nécessaire et suivez les demandes d’approbation de l’extension ou de redémarrage.

Quittez TurboKiller et remplacez l’app dans Applications par celle de TurboKiller-1.2.0.dmg. Suivez les éventuelles demandes d’autorisation ou de redémarrage.

L’app et son service sont signés avec Developer ID. Cette version n’est pas notariée par Apple ; macOS peut bloquer le premier lancement. Téléchargez uniquement depuis le dépôt officiel. Quittez l’ancienne app avant de la remplacer.

## Utilisation

Choisissez « Désactiver Turbo Boost » pour réduire la chaleur et le bruit des ventilateurs, puis « Rétablir Turbo Boost » pour retrouver les performances. La désactivation peut ralentir les tâches exigeantes. Vérifiez l’état après chaque changement ; ne répétez pas les clics en cas d’erreur.

État visible sur l’icône de vent de la barre des menus

## Notes de version · 1.2.0

- Icône de vent fixe avec un indicateur monochrome : Turbo Boost activé, désactivé ou état inconnu.
- Fenêtre compacte consacrée à l’état et au contrôle ; un message remplace ces éléments sur les Mac incompatibles. Réglages et Quitter restent accessibles.
- 17 versions linguistiques pour l’app, le site, le README et ces notes, dont l’arabe et l’hébreu avec une disposition de droite à gauche.
- Actualisation de l’état au lancement, au réveil, après les opérations et régulièrement en arrière-plan.

[Notes de version](../../docs/releases/1.2.0/fr.md)

## Retours

Encore expérimental, testé sur certains Mac Intel. La compatibilité avec toutes les configurations matérielles et macOS n’est pas garantie. Signalez les problèmes sur GitHub avec le modèle de Mac, les versions de macOS et de l’app, ainsi que l’erreur complète ou une capture d’écran. Les retours de compatibilité réussie sont aussi bienvenus.

[Signaler un problème](https://github.com/nicotech-studio/turbo-killer/issues/new?template=report.fr.yml)

## Pour les développeurs

L’app SwiftUI de la barre des menus communique par XPC avec un service privilégié qui charge ou décharge l’ancienne extension du noyau fournie. L’état reflète son chargement, sans mesurer la fréquence du processeur. Ouvrez TurboKiller.xcodeproj dans Xcode pour compiler. Conservez le paquet historique de l’extension sans modification.

[SHA-256](../../LegacyKextIntegrity.swift)

## Soutenir

TurboKiller est gratuit et open source. S’il vous est utile, vous pouvez m’offrir un café.

[Offrez-moi un café](https://ko-fi.com/hello_nico_chan)

## Licence

[GPL-2.0](../../LICENSE) · [Mentions des tiers](../../THIRD_PARTY_NOTICES.md)
