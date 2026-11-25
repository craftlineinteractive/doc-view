# Doc View — Document Reader & Productivity Suite for Android

[![Flutter](https://img.shields.io/badge/Flutter-3.44.9-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart)](https://dart.dev)
[![Target SDK](https://img.shields.io/badge/Android%20Target%20SDK-36-3DDC84?logo=android)](https://developer.android.com)
[![Tests](https://img.shields.io/badge/Tests-781%2B%20Passing-success)](#testing--verification)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

**Doc View** is an ultra-fast, privacy-first offline document reader, file manager, and comprehensive PDF productivity toolkit designed natively for Android.

---

## Key Features

### 1. Document Reading & Viewing
- **High-Performance PDF Engine**: Smooth vertical scrolling, pinch-to-zoom, jump-to-page slider, outline/bookmarks navigation, and instant full-text search with match counters.
- **Office Document Viewer**: Embedded on-device rendering for Microsoft Word (`.docx`), Excel spreadsheets (`.xlsx` interactive grid), and PowerPoint presentations (`.pptx`).
- **Text & Images**: Crisp full-screen TXT reader and image gallery viewer.
- **Themes**: Full support for System, Light, and True Dark themes with tokenized contrast.

### 2. Complete PDF Toolkit
- **Scan to PDF**: Photograph paper documents with on-device perspective correction and multi-page bundling.
- **Image to PDF**: Convert camera photos and gallery images into clean PDF documents.
- **Merge PDF**: Combine multiple PDFs with visual order rearrangement.
- **Split PDF**: Extract page ranges or burst documents into individual single-page files.
- **Manage Pages**: Rotate, reorder, or delete pages in any PDF file.
- **Annotate & Draw**: Smooth vector ink drawing, highlight passages, underline, and color selection.
- **Add Text**: Place custom text blocks with customizable font size and colors.
- **Digital Signatures**: Create and store reusable vector signatures and place them anywhere on contracts.
- **PDF to Word**: Extract textual content from PDF files into standard `.docx` files.
- **Print**: Direct Android printing support for physical and cloud-connected printers.

### 3. Automatic Organization & File Management
- **Universal Storage Scanner**: Automatically indexes documents across internal storage and SD card folders.
- **Folder Browser (Directories)**: Physical directory navigation for storage organization.
- **Recycle Bin**: 30-day safety retention with one-tap restore and automatic expired file cleanup.
- **Recents & Bookmarks**: Fast access to favorite and recently opened documents.

### 4. Android Home Screen Widgets & Quick Access
- **Recent Files Widget (4x2)**: Glance at your top 5 recently opened documents and launch them directly.
- **Quick Tools Widget (4x1)**: One-tap shortcuts for Scan, Image to PDF, Search, and Import.
- **Quick Access Notification**: Optional low-importance persistent notification drawer with tool shortcuts.

---

## Privacy & Security Architecture

Doc View is built from the ground up on **Local-First** principles:
1. **Zero Document Uploads**: All document parsing, rendering, text extraction, scanning, and file conversions occur **100% locally** on the device.
2. **Data Minimization in Widgets**: Home screen widgets store only minimal metadata (`id`, `name`, `type`, `modified`). Absolute filesystem paths are strictly stripped.
3. **Protected Digital Signatures**: User signature paths are stored in internal sandboxed app storage and excluded from Android Cloud Backups.
4. **Minimal Permissions**: Transitive media permissions (`READ_MEDIA_*`) and `FOREGROUND_SERVICE` are explicitly stripped.

---

## Getting Started

### Prerequisites
- **Flutter SDK**: `3.44.9` (or compatible channel)
- **Dart SDK**: `3.12.2`
- **Android SDK**: `compileSdk 36`, `minSdk 24`, Java 17+
- **Android Emulator or Device**: Android 7.0+ (API 24 to 36)

### Installation
Clone the repository and fetch dependencies:
```bash
git clone https://github.com/craftlineinteractive/doc-view.git
cd doc-view
flutter pub get
```

### Running Debug Build
```bash
flutter run
```

---

## Testing & Verification

Doc View maintains an extensive test suite covering unit logic, Riverpod providers, widget UI, accessibility, and security guardrails:

```bash
# Run static analysis
flutter analyze

# Run full test suite (780+ tests)
flutter test

# Run security guardrail checks
flutter test test/ads/no_real_ad_ids_test.dart
flutter test test/premium/no_price_literals_test.dart
flutter test test/l10n/no_hardcoded_strings_test.dart
```

---

## Building for Production (Release AAB)

Doc View includes automated fail-safe checks in `android/app/build.gradle.kts` to prevent accidental releases with debug keystores or Google test ad IDs:

1. Copy `android/key.properties.example` to `android/key.properties` and configure your release upload keystore credentials (see `docs/release/keystore.md`).
2. Build the obfuscated Android App Bundle with R8 shrinking:
   ```bash
   flutter build appbundle --release \
     --obfuscate \
     --split-debug-info=../docview_symbols \
     --dart-define=ADMOB_BANNER_ID="YOUR_BANNER_ID" \
     --dart-define=ADMOB_NATIVE_ID="YOUR_NATIVE_ID" \
     --dart-define=ADMOB_INTERSTITIAL_ID="YOUR_INTERSTITIAL_ID" \
     -PadmobAppId="YOUR_ADMOB_APP_ID"
   ```

---

## Documentation

Comprehensive project documentation is available in the `docs/` directory:
- **Architecture & Redesign**: [`docs/redesign/`](docs/redesign/)
- **AdMob & Placement Compliance**: [`docs/redesign/06_ad_placement_audit.md`](docs/redesign/06_ad_placement_audit.md)
- **App Widgets & Notification Evidence**: [`docs/redesign/g8_evidence.md`](docs/redesign/g8_evidence.md)
- **Advertising & UMP Evidence**: [`docs/redesign/g9_evidence.md`](docs/redesign/g9_evidence.md)
- **Store Listing & Policy Documents**: [`docs/release/store/`](docs/release/store/)
- **Release Hardening & Keystore Guide**: [`docs/release/keystore.md`](docs/release/keystore.md)
- **Size Optimization Report**: [`docs/release/size_report.md`](docs/release/size_report.md)
- **Security Audit Matrix**: [`docs/release/security_review.md`](docs/release/security_review.md)

---

## License

This project is licensed under the **Apache License, Version 2.0**. See the [LICENSE](LICENSE) file for details.

Third-party libraries and fonts used in this application:
- **Arimo Fonts**: Licensed under the SIL Open Font License, Version 1.1 ([assets/fonts/LICENSE-Arimo.txt](assets/fonts/LICENSE-Arimo.txt)).
- **Inter Fonts**: Licensed under the SIL Open Font License, Version 1.1 ([assets/fonts/Inter-OFL.txt](assets/fonts/Inter-OFL.txt)).
- **Space Grotesk Fonts**: Licensed under the SIL Open Font License, Version 1.1 ([assets/fonts/SpaceGrotesk-OFL.txt](assets/fonts/SpaceGrotesk-OFL.txt)).
- **Syncfusion PDF**: Used under the [Syncfusion Community License](docs/release/syncfusion_license.md).
