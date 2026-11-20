import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/tools/create_pdf/create_pdf_screen.dart';
import 'package:docview/features/tools/create_pdf/create_pdf_service.dart';
import 'package:docview/features/tools/create_pdf/paper_template.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockCreatePdfService implements CreatePdfService {
  _MockCreatePdfService({this.shouldFail = false});

  final bool shouldFail;
  PaperTemplate? lastTemplate;
  PaperPageSize? lastPageSize;
  PaperOrientation? lastOrientation;
  PaperColorSwatch? lastSwatch;
  int? lastPageCount;
  String? lastFileName;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<DocFile> generateTemplatePdf({
    required PaperTemplate template,
    required PaperPageSize pageSize,
    required PaperOrientation orientation,
    required PaperColorSwatch colorSwatch,
    required int pageCount,
    required String fileName,
    void Function(int done, int total)? onProgress,
    bool compress = true,
  }) async {
    if (shouldFail) {
      throw const CreatePdfException(
        CreatePdfErrorReason.generationFailed,
        details: 'Simulated generation error',
      );
    }

    lastTemplate = template;
    lastPageSize = pageSize;
    lastOrientation = orientation;
    lastSwatch = colorSwatch;
    lastPageCount = pageCount;
    lastFileName = fileName;

    onProgress?.call(1, pageCount);

    return DocFile(
      path: '/mock/path/$fileName.pdf',
      name: '$fileName.pdf',
      extension: 'pdf',
      sizeBytes: 1024 * 50,
      modified: DateTime(2026, 11, 20),
      category: FileCategory.pdf,
      isBookmarked: false,
      isImported: true,
    );
  }
}

void main() {
  Widget buildTestApp({
    required CreatePdfService service,
  }) {
    return ProviderScope(
      overrides: [
        createPdfServiceProvider.overrideWithValue(service),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CreatePdfScreen(),
      ),
    );
  }

  group('CreatePdfScreen Widget & Interaction Tests', () {
    testWidgets('Renders all controls, sections, and default states', (tester) async {
      tester.view.physicalSize = const Size(393 * 2, 852 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final service = _MockCreatePdfService();
      await tester.pumpWidget(buildTestApp(service: service));
      await tester.pumpAndSettle();

      // Screen title
      expect(find.text('Create PDF'), findsWidgets);

      // Section headers
      expect(find.text('TEMPLATE'), findsOneWidget);
      expect(find.text('PAGE SIZE'), findsOneWidget);
      expect(find.text('ORIENTATION'), findsOneWidget);
      expect(find.text('PAGE COLOR'), findsOneWidget);
      expect(find.text('PAGE COUNT'), findsOneWidget);

      // All 7 template cards
      for (final t in PaperTemplate.values) {
        expect(find.byKey(Key('template_card_${t.name}')), findsOneWidget);
      }

      // Default page size chips
      expect(find.byKey(const Key('page_size_a4')), findsOneWidget);
      expect(find.byKey(const Key('page_size_letter')), findsOneWidget);

      // Orientation segment
      expect(find.text('Portrait'), findsOneWidget);
      expect(find.text('Landscape'), findsOneWidget);

      // Page count stepper
      expect(find.text('1 page'), findsWidgets);

      // Create PDF primary CTA button
      expect(find.byKey(const Key('create_pdf_submit_button')), findsOneWidget);
    });

    testWidgets('Selects Cornell template and Landscape orientation', (tester) async {
      tester.view.physicalSize = const Size(393 * 2, 852 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final service = _MockCreatePdfService();
      await tester.pumpWidget(buildTestApp(service: service));
      await tester.pumpAndSettle();

      // Tap Cornell card
      await tester.ensureVisible(find.byKey(const Key('template_card_cornell')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('template_card_cornell')));
      await tester.pumpAndSettle();

      // Tap Landscape segment
      await tester.ensureVisible(find.text('Landscape'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Landscape'));
      await tester.pumpAndSettle();

      // Tap Increment page count
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('2 pages'), findsWidgets);

      // Tap Create PDF submit button
      await tester.tap(find.byKey(const Key('create_pdf_submit_button')));
      await tester.pumpAndSettle();

      // Verify service was invoked with chosen parameters
      expect(service.lastTemplate, PaperTemplate.cornell);
      expect(service.lastOrientation, PaperOrientation.landscape);
      expect(service.lastPageCount, 2);

      // Result sheet appears
      expect(find.text('Open'), findsOneWidget);
    });

    testWidgets('Displays error sheet when generation fails and allows retry', (tester) async {
      tester.view.physicalSize = const Size(393 * 2, 852 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final service = _MockCreatePdfService(shouldFail: true);
      await tester.pumpWidget(buildTestApp(service: service));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('create_pdf_submit_button')));
      await tester.pumpAndSettle();

      // Error sheet shown
      expect(find.text('Unable to Create PDF'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
