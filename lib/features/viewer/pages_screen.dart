import 'dart:async';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../core/extensions/l10n_extension.dart';
import '../../core/router/premium_gate.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../core/utils/app_log.dart';
import '../../core/utils/file_ingest_helper.dart';
import '../../data/models/doc_file.dart';
import '../../data/services/pdf/pdf_page_edit_service.dart';
import '../providers/providers.dart';

/// Screen allowing users to inspect, reorder, rotate, delete, insert,
/// and extract pages of a PDF document.
class PagesScreen extends ConsumerStatefulWidget {
  final DocFile file;
  final int initialPage;
  final List<PdfPageEditSpec>? initialPages;

  const PagesScreen({
    super.key,
    required this.file,
    this.initialPage = 1,
    this.initialPages,
  });

  @override
  ConsumerState<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends ConsumerState<PagesScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<PdfPageEditSpec> _pages = [];
  List<PdfPageEditSpec>? _undoSnapshot;
  final Set<int> _selectedIndices = {};
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;

  final _ThumbnailCache _thumbnailCache = _ThumbnailCache(maxItems: 60);
  final _RenderQueue _renderQueue = _RenderQueue();
  final Map<String, PdfDocument> _sourceDocs = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialPages != null) {
      _pages = List<PdfPageEditSpec>.from(widget.initialPages!);
      _isLoading = false;
    } else {
      _loadDocument();
    }
  }

  @override
  void dispose() {
    _thumbnailCache.dispose();
    for (final doc in _sourceDocs.values) {
      doc.dispose();
    }
    _sourceDocs.clear();
    super.dispose();
  }

  Future<void> _loadDocument() async {
    try {
      final safeFile = await FileIngestHelper.ingestToCache(widget.file.path, subDir: 'pages_inputs');
      final doc = await PdfDocument.openFile(safeFile.path);
      _sourceDocs[safeFile.path] = doc;
      if (!mounted) return;
      setState(() {
        _pages = List.generate(
          doc.pages.length,
          (i) => PdfPageEditSpec(
            sourcePath: safeFile.path,
            sourcePageIndex: i,
          ),
        );
        _isLoading = false;
      });
    } catch (e, st) {
      AppLog.e('Pages', 'load_document_failed', e, st);
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<PdfDocument> _getSourceDocument(String path) async {
    final existing = _sourceDocs[path];
    if (existing != null) return existing;
    final safeFile = await FileIngestHelper.ingestToCache(path, subDir: 'pages_inputs');
    final doc = await PdfDocument.openFile(safeFile.path);
    _sourceDocs[path] = doc;
    return doc;
  }

  void _saveUndoSnapshot() {
    _undoSnapshot = List<PdfPageEditSpec>.from(_pages);
  }

  void _handleUndo() {
    if (_undoSnapshot == null) return;
    setState(() {
      _pages = List<PdfPageEditSpec>.from(_undoSnapshot!);
      _undoSnapshot = null;
      _selectedIndices.clear();
      _hasUnsavedChanges = true;
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedIndices.length == _pages.length) {
        _selectedIndices.clear();
      } else {
        _selectedIndices.clear();
        for (var i = 0; i < _pages.length; i++) {
          _selectedIndices.add(i);
        }
      }
    });
  }

  bool get _isReadOnly => PremiumGate.isLocked(ref, PremiumFeature.managePages);

  Future<void> _handleReorder(int oldIndex, int newIndex) async {
    if (_isReadOnly) return;
    if (oldIndex == newIndex ||
        oldIndex < 0 ||
        oldIndex >= _pages.length ||
        newIndex < 0 ||
        newIndex >= _pages.length) {
      return;
    }
    setState(() {
      _saveUndoSnapshot();
      final item = _pages.removeAt(oldIndex);
      _pages.insert(newIndex, item);
      _selectedIndices.clear();
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _handleRotate() async {
    if (_isReadOnly) return;
    if (_selectedIndices.isEmpty) return;
    if (!mounted) return;
    setState(() {
      _saveUndoSnapshot();
      for (final idx in _selectedIndices) {
        final current = _pages[idx];
        final nextRotation = (current.rotationDegrees + 90) % 360;
        _pages[idx] = current.copyWith(rotationDegrees: nextRotation);
      }
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _handleDelete() async {
    if (_isReadOnly) return;
    if (_selectedIndices.isEmpty) return;
    if (!mounted) return;
    if (_selectedIndices.length >= _pages.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.pagesDeleteAllBlocked),
          backgroundColor: DocViewColors.error,
        ),
      );
      return;
    }

    setState(() {
      _saveUndoSnapshot();
      _pages = [
        for (var i = 0; i < _pages.length; i++)
          if (!_selectedIndices.contains(i)) _pages[i],
      ];
      _selectedIndices.clear();
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _handleInsert() async {
    if (_isReadOnly) return;
    if (!mounted) return;
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final tokens = sheetContext.tokens;
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? DocViewColors.backgroundDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    sheetContext.l10n.pagesInsertSheetTitle,
                    style: DocViewTypography.headlineSm.copyWith(
                      color: tokens.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.file_open_outlined, color: tokens.primaryBlue),
                  title: Text(
                    sheetContext.l10n.pagesInsertPagesFromPdf,
                    style: DocViewTypography.bodyMd.copyWith(color: tokens.textPrimary),
                  ),
                  onTap: () => sheetContext.pop('pdf'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == 'pdf' && mounted) {
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (pickedFiles.isNotEmpty && pickedFiles.first.path != null && mounted) {
        final sourcePath = pickedFiles.first.path!;
        try {
          final count = await const PdfPageEditService().getPageCount(sourcePath);
          if (count > 0 && mounted) {
            setState(() {
              _saveUndoSnapshot();
              final newSpecs = List.generate(
                count,
                (i) => PdfPageEditSpec(
                  sourcePath: sourcePath,
                  sourcePageIndex: i,
                ),
              );
              _pages.addAll(newSpecs);
              _hasUnsavedChanges = true;
            });
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.pagesErrorUnreadable),
                backgroundColor: DocViewColors.error,
              ),
            );
          }
        }
      }
    }
  }

  String _baseFileName() {
    final name = widget.file.name;
    if (name.toLowerCase().endsWith('.pdf')) {
      return name.substring(0, name.length - 4);
    }
    return name;
  }

  Future<void> _handleExtract() async {
    if (_selectedIndices.isEmpty) return;
    if (_isReadOnly) return;
    if (!mounted) return;
    final selectedSpecs = _selectedIndices.map((i) => _pages[i]).toList();
    final defaultName = '${_baseFileName()}_extracted';

    final textController = TextEditingController(text: defaultName);
    final confirmedName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(dialogContext.l10n.pagesActionExtract),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: dialogContext.l10n.pagesSaveFileNameLabel,
              suffixText: '.pdf',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(dialogContext.l10n.actionCancel),
            ),
            FilledButton(
              onPressed: () => dialogContext.pop(textController.text.trim()),
              child: Text(dialogContext.l10n.pagesActionExtract),
            ),
          ],
        );
      },
    );

    if (confirmedName != null && confirmedName.isNotEmpty && mounted) {
      setState(() => _isSaving = true);
      try {
        final outputService = ref.read(pdfOutputServiceProvider);
        final outputFile = await outputService.uniqueFile(confirmedName);

        await const PdfPageEditService().extractPages(
          pages: selectedSpecs,
          outputPath: outputFile.path,
        );

        await outputService.registerOutput(outputFile);

        if (mounted) {
          setState(() {
            _isSaving = false;
            _selectedIndices.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.pagesExtractSuccess(selectedSpecs.length)),
              backgroundColor: DocViewColors.success,
            ),
          );
        }
      } catch (e, st) {
        AppLog.e('Pages', 'extract_pages_failed', e, st);
        if (mounted) {
          setState(() => _isSaving = false);
          final err = '${context.l10n.pagesErrorUnreadable}\n${context.l10n.errorCodeLabel('PAGES_EXTRACT_FAILED')}';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err),
              backgroundColor: DocViewColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _showSaveDialog() async {
    final defaultName = '${_baseFileName()}_edited';
    var saveAsNew = true;
    final textController = TextEditingController(text: defaultName);

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final tokens = context.tokens;
            return AlertDialog(
              title: Text(dialogContext.l10n.pagesSaveDialogTitle),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: Icon(
                        saveAsNew
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: saveAsNew ? tokens.primaryBlue : tokens.textSecondary,
                      ),
                      title: Text(dialogContext.l10n.pagesSaveAsNew),
                      onTap: () => setDialogState(() => saveAsNew = true),
                    ),
                    if (saveAsNew)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            labelText: dialogContext.l10n.pagesSaveFileNameLabel,
                            suffixText: '.pdf',
                          ),
                        ),
                      ),
                    ListTile(
                      leading: Icon(
                        !saveAsNew
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: !saveAsNew ? tokens.primaryBlue : tokens.textSecondary,
                      ),
                      title: Text(dialogContext.l10n.pagesSaveReplace),
                      subtitle: Text(
                        dialogContext.l10n.pagesSaveReplaceWarning,
                        style: TextStyle(color: tokens.textSecondary, fontSize: 12),
                      ),
                      onTap: () => setDialogState(() => saveAsNew = false),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => dialogContext.pop(false),
                  child: Text(dialogContext.l10n.actionCancel),
                ),
                FilledButton(
                  onPressed: () => dialogContext.pop(true),
                  child: Text(dialogContext.l10n.pagesActionSave),
                ),
              ],
            );
          },
        );
      },
    );

    if (shouldSave == true && mounted) {
      setState(() => _isSaving = true);
      try {
        final outputService = ref.read(pdfOutputServiceProvider);
        String finalSavedPath;

        if (saveAsNew) {
          final chosenName = textController.text.trim().isEmpty
              ? defaultName
              : textController.text.trim();
          final outFile = await outputService.uniqueFile(chosenName);
          await const PdfPageEditService().saveDocument(
            pages: _pages,
            outputPath: outFile.path,
            replaceOriginal: false,
          );
          await outputService.registerOutput(outFile);
          finalSavedPath = outFile.path;
        } else {
          for (final doc in _sourceDocs.values) {
            doc.dispose();
          }
          _sourceDocs.clear();

          await const PdfPageEditService().saveDocument(
            pages: _pages,
            outputPath: widget.file.path,
            replaceOriginal: true,
            originalPath: widget.file.path,
          );
          outputService.actionsController.invalidateAll();
          finalSavedPath = widget.file.path;
        }

        if (mounted) {
          setState(() {
            _isSaving = false;
            _hasUnsavedChanges = false;
          });
          context.pop({'saved': true, 'path': finalSavedPath});
        }
      } catch (e, st) {
        AppLog.e('Pages', 'save_document_failed', e, st);
        if (mounted) {
          setState(() => _isSaving = false);
          final err = '${context.l10n.pagesErrorUnreadable}\n${context.l10n.errorCodeLabel('PAGES_SAVE_FAILED')}';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err),
              backgroundColor: DocViewColors.error,
            ),
          );
        }
      }
    }
  }

  Future<bool> _confirmDiscard() async {
    if (!_hasUnsavedChanges) return true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(dialogContext.l10n.pagesDiscardDialogTitle),
          content: Text(dialogContext.l10n.pagesDiscardDialogBody),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(false),
              child: Text(dialogContext.l10n.actionCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: DocViewColors.error),
              onPressed: () => dialogContext.pop(true),
              child: Text(dialogContext.l10n.pagesDiscardButton),
            ),
          ],
        );
      },
    );
    return discard == true;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _confirmDiscard();
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? DocViewColors.backgroundDark : DocViewColors.backgroundLight,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.3,
            child: AppBar(
              backgroundColor: isDark ? DocViewColors.surfaceDark : Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: context.l10n.tooltipBack,
                onPressed: () async {
                  final shouldPop = await _confirmDiscard();
                  if (shouldPop && context.mounted) {
                    context.pop();
                  }
                },
              ),
              title: Text(
                context.l10n.pagesScreenTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DocViewTypography.headlineSm.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                if (!_isReadOnly) ...[
                  // Undo button
                  IconButton(
                    key: const Key('pages_undo_button'),
                    icon: const Icon(Icons.undo_rounded),
                    tooltip: context.l10n.pagesActionUndo,
                    onPressed: _undoSnapshot != null ? _handleUndo : null,
                  ),

                  // Save button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: FilledButton.tonal(
                      key: const Key('pages_save_button'),
                      onPressed: _hasUnsavedChanges && !_isSaving ? _showSaveDialog : null,
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(context.l10n.pagesActionSave),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        body: _buildBody(context),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final tokens = context.tokens;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: DocViewColors.error),
              const SizedBox(height: 12),
              Text(
                context.l10n.pagesErrorUnreadable,
                style: DocViewTypography.titleMd.copyWith(color: tokens.textPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_pages.isEmpty) {
      return Center(
        child: Text(
          context.l10n.pagesDeleteAllBlocked,
          style: DocViewTypography.bodyMd.copyWith(color: tokens.textSecondary),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Sub-header bar: Page count on the left, Select all / Clear on the right
        MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? DocViewColors.surfaceDark : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: tokens.hairline,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.pagesScreenPageCount(_pages.length),
                    style: DocViewTypography.bodySm.copyWith(
                      color: tokens.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: TextButton(
                    onPressed: _pages.isEmpty ? null : _toggleSelectAll,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(
                      _pages.isNotEmpty && _selectedIndices.length == _pages.length
                          ? context.l10n.pagesActionClearSelection
                          : context.l10n.pagesActionSelectAll,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DocViewTypography.labelMd.copyWith(
                        color: tokens.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = constraints.maxWidth > constraints.maxHeight;
              final crossAxisCount = isLandscape ? 5 : 3;

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final spec = _pages[index];
                  final isSelected = _selectedIndices.contains(index);

                  if (_isReadOnly) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedIndices.remove(index);
                          } else {
                            _selectedIndices.add(index);
                          }
                        });
                      },
                      child: _buildTileContent(index, spec, isSelected),
                    );
                  }

                  return LongPressDraggable<int>(
                    data: index,
                    feedback: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: (constraints.maxWidth - 48) / crossAxisCount,
                        height: ((constraints.maxWidth - 48) / crossAxisCount) / 0.72,
                        child: _buildTileContent(index, spec, isSelected, isDragging: true),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: _buildTileContent(index, spec, isSelected),
                    ),
                    child: DragTarget<int>(
                      onWillAcceptWithDetails: (details) => details.data != index,
                      onAcceptWithDetails: (details) => _handleReorder(details.data, index),
                      builder: (context, candidateData, rejectedData) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedIndices.remove(index);
                              } else {
                                _selectedIndices.add(index);
                              }
                            });
                          },
                          child: _buildTileContent(index, spec, isSelected),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTileContent(
    int index,
    PdfPageEditSpec spec,
    bool isSelected, {
    bool isDragging = false,
  }) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? DocViewColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? tokens.primaryBlue : tokens.hairline,
          width: isSelected ? 2.5 : 1.0,
        ),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Centered Thumbnail with live visual rotation
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: RotatedBox(
                quarterTurns: (spec.rotationDegrees ~/ 90) % 4,
                child: _PageThumbnail(
                  spec: spec,
                  cache: _thumbnailCache,
                  queue: _renderQueue,
                  docProvider: _getSourceDocument,
                ),
              ),
            ),
          ),

          // Top-left: Page Number Badge
          Positioned(
            left: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${index + 1}',
                style: DocViewTypography.bodySm.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ),

          // Top-right: Selection Checkmark Badge
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? tokens.primaryBlue : Colors.black.withValues(alpha: 0.35),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildBottomBar(BuildContext context) {
    if (_isLoading || _errorMessage != null || _pages.isEmpty) {
      return null;
    }

    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isReadOnly) {
      return Container(
        decoration: BoxDecoration(
          color: isDark ? DocViewColors.surfaceDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: tokens.hairline,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SafeArea(
          top: false,
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.3,
            child: SizedBox(
              height: 56,
              child: Center(
                child: FilledButton.icon(
                  key: const Key('pages_edit_pages_button'),
                  onPressed: () => context.push('/premium'),
                  icon: const Icon(AppIcons.crown, color: Colors.white, size: 20),
                  label: Text(context.l10n.pagesEditPagesAction),
                  style: FilledButton.styleFrom(
                    backgroundColor: tokens.premiumGoldDark,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? DocViewColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: tokens.hairline,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        top: false,
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.3,
          child: SizedBox(
            height: 56,
            child: _selectedIndices.isEmpty
                ? Center(
                    child: OutlinedButton.icon(
                      onPressed: _handleInsert,
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      label: Text(context.l10n.pagesActionInsert),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: tokens.primaryBlue,
                        side: BorderSide(color: tokens.primaryBlue),
                        minimumSize: const Size(180, 48),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      // Rotate
                      Expanded(
                        child: _BottomBarAction(
                          icon: Icons.rotate_right_rounded,
                          label: context.l10n.pagesActionRotate,
                          onTap: _handleRotate,
                        ),
                      ),

                      // Extract
                      Expanded(
                        child: _BottomBarAction(
                          icon: Icons.file_download_outlined,
                          label: context.l10n.pagesActionExtract,
                          onTap: _handleExtract,
                        ),
                      ),

                      // Delete
                      Expanded(
                        child: _BottomBarAction(
                          icon: Icons.delete_outline_rounded,
                          label: context.l10n.pagesActionDelete,
                          color: DocViewColors.error,
                          onTap: _handleDelete,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _BottomBarAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _BottomBarAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final actionColor = color ?? tokens.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: actionColor, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: DocViewTypography.bodySm.copyWith(
                color: actionColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageThumbnail extends StatefulWidget {
  final PdfPageEditSpec spec;
  final _ThumbnailCache cache;
  final _RenderQueue queue;
  final Future<PdfDocument> Function(String path) docProvider;

  const _PageThumbnail({
    required this.spec,
    required this.cache,
    required this.queue,
    required this.docProvider,
  });

  @override
  State<_PageThumbnail> createState() => _PageThumbnailState();
}

class _PageThumbnailState extends State<_PageThumbnail> {
  ui.Image? _image;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(covariant _PageThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spec.sourcePath != widget.spec.sourcePath ||
        oldWidget.spec.sourcePageIndex != widget.spec.sourcePageIndex) {
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    final cacheKey = '${widget.spec.sourcePath}:${widget.spec.sourcePageIndex}';
    final cached = widget.cache.get(cacheKey);
    if (cached != null) {
      if (mounted) {
        setState(() {
          _image = cached;
          _isLoading = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      final img = await widget.queue.enqueue<ui.Image?>(() async {
        final doc = await widget.docProvider(widget.spec.sourcePath);
        if (widget.spec.sourcePageIndex < 0 ||
            widget.spec.sourcePageIndex >= doc.pages.length) {
          return null;
        }
        final page = doc.pages[widget.spec.sourcePageIndex];
        final pdfImage = await page.render(
          fullWidth: 160,
          fullHeight: 220,
        );
        if (pdfImage == null) return null;
        try {
          final flutterImg = await pdfImage.createImage();
          return flutterImg;
        } finally {
          pdfImage.dispose();
        }
      });

      if (img != null) {
        widget.cache.put(cacheKey, img);
      }

      if (mounted) {
        setState(() {
          _image = img;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = context.tokens;

    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: isDark ? DocViewColors.skeletonBaseDark : DocViewColors.skeletonBaseLight,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    if (_image != null) {
      return RawImage(
        image: _image,
        fit: BoxFit.contain,
      );
    }

    return Icon(
      Icons.description_outlined,
      size: 36,
      color: tokens.textSecondary,
    );
  }
}

class _ThumbnailCache {
  final Map<String, ui.Image> _cache = {};
  final List<String> _order = [];
  final int maxItems;

  _ThumbnailCache({this.maxItems = 60});

  ui.Image? get(String key) {
    final img = _cache[key];
    if (img != null) {
      _order.remove(key);
      _order.add(key);
    }
    return img;
  }

  void put(String key, ui.Image image) {
    if (_cache.containsKey(key)) {
      _order.remove(key);
    } else if (_order.length >= maxItems) {
      final oldest = _order.removeAt(0);
      final oldImg = _cache.remove(oldest);
      oldImg?.dispose();
    }
    _cache[key] = image;
    _order.add(key);
  }

  void dispose() {
    for (final img in _cache.values) {
      img.dispose();
    }
    _cache.clear();
    _order.clear();
  }
}

class _RenderQueue {
  int _activeJobs = 0;
  static const int _maxConcurrent = 2;
  final List<VoidCallback> _pending = [];

  Future<T> enqueue<T>(Future<T> Function() task) async {
    final completer = Completer<T>();
    void run() async {
      _activeJobs++;
      try {
        final result = await task();
        completer.complete(result);
      } catch (e, st) {
        completer.completeError(e, st);
      } finally {
        _activeJobs--;
        if (_pending.isNotEmpty && _activeJobs < _maxConcurrent) {
          final next = _pending.removeAt(0);
          next();
        }
      }
    }

    if (_activeJobs < _maxConcurrent) {
      run();
    } else {
      _pending.add(run);
    }
    return completer.future;
  }
}
