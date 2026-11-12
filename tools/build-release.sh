#!/bin/bash
set -euo pipefail

# Local packaging only: never tags, pushes, publishes, installs or loads a Kext.
# Usage: bash tools/build-release.sh [1.3.2] [build-number]
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="${1:-1.3.2}"
BUILD_NUMBER="${2:-}"
TEAM_ID="${TEAM_ID:-PPXL64QJ2V}"
OUTPUT="${RELEASE_OUTPUT_DIR:-$ROOT/.release}"
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo 'Invalid version'; exit 1; }
build_settings=(CODE_SIGNING_ALLOWED=NO "MARKETING_VERSION=$VERSION")
if [[ -n "$BUILD_NUMBER" ]]; then
  [[ "$BUILD_NUMBER" =~ ^[1-9][0-9]*$ ]] || { echo 'Invalid build number'; exit 1; }
  build_settings+=("CURRENT_PROJECT_VERSION=$BUILD_NUMBER")
fi
if [[ -n "${SPARKLE_PACKAGES_DIR:-}" ]]; then
  package_options=(-clonedSourcePackagesDirPath "$SPARKLE_PACKAGES_DIR")
else
  package_options=()
fi
DMG="$OUTPUT/TurboKiller-$VERSION.dmg"
[[ ! -e "$DMG" ]] || { echo "Refusing to overwrite $DMG"; exit 1; }

IDENTITY="${SIGNING_IDENTITY:-$(security find-identity -v -p codesigning |
  sed -n 's/.*"\(Developer ID Application:.*('"$TEAM_ID"')\)".*/\1/p' | head -1)}"
[[ -n "$IDENTITY" ]] || { echo 'Developer ID Application identity not found'; exit 1; }

mkdir -p "$OUTPUT"
WORK="$(mktemp -d "$OUTPUT/build-$VERSION.XXXXXX")"
STAGE="$WORK/stage"
MOUNT="$WORK/mounted"
APP="$STAGE/TurboKiller.app"
HELPER="$APP/Contents/MacOS/TurboKillerHelper"
SPARKLE="$APP/Contents/Frameworks/Sparkle.framework"
KEXT_RELATIVE="Contents/Resources/DisableTurboBoost.64bits.kext"
MOUNTED=false
cleanup() {
  if [[ "$MOUNTED" == true ]]; then hdiutil detach "$MOUNT" || true; fi
}
trap cleanup EXIT
mkdir -p "$STAGE" "$MOUNT"

xcrun swiftc "$ROOT/LegacyKextIntegrity.swift" "$ROOT/tools/VerifyKext.swift" \
  -o "$WORK/verify-kext"
xcrun swiftc "$ROOT/LegacyKextIntegrity.swift" "$ROOT/Tests/LegacyKextIntegrityTests.swift" \
  -o "$WORK/integrity-tests"
"$WORK/integrity-tests" "$ROOT/TurboKiller/Resources/DisableTurboBoost.64bits.kext"

xcodebuild -quiet -project "$ROOT/TurboKiller.xcodeproj" -scheme TurboKiller \
  -configuration Release -destination 'generic/platform=macOS' \
  -derivedDataPath "$WORK/DerivedData" -archivePath "$WORK/TurboKiller.xcarchive" \
  -onlyUsePackageVersionsFromResolvedFile \
  ${package_options[@]+"${package_options[@]}"} "${build_settings[@]}" archive

ditto "$WORK/TurboKiller.xcarchive/Products/Applications/TurboKiller.app" "$APP"
"$WORK/verify-kext" "$APP/$KEXT_RELATIVE"
[[ "$(lipo -archs "$APP/Contents/MacOS/TurboKiller")" == x86_64 ]]
[[ "$(lipo -archs "$HELPER")" == x86_64 ]]
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$APP/Contents/Info.plist")" == "$VERSION" ]]
[[ "$(/usr/libexec/PlistBuddy -c 'Print :SUFeedURL' "$APP/Contents/Info.plist")" == "https://turbokiller.nicotech.cc/updates/$VERSION/appcast.xml" ]]
[[ "$(/usr/libexec/PlistBuddy -c 'Print :LSRequiresNativeExecution' "$APP/Contents/Info.plist")" == true ]]
if [[ -n "$BUILD_NUMBER" ]]; then
  [[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$APP/Contents/Info.plist")" == "$BUILD_NUMBER" ]]
fi

# Sign nested code from the inside out. Leave the historical Kext unchanged.
sign_code() {
  codesign --force --options runtime --timestamp --sign "$IDENTITY" "$1"
}

[[ -x "$SPARKLE/Versions/B/Autoupdate" && -d "$SPARKLE/Versions/B/Updater.app" ]]
sign_code "$SPARKLE/Versions/B/Autoupdate"
sign_code "$SPARKLE/Versions/B/Updater.app"
for service in "$SPARKLE/Versions/B/XPCServices/"*.xpc; do
  if [[ -d "$service" ]]; then
    sign_code "$service"
  fi
done
sign_code "$SPARKLE"
sign_code "$HELPER"
sign_code "$APP"
codesign --verify --deep --strict --verbose=2 "$SPARKLE"
codesign --verify --strict --verbose=2 "$HELPER"
codesign --verify --strict --verbose=2 "$APP"
"$WORK/verify-kext" "$APP/$KEXT_RELATIVE"

ln -s /Applications "$STAGE/Applications"
hdiutil create -volname TurboKiller -srcfolder "$STAGE" -format UDZO "$DMG"
codesign --force --timestamp --sign "$IDENTITY" "$DMG"
codesign --verify --verbose=2 "$DMG"

# Validate the actual disk image, not only the directory used to make it.
hdiutil attach -readonly -nobrowse -noautoopen -mountpoint "$MOUNT" "$DMG"
MOUNTED=true
codesign --verify --strict --verbose=2 "$MOUNT/TurboKiller.app"
codesign --verify --strict --verbose=2 "$MOUNT/TurboKiller.app/Contents/MacOS/TurboKillerHelper"
codesign --verify --deep --strict --verbose=2 "$MOUNT/TurboKiller.app/Contents/Frameworks/Sparkle.framework"
"$WORK/verify-kext" "$MOUNT/TurboKiller.app/$KEXT_RELATIVE"
hdiutil detach "$MOUNT"
MOUNTED=false

(cd "$OUTPUT" && shasum -a 256 "TurboKiller-$VERSION.dmg") > "$DMG.sha256"
printf '\nReady for review (not published): %s\nWork directory retained: %s\n' "$DMG" "$WORK"
echo 'Developer ID signed; NOT Apple-notarized. Kext remains unsigned.'
