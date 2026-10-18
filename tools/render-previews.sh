#!/bin/bash
set -euo pipefail
# Render actual SwiftUI views using a mock controller; never install a helper or load a Kext.
# Usage: bash tools/render-previews.sh /path/to/built/TurboKiller.app /path/to/output
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="${1:?Pass a built TurboKiller.app}"
OUTPUT="${2:?Pass an output directory}"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/turbokiller-previews.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
BUNDLE="$WORK/Preview.app"
mkdir -p "$BUNDLE/Contents/MacOS" "$OUTPUT"
cp -R "$APP/Contents/Resources" "$BUNDLE/Contents/"
python3 - "$ROOT" "$BUNDLE" <<'PY'
import json,plistlib,sys
from pathlib import Path
root,bundle=map(Path,sys.argv[1:])
locales=json.loads((root/'docs/localization/languages.json').read_text())
plistlib.dump({'CFBundleIdentifier':'cc.nicotech.TurboKiller.Preview','CFBundleExecutable':'Preview','CFBundleDevelopmentRegion':'en','CFBundleLocalizations':[x['app'] for x in locales]},open(bundle/'Contents/Info.plist','wb'))
PY
xcrun swiftc -parse-as-library -module-cache-path "$WORK/modules" \
  "$ROOT/LegacyKextIntegrity.swift" "$ROOT/TurboKillerHelperProtocol.swift" \
  "$ROOT/TurboKiller/TurboBoostController.swift" "$ROOT/TurboKiller/TurboKillerModel.swift" \
  "$ROOT/TurboKiller/TurboKillerHelperClient.swift" "$ROOT/TurboKiller/TurboKillerHelperManager.swift" \
  "$ROOT/TurboKiller/ContentView.swift" "$ROOT/TurboKiller/SettingsView.swift" \
  "$ROOT/TurboKiller/TurboKillerMenuBarLabel.swift" "$ROOT/tools/RenderPreview.swift" \
  -o "$BUNDLE/Contents/MacOS/Preview"
while IFS=$'\t' read -r id app; do
  "$BUNDLE/Contents/MacOS/Preview" "$OUTPUT/$id" -AppleLanguages "($app)"
  echo "Rendered $id"
done < <(python3 - "$ROOT/docs/localization/languages.json" <<'PY'
import json,sys
for x in json.load(open(sys.argv[1])): print(x['id']+'\t'+x['app'])
PY
)
