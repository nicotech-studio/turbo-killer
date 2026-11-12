#!/bin/bash
set -euo pipefail

# Usage: SPARKLE_TOOLS_DIR=/path/to/Sparkle/bin bash tools/build-appcast.sh DMG RELEASE_NOTES.md
DMG="${1:?Pass the signed TurboKiller-VERSION.dmg}"
NOTES="${2:?Pass a Markdown release notes file}"
TOOLS="${SPARKLE_TOOLS_DIR:?Set SPARKLE_TOOLS_DIR to the Sparkle bin directory}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ACCOUNT=cc.nicotech.TurboKiller
REPOSITORY=https://github.com/nicotech-studio/turbo-killer
OUTPUT="$(cd "$(dirname "$DMG")" && pwd)"

if [[ ! "$(basename "$DMG")" =~ ^TurboKiller-([0-9]+\.[0-9]+\.[0-9]+)\.dmg$ ]]; then
  echo 'Expected a versioned TurboKiller DMG.' >&2
  exit 1
fi
VERSION="${BASH_REMATCH[1]}"
[[ -f "$DMG" && -s "$NOTES" ]]
[[ ! -e "$OUTPUT/appcast.xml" && ! -e "$OUTPUT/TurboKiller.dmg" ]]

PUBLIC_KEY="$(/usr/libexec/PlistBuddy -c 'Print :SUPublicEDKey' "$ROOT/Config/TurboKiller-Info.plist")"
if [[ "$("$TOOLS/generate_keys" --account "$ACCOUNT" -p)" != "$PUBLIC_KEY" ]]; then
  echo 'The Sparkle key in the Keychain does not match the app public key.' >&2
  exit 1
fi
codesign --verify --verbose=2 "$DMG"

WORK="$(mktemp -d "$OUTPUT/appcast.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
cp "$DMG" "$WORK/TurboKiller.dmg"
cp "$NOTES" "$WORK/TurboKiller.md"
DOWNLOAD="$REPOSITORY/releases/download/v$VERSION/TurboKiller.dmg"
"$TOOLS/generate_appcast" --account "$ACCOUNT" --maximum-deltas 0 \
  --embed-release-notes --download-url-prefix "${DOWNLOAD%/*}/" \
  --link "$REPOSITORY/releases/tag/v$VERSION" -o "$WORK/appcast.xml" "$WORK"
"$TOOLS/sign_update" --account "$ACCOUNT" --verify "$WORK/appcast.xml"

python3 - "$WORK" "$VERSION" "$DOWNLOAD" <<'PY'
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

work = Path(sys.argv[1])
version, url = sys.argv[2:]
sparkle = "{http://www.andymatuschak.org/xml-namespaces/sparkle}"
items = ET.parse(work / "appcast.xml").findall("./channel/item")
if len(items) != 1:
    sys.exit("Expected one release in the appcast.")
item = items[0]
enclosure = item.find("enclosure")
if (
    item.findtext(f"{sparkle}shortVersionString") != version
    or not item.findtext(f"{sparkle}version")
    or not item.findtext("description")
    or enclosure is None
    or enclosure.get("url") != url
    or enclosure.get("length") != str((work / "TurboKiller.dmg").stat().st_size)
    or not enclosure.get(f"{sparkle}edSignature")
):
    sys.exit("The generated appcast does not match the release.")
PY

mv "$WORK/TurboKiller.dmg" "$OUTPUT/TurboKiller.dmg"
mv "$WORK/appcast.xml" "$OUTPUT/appcast.xml"
printf 'Release asset: %s\nWebsite feed: %s\n' "$OUTPUT/TurboKiller.dmg" "$OUTPUT/appcast.xml"
