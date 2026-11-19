import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../skeletons/shimmer.dart';

/// Top bar replacement widget providing debounced interactive document search.
///
/// Features:
/// - Back button to dismiss search and restore normal reader chrome.
/// - Debounced (300 ms) text input with autofocus.
/// - Match counter with 500+ cap badge and tabular numbers.
/// - Up/Down chevron buttons to navigate between matches.
/// - No-text-layer banner for scanned PDFs.
/// - Accessible semantics and RTL layout support.
class ReaderSearchBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onQueryChanged;
  final VoidCallback? onClose;
  final VoidCallback? onPrevMatch;
  final VoidCallback? onNextMatch;
  final VoidCallback? onClear;
  final int? currentMatchIndex;
  final int totalMatches;
  final bool isSearching;
  final bool hasNoTextLayer;
  final bool isLoading;
  final bool showNavigationChevrons;

  const ReaderSearchBar({
    super.key,
    this.controller,
    this.onQueryChanged,
    this.onClose,
    this.onPrevMatch,
    this.onNextMatch,
    this.onClear,
    this.currentMatchIndex,
    this.totalMatches = 0,
    this.isSearching = false,
    this.hasNoTextLayer = false,
    this.isLoading = false,
    this.showNavigationChevrons = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  State<ReaderSearchBar> createState() => _ReaderSearchBarState();
}

class _ReaderSearchBarState extends State<ReaderSearchBar> {
  late final TextEditingController _controller;
  late final bool _internalController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _internalController = false;
    } else {
      _controller = TextEditingController();
      _internalController = true;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (_internalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(String text) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        widget.onQueryChanged?.call(text);
      }
    });
    setState(() {});
  }

  void _clearText() {
    _controller.clear();
    widget.onClear?.call();
    widget.onQueryChanged?.call('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;
    final topInset = MediaQuery.paddingOf(context).top;

    if (widget.isLoading) {
      return _buildSkeleton(tokens, isDark, topInset);
    }

    final hasQuery = _controller.text.isNotEmpty;
    final hasMatches = widget.totalMatches > 0 && widget.currentMatchIndex != null;

    final String counterText;
    if (!hasQuery) {
      counterText = '';
    } else if (widget.totalMatches > 500) {
      counterText = l10n.readerSearchMatchCap;
    } else if (widget.totalMatches == 0) {
      counterText = l10n.readerSearchNoMatches;
    } else if (widget.currentMatchIndex != null) {
      final current = widget.currentMatchIndex! + 1;
      counterText = l10n.readerSearchMatchCounter(current, widget.totalMatches);
    } else {
      counterText = l10n.readerSearchTotalMatches(widget.totalMatches);
    }

    final clampedScale = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: clampedScale),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8, topInset > 0 ? topInset + 2 : 4, 8, 4),
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
                // Back/Close search button
                IconButton(
                  key: const Key('reader_search_close_button'),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: tokens.textPrimary,
                  ),
                  tooltip: l10n.tooltipCloseSearch,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  padding: EdgeInsets.zero,
                  onPressed: widget.onClose,
                ),
                const SizedBox(width: 4),

                // Search text input
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: tokens.surfaceAlt,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: tokens.hairline.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: tokens.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            key: const Key('reader_search_text_field'),
                            controller: _controller,
                            autofocus: true,
                            textInputAction: TextInputAction.search,
                            style: DocViewTypography.bodyMd.copyWith(
                              color: tokens.textPrimary,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: l10n.readerSearchHint,
                              hintStyle: DocViewTypography.bodyMd.copyWith(
                                color: tokens.textSecondary.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                            onChanged: _onTextChanged,
                          ),
                        ),
                        if (widget.isSearching) ...[
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: tokens.primaryBlue,
                            ),
                          ),
                        ],
                        if (counterText.isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              counterText,
                              key: const Key('reader_search_counter_text'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontFeatures: const [FontFeature.tabularFigures()],
                                color: tokens.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        if (hasQuery) ...[
                          const SizedBox(width: 2),
                          GestureDetector(
                            key: const Key('reader_search_clear_button'),
                            behavior: HitTestBehavior.opaque,
                            onTap: _clearText,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: tokens.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Navigation chevrons (Up / Down)
                if (widget.showNavigationChevrons) ...[
                  IconButton(
                    key: const Key('reader_search_prev_button'),
                    icon: const Icon(Icons.keyboard_arrow_up_rounded),
                    color: hasMatches ? tokens.textPrimary : tokens.textSecondary.withValues(alpha: 0.3),
                    tooltip: l10n.readerSearchPrevMatch,
                    constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                    padding: EdgeInsets.zero,
                    onPressed: hasMatches ? widget.onPrevMatch : null,
                  ),
                  IconButton(
                    key: const Key('reader_search_next_button'),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    color: hasMatches ? tokens.textPrimary : tokens.textSecondary.withValues(alpha: 0.3),
                    tooltip: l10n.readerSearchNextMatch,
                    constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                    padding: EdgeInsets.zero,
                    onPressed: hasMatches ? widget.onNextMatch : null,
                  ),
                ],
              ],
            ),
          ),

        // Scanned PDF warning notice if document has no text layer
        if (widget.hasNoTextLayer)
          Container(
            key: const Key('reader_search_no_text_layer_banner'),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: tokens.primaryBlue.withValues(alpha: 0.12),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: tokens.primaryBlue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.readerSearchNoTextLayer,
                    style: DocViewTypography.bodySm.copyWith(
                      color: tokens.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

  Widget _buildSkeleton(DocViewTokens tokens, bool isDark, double topInset) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, topInset + 8, 16, 12),
      color: isDark ? DocViewColors.backgroundDark : Colors.white,
      child: const Row(
        children: [
          Shimmer(
            child: SkeletonBox(
              width: 36,
              height: 36,
              borderRadius: 18,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Shimmer(
              child: SkeletonBox(
                height: 40,
                borderRadius: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
