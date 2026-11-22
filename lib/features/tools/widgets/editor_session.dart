/// Generic immutable undo/redo history manager capped at [maxUndoHistory] entries.
class EditorSession<T> {
  const EditorSession({
    required this.current,
    this.undoStack = const [],
    this.redoStack = const [],
  });

  /// Maximum allowed snapshots retained in the undo stack.
  static const int maxUndoHistory = 100;

  final T current;
  final List<T> undoStack;
  final List<T> redoStack;

  bool get canUndo => undoStack.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;
  bool get isDirty => undoStack.isNotEmpty;

  /// Pushes a new snapshot [next], pushing [current] onto the undo stack and clearing redo.
  EditorSession<T> push(T next) {
    final newUndo = [...undoStack, current];
    if (newUndo.length > maxUndoHistory) {
      newUndo.removeAt(0);
    }
    return EditorSession(
      current: next,
      undoStack: newUndo,
      redoStack: const [],
    );
  }

  /// Reverts to the most recent snapshot from [undoStack].
  EditorSession<T> undo() {
    if (!canUndo) return this;
    final previous = undoStack.last;
    final newUndo = undoStack.sublist(0, undoStack.length - 1);
    final newRedo = [...redoStack, current];
    if (newRedo.length > maxUndoHistory) {
      newRedo.removeAt(0);
    }
    return EditorSession(
      current: previous,
      undoStack: newUndo,
      redoStack: newRedo,
    );
  }

  /// Re-applies the most recent undone snapshot from [redoStack].
  EditorSession<T> redo() {
    if (!canRedo) return this;
    final next = redoStack.last;
    final newRedo = redoStack.sublist(0, redoStack.length - 1);
    final newUndo = [...undoStack, current];
    if (newUndo.length > maxUndoHistory) {
      newUndo.removeAt(0);
    }
    return EditorSession(
      current: next,
      undoStack: newUndo,
      redoStack: newRedo,
    );
  }

  /// Resets dirty flag by clearing history while keeping [current].
  EditorSession<T> markClean() {
    return EditorSession(
      current: current,
      undoStack: const [],
      redoStack: const [],
    );
  }
}
