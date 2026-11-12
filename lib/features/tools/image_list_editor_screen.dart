import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/format_utils.dart';
import '../../data/services/pdf/image_to_pdf_service.dart';
import '../../shared/widgets/ads/ad_placeholders.dart';
import '../../shared/widgets/buttons/doc_buttons.dart';
import '../../shared/widgets/buttons/doc_icon_button.dart';
import '../../shared/widgets/navigation/doc_app_bar.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';
import '../../shared/widgets/tools/doc_tool_widgets.dart';
import '../providers/providers.dart';
import 'widgets/tool_error_sheet.dart';
import 'widgets/tool_progress_dialog.dart';
import 'widgets/tool_result_sheet.dart';

/// Screen allowing users to inspect, reorder, delete, and append pages before generating a PDF from images or scans.
/// Enforces strict 100-image cap, A4 vs Fit to Image segmented control, file name validation, and sticky footer.
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
  static const int maxImageCount = 100;

  late final List<String> _imagePaths;
  late final TextEditingController _nameController;
  final Map<String, int> _fileSizes = {};
  int _totalBytes = 0;
  PageMode _pageMode = PageMode.a4;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _imagePaths = List<String>.from(
      widget.initialImagePaths.take(maxImageCount),
    );
    final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    _nameController = TextEditingController(
      text: '${widget.defaultNamePrefix}_$timestamp',
    );
    _nameController.addListener(() => setState(() {}));
    _updateSizes();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateSizes() {
    int sum = 0;
    for (final path in _imagePaths) {
      if (!_fileSizes.containsKey(path)) {
        try {
          _fileSizes[path] = File(path).lengthSync();
        } catch (_) {
          _fileSizes[path] = 0;
        }
      }
      sum += _fileSizes[path] ?? 0;
    }
    _totalBytes = sum;
  }

  void _onReorderItem(int oldIndex, int newIndex) {
    setState(() {
      var targetIndex = newIndex;
      if (oldIndex < targetIndex) {
        targetIndex -= 1;
      }
      final item = _imagePaths.removeAt(oldIndex);
      _imagePaths.insert(targetIndex, item);
    });
  }

  void _removeImage(int index) {
    setState(() {
      final removed = _imagePaths.removeAt(index);
      _fileSizes.remove(removed);
      _updateSizes();
    });
  }

  void _clearAll() {
    setState(() {
      _imagePaths.clear();
      _fileSizes.clear();
      _totalBytes = 0;
    });
  }

  Future<void> _addMoreImages() async {
    if (_imagePaths.length >= maxImageCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum limit of 100 images reached.'),
        ),
      );
      return;
    }

    if (widget.isScannerSource) {
      final messenger = ScaffoldMessenger.of(context);
      try {
        final scans = await CunningDocumentScanner.getPictures();
        if (!mounted) return;
        if (scans != null && scans.isNotEmpty) {
          final remaining = maxImageCount - _imagePaths.length;
          setState(() {
            _imagePaths.addAll(scans.take(remaining));
            _updateSizes();
          });
        }
      } catch (e) {
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(content: Text('Scanning failed: $e')),
        );
      }
    } else {
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.image,
      );
      if (pickedFiles.isNotEmpty && mounted) {
        final newPaths = pickedFiles
            .map((f) => f.path)
            .whereType<String>()
            .where((p) => p.isNotEmpty)
            .toList();
        final remaining = maxImageCount - _imagePaths.length;
        setState(() {
          _imagePaths.addAll(newPaths.take(remaining));
          _updateSizes();
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
            return ToolProgressDialog(
              title: widget.isScannerSource ? 'Creating PDF from Scans' : 'Creating PDF',
              message: 'Processing image $progressDone of $total...',
              progress: progressValue,
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

        // Show result sheet
        await ToolResultSheet.show(
          context,
          files: [docFile],
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
        // Dismiss progress dialog
        Navigator.of(context, rootNavigator: true).pop();
        setState(() => _isCreating = false);

        await ToolErrorSheet.show(
          context,
          title: "Couldn't create PDF",
          errorMessage: e.toString(),
          onRetry: _createPdf,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isNameValid = _nameController.text.trim().isNotEmpty;
    final canCreate = _imagePaths.isNotEmpty && isNameValid && !_isCreating;

    return DocScaffold(
      showDockedBanner: false, // No ads on editor/creator screens
      isAdLoaded: false,
      appBar: DocSubAppBar(
        title: widget.isScannerSource ? 'Scan to PDF' : 'Image to PDF',
        actions: [
          if (_imagePaths.isNotEmpty)
            TextButton(
              onPressed: _isCreating ? null : _clearAll,
              child: Text(
                'Clear',
                style: DocViewTypography.labelMd.copyWith(
                  color: DocViewColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Config Bar: File Name and Page Mode Segmented Control
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            decoration: BoxDecoration(
              color: tokens.surfaceAlt,
              border: Border(
                bottom: BorderSide(color: tokens.hairline, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // File name field with locked .pdf suffix
                TextField(
                  controller: _nameController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'File Name',
                    suffixText: '.pdf',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: tokens.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: tokens.hairline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: tokens.hairline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: tokens.interactiveBlue, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Page Size Segmented Control
                Row(
                  children: [
                    Text(
                      'Page Size:',
                      style: DocViewTypography.labelMd.copyWith(
                        color: tokens.textSecondary,
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
                            label: Text('Fit to image'),
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

          // Main List or Empty State
          Expanded(
            child: _imagePaths.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: tokens.surfaceAlt,
                              shape: BoxShape.circle,
                              border: Border.all(color: tokens.hairline, width: 1),
                            ),
                            child: Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32,
                              color: tokens.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Add images to start',
                            style: DocViewTypography.headlineSm.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: tokens.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Select photos or scan paper documents to generate a PDF.',
                            textAlign: TextAlign.center,
                            style: DocViewTypography.bodySm.copyWith(
                              color: tokens.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: DocPrimaryButton(
                                  label: 'Choose photos',
                                  icon: const Icon(Icons.photo_library_outlined, size: 18, color: Colors.white),
                                  onPressed: _addMoreImages,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DocSecondaryButton(
                                  label: 'Scan paper',
                                  icon: Icon(Icons.document_scanner_outlined, size: 18, color: tokens.textPrimary),
                                  onPressed: () async {
                                    final messenger = ScaffoldMessenger.of(context);
                                    try {
                                      final scans = await CunningDocumentScanner.getPictures();
                                      if (!mounted) return;
                                      if (scans != null && scans.isNotEmpty) {
                                        setState(() {
                                          _imagePaths.addAll(scans.take(maxImageCount));
                                          _updateSizes();
                                        });
                                      }
                                    } catch (e) {
                                      if (!mounted) return;
                                      messenger.showSnackBar(
                                        SnackBar(content: Text('Scanning failed: $e')),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 8),
                        sliver: SliverReorderableList(
                          itemCount: _imagePaths.length,
                          onReorderItem: _onReorderItem,
                          itemBuilder: (context, index) {
                            final path = _imagePaths[index];
                            final file = File(path);
                            final fileName = path.split(Platform.pathSeparator).last;
                            final sizeBytes = _fileSizes[path] ?? 0;
                            final sizeStr = FormatUtils.formatFileSize(sizeBytes);

                            return Container(
                              key: ValueKey('page_${path}_$index'),
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: tokens.surfaceAlt,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: tokens.hairline, width: 1),
                              ),
                              child: Row(
                                children: [
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Icon(
                                        AppIcons.dragHandle,
                                        color: tokens.textSecondary,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: 56,
                                          height: 56,
                                          child: Image.file(
                                            file,
                                            cacheWidth: 168,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              color: tokens.surface,
                                              child: Icon(Icons.broken_image_rounded, color: tokens.textSecondary),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (widget.isScannerSource)
                                        const Positioned.fill(
                                          child: _ScanCornerOverlay(),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: tokens.primaryBlue.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'Page ${index + 1}',
                                            style: DocViewTypography.captionXs.copyWith(
                                              color: tokens.primaryBlue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$fileName • $sizeStr',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: DocViewTypography.bodySm.copyWith(
                                            color: tokens.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DocIconButton(
                                    icon: AppIcons.close,
                                    tooltip: 'Remove image',
                                    size: 20,
                                    onPressed: _isCreating ? null : () => _removeImage(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: DashedAddCard(
                            key: const Key('add_more_card'),
                            label: widget.isScannerSource ? 'Add more scans' : 'Add more images',
                            onTap: _addMoreImages,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          // Sticky Footer with real estimate and CTA
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.paddingOf(context).bottom + 12,
            ),
            decoration: BoxDecoration(
              color: tokens.surfaceAlt,
              border: Border(
                top: BorderSide(color: tokens.hairline, width: 1),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_imagePaths.length} ${_imagePaths.length == 1 ? 'image' : 'images'} · est. ~ ${FormatUtils.formatFileSize(_totalBytes)}',
                      style: DocViewTypography.bodySm.copyWith(
                        color: tokens.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: tokens.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: tokens.hairline, width: 1),
                      ),
                      child: Text(
                        _pageMode == PageMode.a4 ? 'A4' : 'Fit to image',
                        style: DocViewTypography.captionXs.copyWith(
                          color: tokens.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DocPrimaryButton(
                  label: 'Create PDF',
                  icon: const Icon(Icons.picture_as_pdf_rounded, size: 20, color: Colors.white),
                  onPressed: canCreate ? _createPdf : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Decorative corner brackets overlay giving scanned document previews a distinct viewfinder aesthetic.
class _ScanCornerOverlay extends StatelessWidget {
  const _ScanCornerOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _CornerBracketPainter(),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00BCD4)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const double len = 8.0;

    // Top-left
    canvas.drawLine(const Offset(2, 2), const Offset(2 + len, 2), paint);
    canvas.drawLine(const Offset(2, 2), const Offset(2, 2 + len), paint);

    // Top-right
    canvas.drawLine(Offset(size.width - 2, 2), Offset(size.width - 2 - len, 2), paint);
    canvas.drawLine(Offset(size.width - 2, 2), Offset(size.width - 2, 2 + len), paint);

    // Bottom-left
    canvas.drawLine(Offset(2, size.height - 2), Offset(2 + len, size.height - 2), paint);
    canvas.drawLine(Offset(2, size.height - 2), Offset(2, size.height - 2 - len), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width - 2, size.height - 2), Offset(size.width - 2 - len, size.height - 2), paint);
    canvas.drawLine(Offset(size.width - 2, size.height - 2), Offset(size.width - 2, size.height - 2 - len), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
