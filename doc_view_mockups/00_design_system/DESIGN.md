---
name: Precision Doc Engine
colors:
  surface: '#faf8ff'
  surface-dim: '#d8d9e5'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#ecedf9'
  surface-container-high: '#e6e7f3'
  surface-container-highest: '#e0e2ee'
  on-surface: '#181b24'
  on-surface-variant: '#424753'
  inverse-surface: '#2d3039'
  inverse-on-surface: '#eff0fc'
  outline: '#727785'
  outline-variant: '#c2c6d5'
  surface-tint: '#005bbf'
  primary: '#0059ba'
  on-primary: '#ffffff'
  primary-container: '#1f71e0'
  on-primary-container: '#fefcff'
  inverse-primary: '#acc7ff'
  secondary: '#0054cb'
  on-secondary: '#ffffff'
  secondary-container: '#276def'
  on-secondary-container: '#fefcff'
  tertiary: '#545d68'
  on-tertiary: '#ffffff'
  tertiary-container: '#6d7581'
  on-tertiary-container: '#fdfcff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d7e2ff'
  primary-fixed-dim: '#acc7ff'
  on-primary-fixed: '#001a40'
  on-primary-fixed-variant: '#004492'
  secondary-fixed: '#dae2ff'
  secondary-fixed-dim: '#b1c5ff'
  on-secondary-fixed: '#001847'
  on-secondary-fixed-variant: '#00409f'
  tertiary-fixed: '#dbe3f1'
  tertiary-fixed-dim: '#bfc7d4'
  on-tertiary-fixed: '#141c26'
  on-tertiary-fixed-variant: '#3f4752'
  background: '#faf8ff'
  on-background: '#181b24'
  surface-variant: '#e0e2ee'
typography:
  headline-xl:
    fontFamily: Space Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 38px
  headline-lg:
    fontFamily: Space Grotesk
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 30px
  headline-sm:
    fontFamily: Space Grotesk
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '700'
    lineHeight: 22px
  label-lg:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 18px
  label-xs:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
  body-lg:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '500'
    lineHeight: 22px
  body-md:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 0.75rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

This design system drives a high-efficiency mobile document reader and PDF manipulation suite tailored for power users, students, and mobile professionals. Designed natively for modern handheld form factors (baseline 393 × 852 pt), the visual identity balances the geometric rigor of modern technical workspaces with pristine utilitarian legibility. 

The emotional tone is reliable, swift, and distraction-free: files must open instantaneously, tools must feel industrial-grade, and monetization surfaces (such as docked AdMob containers) must coexist cleanly without compromising workflow ergonomics. The style merges crisp technical structuralism with soft-radius surfaces—employing hairline delineations, tactile surface containers, and vibrant file-format signifiers.

## Colors

The palette is engineered around high legibility, rigorous typographic contrast, and fast cognitive recognition of diverse file formats.

### Core Semantic Roles
- **Primary & Interactive Blue (`#2F7BEA`, `#1A66E8`)**: Drives key execution paths, folder directory nodes, and active state highlights. In dark mode, interactives shift to vibrant Active Blue (`#4D8FF7`) for reduced halation.
- **Tint Bases (`#E8F0FE` light / `#1E2A45` dark)**: Used for selection overlays, tool badge backdrops, and active category highlights.
- **Text & Structure**: Light mode anchors onto deep carbon text (`#11141C`) over an elevated tinted top header gradient (`linear-gradient(180deg, #E9F2FF 0%, #FFFFFF 100%)`). Dark mode deploys a deep navy substrate (`#1A1D29`) with neutral high-contrast white text (`#FFFFFF`) and slate support tones (`#858B9C`).

### File Format & Semantic Signifiers
- **PDF**: `#E02B2B`
- **Word**: `#1E5FD8`
- **Excel**: `#1E9E4F`
- **PowerPoint**: `#F26B1D`
- **TXT**: `#5B6B9A`
- **Image**: `#FFB300`
- **Directories**: `#2F7BEA`
- **System States**: Success (`#1FA971`), Warning (`#F5A524`), Error (`#E5484D`)

## Typography

The type hierarchy creates deliberate friction between technical header architecture and fast continuous body scanning.

- **Display & Section Anchors (`Space Grotesk`)**: Headlines communicate the structural, tool-driven nature of an engineering-focused document workbench.
- **Data, Navigation & Body (`Inter`)**: All high-density metadata (byte sizes, timestamps, pagination, labels, file titles) utilizes Inter with explicit weight assignments:
  - **Bold (700)**: File titles and prominent dialog headlines.
  - **SemiBold (600)**: Interactive buttons, tab bars, filter chips, and section meta labels (`#8A94AE` / `#7F8AA8`).
  - **Medium (500) & Regular (400)**: Reading passages, list descriptions, and file path breadcrumbs.

## Layout & Spacing

A strictly disciplined 4pt/4px spatial grid governs the layout, anchored to an iPhone standard canvas width of 393pt.

- **Page Margins**: Fixed at 20pt (`1.25rem`) on horizontal canvas edges.
- **Docked Heights**:
  - Docked Primary Action / Bottom Bar: 64pt.
  - Docked Adaptive AdMob Banner: Exactly 60pt with an integrated neutral `AD` pill badge.
  - Minimum touch target: 48pt × 48pt across all icons, hitboxes, and overflow toggles.
- **Section Banding**: Clear visual rhythm using 8pt divider bands (`#F1F3F8` light / `#141722` dark) to partition recent documents, toolkit operations, and system folders without creating jarring drop shadows.

## Elevation & Depth

Visual hierarchy prioritizes content-first planar surfaces and tactile hairline boundaries rather than dramatic volumetric drop shadows.

- **Hairline Borders**: 1px crisp strokes (`#E6E9F0` in light mode, `#2A3042` in dark mode) wrap file tiles, preview boxes, and modal dialogs.
- **Surface Elevation**: Stacked panels (sheets, floating toolbars, contextual popovers) rely on layered tonal contrast (`#F3F5FA` on `#FFFFFF` in light mode; `#232838` on `#1A1D29` in dark mode) supplemented with subtle ambient diffusion: `0 4px 20px rgba(17, 20, 28, 0.06)` for light mode and `0 4px 24px rgba(0, 0, 0, 0.45)` for deep navy mode.
- **Modals & Bottom Sheets**: Rendered with dimming backdrop scrims (`rgba(17, 20, 28, 0.40)`) and a fixed 28pt top corner radius.

## Shapes

The design uses balanced, rounded geometries to keep the technical document environment tactile and comfortable for one-handed thumb interaction.

- **Card / Category Tile Radius**: 20pt.
- **Interactive Action Buttons**: 16pt (with full-width primary CTA height pinned at 56pt).
- **Document & Page Thumbnails**: 10pt with an inner 0.5pt hairline border to preserve preview contrast.
- **Sheets**: 28pt top corners for interactive drag modals and utility drawers.
- **Pills & Chips**: Fully pill-shaped (`9999px`) for filter tags, status notifications, and AdMob badges.

## Components

### Buttons & CTAs
- **Primary Button**: 56pt height, 16pt border radius, filled with `#1A66E8` (or `#4D8FF7` active dark). Text styled in `Inter SemiBold` 16pt white.
- **Ghost / Tool Bar Actions**: 48pt minimum hitbox, transparent fill, 12pt inner padding, highlighting to `#E8F0FE` / `#1E2A45` on active press.

### File & Category Tiles
- Encased in 20pt radius containers (`#F3F5FA` light, `#232838` dark) bounded by 1px hairline strokes.
- Contain a dedicated leading 10pt radius document thumbnail or color-coded file badge (e.g., `#E02B2B` for PDF), primary file title in `Inter Bold`, and trailing meta info in `Inter Regular` `#8A8F9C`.

### Input & Search Fields
- 48pt height, 12pt corner radius, background `#F3F5FA` (`#232838` in dark mode) with hairline borders that glow to `#2F7BEA` when focused. Clear button and voice search hitboxes pinned at 48pt minimum.

### AdMob Container
- Docked height strictly 60pt. Background matches surface background with a 1px top hairline divider (`#E6E9F0` / `#2A3042`).
- Features a standardized 16pt × 10pt `AD` indicator badge (`Inter SemiBold`, 9pt, text `#8A8F9C`, border 1px solid `#8A8F9C`).

### Skeleton Loading State
- Applied to file cards and document grid placeholders during index caching.
- Light mode shimmers between `#E9EDF5` and `#F5F7FB`.
- Dark mode shimmers between `#262B3A` and `#30364A` over a continuous 1.4s sweep.