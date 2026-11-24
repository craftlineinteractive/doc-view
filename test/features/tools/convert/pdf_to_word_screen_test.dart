import 'dart:io';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/tools/convert/pdf_to_word_screen.dart';
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
  late File emptyPdf;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = Directory.systemTemp.createTempSync('pdf_to_word_screen_test_');

    final doc = sf.PdfDocument();
    final page = doc.pages.add();
    final font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, 12);
    page.graphics.drawString(
      'Test Content For Conversion Screen',
      font,
      bounds: const Rect.fromLTWH(50, 50, 300, 20),
    );
    final bytes = doc.saveSync();
    doc.dispose();

    samplePdf = File('${tempDir.path}/sample_doc.pdf');
    await samplePdf.writeAsBytes(bytes);

    final emptyDoc = sf.PdfDocument();
    emptyDoc.pages.add();
    final emptyBytes = emptyDoc.saveSync();
    emptyDoc.dispose();

    emptyPdf = File('${tempDir.path}/empty_doc.pdf');
    await emptyPdf.writeAsBytes(emptyBytes);
  });

  tearDown(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  Widget createTestWidget({
    DocFile? initialFile,
    String? initialPassword,
  }) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PdfToWordScreen(
          initialFile: initialFile,
          initialPassword: initialPassword,
        ),
      ),
    );
  }

  testWidgets('Renders empty picker when no initial file is provided', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('btn_select_pdf')), findsOneWidget);
    expect(find.text('PDF to Word'), findsWidgets);
  });

  testWidgets('Renders main screen with PDF card, info banner, filename field, page switch and convert button', (tester) async {
    final docFile = DocFile(
      path: samplePdf.path,
      name: 'sample_doc.pdf',
      extension: 'pdf',
      sizeBytes: samplePdf.lengthSync(),
      modified: DateTime.now(),
      category: FileCategory.pdf,
    );

    await tester.pumpWidget(createTestWidget(initialFile: docFile));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pump();

    expect(find.text('sample_doc.pdf'), findsOneWidget);
    expect(find.byKey(const Key('input_docx_file_name')), findsOneWidget);
    expect(find.text('.docx'), findsOneWidget);
    expect(find.byKey(const Key('switch_page_breaks')), findsOneWidget);
    expect(find.byKey(const Key('btn_convert_to_word')), findsOneWidget);
    expect(find.byKey(const Key('btn_change_file')), findsOneWidget);

    // Toggle switch
    await tester.tap(find.byKey(const Key('switch_page_breaks')));
    await tester.pump();
  });

  testWidgets('Displays full-screen EmptyState with only Back button for scanned/empty text PDF', (tester) async {
    final docFile = DocFile(
      path: emptyPdf.path,
      name: 'empty_doc.pdf',
      extension: 'pdf',
      sizeBytes: emptyPdf.lengthSync(),
      modified: DateTime.now(),
      category: FileCategory.pdf,
    );

    await tester.pumpWidget(createTestWidget(initialFile: docFile));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pump();

    // Verify full-screen empty state for scanned / empty text is shown
    expect(find.text('No text found'), findsOneWidget);
    expect(find.text("No text found in this PDF. Scanned documents can't be converted."), findsOneWidget);
    expect(find.text('Back'), findsWidgets);

    // Convert button, options, and settings must NOT be shown
    expect(find.byKey(const Key('btn_convert_to_word')), findsNothing);
    expect(find.byKey(const Key('switch_page_breaks')), findsNothing);
    expect(find.byKey(const Key('input_docx_file_name')), findsNothing);
  });
}
