import 'package:docview/app.dart';
import 'package:docview/core/constants/file_types.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'DocReaderApp smoke test - renders navigation tabs, grid and sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoryCountsProvider.overrideWith(
            (ref) async => {
              FileCategory.pdf: 5,
              FileCategory.word: 3,
              FileCategory.excel: 2,
              FileCategory.ppt: 1,
              FileCategory.txt: 4,
              FileCategory.image: 10,
              FileCategory.other: 0,
            },
          ),
        ],
        child: const DocReaderApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Doc Reader'), findsOneWidget);
    expect(find.text('All files'), findsWidgets);
    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('Word'), findsOneWidget);
    expect(find.text('Recent'), findsOneWidget);
    expect(find.text('Bookmarks'), findsOneWidget);
  });
}
