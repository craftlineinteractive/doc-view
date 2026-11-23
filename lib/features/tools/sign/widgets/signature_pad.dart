import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../core/theme/doc_view_typography.dart';
import '../../../../data/models/ink_stroke.dart';

/// Result from [SignaturePad] providing normalized vector stroke polylines.
class SignaturePadResult {
  final List<List<Offset>> normalizedStrokes;
  final double aspectRatio;
  final bool saveForFutureUse;

  const SignaturePadResult({
    required this.normalizedStrokes,
    required this.aspectRatio,
    required this.saveForFutureUse,
  });
}

/// Interactive vector drawing pad allowing users to hand-draw their signature,
/// featuring baseline guide, "Sign here" hint, Undo, Clear, "Use once" and "Save and use" options.
class SignaturePad extends StatefulWidget {
  const SignaturePad({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3.0,
    super.key,
  });

  final Color strokeColor;
  final double strokeWidth;

  /// Helper to display the signature pad in a tall modal bottom sheet.
  static Future<SignaturePadResult?> show(BuildContext context) {
    return showModalBottomSheet<SignaturePadResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SignaturePad(),
    );
  }

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentStroke = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentStroke.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentStroke.isNotEmpty) {
      final processed = InkStrokeMath.isTapDot(_currentStroke)
          ? [_currentStroke.first]
          : InkStrokeMath.processPoints(_currentStroke);
      if (processed.isNotEmpty) {
        setState(() {
          _strokes.add(processed);
          _currentStroke = [];
        });
      }
    }
  }

  void _clear() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
    });
  }

  void _undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.removeLast();
      });
    }
  }

  void _complete({required bool saveForFutureUse}) {
    final allStrokes = [..._strokes];
    if (_currentStroke.isNotEmpty) {
      allStrokes.add(_currentStroke);
    }
    if (allStrokes.isEmpty) return;

    var minX = double.infinity;
    var maxX = double.negativeInfinity;
    var minY = double.infinity;
    var maxY = double.negativeInfinity;

    for (final s in allStrokes) {
      for (final p in s) {
        if (p.dx < minX) minX = p.dx;
        if (p.dx > maxX) maxX = p.dx;
        if (p.dy < minY) minY = p.dy;
        if (p.dy > maxY) maxY = p.dy;
      }
    }

    final width = math.max(maxX - minX, 20.0);
    final height = math.max(maxY - minY, 10.0);
    final aspectRatio = width / height;

    final normalized = allStrokes.map((stroke) {
      return stroke.map((p) {
        final nx = ((p.dx - minX) / width).clamp(0.0, 1.0);
        final ny = ((p.dy - minY) / height).clamp(0.0, 1.0);
        return Offset(nx, ny);
      }).toList();
    }).toList();

    Navigator.of(context).pop(
      SignaturePadResult(
        normalizedStrokes: normalized,
        aspectRatio: aspectRatio,
        saveForFutureUse: saveForFutureUse,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final hasContent = _strokes.isNotEmpty || _currentStroke.isNotEmpty;
    final canUndo = _strokes.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Drag Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: tokens.hairline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Top Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.signPadTitle,
                    style: DocViewTypography.headlineSm.copyWith(
                      color: tokens.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  key: const Key('signature_pad_undo'),
                  icon: const Icon(Icons.undo),
                  tooltip: l10n.signPadUndo,
                  onPressed: canUndo ? _undo : null,
                ),
                TextButton(
                  key: const Key('signature_pad_clear'),
                  onPressed: hasContent ? _clear : null,
                  child: Text(l10n.signPadClear),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Drawing Canvas with Baseline & Hint
          Container(
            height: 260,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tokens.hairline),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GestureDetector(
                key: const Key('signature_pad_canvas'),
                behavior: HitTestBehavior.opaque,
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: CustomPaint(
                  painter: _SignatureCanvasPainter(
                    strokes: _strokes,
                    currentStroke: _currentStroke,
                    color: widget.strokeColor,
                    strokeWidth: widget.strokeWidth,
                    baselineHint: l10n.signPadBaselineHint,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Action Buttons: Use once vs Save and use
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: const Key('signature_pad_use_once'),
                    onPressed: hasContent ? () => _complete(saveForFutureUse: false) : null,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      l10n.signPadUseOnce,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    key: const Key('signature_pad_save_and_use'),
                    onPressed: hasContent ? () => _complete(saveForFutureUse: true) : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      l10n.signPadSaveAndUse,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignatureCanvasPainter extends CustomPainter {
  const _SignatureCanvasPainter({
    required this.strokes,
    required this.currentStroke,
    required this.color,
    required this.strokeWidth,
    required this.baselineHint,
  });

  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Color color;
  final double strokeWidth;
  final String baselineHint;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw subtle baseline guide
    final baselineY = size.height * 0.75;
    final guidePaint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(20, baselineY), Offset(size.width - 20, baselineY), guidePaint);

    // Baseline "Sign here" text prompt
    final textPainter = TextPainter(
      text: TextSpan(
        text: baselineHint,
        style: const TextStyle(
          color: Colors.black26,
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(24, baselineY + 6));

    // 2. Draw Vector Strokes
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final s in strokes) {
      if (s.isEmpty) continue;
      if (s.length == 1) {
        canvas.drawCircle(s.first, strokeWidth / 2, dotPaint);
      } else {
        final path = Path()..moveTo(s.first.dx, s.first.dy);
        for (var i = 1; i < s.length; i++) {
          path.lineTo(s[i].dx, s[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }

    if (currentStroke.isNotEmpty) {
      if (currentStroke.length == 1) {
        canvas.drawCircle(currentStroke.first, strokeWidth / 2, dotPaint);
      } else {
        final path = Path()..moveTo(currentStroke.first.dx, currentStroke.first.dy);
        for (var i = 1; i < currentStroke.length; i++) {
          path.lineTo(currentStroke[i].dx, currentStroke[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignatureCanvasPainter oldDelegate) => true;
}
