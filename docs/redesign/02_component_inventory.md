# 02. Component Inventory: Doc View Design System

This inventory catalogs every reusable UI component required to implement the redesign of **Doc View** based on the approved mockups in `doc_view_mockups/` and section 8 of `README.md`.

---

## 1. Theme & Design Tokens

### `DocViewColors` & `DocViewTypography`
- **Proposed Path**: `lib/core/theme/doc_view_theme.dart`, `lib/core/theme/doc_view_colors.dart`, `lib/core/theme/doc_view_typography.dart`
- **Class Names**: `DocViewColors`, `DocViewTypography`, `DocViewThemeExtension` (extends `ThemeExtension<DocViewThemeExtension>`)
- **Props / Properties**:
  - Light and Dark palette references (see `01_design_tokens.md`).
  - Semantics colors for 6 file types (PDF, Word, Excel, PPT, TXT, Image).
  - Space Grotesk + Inter text styles with hardcoded weights, sizes, and line-heights.
- **States**: `ThemeMode.system`, `ThemeMode.light`, `ThemeMode.dark`.
- **Mockup Usage**: Universal across all 24 screen folders.

---

## 2. Navigation & Layout Scaffolding

### `DocScaffold`
- **Proposed Path**: `lib/core/widgets/doc_scaffold.dart`
- **Class Name**: `DocScaffold`
- **Description**: Standard root scaffold handling safe areas, background gradients, floating action button layout, docked banner slot, and optional bottom navigation bar.
- **Props**:
  - `Widget? appBar`: Custom app bar.
  - `Widget body`: Main screen content.
  - `Widget? floatingActionButton`: FAB (automatically positioned $\ge 16\text{pt}$ above docked ad banner).
  - `Widget? bottomNavigationBar`: Typically `DocBottomNavBar`.
  - `bool showDockedBanner`: Defaults to `true` (can be suppressed, e.g. during selection mode).
  - `bool applyHeaderGradient`: When `true`, paints `#E9F2FF` to `#FFFFFF` gradient behind the app bar in Light mode.
- **Mockup Usage**: Folders `02_home_all_files`, `03_home_recent_and_bookmarks`, `06_tools_tab`, `07_settings`.

### `DocBottomNavBar`
- **Proposed Path**: `lib/core/widgets/doc_bottom_nav_bar.dart`
- **Class Name**: `DocBottomNavBar`
- **Description**: Persistent 3-tab navigation bar with exact 64pt height, filled active icon, outlined inactive icon, 11px label, and top hairline border.
- **Tabs**:
  1. `All files` (Icon: `folder` / `folder_open`)
  2. `Tools` (Icon: `build` / `build_outlined` or `handyman`)
  3. `Settings` (Icon: `settings` / `settings_outlined`)
- **Props**:
  - `int currentIndex`: 0, 1, or 2.
  - `ValueChanged<int> onTap`: Callback when tab is selected.
- **Styling**:
  - Background: Light `#FFFFFF`, Dark `#1A1D29`.
  - Top border: 1px `#E6E9F0` (Light) / `#2A3042` (Dark).
  - Active color: `#1A66E8` (Light) / `#4D8FF7` (Dark).
  - Inactive color: `#8A8F9C` (Light) / `#858B9C` (Dark).
- **Mockup Usage**: Folders `02_home_all_files`, `03_home_recent_and_bookmarks`, `06_tools_tab`, `07_settings`.

---

## 3. App Bar Family

### `DocHomeAppBar`
- **Proposed Path**: `lib/core/widgets/doc_app_bar.dart`
- **Class Name**: `DocHomeAppBar`
- **Description**: Top header for the Home tab. Features app title "Doc View" (Space Grotesk 24pt Bold), search icon pill/button, and selection mode entry action.
- **Props**:
  - `VoidCallback onSearchTap`: Opens `/search`.
  - `VoidCallback onSelectTap`: Activates multi-selection mode.
  - `VoidCallback? onScanTap`: Manual rescan trigger.
- **Mockup Usage**: Folder `02_home_all_files`.

### `DocSubAppBar`
- **Proposed Path**: `lib/core/widgets/doc_app_bar.dart`
- **Class Name**: `DocSubAppBar`
- **Description**: Standard sub-screen app bar with back navigation button, centered/start title (18pt SemiBold), and optional trailing action icons.
- **Props**:
  - `String title`: Screen title.
  - `VoidCallback? onBack`: Back pop action.
  - `List<Widget>? actions`: Trailing actions (e.g. search, sort, menu).
- **Mockup Usage**: Folders `04_file_management/03_directories`, `05_viewers/*`, `07_settings/*`.

### `DocSelectionAppBar`
- **Proposed Path**: `lib/core/widgets/doc_selection_app_bar.dart`
- **Class Name**: `DocSelectionAppBar`
- **Description**: Replaces standard app bar when multi-select is active. Shows selected count ("N selected"), "Select All" toggle button, and "Cancel" action.
- **Props**:
  - `int selectedCount`: Current selection count.
  - `int totalCount`: Total selectable items.
  - `VoidCallback onSelectAll`: Toggle select all / deselect all.
  - `VoidCallback onCancel`: Exit selection mode.
  - `VoidCallback onDelete`: Batch delete action.
- **Mockup Usage**: Folder `04_file_management/02_multi_select_delete`.

---

## 4. Tabs, Filters & Breadcrumbs

### `DocUnderlineTabs`
- **Proposed Path**: `lib/core/widgets/doc_underline_tabs.dart`
- **Class Name**: `DocUnderlineTabs`
- **Description**: Horizontal tab bar switching between "Recent" and "Bookmarks" with a 3pt active pill indicator and item count badges.
- **Props**:
  - `int selectedIndex`: 0 (Recent) or 1 (Bookmarks).
  - `int recentCount`: Number of recent files.
  - `int bookmarksCount`: Number of bookmarked files.
  - `ValueChanged<int> onTabSelected`: Tab switch handler.
- **Mockup Usage**: Folder `03_home_recent_and_bookmarks`.

### `DocFilterChipRow`
- **Proposed Path**: `lib/core/widgets/doc_filter_chip_row.dart`
- **Class Name**: `DocFilterChipRow`
- **Description**: Horizontally scrollable row of rounded filter chips: `All`, `PDF`, `Word`, `Excel`, `PPT`, `TXT`, `Image`.
- **Props**:
  - `FileTypeCategory? selectedCategory`: Currently selected category (or null for All).
  - `Map<FileTypeCategory, int> counts`: Document counts per format.
  - `ValueChanged<FileTypeCategory?> onSelected`: Filter change callback.
- **Visuals**:
  - Pill shape: 16pt radius, 32pt height.
  - Inactive: `#F3F5FA` (Light) / `#232838` (Dark), with small colored circular dot indicating type color.
  - Active: `#1A66E8` background with white text and dot.
- **Mockup Usage**: Folder `02_home_all_files`, `03_home_search`.

### `DocBreadcrumbBar`
- **Proposed Path**: `lib/core/widgets/doc_breadcrumb_bar.dart`
- **Class Name**: `DocBreadcrumbBar`
- **Description**: Horizontally scrollable breadcrumb path navigation for the directory browser (`Root > Download > Subfolder`).
- **Props**:
  - `List<String> pathSegments`: List of directory components.
  - `ValueChanged<int> onSegmentTap`: Jump back to ancestor segment index.
- **Mockup Usage**: Folder `04_file_management/03_directories`.

---

## 5. Tile & Row Components

### `CategoryTile`
- **Proposed Path**: `lib/core/widgets/category_tile.dart`
- **Class Name**: `CategoryTile`
- **Description**: 4-column grid item on the Home screen representing a document category or Directories.
- **Props**:
  - `FileTypeCategory category`: PDF, Word, Excel, PPT, TXT, Image, or Directories.
  - `int count`: Document count.
  - `VoidCallback onTap`: Tap handler.
- **Visuals**:
  - Card: 20pt corner radius, `#F3F5FA` (Light) / `#232838` (Dark).
  - Icon container: 44x44pt rounded rect (12pt radius) with tinted pastel background.
  - Typography: 13pt SemiBold category name, 11pt Regular item count.
- **Mockup Usage**: Folder `02_home_all_files`.

### `FileTypeGlyph` / `FileTypeBadge`
- **Proposed Path**: `lib/core/widgets/file_type_badge.dart`
- **Class Name**: `FileTypeBadge`
- **Description**: Folded-corner document badge rendered in 3 sizes:
  - `Small (16pt)`: Inline tag.
  - `Medium (24pt)`: Grid tile tag.
  - `Large (48pt)`: Fallback file thumbnail.
- **Props**:
  - `FileTypeCategory category`: Format category.
  - `BadgeSize size`: Small, Medium, Large.
  - `String? extensionText`: Optional override (e.g. "PDF", "DOCX", "XLSX").
- **Mockup Usage**: Folders `02_home_all_files`, `03_home_search`, `04_file_management/*`.

### `FileRow`
- **Proposed Path**: `lib/core/widgets/file_row.dart`
- **Class Name**: `FileRow`
- **Description**: 68pt height document list item. Features thumbnail/badge, primary title (15pt Bold), metadata line (12pt Regular: date + file size), bookmark star button, and 3-dot options menu.
- **Props**:
  - `DocumentEntity document`: File metadata model.
  - `bool isSelected`: In multi-select mode, shows checkbox instead of thumbnail.
  - `bool isSelectionMode`: Multi-select active state.
  - `VoidCallback onTap`: Open document / toggle select.
  - `VoidCallback onLongPress`: Trigger selection mode or options sheet.
  - `VoidCallback onToggleBookmark`: Quick bookmark toggle.
  - `VoidCallback onOptions`: Open options bottom sheet.
- **Mockup Usage**: Folders `02_home_all_files`, `03_home_recent_and_bookmarks`, `03_home_search`, `04_file_management/*`.

### `FolderRow`
- **Proposed Path**: `lib/core/widgets/folder_row.dart`
- **Class Name**: `FolderRow`
- **Description**: Directory list item in the folder browser. Shows folder icon (accent blue `#2F7BEA`), folder name, item count, modified date, and trailing chevron.
- **Props**:
  - `String folderName`: Folder name.
  - `int? itemCount`: Number of items inside (or null if calculating/lazy).
  - `DateTime? modifiedDate`: Last modified timestamp.
  - `VoidCallback onTap`: Browse into folder.
- **Mockup Usage**: Folder `04_file_management/03_directories`.

### `FileThumbnail`
- **Proposed Path**: `lib/core/widgets/file_thumbnail.dart`
- **Class Name**: `FileThumbnail`
- **Description**: 48x56pt container with 10pt radius and 0.5pt inner border. Displays cached image/PDF preview or falls back to `FileTypeBadge`.
- **Props**:
  - `String filePath`: Path to file for thumbnail generation.
  - `FileTypeCategory category`: Fallback category.
- **Mockup Usage**: Folders `02_home_all_files`, `03_home_recent_and_bookmarks`, `04_file_management/01_file_actions`.

---

## 6. Button Family

### `DocPrimaryButton`
- **Proposed Path**: `lib/core/widgets/buttons/doc_primary_button.dart`
- **Class Name**: `DocPrimaryButton`
- **Description**: 56pt height full-width or flex CTA button. 16pt radius, `#1A66E8` background, pure white 15pt SemiBold text, subtle elevation (2dp).
- **Props**:
  - `String label`: Button text.
  - `Widget? icon`: Optional leading icon.
  - `VoidCallback? onPressed`: Action (null for disabled state `#A0BFF8`).
  - `bool isLoading`: Shows circular spinner.
- **Mockup Usage**: Folders `01_launch/02_onboarding_*`, `01_launch/04_permissions`, `06_tools_tab/*`.

### `DocSecondaryButton` / `DocTonalButton`
- **Proposed Path**: `lib/core/widgets/buttons/doc_secondary_button.dart`
- **Class Name**: `DocSecondaryButton`, `DocTonalButton`
- **Description**:
  - `DocSecondaryButton`: 1px outline `#E6E9F0`, 16pt radius, 48pt or 56pt height, transparent background.
  - `DocTonalButton`: `#F3F5FA` (Light) / `#232838` (Dark) background, 16pt radius.
- **Props**:
  - `String label`: Button text.
  - `VoidCallback? onPressed`: Tap callback.
  - `Color? textColor`: Custom text color.
- **Mockup Usage**: Folders `01_launch/04_permissions` ("Import files instead"), `04_file_management/*`.

### `DocDestructiveButton`
- **Proposed Path**: `lib/core/widgets/buttons/doc_destructive_button.dart`
- **Class Name**: `DocDestructiveButton`
- **Description**: Crimson `#E5484D` background or tonal tint for destructive actions (Delete file, Delete batch).
- **Props**:
  - `String label`: "Delete", "Remove".
  - `VoidCallback? onPressed`: Destructive action callback.
- **Mockup Usage**: Folder `04_file_management/*`.

### `DocIconButton`
- **Proposed Path**: `lib/core/widgets/buttons/doc_icon_button.dart`
- **Class Name**: `DocIconButton`
- **Description**: Circular or square icon button with strict 48x48pt minimum touch target, tooltip, and semantic label.
- **Props**:
  - `IconData icon`: Icon to display.
  - `String tooltip`: Accessibility tooltip.
  - `VoidCallback? onPressed`: Tap callback.
  - `Color? color`: Icon color.
- **Mockup Usage**: Universal across all screens.

### `DocFab`
- **Proposed Path**: `lib/core/widgets/buttons/doc_fab.dart`
- **Class Name**: `DocFab`
- **Description**: 56x56pt floating action button with 16pt rounded corners, `#1A66E8` background, white icon. Enforces $\ge 16\text{pt}$ clearance above docked banner.
- **Props**:
  - `IconData icon`: Icon (e.g. `add`, `document_scanner`).
  - `String tooltip`: Accessibility label.
  - `VoidCallback onPressed`: Trigger action.
- **Mockup Usage**: Folders `02_home_all_files`, `06_tools_tab/02_merge_pdf_step1`.

---

## 7. Input & Form Family

### `DocSearchField`
- **Proposed Path**: `lib/core/widgets/inputs/doc_search_field.dart`
- **Class Name**: `DocSearchField`
- **Description**: 48pt height pill-shaped search input with magnifying glass prefix icon, clear button suffix, and `#F3F5FA` background.
- **Props**:
  - `TextEditingController controller`: Text controller.
  - `ValueChanged<String>? onChanged`: Query changed callback.
  - `VoidCallback? onClear`: Clear query callback.
  - `String hintText`: "Search documents, folders...".
  - `bool autofocus`: Auto-focus state.
- **Mockup Usage**: Folder `03_home_search`.

### `DocTextField`
- **Proposed Path**: `lib/core/widgets/inputs/doc_text_field.dart`
- **Class Name**: `DocTextField`
- **Description**: Standard input field with 12pt radius, 1px hairline border, optional prefix icon, helper text, and error states. Supports locked extension suffix (e.g. `.pdf` in rename dialog).
- **Props**:
  - `TextEditingController controller`: Controller.
  - `String? label`: Top floating or static label.
  - `String? lockedSuffix`: Locked text suffix (e.g. `.pdf`).
  - `String? errorText`: Validation error string.
  - `bool obscureText`: Password masking with toggle eye icon.
- **Mockup Usage**: Folders `04_file_management/01_file_actions` (Rename), `05_viewers/02_pdf_password_dialog`.

### `DocSegmentedControl<T>`
- **Proposed Path**: `lib/core/widgets/inputs/doc_segmented_control.dart`
- **Class Name**: `DocSegmentedControl<T>`
- **Description**: Sliding segmented toggle container with smooth animation, rounded pill indicators, and high contrast active state.
- **Props**:
  - `Map<T, String> options`: Segment keys and labels (e.g. `{Layout.a4: 'A4', Layout.fit: 'Fit to Image'}`).
  - `T selectedValue`: Selected segment key.
  - `ValueChanged<T> onValueChanged`: Change callback.
- **Mockup Usage**: Folders `06_tools_tab/01_image_to_pdf`, `06_tools_tab/03_split_pdf`.

---

## 8. Modals, Sheets & Dialogs

### `DocBottomSheet`
- **Proposed Path**: `lib/core/widgets/modals/doc_bottom_sheet.dart`
- **Class Name**: `DocBottomSheet`
- **Description**: Standard modal bottom sheet chassis with 28pt top corner radius, 36x4pt top drag handle, light/dark surface, and dimmed backdrop scrim (`rgba(17,20,28,0.45)`).
- **Props**:
  - `String? title`: Optional sheet header title.
  - `Widget content`: Sheet body.
  - `Widget? bottomActions`: Pinned bottom action buttons.
- **Mockup Usage**: Folders `04_file_management/01_file_actions`, `05_viewers/01_pdf_reader` (More sheet).

### `OptionsListTile`
- **Proposed Path**: `lib/core/widgets/modals/options_list_tile.dart`
- **Class Name**: `OptionsListTile`
- **Description**: 56pt height action row inside a bottom sheet. Features 24pt icon, 15pt title, optional badge, and optional destructive red styling.
- **Props**:
  - `IconData icon`: Action icon.
  - `String label`: Action text ("Rename", "Share", "Delete").
  - `bool isDestructive`: Red text and icon styling.
  - `VoidCallback onTap`: Action handler.
- **Mockup Usage**: Folder `04_file_management/01_file_actions`.

### `DocDialog`
- **Proposed Path**: `lib/core/widgets/modals/doc_dialog.dart`
- **Class Name**: `DocDialog`
- **Description**: Rounded modal dialog (24pt radius) with title (18pt Bold Space Grotesk), body text (14pt Regular Inter), and dual action buttons (Cancel / Confirm).
- **Props**:
  - `String title`: Dialog title.
  - `Widget content`: Message or custom input widget.
  - `String confirmLabel`: "Confirm", "Delete", "Rename".
  - `bool isDestructive`: Confirm button uses red styling.
  - `VoidCallback onConfirm`: Confirm handler.
  - `VoidCallback? onCancel`: Cancel handler.
- **Mockup Usage**: Folders `04_file_management/01_file_actions`, `04_file_management/02_multi_select_delete`.

### `ProgressDialog` / `ExportProgressSheet`
- **Proposed Path**: `lib/core/widgets/modals/progress_sheet.dart`
- **Class Name**: `ProgressSheet`
- **Description**: Modal bottom sheet or dialog showing determinate export progress (percentage text, smooth progress bar, operation status message).
- **Props**:
  - `double progress`: 0.0 to 1.0.
  - `String title`: "Converting images...", "Merging PDFs...".
  - `String statusText`: "Page 4 of 12".
  - `VoidCallback? onCancel`: Cancel operation callback.
- **Mockup Usage**: Folder `06_tools_tab/04_tool_export_flow`.

### `ResultSheet`
- **Proposed Path**: `lib/core/widgets/modals/result_sheet.dart`
- **Class Name**: `ResultSheet`
- **Description**: Sheet presented upon successful tool export. Features large green checkmark badge, created file card with thumbnail and metadata, and dual actions: "Open PDF" (Primary) and "Share" (Secondary).
- **Props**:
  - `String filePath`: Generated PDF path.
  - `String fileName`: Display name.
  - `int fileSize`: Size in bytes.
  - `VoidCallback onOpen`: Open in reader.
  - `VoidCallback onShare`: Share file intent.
- **Mockup Usage**: Folder `06_tools_tab/04_tool_export_flow`.

---

## 9. Status & State Widgets

### `DocEmptyState`
- **Proposed Path**: `lib/core/widgets/states/doc_empty_state.dart`
- **Class Name**: `DocEmptyState`
- **Description**: Centered empty state illustration/icon, headline (18pt Bold), explanation body copy, and optional action button.
- **Props**:
  - `IconData icon`: Large illustrative icon.
  - `String title`: "No documents found".
  - `String message`: Explanatory message.
  - `String? actionLabel`: Optional button label.
  - `VoidCallback? onAction`: Button callback.
- **Mockup Usage**: Folders `02_home_all_files`, `03_home_recent_and_bookmarks`, `03_home_search`.

### `DocErrorState`
- **Proposed Path**: `lib/core/widgets/states/doc_error_state.dart`
- **Class Name**: `DocErrorState`
- **Description**: Replaces generic errors with clear iconography, message, and a "Retry" button.
- **Props**:
  - `String message`: Error explanation.
  - `VoidCallback onRetry`: Retry action.
- **Mockup Usage**: Folder `04_file_management/03_directories`.

### `DocPermissionRequiredState`
- **Proposed Path**: `lib/core/widgets/states/doc_permission_required_state.dart`
- **Class Name**: `DocPermissionRequiredState`
- **Description**: Explains All Files Access permission requirement. Features folder badge, clear explanation text, primary "Grant access" button, and secondary "Import files instead" button.
- **Props**:
  - `VoidCallback onGrantAccess`: System settings launcher.
  - `VoidCallback onImportFiles`: System file picker fallback.
- **Mockup Usage**: Folders `01_launch/04_permissions`, `04_file_management/03_directories`.

---

## 10. Skeleton Primitives

### `ShimmerBox`
- **Proposed Path**: `lib/core/widgets/skeletons/shimmer_box.dart`
- **Class Name**: `ShimmerBox`
- **Description**: Base container with 1.5s linear shimmer gradient sweep (`#E9EDF5` to `#F5F7FB` in Light; `#262B3A` to `#30364A` in Dark).
- **Props**:
  - `double width`: Box width.
  - `double height`: Box height.
  - `double borderRadius`: Corner radius (default 8pt).
- **Mockup Usage**: Folder `08_admob_placements` (skeleton placeholders).

### `SkeletonFileRow` & `SkeletonList`
- **Proposed Path**: `lib/core/widgets/skeletons/skeleton_file_row.dart`
- **Class Name**: `SkeletonFileRow`, `SkeletonList`
- **Description**: Exact 68pt height skeleton row matching `FileRow` geometry (48x56pt thumbnail box, title line, meta line).
- **Props**:
  - `int itemCount`: Number of skeleton rows to render.
- **Mockup Usage**: All loading states across file lists.

---

## 11. AdMob Placeholder Widgets

### `AdBannerSlot`
- **Proposed Path**: `lib/core/widgets/ads/ad_banner_slot.dart`
- **Class Name**: `AdBannerSlot`
- **Description**: Docked banner container with exact 60pt height, 1px top hairline, small `AD` pill badge, and automatic `0pt` collapse (`SizedBox.shrink()`) if ad fails to load.
- **Props**:
  - `bool isLoaded`: Banner load state.
  - `Widget? adWidget`: Loaded ad platform view.
- **Mockup Usage**: Folders `02_home_all_files`, `03_home_recent_and_bookmarks`, `06_tools_tab`, `07_settings`.

### `NativeAdRow`
- **Proposed Path**: `lib/core/widgets/ads/native_ad_row.dart`
- **Class Name**: `NativeAdRow`
- **Description**: In-feed native ad row with exact 68pt height matching `FileRow` geometry. Features 48x48pt ad app icon, title, sponsored badge ("AD"), description/star rating, and install CTA button.
- **Props**:
  - `bool isLoaded`: Load state (collapses if false).
- **Mockup Usage**: Folders `02_home_all_files` (Recent list slot 6), `03_home_search` (Search slot 6), `06_tools_tab/02_merge_pdf_step1`.

---

## 12. Tool-Specific Components

### `ToolCard`
- **Proposed Path**: `lib/core/widgets/tools/tool_card.dart`
- **Class Name**: `ToolCard`
- **Description**: Large tool card on the Tools tab. Features glossy gradient icon badge (48x48pt), bold tool title, descriptive subtitle, and right chevron.
- **Props**:
  - `String title`: Tool name (Image to PDF, Scan to PDF, Merge PDF, Split PDF).
  - `String description`: Short tool description.
  - `IconData icon`: Tool icon.
  - `LinearGradient gradient`: Gradient background for icon badge.
  - `VoidCallback onTap`: Navigation callback.
- **Mockup Usage**: Folder `06_tools_tab/00_tools_grid`.

### `ReorderablePageRow`
- **Proposed Path**: `lib/core/widgets/tools/reorderable_page_row.dart`
- **Class Name**: `ReorderablePageRow`
- **Description**: List item in Image to PDF and Merge PDF builders. Features drag reorder handle, page thumbnail, page number badge, rotation action, and remove button.
- **Props**:
  - `int index`: Page index.
  - `String imageOrPdfPath`: File preview path.
  - `VoidCallback onRemove`: Delete page callback.
  - `VoidCallback? onRotate`: Rotate page callback.
- **Mockup Usage**: Folders `06_tools_tab/01_image_to_pdf`, `06_tools_tab/02_merge_pdf_step2`.

### `DashedAddCard`
- **Proposed Path**: `lib/core/widgets/tools/dashed_add_card.dart`
- **Class Name**: `DashedAddCard`
- **Description**: Rounded card with dashed 1.5px border and central `+ Add more images` / `+ Add PDF` CTA.
- **Props**:
  - `String label`: Button text.
  - `VoidCallback onTap`: Tap handler.
- **Mockup Usage**: Folders `06_tools_tab/01_image_to_pdf`, `06_tools_tab/02_merge_pdf_step2`.

