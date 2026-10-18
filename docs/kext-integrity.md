# Historical Kext bundle integrity

The historical `DisableTurboBoost.64bits.kext` must contain exactly these files:

| Relative path | SHA-256 |
| --- | --- |
| `Contents/MacOS/DisableTurboBoost` | `f81f003ccd5827122a41c39bddb78e4ffff37d84718a647dbd5fc3c6a92f987c` |
| `Contents/Info.plist` | `1de21bfa5521f32055f6b91a56552aa062e412ba517f9968a9bd2076cc1eee28` |
| `Contents/Info.plist~` | `a8aac919a47fb74339ac09366161efb90cc22dba0926d23413bd0ec615ffff06` |

Do not delete `Info.plist~`, even though its name resembles an editor backup.
It is preserved from the historical upstream bundle. Local reproduction using
Apple's detached ad-hoc signing algorithm produced these CDHashes:

- Complete bundle: `f5b755b280b4e501bacd72362f0bb26d006d1762`.
- Without `Info.plist~`: `b39ac35a33020b3e45b1a84253f9526b0558939f`.

Both investigated Macs' `AppleKextExcludeList.kext` versions (20.0.0 and
21.0.0) contained the first hash in `OSKextSigExceptionHashList`, but not the
second. The second matched the failed macOS 15.7.9 load's diagnostic CDHash.
This explains the observed signature mismatch; it does not guarantee loading
on all Macs.

## Confirmed acceptance result

The user tested the Developer ID-signed 1.1.1 build on the affected
MacBookPro16,3 running macOS 15.7.9 (24G830), with SIP enabled:

- `kmutil showloaded` listed `com.rugarciap.DisableTurboBoost` version 0.0.1,
  UUID `2BECDC3A-718C-3ED6-9E06-83FEDB537B36`.
- The UI reflected the disabled state, and measured CPU frequency dropped to
  1.4 GHz. The user recalled the enabled frequency as above 3 GHz, but did not
  retain an exact baseline; do not present that approximation as benchmark data.
- Re-enabling Turbo Boost also worked, according to the user's test report.

This verifies the affected machine's disable/restore flow. It does not establish
universal hardware compatibility, sleep/wake behavior or reboot persistence.

The App, Helper and release validator share `LegacyKextIntegrity.swift`.
They verify all three files and reject missing, modified, extra or symlinked
entries. Preparation replaces an incomplete prior installation even if its
executable hash is correct. The Helper also checks integrity before loading.
The health-check response includes a compatibility marker so a running old
Helper triggers the existing re-registration flow instead of skipping migration.
The Kext itself remains unsigned and must not be rebuilt or re-signed.

## Regression tests

From the repository root, compile and run without loading the Kext:

```sh
TK_TEST_DIR="$(mktemp -d)"
xcrun swiftc LegacyKextIntegrity.swift Tests/LegacyKextIntegrityTests.swift \
  -o "$TK_TEST_DIR/integrity-tests"
"$TK_TEST_DIR/integrity-tests" \
  "$PWD/TurboKiller/Resources/DisableTurboBoost.64bits.kext"
```

The tracked `tools/build-release.sh` runs the regression suite, validates the
archive's Kext and signed App, then validates the App again from the mounted
final DMG. A missing backup file stops packaging instead of silently shipping a
broken bundle. It never publishes or installs anything:

```sh
bash tools/build-release.sh 1.1.1
```

It requires the matching Developer ID identity and refuses to overwrite an
existing DMG. Build intermediates are retained for review. The older local
`distribution/release.sh` is Git-ignored; use the tracked script for this release.

For other packaging workflows, compile the tracked validator and run it against
the final App's Kext before distribution:

```sh
xcrun swiftc LegacyKextIntegrity.swift tools/VerifyKext.swift \
  -o "$TK_TEST_DIR/verify-kext"
"$TK_TEST_DIR/verify-kext" \
  /path/to/TurboKiller.app/Contents/Resources/DisableTurboBoost.64bits.kext
```

## Manual acceptance test before publishing

1. Install the newly Developer ID-signed App on the affected Intel Mac; leave
   SIP and startup security settings unchanged.
2. Approve its background Helper if required. Use the App to disable Turbo
   Boost once, allowing time for macOS to process the request.
3. Confirm the installed Kext contains all three pinned files and that
   `kmutil showloaded` lists `com.rugarciap.DisableTurboBoost`.
4. If macOS asks for Kext approval or a restart, follow that flow, then retry.
5. Re-enable Turbo Boost and confirm the Kext is unloaded.
6. Keep the full error and kernel-management logs if either operation fails.

The existing short XPC timeout is a separate known issue: a UI timeout alone
does not establish whether a load succeeded. Check actual loaded state before
retrying. This packaging fix does not change the timeout behavior.
