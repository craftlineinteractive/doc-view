import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../data/models/pdf_text_box.dart';
import '../../../data/services/pdf/pdf_annotation_service.dart';
import '../../../data/services/pdf/text_layout_engine.dart';
import '../../providers/providers.dart';
import '../../../shared/widgets/reader/reader_bottom_row.dart';
import '../widgets/editor_session.dart';
import '../widgets/pdf_editor_shell.dart';
import '../widgets/tool_file_picker_screen.dart';
import '../widgets/tool_progress_dialog.dart';
import 'widgets/text_box_overlay.dart';
import 'widgets/text_style_sheet.dart';

/// Full-featured PDF Add Text tool allowing users to insert, style, and position text on PDF pages.
class AddTextScreen extends ConsumerStatefulWidget {
  const AddTextScreen({
    this.initialFilePath,
    this.initialTextBoxes,
    this.viewerBuilder,
    super.key,
  });

  final String? initialFilePath;
  final List<PdfTextBox>? initialTextBoxes;
  final Widget Function(
    BuildContext context,
    List<Widget> Function(int pageIndex, Size pageSize) overlaysBuilder,
  )? viewerBuilder;

  @override
  ConsumerState<AddTextScreen> createState() => _AddTextScreenState();
}

class _AddTextScreenState extends ConsumerState<AddTextScreen> {
  String? _filePath;
  PdfDocumentInfo? _documentInfo;
  bool _isLoadingInfo = true;
  String? _loadError;

  EditorSession<List<PdfTextBox>> _session =
      const EditorSession<List<PdfTextBox>>(current: []);
  List<PdfTextBox> get _textBoxes => _session.current;

  String? _selectedBoxId;
  String? _editingBoxId;
  bool _isPlacementMode = false;

  // Session-remembered style settings
  double _sessionFontSize = PdfTextBox.defaultFontSize;
  Color _sessionColor = const Color(PdfTextBox.defaultColorValue);
  bool _sessionIsBold = false;
  bool _sessionIsItalic = false;
  TextAlign _sessionAlignment = TextAlign.start;

  // Banner persistence flags
  bool _permanentNoticeDismissed = false;
  bool _rasterNoticeDismissed = false;

  @override
  void initState() {
    super.initState();
    _filePath = widget.initialFilePath;
    if (widget.initialTextBoxes != null) {
      _session = EditorSession<List<PdfTextBox>>(current: widget.initialTextBoxes!);
    }

    SharedPreferences.getInstance().then((prefs) {
      if (mounted) {
        setState(() {
          _permanentNoticeDismissed =
              prefs.getBool('add_text_permanent_notice_dismissed') ?? false;
          _rasterNoticeDismissed =
              prefs.getBool('add_text_raster_notice_dismissed') ?? false;
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
      title: context.l10n.toolAddText,
    );
    if (!mounted) return;

    if (picked != null) {
      setState(() {
        _filePath = picked.path;
      });
      _loadDocumentInfo(picked.path);
    } else {
      context.pop();
    }
  }

  Future<void> _loadDocumentInfo(String path, {String? password}) async {
    setState(() {
      _isLoadingInfo = true;
      _loadError = null;
    });

    try {
      final info = await ref
          .read(pdfAnnotationServiceProvider)
          .getDocumentInfo(path, password: password);
      if (mounted) {
        setState(() {
          _documentInfo = info;
          _isLoadingInfo = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('password') || errStr.contains('encrypt')) {
        _showPasswordDialog(path);
      } else {
        setState(() {
          _loadError = context.l10n.annotateErrorCorrupt;
          _isLoadingInfo = false;
        });
      }
    }
  }

  Future<void> _showPasswordDialog(String path) async {
    final controller = TextEditingController();
    final password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.pdfPasswordTitle),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: context.l10n.pdfPasswordHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: Text(context.l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: Text(context.l10n.pdfPasswordActionUnlock),
          ),
        ],
      ),
    );

    if (password != null && mounted) {
      _loadDocumentInfo(path, password: password);
    } else if (mounted) {
      context.pop();
    }
  }

  void _undo() {
    setState(() {
      _session = _session.undo();
      _selectedBoxId = null;
      _editingBoxId = null;
    });
  }

  void _redo() {
    setState(() {
      _session = _session.redo();
      _selectedBoxId = null;
      _editingBoxId = null;
    });
  }

  void _togglePlacementMode() {
    setState(() {
      _isPlacementMode = !_isPlacementMode;
      if (_isPlacementMode) {
        _selectedBoxId = null;
        _editingBoxId = null;
      }
    });
  }

  void _handlePageTap(Offset tapPoint, int pageIndex, Size pageSize) {
    if (!_isPlacementMode) {
      if (_editingBoxId != null) {
        final editingBox = _textBoxes.where((b) => b.id == _editingBoxId).firstOrNull;
        if (editingBox != null) {
          _commitBoxEdit(editingBox);
          return;
        }
      }
      setState(() {
        _selectedBoxId = null;
        _editingBoxId = null;
      });
      return;
    }

    if (_textBoxes.length >= PdfTextBox.maxBoxesPerDocument) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.addTextErrorTooManyBoxes),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      setState(() {
        _isPlacementMode = false;
      });
      return;
    }

    final boxWidth = pageSize.width * 0.6;
    final boxHeight = _sessionFontSize * 2.0;
    final clampedLeft = tapPoint.dx.clamp(0.0, pageSize.width - boxWidth);
    final clampedTop = tapPoint.dy.clamp(0.0, pageSize.height - boxHeight);

    final newBox = PdfTextBox(
      id: 'box_${DateTime.now().microsecondsSinceEpoch}',
      pageIndex: pageIndex,
      bounds: Rect.fromLTWH(clampedLeft, clampedTop, boxWidth, boxHeight),
      text: '',
      fontSize: _sessionFontSize,
      colorValue: _sessionColor.toARGB32(),
      isBold: _sessionIsBold,
      isItalic: _sessionIsItalic,
      alignment: _sessionAlignment,
    );

    setState(() {
      _session = _session.push([..._textBoxes, newBox]);
      _selectedBoxId = newBox.id;
      _editingBoxId = newBox.id;
      _isPlacementMode = false;
    });
  }

  Future<void> _commitBoxEdit(PdfTextBox box) async {
    final currentBox = _textBoxes.where((b) => b.id == box.id).firstOrNull ?? box;
    if (currentBox.text.trim().isEmpty) {
      // Empty box discarded
      setState(() {
        _session = _session.undo();
        _selectedBoxId = null;
        _editingBoxId = null;
      });
      return;
    }

    // Check language / WinAnsi coverage
    final isSafe = TextLayoutEngine.isWinAnsiSafe(currentBox.text);

    // Compute Latin lines if safe
    final layout = TextLayoutEngine.layoutText(
      text: currentBox.text,
      fontSize: currentBox.fontSize,
      isBold: currentBox.isBold,
      isItalic: currentBox.isItalic,
      maxWidth: currentBox.bounds.width,
      alignment: currentBox.alignment,
    );

    final updatedBox = currentBox.copyWith(
      lines: layout.lines,
      isRaster: !isSafe,
      bounds: Rect.fromLTWH(
        currentBox.bounds.left,
        currentBox.bounds.top,
        currentBox.bounds.width,
        layout.totalHeight.clamp(currentBox.fontSize * 1.5, double.infinity),
      ),
    );

    setState(() {
      _session = _session.updateCurrent(
        _textBoxes.map((b) => b.id == currentBox.id ? updatedBox : b).toList(),
      );
      _editingBoxId = null;
      _selectedBoxId = updatedBox.id;
    });

    if (!isSafe) {
      TextLayoutEngine.renderTextToPng(
        text: currentBox.text,
        fontSize: currentBox.fontSize,
        color: Color(currentBox.colorValue),
        isBold: currentBox.isBold,
        isItalic: currentBox.isItalic,
        alignment: currentBox.alignment,
        width: currentBox.bounds.width,
        height: currentBox.bounds.height,
      ).then((png) {
        if (mounted) {
          setState(() {
            final boxWithPng = updatedBox.copyWith(pngBytes: png);
            _session = _session.updateCurrent(
              _textBoxes.map((b) => b.id == currentBox.id ? boxWithPng : b).toList(),
            );
          });
        }
      });
    }
  }

  void _updateBoxBounds(PdfTextBox box, Rect newBounds) {
    final updated = box.copyWith(bounds: newBounds);
    setState(() {
      _session = _session.push(
        _textBoxes.map((b) => b.id == box.id ? updated : b).toList(),
      );
      _selectedBoxId = updated.id;
    });
  }

  void _deleteSelectedBox() {
    if (_selectedBoxId == null) return;
    setState(() {
      _session = _session.push(
        _textBoxes.where((b) => b.id != _selectedBoxId).toList(),
      );
      _selectedBoxId = null;
      _editingBoxId = null;
    });
  }

  void _openStyleSheet() {
    if (_selectedBoxId == null) return;
    final box = _textBoxes.firstWhere((b) => b.id == _selectedBoxId);

    TextStyleSheet.show(
      context,
      initialFontSize: box.fontSize,
      initialColor: Color(box.colorValue),
      initialIsBold: box.isBold,
      initialIsItalic: box.isItalic,
      initialAlignment: box.alignment,
      onChanged: ({
        required double fontSize,
        required Color color,
        required bool isBold,
        required bool isItalic,
        required TextAlign alignment,
      }) {
        setState(() {
          _sessionFontSize = fontSize;
          _sessionColor = color;
          _sessionIsBold = isBold;
          _sessionIsItalic = isItalic;
          _sessionAlignment = alignment;

          final layout = TextLayoutEngine.layoutText(
            text: box.text.isEmpty ? ' ' : box.text,
            fontSize: fontSize,
            isBold: isBold,
            isItalic: isItalic,
            maxWidth: box.bounds.width,
            alignment: alignment,
          );

          final updated = box.copyWith(
            fontSize: fontSize,
            colorValue: color.toARGB32(),
            isBold: isBold,
            isItalic: isItalic,
            alignment: alignment,
            lines: layout.lines,
            bounds: Rect.fromLTWH(
              box.bounds.left,
              box.bounds.top,
              box.bounds.width,
              layout.totalHeight.clamp(fontSize * 1.5, double.infinity),
            ),
          );

          _session = _session.push(
            _textBoxes.map((b) => b.id == box.id ? updated : b).toList(),
          );
          _selectedBoxId = updated.id;
        });
      },
    );
  }

  Future<void> _showSaveOptions() async {
    final isSigned = _documentInfo?.hasDigitalSignature ?? false;
    final action = await PdfEditorShell.showSaveOptionsSheet(
      context,
      isSigned: isSigned,
    );

    if (action == null || !mounted) return;

    if (action == 'replace') {
      await _executeSave(replaceOriginal: true);
    } else if (action == 'new') {
      await _executeSave(replaceOriginal: false);
    }
  }

  Future<void> _executeSave({required bool replaceOriginal}) async {
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
        final unique = await ref
            .read(pdfOutputServiceProvider)
            .uniqueFile('${baseName}_edited');
        targetOutputPath = unique.path;
      }

      final savedFile = await ref
          .read(pdfAnnotationServiceProvider)
          .saveAnnotations(
            sourcePath: sourcePath,
            outputPath: targetOutputPath,
            textBoxes: _textBoxes,
            replaceOriginal: replaceOriginal,
            originalPath: sourcePath,
          );

      if (!replaceOriginal) {
        await ref.read(pdfOutputServiceProvider).registerOutput(savedFile);
      } else {
        ref.read(fileActionsControllerProvider).invalidateAll();
      }

      setState(() {
        _session = _session.markClean();
      });

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
        Navigator.of(context, rootNavigator: true).pop(); // dismiss progress dialog
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
    final l10n = context.l10n;
    final selectedBox = _selectedBoxId != null
        ? _textBoxes.where((b) => b.id == _selectedBoxId).firstOrNull
        : null;

    return PdfEditorShell(
      filePath: _filePath ?? '',
      isDirty: _session.canUndo,
      canUndo: _session.canUndo,
      canRedo: _session.canRedo,
      canSave: _textBoxes.isNotEmpty,
      onUndo: _undo,
      onRedo: _redo,
      onSave: _showSaveOptions,
      documentInfo: _documentInfo,
      changesCount: _textBoxes.length,
      onBack: () => context.pop(),
      bottomBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ReaderBottomRow(
            items: [
              ReaderBottomRowItem(
                key: const Key('add_text_action_add'),
                icon: Icons.text_fields_outlined,
                label: l10n.addTextActionAdd,
                isSelected: _isPlacementMode,
                onTap: _togglePlacementMode,
                tooltip: l10n.addTextActionAdd,
              ),
              ReaderBottomRowItem(
                key: const Key('add_text_action_style'),
                icon: Icons.tune_outlined,
                label: l10n.addTextActionStyle,
                isEnabled: selectedBox != null,
                onTap: selectedBox != null ? _openStyleSheet : null,
                tooltip: l10n.addTextActionStyle,
              ),
              ReaderBottomRowItem(
                key: const Key('add_text_action_delete'),
                icon: Icons.delete_outline,
                label: l10n.addTextActionDelete,
                isEnabled: selectedBox != null,
                onTap: selectedBox != null ? _deleteSelectedBox : null,
                tooltip: l10n.addTextActionDelete,
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final tokens = context.tokens;
    final l10n = context.l10n;

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

    return Column(
      children: [
        // One-time first box notice banner
        if (!_permanentNoticeDismissed && _textBoxes.isNotEmpty)
          Container(
            key: const Key('add_text_notice_permanent_banner'),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: tokens.surfaceAlt,
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: tokens.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.addTextNoticePermanent,
                    style: DocViewTypography.bodySm.copyWith(
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  key: const Key('add_text_notice_permanent_got_it'),
                  onPressed: () {
                    setState(() {
                      _permanentNoticeDismissed = true;
                    });
                    SharedPreferences.getInstance().then(
                      (p) => p.setBool(
                        'add_text_permanent_notice_dismissed',
                        true,
                      ),
                    );
                  },
                  child: Text(l10n.addTextNoticeGotIt),
                ),
              ],
            ),
          ),

        // One-time non-Latin raster notice banner
        if (!_rasterNoticeDismissed && _textBoxes.any((b) => b.isRaster))
          Container(
            key: const Key('add_text_notice_raster_banner'),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: tokens.surfaceAlt,
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: tokens.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.addTextNoticeRaster,
                    style: DocViewTypography.bodySm.copyWith(
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  key: const Key('add_text_notice_raster_got_it'),
                  onPressed: () {
                    setState(() {
                      _rasterNoticeDismissed = true;
                    });
                    SharedPreferences.getInstance().then(
                      (p) => p.setBool(
                        'add_text_raster_notice_dismissed',
                        true,
                      ),
                    );
                  },
                  child: Text(l10n.addTextNoticeGotIt),
                ),
              ],
            ),
          ),

        Expanded(
          child: widget.viewerBuilder != null
              ? widget.viewerBuilder!(context, _buildPageOverlays)
              : PdfViewer.file(
                  _filePath!,
                  params: PdfViewerParams(
                    pageOverlaysBuilder: (context, pageRect, page) {
                      return _buildPageOverlays(
                        page.pageNumber - 1,
                        Size(page.width, page.height),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  List<Widget> _buildPageOverlays(int pageIdx, Size pageSize) {
    final pageBoxes = _textBoxes.where((b) => b.pageIndex == pageIdx).toList();

    return [
      // Full-page tap detector for placement mode and tapping outside
      Positioned.fill(
        child: GestureDetector(
          key: _isPlacementMode
              ? Key('add_text_page_tap_$pageIdx')
              : Key('add_text_page_dismiss_tap_$pageIdx'),
          behavior: HitTestBehavior.opaque,
          onTapUp: (details) {
            _handlePageTap(
              details.localPosition,
              pageIdx,
              pageSize,
            );
          },
        ),
      ),

      // Placed text box overlays
      for (final box in pageBoxes)
        TextBoxOverlay(
          key: Key('text_box_overlay_${box.id}'),
          box: box,
          isSelected: box.id == _selectedBoxId,
          isEditing: box.id == _editingBoxId,
          pageSize: pageSize,
          onTap: () {
            setState(() {
              _selectedBoxId = box.id;
              _editingBoxId = box.id;
            });
          },
          onMoved: (newBounds) => _updateBoxBounds(box, newBounds),
          onResized: (newBounds) => _updateBoxBounds(box, newBounds),
          onTextChanged: (newText) {
            final updated = box.copyWith(text: newText);
            setState(() {
              _session = _session.updateCurrent(
                _textBoxes
                    .map((b) => b.id == box.id ? updated : b)
                    .toList(),
              );
              _selectedBoxId = updated.id;
            });
          },
          onEditingComplete: () => _commitBoxEdit(box),
          onDeleted: () {
            setState(() {
              _selectedBoxId = box.id;
            });
            _deleteSelectedBox();
          },
        ),
    ];
  }
}
