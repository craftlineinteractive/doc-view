import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart' as pdfrx;

import '../../core/constants/file_types.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/format_utils.dart';
import '../../core/utils/page_range_parser.dart';
import '../../data/models/doc_file.dart';
import '../../shared/widgets/ads/ad_placeholders.dart';
import '../../shared/widgets/buttons/doc_icon_button.dart';
import '../../shared/widgets/skeletons/shimmer.dart';
import '../../shared/widgets/tiles/file_thumbnail.dart';
import '../../shared/widgets/tiles/pdf_thumbnail_source.dart';
import '../providers/providers.dart';
import 'services/pdf_page_count_service.dart';
import 'widgets/tool_error_sheet.dart';
import 'widgets/tool_progress_dialog.dart';
import 'widgets/tool_result_sheet.dart';

/// Screen enabling users to inspect page counts, define custom page ranges with live validation,
/// utilize Quick Select macros (capped at 100 files), and split a PDF document into multiple files.
/// Implements Step 2 of Split PDF flow ("Split Config") matching mockups and owner decisions.
class SplitScreen extends ConsumerStatefulWidget {
  const SplitScreen({
    required this.file,
    super.key,
  });

  /// The source PDF to split.
  final DocFile file;

  @override
  ConsumerState<SplitScreen> createState() => _SplitScreenState();
}

class _SplitScreenState extends ConsumerState<SplitScreen> {
  int? _pageCount;
  bool _isLoadingInfo = true;
  String? _infoError;

  late final TextEditingController _rangeController;
  late final TextEditingController _prefixController;
  String? _rangeError;
  List<PageRange> _generatedRanges = <PageRange>[];
  bool _isSplitting = false;

  @override
  void initState() {
    super.initState();
    _rangeController = TextEditingController();
    final basePrefix = p.basenameWithoutExtension(widget.file.name);
    _prefixController = TextEditingController(text: basePrefix);
    _loadDocumentDetails();
  }

  @override
  void dispose() {
    _rangeController.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  Future<void> _loadDocumentDetails() async {
    if (PdfPageCountService.instance.isFlaggedError(widget.file.path)) {
      if (mounted) {
        setState(() {
          _isLoadingInfo = false;
          _infoError = '${widget.file.name} is password-protected or damaged';
        });
      }
      return;
    }

    final cached = PdfPageCountService.instance.getCachedCount(widget.file.path);
    if (cached != null) {
      if (mounted) {
        setState(() {
          _pageCount = cached;
          _isLoadingInfo = false;
        });
      }
      return;
    }

    try {
      final doc = await pdfrx.PdfDocument.openFile(widget.file.path);
      if (doc.isEncrypted) {
        await doc.dispose();
        if (mounted) {
          setState(() {
            _isLoadingInfo = false;
            _infoError = '${widget.file.name} is password-protected or damaged';
          });
        }
        return;
      }
      final count = doc.pages.length;
      await doc.dispose();

      if (mounted) {
        setState(() {
          _pageCount = count;
          _isLoadingInfo = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingInfo = false;
          _infoError = '${widget.file.name} is password-protected or damaged';
        });
      }
    }
  }

  void _onRangeChanged(String text) {
    if (_pageCount == null || _pageCount! < 1) return;
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _rangeError = null;
        _generatedRanges = [];
      });
      return;
    }

    final validation = validatePageRanges(trimmed, _pageCount!);
    if (validation != null) {
      setState(() {
        _rangeError = validation;
        _generatedRanges = [];
      });
    } else {
      final parsed = parsePageRanges(trimmed, _pageCount!);
      setState(() {
        _rangeError = null;
        _generatedRanges = parsed;
      });
    }
  }

  void _onReset() {
    _rangeController.clear();
    setState(() {
      _rangeError = null;
      _generatedRanges = [];
    });
  }

  void _applyAllPagesMacro() {
    final count = _pageCount;
    if (count == null || count < 1 || count > 100) return;

    final pages = List.generate(count, (i) => '${i + 1}').join(', ');
    _rangeController.text = pages;
    _onRangeChanged(pages);
  }

  void _applyEvery5PagesMacro() {
    final count = _pageCount;
    if (count == null || count < 1) return;
    final totalBatches = (count / 5).ceil();
    if (totalBatches > 100) return;

    final ranges = <String>[];
    for (var i = 1; i <= count; i += 5) {
      final end = (i + 4 <= count) ? i + 4 : count;
      if (i == end) {
        ranges.add('$i');
      } else {
        ranges.add('$i-$end');
      }
    }
    final rangeStr = ranges.join(', ');
    _rangeController.text = rangeStr;
    _onRangeChanged(rangeStr);
  }

  int get _totalExtractedPages {
    var sum = 0;
    for (final r in _generatedRanges) {
      sum += r.pageCount;
    }
    return sum;
  }

  int get _estimatedOutputBytes {
    final count = _pageCount;
    if (count == null || count < 1 || _generatedRanges.isEmpty) return 0;
    final extracted = _totalExtractedPages;
    return ((extracted / count) * widget.file.sizeBytes).round();
  }

  Future<void> _splitPdf() async {
    final count = _pageCount;
    if (count == null || count < 1) return;

    final trimmedRange = _rangeController.text.trim();
    final validation = validatePageRanges(trimmedRange, count);
    if (validation != null) {
      setState(() => _rangeError = validation);
      return;
    }

    final ranges = parsePageRanges(trimmedRange, count);
    final prefix = _prefixController.text.trim().isEmpty
        ? p.basenameWithoutExtension(widget.file.name)
        : _prefixController.text.trim();

    setState(() => _isSplitting = true);

    var progressDone = 0;
    final total = ranges.length;
    StateSetter? dialogSetState;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            dialogSetState = setDialogState;
            final progressValue = total > 0 ? progressDone / total : 0.0;
            return ToolProgressDialog(
              title: 'Splitting PDF',
              message: 'Generating file $progressDone of $total...',
              progress: progressValue,
            );
          },
        );
      },
    );

    try {
      final createdFiles = await ref.read(pdfSplitServiceProvider).split(
            widget.file.path,
            ranges,
            namePrefix: prefix,
            onProgress: (done, tot) {
              progressDone = done;
              dialogSetState?.call(() {});
            },
          );

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() => _isSplitting = false);

        await ToolResultSheet.show(
          context,
          files: createdFiles,
          onDone: () async {
            if (mounted) {
              await InterstitialPlaceholder.show(context);
              if (mounted) {
                Navigator.of(context).pop();
              }
            }
          },
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() => _isSplitting = false);
        await ToolErrorSheet.show(
          context,
          title: "Couldn't split PDF",
          errorMessage: e.toString(),
          onRetry: _splitPdf,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final count = _pageCount ?? 0;
    final isAllPagesDisabled = count < 1 || count > 100;
    final isEvery5Disabled = count < 1 || (count / 5).ceil() > 100;
    final canSplit = !_isLoadingInfo &&
        _infoError == null &&
        !_isSplitting &&
        _generatedRanges.isNotEmpty &&
        _rangeError == null;

    return Scaffold(
      backgroundColor: tokens.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: tokens.surface,
              border: Border(
                bottom: BorderSide(color: tokens.hairline, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    DocIconButton(
                      icon: AppIcons.back,
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Split PDF',
                      style: DocViewTypography.headlineSm.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _isLoadingInfo || _isSplitting ? null : _onReset,
                  child: Text(
                    'Reset',
                    style: DocViewTypography.labelMd.copyWith(
                      color: tokens.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoadingInfo
          ? _buildSkeletonState(tokens)
          : _infoError != null
              ? _buildErrorScreen(tokens)
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Document Preview Card
                      _buildDocumentCard(tokens),
                      const SizedBox(height: 16),

                      // Page Ranges Input Card
                      _buildPageRangesInput(tokens),
                      const SizedBox(height: 16),

                      // Live Parsed Generated Files Chips
                      _buildGeneratedChips(tokens),
                      const SizedBox(height: 16),

                      // Quick Select Macros
                      _buildQuickSelectMacros(
                        tokens,
                        isAllPagesDisabled,
                        isEvery5Disabled,
                      ),
                      const SizedBox(height: 16),

                      // Output summary tile
                      _buildOutputSummaryTile(tokens),
                    ],
                  ),
                ),
      bottomSheet: _buildStickyFooter(tokens, canSplit),
    );
  }

  Widget _buildDocumentCard(DocViewTokens tokens) {
    final sizeStr = FormatUtils.formatFileSize(widget.file.sizeBytes);
    final count = _pageCount ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.hairline, width: 1),
      ),
      child: Row(
        children: [
          FileThumbnail(
            filePath: widget.file.path,
            category: FileCategory.pdf,
            source: PdfThumbnailSource.instance,
            width: 56,
            height: 68,
            borderRadius: 10,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DocViewTypography.titleMd.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count ${count == 1 ? 'page' : 'pages'} · $sizeStr',
                  style: DocViewTypography.bodySm.copyWith(
                    color: tokens.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageRangesInput(DocViewTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PAGE RANGES',
              style: DocViewTypography.captionXs.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: tokens.textSecondary,
                fontSize: 11,
              ),
            ),
            Text(
              'Syntax: 1-3, 5, 8-10',
              style: DocViewTypography.captionXs.copyWith(
                color: tokens.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _rangeError != null
                ? tokens.error.withValues(alpha: 0.08)
                : tokens.surfaceAlt,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _rangeError != null ? tokens.error : tokens.hairline,
              width: _rangeError != null ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _rangeController,
                  textInputAction: TextInputAction.done,
                  style: DocViewTypography.titleMd.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: tokens.textPrimary,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'e.g. 1-3, 5, 8-10',
                    hintStyle: DocViewTypography.bodyMedium.copyWith(
                      color: tokens.textSecondary,
                    ),
                    isDense: true,
                  ),
                  onChanged: _onRangeChanged,
                ),
              ),
              if (_rangeController.text.isNotEmpty)
                DocIconButton(
                  icon: AppIcons.close,
                  tooltip: 'Clear range',
                  onPressed: () {
                    _rangeController.clear();
                    _onRangeChanged('');
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        if (_rangeError != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: tokens.error.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: tokens.error,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _rangeError!,
                    style: DocViewTypography.captionXs.copyWith(
                      color: tokens.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            'Each range becomes a separate PDF file.',
            style: DocViewTypography.captionXs.copyWith(
              color: tokens.textSecondary,
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  Widget _buildGeneratedChips(DocViewTokens tokens) {
    final count = _generatedRanges.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GENERATED FILES ($count)',
          style: DocViewTypography.captionXs.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: tokens.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 8),
        if (_rangeError != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tokens.surfaceAlt,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.hairline, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.rule_rounded,
                  color: tokens.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Chips Suspended',
                        style: DocViewTypography.titleMd.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Resolve the syntax error above to reconstruct extraction pipeline.',
                        style: DocViewTypography.captionXs.copyWith(
                          color: tokens.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else if (_generatedRanges.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tokens.surfaceAlt,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.hairline, width: 1),
            ),
            child: Center(
              child: Text(
                'Enter page ranges above to generate PDF slices',
                style: DocViewTypography.captionXs.copyWith(
                  color: tokens.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _generatedRanges.map((range) {
              final label = range.start == range.end
                  ? 'Page ${range.start}'
                  : 'Pages ${range.start}–${range.end}';
              final pgsLabel =
                  '${range.pageCount} ${range.pageCount == 1 ? 'pg' : 'pgs'}';

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: tokens.blueTint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: tokens.primaryBlue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: DocViewTypography.labelMd.copyWith(
                        color: tokens.primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        pgsLabel,
                        style: DocViewTypography.captionXs.copyWith(
                          color: tokens.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildQuickSelectMacros(
    DocViewTokens tokens,
    bool isAllPagesDisabled,
    bool isEvery5Disabled,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK SELECT',
          style: DocViewTypography.captionXs.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: tokens.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Macro 1: All pages
            Expanded(
              child: _buildMacroButton(
                tokens: tokens,
                label: 'All pages',
                isDisabled: isAllPagesDisabled,
                onTap: _applyAllPagesMacro,
              ),
            ),
            const SizedBox(width: 10),
            // Macro 2: Every 5 pages
            Expanded(
              child: _buildMacroButton(
                tokens: tokens,
                label: 'Every 5 pages',
                isDisabled: isEvery5Disabled,
                onTap: _applyEvery5PagesMacro,
              ),
            ),
          ],
        ),
        if (isAllPagesDisabled || isEvery5Disabled)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Macros producing > 100 files are disabled to protect device memory',
              style: DocViewTypography.captionXs.copyWith(
                color: tokens.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMacroButton({
    required DocViewTokens tokens,
    required String label,
    required bool isDisabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDisabled
              ? tokens.hairline.withValues(alpha: 0.3)
              : tokens.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: tokens.hairline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: DocViewTypography.labelMd.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDisabled
                ? tokens.textSecondary.withValues(alpha: 0.4)
                : tokens.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildOutputSummaryTile(DocViewTokens tokens) {
    final fileCount = _generatedRanges.length;
    final extracted = _totalExtractedPages;
    final estBytes = _estimatedOutputBytes;
    final estStr = FormatUtils.formatFileSize(estBytes);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tokens.hairline, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.layers_rounded,
                color: tokens.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Output: $fileCount files · $extracted pages extracted',
                style: DocViewTypography.labelMd.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: tokens.textPrimary,
                ),
              ),
            ],
          ),
          Text(
            'EST ~ $estStr',
            style: DocViewTypography.captionXs.copyWith(
              color: tokens.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter(DocViewTokens tokens, bool canSplit) {
    final fileCount = _generatedRanges.length;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.paddingOf(context).bottom + 12,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        border: Border(top: BorderSide(color: tokens.hairline, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        height: 52,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: tokens.primaryBlue,
            foregroundColor: Colors.white,
            disabledBackgroundColor: tokens.hairline,
            disabledForegroundColor: tokens.textSecondary.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.call_split_rounded, size: 20),
          label: Text(
            canSplit ? 'Split into $fileCount PDFs' : 'Split into PDFs',
            style: DocViewTypography.labelLg.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          onPressed: canSplit ? _splitPdf : null,
        ),
      ),
    );
  }

  Widget _buildSkeletonState(DocViewTokens tokens) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Shimmer(
            child: SkeletonBox(width: double.infinity, height: 96, borderRadius: 16),
          ),
          SizedBox(height: 16),
          Shimmer(
            child: SkeletonBox(width: double.infinity, height: 52, borderRadius: 16),
          ),
          SizedBox(height: 16),
          Shimmer(
            child: SkeletonBox(width: double.infinity, height: 44, borderRadius: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(DocViewTokens tokens) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: tokens.error,
            ),
            const SizedBox(height: 16),
            Text(
              _infoError!,
              textAlign: TextAlign.center,
              style: DocViewTypography.titleMd.copyWith(
                color: tokens.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
