import 'dart:io';

import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/pdf_markup.dart';
import 'package:docview/data/services/pdf/pdf_annotation_service.dart';
import 'package:docview/features/tools/annotate/annotate_screen.dart';
import 'package:docview/features/tools/annotate/annotate_session_notifier.dart';
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
    tempDir = Directory.systemTemp.createTempSync('annotate_screen_test_');

    // Generate a simple test PDF
    final doc = sf.PdfDocument();
    final page = doc.pages.add();
    final font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 12);
    page.graphics.drawString('Test PDF Annotate Screen Content', font,
        bounds: const Rect.fromLTWH(50, 50, 300, 20));
    final bytes = doc.saveSync();
    doc.dispose();

    samplePdf = File('${tempDir.path}/test_doc.pdf');
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AnnotateScreen(
          initialFilePath: path ?? samplePdf.path,
        ),
      ),
    );
  }

  Future<void> pumpUntilLoaded(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('AnnotateScreen Widget Tests', () {
    testWidgets('renders top bar, title, disabled undo/redo/save initially', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await pumpUntilLoaded(tester);

      // Top bar elements
      expect(find.byKey(const Key('annotate_back_button')), findsOneWidget);
      expect(find.text('test_doc.pdf'), findsOneWidget);
      expect(find.byKey(const Key('annotate_action_undo')), findsOneWidget);
      expect(find.byKey(const Key('annotate_action_redo')), findsOneWidget);
      expect(find.byKey(const Key('annotate_action_save')), findsOneWidget);

      // Save button is initially disabled (no markups)
      final saveButton = tester.widget<FilledButton>(
        find.byKey(const Key('annotate_action_save')),
      );
      expect(saveButton.onPressed, isNull);

      // Markup toolbar present at bottom
      expect(find.byKey(const Key('annotate_tool_highlight')), findsOneWidget);
      expect(find.byKey(const Key('annotate_tool_underline')), findsOneWidget);
      expect(find.byKey(const Key('annotate_tool_strikethrough')), findsOneWidget);
      expect(find.byKey(const Key('annotate_color_swatches')), findsOneWidget);
    });

    testWidgets('shows discard dialog on back press when session is dirty', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await pumpUntilLoaded(tester);

      // Manually add markup to session via container/provider
      final element = tester.element(find.byType(AnnotateScreen));
      final container = ProviderScope.containerOf(element);
      container.read(annotateSessionProvider.notifier).addMarkup(
        TextMarkup(
          id: 'test_m1',
          pageIndex: 0,
          type: TextMarkupType.highlight,
          colorValue: 0xFFFFEB3B,
          lineRects: const [Rect.fromLTWH(50, 50, 100, 20)],
          text: 'Highlighted',
          createdAtMs: 1000,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Save button should now be enabled
      final saveButton = tester.widget<FilledButton>(
        find.byKey(const Key('annotate_action_save')),
      );
      expect(saveButton.onPressed, isNotNull);

      // Tap back button
      await tester.tap(find.byKey(const Key('annotate_back_button')));
      await tester.pump(const Duration(milliseconds: 200));

      // Discard dialog appears
      expect(find.text('Discard unsaved annotations?'), findsOneWidget);
      expect(find.text('You have unsaved markups. If you exit now, your changes will be lost.'), findsOneWidget);
      expect(find.text('Discard'), findsOneWidget);
      expect(find.text('Keep editing'), findsOneWidget);

      // Tap Keep editing
      await tester.tap(find.text('Keep editing'));
      await tester.pump(const Duration(milliseconds: 200));

      // Dialog dismissed, screen remains
      expect(find.text('Discard unsaved annotations?'), findsNothing);
      expect(find.text('test_doc.pdf'), findsOneWidget);
    });

    testWidgets('shows signed banner and disables replace original if signed', (tester) async {
      const signedInfo = PdfDocumentInfo(
        pageCount: 1,
        isEncrypted: false,
        hasDigitalSignature: true,
        pageRotations: [0],
        pageSizes: [Size(600, 800)],
      );

      await tester.pumpWidget(createTestWidget(mockInfo: signedInfo));
      await pumpUntilLoaded(tester);

      final element = tester.element(find.byType(AnnotateScreen));
      final container = ProviderScope.containerOf(element);
      container.read(annotateSessionProvider.notifier).addMarkup(
        TextMarkup(
          id: 'test_m2',
          pageIndex: 0,
          type: TextMarkupType.underline,
          colorValue: 0xFF2196F3,
          lineRects: const [Rect.fromLTWH(50, 50, 100, 20)],
          text: 'Underline',
          createdAtMs: 1000,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Signed banner is displayed
      expect(find.byKey(const Key('annotate_signed_banner')), findsOneWidget);
      expect(find.text('Digitally signed PDF: Saving will create a new copy to preserve the signature.'), findsOneWidget);

      // Tap Save button to open save options sheet
      await tester.tap(find.byKey(const Key('annotate_action_save')));
      await tester.pump(const Duration(milliseconds: 300));

      // Verify bottom sheet options
      expect(find.text('Save annotations'), findsOneWidget);
      expect(find.text('Save as new file'), findsOneWidget);
      expect(find.text('Replace original'), findsOneWidget);

      // Replace original ListTile is disabled
      final replaceTile = tester.widget<ListTile>(
        find.widgetWithText(ListTile, 'Replace original'),
      );
      expect(replaceTile.enabled, isFalse);
    });

    testWidgets('Pen tool activates pen mode, displays tip banner, and opens PenSheet on second tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await pumpUntilLoaded(tester);

      // Verify 5 tools present in bottom toolbar
      expect(find.byKey(const Key('annotate_tool_copy')), findsOneWidget);
      expect(find.byKey(const Key('annotate_tool_highlight')), findsOneWidget);
      expect(find.byKey(const Key('annotate_tool_underline')), findsOneWidget);
      expect(find.byKey(const Key('annotate_tool_strikethrough')), findsOneWidget);
      expect(find.byKey(const Key('annotate_tool_pen')), findsOneWidget);

      // Initially highlight is active, no pen banner
      expect(find.byKey(const Key('annotate_pen_tip_banner')), findsNothing);

      // Tap Pen tool
      await tester.tap(find.byKey(const Key('annotate_tool_pen')));
      await tester.pump(const Duration(milliseconds: 100));

      // One-time first-use pen notice appears
      expect(find.byKey(const Key('annotate_pen_notice_banner')), findsOneWidget);

      // Dismiss one-time notice
      await tester.tap(find.byKey(const Key('annotate_pen_notice_got_it')));
      await tester.pump(const Duration(milliseconds: 100));

      // Pen tip banner appears
      expect(find.byKey(const Key('annotate_pen_tip_banner')), findsOneWidget);

      // Tap Pen tool again to open PenSheet
      await tester.tap(find.byKey(const Key('annotate_tool_pen')));
      await tester.pump(const Duration(milliseconds: 300));

      // Pen settings sheet is displayed
      expect(find.byKey(const Key('pen_color_swatches')), findsOneWidget);
      expect(find.byKey(const Key('pen_stroke_width_slider')), findsOneWidget);
      expect(find.byKey(const Key('pen_eraser_toggle')), findsOneWidget);
    });
  });
}
