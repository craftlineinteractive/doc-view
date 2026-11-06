# 01. Design Tokens: Doc View Precision Design System

This document codifies the design tokens for **Doc View** based on the approved phone frames (393 × 852 pt baseline) inside `doc_view_mockups/`.

Per project governance rules:
> **Source of truth order:** 393 × 852 phone frames in `screen.png` / `code.html` > `00_design_system/DESIGN.md` > `README.md`.
> Any conflict between `DESIGN.md` and the HTML phone frames is resolved in favor of the **HTML phone frames**.

---

## 1. Color Palette

### 1.1 Light Mode
| Token Name | Hex / Value | Usage & Context |
| :--- | :--- | :--- |
| `colorBackground` | `#FFFFFF` | Core canvas background |
| `colorHeaderGradientStart` | `#E9F2FF` | Top app bar & status bar background gradient start |
| `colorHeaderGradientEnd` | `#FFFFFF` | Top app bar gradient transition into pure white body |
| `colorSurface` | `#F3F5FA` | Category tiles, file cards, tool cards, input fields |
| `colorSurfaceHover` | `#E9EDF6` | Pressed / hover state on cards and tiles |
| `colorSurfaceAlt` | `#F8FAFD` | Native ad container, list row highlight, banner background |
| `colorDividerBand` | `#F1F3F8` | 6pt – 8pt structural section separator band |
| `colorHairline` | `#E6E9F0` | 1px crisp outline border around cards, dialogs, and dividers |
| `colorTextPrimary` | `#11141C` | Primary titles, document names, dialog headlines |
| `colorTextSecondary` | `#8A8F9C` | Metadata (dates, sizes, folder paths, inactive labels) |
| `colorSectionHeader` | `#8A94AE` | Uppercase section header text (`EDIT & MANAGE`, etc.) |
| `colorPrimaryBlue` | `#1A66E8` | Primary CTA buttons, FAB background, active tabs, brand icon |
| `colorInteractiveBlue` | `#2F7BEA` | Accent folder glyphs, active filter pill, link text |
| `colorBlueTint` | `#E8F0FE` | Selection highlight overlay, icon background container |
| `colorSheetScrim` | `rgba(17, 20, 28, 0.45)` | Dimmed backdrop scrim behind modal sheets and dialogs |
| `colorReaderCanvas` | `#EEF0F5` | Neutral document reader canvas surrounding white pages |
| `colorSkeletonBase` | `#E9EDF5` | Skeleton placeholder base |
| `colorSkeletonHighlight` | `#F5F7FB` | Skeleton shimmer sweep highlight |

### 1.2 Dark Mode (Deep Navy)
| Token Name | Hex / Value | Usage & Context |
| :--- | :--- | :--- |
| `colorBackgroundDark` | `#1A1D29` | Deep navy canvas background |
| `colorSurfaceDark` | `#232838` | Dark cards, tiles, inputs, modal sheet surface |
| `colorSurfaceHoverDark` | `#2B3144` | Pressed / hover state on dark cards and tiles |
| `colorDividerBandDark` | `#141722` | Structural section separator band |
| `colorHairlineDark` | `#2A3042` | 1px crisp outline border on dark chassis |
| `colorTextPrimaryDark` | `#FFFFFF` | Pure white titles and high-contrast headlines |
| `colorTextSecondaryDark` | `#858B9C` | Muted secondary labels, timestamps, metadata |
| `colorSectionHeaderDark` | `#7F8AA8` | Uppercase section header text |
| `colorPrimaryButtonDark` | `#1A66E8` | Primary CTA button background |
| `colorActiveBlueDark` | `#4D8FF7` | Vibrant active blue for text links, active tabs & indicators |
| `colorBlueTintDark` | `#1E2A45` | Selection row tint and tool badge background |
| `colorSheetScrimDark` | `rgba(10, 12, 18, 0.65)` | Modal sheet backdrop scrim |
| `colorReaderCanvasDark` | `#11131B` | Chassis behind document (page stays white, not inverted) |
| `colorSkeletonBaseDark` | `#262B3A` | Dark skeleton base |
| `colorSkeletonHighlightDark` | `#30364A` | Dark skeleton sweep highlight |

### 1.3 File Format & Semantic Signifiers
| Category | Primary Glyph Hex | Light Tint Container | Dark Tint Container | Badge Text |
| :--- | :--- | :--- | :--- | :--- |
| **PDF** | `#E02B2B` | `#FDE8E8` | `#3A1E22` | `PDF` |
| **Word** | `#1E5FD8` | `#EDF3FD` | `#1B2A4A` | `DOCX` / `W` |
| **Excel** | `#1E9E4F` | `#EEF9F2` | `#173324` | `XLSX` / `X` |
| **PowerPoint** | `#F26B1D` | `#FEF0E8` | `#38251B` | `PPT` / `P` |
| **TXT** | `#5B6B9A` | `#EFF1F7` | `#242838` | `TXT` |
| **Image** | `#FFB300` | `#FFF8E6` | `#38311B` | `IMG` |
| **Directories** | `#2F7BEA` | `#E8F0FE` | `#1E2A45` | Folder glyph |

### 1.4 Status & Feedback Colors
- **Success**: `#1FA971` (Light container: `#E8F8F0`, Dark: `#1B3B2B`)
- **Warning**: `#F5A524` (Light container: `#FEF6E9`, Dark: `#3A2E19`)
- **Error / Destructive**: `#E5484D` (Light container: `#FDE8E9`, Dark: `#3E1C1E`)

---

## 2. Typography

All typography is rendered using two bundled font families (strictly offline, bundled into `assets/fonts/`):
1. **Space Grotesk** (Display headings, screen titles, brand mark)
2. **Inter** (All metadata, body copy, labels, buttons, badges)

*(Note: JetBrains Mono seen in presentation boards is omitted. Inter with tabular figures is used for all numbers.)*

| Style Name | Font Family | Size | Weight | Line Height | Letter Spacing | Target Elements |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `headlineXl` | Space Grotesk | 32px | 700 (Bold) | 38px | `-0.5px` | Splash title, major onboarding headlines |
| `headlineLg` | Space Grotesk | 24px | 700 (Bold) | 30px | `-0.25px` | Screen titles, onboarding headings |
| `headlineSm` | Space Grotesk | 18px | 600 (SemiBold)| 24px | `0px` | Section titles (`Convert & Create`), App bar titles |
| `titleMd` | Inter | 16px | 700 (Bold) | 22px | `0px` | Document file names, dialog titles, tab active |
| `labelLg` | Inter | 15px | 600 (SemiBold)| 20px | `0px` | Primary CTA buttons (56pt), sheet actions |
| `labelMd` | Inter | 13px | 600 (SemiBold)| 18px | `0px` | Category titles, filter chips, secondary buttons |
| `labelXs` | Inter | 11px | 600 (SemiBold)| 14px | `+0.5px` | Section uppercase tags, bottom nav labels, status pills |
| `bodyLg` | Inter | 15px | 500 (Medium) | 22px | `0px` | Taglines, descriptive sheet subtitles, instructions |
| `bodyMd` | Inter | 13px | 400 (Regular) | 18px | `0px` | Reader text, FAQ body text, dialog explanations |
| `bodySm` | Inter | 12px | 400 (Regular) | 16px | `0px` | Timestamps, file size metadata, row secondary info |
| `captionXs`| Inter | 10px / 9px | 700 (Bold) | 12px | `+0.5px` | Thumbnail format badges (`PDF`, `DOCX`, `AD` pill) |

---

## 3. Spacing, Geometry & Radii

A strict **4pt / 4px spatial grid** governs all layout dimensions.

### 3.1 Dimensions & Heights
- **Page Horizontal Margin**: `20pt` (fixed on all screens)
- **Primary CTA Button Height**: `56pt` (touch hitbox $\ge 56\text{pt}$)
- **Standard Hitbox Minimum**: `48pt × 48pt` (all icon buttons, toggles, chips)
- **File List Row Height**: `68pt` (standard density)
- **Native Ad Row Height**: `68pt` (matching file row rhythm)
- **Input / Search Field Height**: `48pt`
- **Bottom Navigation Bar Height**: `64pt`
- **Docked Adaptive Banner Height**: `60pt`
- **Section Band Divider Height**: `6pt` – `8pt`
- **FAB Dimension**: `56pt × 56pt` (positioned $\ge 16\text{pt}$ above banner)

### 3.2 Corner Radii
| Component | Corner Radius | Notes |
| :--- | :--- | :--- |
| **Card / Category Tile** | `20pt` (`rounded-[20px]`) | Applied to home categories, tool cards, file containers |
| **Primary Button / CTA** | `16pt` (`rounded-2xl`) | Main execution buttons |
| **Modal Bottom Sheet** | `28pt` top corners | Top-left and top-right radii (`RoundedRectangleBorder`) |
| **Modal Dialog** | `24pt` | Centered alert dialogs and confirmation modals |
| **Document Thumbnail** | `10pt` | Preview boxes with 0.5pt inner contrast hairline |
| **Input / Search Field** | `24pt` (pill) or `12pt` | Pill on search bar; 12pt on form inputs |
| **Pills, Chips & AD Badges**| `9999px` (`full`) | Filter chips, page pills, AdMob indicators |

---

## 4. Elevation, Depth & Hairlines

- **Hairline Borders**: `1.0px` solid `#E6E9F0` (light) / `#2A3042` (dark) around tiles, cards, dialogs, and dividers.
- **Light Tonal Shadow**: `BoxShadow(color: Color(0x0F11141C), blurRadius: 20, offset: Offset(0, 4))`
- **Dark Tonal Shadow**: `BoxShadow(color: Color(0x73000000), blurRadius: 24, offset: Offset(0, 4))`
- **Primary FAB Shadow**: `BoxShadow(color: Color(0x591A66E8), blurRadius: 18, offset: Offset(0, 6))`
- **Backdrop Scrim**: `Color(0x7311141C)` (Light) / `Color(0xA60A0C12)` (Dark).

---

## 5. Motion & Accessibility

- **Skeleton Shimmer**: Linear looping gradient sweep over `1400ms`.
  - Light: `#E9EDF5` $\rightarrow$ `#F5F7FB` $\rightarrow$ `#E9EDF5`
  - Dark: `#262B3A` $\rightarrow$ `#30364A` $\rightarrow$ `#262B3A`
- **Button Feedback**: Subtle scale down to `0.96` on touch down with fast `100ms` spring recovery.
- **Bottom Sheet Animation**: `250ms` cubic ease out (`Curves.easeOutCubic`).
- **Reduced Motion**: If the OS reduced motion preference is enabled, shimmer sweeps disable and render solid base placeholders.
- **Text Scale 2.0 Resilience**: All list tiles, category labels, buttons, and bottom sheets wrap or use `TextOverflow.ellipsis` without layout overflow.

---

## 6. Ad Sizes & Policy Rules

- **Docked Adaptive Banner**: Exactly `60pt` height, docked directly above the 64pt bottom navigation bar. Includes persistent `AD` badge (`#8A8F9C`).
- **In-feed Native Row**: Exactly `68pt` height, placed inside scrollable document feeds (Home Recent list, Search result slot 6, Merge PDF step 1). Includes amber `Ad` badge.
- **Interstitial**: Full-screen modal (`393 × 852 pt`) with delayed close circle. **Only triggered after successful tool export**, never on app launch, resume, or tab navigation.
- **$\ge 16\text{pt}$ Touch Buffer**: Persistent vertical and horizontal separation $\ge 16\text{pt}$ between any clickable ad area and any button/FAB.
- **Failure Collapse**: Ad slots must collapse to `0pt` height (`SizedBox.shrink()`) if an ad fails to load or no ad network is available.

---

## 7. Conflicts Between `DESIGN.md` and HTML Frames (Resolved)

| Property | `DESIGN.md` Value | HTML Phone Frame Value | Resolved Value (HTML Wins) | Reason |
| :--- | :--- | :--- | :--- | :--- |
| **Canvas Background** | `surface: #faf8ff` | `bg-white (#FFFFFF)` with pale-blue top header gradient `#E9F2FF` | `#FFFFFF` canvas with `#E9F2FF` header gradient | Phone frames in `02_home/01_home_all_files` use pure white body with header gradient. |
| **Primary Blue** | `primary: #0059ba` | `#1A66E8` / interactive `#2F7BEA` | `#1A66E8` (Active dark: `#4D8FF7`) | All buttons, FABs, and tab indicators in HTML use `#1A66E8`. |
| **Card / Tile Fill** | `surface-container: #ecedf9` | `bg-[#F3F5FA]` | `#F3F5FA` (Light) / `#232838` (Dark) | Applied across all 24 screen mockups. |
| **Divider Band** | Missing / not specified | `bg-[#F1F3F8]` (Light) / `bg-[#141722]` (Dark) | `6pt`–`8pt` band `#F1F3F8` / `#141722` | HTML frames use dedicated divider bands between sections. |
| **Hairline Border** | `outline-variant: #c2c6d5` | `#E6E9F0` (Light) / `#2A3042` (Dark) | `#E6E9F0` / `#2A3042` | Consistent 1px borders in all HTML cards. |
| **Category Card Radius** | `rounded.md: 1.5rem (24px)` | `rounded-[20px]` (20pt) | `20pt` | Category tiles and tool cards explicitly declare `rounded-[20px]`. |
| **Fonts** | Space Grotesk + Inter | Space Grotesk + Inter (some boards mention JetBrains Mono) | Space Grotesk + Inter only | README explicitly directs: no third font; use Inter with tabular figures. |

