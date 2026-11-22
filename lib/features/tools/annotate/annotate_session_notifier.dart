import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// Immutable state for an active PDF annotation editing session.
class AnnotateSessionState {
  final List<TextMarkup> markups;
  final List<List<TextMarkup>> undoStack;
  final List<List<TextMarkup>> redoStack;
  final TextMarkupType selectedTool;
  final Color selectedColor;
  final bool isSaving;
  final PdfDocumentInfo? documentInfo;
  final int currentPage;

  const AnnotateSessionState({
    this.markups = const [],
    this.undoStack = const [],
    this.redoStack = const [],
    this.selectedTool = TextMarkupType.highlight,
    this.selectedColor = AnnotateColors.yellow,
    this.isSaving = false,
    this.documentInfo,
    this.currentPage = 0,
  });

  bool get canUndo => undoStack.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;
  bool get isDirty => undoStack.isNotEmpty;

  AnnotateSessionState copyWith({
    List<TextMarkup>? markups,
    List<List<TextMarkup>>? undoStack,
    List<List<TextMarkup>>? redoStack,
    TextMarkupType? selectedTool,
    Color? selectedColor,
    bool? isSaving,
    PdfDocumentInfo? documentInfo,
    int? currentPage,
  }) {
    return AnnotateSessionState(
      markups: markups ?? this.markups,
      undoStack: undoStack ?? this.undoStack,
      redoStack: redoStack ?? this.redoStack,
      selectedTool: selectedTool ?? this.selectedTool,
      selectedColor: selectedColor ?? this.selectedColor,
      isSaving: isSaving ?? this.isSaving,
      documentInfo: documentInfo ?? this.documentInfo,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// State notifier managing PDF markup annotations, undo/redo history, and active tool selection.
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
    state = state.copyWith(selectedTool: tool);
  }

  void selectColor(Color color) {
    state = state.copyWith(selectedColor: color);
  }

  void setSaving(bool saving) {
    state = state.copyWith(isSaving: saving);
  }

  /// Adds a new [markup] to the session, recording the previous state in [undoStack].
  void addMarkup(TextMarkup markup) {
    final newUndo = List<List<TextMarkup>>.from(state.undoStack)..add(state.markups);
    if (newUndo.length > maxUndoHistory) {
      newUndo.removeAt(0);
    }

    final newMarkups = List<TextMarkup>.from(state.markups)..add(markup);

    state = state.copyWith(
      markups: newMarkups,
      undoStack: newUndo,
      redoStack: const [],
    );
  }

  /// Removes the markup with [id], recording previous state in [undoStack].
  void removeMarkup(String id) {
    final idx = state.markups.indexWhere((m) => m.id == id);
    if (idx == -1) return;

    final newUndo = List<List<TextMarkup>>.from(state.undoStack)..add(state.markups);
    if (newUndo.length > maxUndoHistory) {
      newUndo.removeAt(0);
    }

    final newMarkups = List<TextMarkup>.from(state.markups)..removeAt(idx);

    state = state.copyWith(
      markups: newMarkups,
      undoStack: newUndo,
      redoStack: const [],
    );
  }

  /// Undoes the last markup operation.
  void undo() {
    if (!state.canUndo) return;

    final newUndo = List<List<TextMarkup>>.from(state.undoStack);
    final previousMarkups = newUndo.removeLast();

    final newRedo = List<List<TextMarkup>>.from(state.redoStack)..add(state.markups);

    state = state.copyWith(
      markups: previousMarkups,
      undoStack: newUndo,
      redoStack: newRedo,
    );
  }

  /// Redoes the previously undone operation.
  void redo() {
    if (!state.canRedo) return;

    final newRedo = List<List<TextMarkup>>.from(state.redoStack);
    final nextMarkups = newRedo.removeLast();

    final newUndo = List<List<TextMarkup>>.from(state.undoStack)..add(state.markups);
    if (newUndo.length > maxUndoHistory) {
      newUndo.removeAt(0);
    }

    state = state.copyWith(
      markups: nextMarkups,
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
    NotifierProvider.autoDispose<AnnotateSessionNotifier, AnnotateSessionState>(
  AnnotateSessionNotifier.new,
);
