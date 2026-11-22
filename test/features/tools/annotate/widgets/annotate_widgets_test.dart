import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/pdf_markup.dart';
import 'package:docview/features/tools/annotate/annotate_session_notifier.dart';
import 'package:docview/features/tools/annotate/widgets/annotate_toolbar.dart';
import 'package:docview/features/tools/annotate/widgets/page_markup_overlay.dart';
import 'package:docview/features/tools/annotate/widgets/selection_menu.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  group('AnnotateToolbar Tests', () {
    testWidgets('renders tools and colors, triggers callbacks on tap', (tester) async {
      AnnotateActiveTool selectedTool = AnnotateActiveTool.highlight;
      Color selectedColor = AnnotateColors.yellow;

      await tester.pumpWidget(
        buildTestableWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return AnnotateToolbar(
                activeTool: selectedTool,
                selectedMarkupColor: selectedColor,
                onToolSelected: (t) => setState(() => selectedTool = t as AnnotateActiveTool),
                onColorSelected: (c) => setState(() => selectedColor = c),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify tool buttons
      expect(find.byKey(const Key('annotate_tool_highlight')), findsOneWidget);
      expect(find.byKey(const Key('annotate_tool_underline')), findsOneWidget);
      expect(find.byKey(const Key('annotate_tool_strikethrough')), findsOneWidget);
      expect(find.byKey(const Key('annotate_tool_pen')), findsOneWidget);

      // Verify color swatches
      expect(find.byKey(const Key('annotate_color_swatches')), findsOneWidget);

      // Tap Underline tool
      await tester.tap(find.byKey(const Key('annotate_tool_underline')));
      await tester.pumpAndSettle();
      expect(selectedTool, AnnotateActiveTool.underline);

      // Tap Pink color
      final pinkSwatch = find.bySemanticsLabel('Pink');
      expect(pinkSwatch, findsOneWidget);
      await tester.tap(pinkSwatch);
      await tester.pumpAndSettle();
      expect(selectedColor, AnnotateColors.pink);
    });
  });

  group('SelectionMenu Tests', () {
    testWidgets('renders 4 actions and triggers callbacks', (tester) async {
      var copyCalled = false;
      var highlightCalled = false;
      var underlineCalled = false;
      var strikethroughCalled = false;

      await tester.pumpWidget(
        buildTestableWidget(
          SelectionMenu(
            onCopy: () => copyCalled = true,
            onHighlight: () => highlightCalled = true,
            onUnderline: () => underlineCalled = true,
            onStrikethrough: () => strikethroughCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('selection_action_copy')), findsOneWidget);
      expect(find.byKey(const Key('selection_action_highlight')), findsOneWidget);
      expect(find.byKey(const Key('selection_action_underline')), findsOneWidget);
      expect(find.byKey(const Key('selection_action_strikethrough')), findsOneWidget);

      await tester.tap(find.byKey(const Key('selection_action_copy')));
      expect(copyCalled, isTrue);

      await tester.tap(find.byKey(const Key('selection_action_highlight')));
      expect(highlightCalled, isTrue);

      await tester.tap(find.byKey(const Key('selection_action_underline')));
      expect(underlineCalled, isTrue);

      await tester.tap(find.byKey(const Key('selection_action_strikethrough')));
      expect(strikethroughCalled, isTrue);
    });
  });

  group('PageMarkupOverlay Tests', () {
    testWidgets('renders CustomPaint when markups exist for current page', (tester) async {
      final markups = [
        TextMarkup(
          id: '1',
          pageIndex: 0,
          type: TextMarkupType.highlight,
          colorValue: 0xFFFFEB3B,
          lineRects: const [Rect.fromLTWH(10, 10, 100, 20)],
          text: 'Highlighted',
          createdAtMs: 1000,
        ),
      ];

      await tester.pumpWidget(
        buildTestableWidget(
          PageMarkupOverlay(
            pageIndex: 0,
            markups: markups,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final overlayPaint = find.descendant(
        of: find.byType(PageMarkupOverlay),
        matching: find.byType(CustomPaint),
      );
      expect(overlayPaint, findsOneWidget);
    });

    testWidgets('renders SizedBox.shrink when no markups exist for current page', (tester) async {
      final markups = [
        TextMarkup(
          id: '1',
          pageIndex: 1, // On page 1, not 0
          type: TextMarkupType.highlight,
          colorValue: 0xFFFFEB3B,
          lineRects: const [Rect.fromLTWH(10, 10, 100, 20)],
          text: 'Highlighted',
          createdAtMs: 1000,
        ),
      ];

      await tester.pumpWidget(
        buildTestableWidget(
          PageMarkupOverlay(
            pageIndex: 0,
            markups: markups,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final overlayPaint = find.descendant(
        of: find.byType(PageMarkupOverlay),
        matching: find.byType(CustomPaint),
      );
      expect(overlayPaint, findsNothing);
    });
  });
}
