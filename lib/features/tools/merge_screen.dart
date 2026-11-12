import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants/file_types.dart';
import '../../core/utils/format_utils.dart';
import '../../data/models/doc_file.dart';
import '../providers/providers.dart';
import 'widgets/library_pdf_picker_screen.dart';
import 'widgets/tool_error_sheet.dart';
import 'widgets/tool_progress_dialog.dart';
import 'widgets/tool_result_sheet.dart';

/// Screen allowing users to inspect, reorder, delete, and add PDF documents before merging them into a single file.
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
  bool _isMerging = false;

  @override
  void initState() {
    super.initState();
    _files = List<DocFile>.from(widget.initialFiles);
    final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    _nameController = TextEditingController(text: 'Merged_$timestamp');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
    if (_files.isEmpty) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _addMoreFiles() async {
    final picked = await LibraryPdfPickerScreen.pick(
      context,
      multiSelect: true,
      title: 'Add More PDFs',
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

  Future<void> _mergePdfs() async {
    if (_files.length < 2) return;

    final trimmedName = _nameController.text.trim();
    final fileName = trimmedName.isEmpty
        ? 'Merged_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}'
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
          onDone: () {
            if (mounted) {
              Navigator.of(context).pop();
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Merge PDFs'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_files.length} ${_files.length == 1 ? 'file' : 'files'}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // File Name configuration
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: TextField(
              controller: _nameController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Merged File Name',
                suffixText: '.pdf',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Instruction and add more action
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Order determines final page sequence',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(48, 48),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Add PDF'),
                  onPressed: _isMerging ? null : _addMoreFiles,
                ),
              ],
            ),
          ),

          // Reorderable PDF List
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: _files.length,
              onReorderItem: _onReorderItem,
              itemBuilder: (context, index) {
                final file = _files[index];

                return Container(
                  key: ValueKey(file.path),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.1),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: const SizedBox(
                            width: 36,
                            height: 48,
                            child: Icon(Icons.drag_indicator_rounded,
                                color: Colors.white38),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                FileCategory.pdf.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            FileCategory.pdf.icon,
                            color: FileCategory.pdf.color,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      FormatUtils.formatFileSize(file.sizeBytes),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    trailing: IconButton(
                      constraints:
                          const BoxConstraints(minWidth: 48, minHeight: 48),
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                      tooltip: 'Remove',
                      onPressed:
                          _isMerging ? null : () => _removeFile(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.call_merge_rounded),
            label: Text('Merge ${_files.length} PDFs'),
            onPressed:
                _files.length < 2 || _isMerging ? null : _mergePdfs,
          ),
        ),
      ),
    );
  }
}

