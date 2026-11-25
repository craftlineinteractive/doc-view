# Doc View Application Size Report & Optimization Analysis

## 1. Overview & Build Metrics

This report documents the size composition of Doc View (version 1.0.0+1) built in release mode with R8 code shrinking and resource minification enabled (`isMinifyEnabled = true`, `isShrinkResources = true`).

- **Architecture**: `android-arm64` (Standard target for modern Android devices).
- **ProGuard / R8 Status**: Enabled with active tree-shaking and dead-code stripping.
- **Icon Font Tree-Shaking**:
  - `CupertinoIcons.ttf`: 257.6 KB → 848 bytes (99.7% reduction).
  - `MaterialIcons-Regular.otf`: 1.64 MB → 28.2 KB (98.3% reduction).

---

## 2. Top Size Contributors Breakdown

| Component / Layer | Raw Size (Uncompressed) | Estimated Compressed AAB Impact | Description / Contents |
|---|---|---|---|
| **Arimo Fonts (`assets/fonts/Arimo-*`)** | 2.35 MB (2,348,892 bytes) | ~1.15 MB | Metric-compatible Arial replacement fonts required for clean on-device PDF text reflow and PDF to Word extraction. |
| **Inter & Space Grotesk Fonts** | 1.92 MB (1,920,844 bytes) | ~950 KB | Primary UI typography for headings, labels, and readable body text. |
| **Branding Assets (`docview_icon.png`)** | 1.30 MB (1,303,268 bytes) | ~450 KB | High-resolution 1024x1024 branding icon asset. |
| **Syncfusion PDF (`syncfusion_flutter_pdf`)** | ~3.8 MB (Native + Dart bytecode) | ~1.4 MB | PDF parsing, table extraction, form editing, and PDF manipulation engine. |
| **Offline Document Viewer & WebViews** | ~3.2 MB (AAR + JS assets) | ~1.2 MB | Embedded browser engine and styling assets for offline Word (DOCX), Excel (XLSX), and PPTX rendering. |
| **Google Mobile Ads SDK** | ~2.8 MB (Play Services Ads AARs) | ~950 KB | Native Android AdMob SDK, UMP consent libraries, and Privacy Sandbox measurement APIs. |
| **PDFium Native Binaries (`libpdfium.so`)** | ~14.5 MB | ~5.8 MB | High-performance C++ PDF rendering engine compiled for `arm64-v8a`. |
| **Flutter Engine (`libflutter.so`)** | ~12.2 MB | ~4.9 MB | Core Flutter framework runtime and Impeller/OpenGL graphics pipeline. |

---

## 3. Recommended Reductions (For Future Optimization)

The following reductions are **RECOMMENDED** for future updates (do not apply without owner approval):

1. **Font Subsetting for Arimo**:
   - *Current*: Full unicode character tables across Regular, Bold, Italic, and BoldItalic (2.35 MB total).
   - *Recommendation*: Use `pyftsubset` to strip unused non-Latin glyph blocks (e.g. CJK, archaic scripts) or dynamic on-demand font loading via Google Fonts package. Estimated savings: **~1.4 MB**.
2. **Optimize Branding PNG Asset**:
   - *Current*: `assets/images/docview_icon.png` is an uncompressed 32-bit PNG (1.3 MB).
   - *Recommendation*: Convert to WebP format or compress with `pngquant` / `oxipng`. Estimated savings: **~900 KB**.
3. **Selective ABI Bundling**:
   - Distribute strictly via Android App Bundle (`.aab`) rather than fat APKs. Google Play automatically serves split APKs containing only the user's specific device ABI (`arm64-v8a`), stripping unused 32-bit `armeabi-v7a` and `x86_64` binaries on download.
