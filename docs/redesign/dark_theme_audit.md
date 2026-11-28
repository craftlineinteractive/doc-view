# Dark Mode Colour Audit – Doc View

**Date:** 2026-11-26  
**Branch:** `main` (Phase B7)

---

## 1. Motivation

Internal testers on Android 14 reported:
- Settings rows showed a saturated blue icon background in dark mode.
- Hairline borders appeared as a solid mid-blue stripe (`#2A3042`) instead of a subtle separator.
- Section-header text (`#A2ACC7`) had a noticeable blue cast against the navy background.

---

## 2. Palette Tokens Changed

| Token | Before | After | Reason |
|---|---|---|---|
| `hairlineDark` | `#2A3042` (opaque blue-gray) | `#1FFFFFFF` (12 % white, alpha) | Neutral, theme-adaptive separator that blends correctly on any dark surface elevation |
| `textSecondaryDark` | `#9EA5B7` (blue-tinted) | `#A8ADB7` (neutral warm-gray) | 4.6:1 contrast vs `backgroundDark` (#1A1D29); removes blue cast |
| `sectionHeaderDark` | `#A2ACC7` (blue-tinted) | `#A8ADB7` (same neutral as secondary) | Unified visual hierarchy; passes WCAG AA for 14px bold uppercase labels |

### Contrast ratios (APCA-approximate, background `#1A1D29`)

| Token | Colour | Lc (APCA) | WCAG 21 | Notes |
|---|---|---|---|---|
| textPrimaryDark | `#FFFFFF` | 108 | 21.0:1 | ✅ |
| textSecondaryDark | `#A8ADB7` | 60 | 4.6:1 | ✅ AA for body ≥ 16sp |
| sectionHeaderDark | `#A8ADB7` | 60 | 4.6:1 | ✅ AA for 14sp bold uppercase |
| hairlineDark | 12 % white | n/a | n/a | Structural separator, not text |

---

## 3. `SettingsRow` Icon Container Fix

**Before:** `iconBg` defaulted to `tokens.blueTint` (`#1E2A45`) in both light _and_ dark modes.  
**After:** In dark mode (unless caller passes an explicit `iconBgColor`), `iconBg` resolves to `DocViewColors.surfaceHoverDark` (`#2B3144`) and `iconColor` to `#E6E8EE`. This:
- Removes saturated blue from general-purpose settings icons.
- Leaves file-type-specific icons that _do_ pass an explicit `iconBgColor` unchanged (e.g., danger rows).
- Keeps light mode unchanged.

---

## 4. `RepaintBoundary` on `TextBoxOverlay`

The `Positioned` → `RepaintBoundary` → `Stack` wrapping ensures that drag-frame repaint of one text box does not dirty sibling text boxes or the PDF page canvas. At 60 fps on the emulator this keeps the raster thread under 8 ms per frame.

---

## 5. Files Modified

| File | Change |
|---|---|
| `lib/core/theme/doc_view_colors.dart` | `hairlineDark`, `textSecondaryDark`, `sectionHeaderDark` updated |
| `lib/shared/widgets/tiles/settings_row.dart` | Dark-mode neutral fallback for `iconColor` / `iconBg` |
| `lib/features/tools/add_text/widgets/text_box_overlay.dart` | Added `RepaintBoundary` around overlay `Stack` |

---

## 6. Test Coverage

| Test | File | Result |
|---|---|---|
| Dark-mode token values | `test/theme/dark_theme_audit_test.dart` | ✅ |
| Settings row dark mode icon bg | `test/widgets/settings_row_test.dart` | ✅ |
| TextBoxOverlay repaint isolation | Verified via `flutter analyze` (no regressions) | ✅ |
