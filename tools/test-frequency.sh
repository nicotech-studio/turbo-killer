#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/turbokiller-frequency-tests.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
xcrun swiftc -parse-as-library -module-cache-path "$WORK/modules" \
  "$ROOT/TurboKiller/CPUBaseFrequency.swift" "$ROOT/CPUFrequencyTelemetry.swift" "$ROOT/TurboKillerHelperProtocol.swift" \
  "$ROOT/TurboKiller/CPUFrequencyMonitor.swift" "$ROOT/TurboKillerHelper/CPUFrequencySampler.swift" \
  "$ROOT/LegacyKextIntegrity.swift" "$ROOT/TurboKiller/TurboBoostController.swift" \
  "$ROOT/TurboKiller/TurboKillerHelperClient.swift" "$ROOT/TurboKiller/TurboKillerHelperManager.swift" \
  "$ROOT/TurboKiller/TurboKillerModel.swift" "$ROOT/Tests/FrequencyTests.swift" \
  -o "$WORK/frequency-tests"
"$WORK/frequency-tests"
