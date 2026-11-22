import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/doc_view_tokens.dart';
import '../../../../core/theme/doc_view_typography.dart';
import '../../../../data/models/ink_stroke.dart';

/// Interactive drawing pad allowing users to hand-draw their signature in crisp black ink,
/// with real-time preview, stroke smoothing, and PNG export.
class SignaturePad extends StatefulWidget {
  const SignaturePad({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3.0,
    super.key,
  });

  final Color strokeColor;
  final double strokeWidth;

  /// Helper to display the signature pad in a standard dialog.
  static Future<Uint8List?> show(BuildContext context) {
    return showDialog<Uint8List>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SignaturePad(),
      ),
    );
  }

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  final GlobalKey _canvasKey = GlobalKey();

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

  Future<void> _save() async {
    if (_strokes.isEmpty && _currentStroke.isEmpty) return;

    // Calculate bounding box of all strokes
    final allStrokes = [..._strokes];
    if (_currentStroke.isNotEmpty) {
      allStrokes.add(_currentStroke);
    }

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

    const padding = 16.0;
    minX = (minX - padding).clamp(0.0, double.infinity);
    minY = (minY - padding).clamp(0.0, double.infinity);
    final renderWidth = (maxX - minX + padding * 2).clamp(100.0, 800.0);
    final renderHeight = (maxY - minY + padding * 2).clamp(50.0, 400.0);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, renderWidth, renderHeight));

    final paint = Paint()
      ..color = widget.strokeColor
      ..strokeWidth = widget.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.translate(-minX, -minY);

    for (final s in allStrokes) {
      if (s.isEmpty) continue;
      if (s.length == 1) {
        final dotPaint = Paint()
          ..color = widget.strokeColor
          ..style = PaintingStyle.fill;
        canvas.drawCircle(s.first, widget.strokeWidth / 2, dotPaint);
      } else {
        final path = Path()..moveTo(s.first.dx, s.first.dy);
        for (var i = 1; i < s.length; i++) {
          path.lineTo(s[i].dx, s[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(renderWidth.toInt(), renderHeight.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null && mounted) {
      Navigator.of(context).pop(byteData.buffer.asUint8List());
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final hasContent = _strokes.isNotEmpty || _currentStroke.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.signPadTitle,
                      style: DocViewTypography.headlineSm.copyWith(
                        color: tokens.textPrimary,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    key: const Key('signature_pad_clear'),
                    onPressed: hasContent ? _clear : null,
                    child: Text(l10n.signPadClear),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),

          // Drawing Canvas
          Container(
            key: _canvasKey,
            height: 220,
            color: Colors.white,
            child: GestureDetector(
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
                ),
                child: Center(
                  child: !hasContent
                      ? Text(
                          l10n.signPadTitle,
                          style: TextStyle(
                            color: Colors.black26,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          const Divider(height: 1),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton(
                  key: const Key('signature_pad_cancel'),
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(l10n.annotateDiscardDialogActionDiscard),
                ),
                FilledButton(
                  key: const Key('signature_pad_save'),
                  onPressed: hasContent ? _save : null,
                  child: Text(l10n.signPadSave),
                ),
              ],
            ),
          ),
        ],
      ),
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
  });

  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
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
  bool shouldRepaint(covariant _SignatureCanvasPainter oldDelegate) {
    return true;
  }
}
