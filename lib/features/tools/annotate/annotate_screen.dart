import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../data/models/pdf_markup.dart';
import '../../../data/services/pdf/pdf_annotation_service.dart';
import '../../providers/providers.dart';
import '../widgets/pdf_editor_shell.dart';
import '../widgets/tool_file_picker_screen.dart';
import '../widgets/tool_progress_dialog.dart';
import 'annotate_session_notifier.dart';
import 'widgets/annotate_toolbar.dart';
import 'widgets/ink_overlay.dart';
import 'widgets/page_markup_overlay.dart';
import 'widgets/pen_sheet.dart';
import 'widgets/selection_menu.dart';

/// Full-featured PDF Annotation Screen supporting text markups (Highlight, Underline, Strikethrough),
/// freehand Pen drawing, and text copy, with undo/redo, ad-free layout, and atomic file saving.
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
  bool _penNoticeDismissed = false;

  @override
  void initState() {
    super.initState();
    _filePath = widget.initialFilePath;
    SharedPreferences.getInstance().then((prefs) {
      if (mounted) {
        setState(() {
          _penNoticeDismissed = prefs.getBool('annotate_pen_notice_dismissed') ?? false;
        });
      }
    });

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
    if (!session.isDirty || !session.hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.annotateNoChanges)),
      );
      return;
    }

    final isSigned = session.documentInfo?.hasDigitalSignature ?? false;
    final choice = await PdfEditorShell.showSaveOptionsSheet(
      context,
      isSigned: isSigned,
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
        strokes: session.strokes,
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
    final session = ref.watch(annotateSessionProvider);
    final notifier = ref.read(annotateSessionProvider.notifier);

    return PdfEditorShell(
      filePath: _filePath ?? '',
      isDirty: session.isDirty,
      canUndo: session.canUndo,
      canRedo: session.canRedo,
      canSave: session.isDirty && session.hasChanges,
      onUndo: () => notifier.undo(),
      onRedo: () => notifier.redo(),
      onSave: _showSaveOptions,
      documentInfo: session.documentInfo,
      changesCount: session.markups.length + session.strokes.length,
      onBack: () => context.pop(),
      bottomBar: AnnotateToolbar(
        activeTool: session.activeTool,
        selectedMarkupColor: session.selectedColor,
        penColor: session.penColor,
        onToolSelected: (tool) {
          if (tool is AnnotateActiveTool) {
            notifier.selectActiveTool(tool);
          }
        },
        onColorSelected: (color) {
          if (session.activeTool == AnnotateActiveTool.pen) {
            notifier.setPenColor(color);
          } else {
            notifier.selectColor(color);
          }
        },
        onPenSettingsTapped: () {
          PenSheet.show(
            context,
            selectedColor: session.penColor,
            strokeWidth: session.penStrokeWidth,
            isEraserMode: session.isEraserMode,
            onColorChanged: notifier.setPenColor,
            onStrokeWidthChanged: notifier.setPenStrokeWidth,
            onEraserModeChanged: notifier.setEraserMode,
          );
        },
        onCopyTapped: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.annotateToolbarCopy),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
      body: _buildBody(session, notifier),
    );
  }

  Widget _buildBody(
    AnnotateSessionState session,
    AnnotateSessionNotifier notifier,
  ) {
    final tokens = context.tokens;

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

    final isPenActive = session.activeTool == AnnotateActiveTool.pen;

    return Column(
      children: [
        // One-time first-use pen notice banner
        if (isPenActive && !_penNoticeDismissed)
          Container(
            key: const Key('annotate_pen_notice_banner'),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: tokens.surfaceAlt,
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: tokens.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.annotatePenNotice,
                    style: DocViewTypography.bodySm.copyWith(
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  key: const Key('annotate_pen_notice_got_it'),
                  onPressed: () {
                    setState(() {
                      _penNoticeDismissed = true;
                    });
                    SharedPreferences.getInstance().then((p) => p.setBool('annotate_pen_notice_dismissed', true));
                  },
                  child: Text(context.l10n.annotatePenNoticeDismiss),
                ),
              ],
            ),
          ),
        // Active hint banner
        if (isPenActive && _penNoticeDismissed)
          Container(
            key: const Key('annotate_pen_tip_banner'),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: tokens.surfaceAlt.withValues(alpha: 0.6),
            child: Row(
              children: [
                Icon(Icons.touch_app_outlined, size: 18, color: tokens.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.annotatePenTipBanner,
                    style: DocViewTypography.bodySm.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Ad-Free PDF Viewer with markups and ink overlays
        Expanded(
          child: PdfViewer.file(
            _filePath!,
            params: PdfViewerParams(
              onViewerReady: (document, controller) {
                _viewerController = controller;
              },
              pageOverlaysBuilder: (context, pageRect, page) {
                final pageIdx = page.pageNumber - 1;
                return [
                  Positioned.fill(
                    child: PageMarkupOverlay(
                      pageIndex: pageIdx,
                      markups: session.markups,
                    ),
                  ),
                  Positioned.fill(
                    child: InkOverlay(
                      pageIndex: pageIdx,
                      strokes: session.strokes,
                      isPenActive: isPenActive,
                      isEraserMode: session.isEraserMode,
                      penColor: session.penColor,
                      strokeWidth: session.penStrokeWidth,
                      onStrokeAdded: notifier.addStroke,
                      onStrokeErased: notifier.removeStroke,
                    ),
                  ),
                ];
              },
              buildContextMenu: isPenActive
                  ? null
                  : (context, params) {
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
    );
  }
}
