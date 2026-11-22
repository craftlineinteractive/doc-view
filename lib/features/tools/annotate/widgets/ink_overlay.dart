import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/ink_stroke.dart';

/// Custom recognizer that strictly accepts 1-finger gestures for drawing,
/// and yields to multi-touch pinch/pan gestures (2+ fingers).
class SinglePointerDrawRecognizer extends OneSequenceGestureRecognizer {
  SinglePointerDrawRecognizer({super.debugOwner});

  void Function(Offset localPosition)? onStart;
  void Function(Offset localPosition)? onUpdate;
  VoidCallback? onEnd;

  int _trackedPointer = -1;
  int _activePointers = 0;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    _activePointers++;
    if (_activePointers == 1) {
      _trackedPointer = event.pointer;
      startTrackingPointer(event.pointer, event.transform);
      resolve(GestureDisposition.accepted);
      onStart?.call(event.localPosition);
    } else {
      // 2 or more fingers: cancel drawing and yield gesture to viewer
      if (_trackedPointer != -1) {
        stopTrackingPointer(_trackedPointer);
        _trackedPointer = -1;
        onEnd?.call();
      }
      resolve(GestureDisposition.rejected);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event.pointer != _trackedPointer) return;

    if (event is PointerMoveEvent) {
      onUpdate?.call(event.localPosition);
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      stopTrackingPointer(event.pointer);
      _trackedPointer = -1;
      onEnd?.call();
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _activePointers = 0;
    _trackedPointer = -1;
  }

  @override
  String get debugDescription => 'singlePointerDrawRecognizer';
}

/// Overlay widget layered on each PDF page to render completed strokes,
/// track active drawing strokes, and handle eraser hit-testing.
class InkOverlay extends StatefulWidget {
  const InkOverlay({
    required this.pageIndex,
    required this.strokes,
    required this.isPenActive,
    required this.isEraserMode,
    required this.penColor,
    required this.strokeWidth,
    required this.onStrokeAdded,
    required this.onStrokeErased,
    super.key,
  });

  final int pageIndex;
  final List<InkStroke> strokes;
  final bool isPenActive;
  final bool isEraserMode;
  final Color penColor;
  final double strokeWidth;
  final ValueChanged<InkStroke> onStrokeAdded;
  final ValueChanged<String> onStrokeErased;

  @override
  State<InkOverlay> createState() => _InkOverlayState();
}

class _InkOverlayState extends State<InkOverlay> {
  final List<Offset> _activePoints = [];

  void _handleStart(Offset pos) {
    if (!widget.isPenActive) return;

    if (widget.isEraserMode) {
      _checkErase(pos);
    } else {
      setState(() {
        _activePoints.clear();
        _activePoints.add(pos);
      });
    }
  }

  void _handleUpdate(Offset pos) {
    if (!widget.isPenActive) return;

    if (widget.isEraserMode) {
      _checkErase(pos);
    } else {
      if (_activePoints.isEmpty) {
        setState(() {
          _activePoints.add(pos);
        });
        return;
      }
      final last = _activePoints.last;
      final distSq = (pos.dx - last.dx) * (pos.dx - last.dx) +
          (pos.dy - last.dy) * (pos.dy - last.dy);
      if (distSq >= 4.0) {
        setState(() {
          _activePoints.add(pos);
        });
      }
    }
  }

  void _handleEnd() {
    if (!widget.isPenActive || widget.isEraserMode) return;
    if (_activePoints.isEmpty) return;

    final points = List<Offset>.from(_activePoints);
    setState(() {
      _activePoints.clear();
    });

    final isDot = InkStrokeMath.isTapDot(points);
    final processed = isDot ? [points.first] : InkStrokeMath.processPoints(points);

    if (processed.isEmpty) return;

    final stroke = InkStroke(
      id: '${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(99999)}',
      pageIndex: widget.pageIndex,
      points: processed,
      colorValue: widget.penColor.toARGB32(),
      strokeWidth: widget.strokeWidth,
      timestampMs: DateTime.now().millisecondsSinceEpoch,
      isDot: isDot,
    );

    widget.onStrokeAdded(stroke);
  }

  void _checkErase(Offset pos) {
    for (final stroke in widget.strokes) {
      if (stroke.pageIndex == widget.pageIndex) {
        if (InkStrokeMath.hitTest(stroke, pos)) {
          widget.onStrokeErased(stroke.id);
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageStrokes = widget.strokes.where((s) => s.pageIndex == widget.pageIndex).toList();

    Widget content = CustomPaint(
      painter: _InkPainter(
        strokes: pageStrokes,
        activePoints: _activePoints,
        activeColor: widget.penColor,
        activeStrokeWidth: widget.strokeWidth,
      ),
    );

    if (widget.isPenActive) {
      content = RawGestureDetector(
        gestures: {
          SinglePointerDrawRecognizer:
              GestureRecognizerFactoryWithHandlers<SinglePointerDrawRecognizer>(
            () => SinglePointerDrawRecognizer(),
            (recognizer) {
              recognizer.onStart = _handleStart;
              recognizer.onUpdate = _handleUpdate;
              recognizer.onEnd = _handleEnd;
            },
          ),
        },
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}

class _InkPainter extends CustomPainter {
  const _InkPainter({
    required this.strokes,
    required this.activePoints,
    required this.activeColor,
    required this.activeStrokeWidth,
  });

  final List<InkStroke> strokes;
  final List<Offset> activePoints;
  final Color activeColor;
  final double activeStrokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Paint committed strokes
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = Color(stroke.colorValue)
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (stroke.isDot) {
        if (stroke.points.isNotEmpty) {
          final dotPaint = Paint()
            ..color = Color(stroke.colorValue)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(stroke.points.first, stroke.strokeWidth / 2, dotPaint);
        }
      } else if (stroke.points.length == 1) {
        canvas.drawCircle(stroke.points.first, stroke.strokeWidth / 2, paint..style = PaintingStyle.fill);
      } else {
        final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
        for (var i = 1; i < stroke.points.length; i++) {
          path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }

    // 2. Paint active stroke in progress
    if (activePoints.isNotEmpty) {
      final activePaint = Paint()
        ..color = activeColor
        ..strokeWidth = activeStrokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (activePoints.length == 1) {
        canvas.drawCircle(
          activePoints.first,
          activeStrokeWidth / 2,
          activePaint..style = PaintingStyle.fill,
        );
      } else {
        final activePath = Path()..moveTo(activePoints.first.dx, activePoints.first.dy);
        for (var i = 1; i < activePoints.length; i++) {
          activePath.lineTo(activePoints[i].dx, activePoints[i].dy);
        }
        canvas.drawPath(activePath, activePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _InkPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.activePoints.length != activePoints.length ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.activeStrokeWidth != activeStrokeWidth;
  }
}
