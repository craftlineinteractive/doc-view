# 08. New & Restructured Screens (Phase G2)

This document catalogs every screen and bottom sheet added or restructured in **Phase G2**, mapping each to the existing screen pattern it follows, the shared components reused, the three newly introduced shared components, and the native Android/iOS File Manager integration contract.

---

## Allowed New Shared Components

| Component | Path | Purpose & Accessibility |
| --- | --- | --- |
| `StarRatingBar` | `lib/shared/widgets/settings/star_rating_bar.dart` | 5 tappable star buttons (`>= 48x48` each), localized `"N stars"` semantics, reading-direction RTL ordering, reduced-motion aware (`MediaQuery.disableAnimationsOf(context)` skips scale animation). |
| `LanguageTile` | `lib/shared/widgets/settings/language_tile.dart` | Radio selection row (`>= 56pt` height) matching Scan Settings radio geometry, with native name title, optional English subtitle, optional `(not translated)` debug badge, and full button/selected semantics. |
| `SettingsFooter` | `lib/shared/widgets/settings/settings_footer.dart` | Centered `"Version X.Y.Z (N)"` footer with `"Version X.Y.Z build N"` semantics, debug-only long-press hook for `ComponentGalleryScreen`, and a small `"Open-source licenses"` `TextButton` directly underneath (approved deviation). |

---

## Screen & Sheet Inventory

### 1. Settings Tab (`lib/features/settings/settings_screen.dart`)
- **Existing screen copied**: Previous `SettingsScreen` (`07_settings/01_settings_tab`).
- **Shared components reused**: `DocScaffold`, `SettingsGroupCard`, `SettingsRow`, `SettingsSectionHeader`, `Shimmer`, `SkeletonBox`, `ThemeSelectionSheet`, `AdBannerSlot` (via `DocScaffold`).
- **New shared components used**: `SettingsFooter`.
- **Structure (exact order)**:
  1. **Top group**: `File manager`, `FAQ`, `Share` (hidden when `AppConstants.storeShareUrl` is empty).
  2. **General**: `Scan settings`, `App theme`, `Language` (shown in release only when `> 1` shipped language; always shown in debug), `Rate us`.
  3. **Others** *(hidden entirely when all 4 rows are hidden)*: `Add Widget` (`widgetsEnabled`), `Terms of use` (`termsOfUseUrl`), `Privacy policy` (`privacyPolicyUrl`), `Manage subscriptions` (`premiumEnabled`).
  4. **Footer**: Centered `SettingsFooter` (`Version 1.0.0 (1)` + `Open-source licenses` link).
- **Removed from Settings**: `Import files` (moves to Tools in G4; Home FAB continues importing), `Rescan now` (lives in Scan settings), `Clear recent history` (moved to Scan settings History section), `Send feedback` (lives inside FAQ and Rate drawer).

### 2. Language Screen (`lib/features/settings/language_screen.dart`, route `/settings/language`)
- **Existing screens copied**: `ScanSettingsScreen` (grouped radio card layout) + `SearchScreen` (`DocSearchField` pill search bar).
- **Shared components reused**: `DocScaffold`, `DocSubAppBar`, `DocSearchField`, `SettingsGroupCard`, `DocEmptyState`.
- **New shared components used**: `LanguageTile`.
- **Behavior**:
  - Lists `"System default"` first (resets `localeCode` to `null`), followed by entries from `LanguageCatalog`.
  - Release builds display **only shipped languages** backed by ARB files in `AppLocalizations.supportedLocales`.
  - Debug builds also display `Pseudo-locale (en_XA)` and planned unshipped languages (`hi`, `gu`, `es`, `pt-BR`, `fr`, `de`, `ar`, `id`, `ru`) badged `(not translated)`.
  - Selecting a shipped language (or `en_XA` in debug) updates `localeProvider` live without app restart and persists to `SettingsRepository`.

### 3. Rate Us Drawer (`lib/features/settings/widgets/rate_us_sheet.dart`)
- **Existing screen copied**: `ThemeSelectionSheet` / modal bottom sheets built on `DocBottomSheet`.
- **Shared components reused**: `DocBottomSheet`, `DocTonalButton`.
- **New shared components used**: `StarRatingBar`.
- **Compliance & non-gating rules**:
  - Shows `"Rate Doc View"`, `"Your feedback helps us improve"`, and 5 interactive stars.
  - After selecting **any** star value (1–5), displays a short localized message (high / medium / low wording only) and **always** shows the exact same two equal-size, equal-weight `DocTonalButton` actions in order:
    1. `"Rate on Google Play"` (opens `storeRateUrl`; hidden only when `storeRateUrl` is empty; supports debug override).
    2. `"Help & feedback"` (closes sheet and navigates to `/faq` with `extra: {'fromRating': true}`).
  - Plus a `"Not now"` text button. Never gates routes by star count, never auto-opens the store, and never prompts automatically.

### 4. FAQ with Rating Highlight (`lib/features/settings/faq_screen.dart`, route `/faq`)
- **Existing screen copied**: Existing `FaqScreen` (`07_settings/03_faq`).
- **Shared components reused**: `DocScaffold`, `DocIconButton`, `InfoBanner` (highlight style with `tokens.primaryBlue`).
- **New shared components used**: None.
- **Behavior**:
  - Accepts optional `fromRating` boolean (passed via GoRouter `state.extra`).
  - Normal FAQ (`fromRating == false`) renders without any banner.
  - When `fromRating == true`, displays `InfoBanner` above the topics list with `"Sorry to hear that. Browse the answers below or contact us; we read every message."` and a `"Contact us"` button (launches `mailto:` to `supportEmail` with app version/build in subject & body; hidden when `supportEmail` is empty).

### 5. Scan Settings History Section (`lib/features/settings/scan_settings_screen.dart`)
- **Existing screen copied**: Existing `ScanSettingsScreen` (`07_settings/02_settings_sub_screens`).
- **Shared components reused**: `SettingsSectionHeader`, `SettingsGroupCard`, `SettingsRow`, `showDocConfirmDialog`.
- **New shared components used**: None.
- **Behavior**:
  - Adds a `"History"` section with `"Clear recent history"` reusing the existing destructive confirmation dialog, `FileActionsController.clearRecentHistory()`, and localized snackbar.
  - Keeps `"Rescan now"` on Android and displays the localized `"Last scan: ..."` timestamp subtitle directly underneath.

### 6. Version Footer (`lib/shared/widgets/settings/settings_footer.dart`)
- **Existing screen copied**: Replaces the previous Settings `About` card rows (`Version` and `Open-source licenses`).
- **Shared components reused**: Material `TextButton`, `showLicensePage`, `DocViewTypography`, `DocViewTokens`.
- **New shared components used**: `SettingsFooter`.
- **Approved deviation**: Includes a small `"Open-source licenses"` text link centered underneath `"Version 1.0.0 (1)"` so third-party license attribution remains accessible.

---

## System File Manager MethodChannel Contract

- **Channel Name**: `com.craftlineinteractive.docview/file_manager`
- **Method**: `openSystemFileManager` -> returns `Future<bool>`
- **Android Implementation** (`android/app/src/main/kotlin/com/craftlineinteractive/docview/MainActivity.kt`):
  1. Attempts `Intent(Intent.ACTION_VIEW)` with URI `content://com.android.externalstorage.documents/document/primary%3ADownload` and MIME type `vnd.android.document/directory` (`FLAG_ACTIVITY_NEW_TASK`) — verified in G0 Spike 4 (`docs/spikes/g0_report.md`).
  2. Falls back to URI-only `Intent(Intent.ACTION_VIEW, downloadDocsUri)`.
  3. Falls back to `Intent("android.intent.action.VIEW_DOWNLOADS")`.
  4. If no activity can handle any intent or an exception occurs, catches safely and returns `false` (never crashes).
- **iOS Implementation** (`lib/data/services/file_manager_service.dart`):
  - Attempts `url_launcher` with `shareddocuments://` (`LaunchMode.externalApplication`); returns `false` if unavailable.
- **Dart Fallback** (`SettingsScreen._openFileManager`):
  - If `FileManagerService.openSystemFileManager()` returns `false`, navigates cleanly to the in-app `/directories` screen (`DirectoriesScreen`).
