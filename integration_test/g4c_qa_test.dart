import 'dart:io';
import 'dart:ui' as ui;

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/trash_item.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/tools/recycle_bin/recycle_bin_screen.dart';
import 'package:docview/features/tools/recycle_bin/widgets/trash_details_sheet.dart';
import 'package:docview/features/tools/recycle_bin/widgets/trash_options_sheet.dart';
import 'package:docview/features/tools/tools_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> _captureToSdcard(GlobalKey key, String fileName) async {
  try {
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      final image = await boundary.toImage(pixelRatio: 1.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final bytes = byteData.buffer.asUint8List();
        final file = File('/sdcard/Download/$fileName');
        await file.writeAsBytes(bytes);
        debugPrint('[G4C_QA] Saved screenshot to ${file.path} (${bytes.length} bytes)');
      }
    }
  } catch (e) {
    debugPrint('[G4C_QA] Error capturing screenshot $fileName: $e');
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final nowMs = DateTime.now().millisecondsSinceEpoch;
  final sampleItem1 = TrashItem(
    id: 'trash_doc_1',
    trashPath: '/mock/app_support/recycle_bin/trash_doc_1.pdf',
    originalPath: '/storage/emulated/0/Download/Quarterly_Financial_Report_2026.pdf',
    originalName: 'Quarterly_Financial_Report_2026.pdf',
    extension: 'pdf',
    sizeBytes: 3450000,
    category: FileCategory.pdf,
    originalModifiedMs: nowMs - 5000000,
    deletedMs: nowMs - 86400000 * 2,
    expiresMs: nowMs + 86400000 * 28, // 28d left
    wasBookmarked: true,
    wasImported: false,
  );

  final sampleItem2 = TrashItem(
    id: 'trash_doc_2',
    trashPath: '/mock/app_support/recycle_bin/trash_doc_2.docx',
    originalPath: '/storage/emulated/0/Documents/Contract_Agreement_Vendor_v2.docx',
    originalName: 'Contract_Agreement_Vendor_v2.docx',
    extension: 'docx',
    sizeBytes: 1240000,
    category: FileCategory.word,
    originalModifiedMs: nowMs - 12000000,
    deletedMs: nowMs - 86400000 * 28,
    expiresMs: nowMs + 86400000 * 2, // 2d left (expiring soon)
    wasBookmarked: false,
    wasImported: false,
  );

  final sampleItem3 = TrashItem(
    id: 'trash_doc_3',
    trashPath: '/mock/app_support/recycle_bin/trash_doc_3.xlsx',
    originalPath: '/storage/emulated/0/Download/Annual_Budget_Forecast_2027.xlsx',
    originalName: 'Annual_Budget_Forecast_2027.xlsx',
    extension: 'xlsx',
    sizeBytes: 850000,
    category: FileCategory.excel,
    originalModifiedMs: nowMs - 3000000,
    deletedMs: nowMs - 86400000 * 15,
    expiresMs: nowMs + 86400000 * 15, // 15d left
    wasBookmarked: false,
    wasImported: true,
  );

  group('G4c QA Screenshots', () {
    testWidgets('1. Capture Tools tab showing Recycle bin in Others', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: [
            createdFilesProvider.overrideWith((ref) => Future.value([])),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: RepaintBoundary(
              key: key,
              child: const ToolsScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('tool_recycle_bin')), findsOneWidget);
      await _captureToSdcard(key, 'tools_tab_recycle_bin.png');
    });

    testWidgets('2. Capture Recycle bin screen: empty state', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: [
            trashItemsProvider.overrideWith((ref) => Future.value([])),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: RepaintBoundary(
              key: key,
              child: const RecycleBinScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _captureToSdcard(key, 'recycle_bin_empty.png');
    });

    testWidgets('3. Capture Recycle bin screen: non-empty list', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: [
            trashItemsProvider.overrideWith(
              (ref) => Future.value([sampleItem1, sampleItem2, sampleItem3]),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: RepaintBoundary(
              key: key,
              child: const RecycleBinScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _captureToSdcard(key, 'recycle_bin_list.png');
    });

    testWidgets('4. Capture TrashOptionsSheet', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: RepaintBoundary(
                key: key,
                child: Center(
                  child: TrashOptionsSheet(item: sampleItem1),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _captureToSdcard(key, 'trash_options_sheet.png');
    });

    testWidgets('5. Capture TrashDetailsSheet', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: RepaintBoundary(
                key: key,
                child: Center(
                  child: TrashDetailsSheet(item: sampleItem1),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _captureToSdcard(key, 'trash_details_sheet.png');
    });

    testWidgets('6. Capture Recycle bin selection mode', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: [
            trashItemsProvider.overrideWith(
              (ref) => Future.value([sampleItem1, sampleItem2, sampleItem3]),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: RepaintBoundary(
              key: key,
              child: const RecycleBinScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.longPress(find.text(sampleItem1.originalName));
      await tester.pumpAndSettle();
      await _captureToSdcard(key, 'recycle_bin_selection.png');
    });

    testWidgets('7. Capture Empty bin confirmation dialog', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: [
            trashItemsProvider.overrideWith(
              (ref) => Future.value([sampleItem1, sampleItem2]),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: RepaintBoundary(
              key: key,
              child: const RecycleBinScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Empty bin'));
      await tester.pumpAndSettle();
      await _captureToSdcard(key, 'recycle_bin_empty_dialog.png');
    });
  });
}
