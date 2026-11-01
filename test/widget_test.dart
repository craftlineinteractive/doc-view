import 'package:docview/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DocReaderApp smoke test - renders navigation tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DocReaderApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('All files'), findsWidgets);
    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
