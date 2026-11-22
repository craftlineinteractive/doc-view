import 'dart:ui';

import 'package:docview/data/models/pdf_markup.dart';
import 'package:docview/data/services/pdf/pdf_annotation_service.dart';
import 'package:docview/features/tools/annotate/annotate_session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnnotateSessionNotifier Tests', () {
    late ProviderContainer container;
    late AnnotateSessionNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(annotateSessionProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    AnnotateSessionState getState() => container.read(annotateSessionProvider);

    test('initial state has default tool, yellow color, empty markups, not dirty', () {
      final state = getState();
      expect(state.markups, isEmpty);
      expect(state.selectedTool, TextMarkupType.highlight);
      expect(state.selectedColor, AnnotateColors.yellow);
      expect(state.isDirty, isFalse);
      expect(state.canUndo, isFalse);
      expect(state.canRedo, isFalse);
    });

    test('addMarkup appends markup, updates isDirty and canUndo, clears redo', () {
      final markup1 = TextMarkup(
        id: '1',
        pageIndex: 0,
        type: TextMarkupType.highlight,
        colorValue: 0xFFFFEB3B,
        lineRects: const [Rect.fromLTWH(10, 10, 100, 20)],
        text: 'Sample',
        createdAtMs: 1000,
      );

      notifier.addMarkup(markup1);

      expect(getState().markups.length, 1);
      expect(getState().isDirty, isTrue);
      expect(getState().canUndo, isTrue);
      expect(getState().canRedo, isFalse);
    });

    test('undo and redo cycle properly restores state', () {
      final m1 = TextMarkup(
        id: '1',
        pageIndex: 0,
        type: TextMarkupType.highlight,
        colorValue: 0xFFFFEB3B,
        lineRects: const [Rect.fromLTWH(10, 10, 100, 20)],
        text: 'Text 1',
        createdAtMs: 1000,
      );
      final m2 = TextMarkup(
        id: '2',
        pageIndex: 0,
        type: TextMarkupType.underline,
        colorValue: 0xFF4CAF50,
        lineRects: const [Rect.fromLTWH(10, 40, 100, 20)],
        text: 'Text 2',
        createdAtMs: 2000,
      );

      notifier.addMarkup(m1);
      notifier.addMarkup(m2);
      expect(getState().markups.length, 2);

      // Undo m2
      notifier.undo();
      expect(getState().markups.length, 1);
      expect(getState().markups.first.id, '1');
      expect(getState().canRedo, isTrue);

      // Undo m1
      notifier.undo();
      expect(getState().markups, isEmpty);
      expect(getState().canUndo, isFalse);
      expect(getState().canRedo, isTrue);

      // Redo m1
      notifier.redo();
      expect(getState().markups.length, 1);
      expect(getState().markups.first.id, '1');

      // Redo m2
      notifier.redo();
      expect(getState().markups.length, 2);
      expect(getState().markups.last.id, '2');
      expect(getState().canRedo, isFalse);
    });

    test('undo history is capped at 100 entries', () {
      for (var i = 0; i < 110; i++) {
        notifier.addMarkup(TextMarkup(
          id: 'id_$i',
          pageIndex: 0,
          type: TextMarkupType.highlight,
          colorValue: 0xFFFFEB3B,
          lineRects: const [Rect.fromLTWH(0, 0, 10, 10)],
          text: 'Text $i',
          createdAtMs: i,
        ));
      }

      expect(getState().markups.length, 110);
      expect(getState().undoStack.length, AnnotateSessionNotifier.maxUndoHistory);
    });

    test('removeMarkup removes matching markup by id and pushes to undo', () {
      final m1 = TextMarkup(
        id: 'target',
        pageIndex: 0,
        type: TextMarkupType.strikethrough,
        colorValue: 0xFFE91E63,
        lineRects: const [Rect.fromLTWH(0, 0, 50, 10)],
        text: 'Strikethrough text',
        createdAtMs: 100,
      );
      notifier.addMarkup(m1);
      expect(getState().markups.length, 1);

      notifier.removeMarkup('target');
      expect(getState().markups, isEmpty);

      // Undo restores it
      notifier.undo();
      expect(getState().markups.length, 1);
      expect(getState().markups.first.id, 'target');
    });

    test('selectTool and selectColor update state', () {
      notifier.selectTool(TextMarkupType.strikethrough);
      expect(getState().selectedTool, TextMarkupType.strikethrough);

      notifier.selectColor(AnnotateColors.pink);
      expect(getState().selectedColor, AnnotateColors.pink);
    });

    test('setDocumentInfo updates metadata', () {
      const info = PdfDocumentInfo(
        pageCount: 5,
        isEncrypted: false,
        hasDigitalSignature: true,
        pageRotations: [0, 90, 0, 0, 0],
        pageSizes: [Size(600, 800)],
      );

      notifier.setDocumentInfo(info);
      expect(getState().documentInfo?.pageCount, 5);
      expect(getState().documentInfo?.hasDigitalSignature, isTrue);
    });

    test('resetDirty clears undo and redo stacks', () {
      notifier.addMarkup(TextMarkup(
        id: '1',
        pageIndex: 0,
        type: TextMarkupType.highlight,
        colorValue: 0xFFFFEB3B,
        lineRects: const [Rect.fromLTWH(0, 0, 50, 10)],
        text: 'Text',
        createdAtMs: 100,
      ));
      expect(getState().isDirty, isTrue);

      notifier.resetDirty();
      expect(getState().isDirty, isFalse);
      expect(getState().canUndo, isFalse);
      expect(getState().canRedo, isFalse);
      expect(getState().markups.length, 1);
    });
  });
}
