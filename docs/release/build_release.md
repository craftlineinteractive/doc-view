# Doc View Release Build Guide (Android AAB)

## 1. Release Command Reference

To generate a production-ready, obfuscated Android App Bundle (AAB) for Google Play submission:

```bash
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=../docview_symbols \
  --dart-define=ADMOB_BANNER_ID="YOUR_PRODUCTION_BANNER_ID" \
  --dart-define=ADMOB_NATIVE_ID="YOUR_PRODUCTION_NATIVE_ID" \
  --dart-define=ADMOB_INTERSTITIAL_ID="YOUR_PRODUCTION_INTERSTITIAL_ID" \
  -PadmobAppId="YOUR_PRODUCTION_ADMOB_APP_ID"
```

### Parameter Breakdown:
- `--release`: Triggers release optimization, AOT compilation, and R8 tree-shaking.
- `--obfuscate`: Obfuscates Dart identifiers (classes, methods, fields) to protect intellectual property.
- `--split-debug-info=../docview_symbols`: Emits symbol mapping tables to a directory **OUTSIDE** the git repository for symbolication of crash traces.
- `--dart-define=ADMOB_*_ID=...`: Supplies production AdMob ad unit IDs. If any placement is left empty or omitted, that ad unit is disabled and collapses cleanly to 0 height.
- `-PadmobAppId=...`: Supplies production AdMob Application ID to Android Gradle. Gradle validates that this does not equal Google's public test app ID (`ca-app-pub-3940256099942544~3347511713`).

---

## 2. Test-Ad Release Blocker & Fail-Safes

Doc View implements automated Gradle fail-safe checks in `android/app/build.gradle.kts`:
1. **Keystore Blocker**: If `android/key.properties` does not exist and `-PallowDebugSigning=true` is not passed, `bundleRelease` and `assembleRelease` fail immediately.
2. **Test Ad ID Blocker**: If `admobAppId` equals Google's public test ID (`ca-app-pub-3940256099942544~3347511713`) and `-PallowTestAdIds=true` is not passed, release builds fail immediately.

### Local Test Builds (Developer Testing Only)
To build a release bundle for local testing using the debug keystore and Google's test ad IDs:
```bash
flutter build appbundle --release \
  -PallowDebugSigning=true \
  -PallowTestAdIds=true
```

---

## 3. Pre-Flight Release Checklist

Before building the production artifact:
- [ ] Version and build number incremented in `pubspec.yaml` (e.g. `version: 1.0.0+1`).
- [ ] `android/key.properties` configured with valid upload keystore credentials.
- [ ] `flutter analyze` passes with **0 issues**.
- [ ] Full test suite (`flutter test`) passes with **0 failures**.
- [ ] Production AdMob App ID and ad unit IDs verified in AdMob console.
- [ ] Constants in `docs/release/constants_to_fill.md` configured.
- [ ] All sensitive files verified untracked (`git status`).

---

## 4. Symbol Files & Crash Analysis (De-obfuscation)

1. **Dart Symbols**: Located at `../docview_symbols/app.android-arm64.symbols`. Archive these securely with the release Git tag. When viewing crash logs in Play Console, upload the corresponding symbol file.
2. **R8 / ProGuard Mapping File**: Generated automatically by Gradle at:
   `build/app/outputs/mapping/release/mapping.txt`
   Upload `mapping.txt` to Google Play Console under **App integrity** → **Deobfuscation files** to de-obfuscate Java/Kotlin stack traces.
