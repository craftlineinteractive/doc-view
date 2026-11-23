import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../data/models/placed_signature.dart';
import '../../../data/repositories/signature_repository.dart';
import '../../../data/services/pdf/pdf_annotation_service.dart';
import '../../providers/providers.dart';
import '../../../shared/widgets/reader/reader_bottom_row.dart';
import '../widgets/editor_session.dart';
import '../widgets/pdf_editor_shell.dart';
import '../widgets/tool_file_picker_screen.dart';
import '../widgets/tool_progress_dialog.dart';
import 'widgets/placed_signature_box.dart';
import 'widgets/signatures_sheet.dart';

/// Full-featured PDF Document Signing Screen allowing users to place hand-drawn signatures
/// and date stamps onto PDF pages, drag, resize, undo/redo, and save atomically.
class SignScreen extends ConsumerStatefulWidget {
  const SignScreen({
    this.initialFilePath,
    super.key,
  });

  final String? initialFilePath;

  @override
  ConsumerState<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends ConsumerState<SignScreen> {
  String? _filePath;
  PdfDocumentInfo? _documentInfo;
  bool _isLoadingInfo = true;
  String? _loadError;

  EditorSession<List<PlacedSignature>> _session =
      const EditorSession<List<PlacedSignature>>(current: []);
  List<PlacedSignature> get _signatures => _session.current;

  String? _selectedSignatureId;
  int _currentPageIndex = 0;

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
      title: context.l10n.toolSign,
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

      setState(() {
        _documentInfo = info;
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

  void _recordSnapshot(List<PlacedSignature> newSignatures) {
    setState(() {
      _session = _session.push(List.unmodifiable(newSignatures));
    });
  }

  void _undo() {
    if (!_session.canUndo) return;
    setState(() {
      _session = _session.undo();
      _selectedSignatureId = null;
    });
  }

  void _redo() {
    if (!_session.canRedo) return;
    setState(() {
      _session = _session.redo();
      _selectedSignatureId = null;
    });
  }

  Future<void> _openSignaturesSheet() async {
    if (_signatures.length >= PlacedSignature.maxSignaturesPerDocument) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.signMaxPlacedReached)),
      );
      return;
    }

    final repo = ref.read(signatureRepositoryProvider);
    final chosen = await SignaturesSheet.show(context, repository: repo);
    if (chosen != null && mounted) {
      _placeSignature(chosen);
    }
  }

  void _placeSignature(SavedSignature saved) {
    if (_signatures.length >= PlacedSignature.maxSignaturesPerDocument) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.signMaxPlacedReached)),
      );
      return;
    }

    final pageSize = _getPageSize(_currentPageIndex);
    final sigWidth = (180.0).clamp(60.0, pageSize.width * 0.9);
    final sigHeight = (sigWidth / saved.aspectRatio).clamp(20.0, pageSize.height * 0.8);
    final left = ((pageSize.width - sigWidth) / 2).clamp(20.0, double.infinity);
    final top = ((pageSize.height - sigHeight) / 2).clamp(20.0, double.infinity);

    final placed = PlacedSignature(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      pageIndex: _currentPageIndex,
      bounds: Rect.fromLTWH(left, top, sigWidth, sigHeight),
      signatureId: saved.id,
      normalizedStrokes: saved.strokes,
      colorValue: saved.colorValue,
      strokeWidth: 2.0,
      timestampMs: DateTime.now().millisecondsSinceEpoch,
    );

    _selectedSignatureId = placed.id;
    _recordSnapshot([..._signatures, placed]);
  }

  Future<void> _confirmClearAll() async {
    if (_signatures.isEmpty) return;

    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signConfirmClearAllTitle),
        content: Text(l10n.signConfirmClearAllBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.annotateDiscardDialogActionKeep),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.signToolbarClearAll),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _selectedSignatureId = null;
      _recordSnapshot(const []);
    }
  }

  Size _getPageSize(int pageIndex) {
    if (_documentInfo != null &&
        pageIndex >= 0 &&
        pageIndex < _documentInfo!.pageSizes.length) {
      return _documentInfo!.pageSizes[pageIndex];
    }
    return const Size(612, 792); // Standard US Letter default
  }

  Future<void> _showSaveOptions() async {
    if (_signatures.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.signNoSignaturesToSave)),
      );
      return;
    }

    final isSigned = _documentInfo?.hasDigitalSignature ?? false;
    final choice = await PdfEditorShell.showSaveOptionsSheet(
      context,
      isSigned: isSigned,
    );

    if (choice != null && mounted) {
      await _executeSave(replaceOriginal: choice == 'replace');
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
        final unique = await ref.read(pdfOutputServiceProvider).uniqueFile('${baseName}_signed');
        targetOutputPath = unique.path;
      }

      final savedFile = await ref.read(pdfAnnotationServiceProvider).saveAnnotations(
        sourcePath: sourcePath,
        outputPath: targetOutputPath,
        signatures: _signatures,
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
            content: Text(context.l10n.signSaveSuccess),
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

    return PdfEditorShell(
      filePath: _filePath ?? '',
      isDirty: _session.canUndo,
      canUndo: _session.canUndo,
      canRedo: _session.canRedo,
      canSave: _signatures.isNotEmpty,
      onUndo: _undo,
      onRedo: _redo,
      onSave: _showSaveOptions,
      documentInfo: _documentInfo,
      changesCount: _signatures.length,
      onBack: () => context.pop(),
      bottomBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ReaderBottomRow(
            items: [
              ReaderBottomRowItem(
                key: const Key('sign_action_sign'),
                icon: Icons.draw_outlined,
                label: l10n.signToolbarSign,
                isSelected: false,
                onTap: _openSignaturesSheet,
                tooltip: l10n.signToolbarSign,
              ),
              ReaderBottomRowItem(
                key: const Key('sign_action_clear_all'),
                icon: Icons.clear_all_outlined,
                label: l10n.signToolbarClearAll,
                isSelected: false,
                onTap: _confirmClearAll,
                tooltip: l10n.signToolbarClearAll,
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

    return PdfViewer.file(
      _filePath!,
      params: PdfViewerParams(
        onViewerReady: (document, controller) {
          // ready
        },
        pageOverlaysBuilder: (context, pageRect, page) {
          final pageIdx = page.pageNumber - 1;
          final pageSignatures = _signatures.where((s) => s.pageIndex == pageIdx).toList();
          final pageSize = Size(page.width, page.height);

          return [
            for (final sig in pageSignatures)
              PlacedSignatureBox(
                key: Key('placed_sig_box_${sig.id}'),
                signature: sig,
                isSelected: sig.id == _selectedSignatureId,
                pageSize: pageSize,
                onTap: () {
                  setState(() {
                    _selectedSignatureId = sig.id;
                    _currentPageIndex = pageIdx;
                  });
                },
                onMoved: (newRect) {
                  final updated = _signatures.map((s) {
                    if (s.id == sig.id) return s.copyWith(bounds: newRect);
                    return s;
                  }).toList();
                  _recordSnapshot(updated);
                },
                onResized: (newRect) {
                  final updated = _signatures.map((s) {
                    if (s.id == sig.id) return s.copyWith(bounds: newRect);
                    return s;
                  }).toList();
                  _recordSnapshot(updated);
                },
                onDeleted: () {
                  setState(() {
                    _selectedSignatureId = null;
                  });
                  final updated = _signatures.where((s) => s.id != sig.id).toList();
                  _recordSnapshot(updated);
                },
                onApplied: () {
                  setState(() {
                    _selectedSignatureId = null;
                  });
                },
              ),
          ];
        },
      ),
    );
  }
}
