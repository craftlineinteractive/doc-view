import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State representation for multi-selection mode across file listings.
class SelectionState {
  const SelectionState({
    this.isSelectionMode = false,
    this.selectedPaths = const <String>{},
  });

  final bool isSelectionMode;
  final Set<String> selectedPaths;

  int get count => selectedPaths.length;
  bool isSelected(String path) => selectedPaths.contains(path);

  SelectionState copyWith({
    bool? isSelectionMode,
    Set<String>? selectedPaths,
  }) {
    return SelectionState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedPaths: selectedPaths ?? this.selectedPaths,
    );
  }
}

/// Unified notifier managing selection mode, selected paths, and batch actions.
class SelectionNotifier extends Notifier<SelectionState> {
  @override
  SelectionState build() => const SelectionState();

  /// Starts selection mode with [initialPath] selected.
  void startSelection(String initialPath) {
    state = SelectionState(
      isSelectionMode: true,
      selectedPaths: {initialPath},
    );
  }

  /// Toggles selection of [path]. Exits selection mode if the last item is unselected.
  void toggle(String path) {
    if (!state.isSelectionMode) return;
    final updated = Set<String>.from(state.selectedPaths);
    if (updated.contains(path)) {
      updated.remove(path);
      if (updated.isEmpty) {
        state = const SelectionState(isSelectionMode: false);
        return;
      }
    } else {
      updated.add(path);
    }
    state = state.copyWith(selectedPaths: updated);
  }

  /// Selects all paths in [allPaths].
  void selectAll(List<String> allPaths) {
    state = state.copyWith(
      isSelectionMode: true,
      selectedPaths: allPaths.toSet(),
    );
  }

  /// Unselects all items or cancels selection mode.
  void clear() {
    state = const SelectionState(
      isSelectionMode: false,
      selectedPaths: {},
    );
  }
}

/// Global selection state provider used by both FilesScreen and SearchScreen.
final selectionProvider =
    NotifierProvider<SelectionNotifier, SelectionState>(SelectionNotifier.new);

