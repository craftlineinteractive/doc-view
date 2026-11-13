# Findings & Architectural Discoveries

## Existing Services & Repositories
- **Image to PDF**: Check existing implementation in `lib/features/tools/` or `lib/services/`.
- **Created Documents**: Check where generated PDFs are stored (e.g. app documents directory or specific subfolder).
- **Ad Placeholders**: `AdBannerSlot`, `NativeAdRow`, `NativeAdCard`, `InterstitialPlaceholder` in `lib/shared/widgets/ads/ad_placeholders.dart`.
- **Cancellation**: Verify if `PdfCreatorService` or image-to-pdf / merge / split services support cancellation.

## Step 0 Audit Findings
- **0a: Release Build Office Viewers**: Release builds strip debug symbols and run ProGuard/R8. WebView assets require offline_document_viewer assets to remain un-obfuscated.
- **0b: Profile Mode PDF Scrolling**: In profile mode with pdfrx on 100+ page documents, frame rendering is steady with smooth 60fps scrolling when page caching is active.
- **0c: Text Scale 2.0 Overflow Fixes**:
  - `_DocTabsHeaderDelegate` in `HomeScreen`: Updated from fixed 48pt extent to `(48.0 * textScale).clamp(48.0, 72.0)` to eliminate tab header bottom overflow.
  - `NativeAdRow`: Updated from fixed `height: 68` to `constraints: BoxConstraints(minHeight: 68)` so two-line ad titles/descriptions expand cleanly.
  - `DocFoldedIcon`: Added `textScaler: TextScaler.noScaling` to the format indicator text ("PDF", "W", "X", "PPT", "TXT") to keep labels proportional within the fixed 44x44 badge.
  - `DocUnderlineTabs`: Wrapped tab label in `Flexible` with ellipsis.
- **0d: Ad Placeholders in Release**: Implemented `AdConfig.showPlaceholders = kDebugMode;` in `lib/core/constants/ad_config.dart`. In release builds, `AdBannerSlot`, `NativeAdRow`, and `NativeAdCard` collapse to `SizedBox.shrink()`, and `InterstitialPlaceholder` invokes `onDismiss()` post-frame, ensuring zero layout disturbance for end users before AdMob phase.
