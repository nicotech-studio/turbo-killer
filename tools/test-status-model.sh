#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/turbokiller-status-tests.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
xcrun swiftc -parse-as-library -module-cache-path "$WORK/modules" \
  "$ROOT/LegacyKextIntegrity.swift" "$ROOT/TurboKillerHelperProtocol.swift" \
  "$ROOT/TurboKiller/TurboBoostController.swift" "$ROOT/TurboKiller/TurboKillerModel.swift" \
  "$ROOT/TurboKiller/TurboKillerHelperClient.swift" "$ROOT/TurboKiller/TurboKillerHelperManager.swift" \
  "$ROOT/Tests/StatusModelTests.swift" -o "$WORK/status-tests"
"$WORK/status-tests"
