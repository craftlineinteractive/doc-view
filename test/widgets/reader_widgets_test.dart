import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:docview/shared/widgets/reader/reader_bottom_row.dart';
import 'package:docview/shared/widgets/reader/reader_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildTestApp({required Widget child, TextDirection textDirection = TextDirection.ltr}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('en', 'XA')],
    home: Directionality(
      textDirection: textDirection,
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('ReaderBottomRow Widget Tests', () {
    testWidgets('renders all 5 items with labels, icons, and accessible touch targets', (tester) async {
      var tappedIndex = -1;

      final items = [
        ReaderBottomRowItem(
          icon: Icons.swap_horiz_rounded,
          label: 'Horizontal',
          onTap: () => tappedIndex = 0,
        ),
        ReaderBottomRowItem(
          icon: Icons.screen_rotation_outlined,
          label: 'Rotate',
          onTap: () => tappedIndex = 1,
        ),
        ReaderBottomRowItem(
          icon: Icons.search_rounded,
          label: 'Search',
          onTap: () => tappedIndex = 2,
        ),
        ReaderBottomRowItem(
          icon: Icons.invert_colors_rounded,
          label: 'Invert',
          isSelected: true,
          onTap: () => tappedIndex = 3,
        ),
        ReaderBottomRowItem(
          icon: Icons.share_outlined,
          label: 'Share',
          onTap: () => tappedIndex = 4,
        ),
      ];

      await tester.pumpWidget(
        _buildTestApp(
          child: Center(
            child: ReaderBottomRow(items: items),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Horizontal'), findsOneWidget);
      expect(find.text('Rotate'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Invert'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);

      // Verify tap target height is at least 48
      final inkWellFinder = find.byType(InkWell);
      expect(inkWellFinder, findsNWidgets(5));
      for (final element in inkWellFinder.evaluate()) {
        final renderBox = element.findRenderObject() as RenderBox;
        expect(renderBox.size.height, greaterThanOrEqualTo(48.0));
      }

      // Tap on Invert
      await tester.tap(find.text('Invert'));
      expect(tappedIndex, equals(3));
    });

    testWidgets('renders skeleton state cleanly when isLoading is true', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const Center(
            child: ReaderBottomRow(
              isLoading: true,
              items: [],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Search'), findsNothing);
      expect(find.byType(ReaderBottomRow), findsOneWidget);
    });
  });

  group('ReaderSearchBar Widget Tests', () {
    testWidgets('renders input, counter, chevrons, debounces typing by 300ms, and clears', (tester) async {
      String lastQuery = '';
      var closed = false;
      var prevTapped = false;
      var nextTapped = false;

      await tester.pumpWidget(
        _buildTestApp(
          child: ReaderSearchBar(
            totalMatches: 14,
            currentMatchIndex: 1,
            onQueryChanged: (q) => lastQuery = q,
            onClose: () => closed = true,
            onPrevMatch: () => prevTapped = true,
            onNextMatch: () => nextTapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check text field
      expect(find.byKey(const Key('reader_search_text_field')), findsOneWidget);

      // Check close button
      await tester.tap(find.byKey(const Key('reader_search_close_button')));
      expect(closed, isTrue);

      // Enter query
      await tester.enterText(find.byKey(const Key('reader_search_text_field')), 'invoice');
      // Before 300 ms, debounced callback has not fired
      await tester.pump(const Duration(milliseconds: 100));
      expect(lastQuery, equals(''));

      // After 300 ms, callback fires
      await tester.pump(const Duration(milliseconds: 250));
      expect(lastQuery, equals('invoice'));

      // Check counter "2 of 14"
      expect(find.text('2 of 14'), findsOneWidget);

      // Check chevrons
      await tester.tap(find.byKey(const Key('reader_search_prev_button')));
      expect(prevTapped, isTrue);

      await tester.tap(find.byKey(const Key('reader_search_next_button')));
      expect(nextTapped, isTrue);

      // Clear button
      await tester.tap(find.byKey(const Key('reader_search_clear_button')));
      await tester.pumpAndSettle();
      expect(lastQuery, equals(''));
    });

    testWidgets('renders 500+ counter cap and scanned PDF banner', (tester) async {
      final controller = TextEditingController(text: 'the');

      await tester.pumpWidget(
        _buildTestApp(
          child: ReaderSearchBar(
            controller: controller,
            totalMatches: 540,
            currentMatchIndex: 0,
            hasNoTextLayer: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('500+'), findsOneWidget);
      expect(find.text('This PDF has no searchable text'), findsOneWidget);
    });
  });
}
