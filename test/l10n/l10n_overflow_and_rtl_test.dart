import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/models/trash_item.dart';
import 'package:docview/features/directories/directories_screen.dart';
import 'package:docview/features/files/widgets/file_details_sheet.dart';
import 'package:docview/features/files/widgets/file_options_sheet.dart';
import 'package:docview/features/home/home_screen.dart';
import 'package:docview/features/onboarding/onboarding_screen.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/search/search_screen.dart';
import 'package:docview/features/settings/faq_screen.dart';
import 'package:docview/features/settings/language_screen.dart';
import 'package:docview/features/settings/scan_settings_screen.dart';
import 'package:docview/features/settings/settings_screen.dart';
import 'package:docview/features/settings/widgets/rate_us_sheet.dart';
import 'package:docview/features/settings/widgets/theme_selection_sheet.dart';
import 'package:docview/features/tools/create_pdf/create_pdf_screen.dart';
import 'package:docview/features/tools/created_documents_screen.dart';
import 'package:docview/features/tools/image_list_editor_screen.dart';
import 'package:docview/features/tools/merge_screen.dart';
import 'package:docview/features/tools/recycle_bin/recycle_bin_screen.dart';
import 'package:docview/features/tools/recycle_bin/widgets/trash_details_sheet.dart';
import 'package:docview/features/tools/recycle_bin/widgets/trash_options_sheet.dart';
import 'package:docview/features/tools/services/pdf_page_count_service.dart';
import 'package:docview/features/tools/split_screen.dart';
import 'package:docview/features/tools/tools_screen.dart';
import 'package:docview/features/tools/widgets/merge_pdf_picker_screen.dart';
import 'package:docview/features/tools/widgets/split_picker_screen.dart';
import 'package:docview/features/tools/widgets/tool_error_sheet.dart';
import 'package:docview/features/tools/widgets/tool_file_picker_screen.dart';
import 'package:docview/features/tools/widgets/tool_progress_dialog.dart';
import 'package:docview/features/tools/widgets/tool_result_sheet.dart';
import 'package:docview/features/viewer/pages_screen.dart';
import 'package:docview/features/viewer/widgets/office_outline_sheet.dart';
import 'package:docview/features/viewer/widgets/pdf_goto_page_dialog.dart';
import 'package:docview/features/viewer/widgets/pdf_more_sheet.dart';
import 'package:docview/features/viewer/widgets/pdf_pages_sheet.dart';
import 'package:docview/features/viewer/widgets/pdf_password_dialog.dart';
import 'package:docview/data/models/spreadsheet_data.dart';
import 'package:docview/data/services/pdf/pdf_page_edit_service.dart';
import 'package:docview/shared/widgets/reader/reader_bottom_row.dart';
import 'package:docview/shared/widgets/reader/reader_search_bar.dart';
import 'package:docview/shared/widgets/spreadsheet/formula_bar.dart';
import 'package:docview/shared/widgets/spreadsheet/sheet_tab_bar.dart';
import 'package:docview/shared/widgets/spreadsheet/spreadsheet_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

void main() {
  final sampleDoc = DocFile(
    id: 1,
    path: '/storage/emulated/0/Download/Sample_Contract_2026.pdf',
    name: 'Sample_Contract_2026.pdf',
    extension: 'pdf',
    sizeBytes: 2048576,
    modified: DateTime(2026, 11, 15, 14, 30),
    category: FileCategory.pdf,
  );

  final sampleDoc2 = DocFile(
    id: 2,
    path: '/storage/emulated/0/Download/Quarterly_Report_2026.pdf',
    name: 'Quarterly_Report_2026.pdf',
    extension: 'pdf',
    sizeBytes: 1024000,
    modified: DateTime(2026, 11, 14, 10, 15),
    category: FileCategory.pdf,
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'recent_searches': ['financial report', 'invoice nov'],
    });
    PdfPageCountService.instance.reset();
    PdfPageCountService.instance.setCachedCountForTesting(sampleDoc.path, 12);
    PdfPageCountService.instance.setCachedCountForTesting(sampleDoc2.path, 8);
  });

  final testOverrides = [
    categoryCountsProvider.overrideWith((ref) async => {
          FileCategory.pdf: 14,
          FileCategory.word: 8,
          FileCategory.excel: 3,
          FileCategory.ppt: 2,
          FileCategory.txt: 1,
          FileCategory.image: 25,
        }),
    recentsProvider.overrideWith((ref) async => [sampleDoc]),
    bookmarksProvider.overrideWith((ref) async => [sampleDoc]),
    searchResultsProvider.overrideWith((ref) async => [sampleDoc]),
    filesProvider(FileCategory.pdf)
        .overrideWith((ref) async => [sampleDoc, sampleDoc2]),
    createdFilesProvider.overrideWith((ref) async => [sampleDoc]),
    trashItemsProvider.overrideWith((ref) async => [
          TrashItem(
            id: '1',
            trashPath: '/mock/support/recycle_bin/sample.pdf',
            originalPath: '/mock/storage/sample.pdf',
            originalName: 'Sample_Contract_2026.pdf',
            extension: 'pdf',
            sizeBytes: 2048576,
            category: FileCategory.pdf,
            originalModifiedMs: 1731661800000,
            deletedMs: 1732000000000,
            expiresMs: 1734592000000,
            wasBookmarked: false,
            wasImported: false,
          ),
        ]),
  ];

  group('L10n & RTL Overflow Testing Harness', () {
    final configurations =
        <String, ({Locale locale, TextDirection direction, double scale})>{
      'en_LTR_1.0x': (
        locale: const Locale('en'),
        direction: TextDirection.ltr,
        scale: 1.0,
      ),
      'en_LTR_2.0x': (
        locale: const Locale('en'),
        direction: TextDirection.ltr,
        scale: 2.0,
      ),
      'pseudo_en_XA_LTR_1.0x': (
        locale: const Locale('en', 'XA'),
        direction: TextDirection.ltr,
        scale: 1.0,
      ),
      'pseudo_en_XA_LTR_2.0x': (
        locale: const Locale('en', 'XA'),
        direction: TextDirection.ltr,
        scale: 2.0,
      ),
      'pseudo_en_XA_RTL_1.0x': (
        locale: const Locale('en', 'XA'),
        direction: TextDirection.rtl,
        scale: 1.0,
      ),
      'pseudo_en_XA_RTL_2.0x': (
        locale: const Locale('en', 'XA'),
        direction: TextDirection.rtl,
        scale: 2.0,
      ),
    };

    final screens = <String, Widget Function()>{
      // G1a surviving screens
      'HomeScreen': () => const HomeScreen(),
      'SearchScreen': () => const SearchScreen(),
      'OnboardingScreen': () => const OnboardingScreen(),
      // G1b & G2 surviving screens
      'DirectoriesScreen': () => const DirectoriesScreen(),
      'SettingsScreen': () => const SettingsScreen(
            isReleaseOverride: false,
            premiumEnabledOverride: true,
            widgetsEnabledOverride: true,
            storeShareUrlOverride: 'https://example.com/share',
            termsOfUseUrlOverride: 'https://example.com/terms',
            privacyPolicyUrlOverride: 'https://example.com/privacy',
          ),
      'LanguageScreen': () => const LanguageScreen(isReleaseOverride: false),
      'FaqScreen': () => const FaqScreen(),
      'FaqScreenFromRating': () => const FaqScreen(
            fromRating: true,
            supportEmailOverride: 'support@docview.app',
          ),
      'ScanSettingsScreen': () => const ScanSettingsScreen(),
      'CreatedDocumentsScreen': () => const CreatedDocumentsScreen(),
      'RecycleBinScreen': () => const RecycleBinScreen(),
      'ImageListEditorScreen': () => const ImageListEditorScreen(
            initialImagePaths: [],
          ),
      'CreatePdfScreen': () => const CreatePdfScreen(),
      'ToolsScreen': () => const ToolsScreen(),
      'ToolFilePickerScreen': () => const ToolFilePickerScreen(
            title: 'Select PDF',
            allowMultiple: false,
          ),
      'ToolFilePickerScreenMulti': () => const ToolFilePickerScreen(
            title: 'Select PDF Files',
            allowMultiple: true,
          ),
      'MergeScreen': () => MergeScreen(initialFiles: [sampleDoc, sampleDoc2]),
      'SplitScreen': () => SplitScreen(file: sampleDoc),
      'MergePdfPickerScreen': () => const MergePdfPickerScreen(),
      'SplitPickerScreen': () => const SplitPickerScreen(),
      // G1b surviving sheets & dialogs
      'FileDetailsSheet': () => Scaffold(
            body: SingleChildScrollView(
              child: FileDetailsSheet(file: sampleDoc),
            ),
          ),
      'FileOptionsSheet': () => Scaffold(
            body: SingleChildScrollView(
              child: FileOptionsSheet(file: sampleDoc),
            ),
          ),
      'TrashDetailsSheet': () => Scaffold(
            body: SingleChildScrollView(
              child: TrashDetailsSheet(
                item: TrashItem(
                  id: '1',
                  trashPath: '/mock/support/recycle_bin/sample.pdf',
                  originalPath: '/mock/storage/sample.pdf',
                  originalName: 'Sample_Contract_2026.pdf',
                  extension: 'pdf',
                  sizeBytes: 2048576,
                  category: FileCategory.pdf,
                  originalModifiedMs: 1731661800000,
                  deletedMs: 1732000000000,
                  expiresMs: 1734592000000,
                  wasBookmarked: false,
                  wasImported: false,
                ),
              ),
            ),
          ),
      'TrashOptionsSheet': () => Scaffold(
            body: SingleChildScrollView(
              child: TrashOptionsSheet(
                item: TrashItem(
                  id: '1',
                  trashPath: '/mock/support/recycle_bin/sample.pdf',
                  originalPath: '/mock/storage/sample.pdf',
                  originalName: 'Sample_Contract_2026.pdf',
                  extension: 'pdf',
                  sizeBytes: 2048576,
                  category: FileCategory.pdf,
                  originalModifiedMs: 1731661800000,
                  deletedMs: 1732000000000,
                  expiresMs: 1734592000000,
                  wasBookmarked: false,
                  wasImported: false,
                ),
              ),
            ),
          ),
      'ThemeSelectionSheet': () => const Scaffold(
            body: SingleChildScrollView(
              child: ThemeSelectionSheet(),
            ),
          ),
      'RateUsSheet': () => const Scaffold(
            body: SingleChildScrollView(
              child: RateUsSheet(
                storeRateUrlOverride: 'https://example.com/rate',
              ),
            ),
          ),
      'PdfGoToPageDialog': () => const Scaffold(
            body: Center(
              child: PdfGoToPageDialog(currentPage: 1, pageCount: 25),
            ),
          ),
      'PdfPasswordDialog': () => const Scaffold(
            body: Center(
              child: PdfPasswordDialog(isRetry: true),
            ),
          ),
      'ToolProgressDialog': () => Scaffold(
            body: Center(
              child: ToolProgressDialog(
                title: 'Merging PDFs',
                progress: 0.45,
                onCancel: () {},
              ),
            ),
          ),
      'ToolResultSheet': () => Scaffold(
            body: SingleChildScrollView(
              child: ToolResultSheet(files: [sampleDoc]),
            ),
          ),
      'ToolErrorSheet': () => Scaffold(
            body: SingleChildScrollView(
              child: ToolErrorSheet(
                errorMessage: 'Sample error details',
                onRetry: () {},
              ),
            ),
          ),
      // G3a reader & pages screens/components
      'ReaderBottomRow': () => Scaffold(
            bottomNavigationBar: ReaderBottomRow(
              items: [
                ReaderBottomRowItem(
                  icon: Icons.swap_vert_rounded,
                  label: 'Vertical',
                  onTap: () {},
                ),
                ReaderBottomRowItem(
                  icon: Icons.screen_rotation_rounded,
                  label: 'Rotate',
                  onTap: () {},
                ),
                ReaderBottomRowItem(
                  icon: Icons.search_rounded,
                  label: 'Search',
                  onTap: () {},
                ),
                ReaderBottomRowItem(
                  icon: Icons.invert_colors_rounded,
                  label: 'Invert',
                  onTap: () {},
                ),
                ReaderBottomRowItem(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  onTap: () {},
                ),
              ],
            ),
          ),
      'ReaderSearchBar': () => Scaffold(
            appBar: ReaderSearchBar(
              controller: TextEditingController(text: 'Sample Query'),
              totalMatches: 15,
              currentMatchIndex: 2,
              onClose: () {},
            ),
          ),
      'PagesScreen': () => PagesScreen(
            file: sampleDoc,
            initialPages: [
              PdfPageEditSpec(sourcePath: sampleDoc.path, sourcePageIndex: 0),
              PdfPageEditSpec(sourcePath: sampleDoc.path, sourcePageIndex: 1),
              PdfPageEditSpec(sourcePath: sampleDoc.path, sourcePageIndex: 2),
            ],
          ),
      'PdfPagesSheet': () => Scaffold(
            body: SingleChildScrollView(
              child: PdfPagesSheet(
                currentPage: 1,
                pageCount: 12,
                onPageSelected: (_) {},
              ),
            ),
          ),
      'PdfMoreSheet': () => Scaffold(
            body: SingleChildScrollView(
              child: PdfMoreSheet(
                file: sampleDoc,
                pageCount: 12,
              ),
            ),
          ),
      'OfficeOutlineSheet': () => const Scaffold(
            body: SingleChildScrollView(
              child: OfficeOutlineSheet(
                outline: ['Introduction', 'Financial Overview', 'Appendices'],
                currentPosition: 0,
              ),
            ),
          ),
      'FormulaBar': () => Scaffold(
            body: FormulaBar(
              sheet: SheetData(
                name: 'Financials',
                rowCount: 10,
                columnCount: 5,
                cells: {
                  const CellCoordinate(0, 0): const SpreadsheetCell(
                    rawValue: 'Revenue',
                    formula: '=SUM(B2:B10)',
                  ),
                },
              ),
              selection: const SpreadsheetSelection.cell(0, 0),
            ),
          ),
      'SheetTabBar': () => Scaffold(
            body: SheetTabBar(
              sheetNames: const ['Q1 Summary', 'Cash Flow', 'Balance Sheet', 'Appendix Notes'],
              activeIndex: 0,
              onSheetSelected: (_) {},
            ),
          ),
      'SpreadsheetGrid': () => Scaffold(
            body: SpreadsheetGrid(
              sheet: SheetData(
                name: 'Summary',
                rowCount: 5,
                columnCount: 4,
                cells: {
                  const CellCoordinate(0, 0): const SpreadsheetCell(rawValue: 'Total Revenue'),
                  const CellCoordinate(0, 1): const SpreadsheetCell(rawValue: '\$1,234,567.89'),
                },
              ),
              selection: const SpreadsheetSelection.cell(0, 0),
              onSelectionChanged: (_) {},
            ),
          ),
    };

    for (final configEntry in configurations.entries) {
      final configName = configEntry.key;
      final config = configEntry.value;

      for (final screenEntry in screens.entries) {
        final screenName = screenEntry.key;

        testWidgets(
          '$screenName renders without overflow in $configName',
          (tester) async {
            FlutterErrorDetails? overflowError;
            final originalOnError = FlutterError.onError;
            FlutterError.onError = (details) {
              if (details.toString().contains('overflowed by') ||
                  details.toString().contains('RenderFlex overflowed')) {
                overflowError = details;
              }
              originalOnError?.call(details);
            };
            addTearDown(() => FlutterError.onError = originalOnError);

            tester.view.physicalSize = const Size(1080, 2400); // 360x800 @ 3.0 DPR
            tester.view.devicePixelRatio = 3.0;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);

            await tester.pumpApp(
              screenEntry.value(),
              locale: config.locale,
              textDirection: config.direction,
              textScale: config.scale,
              overrides: testOverrides,
            );

            await tester.pumpAndSettle();

            if (screenName == 'RateUsSheet') {
              await tester.tap(find.byKey(const Key('rate_star_3')));
              await tester.pumpAndSettle();
            }

            expect(
              overflowError,
              isNull,
              reason: 'Layout overflow detected in $screenName under $configName: '
                  '${overflowError?.summary}',
            );
          },
        );
      }
    }
  });
}
