import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/ink_stroke.dart';
import '../../../data/models/pdf_markup.dart';
import '../../../data/services/pdf/pdf_annotation_service.dart';

/// Preset palette of annotation colors (5 high-contrast accessible tints).
abstract final class AnnotateColors {
  static const Color yellow = Color(0xFFFFEB3B);
  static const Color green = Color(0xFF4CAF50);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color pink = Color(0xFFE91E63);
  static const Color orange = Color(0xFFFF9800);

  static const List<Color> palette = [
    yellow,
    green,
    cyan,
    pink,
    orange,
  ];
}

/// Preset palette of pen drawing colors (6 high-contrast accessible tints).
abstract final class PenColors {
  static const Color black = Color(0xFF000000);
  static const Color blue = Color(0xFF1E88E5);
  static const Color red = Color(0xFFE53935);
  static const Color green = Color(0xFF43A047);
  static const Color purple = Color(0xFF8E24AA);
  static const Color orange = Color(0xFFFB8C00);

  static const List<Color> palette = [
    black,
    blue,
    red,
    green,
    purple,
    orange,
  ];
}

/// Active tool in the Annotate screen.
enum AnnotateActiveTool {
  highlight,
  underline,
  strikethrough,
  pen;

  String get name {
    switch (this) {
      case AnnotateActiveTool.highlight:
        return 'highlight';
      case AnnotateActiveTool.underline:
        return 'underline';
      case AnnotateActiveTool.strikethrough:
        return 'strikethrough';
      case AnnotateActiveTool.pen:
        return 'pen';
    }
  }
}

/// Unified snapshot representing the document's markups and ink strokes at a point in time.
class AnnotateSnapshot {
  const AnnotateSnapshot({
    required this.markups,
    required this.strokes,
  });

  final List<TextMarkup> markups;
  final List<InkStroke> strokes;
}

/// Immutable state for an active PDF annotation editing session.
class AnnotateSessionState {
  final List<TextMarkup> markups;
  final List<InkStroke> strokes;
  final List<AnnotateSnapshot> undoStack;
  final List<AnnotateSnapshot> redoStack;
  final AnnotateActiveTool activeTool;
  final Color selectedColor;
  final Color penColor;
  final double penStrokeWidth;
  final bool isEraserMode;
  final bool isSaving;
  final PdfDocumentInfo? documentInfo;
  final int currentPage;

  const AnnotateSessionState({
    this.markups = const [],
    this.strokes = const [],
    this.undoStack = const [],
    this.redoStack = const [],
    this.activeTool = AnnotateActiveTool.highlight,
    this.selectedColor = AnnotateColors.yellow,
    this.penColor = PenColors.black,
    this.penStrokeWidth = 2.0,
    this.isEraserMode = false,
    this.isSaving = false,
    this.documentInfo,
    this.currentPage = 0,
  });

  TextMarkupType get selectedTool {
    switch (activeTool) {
      case AnnotateActiveTool.underline:
        return TextMarkupType.underline;
      case AnnotateActiveTool.strikethrough:
        return TextMarkupType.strikethrough;
      case AnnotateActiveTool.highlight:
      case AnnotateActiveTool.pen:
        return TextMarkupType.highlight;
    }
  }

  bool get canUndo => undoStack.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;
  bool get isDirty => undoStack.isNotEmpty;
  bool get hasChanges => markups.isNotEmpty || strokes.isNotEmpty;

  AnnotateSessionState copyWith({
    List<TextMarkup>? markups,
    List<InkStroke>? strokes,
    List<AnnotateSnapshot>? undoStack,
    List<AnnotateSnapshot>? redoStack,
    AnnotateActiveTool? activeTool,
    Color? selectedColor,
    Color? penColor,
    double? penStrokeWidth,
    bool? isEraserMode,
    bool? isSaving,
    PdfDocumentInfo? documentInfo,
    int? currentPage,
  }) {
    return AnnotateSessionState(
      markups: markups ?? this.markups,
      strokes: strokes ?? this.strokes,
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
      activeTool: activeTool ?? this.activeTool,
      selectedColor: selectedColor ?? this.selectedColor,
      penColor: penColor ?? this.penColor,
      penStrokeWidth: penStrokeWidth ?? this.penStrokeWidth,
      isEraserMode: isEraserMode ?? this.isEraserMode,
      isSaving: isSaving ?? this.isSaving,
      documentInfo: documentInfo ?? this.documentInfo,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// State notifier managing PDF markup annotations, strokes, undo/redo history, and active tool selection.
class AnnotateSessionNotifier extends Notifier<AnnotateSessionState> {
  @override
  AnnotateSessionState build() => const AnnotateSessionState();

  static const int maxUndoHistory = 100;

  void setDocumentInfo(PdfDocumentInfo info) {
    state = state.copyWith(documentInfo: info);
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void selectTool(TextMarkupType tool) {
    AnnotateActiveTool next;
    switch (tool) {
      case TextMarkupType.highlight:
        next = AnnotateActiveTool.highlight;
        break;
      case TextMarkupType.underline:
        next = AnnotateActiveTool.underline;
        break;
      case TextMarkupType.strikethrough:
        next = AnnotateActiveTool.strikethrough;
        break;
    }
    state = state.copyWith(
      activeTool: next,
      isEraserMode: false,
    );
  }

  void selectActiveTool(AnnotateActiveTool tool) {
    state = state.copyWith(
      activeTool: tool,
      isEraserMode: false,
    );
  }

  void selectColor(Color color) {
    state = state.copyWith(selectedColor: color);
  }

  void setPenColor(Color color) {
    state = state.copyWith(penColor: color);
  }

  void setPenStrokeWidth(double width) {
    state = state.copyWith(penStrokeWidth: width.clamp(1.0, 12.0));
  }

  void setEraserMode(bool enabled) {
    state = state.copyWith(isEraserMode: enabled);
  }

  void setSaving(bool saving) {
    state = state.copyWith(isSaving: saving);
  }

  void _pushSnapshot() {
    final snapshot = AnnotateSnapshot(
      markups: state.markups,
      strokes: state.strokes,
    );
    final newUndo = List<AnnotateSnapshot>.from(state.undoStack)..add(snapshot);
    if (newUndo.length > maxUndoHistory) {
      newUndo.removeAt(0);
    }
    state = state.copyWith(
      undoStack: newUndo,
      redoStack: const [],
    );
  }

  /// Adds a new [markup] to the session, recording the previous state in [undoStack].
  void addMarkup(TextMarkup markup) {
    _pushSnapshot();
    final newMarkups = List<TextMarkup>.from(state.markups)..add(markup);
    state = state.copyWith(markups: newMarkups);
  }

  /// Removes the markup with [id], recording previous state in [undoStack].
  void removeMarkup(String id) {
    final idx = state.markups.indexWhere((m) => m.id == id);
    if (idx == -1) return;

    _pushSnapshot();
    final newMarkups = List<TextMarkup>.from(state.markups)..removeAt(idx);
    state = state.copyWith(markups: newMarkups);
  }

  /// Adds a new freehand [stroke] to the session, observing the 300,000 document point cap.
  void addStroke(InkStroke stroke) {
    final totalPoints = state.strokes.fold<int>(0, (sum, s) => sum + s.points.length);
    if (totalPoints + stroke.points.length > InkStrokeMath.maxPointsPerDocument) {
      // Over budget, ignore or drop oldest stroke
      return;
    }

    _pushSnapshot();
    final newStrokes = List<InkStroke>.from(state.strokes)..add(stroke);
    state = state.copyWith(strokes: newStrokes);
  }

  /// Removes the stroke with [id], recording previous state in [undoStack].
  void removeStroke(String id) {
    final idx = state.strokes.indexWhere((s) => s.id == id);
    if (idx == -1) return;

    _pushSnapshot();
    final newStrokes = List<InkStroke>.from(state.strokes)..removeAt(idx);
    state = state.copyWith(strokes: newStrokes);
  }

  /// Undoes the last operation (markup or stroke).
  void undo() {
    if (!state.canUndo) return;

    final newUndo = List<AnnotateSnapshot>.from(state.undoStack);
    final previous = newUndo.removeLast();

    final currentSnapshot = AnnotateSnapshot(
      markups: state.markups,
      strokes: state.strokes,
    );
    final newRedo = List<AnnotateSnapshot>.from(state.redoStack)..add(currentSnapshot);

    state = state.copyWith(
      markups: previous.markups,
      strokes: previous.strokes,
      undoStack: newUndo,
      redoStack: newRedo,
    );
  }

  /// Redoes the previously undone operation.
  void redo() {
    if (!state.canRedo) return;

    final newRedo = List<AnnotateSnapshot>.from(state.redoStack);
    final next = newRedo.removeLast();

    final currentSnapshot = AnnotateSnapshot(
      markups: state.markups,
      strokes: state.strokes,
    );
    final newUndo = List<AnnotateSnapshot>.from(state.undoStack)..add(currentSnapshot);
    if (newUndo.length > maxUndoHistory) {
      newUndo.removeAt(0);
    }

    state = state.copyWith(
      markups: next.markups,
      strokes: next.strokes,
      undoStack: newUndo,
      redoStack: newRedo,
    );
  }

  /// Resets dirty status after successfully saving.
  void resetDirty() {
    state = state.copyWith(
      undoStack: const [],
      redoStack: const [],
    );
  }
}

/// Provider for the annotation session state.
final annotateSessionProvider =
    NotifierProvider<AnnotateSessionNotifier, AnnotateSessionState>(
  AnnotateSessionNotifier.new,
);
