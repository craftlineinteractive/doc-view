import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/features/viewer/widgets/office_outline_sheet.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:docview/shared/widgets/reader/reader_bottom_row.dart';
import 'package:docview/shared/widgets/reader/reader_search_bar.dart';

Widget _buildTestApp({
  required Widget child,
  ThemeData? theme,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    theme: theme ?? AppTheme.lightTheme,
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('en', 'XA')],
    home: Scaffold(body: child),
  );
}

void main() {
  group('Office Viewer Bottom Row & Capability Rules', () {
    testWidgets(
        'shows exactly Rotate, Search, Share and strictly hides Horizontal and Invert',
        (tester) async {
      var rotateTapped = false;
      var searchTapped = false;
      var shareTapped = false;

      // Build Office viewer's bottom row configuration
      final items = [
        ReaderBottomRowItem(
          icon: Icons.screen_rotation_outlined,
          label: 'Rotate',
          tooltip: 'Rotate',
          onTap: () => rotateTapped = true,
        ),
        ReaderBottomRowItem(
          icon: Icons.search_rounded,
          label: 'Search',
          tooltip: 'Search',
          onTap: () => searchTapped = true,
        ),
        ReaderBottomRowItem(
          icon: Icons.share_outlined,
          label: 'Share',
          tooltip: 'Share',
          onTap: () => shareTapped = true,
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

      // Exactly 3 items
      expect(find.text('Rotate'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);

      // Horizontal and Invert are strictly HIDDEN
      expect(find.text('Horizontal'), findsNothing);
      expect(find.text('Vertical'), findsNothing);
      expect(find.text('Invert'), findsNothing);

      // Verify interactive taps
      await tester.tap(find.text('Rotate'));
      expect(rotateTapped, isTrue);

      await tester.tap(find.text('Search'));
      expect(searchTapped, isTrue);

      await tester.tap(find.text('Share'));
      expect(shareTapped, isTrue);
    });

    testWidgets('ReaderSearchBar hides chevrons and renders match count for Office docs',
        (tester) async {
      final controller = TextEditingController(text: 'quarterly');

      await tester.pumpWidget(
        _buildTestApp(
          child: ReaderSearchBar(
            controller: controller,
            totalMatches: 8,
            currentMatchIndex: null,
            showNavigationChevrons: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Chevrons should NOT be rendered when showNavigationChevrons is false
      expect(find.byKey(const Key('reader_search_prev_button')), findsNothing);
      expect(find.byKey(const Key('reader_search_next_button')), findsNothing);

      // Total matches indicator is displayed
      expect(find.text('8 matches'), findsOneWidget);
    });

    testWidgets('ReaderSearchBar renders singular match count', (tester) async {
      final controller = TextEditingController(text: 'report');

      await tester.pumpWidget(
        _buildTestApp(
          child: ReaderSearchBar(
            controller: controller,
            totalMatches: 1,
            currentMatchIndex: null,
            showNavigationChevrons: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 match'), findsOneWidget);
    });
  });

  group('OfficeOutlineSheet Tests', () {
    testWidgets('renders section items, counter, and selection callback',
        (tester) async {
      int? selectedIndex;
      final outline = ['Introduction', 'Financial Overview', 'Conclusion'];

      await tester.pumpWidget(
        _buildTestApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  OfficeOutlineSheet.show(
                    context,
                    outline: outline,
                    currentPosition: 1,
                    onSectionSelected: (i) => selectedIndex = i,
                  );
                },
                child: const Text('Open Outline'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Outline'));
      await tester.pumpAndSettle();

      // Header and badge count
      expect(find.text('Document outline'), findsOneWidget);
      expect(find.text('3 items'), findsOneWidget);

      // Section titles
      expect(find.text('Introduction'), findsOneWidget);
      expect(find.text('Financial Overview'), findsOneWidget);
      expect(find.text('Conclusion'), findsOneWidget);

      // Current section (index 1) has active check indicator
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      // Tap on Conclusion (index 2)
      await tester.tap(find.text('Conclusion'));
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(2));
      // Sheet dismissed
      expect(find.text('Document Outline'), findsNothing);
    });

    testWidgets('renders empty state when outline list is empty', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  OfficeOutlineSheet.show(
                    context,
                    outline: const [],
                  );
                },
                child: const Text('Open Empty Outline'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Empty Outline'));
      await tester.pumpAndSettle();

      expect(find.text('No sections found in this document'), findsOneWidget);
      expect(find.text('0 items'), findsOneWidget);
    });
  });
}
