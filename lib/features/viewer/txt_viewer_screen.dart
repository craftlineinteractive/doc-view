import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/extensions/l10n_extension.dart';
import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/format_utils.dart';
import '../../data/models/doc_file.dart';
import '../../shared/widgets/buttons/doc_buttons.dart';
import '../../shared/widgets/reader/reader_bottom_row.dart';
import '../../shared/widgets/reader/reader_orientation.dart';
import '../../shared/widgets/reader/reader_search_bar.dart';
import '../../shared/widgets/skeletons/shimmer.dart';
import '../files/widgets/file_details_sheet.dart';
import '../providers/providers.dart';

/// Data class holding processed text lines and truncation status.
class TxtContent {
  const TxtContent({
    required this.lines,
    required this.isTruncated,
  });

  final List<String> lines;
  final bool isTruncated;
}

/// Match location in a text file.
class TxtMatch {
  final int lineIndex;
  final int startOffset;
  final int endOffset;

  const TxtMatch({
    required this.lineIndex,
    required this.startOffset,
    required this.endOffset,
  });
}

/// Top-level synchronous worker function running inside an isolate.
/// Reads a text file safely capping reading to 1 MB with malformed UTF-8 tolerance.
TxtContent readTxtFileWorker(String filePath) {
  final file = File(filePath);
  if (!file.existsSync()) {
    return const TxtContent(lines: [], isTruncated: false);
  }

  final length = file.lengthSync();
  const maxBytes = 1024 * 1024; // 1 MB
  final isTruncated = length > maxBytes;

  List<int> bytes;
  if (isTruncated) {
    final raf = file.openSync(mode: FileMode.read);
    try {
      bytes = raf.readSync(maxBytes);
    } finally {
      raf.closeSync();
    }
  } else {
    bytes = file.readAsBytesSync();
  }

  final decoded = utf8.decode(bytes, allowMalformed: true);
  final lines = const LineSplitter().convert(decoded);
  return TxtContent(lines: lines, isTruncated: isTruncated);
}

/// Dispatches [readTxtFileWorker] in a background isolate via [Isolate.run].
Future<TxtContent> readTxtFileContent(String filePath) {
  return Isolate.run(() => readTxtFileWorker(filePath));
}

/// Top-level isolate worker finding all occurrences of [query] in [lines].
List<TxtMatch> searchTxtMatchesWorker(Map<String, dynamic> args) {
  final lines = args['lines'] as List<String>;
  final query = (args['query'] as String).toLowerCase();
  if (query.isEmpty) return const [];

  final results = <TxtMatch>[];
  final queryLen = query.length;

  for (var lineIdx = 0; lineIdx < lines.length; lineIdx++) {
    final lineLower = lines[lineIdx].toLowerCase();
    var startIdx = 0;
    while (true) {
      final matchIdx = lineLower.indexOf(query, startIdx);
      if (matchIdx == -1) break;
      results.add(TxtMatch(
        lineIndex: lineIdx,
        startOffset: matchIdx,
        endOffset: matchIdx + queryLen,
      ));
      startIdx = matchIdx + queryLen;
    }
  }
  return results;
}

/// Content-first text document reader with isolate-backed decoding,
/// background isolate search with highlighting, theme inversion,
/// and shared reader chrome.
class TxtViewerScreen extends ConsumerStatefulWidget {
  const TxtViewerScreen({
    required this.file,
    super.key,
  });

  final DocFile file;

  @override
  ConsumerState<TxtViewerScreen> createState() => _TxtViewerScreenState();
}

class _TxtViewerScreenState extends ConsumerState<TxtViewerScreen> {
  static const String _keyFontSize = 'txt_font_size';
  static const String _keyMonospace = 'txt_is_monospace';

  late Future<TxtContent> _contentFuture;
  late final ReaderOrientationController _orientationController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  double _fontSize = 15.0;
  bool _isMonospace = false;
  bool _dismissedTruncationBanner = false;
  bool _showChrome = true;
  bool _isInverted = false;
  bool _isSearching = false;
  bool _isSearchRunning = false;

  List<String> _cachedLines = const [];
  List<TxtMatch> _matches = const [];
  Map<int, List<TxtMatch>> _matchesByLine = const {};
  int? _currentMatchIndex;

  @override
  void initState() {
    super.initState();
    _orientationController = ReaderOrientationController();
    _contentFuture = readTxtFileContent(widget.file.path).then((data) {
      if (mounted) {
        setState(() {
          _cachedLines = data.lines;
        });
      }
      return data;
    });
    _loadPreferences();
  }

  @override
  void dispose() {
    _orientationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _fontSize = (prefs.getDouble(_keyFontSize) ?? 15.0).clamp(12.0, 28.0);
        _isMonospace = prefs.getBool(_keyMonospace) ?? false;
      });
    } catch (_) {}
  }

  Future<void> _setFontSize(double newSize) async {
    final clamped = newSize.clamp(12.0, 28.0);
    setState(() {
      _fontSize = clamped;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_keyFontSize, clamped);
    } catch (_) {}
  }

  Future<void> _toggleMonospace() async {
    final next = !_isMonospace;
    setState(() {
      _isMonospace = next;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyMonospace, next);
    } catch (_) {}
  }

  void _retry() {
    setState(() {
      _contentFuture = readTxtFileContent(widget.file.path).then((data) {
        if (mounted) {
          setState(() {
            _cachedLines = data.lines;
          });
        }
        return data;
      });
    });
  }

  void _toggleChrome() {
    if (_isSearching) return;
    setState(() {
      _showChrome = !_showChrome;
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
      _showChrome = true;
    });
  }

  void _stopSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _matches = const [];
      _matchesByLine = const {};
      _currentMatchIndex = null;
    });
  }

  Future<void> _onSearchQueryChanged(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty || _cachedLines.isEmpty) {
      setState(() {
        _matches = const [];
        _matchesByLine = const {};
        _currentMatchIndex = null;
        _isSearchRunning = false;
      });
      return;
    }

    setState(() {
      _isSearchRunning = true;
    });

    final found = await Isolate.run(
      () => searchTxtMatchesWorker({'lines': _cachedLines, 'query': trimmed}),
    );

    if (!mounted) return;

    final byLine = <int, List<TxtMatch>>{};
    for (final m in found) {
      byLine.putIfAbsent(m.lineIndex, () => []).add(m);
    }

    setState(() {
      _matches = found;
      _matchesByLine = byLine;
      _currentMatchIndex = found.isNotEmpty ? 0 : null;
      _isSearchRunning = false;
    });

    if (found.isNotEmpty) {
      _scrollToMatch(0);
    }
  }

  void _nextMatch() {
    if (_matches.isEmpty) return;
    final next = ((_currentMatchIndex ?? 0) + 1) % _matches.length;
    setState(() {
      _currentMatchIndex = next;
    });
    _scrollToMatch(next);
  }

  void _prevMatch() {
    if (_matches.isEmpty) return;
    final prev = ((_currentMatchIndex ?? 0) - 1 + _matches.length) % _matches.length;
    setState(() {
      _currentMatchIndex = prev;
    });
    _scrollToMatch(prev);
  }

  void _scrollToMatch(int matchIndex) {
    if (_matches.isEmpty || matchIndex < 0 || matchIndex >= _matches.length) return;
    final match = _matches[matchIndex];
    if (_scrollController.hasClients) {
      final approxLineHeight = _fontSize * 1.5 + 4;
      final target = (match.lineIndex * approxLineHeight) - 80;
      final clamped = target.clamp(0.0, _scrollController.position.maxScrollExtent);
      _scrollController.animateTo(
        clamped,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _showTypographySheet(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? DocViewColors.backgroundDark : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: tokens.textSecondary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.txtViewerTypographyTitle,
                          style: DocViewTypography.headlineSm.copyWith(
                            color: tokens.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: tokens.primaryBlue.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            l10n.txtViewerFontSizeLabel(_fontSize.round()),
                            style: TextStyle(
                              color: tokens.primaryBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Font size slider
                    Row(
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                          icon: Icon(Icons.remove_rounded, color: tokens.textPrimary),
                          tooltip: l10n.txtViewerTooltipDecreaseFont,
                          onPressed: _fontSize > 12.0
                              ? () {
                                  _setFontSize(_fontSize - 1.0);
                                  setSheetState(() {});
                                }
                              : null,
                        ),
                        Expanded(
                          child: Slider(
                            value: _fontSize,
                            min: 12.0,
                            max: 28.0,
                            divisions: 16,
                            activeColor: tokens.primaryBlue,
                            inactiveColor: tokens.hairline,
                            onChanged: (val) {
                              _setFontSize(val);
                              setSheetState(() {});
                            },
                          ),
                        ),
                        IconButton(
                          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                          icon: Icon(Icons.add_rounded, color: tokens.textPrimary),
                          tooltip: l10n.txtViewerTooltipIncreaseFont,
                          onPressed: _fontSize < 28.0
                              ? () {
                                  _setFontSize(_fontSize + 1.0);
                                  setSheetState(() {});
                                }
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Monospace toggle
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.txtViewerMonospaceLabel,
                        style: DocViewTypography.bodyMd.copyWith(
                          color: tokens.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        l10n.txtViewerMonospaceSubtitle,
                        style: DocViewTypography.captionXs.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                      value: _isMonospace,
                      activeThumbColor: tokens.primaryBlue,
                      onChanged: (val) {
                        setSheetState(() {});
                        _toggleMonospace();
                      },
                    ),
                    const SizedBox(height: 16),

                    // Live preview line
                    Text(
                      l10n.txtViewerPreviewLabel,
                      style: DocViewTypography.captionXs.copyWith(
                        color: tokens.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: tokens.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: tokens.hairline),
                      ),
                      child: Text(
                        l10n.txtViewerPreviewText,
                        style: TextStyle(
                          fontSize: _fontSize,
                          fontFamily: _isMonospace ? 'monospace' : null,
                          height: 1.5,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch filesProvider to reflect bookmark toggles in real-time
    final filesAsync = ref.watch(filesProvider(null));
    final currentFile = filesAsync.value
            ?.where((f) => f.path == widget.file.path)
            .firstOrNull ??
        widget.file;

    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Invert text reading surface colors
    final Color surfaceBg;
    final Color surfaceFg;
    if (isDark) {
      surfaceBg = _isInverted ? Colors.white : DocViewColors.backgroundDark;
      surfaceFg = _isInverted ? const Color(0xFF1E2433) : tokens.textPrimary;
    } else {
      surfaceBg = _isInverted ? DocViewColors.backgroundDark : Colors.white;
      surfaceFg = _isInverted ? Colors.white : tokens.textPrimary;
    }

    return Scaffold(
      backgroundColor: tokens.readerCanvas,
      body: Stack(
        children: [
          // 1. Text reading canvas
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _toggleChrome,
              child: FutureBuilder<TxtContent>(
                future: _contentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildSkeletonBody(tokens, topInset);
                  }

                  if (snapshot.hasError) {
                    return _buildErrorBody(context, tokens, l10n);
                  }

                  final data = snapshot.data!;
                  final lines = data.lines;

                  return Container(
                    color: surfaceBg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: topInset + 56),

                        // Truncation notice banner
                        if (data.isTruncated && !_dismissedTruncationBanner)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
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
                                    l10n.txtViewerTruncationBanner,
                                    style: DocViewTypography.bodySm.copyWith(
                                      color: tokens.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _dismissedTruncationBanner = true;
                                    });
                                  },
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

                        // Virtualized Line List with Match Highlighting & SelectionArea
                        Expanded(
                          child: SelectionArea(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.fromLTRB(20, 16, 20, 80 + bottomInset),
                              itemCount: lines.length,
                              itemBuilder: (context, index) {
                                final line = lines[index];
                                final lineMatches = _matchesByLine[index];

                                return _buildLineWidget(
                                  line: line,
                                  lineMatches: lineMatches,
                                  textColor: surfaceFg,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Animated Top Bar / Search Bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            top: (_showChrome || _isSearching) ? 0 : -(100 + topInset),
            left: 0,
            right: 0,
            child: _isSearching
                ? ReaderSearchBar(
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
                : _buildTopBar(tokens, l10n, isDark, topInset, currentFile),
          ),

          // 3. Animated Floating Bottom Toolbar ([ReaderBottomRow])
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            bottom: _showChrome ? (16 + bottomInset) : -(100 + bottomInset),
            left: 20,
            right: 20,
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
                  isSelected: _isInverted,
                  onTap: () {
                    setState(() {
                      _isInverted = !_isInverted;
                    });
                  },
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
      ),
    );
  }

  Widget _buildLineWidget({
    required String line,
    required List<TxtMatch>? lineMatches,
    required Color textColor,
  }) {
    if (line.isEmpty) {
      return SizedBox(height: _fontSize * 1.5);
    }

    if (lineMatches == null || lineMatches.isEmpty) {
      return Text(
        line,
        style: TextStyle(
          fontSize: _fontSize,
          fontFamily: _isMonospace ? 'monospace' : null,
          height: 1.5,
          color: textColor,
        ),
      );
    }

    final spans = <TextSpan>[];
    var lastIdx = 0;

    for (final match in lineMatches) {
      if (match.startOffset > lastIdx && match.startOffset <= line.length) {
        spans.add(TextSpan(
          text: line.substring(lastIdx, match.startOffset),
          style: TextStyle(color: textColor),
        ));
      }

      final isCurrent = _currentMatchIndex != null &&
          _currentMatchIndex! >= 0 &&
          _currentMatchIndex! < _matches.length &&
          identical(_matches[_currentMatchIndex!], match);

      final safeEnd = match.endOffset.clamp(0, line.length);
      if (match.startOffset < safeEnd) {
        spans.add(TextSpan(
          text: line.substring(match.startOffset, safeEnd),
          style: TextStyle(
            color: Colors.black,
            backgroundColor: isCurrent
                ? Colors.orange.withValues(alpha: 0.8)
                : Colors.yellow.withValues(alpha: 0.65),
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ));
      }
      lastIdx = safeEnd;
    }

    if (lastIdx < line.length) {
      spans.add(TextSpan(
        text: line.substring(lastIdx),
        style: TextStyle(color: textColor),
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
      style: TextStyle(
        fontSize: _fontSize,
        fontFamily: _isMonospace ? 'monospace' : null,
        height: 1.5,
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
    final subtitle = _cachedLines.isNotEmpty
        ? l10n.txtViewerLinesSubtitle(
            _cachedLines.length,
            FormatUtils.formatFileSize(widget.file.sizeBytes),
          )
        : FormatUtils.formatFileSize(widget.file.sizeBytes);

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
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DocViewTypography.captionXs.copyWith(
                    color: tokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Typography button
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              Icons.tune_rounded,
              color: tokens.textPrimary,
              size: 20,
            ),
            tooltip: l10n.txtViewerTooltipTypography,
            onPressed: () => _showTypographySheet(context),
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
                : l10n.tooltipBookmark,
            onPressed: () {
              ref
                  .read(fileActionsControllerProvider)
                  .toggleBookmark(currentFile);
            },
          ),
          // 3-dot popup menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: tokens.textPrimary),
            tooltip: l10n.tooltipMoreOptions,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (action) {
              if (action == 'details') {
                FileDetailsSheet.show(context, currentFile);
              } else if (action == 'open_external') {
                OpenFilex.open(widget.file.path);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'details',
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: tokens.textPrimary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.readerMenuDetails,
                      style: DocViewTypography.bodyMd.copyWith(
                        color: tokens.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'open_external',
                child: Row(
                  children: [
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 20,
                      color: tokens.textPrimary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.readerMenuOpenExternal,
                      style: DocViewTypography.bodyMd.copyWith(
                        color: tokens.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonBody(DocViewTokens tokens, double topInset) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, topInset + 70, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < 8; i++) ...[
            Shimmer(
              child: Container(
                width: i % 3 == 0
                    ? 180
                    : (i % 2 == 0 ? double.infinity : 280),
                height: 14,
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorBody(
    BuildContext context,
    DocViewTokens tokens,
    dynamic l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: DocViewColors.pdfSolid.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: DocViewColors.pdfSolid,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.txtViewerErrorTitle,
              textAlign: TextAlign.center,
              style: DocViewTypography.headlineSm.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.txtViewerErrorMessage,
              textAlign: TextAlign.center,
              style: DocViewTypography.bodyMd.copyWith(
                color: tokens.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            DocPrimaryButton(
              label: l10n.viewerActionOpenExternal,
              icon: const Icon(Icons.open_in_new_rounded, size: 20, color: Colors.white),
              onPressed: () {
                OpenFilex.open(widget.file.path);
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _retry,
              child: Text(
                l10n.txtViewerActionRetry,
                style: DocViewTypography.labelLg.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
