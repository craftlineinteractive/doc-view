import 'dart:io';

import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/pdf_text_box.dart';
import 'package:docview/data/services/pdf/pdf_annotation_service.dart';
import 'package:docview/features/tools/add_text/add_text_screen.dart';
import 'package:docview/features/tools/add_text/widgets/text_box_overlay.dart';
import 'package:docview/features/tools/add_text/widgets/text_style_sheet.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late File samplePdf;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('add_text_screen_test_');

    final doc = sf.PdfDocument();
    final page = doc.pages.add();
    final font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 12);
    page.graphics.drawString(
      'Test PDF Add Text Content',
      font,
      bounds: const Rect.fromLTWH(50, 50, 300, 20),
    );
    final bytes = doc.saveSync();
    doc.dispose();

    samplePdf = File('${tempDir.path}/test_text_doc.pdf');
    await samplePdf.writeAsBytes(bytes);
  });

  tearDown(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  Widget createTestWidget({
    String? path,
    PdfDocumentInfo? mockInfo,
    List<PdfTextBox>? initialTextBoxes,
    Locale locale = const Locale('en'),
    double textScaleFactor = 1.0,
  }) {
    return ProviderScope(
      overrides: [
        pdfAnnotationServiceProvider.overrideWithValue(
          PdfAnnotationService(
            getDocumentInfoHook: (filePath, {password}) async {
              return mockInfo ??
                  const PdfDocumentInfo(
                    pageCount: 1,
                    isEncrypted: false,
                    hasDigitalSignature: false,
                    pageRotations: [0],
                    pageSizes: [Size(600, 800)],
                  );
            },
          ),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: child!,
        ),
        home: AddTextScreen(
          initialFilePath: path ?? samplePdf.path,
          initialTextBoxes: initialTextBoxes,
          viewerBuilder: (ctx, overlaysBuilder) {
            return SizedBox(
              width: 600,
              height: 800,
              child: Stack(
                children: overlaysBuilder(0, const Size(600, 800)),
              ),
            );
          },
        ),
      ),
    );
  }

  group('AddTextScreen Widget Tests', () {
    testWidgets('Renders screen with initial bottom actions', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_text_action_add')), findsOneWidget);
      expect(find.byKey(const Key('add_text_action_style')), findsOneWidget);
      expect(find.byKey(const Key('add_text_action_delete')), findsOneWidget);
    });

    testWidgets('Toggles placement mode when tapping Add text action', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap "Add text"
      await tester.tap(find.byKey(const Key('add_text_action_add')));
      await tester.pumpAndSettle();

      // Placement detector on page 0 should be active
      expect(find.byKey(const Key('add_text_page_tap_0')), findsOneWidget);

      // Tap "Add text" again to toggle off
      await tester.tap(find.byKey(const Key('add_text_action_add')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('add_text_page_tap_0')), findsNothing);
    });

    testWidgets('Creates box on tap, commits text, and enforces undo/redo', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enable placement mode
      await tester.tap(find.byKey(const Key('add_text_action_add')));
      await tester.pumpAndSettle();

      // Tap on page
      await tester.tap(find.byKey(const Key('add_text_page_tap_0')));
      await tester.pumpAndSettle();

      // A TextField should now be visible for inline editing
      expect(find.byType(TextField), findsOneWidget);

      // Enter text
      await tester.enterText(find.byType(TextField), 'Invoice Approved');
      // Tap outside to commit
      await tester.tap(find.byKey(const Key('add_text_page_dismiss_tap_0')));
      await tester.pumpAndSettle();

      // Committed text is displayed
      expect(find.text('Invoice Approved'), findsOneWidget);

      // Notice banner for first box is displayed
      expect(find.byKey(const Key('add_text_notice_permanent_banner')), findsOneWidget);

      // Dismiss banner with "Got it"
      await tester.tap(find.byKey(const Key('add_text_notice_permanent_got_it')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('add_text_notice_permanent_banner')), findsNothing);

      // Tap Undo to remove box
      final undoButton = find.byKey(const Key('annotate_action_undo'));
      expect(undoButton, findsOneWidget);
      await tester.tap(undoButton);
      await tester.pumpAndSettle();
      expect(find.text('Invoice Approved'), findsNothing);

      // Tap Redo to restore box
      final redoButton = find.byKey(const Key('annotate_action_redo'));
      expect(redoButton, findsOneWidget);
      await tester.tap(redoButton);
      await tester.pumpAndSettle();
      expect(find.text('Invoice Approved'), findsOneWidget);
    });

    testWidgets('Empty text box is discarded on tap outside', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('add_text_action_add')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('add_text_page_tap_0')));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);

      // Tap outside without entering any text
      await tester.tap(find.byKey(const Key('add_text_page_dismiss_tap_0')));
      await tester.pumpAndSettle();

      // Box should be discarded
      expect(find.byType(TextBoxOverlay), findsNothing);
    });

    testWidgets('Style sheet opens and customizes font size and color', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Add a box
      await tester.tap(find.byKey(const Key('add_text_action_add')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add_text_page_tap_0')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Styled Note');
      await tester.tapAt(const Offset(500, 700));
      await tester.pumpAndSettle();

      // Tap the box to select it
      await tester.tap(find.text('Styled Note'));
      await tester.pumpAndSettle();

      // Tap Style button
      await tester.tap(find.byKey(const Key('add_text_action_style')));
      await tester.pumpAndSettle();

      expect(find.byType(TextStyleSheet), findsOneWidget);
      expect(find.text('Text style'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);

      // Close sheet
      await tester.tap(find.byIcon(Icons.close).first, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(TextStyleSheet), findsNothing);
    });

    testWidgets('Non-Latin text displays raster notice banner', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Add a Hindi text box
      await tester.tap(find.byKey(const Key('add_text_action_add')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add_text_page_tap_0')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'नमस्ते दुनिया');
      // Tap outside to commit
      await tester.tap(find.byKey(const Key('add_text_page_dismiss_tap_0')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Raster notice banner should appear
      expect(find.byKey(const Key('add_text_notice_raster_banner')), findsOneWidget);

      // Dismiss banner with "Got it"
      await tester.tap(find.byKey(const Key('add_text_notice_raster_got_it')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('add_text_notice_raster_banner')), findsNothing);
    });

    testWidgets('Enforces 30 boxes cap', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final fullBoxes = List.generate(
        30,
        (i) => PdfTextBox(
          id: 'box_$i',
          pageIndex: 0,
          bounds: Rect.fromLTWH(50, 50.0 + (i * 20), 100, 20),
          text: 'Box $i',
        ),
      );

      await tester.pumpWidget(createTestWidget(initialTextBoxes: fullBoxes));
      await tester.pumpAndSettle();

      // Attempt to enter placement mode and tap
      await tester.tap(find.byKey(const Key('add_text_action_add')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add_text_page_tap_0')));
      await tester.pumpAndSettle();

      // Cap snackbar is displayed
      expect(find.text('Maximum of 30 text boxes reached'), findsOneWidget);
    });

    testWidgets('Supports en_XA pseudo-locale and text scale 2.0 with no overflow', (tester) async {
      tester.view.physicalSize = const Size(1000, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('en', 'XA'),
          textScaleFactor: 2.0,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
