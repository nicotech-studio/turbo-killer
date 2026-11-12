# Building and publishing updates

TurboKiller 1.3.1 checks `https://turbokiller.nicotech.cc/appcast.xml`. Newer versions check `/updates/<installed-version>/appcast.xml`. Each feed points to the same release and includes the notes for all versions newer than the installed version, with one Markdown description per app language. Sparkle verifies the feed and DMG with the public key in `Config/TurboKiller-Info.plist`. The matching private key is in the release maintainer's login Keychain under Sparkle account `cc.nicotech.TurboKiller`.

1. Increase both the App version and build number in the Xcode project. Sparkle compares the build number when selecting an update.
2. Run `bash tools/build-release.sh VERSION BUILD_NUMBER` on the release Mac to build and verify the Developer ID signed DMG.
3. Add notes for all supported languages under `docs/releases/VERSION/`, following the heading and language links in the previous release. Run `SPARKLE_TOOLS_DIR=/path/to/Sparkle/bin bash tools/build-appcast.sh .release/TurboKiller-VERSION.dmg`. Use the Sparkle tools from the version pinned in `Package.resolved`.
4. Verify the signed update on an Intel Mac using a private test feed. Confirm the app restarts, connects to its Helper, and can read frequency and toggle Turbo Boost.
5. Use `docs/releases/1.3.1/github-release.md` as the GitHub Release template. Link all supported languages to their versioned notes at the release tag or the commit containing the notes, then include the English summary and the SHA-256 of the DMG.
6. Publish the generated `TurboKiller.dmg` under the corresponding GitHub Release tag. Copy the generated `appcast.xml` and `updates/` to `public/` in the website repository and deploy them once the release asset is available. Verify the root and version-specific feeds and the DMG URL after deployment.

Keep a secure backup of the Sparkle signing key. Rebuild and re-sign the feed after changing its contents.
