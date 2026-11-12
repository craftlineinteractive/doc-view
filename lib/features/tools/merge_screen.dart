import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants/file_types.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/file_name_utils.dart';
import '../../core/utils/format_utils.dart';
import '../../data/models/doc_file.dart';
import '../../shared/widgets/ads/ad_placeholders.dart';
import '../../shared/widgets/buttons/doc_icon_button.dart';
import '../../shared/widgets/tiles/file_thumbnail.dart';
import '../../shared/widgets/tiles/pdf_thumbnail_source.dart';
import '../providers/providers.dart';
import 'services/pdf_page_count_service.dart';
import 'widgets/merge_pdf_picker_screen.dart';
import 'widgets/tool_error_sheet.dart';
import 'widgets/tool_progress_dialog.dart';
import 'widgets/tool_result_sheet.dart';

/// Screen allowing users to inspect, reorder, delete, and add PDF documents before merging them into a single file.
/// Implements Step 2 of Merge PDF flow ("Arrange & merge") matching mockups and owner decisions.
class MergeScreen extends ConsumerStatefulWidget {
  const MergeScreen({
    required this.initialFiles,
    super.key,
  });

  /// The list of PDF documents selected from the picker.
  final List<DocFile> initialFiles;

  @override
  ConsumerState<MergeScreen> createState() => _MergeScreenState();
}

class _MergeScreenState extends ConsumerState<MergeScreen> {
  late final List<DocFile> _files;
  late final TextEditingController _nameController;
  String? _nameError;
  bool _isMerging = false;

  @override
  void initState() {
    super.initState();
    _files = List<DocFile>.from(widget.initialFiles);
    final dateStr = DateFormat('yyyyMMdd').format(DateTime.now());
    _nameController = TextEditingController(text: 'Merged_$dateStr');

    // Trigger page count caching for initial files
    for (final f in _files) {
      PdfPageCountService.instance.loadPageCount(
        f.path,
        onLoaded: () {
          if (mounted) setState(() {});
        },
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged(String val) {
    setState(() {
      _nameError = validateFileName(val);
    });
  }

  void _onReorderItem(int oldIndex, int newIndex) {
    setState(() {
      final item = _files.removeAt(oldIndex);
      _files.insert(newIndex, item);
    });
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
    if (_files.isEmpty && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onClear() {
    setState(() {
      _files.clear();
    });
    Navigator.of(context).pop();
  }

  Future<void> _addMoreFiles() async {
    final picked = await MergePdfPickerScreen.pick(
      context,
      title: 'Add More PDFs',
      minSelection: 1,
    );
    if (picked != null && picked.isNotEmpty && mounted) {
      final existingPaths = _files.map((f) => f.path).toSet();
      setState(() {
        for (final file in picked) {
          if (!existingPaths.contains(file.path)) {
            _files.add(file);
          }
        }
      });
    }
  }

  int get _flaggedCount {
    return _files
        .where((f) => PdfPageCountService.instance.isFlaggedError(f.path))
        .length;
  }

  int get _totalCalculatedPages {
    var sum = 0;
    for (final f in _files) {
      final count = PdfPageCountService.instance.getCachedCount(f.path);
      if (count != null) {
        sum += count;
      }
    }
    return sum;
  }

  int get _totalSizeBytes {
    var sum = 0;
    for (final f in _files) {
      sum += f.sizeBytes;
    }
    return sum;
  }

  Future<void> _mergePdfs() async {
    if (_files.length < 2 || _flaggedCount > 0) return;

    final trimmedName = _nameController.text.trim();
    final validation = validateFileName(trimmedName);
    if (validation != null) {
      setState(() => _nameError = validation);
      return;
    }

    final fileName = trimmedName.isEmpty
        ? 'Merged_${DateFormat('yyyyMMdd').format(DateTime.now())}'
        : trimmedName;

    setState(() => _isMerging = true);

    var progressDone = 0;
    final total = _files.length;
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
              title: 'Merging PDFs',
              message: 'Merging document $progressDone of $total...',
              progress: progressValue,
            );
          },
        );
      },
    );

    try {
      final pdfPaths = _files.map((f) => f.path).toList();
      final mergedDoc = await ref.read(pdfMergeServiceProvider).merge(
            pdfPaths,
            name: fileName,
            onProgress: (done, tot) {
              progressDone = done;
              dialogSetState?.call(() {});
            },
          );

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() => _isMerging = false);

        await ToolResultSheet.show(
          context,
          files: [mergedDoc],
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
        setState(() => _isMerging = false);
        await ToolErrorSheet.show(
          context,
          title: "Couldn't merge PDFs",
          errorMessage: e.toString(),
          onRetry: _mergePdfs,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasErrors = _flaggedCount > 0;
    final isNameValid = _nameError == null && _nameController.text.trim().isNotEmpty;
    final canMerge = _files.length >= 2 && !hasErrors && isNameValid && !_isMerging;

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
                      'Arrange & merge',
                      style: DocViewTypography.headlineSm.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _isMerging ? null : _onClear,
                  child: Text(
                    'Clear',
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
      body: Column(
        children: [
          // Drag instruction banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: tokens.surfaceAlt,
              border: Border(
                bottom: BorderSide(color: tokens.hairline, width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.drag_indicator_rounded,
                  size: 18,
                  color: tokens.primaryBlue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Drag handles to reorder',
                    style: DocViewTypography.captionXs.copyWith(
                      color: tokens.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _isMerging ? null : _addMoreFiles,
                  icon: Icon(Icons.add_rounded, size: 16, color: tokens.primaryBlue),
                  label: Text(
                    'Add PDF',
                    style: DocViewTypography.labelXs.copyWith(
                      color: tokens.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Output File Name field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OUTPUT FILE NAME',
                  style: DocViewTypography.captionXs.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: tokens.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: tokens.surfaceAlt,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _nameError != null ? tokens.error : tokens.hairline,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        color: tokens.primaryBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          textInputAction: TextInputAction.done,
                          style: DocViewTypography.titleMd.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: tokens.textPrimary,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Merged_fileName',
                            hintStyle: DocViewTypography.bodyMedium.copyWith(
                              color: tokens.textSecondary,
                            ),
                            isDense: true,
                          ),
                          onChanged: _onNameChanged,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: tokens.error,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '.pdf',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_nameError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Text(
                      _nameError!,
                      style: DocViewTypography.captionXs.copyWith(
                        color: tokens.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Reorderable list
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: _files.length,
              onReorderItem: _onReorderItem,
              itemBuilder: (context, index) {
                final file = _files[index];
                final isFlagged =
                    PdfPageCountService.instance.isFlaggedError(file.path);
                final pageCount =
                    PdfPageCountService.instance.getCachedCount(file.path);
                final sizeStr = FormatUtils.formatFileSize(file.sizeBytes);

                if (isFlagged) {
                  // Flagged Error Row
                  return Container(
                    key: ValueKey(file.path),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: tokens.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: tokens.error.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                color: tokens.error,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      file.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: DocViewTypography.titleMd.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: tokens.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${file.name} is password-protected or damaged',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: DocViewTypography.captionXs.copyWith(
                                        color: tokens.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: tokens.error,
                                  foregroundColor: Colors.white,
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => _removeFile(index),
                                child: const Text('Remove', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Standard valid reorderable item
                return Container(
                  key: ValueKey(file.path),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: tokens.surfaceAlt,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: tokens.hairline, width: 1),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: Container(
                            width: 32,
                            height: 44,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.drag_handle_rounded,
                              color: tokens.textSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                        FileThumbnail(
                          filePath: file.path,
                          category: FileCategory.pdf,
                          source: PdfThumbnailSource.instance,
                          width: 38,
                          height: 44,
                          borderRadius: 8,
                        ),
                      ],
                    ),
                    title: Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DocViewTypography.titleMd.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: tokens.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      '${pageCount != null ? '$pageCount pages' : 'Loading pages...'} · $sizeStr',
                      style: DocViewTypography.bodySm.copyWith(
                        color: tokens.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: tokens.textSecondary,
                        size: 20,
                      ),
                      tooltip: 'Remove',
                      onPressed: () => _removeFile(index),
                    ),
                  ),
                );
              },
            ),
          ),

          // Pre-flight Card & Sticky Action
          _buildPreflightAndBottomBar(tokens, canMerge, hasErrors),
        ],
      ),
    );
  }

  Widget _buildPreflightAndBottomBar(
    DocViewTokens tokens,
    bool canMerge,
    bool hasErrors,
  ) {
    final sizeFormatted = FormatUtils.formatFileSize(_totalSizeBytes);
    final totalPages = _totalCalculatedPages;

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Preflight card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: hasErrors
                  ? tokens.error.withValues(alpha: 0.08)
                  : tokens.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasErrors
                    ? tokens.error.withValues(alpha: 0.3)
                    : tokens.hairline,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasErrors ? '1 invalid file detected' : 'Ready to merge',
                      style: DocViewTypography.captionXs.copyWith(
                        fontWeight: FontWeight.bold,
                        color: hasErrors ? tokens.error : tokens.textPrimary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasErrors
                          ? 'Please remove password-protected documents'
                          : '${_files.length} files · $totalPages pages · ~ $sizeFormatted',
                      style: DocViewTypography.captionXs.copyWith(
                        color: tokens.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                if (!hasErrors)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tokens.blueTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Ready',
                      style: DocViewTypography.captionXs.copyWith(
                        color: tokens.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Primary CTA button
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: tokens.primaryBlue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: tokens.hairline,
                disabledForegroundColor:
                    tokens.textSecondary.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: Icon(
                hasErrors ? Icons.lock_outline_rounded : Icons.call_merge_rounded,
                size: 20,
              ),
              label: Text(
                hasErrors
                    ? 'Merge Blocked (Resolve Errors)'
                    : 'Merge ${_files.length} PDFs ($totalPages Pages)',
                style: DocViewTypography.labelLg.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              onPressed: canMerge ? _mergePdfs : null,
            ),
          ),
        ],
      ),
    );
  }
}
