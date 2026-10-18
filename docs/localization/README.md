# Localization maintenance

The product supports 17 locales. `languages.json` maps public document/website
language codes to Xcode catalog identifiers (`zh-CN` → `zh-Hans`, `zh-TW` →
`zh-Hant`) and records right-to-left locales.

For each language, keep these surfaces in sync:

- App: `TurboKiller/Localizable.xcstrings` and Xcode `knownRegions`.
- Product README: `README.<locale>.md` (`README.md` for English).
- Issue form: `.github/ISSUE_TEMPLATE/report.<locale>.yml`.
- Release notes from 1.2.0 onward: `docs/releases/<version>/<locale>.md`.
- Website repository: `src/locales.json`, `src/languages.js`, and
  `public/assets/screenshots/app-<locale>.png`.

Run `python3 tools/check-localizations.py` to check catalog coverage, formatting
placeholders, document coverage and local links. Run `bash tools/test-status-model.sh`
for status regressions without using a real helper or loading a kernel extension.
The website has its own React, release-policy and asset tests.

Generate screenshots from a built App with:

```sh
bash tools/render-previews.sh /path/to/TurboKiller.app /path/to/output
```

The renderer uses the real SwiftUI views with a mock controller, in a temporary
bundle containing the built App's localizations. It does not install or load any
system components. It renders status, unsupported-hardware and settings views,
plus the three monochrome menu bar icons. Review all locales at actual size,
especially long button labels and Arabic/Hebrew layout. Some native tab chrome
may not be captured by offscreen rendering; verify it in the running App too.

Do not translate the TurboKiller or NicoTech Studio names, commands, paths or
raw system diagnostics. Explain system errors in localized UI text while keeping
the original diagnostic available. Preserve printf placeholders exactly; Arabic
and Hebrew version strings isolate their left-to-right version value.

GitHub Release uses the English body in `github-release.md`, with links pinned
to the version tag for all translations. Publish the App release before deploying
a website that links to its download. Leave historical release text unchanged.
