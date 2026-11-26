import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';

import '../../core/extensions/l10n_extension.dart';
import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/format_utils.dart';
import '../../core/utils/spreadsheet_helpers.dart';
import '../../data/models/doc_file.dart';
import '../../data/models/spreadsheet_data.dart';
import '../../data/services/spreadsheet_parser_service.dart';
import '../providers/providers.dart';
import 'widgets/viewer_more_sheet.dart';
import '../../shared/widgets/reader/reader_bottom_row.dart';
import '../../shared/widgets/reader/reader_orientation.dart';
import '../../shared/widgets/reader/reader_search_bar.dart';
import '../../shared/widgets/spreadsheet/formula_bar.dart';
import '../../shared/widgets/spreadsheet/sheet_tab_bar.dart';
import '../../shared/widgets/spreadsheet/spreadsheet_grid.dart';
import '../../shared/widgets/spreadsheet/zoom_pill.dart';
import 'office_viewer_screen.dart';

/// Top-level worker searching cell display text in an isolated thread.
List<CellCoordinate> searchSpreadsheetMatchesWorker(Map<String, dynamic> args) {
  final cells = args['cells'] as Map<String, String>;
  final query = (args['query'] as String).toLowerCase();
  if (query.isEmpty) return const [];

  final matches = <CellCoordinate>[];
  for (final entry in cells.entries) {
    if (entry.value.toLowerCase().contains(query)) {
      final parts = entry.key.split(',');
      if (parts.length == 2) {
        final r = int.tryParse(parts[0]);
        final c = int.tryParse(parts[1]);
        if (r != null && c != null) {
          matches.add(CellCoordinate(r, c));
          if (matches.length >= 500) {
            break;
          }
        }
      }
    }
  }

  matches.sort((a, b) {
    final rowComp = a.row.compareTo(b.row);
    if (rowComp != 0) return rowComp;
    return a.column.compareTo(b.column);
  });

  return matches;
}

/// Dispatches spreadsheet cell searching in a background isolate.
Future<List<CellCoordinate>> computeSpreadsheetMatches(
  SheetData sheet,
  String query,
  Locale locale,
) {
  final stringMap = <String, String>{};
  for (final entry in sheet.cells.entries) {
    final text = formatCellDisplayValue(entry.value, locale);
    if (text.isNotEmpty) {
      stringMap['${entry.key.row},${entry.key.column}'] = text;
    }
  }
  return Isolate.run(() => searchSpreadsheetMatchesWorker({
        'cells': stringMap,
        'query': query,
      }));
}

/// Native spreadsheet grid reader for XLSX, XLSM, CSV, and TSV files.
///
/// Features:
/// - Virtualized 2D grid rendering using [SpreadsheetGrid] on [TableView.builder].
/// - Pinned column (A, B, C...) and row (1, 2, 3...) headers.
/// - Cell, row, column, and sheet selection with formula bar and copy action.
/// - In-sheet background isolate search with match navigation and counter.
/// - Pinch-to-zoom (50% to 300%) with floating zoom pill.
/// - Session-only color invert toggle and orientation rotation lock/restore.
/// - Graceful fallback options for oversized, timeout, or corrupted files.
class SpreadsheetViewerScreen extends ConsumerStatefulWidget {
  const SpreadsheetViewerScreen({
    required this.file,
    super.key,
  });

  final DocFile file;

  @override
  ConsumerState<SpreadsheetViewerScreen> createState() =>
      _SpreadsheetViewerScreenState();
}

class _SpreadsheetViewerScreenState
    extends ConsumerState<SpreadsheetViewerScreen> {
  late Future<WorkbookData> _workbookFuture;
  late final ReaderOrientationController _orientationController;
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  WorkbookData? _cachedWorkbook;
  SpreadsheetSelection _selection = const SpreadsheetSelection.none();
  double _zoomScale = 1.0;
  bool _isTableInverted = false;
  bool _isSearching = false;
  bool _isSearchRunning = false;
  bool _dismissedTruncationBanner = false;
  bool _useBasicViewerFallback = false;

  List<CellCoordinate> _matches = const [];
  Set<CellCoordinate> _allMatchCoords = const {};
  int? _currentMatchIndex;

  @override
  void initState() {
    super.initState();
    _orientationController = ReaderOrientationController();
    _loadWorkbook(0);
  }

  @override
  void dispose() {
    _orientationController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadWorkbook(int sheetIndex) {
    _workbookFuture = SpreadsheetParserService.instance
        .parseWorkbook(filePath: widget.file.path, sheetIndex: sheetIndex)
        .then((wb) {
      if (mounted) {
        setState(() {
          _cachedWorkbook = wb;
        });
      }
      return wb;
    });
  }

  void _onSheetTabSelected(int index) {
    if (_cachedWorkbook != null && _cachedWorkbook!.activeSheetIndex == index) {
      return;
    }
    setState(() {
      _selection = const SpreadsheetSelection.none();
      _matches = const [];
      _allMatchCoords = const {};
      _currentMatchIndex = null;
      _loadWorkbook(index);
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _matches = const [];
      _allMatchCoords = const {};
      _currentMatchIndex = null;
    });
  }

  Future<void> _onSearchQueryChanged(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty || _cachedWorkbook == null) {
      setState(() {
        _matches = const [];
        _allMatchCoords = const {};
        _currentMatchIndex = null;
        _isSearchRunning = false;
      });
      return;
    }

    setState(() {
      _isSearchRunning = true;
    });

    final locale = Localizations.localeOf(context);
    final found = await computeSpreadsheetMatches(
      _cachedWorkbook!.activeSheet,
      trimmed,
      locale,
    );

    if (!mounted) return;

    setState(() {
      _matches = found;
      _allMatchCoords = found.toSet();
      _currentMatchIndex = found.isNotEmpty ? 0 : null;
      _isSearchRunning = false;
    });

    if (found.isNotEmpty) {
      _selectAndScrollToMatch(0);
    }
  }

  void _selectAndScrollToMatch(int index) {
    if (index < 0 || index >= _matches.length) return;
    final coord = _matches[index];

    setState(() {
      _currentMatchIndex = index;
      _selection = SpreadsheetSelection.cell(coord.row, coord.column);
    });

    // Approximate coordinate offset and animate into view
    final targetX = (coord.column * 96.0 * _zoomScale).clamp(
      0.0,
      _horizontalScrollController.hasClients
          ? _horizontalScrollController.position.maxScrollExtent
          : 0.0,
    );
    final targetY = (coord.row * 34.0 * _zoomScale).clamp(
      0.0,
      _verticalScrollController.hasClients
          ? _verticalScrollController.position.maxScrollExtent
          : 0.0,
    );

    if (_horizontalScrollController.hasClients) {
      _horizontalScrollController.animateTo(
        targetX,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
    if (_verticalScrollController.hasClients) {
      _verticalScrollController.animateTo(
        targetY,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _nextMatch() {
    if (_matches.isEmpty) return;
    final next = ((_currentMatchIndex ?? 0) + 1) % _matches.length;
    _selectAndScrollToMatch(next);
  }

  void _prevMatch() {
    if (_matches.isEmpty) return;
    final prev = ((_currentMatchIndex ?? 0) - 1 + _matches.length) % _matches.length;
    _selectAndScrollToMatch(prev);
  }

  @override
  Widget build(BuildContext context) {
    if (_useBasicViewerFallback) {
      return OfficeViewerScreen(file: widget.file);
    }

    final tokens = context.tokens;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filesAsync = ref.watch(filesProvider(null));
    final currentFile = filesAsync.value
            ?.where((f) => f.path == widget.file.path)
            .firstOrNull ??
        widget.file;

    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: tokens.readerCanvas,
      body: FutureBuilder<WorkbookData>(
        future: _workbookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _cachedWorkbook == null) {
            return _buildSkeletonView(tokens, l10n, isDark, topInset, bottomInset, currentFile);
          }

          if (snapshot.hasError && _cachedWorkbook == null) {
            return _buildErrorState(context, snapshot.error!, tokens, l10n, topInset, currentFile);
          }

          final workbook = _cachedWorkbook ?? snapshot.data!;
          final activeSheet = workbook.activeSheet;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Bar / Search Bar
              if (_isSearching)
                ReaderSearchBar(
                  controller: _searchController,
                  onQueryChanged: _onSearchQueryChanged,
                  onClose: _stopSearch,
                  onPrevMatch: _prevMatch,
                  onNextMatch: _nextMatch,
                  onClear: () => _onSearchQueryChanged(''),
                  currentMatchIndex: _currentMatchIndex,
                  totalMatches: _matches.length,
                  isSearching: _isSearchRunning,
                  showNavigationChevrons: true,
                )
              else
                _buildTopBar(tokens, l10n, isDark, topInset, currentFile),

              // 2. Formula Bar
              FormulaBar(
                sheet: activeSheet,
                selection: _selection,
              ),

              // 3. Truncation notice banner
              if ((workbook.isTruncated || activeSheet.isTruncated) && !_dismissedTruncationBanner)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: tokens.blueTint,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: tokens.primaryBlue,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.viewerSpreadsheetTruncatedBanner,
                          style: DocViewTypography.bodySm.copyWith(
                            color: tokens.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _dismissedTruncationBanner = true),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: tokens.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // 4. In-Sheet Search No Matches Notice
              if (_isSearching &&
                  _searchController.text.trim().isNotEmpty &&
                  _matches.isEmpty &&
                  !_isSearchRunning)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: tokens.surfaceAlt,
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 18,
                        color: tokens.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.viewerSpreadsheetNoMatches,
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

              // 5. Grid Viewport with Floating Zoom Pill
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SpreadsheetGrid(
                        sheet: activeSheet,
                        selection: _selection,
                        onSelectionChanged: (sel) => setState(() => _selection = sel),
                        zoomScale: _zoomScale,
                        onZoomChanged: (z) => setState(() => _zoomScale = z),
                        isTableInverted: _isTableInverted,
                        currentSearchMatch: _currentMatchIndex != null && _matches.isNotEmpty
                            ? _matches[_currentMatchIndex!]
                            : null,
                        allSearchMatches: _allMatchCoords,
                        horizontalScrollController: _horizontalScrollController,
                        verticalScrollController: _verticalScrollController,
                      ),
                    ),
                    if ((_zoomScale - 1.0).abs() > 0.05)
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: ZoomPill(
                          scale: _zoomScale,
                          onReset: () => setState(() => _zoomScale = 1.0),
                        ),
                      ),
                  ],
                ),
              ),

              // 6. Sheet Tab Bar (Multi-sheet workbooks)
              SheetTabBar(
                sheetNames: workbook.sheetNames,
                activeIndex: workbook.activeSheetIndex,
                onSheetSelected: _onSheetTabSelected,
              ),

              // 7. Floating Bottom Action Toolbar
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 16 + bottomInset),
                child: ReaderBottomRow(
                  items: [
                    // 1. Rotate
                    ReaderBottomRowItem(
                      icon: Icons.screen_rotation_outlined,
                      label: l10n.readerActionRotate,
                      tooltip: l10n.readerActionRotate,
                      onTap: () => _orientationController.toggle(context),
                    ),
                    // 2. Search
                    ReaderBottomRowItem(
                      icon: Icons.search_rounded,
                      label: l10n.readerActionSearch,
                      tooltip: l10n.readerActionSearch,
                      onTap: _startSearch,
                    ),
                    // 3. Invert
                    ReaderBottomRowItem(
                      icon: Icons.invert_colors_rounded,
                      label: l10n.readerActionInvert,
                      tooltip: l10n.readerActionInvert,
                      isSelected: _isTableInverted,
                      onTap: () => setState(() => _isTableInverted = !_isTableInverted),
                    ),
                    // 4. Share
                    ReaderBottomRowItem(
                      icon: Icons.share_outlined,
                      label: l10n.readerActionShare,
                      tooltip: l10n.readerActionShare,
                      onTap: () {
                        ref
                            .read(fileActionsControllerProvider)
                            .shareFiles([currentFile]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar(
    DocViewTokens tokens,
    dynamic l10n,
    bool isDark,
    double topInset,
    DocFile currentFile,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, topInset + 4, 8, 8),
      decoration: BoxDecoration(
        color: (isDark ? DocViewColors.backgroundDark : Colors.white)
            .withValues(alpha: 0.96),
        border: Border(
          bottom: BorderSide(
            color: tokens.hairline.withValues(alpha: 0.6),
            width: 0.5,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: tokens.textPrimary,
            ),
            tooltip: l10n.tooltipBack,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentFile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DocViewTypography.titleMd.copyWith(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  FormatUtils.formatFileSize(widget.file.sizeBytes),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DocViewTypography.captionXs.copyWith(
                    color: tokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Bookmark toggle
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              currentFile.isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: currentFile.isBookmarked
                  ? tokens.primaryBlue
                  : tokens.textPrimary,
            ),
            tooltip: currentFile.isBookmarked
                ? l10n.tooltipRemoveBookmark
                : l10n.tooltipAddBookmark,
            onPressed: () {
              ref
                  .read(fileActionsControllerProvider)
                  .toggleBookmark(currentFile);
            },
          ),
          // 3-dot popup menu
          IconButton(
            key: const Key('spreadsheet_top_menu_button'),
            icon: Icon(Icons.more_vert_rounded, color: tokens.textPrimary),
            tooltip: l10n.tooltipMoreActions,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () {
              ViewerMoreSheet.show(
                context,
                file: currentFile,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonView(
    DocViewTokens tokens,
    dynamic l10n,
    bool isDark,
    double topInset,
    double bottomInset,
    DocFile currentFile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopBar(tokens, l10n, isDark, topInset, currentFile),
        Expanded(
          child: SpreadsheetGrid(
            sheet: const SheetData(
              name: '',
              rowCount: 10,
              columnCount: 6,
              cells: {},
            ),
            selection: const SpreadsheetSelection.none(),
            onSelectionChanged: (_) {},
            isLoading: true,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 16 + bottomInset),
          child: const ReaderBottomRow(
            isLoading: true,
            items: [],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    Object error,
    DocViewTokens tokens,
    dynamic l10n,
    double topInset,
    DocFile currentFile,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bool isPassword = error is SpreadsheetPasswordProtectedException;
    final bool isTimeout = error is SpreadsheetTimeoutException;
    final bool isTooLarge = error is SpreadsheetTooLargeException;

    final String errorTitle = isPassword
        ? l10n.viewerSpreadsheetPasswordTitle
        : l10n.viewerSpreadsheetErrorTitle;

    final String errorMessage;
    if (isPassword) {
      errorMessage = l10n.viewerSpreadsheetPasswordMessage;
    } else if (isTimeout) {
      errorMessage = l10n.viewerSpreadsheetTimeoutMessage;
    } else if (isTooLarge) {
      errorMessage = l10n.viewerSpreadsheetTooLargeMessage;
    } else {
      errorMessage = l10n.viewerSpreadsheetCorruptMessage;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopBar(tokens, l10n, isDark, topInset, currentFile),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: tokens.surfaceAlt,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: tokens.hairline),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPassword ? Icons.lock_outline_rounded : Icons.broken_image_outlined,
                      size: 56,
                      color: isPassword ? tokens.excel.solid : tokens.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorTitle,
                      style: DocViewTypography.headlineSm.copyWith(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      style: DocViewTypography.bodyMedium.copyWith(
                        color: tokens.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    if (!isPassword) ...[
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: tokens.excel.solid,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.table_chart_outlined, size: 18),
                          label: Text(l10n.viewerSpreadsheetOpenBasicViewer),
                          onPressed: () {
                            setState(() {
                              _useBasicViewerFallback = true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: Text(l10n.viewerSpreadsheetOpenAnotherApp),
                        onPressed: () => OpenFilex.open(widget.file.path),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
