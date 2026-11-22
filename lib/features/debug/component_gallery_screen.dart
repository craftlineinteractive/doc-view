import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/l10n_extension.dart';
import '../../core/constants/file_types.dart';
import '../../data/models/spreadsheet_data.dart';
import '../providers/providers.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../shared/widgets/ads/ad_placeholders.dart';
import '../../shared/widgets/buttons/doc_buttons.dart';
import '../../shared/widgets/buttons/doc_icon_button.dart';
import '../../shared/widgets/inputs/doc_inputs.dart';
import '../../shared/widgets/modals/doc_modals.dart';
import '../../shared/widgets/navigation/doc_app_bar.dart';
import '../../shared/widgets/navigation/doc_bottom_nav_bar.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';
import '../../shared/widgets/reader/reader_bottom_row.dart';
import '../../shared/widgets/reader/reader_search_bar.dart';
import '../../shared/widgets/skeletons/skeleton_variants.dart';
import '../../shared/widgets/spreadsheet/formula_bar.dart';
import '../../shared/widgets/spreadsheet/sheet_tab_bar.dart';
import '../../shared/widgets/spreadsheet/spreadsheet_grid.dart';
import '../../shared/widgets/spreadsheet/zoom_pill.dart';
import '../../shared/widgets/status/doc_status_widgets.dart';
import '../../shared/widgets/tabs/doc_tabs_and_filters.dart';
import '../../shared/widgets/tiles/category_tile.dart';
import '../../shared/widgets/tiles/file_and_folder_rows.dart';
import '../../shared/widgets/tiles/file_type_badge.dart';
import '../../shared/widgets/tools/doc_tool_widgets.dart';
import '../../data/models/pdf_markup.dart';
import '../tools/annotate/annotate_session_notifier.dart';
import '../tools/annotate/widgets/annotate_toolbar.dart';
import '../tools/annotate/widgets/selection_menu.dart';

/// Debug-only Component Gallery showcasing the entire Doc View component library.
/// Only available in [kDebugMode], accessible via long-press on Settings version row.
class ComponentGalleryScreen extends ConsumerStatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  ConsumerState<ComponentGalleryScreen> createState() =>
      _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends ConsumerState<ComponentGalleryScreen> {
  bool _isDark = false;
  double _textScale = 1.0;
  bool _usePseudoLocale = false;
  bool _isRtl = false;
  int _selectedNavTab = 0;
  int _selectedUnderlineTab = 0;
  FileCategory? _selectedCategory;
  int _segmentedIndex = 0;
  bool _checkboxVal = true;
  int _radioVal = 1;
  bool _switchVal = true;
  bool _adLoaded = true;
  int _gallerySheetIndex = 0;
  SpreadsheetSelection _gallerySpreadsheetSelection = const SpreadsheetSelection.cell(0, 0);
  double _galleryGridZoom = 1.0;
  final SheetData _gallerySheetData = SheetData(
    name: 'Q1 Forecast',
    rowCount: 4,
    columnCount: 3,
    cells: {
      const CellCoordinate(0, 0): const SpreadsheetCell(rawValue: 'Region', style: CellStyleData(isBold: true)),
      const CellCoordinate(0, 1): const SpreadsheetCell(rawValue: 'Revenue', style: CellStyleData(isBold: true, textAlign: TextAlign.right)),
      const CellCoordinate(0, 2): const SpreadsheetCell(rawValue: 'Growth', style: CellStyleData(isBold: true, textAlign: TextAlign.right)),
      const CellCoordinate(1, 0): const SpreadsheetCell(rawValue: 'North America'),
      const CellCoordinate(1, 1): const SpreadsheetCell(rawValue: '1250000', type: CellDataType.number),
      const CellCoordinate(1, 2): const SpreadsheetCell(rawValue: '0.12', type: CellDataType.number),
      const CellCoordinate(2, 0): const SpreadsheetCell(rawValue: 'Europe'),
      const CellCoordinate(2, 1): const SpreadsheetCell(rawValue: '850000', type: CellDataType.number),
      const CellCoordinate(2, 2): const SpreadsheetCell(rawValue: '0.08', type: CellDataType.number),
      const CellCoordinate(3, 0): const SpreadsheetCell(rawValue: 'Total', style: CellStyleData(isBold: true)),
      const CellCoordinate(3, 1): const SpreadsheetCell(rawValue: '2100000', formula: '=SUM(B2:B3)', type: CellDataType.number, style: CellStyleData(isBold: true)),
    },
  );

  final TextEditingController _searchCtrl = TextEditingController(text: 'Quarterly Report');
  final TextEditingController _textCtrl = TextEditingController(text: 'Annual_Budget_2026');
  final TextEditingController _pwdCtrl = TextEditingController(text: 'secret123');

  @override
  void dispose() {
    _searchCtrl.dispose();
    _textCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Theme(
      data: theme,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(_textScale),
        ),
        child: Directionality(
          textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Localizations.override(
            context: context,
            locale: _usePseudoLocale ? const Locale('en', 'XA') : const Locale('en'),
            child: Builder(
              builder: (themedContext) {
                final tokens = themedContext.tokens;

                return DocScaffold(
                  applyHeaderGradient: true,
                  appBar: DocSubAppBar(
                    title: 'Component Gallery',
                    actions: [
                      DocIconButton(
                        icon: Icons.language,
                        tooltip: _usePseudoLocale
                            ? 'Switch to English'
                            : 'Switch to Pseudo-locale (en_XA)',
                        color: _usePseudoLocale
                            ? tokens.primaryBlue
                            : tokens.textSecondary,
                        onPressed: () =>
                            setState(() => _usePseudoLocale = !_usePseudoLocale),
                      ),
                      DocIconButton(
                        icon: Icons.format_textdirection_r_to_l,
                        tooltip: _isRtl ? 'Switch to LTR' : 'Switch to RTL',
                        color: _isRtl ? tokens.primaryBlue : tokens.textSecondary,
                        onPressed: () => setState(() => _isRtl = !_isRtl),
                      ),
                      DocIconButton(
                        icon: _isDark ? Icons.light_mode : Icons.dark_mode,
                        tooltip: _isDark ? 'Switch to Light' : 'Switch to Dark',
                        onPressed: () => setState(() => _isDark = !_isDark),
                      ),
                      DocIconButton(
                        icon: Icons.text_fields,
                        tooltip: 'Text scale: ${_textScale}x (tap to toggle)',
                        onPressed: () => setState(
                          () => _textScale = _textScale == 1.0 ? 2.0 : 1.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  body: ListView(
                    padding: const EdgeInsets.only(bottom: 40),
                    children: [
                      // --- Section 0: Environment Controls ---
                      const SectionHeader(title: '0. Environment Controls'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          color: tokens.surface,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: tokens.hairline),
                          ),
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: const Text('Pseudo-locale (en_XA)'),
                                subtitle: Text(_usePseudoLocale
                                    ? 'Active: [!!! Hêéllôö wôörld !!!] (+40% expansion)'
                                    : 'Standard English (en)'),
                                value: _usePseudoLocale,
                                onChanged: (val) {
                                  setState(() => _usePseudoLocale = val);
                                  ref
                                      .read(settingsProvider.notifier)
                                      .setLocaleCode(val ? 'en_XA' : null);
                                },
                              ),
                              Divider(color: tokens.hairline, height: 1),
                              SwitchListTile(
                                title: const Text('Force RTL'),
                                subtitle: Text(_isRtl
                                    ? 'Right-to-Left layout active'
                                    : 'Left-to-Right layout active'),
                                value: _isRtl,
                                onChanged: (val) {
                                  setState(() => _isRtl = val);
                                  ref
                                      .read(debugForceRtlProvider.notifier)
                                      .setForceRtl(val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // --- Section 1: Typography & Tokens ---
                      const SectionHeader(title: '1. Typography & Tokens'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Space Grotesk Headline XL', style: DocViewTypography.headlineXl.copyWith(color: tokens.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Space Grotesk Headline LG', style: DocViewTypography.headlineLg.copyWith(color: tokens.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Space Grotesk Headline SM', style: DocViewTypography.headlineSm.copyWith(color: tokens.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Inter Title MD (Bold)', style: DocViewTypography.titleMd.copyWith(color: tokens.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Inter Body LG (Medium)', style: DocViewTypography.bodyLg.copyWith(color: tokens.textSecondary)),
                        const SizedBox(height: 4),
                        Text('Inter Body MD (Regular)', style: DocViewTypography.bodyMd.copyWith(color: tokens.textSecondary)),
                        const SizedBox(height: 12),
                        const Text('FileTypeBadges (Small, Medium, Large):'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            const FileTypeBadge(category: FileCategory.pdf, size: BadgeSize.small),
                            const FileTypeBadge(category: FileCategory.word, size: BadgeSize.medium),
                            const FileTypeBadge(category: FileCategory.excel, size: BadgeSize.large),
                            const FileTypeBadge(category: FileCategory.ppt, size: BadgeSize.medium),
                            const FileTypeBadge(category: FileCategory.txt, size: BadgeSize.small),
                            const FileTypeBadge(category: FileCategory.image, size: BadgeSize.large),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- Section 2: Buttons ---
                  const SectionHeader(title: '2. Button Family'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        DocPrimaryButton(label: 'Primary Button (56pt)', onPressed: () {}),
                        const SizedBox(height: 10),
                        DocSecondaryButton(label: 'Secondary Button', onPressed: () {}),
                        const SizedBox(height: 10),
                        DocTonalButton(label: 'Tonal Button', onPressed: () {}),
                        const SizedBox(height: 10),
                        DocDestructiveButton(label: 'Destructive Button', onPressed: () {}),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DocIconButton(icon: AppIcons.search, tooltip: 'Search', onPressed: () {}),
                            DocIconButton(icon: AppIcons.bookmark, tooltip: 'Bookmark', color: DocViewColors.warning, onPressed: () {}),
                            DocIconButton(icon: AppIcons.delete, tooltip: 'Delete', color: DocViewColors.error, onPressed: () {}),
                            DocFab(icon: AppIcons.add, tooltip: 'FAB Button', onPressed: () {}),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- Section 3: Inputs & Form Controls ---
                  const SectionHeader(title: '3. Input & Form Family'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        DocSearchField(controller: _searchCtrl),
                        const SizedBox(height: 12),
                        DocTextField(
                          controller: _textCtrl,
                          label: 'Document Rename (Locked Suffix)',
                          lockedSuffix: '.pdf',
                        ),
                        const SizedBox(height: 12),
                        DocTextField(
                          controller: _pwdCtrl,
                          label: 'Password Protected',
                          isPassword: true,
                        ),
                        const SizedBox(height: 12),
                        DocSegmentedControl<int>(
                          options: const {0: 'A4 Page', 1: 'Fit to Image'},
                          selectedValue: _segmentedIndex,
                          onValueChanged: (val) => setState(() => _segmentedIndex = val),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            DocCheckbox(
                              value: _checkboxVal,
                              label: 'Checkbox',
                              onChanged: (val) => setState(() => _checkboxVal = val ?? false),
                            ),
                            const Spacer(),
                            DocRadio<int>(
                              value: 1,
                              groupValue: _radioVal,
                              label: 'Radio A',
                              onChanged: (v) => setState(() => _radioVal = v),
                            ),
                            const Spacer(),
                            DocSwitch(
                              value: _switchVal,
                              onChanged: (v) => setState(() => _switchVal = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- Section 4: Tabs, Filters, Breadcrumbs ---
                  const SectionHeader(title: '4. Tabs & Navigation Primitives'),
                  DocUnderlineTabs(
                    selectedIndex: _selectedUnderlineTab,
                    recentCount: 14,
                    bookmarksCount: 3,
                    onTabSelected: (i) => setState(() => _selectedUnderlineTab = i),
                  ),
                  const SizedBox(height: 8),
                  DocFilterChipRow(
                    selectedCategory: _selectedCategory,
                    counts: const {
                      FileCategory.pdf: 92,
                      FileCategory.word: 45,
                      FileCategory.excel: 18,
                    },
                    onSelected: (cat) => setState(() => _selectedCategory = cat),
                  ),
                  const SizedBox(height: 8),
                  DocBreadcrumbBar(
                    pathSegments: const ['Root', 'Internal Storage', 'Download', 'PDFs'],
                    onSegmentTap: (_) {},
                  ),

                  // --- Section 5: Tiles & Rows ---
                  const SectionHeader(title: '5. Tiles & Rows'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.78,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        CategoryTile(
                          category: FileCategory.pdf,
                          label: 'PDF',
                          icon: AppIcons.pdf,
                          count: 92,
                          onTap: () {},
                        ),
                        CategoryTile(
                          category: FileCategory.word,
                          label: 'Word',
                          icon: AppIcons.word,
                          count: 45,
                          onTap: () {},
                        ),
                        CategoryTile(
                          category: FileCategory.excel,
                          label: 'Excel',
                          icon: AppIcons.excel,
                          count: 18,
                          onTap: () {},
                        ),
                        CategoryTile(
                          label: 'Directories',
                          icon: AppIcons.folderFilled,
                          count: 8,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FileRow(
                    title: 'Q3_Financial_Analysis_Report.pdf',
                    metadata: 'Oct 24, 2026 • 2.4 MB',
                    category: FileCategory.pdf,
                    filePath: '/storage/sample.pdf',
                    isBookmarked: true,
                    onTap: () {},
                    onToggleBookmark: () {},
                    onOptions: () {},
                  ),
                  FileRow(
                    title: 'Sprint_32_User_Stories.docx',
                    metadata: 'Yesterday • 450 KB',
                    category: FileCategory.word,
                    filePath: '/storage/sample.docx',
                    isBookmarked: false,
                    isSelected: true,
                    isSelectionMode: true,
                    onTap: () {},
                  ),
                  FolderRow(
                    folderName: 'Download',
                    subtitle: '12 items • Modified 2 hours ago',
                    onTap: () {},
                  ),

                  // --- Section 6: Skeletons & Shimmer ---
                  const SectionHeader(title: '6. Shimmer & Skeletons'),
                  const SkeletonFileRow(),
                  const SkeletonFolderRow(),
                  const SkeletonToolCard(),

                  // --- Section 7: Ad Placeholders ---
                  SectionHeader(title: '7. Ad Placeholders (Loaded: $_adLoaded)'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _adLoaded = !_adLoaded),
                          child: Text(_adLoaded ? 'Simulate NO_FILL (Collapse)' : 'Simulate Load Ad'),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(themedContext).push(
                              MaterialPageRoute(
                                builder: (_) => InterstitialPlaceholder(
                                  onDismiss: () => Navigator.of(themedContext).pop(),
                                ),
                              ),
                            );
                          },
                          child: const Text('Show Interstitial'),
                        ),
                      ],
                    ),
                  ),
                  AdBannerSlot(isLoaded: _adLoaded),
                  const SizedBox(height: 8),
                  NativeAdRow(isLoaded: _adLoaded),

                  // --- Section 8: Status & Info Widgets ---
                  const SectionHeader(title: '8. Status & Info'),
                  const InfoBanner(
                    message: 'Background indexing in progress (48/120 files)',
                    icon: AppIcons.refresh,
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: PageNumberPill(currentPage: 4, totalPages: 12),
                  ),
                  const SizedBox(height: 12),
                  const ExpandableFaqCard(
                    question: 'Can I view password-protected PDFs?',
                    answer: 'Yes! Doc View prompts for the document password in-app and renders securely without saving passwords to disk.',
                  ),

                  // --- Section 9: Tool Widgets ---
                  const SectionHeader(title: '9. Tool Components'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ToolCard(
                          title: 'Image to PDF',
                          description: 'Convert JPG, PNG, WEBP into standard PDF',
                          icon: AppIcons.image,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        ToolCard(
                          title: 'Scan to PDF',
                          description: 'Capture documents with edge detection',
                          icon: AppIcons.scanner,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        ToolCard(
                          title: 'Merge PDF',
                          description: 'Combine multiple documents into one',
                          icon: AppIcons.merge,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1A66E8), Color(0xFF1557C0)],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        ToolCard(
                          title: 'Split PDF',
                          description: 'Extract ranges or divide by page count',
                          icon: AppIcons.split,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        DashedAddCard(
                          label: 'Add more files',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        const OnboardingPageIndicator(currentPage: 0, totalPages: 3),
                      ],
                    ),
                  ),

                  // --- Section 10: Modal Sheets Trigger ---
                  const SectionHeader(title: '10. Modals & Sheets'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: DocTonalButton(
                            label: 'Options Sheet',
                            height: 48,
                            onPressed: () {
                              DocBottomSheet.show(
                                context: themedContext,
                                title: 'Document Options',
                                child: Column(
                                  children: [
                                    OptionsListTile(
                                      icon: AppIcons.openWith,
                                      label: 'Open Document',
                                      onTap: () {},
                                    ),
                                    OptionsListTile(
                                      icon: AppIcons.share,
                                      label: 'Share File',
                                      onTap: () {},
                                    ),
                                    OptionsListTile(
                                      icon: AppIcons.rename,
                                      label: 'Rename Document',
                                      onTap: () {},
                                    ),
                                    OptionsListTile(
                                      icon: AppIcons.delete,
                                      label: 'Delete Document',
                                      isDestructive: true,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DocTonalButton(
                            label: 'Result Sheet',
                            height: 48,
                            onPressed: () {
                              DocBottomSheet.show(
                                context: themedContext,
                                child: ResultSheet(
                                  fileName: 'Combined_Invoices.pdf',
                                  metadata: '12 Pages • 3.4 MB',
                                  onOpen: () => Navigator.of(themedContext).pop(),
                                  onShare: () => Navigator.of(themedContext).pop(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Section 11: Reader Components ---
                  const SectionHeader(title: '11. Reader Components'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const ReaderSearchBar(
                          totalMatches: 14,
                          currentMatchIndex: 1,
                        ),
                        const SizedBox(height: 8),
                        const ReaderSearchBar(
                          totalMatches: 0,
                          hasNoTextLayer: true,
                        ),
                        const SizedBox(height: 12),
                        ReaderBottomRow(
                          items: [
                            ReaderBottomRowItem(
                              icon: Icons.swap_horiz_rounded,
                              label: 'Horizontal',
                              onTap: () {},
                            ),
                            ReaderBottomRowItem(
                              icon: Icons.screen_rotation_outlined,
                              label: 'Rotate',
                              onTap: () {},
                            ),
                            ReaderBottomRowItem(
                              icon: Icons.search_rounded,
                              label: 'Search',
                              onTap: () {},
                            ),
                            ReaderBottomRowItem(
                              icon: Icons.invert_colors_rounded,
                              label: 'Invert',
                              isSelected: true,
                              onTap: () {},
                            ),
                            ReaderBottomRowItem(
                              icon: Icons.share_outlined,
                              label: 'Share',
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const ReaderBottomRow(
                          isLoading: true,
                          items: [],
                        ),
                      ],
                    ),
                  ),

                  // --- Section 12: Spreadsheet Components ---
                  const SectionHeader(title: '12. Spreadsheet Grid & Controls'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FormulaBar(
                          sheet: _gallerySheetData,
                          selection: _gallerySpreadsheetSelection,
                        ),
                        const SizedBox(height: 8),
                        SheetTabBar(
                          sheetNames: const ['Q1 Forecast', 'Q2 Plan', 'Consolidated'],
                          activeIndex: _gallerySheetIndex,
                          onSheetSelected: (index) => setState(() => _gallerySheetIndex = index),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ZoomPill(
                              scale: _galleryGridZoom,
                              onReset: () => setState(() => _galleryGridZoom = 1.0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 180,
                          child: SpreadsheetGrid(
                            sheet: _gallerySheetData,
                            selection: _gallerySpreadsheetSelection,
                            zoomScale: _galleryGridZoom,
                            onZoomChanged: (z) => setState(() => _galleryGridZoom = z),
                            onSelectionChanged: (sel) => setState(() => _gallerySpreadsheetSelection = sel),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Section 13: Recycle Bin Debug Controls ---
                  const SectionHeader(title: '13. Recycle Bin Debug Controls'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton.icon(
                          onPressed: () async {
                            final count = await ref
                                .read(trashPurgeServiceProvider)
                                .ageAllTrashItems(days: 29);
                            ref.invalidate(trashItemsProvider);
                            ref.invalidate(trashCountProvider);
                            if (themedContext.mounted) {
                              ScaffoldMessenger.of(themedContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    themedContext.l10n
                                        .galleryDebugAgeTrashSuccess(count),
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.history_toggle_off),
                          label: Text(
                            themedContext.l10n.galleryDebugAgeTrash,
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // --- Section 14: PDF Annotation (G5a) ---
                  const SectionHeader(title: '14. PDF Annotation Components (G5a)'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SelectionMenu(
                          onCopy: () {},
                          onHighlight: () {},
                          onUnderline: () {},
                          onStrikethrough: () {},
                        ),
                        const SizedBox(height: 12),
                        AnnotateToolbar(
                          selectedTool: TextMarkupType.highlight,
                          selectedColor: AnnotateColors.yellow,
                          onToolSelected: (_) {},
                          onColorSelected: (_) {},
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: DocBottomNavBar(
                currentIndex: _selectedNavTab,
                onTap: (i) => setState(() => _selectedNavTab = i),
              ),
            );
          },
        ),
      ),
    ),
  ),
);
  }
}

