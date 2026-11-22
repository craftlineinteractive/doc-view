import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../data/models/pdf_markup.dart';
import '../../../data/services/pdf/pdf_annotation_service.dart';
import '../../providers/providers.dart';
import '../widgets/tool_file_picker_screen.dart';
import '../widgets/tool_progress_dialog.dart';
import 'annotate_session_notifier.dart';
import 'widgets/annotate_toolbar.dart';
import 'widgets/page_markup_overlay.dart';
import 'widgets/selection_menu.dart';

/// Full-featured PDF Annotation Screen supporting text markups (Highlight, Underline, Strikethrough)
/// and text copy, with undo/redo, ad-free layout, and atomic file saving.
class AnnotateScreen extends ConsumerStatefulWidget {
  const AnnotateScreen({
    this.initialFilePath,
    super.key,
  });

  final String? initialFilePath;

  @override
  ConsumerState<AnnotateScreen> createState() => _AnnotateScreenState();
}

class _AnnotateScreenState extends ConsumerState<AnnotateScreen> {
  String? _filePath;
  PdfViewerController? _viewerController;
  bool _isLoadingInfo = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _filePath = widget.initialFilePath;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_filePath == null) {
        _pickFile();
      } else {
        _loadDocumentInfo(_filePath!);
      }
    });
  }

  Future<void> _pickFile() async {
    final picked = await ToolFilePickerScreen.pickSingle(
      context,
      title: context.l10n.toolAnnotate,
    );
    if (!mounted) return;

    if (picked != null) {
      setState(() {
        _filePath = picked.path;
      });
      await _loadDocumentInfo(picked.path);
    } else {
      if (context.canPop()) {
        context.pop();
      }
    }
  }

  Future<void> _loadDocumentInfo(String path) async {
    setState(() {
      _isLoadingInfo = true;
      _loadError = null;
    });

    try {
      final service = ref.read(pdfAnnotationServiceProvider);
      final info = await service.getDocumentInfo(path);
      if (!mounted) return;

      ref.read(annotateSessionProvider.notifier).setDocumentInfo(info);
      setState(() {
        _isLoadingInfo = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingInfo = false;
        _loadError = e.toString();
      });
    }
  }

  Future<bool> _onWillPop() async {
    final session = ref.read(annotateSessionProvider);
    if (!session.isDirty) {
      return true;
    }

    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.annotateDiscardDialogTitle),
        content: Text(context.l10n.annotateDiscardDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(context.l10n.annotateDiscardDialogActionKeep),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(context.l10n.annotateDiscardDialogActionDiscard),
          ),
        ],
      ),
    );

    return discard ?? false;
  }

  List<Rect> _extractVisualLineRects({
    required PdfPageText pageText,
    required int startIndex,
    required int endIndex,
    required PdfPage page,
  }) {
    if (startIndex > endIndex || pageText.charRects.isEmpty) return const [];
    final clampedStart = math.max(0, startIndex);
    final clampedEnd = math.min(pageText.charRects.length - 1, endIndex);

    final lineRects = <Rect>[];
    Rect? currentLine;

    for (var i = clampedStart; i <= clampedEnd; i++) {
      final pdfRect = pageText.charRects[i];
      if (pdfRect.isEmpty) continue;
      final r = pdfRect.toRect(page: page);

      if (currentLine == null) {
        currentLine = r;
      } else {
        final sameLine = (r.top - currentLine.top).abs() < (currentLine.height * 0.5) &&
            (r.bottom - currentLine.bottom).abs() < (currentLine.height * 0.5);
        if (sameLine) {
          currentLine = currentLine.expandToInclude(r);
        } else {
          lineRects.add(currentLine);
          currentLine = r;
        }
      }
    }

    if (currentLine != null) {
      lineRects.add(currentLine);
    }

    return lineRects;
  }

  Future<void> _applyMarkupFromSelection({
    required PdfViewerContextMenuBuilderParams params,
    required TextMarkupType type,
  }) async {
    final range = params.textSelectionDelegate.textSelectionPointRange;
    if (range == null) return;

    final selectedText = await params.textSelectionDelegate.getSelectedText();
    final startPoint = range.start;
    final endPoint = range.end;
    final pageNumber = startPoint.text.pageNumber;
    final pageIndex = pageNumber - 1;

    // Get current pdfrx page
    final doc = _viewerController?.document;
    if (doc == null || pageIndex < 0 || pageIndex >= doc.pages.length) return;
    final page = doc.pages[pageIndex];

    final lineRects = _extractVisualLineRects(
      pageText: startPoint.text,
      startIndex: startPoint.index,
      endIndex: endPoint.index,
      page: page,
    );

    if (lineRects.isEmpty) return;

    final session = ref.read(annotateSessionProvider);
    final markup = TextMarkup(
      id: '${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(9999)}',
      pageIndex: pageIndex,
      type: type,
      colorValue: session.selectedColor.toARGB32(),
      lineRects: lineRects,
      text: selectedText,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
    );

    ref.read(annotateSessionProvider.notifier).addMarkup(markup);
    await params.textSelectionDelegate.clearTextSelection();
  }

  Future<void> _copySelectedText(PdfViewerContextMenuBuilderParams params) async {
    final text = await params.textSelectionDelegate.getSelectedText();
    if (text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: text));
      await params.textSelectionDelegate.clearTextSelection();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.annotateCopiedToClipboard),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _showSaveOptions() async {
    final session = ref.read(annotateSessionProvider);
    if (!session.isDirty || session.markups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.annotateNoChanges)),
      );
      return;
    }

    final isSigned = session.documentInfo?.hasDigitalSignature ?? false;

    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.tokens.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.annotateSaveTitle,
                style: DocViewTypography.headlineSm.copyWith(
                  color: context.tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: Text(context.l10n.annotateActionSaveNew),
                onTap: () => Navigator.of(ctx).pop('new'),
              ),
              ListTile(
                leading: const Icon(Icons.save_outlined),
                title: Text(context.l10n.annotateActionReplace),
                enabled: !isSigned,
                subtitle: isSigned
                    ? Text(
                        context.l10n.annotateSignedReplaceBlocked,
                        style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                      )
                    : null,
                onTap: isSigned ? null : () => Navigator.of(ctx).pop('replace'),
              ),
            ],
          ),
        ),
      ),
    );

    if (choice != null && mounted) {
      await _executeSave(replaceOriginal: choice == 'replace');
    }
  }

  Future<void> _executeSave({required bool replaceOriginal}) async {
    final session = ref.read(annotateSessionProvider);
    final sourcePath = _filePath!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ToolProgressDialog(
        title: context.l10n.annotateSaveTitle,
        message: context.l10n.annotateSaveProgress,
      ),
    );

    try {
      String targetOutputPath;

      if (replaceOriginal) {
        targetOutputPath = sourcePath;
      } else {
        final baseName = p.basenameWithoutExtension(sourcePath);
        final unique = await ref.read(pdfOutputServiceProvider).uniqueFile(baseName);
        targetOutputPath = unique.path;
      }

      final savedFile = await ref.read(pdfAnnotationServiceProvider).saveAnnotations(
        sourcePath: sourcePath,
        outputPath: targetOutputPath,
        markups: session.markups,
        replaceOriginal: replaceOriginal,
        originalPath: sourcePath,
      );

      if (!replaceOriginal) {
        await ref.read(pdfOutputServiceProvider).registerOutput(savedFile);
      } else {
        ref.read(fileActionsControllerProvider).invalidateAll();
      }

      ref.read(annotateSessionProvider.notifier).resetDirty();

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // dismiss progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.annotateSaveSuccess),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // dismiss progress
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.annotateErrorSaveFailed(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final session = ref.watch(annotateSessionProvider);
    final notifier = ref.read(annotateSessionProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: tokens.surface,
          elevation: 0,
          leading: IconButton(
            key: const Key('annotate_back_button'),
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                context.pop();
              }
            },
          ),
          title: Text(
            _filePath != null ? p.basename(_filePath!) : context.l10n.toolAnnotate,
            style: DocViewTypography.headlineSm.copyWith(
              color: tokens.textPrimary,
              fontSize: 18,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              key: const Key('annotate_action_undo'),
              icon: const Icon(Icons.undo),
              tooltip: context.l10n.annotateTooltipUndo,
              onPressed: session.canUndo ? () => notifier.undo() : null,
            ),
            IconButton(
              key: const Key('annotate_action_redo'),
              icon: const Icon(Icons.redo),
              tooltip: context.l10n.annotateTooltipRedo,
              onPressed: session.canRedo ? () => notifier.redo() : null,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton(
                key: const Key('annotate_action_save'),
                onPressed: (session.isDirty && session.markups.isNotEmpty)
                    ? _showSaveOptions
                    : null,
                child: Text(context.l10n.annotateTooltipSave),
              ),
            ),
          ],
        ),
        body: _buildBody(tokens, session, notifier),
      ),
    );
  }

  Widget _buildBody(
    DocViewTokens tokens,
    AnnotateSessionState session,
    AnnotateSessionNotifier notifier,
  ) {
    if (_filePath == null || _isLoadingInfo) {
      return Center(
        child: CircularProgressIndicator(color: tokens.primaryBlue),
      );
    }

    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _loadError!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final isSigned = session.documentInfo?.hasDigitalSignature ?? false;

    return Stack(
      children: [
        Column(
          children: [
            // Digitally signed notice banner
            if (isSigned)
              Container(
                key: const Key('annotate_signed_banner'),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.amber.shade100,
                child: Row(
                  children: [
                    Icon(Icons.verified_outlined, size: 20, color: Colors.amber.shade900),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.l10n.annotateSignedBanner,
                        style: TextStyle(
                          color: Colors.amber.shade900,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Ad-Free PDF Viewer
            Expanded(
              child: PdfViewer.file(
                _filePath!,
                params: PdfViewerParams(
                  onViewerReady: (document, controller) {
                    _viewerController = controller;
                  },
                  pageOverlaysBuilder: (context, pageRect, page) {
                    return [
                      Positioned.fill(
                        child: PageMarkupOverlay(
                          pageIndex: page.pageNumber - 1,
                          markups: session.markups,
                        ),
                      ),
                    ];
                  },
                  buildContextMenu: (context, params) {
                    return Center(
                      child: SelectionMenu(
                        onCopy: () => _copySelectedText(params),
                        onHighlight: () => _applyMarkupFromSelection(
                          params: params,
                          type: TextMarkupType.highlight,
                        ),
                        onUnderline: () => _applyMarkupFromSelection(
                          params: params,
                          type: TextMarkupType.underline,
                        ),
                        onStrikethrough: () => _applyMarkupFromSelection(
                          params: params,
                          type: TextMarkupType.strikethrough,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),

        // Floating bottom markup toolbar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnnotateToolbar(
            selectedTool: session.selectedTool,
            selectedColor: session.selectedColor,
            onToolSelected: notifier.selectTool,
            onColorSelected: notifier.selectColor,
          ),
        ),
      ],
    );
  }
}
