import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/directories/directories_screen.dart';
import 'package:docview/features/files/widgets/file_details_sheet.dart';
import 'package:docview/features/files/widgets/file_options_sheet.dart';
import 'package:docview/features/home/home_screen.dart';
import 'package:docview/features/onboarding/onboarding_screen.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/search/search_screen.dart';
import 'package:docview/features/settings/faq_screen.dart';
import 'package:docview/features/settings/scan_settings_screen.dart';
import 'package:docview/features/settings/widgets/theme_selection_sheet.dart';
import 'package:docview/features/tools/created_documents_screen.dart';
import 'package:docview/features/tools/image_list_editor_screen.dart';
import 'package:docview/features/tools/merge_screen.dart';
import 'package:docview/features/tools/services/pdf_page_count_service.dart';
import 'package:docview/features/tools/split_screen.dart';
import 'package:docview/features/tools/widgets/merge_pdf_picker_screen.dart';
import 'package:docview/features/tools/widgets/split_picker_screen.dart';
import 'package:docview/features/tools/widgets/tool_error_sheet.dart';
import 'package:docview/features/tools/widgets/tool_progress_dialog.dart';
import 'package:docview/features/tools/widgets/tool_result_sheet.dart';
import 'package:docview/features/viewer/widgets/pdf_goto_page_dialog.dart';
import 'package:docview/features/viewer/widgets/pdf_password_dialog.dart';
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
      // G1b surviving screens
      'DirectoriesScreen': () => const DirectoriesScreen(),
      'FaqScreen': () => const FaqScreen(),
      'ScanSettingsScreen': () => const ScanSettingsScreen(),
      'CreatedDocumentsScreen': () => const CreatedDocumentsScreen(),
      'ImageListEditorScreen': () => const ImageListEditorScreen(
            initialImagePaths: [],
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
      'ThemeSelectionSheet': () => const Scaffold(
            body: SingleChildScrollView(
              child: ThemeSelectionSheet(),
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
