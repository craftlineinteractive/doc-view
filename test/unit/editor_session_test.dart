import 'package:docview/features/tools/widgets/editor_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditorSession Unit Tests', () {
    test('initial state has empty stacks and is not dirty', () {
      const session = EditorSession<int>(current: 0);
      expect(session.current, 0);
      expect(session.canUndo, isFalse);
      expect(session.canRedo, isFalse);
      expect(session.isDirty, isFalse);
    });

    test('push updates current, enables undo, and clears redo', () {
      var session = const EditorSession<String>(current: 'A');
      session = session.push('B');

      expect(session.current, 'B');
      expect(session.canUndo, isTrue);
      expect(session.canRedo, isFalse);
      expect(session.isDirty, isTrue);
      expect(session.undoStack, ['A']);
    });

    test('undo and redo cycle restores previous and next snapshots', () {
      var session = const EditorSession<int>(current: 1);
      session = session.push(2).push(3);

      expect(session.current, 3);
      expect(session.undoStack, [1, 2]);

      session = session.undo();
      expect(session.current, 2);
      expect(session.canRedo, isTrue);
      expect(session.redoStack, [3]);

      session = session.undo();
      expect(session.current, 1);
      expect(session.canUndo, isFalse);
      expect(session.canRedo, isTrue);
      expect(session.redoStack, [3, 2]);

      session = session.redo();
      expect(session.current, 2);
      expect(session.canUndo, isTrue);

      session = session.redo();
      expect(session.current, 3);
      expect(session.canRedo, isFalse);
    });

    test('enforces maxUndoHistory cap of 100 snapshots', () {
      var session = const EditorSession<int>(current: 0);
      for (var i = 1; i <= 150; i++) {
        session = session.push(i);
      }

      expect(session.current, 150);
      expect(session.undoStack.length, 100);
      expect(session.undoStack.first, 50); // 0-49 trimmed
      expect(session.undoStack.last, 149);
    });

    test('markClean resets dirty and undo/redo stacks', () {
      var session = const EditorSession<String>(current: 'X');
      session = session.push('Y').push('Z');
      expect(session.isDirty, isTrue);

      session = session.markClean();
      expect(session.current, 'Z');
      expect(session.isDirty, isFalse);
      expect(session.canUndo, isFalse);
      expect(session.canRedo, isFalse);
    });
  });
}
