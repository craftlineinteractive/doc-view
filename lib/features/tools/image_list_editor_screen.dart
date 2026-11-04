import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/services/pdf/image_to_pdf_service.dart';
import '../providers/providers.dart';
import 'widgets/tool_result_bottom_sheet.dart';

/// Screen allowing users to inspect, reorder, delete, and append pages before generating a PDF from images or scans.
class ImageListEditorScreen extends ConsumerStatefulWidget {
  const ImageListEditorScreen({
    required this.initialImagePaths,
    this.defaultNamePrefix = 'Images',
    this.isScannerSource = false,
    super.key,
  });

  /// The list of image paths initially selected or scanned.
  final List<String> initialImagePaths;

  /// Prefix for the generated file name.
  final String defaultNamePrefix;

  /// Whether the session originated from the document scanner.
  final bool isScannerSource;

  @override
  ConsumerState<ImageListEditorScreen> createState() =>
      _ImageListEditorScreenState();
}

class _ImageListEditorScreenState extends ConsumerState<ImageListEditorScreen> {
  late final List<String> _imagePaths;
  late final TextEditingController _nameController;
  PageMode _pageMode = PageMode.a4;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _imagePaths = List<String>.from(widget.initialImagePaths);
    final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    _nameController = TextEditingController(
      text: '${widget.defaultNamePrefix}_$timestamp',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onReorderItem(int oldIndex, int newIndex) {
    setState(() {
      final item = _imagePaths.removeAt(oldIndex);
      _imagePaths.insert(newIndex, item);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
    if (_imagePaths.isEmpty) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _addMoreImages() async {
    if (widget.isScannerSource) {
      try {
        final scans = await CunningDocumentScanner.getPictures();
        if (scans != null && scans.isNotEmpty && mounted) {
          setState(() {
            _imagePaths.addAll(scans);
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Scanning failed: $e')),
          );
        }
      }
    } else {
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.image,
      );
      if (pickedFiles.isNotEmpty && mounted) {
        final newPaths =
            pickedFiles.map((f) => f.path).whereType<String>().where((p) => p.isNotEmpty);
        setState(() {
          _imagePaths.addAll(newPaths);
        });
      }
    }
  }

  Future<void> _createPdf() async {
    if (_imagePaths.isEmpty) return;

    final trimmedName = _nameController.text.trim();
    final fileName = trimmedName.isEmpty
        ? '${widget.defaultNamePrefix}_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}'
        : trimmedName;

    setState(() => _isCreating = true);

    var progressDone = 0;
    final total = _imagePaths.length;
    StateSetter? dialogSetState;

    // Show non-dismissible progress modal
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            dialogSetState = setDialogState;
            final progressValue = total > 0 ? progressDone / total : 0.0;
            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: const Text('Creating PDF'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(value: progressValue),
                    const SizedBox(height: 16),
                    Text(
                      'Processing image $progressDone of $total...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    try {
      final docFile = await ref.read(imageToPdfServiceProvider).createPdf(
            _imagePaths,
            pageMode: _pageMode,
            name: fileName,
            onProgress: (done, tot) {
              progressDone = done;
              dialogSetState?.call(() {});
            },
          );

      if (mounted) {
        // Dismiss progress dialog
        Navigator.of(context, rootNavigator: true).pop();
        setState(() => _isCreating = false);

        await ToolResultBottomSheet.show(
          context,
          files: [docFile],
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
        setState(() => _isCreating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit & Create PDF'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_imagePaths.length} ${_imagePaths.length == 1 ? 'page' : 'pages'}',
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
          // Configuration Panel (File Name & Page Layout)
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'File Name',
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Page Size:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SegmentedButton<PageMode>(
                        segments: const [
                          ButtonSegment<PageMode>(
                            value: PageMode.a4,
                            label: Text('A4'),
                            icon: Icon(Icons.description_outlined, size: 16),
                          ),
                          ButtonSegment<PageMode>(
                            value: PageMode.fitImage,
                            label: Text('Fit Image'),
                            icon: Icon(Icons.aspect_ratio_outlined, size: 16),
                          ),
                        ],
                        selected: {_pageMode},
                        onSelectionChanged: (newSelection) {
                          setState(() {
                            _pageMode = newSelection.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Add more button toolbar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Drag items to reorder pages',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(48, 48),
                  ),
                  icon: const Icon(Icons.add_photo_alternate_rounded, size: 20),
                  label: const Text('Add More'),
                  onPressed: _isCreating ? null : _addMoreImages,
                ),
              ],
            ),
          ),

          // Reorderable list of thumbnails
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: _imagePaths.length,
              onReorderItem: _onReorderItem,
              itemBuilder: (context, index) {
                final path = _imagePaths[index];
                final file = File(path);

                return Container(
                  key: ValueKey(path + index.toString()),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Image.file(
                              file,
                              cacheWidth: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.grey.withValues(alpha: 0.2),
                                child: const Icon(Icons.broken_image_rounded),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      'Page ${index + 1}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      path.split(Platform.pathSeparator).last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                      tooltip: 'Remove page',
                      onPressed:
                          _isCreating ? null : () => _removeImage(index),
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
            icon: const Icon(Icons.picture_as_pdf_rounded),
            label: Text('Create PDF (${_imagePaths.length} Pages)'),
            onPressed:
                _imagePaths.isEmpty || _isCreating ? null : _createPdf,
          ),
        ),
      ),
    );
  }
}

