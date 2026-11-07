# Task Plan: Phase 1 (R-B) - Foundation, Tokens, Theme, & Shared Components

## Goal
Implement the design foundation, font assets, theme system, and shared component library according to `docs/redesign/*` and `doc_view_mockups/README.md`. No screen redesigns yet; keep existing screens and tests passing.

## Steps
- [ ] Step 1: Download & bundle OFL font files (Inter 400, 500, 600, 700; Space Grotesk 600, 700) with OFL licenses in `assets/fonts/` and register in `pubspec.yaml`
- [ ] Step 2: Release size baseline measurement (`flutter build apk --release --split-per-abi --target-platform android-arm64 --analyze-size`) before adding `material_symbols_icons`
- [ ] Step 3: Add `material_symbols_icons` package, build release again, measure size delta. If >3MB increase, revert to Flutter built-in icons; create central `AppIcons` class
- [ ] Step 4: Implement Theme system in `lib/core/theme/` (`AppColors`, `DocViewTokens` ThemeExtension, `DocViewTypography`, refactored `app_theme.dart`)
- [ ] Step 5: Configure Android edge-to-edge system UI styling
- [ ] Step 6: Implement Shared Components in `lib/shared/widgets/`:
  - Scaffolds & Navigation (`DocScaffold`, `DocBottomNavBar`)
  - App Bars (`DocHomeAppBar`, `DocSubAppBar`, `DocSelectionAppBar`, `DocSearchAppBar`)
  - Tabs, Filters, Breadcrumbs (`DocUnderlineTabs`, `DocFilterChipRow`, `DocBreadcrumbBar`)
  - Tiles & Rows (`CategoryTile`, `FileTypeGlyph`, `FileTypeBadge`, `FileRow`, `FolderRow`, `ImageGridTile`)
  - `FileThumbnail` (with abstract `ThumbnailSource` and glyph/skeleton fallbacks)
  - Button Family (`DocPrimaryButton`, `DocSecondaryButton`, `DocTonalButton`, `DocDestructiveButton`, `DocTextButton`, `DocIconButton`, `DocFab`, `DocBottomActionBar`)
  - Input Family (`DocSearchField`, `DocTextField`, `DocSegmentedControl`, `DocCheckbox`, `DocRadio`, `DocSwitch`)
  - Modal Family (`DocBottomSheet`, `OptionsListTile`, `DocDialog`, `ProgressSheet`, `ResultSheet`, `DocSnackbar`)
  - Status/Info (`InfoBanner`, `PageNumberPill`, `DocEmptyState`, `DocErrorState`, `DocPermissionRequiredState`, `SettingsRow`, `SectionHeader`, `ExpandableFaqCard`)
  - Tool Components (`ToolCard`, `ReorderablePageRow`, `DashedAddCard`, `OnboardingPageIndicator`)
- [ ] Step 7: Implement unified `Shimmer` animation controller & skeleton primitives (file row, tile grid, folder row, tool card, settings row, PDF page, ad slot; reduced motion support)
- [ ] Step 8: Implement Ad Placeholder widgets (`AdBannerSlot` with 0-collapse, `NativeAdRow`, `NativeAdCard`, `InterstitialPlaceholder` with 5s countdown; 16pt clearance enforcement)
- [ ] Step 9: Implement Debug Component Gallery (`kDebugMode` only, accessible via long-press on Settings version row, light/dark + text scale 1.0/2.0)
- [ ] Step 10: Write widget tests for top 10 components; verify all 50+ tests pass and `flutter analyze` has 0 issues
- [ ] Step 11: Emulator run & manual verification; report release sizes, created files, and any deviations
