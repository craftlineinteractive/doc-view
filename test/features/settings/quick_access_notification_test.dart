import 'package:docview/features/settings/settings_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildSettingsWidget({
    bool widgetsEnabled = true,
  }) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsScreen(
          widgetsEnabledOverride: widgetsEnabled,
        ),
      ),
    );
  }

  group('SettingsScreen G8 Widget & Notification Rows', () {
    testWidgets('displays Quick access notification switch under General', (tester) async {
      await tester.pumpWidget(buildSettingsWidget());
      await tester.pumpAndSettle();

      final notifRow = find.byKey(const Key('settings_quick_access_notification'));
      expect(notifRow, findsOneWidget);

      final switchWidget = find.byKey(const Key('settings_quick_access_notification_switch'));
      expect(switchWidget, findsOneWidget);
    });

    testWidgets('displays Add Widget row under Others and opens AddWidgetBottomSheet', (tester) async {
      await tester.pumpWidget(buildSettingsWidget(widgetsEnabled: true));
      await tester.pumpAndSettle();

      final addWidgetRow = find.byKey(const Key('settings_add_widget'));
      await tester.scrollUntilVisible(addWidgetRow, 100);
      await tester.pumpAndSettle();

      expect(addWidgetRow, findsOneWidget);

      await tester.tap(addWidgetRow);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_widget_bottom_sheet')), findsOneWidget);
    });
  });
}
