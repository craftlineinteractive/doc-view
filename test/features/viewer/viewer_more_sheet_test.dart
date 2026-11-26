import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/viewer/widgets/viewer_more_sheet.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

DocFile _testDocFile({required String name, required String path, FileCategory category = FileCategory.pdf}) {
  return DocFile(
    id: 101,
    path: path,
    name: name,
    extension: '.pdf',
    sizeBytes: 2048,
    modified: DateTime(2026, 11, 26),
    category: category,
  );
}

void main() {
  group('ViewerMoreSheet Widget Tests', () {
    testWidgets('renders common options (Share, Open, Details, Bookmark)', (tester) async {
      final file = _testDocFile(name: 'sample.pdf', path: '/tmp/sample.pdf');

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: ViewerMoreSheet(file: file),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check header
      expect(find.text('sample.pdf'), findsOneWidget);

      // Check common actions
      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
      expect(find.byIcon(Icons.launch_outlined), findsOneWidget);
      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
    });

    testWidgets('renders Outline option when hasOutline is true', (tester) async {
      final file = _testDocFile(name: 'slides.pptx', path: '/tmp/slides.pptx', category: FileCategory.ppt);
      bool outlineTapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: ViewerMoreSheet(
                file: file,
                hasOutline: true,
                onOutline: () {
                  outlineTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.list_alt_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.list_alt_rounded));
      await tester.pump();

      expect(outlineTapped, isTrue);
    });

    testWidgets('renders Go to Page option when onGoToPage is provided', (tester) async {
      final file = _testDocFile(name: 'doc.pdf', path: '/tmp/doc.pdf', category: FileCategory.pdf);
      bool goToPageTapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: ViewerMoreSheet(
                file: file,
                onGoToPage: () {
                  goToPageTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.format_list_numbered_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.format_list_numbered_rounded));
      await tester.pump();

      expect(goToPageTapped, isTrue);
    });
  });
}
