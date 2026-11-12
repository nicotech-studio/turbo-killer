# Building and publishing updates

The App checks `https://turbokiller.nicotech.cc/appcast.xml`. Sparkle verifies the feed and DMG with the public key in `Config/TurboKiller-Info.plist`. The matching private key is in the release maintainer's login Keychain under Sparkle account `cc.nicotech.TurboKiller`.

1. Increase both the App version and build number in the Xcode project. Sparkle compares the build number when selecting an update.
2. Run `bash tools/build-release.sh VERSION BUILD_NUMBER` on the release Mac to build and verify the Developer ID signed DMG.
3. Run `SPARKLE_TOOLS_DIR=/path/to/Sparkle/bin bash tools/build-appcast.sh .release/TurboKiller-VERSION.dmg path/to/release-notes.md`. Use the Sparkle tools from the version pinned in `Package.resolved`.
4. Verify the signed update on an Intel Mac using a private test feed. Confirm the app restarts, connects to its Helper, and can read frequency and toggle Turbo Boost.
5. Publish the generated `TurboKiller.dmg` under the corresponding GitHub Release tag. Copy the generated `appcast.xml` to `public/appcast.xml` in the website repository and deploy it once the release asset is available. Verify the live feed and the DMG URL after deployment.

Keep a secure backup of the Sparkle signing key. Rebuild and re-sign the feed after changing its contents.
