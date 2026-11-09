import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/doc_view_tokens.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/viewer/widgets/pdf_goto_page_dialog.dart';
import 'package:docview/features/viewer/widgets/pdf_pages_sheet.dart';
import 'package:docview/features/viewer/widgets/pdf_password_dialog.dart';
import 'package:docview/shared/widgets/tiles/doc_folded_icon.dart';
import 'package:docview/shared/widgets/tiles/file_type_badge.dart';

Widget _wrapWithTokens(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: ThemeData.light().copyWith(
        extensions: const [DocViewTokens.light],
      ),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final dummyFile = DocFile(
    path: '/mock/test_document.pdf',
    name: 'test_document.pdf',
    extension: 'pdf',
    sizeBytes: 1024 * 1024 * 2,
    modified: DateTime(2026, 11, 9),
    category: FileCategory.pdf,
  );

  group('PDF Viewer Widgets & Dialogs', () {
    testWidgets('PdfPasswordDialog renders lock icon, eye toggle, and actions',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTokens(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PdfPasswordDialog.show(context),
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('This PDF is password-protected'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Unlock'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'secret123');
      await tester.pump();

      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();

      expect(find.text('Password required'), findsNothing);
    });

    testWidgets('PdfGoToPageDialog enforces inline validation', (tester) async {
      await tester.pumpWidget(
        _wrapWithTokens(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => PdfGoToPageDialog.show(
                  context,
                  currentPage: 5,
                  pageCount: 50,
                ),
                child: const Text('Open GoTo'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open GoTo'));
      await tester.pumpAndSettle();

      expect(find.text('Go to page'), findsOneWidget);
      expect(find.text('1 — 50'), findsOneWidget);

      // Enter an invalid page > 50
      await tester.enterText(find.byType(TextField), '99');
      await tester.pump();

      await tester.tap(find.text('Go'));
      await tester.pump();

      expect(find.text('Enter a page between 1 and 50'), findsNWidgets(2));

      // Enter a valid page
      await tester.enterText(find.byType(TextField), '24');
      await tester.pump();

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.text('Go to page'), findsNothing);
    });

    testWidgets('PdfPagesSheet renders number tiles and highlights current page',
        (tester) async {
      int? selectedPage;

      await tester.pumpWidget(
        _wrapWithTokens(
          PdfPagesSheet(
            pageCount: 10,
            currentPage: 3,
            onPageSelected: (p) => selectedPage = p,
          ),
        ),
      );

      expect(find.text('Pages'), findsOneWidget);
      expect(find.text('10 pages in document'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      // Tap on page 7
      await tester.tap(find.text('7'));
      await tester.pump();

      expect(selectedPage, 7);
    });
  });

  group('DocFoldedIcon & Format Badges', () {
    testWidgets('DocFoldedIcon renders category label with folded flap',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTokens(
          const Row(
            children: [
              DocFoldedIcon(
                category: FileCategory.pdf,
                width: 40,
                height: 48,
              ),
              DocFoldedIcon(
                category: FileCategory.word,
                width: 40,
                height: 48,
              ),
              DocFoldedIcon(
                category: FileCategory.excel,
                width: 40,
                height: 48,
              ),
              DocFoldedIcon(
                category: FileCategory.ppt,
                width: 40,
                height: 48,
              ),
              DocFoldedIcon(
                category: FileCategory.txt,
                width: 40,
                height: 48,
              ),
            ],
          ),
        ),
      );

      expect(find.text('PDF'), findsOneWidget);
      expect(find.text('W'), findsOneWidget);
      expect(find.text('X'), findsOneWidget);
      expect(find.text('PPT'), findsOneWidget);
      expect(find.text('TXT'), findsOneWidget);
    });

    testWidgets('FileTypeBadge renders large folded badge', (tester) async {
      await tester.pumpWidget(
        _wrapWithTokens(
          FileTypeBadge(
            category: dummyFile.category,
            size: BadgeSize.large,
          ),
        ),
      );

      expect(find.byType(DocFoldedIcon), findsOneWidget);
      expect(find.text('PDF'), findsOneWidget);
    });
  });
}
