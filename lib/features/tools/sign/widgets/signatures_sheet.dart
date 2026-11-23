import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../core/theme/doc_view_typography.dart';
import '../../../../data/repositories/signature_repository.dart';
import 'signature_pad.dart';

/// Bottom sheet allowing users to select an existing saved signature,
/// delete unneeded ones, or draw a new signature up to the 5 saved signatures limit.
class SignaturesSheet extends StatefulWidget {
  const SignaturesSheet({
    required this.repository,
    required this.onSignatureSelected,
    this.initialSignatures,
    super.key,
  });

  final SignatureRepository repository;
  final ValueChanged<SavedSignature> onSignatureSelected;
  final List<SavedSignature>? initialSignatures;

  /// Convenience helper to display [SignaturesSheet] as a modal bottom sheet.
  static Future<SavedSignature?> show(
    BuildContext context, {
    required SignatureRepository repository,
  }) {
    final tokens = context.tokens;
    return showModalBottomSheet<SavedSignature>(
      context: context,
      backgroundColor: tokens.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SignaturesSheet(
        repository: repository,
        onSignatureSelected: (sig) => Navigator.of(ctx).pop(sig),
      ),
    );
  }

  @override
  State<SignaturesSheet> createState() => _SignaturesSheetState();
}

class _SignaturesSheetState extends State<SignaturesSheet> {
  List<SavedSignature> _signatures = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialSignatures != null) {
      _signatures = widget.initialSignatures!;
      _isLoading = false;
    } else {
      _loadSignatures();
    }
  }

  Future<void> _loadSignatures() async {
    final list = await widget.repository.getSignatures();
    if (mounted) {
      setState(() {
        _signatures = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _createNew() async {
    final result = await SignaturePad.show(context);
    if (result != null && mounted) {
      if (result.saveForFutureUse) {
        if (_signatures.length >= SignatureRepository.maxSavedSignatures) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.signMaxSignaturesReached)),
          );
          return;
        }
        final saved = await widget.repository.saveSignature(
          strokes: result.normalizedStrokes,
          aspectRatio: result.aspectRatio,
        );
        widget.onSignatureSelected(saved);
      } else {
        final temp = SavedSignature(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Temporary',
          strokes: result.normalizedStrokes,
          aspectRatio: result.aspectRatio,
          createdAtMs: DateTime.now().millisecondsSinceEpoch,
        );
        widget.onSignatureSelected(temp);
      }
    }
  }

  Future<void> _confirmDelete(SavedSignature sig) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key('sign_delete_dialog'),
        title: Text(l10n.signDeleteSignatureTitle),
        content: Text(l10n.signDeleteSignatureBody),
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
            child: Text(l10n.signPlacedSignatureDelete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.repository.deleteSignature(sig.id);
      await _loadSignatures();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final isMaxReached = _signatures.length >= SignatureRepository.maxSavedSignatures;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.signSheetTitle,
                    style: DocViewTypography.headlineSm.copyWith(
                      color: tokens.textPrimary,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_signatures.length}/${SignatureRepository.maxSavedSignatures}',
                  style: DocViewTypography.bodySm.copyWith(
                    color: tokens.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Signatures List
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_signatures.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    l10n.signPadTitle,
                    style: DocViewTypography.bodyMd.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _signatures.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final sig = _signatures[index];
                    return InkWell(
                      key: Key('saved_sig_${sig.id}'),
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => widget.onSignatureSelected(sig),
                      child: Container(
                        height: 72,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: tokens.surfaceAlt,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: tokens.hairline, width: 0.75),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomPaint(
                                painter: _VectorThumbPainter(
                                  strokes: sig.strokes,
                                  color: Color(sig.colorValue),
                                ),
                              ),
                            ),
                            IconButton(
                              key: Key('sign_delete_${sig.id}'),
                              icon: const Icon(Icons.delete_outline, size: 20),
                              color: tokens.error,
                              onPressed: () => _confirmDelete(sig),
                              tooltip: l10n.signPlacedSignatureDelete,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),

            // Create New Signature Button
            FilledButton.icon(
              key: const Key('sign_create_new'),
              icon: const Icon(Icons.add),
              label: Text(l10n.signSheetCreateNew),
              onPressed: isMaxReached ? null : _createNew,
            ),
          ],
        ),
      ),
    );
  }
}

class _VectorThumbPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;

  const _VectorThumbPainter({required this.strokes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final s in strokes) {
      if (s.isEmpty) continue;
      if (s.length == 1) {
        canvas.drawCircle(
          Offset(s.first.dx * size.width, s.first.dy * size.height),
          1.5,
          dotPaint,
        );
      } else {
        final path = Path()
          ..moveTo(s.first.dx * size.width, s.first.dy * size.height);
        for (var i = 1; i < s.length; i++) {
          path.lineTo(s[i].dx * size.width, s[i].dy * size.height);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _VectorThumbPainter oldDelegate) =>
      oldDelegate.strokes != strokes || oldDelegate.color != color;
}
