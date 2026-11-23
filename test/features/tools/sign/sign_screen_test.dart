import 'dart:io';

import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/repositories/signature_repository.dart';
import 'package:docview/data/services/pdf/pdf_annotation_service.dart';
import 'package:docview/features/tools/sign/sign_screen.dart';
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
    tempDir = Directory.systemTemp.createTempSync('sign_screen_test_');

    // Create a simple test PDF
    final doc = sf.PdfDocument();
    final page = doc.pages.add();
    final font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 12);
    page.graphics.drawString('Test PDF Sign Screen Content', font,
        bounds: const Rect.fromLTWH(50, 50, 300, 20));
    final bytes = doc.saveSync();
    doc.dispose();

    samplePdf = File('${tempDir.path}/test_sign_doc.pdf');
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
        signatureRepositoryProvider.overrideWithValue(
          SignatureRepository(
            getDirectoryOverride: () async => tempDir,
          ),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SignScreen(
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

  group('SignScreen Widget Tests', () {
    testWidgets('renders shell, title, toolbar actions with initially disabled undo/redo/save', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await pumpUntilLoaded(tester);

      // Verify top bar
      expect(find.byKey(const Key('annotate_back_button')), findsOneWidget);
      expect(find.text('test_sign_doc.pdf'), findsOneWidget);
      expect(find.byKey(const Key('annotate_action_undo')), findsOneWidget);
      expect(find.byKey(const Key('annotate_action_redo')), findsOneWidget);
      expect(find.byKey(const Key('annotate_action_save')), findsOneWidget);

      // Save button is disabled initially
      final saveBtn = tester.widget<FilledButton>(find.byKey(const Key('annotate_action_save')));
      expect(saveBtn.onPressed, isNull);

      // Verify bottom bar actions (Sign and Clear all; Date stamp removed per G5b requirements)
      expect(find.byKey(const Key('sign_action_sign')), findsOneWidget);
      expect(find.byKey(const Key('sign_action_clear_all')), findsOneWidget);
      expect(find.byKey(const Key('sign_action_date')), findsNothing);
    });

    testWidgets('placing a vector signature enables save and undo/redo cycles properly', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await pumpUntilLoaded(tester);

      // Tap Sign action to open sheet
      await tester.tap(find.byKey(const Key('sign_action_sign')));
      await tester.pumpAndSettle();

      // Open new signature pad
      await tester.tap(find.byKey(const Key('sign_create_new')));
      await tester.pumpAndSettle();

      // Draw a stroke on the signature pad canvas
      await tester.timedDrag(
        find.byKey(const Key('signature_pad_canvas')),
        const Offset(50, 20),
        const Duration(milliseconds: 300),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Tap Use once button
      await tester.tap(find.byKey(const Key('signature_pad_use_once')));
      await tester.pumpAndSettle();

      // Save button should now be enabled
      final saveBtn = tester.widget<FilledButton>(find.byKey(const Key('annotate_action_save')));
      expect(saveBtn.onPressed, isNotNull);

      // Undo button enabled
      expect(find.byKey(const Key('annotate_action_undo')), findsOneWidget);
      await tester.tap(find.byKey(const Key('annotate_action_undo')));
      await tester.pump(const Duration(milliseconds: 100));

      // After undo, save button is disabled again
      final saveBtnAfterUndo = tester.widget<FilledButton>(find.byKey(const Key('annotate_action_save')));
      expect(saveBtnAfterUndo.onPressed, isNull);

      // Redo restores placed item
      await tester.tap(find.byKey(const Key('annotate_action_redo')));
      await tester.pump(const Duration(milliseconds: 100));

      final saveBtnAfterRedo = tester.widget<FilledButton>(find.byKey(const Key('annotate_action_save')));
      expect(saveBtnAfterRedo.onPressed, isNotNull);
    });

    testWidgets('Clear all displays confirmation dialog and clears placed signatures', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestWidget());
      await pumpUntilLoaded(tester);

      // Open and draw a signature
      await tester.tap(find.byKey(const Key('sign_action_sign')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sign_create_new')));
      await tester.pumpAndSettle();

      await tester.timedDrag(
        find.byKey(const Key('signature_pad_canvas')),
        const Offset(40, 20),
        const Duration(milliseconds: 300),
      );
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byKey(const Key('signature_pad_use_once')));
      await tester.pumpAndSettle();

      // Tap Clear all
      await tester.tap(find.byKey(const Key('sign_action_clear_all')));
      await tester.pumpAndSettle();

      // Confirmation dialog appears
      expect(find.text('Clear all signatures?'), findsOneWidget);

      // Confirm clear
      await tester.tap(find.widgetWithText(FilledButton, 'Clear all'));
      await tester.pumpAndSettle();

      // Save button is now disabled (all cleared)
      final saveBtn = tester.widget<FilledButton>(find.byKey(const Key('annotate_action_save')));
      expect(saveBtn.onPressed, isNull);
    });
  });
}
