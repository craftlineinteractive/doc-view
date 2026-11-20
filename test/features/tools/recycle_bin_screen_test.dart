import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/models/trash_item.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/tools/recycle_bin/recycle_bin_screen.dart';
import 'package:docview/features/tools/recycle_bin/widgets/trash_details_sheet.dart';
import 'package:docview/features/tools/recycle_bin/widgets/trash_options_sheet.dart';
import 'package:docview/shared/widgets/navigation/doc_app_bar.dart';
import 'package:docview/shared/widgets/status/doc_status_widgets.dart';
import 'package:docview/shared/widgets/tiles/file_and_folder_rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  final nowMs = DateTime.now().millisecondsSinceEpoch;
  final sampleItem1 = TrashItem(
    id: '1',
    trashPath: '/mock/support/recycle_bin/doc1.pdf',
    originalPath: '/mock/storage/doc1.pdf',
    originalName: 'doc1.pdf',
    extension: 'pdf',
    sizeBytes: 1024 * 1024,
    category: FileCategory.pdf,
    originalModifiedMs: nowMs - 1000000,
    deletedMs: nowMs - 86400000 * 2,
    expiresMs: nowMs + 86400000 * 28, // 28 days left
    wasBookmarked: false,
    wasImported: false,
  );

  final sampleItemExpiringSoon = TrashItem(
    id: '2',
    trashPath: '/mock/support/recycle_bin/doc2.pdf',
    originalPath: '/mock/storage/doc2.pdf',
    originalName: 'doc2.pdf',
    extension: 'pdf',
    sizeBytes: 2048 * 1024,
    category: FileCategory.pdf,
    originalModifiedMs: nowMs - 2000000,
    deletedMs: nowMs - 86400000 * 28,
    expiresMs: nowMs + 86400000 * 2, // 2 days left
    wasBookmarked: false,
    wasImported: false,
  );

  group('RecycleBinScreen Widget Tests', () {
    testWidgets('Renders empty state when trash is empty', (tester) async {
      await tester.pumpApp(
        const RecycleBinScreen(),
        overrides: [
          trashItemsProvider.overrideWith((ref) async => []),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(DocEmptyState), findsOneWidget);
      expect(find.text('Recycle bin is empty'), findsOneWidget);
      expect(find.text('Files moved to Recycle bin will stay here for 30 days before being permanently deleted.'), findsOneWidget);
      expect(find.text('Empty bin'), findsNothing);
    });

    testWidgets('Renders items with days-left badges and Empty bin action', (tester) async {
      await tester.pumpApp(
        const RecycleBinScreen(),
        overrides: [
          trashItemsProvider.overrideWith((ref) async => [sampleItem1, sampleItemExpiringSoon]),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(DocEmptyState), findsNothing);
      expect(find.byType(FileRow), findsNWidgets(2));
      expect(find.text('doc1.pdf'), findsOneWidget);
      expect(find.text('doc2.pdf'), findsOneWidget);
      expect(find.text('Empty bin'), findsOneWidget);

      // Verify days left text
      expect(find.text('28 days left'), findsOneWidget);
      expect(find.text('2 days left'), findsOneWidget);
    });

    testWidgets('Dismisses info banner on close button tap', (tester) async {
      await tester.pumpApp(
        const RecycleBinScreen(),
        overrides: [
          trashItemsProvider.overrideWith((ref) async => [sampleItem1]),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(InfoBanner), findsOneWidget);
      final closeButton = find.byTooltip('Close');
      expect(closeButton, findsOneWidget);

      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      expect(find.byType(InfoBanner), findsNothing);
    });

    testWidgets('Tapping item opens TrashOptionsSheet', (tester) async {
      await tester.pumpApp(
        const RecycleBinScreen(),
        overrides: [
          trashItemsProvider.overrideWith((ref) async => [sampleItem1]),
        ],
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('doc1.pdf'));
      await tester.pumpAndSettle();

      expect(find.byType(TrashOptionsSheet), findsOneWidget);
      expect(find.text('Restore'), findsOneWidget);
      expect(find.text('Delete forever'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
    });

    testWidgets('Long press enters selection mode, select all and cancel work', (tester) async {
      await tester.pumpApp(
        const RecycleBinScreen(),
        overrides: [
          trashItemsProvider.overrideWith((ref) async => [sampleItem1, sampleItemExpiringSoon]),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byType(DocSelectionAppBar), findsNothing);

      // Long press first item
      await tester.longPress(find.text('doc1.pdf'));
      await tester.pumpAndSettle();

      expect(find.byType(DocSelectionAppBar), findsOneWidget);
      expect(find.text('1 selected'), findsOneWidget);

      // Bottom bar is visible
      expect(find.text('Restore'), findsOneWidget);
      expect(find.text('Delete forever'), findsOneWidget);

      // Tap Select All
      await tester.tap(find.text('Select all'));
      await tester.pumpAndSettle();

      expect(find.text('2 selected'), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.byTooltip('Cancel selection'));
      await tester.pumpAndSettle();

      expect(find.byType(DocSelectionAppBar), findsNothing);
      expect(find.byType(DocSubAppBar), findsOneWidget);
    });

    testWidgets('Empty bin button shows confirmation dialog', (tester) async {
      await tester.pumpApp(
        const RecycleBinScreen(),
        overrides: [
          trashItemsProvider.overrideWith((ref) async => [sampleItem1]),
        ],
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Empty bin'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Empty Recycle bin?'), findsOneWidget);
      expect(find.text('Delete all 1 file forever? This cannot be undone.'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('TrashDetailsSheet displays metadata accurately', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: TrashDetailsSheet(item: sampleItem1),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Original location'), findsOneWidget);
      expect(find.text('Date deleted'), findsOneWidget);
      expect(find.text('Expires in'), findsOneWidget);
      expect(find.text('doc1.pdf'), findsOneWidget);
      expect(find.text('/mock/storage/doc1.pdf'), findsOneWidget);
      expect(find.text('28 days left'), findsOneWidget);
    });
  });
}
