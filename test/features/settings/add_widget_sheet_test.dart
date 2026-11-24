import 'package:docview/features/settings/widgets/add_widget_bottom_sheet.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({
    double textScale = 1.0,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(
            textScaler: TextScaler.linear(textScale),
          ),
          child: Directionality(
            textDirection: textDirection,
            child: const Scaffold(
              body: AddWidgetBottomSheet(),
            ),
          ),
        ),
      ),
    );
  }

  group('AddWidgetBottomSheet UI & Accessibility Tests', () {
    testWidgets('renders recent files card (4 × 2) and page indicators', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_widget_bottom_sheet')), findsOneWidget);
      expect(find.byKey(const Key('widget_card_recent_files')), findsOneWidget);
      expect(find.text('4 × 2'), findsOneWidget);
      expect(find.byKey(const Key('widget_page_indicator_0')), findsOneWidget);
      expect(find.byKey(const Key('widget_page_indicator_1')), findsOneWidget);
      expect(find.byKey(const Key('add_widget_primary_button')), findsOneWidget);
    });

    testWidgets('swiping pageview reveals quick tools card (4 × 1)', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Swipe left on the PageView
      await tester.drag(find.byKey(const Key('add_widget_page_view')), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('widget_card_quick_tools')), findsOneWidget);
      expect(find.text('4 × 1'), findsOneWidget);
    });

    testWidgets('renders cleanly at text scale 2.0 without overflow', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildTestWidget(textScale: 2.0));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_widget_bottom_sheet')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly under RTL directionality', (tester) async {
      await tester.pumpWidget(buildTestWidget(textDirection: TextDirection.rtl));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_widget_bottom_sheet')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
