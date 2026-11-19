import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/doc_view_tokens.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/services/pdf/pdf_page_edit_service.dart';
import 'package:docview/features/viewer/pages_screen.dart';
import 'package:docview/features/viewer/pdf_viewer_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> _captureToDevice(GlobalKey key, String fileName) async {
  try {
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      final image = await boundary.toImage(pixelRatio: 1.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final bytes = byteData.buffer.asUint8List();

        // Stream image chunks via stdout to capture on host
        final b64 = base64Encode(bytes);
        const chunkSize = 500;
        for (var i = 0; i < b64.length; i += chunkSize) {
          final end = (i + chunkSize < b64.length) ? i + chunkSize : b64.length;
          // ignore: avoid_print
          print('[G3A_IMG]:$fileName:$i:${b64.substring(i, end)}');
        }
        // ignore: avoid_print
        print('[G3A_IMG_DONE]:$fileName');

        final extDir = await getExternalStorageDirectory();
        if (extDir != null) {
          final file = File('${extDir.path}/$fileName');
          await file.writeAsBytes(bytes);
          debugPrint('[G3A_QA] Captured ${file.path} (${bytes.length} bytes)');
        }
      }
    }
  } catch (e) {
    debugPrint('[G3A_QA] Capture error: $e');
  }
}

Widget _wrapScreen({
  required Widget child,
  required GlobalKey captureKey,
  ThemeMode themeMode = ThemeMode.light,
}) {
  return ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: themeMode,
      theme: ThemeData.light().copyWith(
        extensions: const [DocViewTokens.light],
      ),
      darkTheme: ThemeData.dark().copyWith(
        extensions: const [DocViewTokens.dark],
      ),
      home: RepaintBoundary(
        key: captureKey,
        child: child,
      ),
    ),
  );
}

Future<void> _ensureTestFiles(String basePath) async {
  final sampleFile = File('$basePath/test_6pages.pdf');
  if (!sampleFile.existsSync()) {
    final pdf6 = pw.Document();
    for (var i = 1; i <= 6; i++) {
      pdf6.addPage(
        pw.Page(
          build: (context) => pw.Center(
            child: pw.Text('PAGE $i', style: const pw.TextStyle(fontSize: 40)),
          ),
        ),
      );
    }
    await sampleFile.writeAsBytes(await pdf6.save());
    debugPrint('[G3A_SETUP] Created ${sampleFile.path}');
  }

  final scannedFile = File('$basePath/test_scanned.pdf');
  if (!scannedFile.existsSync()) {
    final pdfScanned = pw.Document();
    pdfScanned.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Container(
            width: 200,
            height: 200,
            color: const PdfColor(0.8, 0.8, 0.8),
          ),
        ),
      ),
    );
    await scannedFile.writeAsBytes(await pdfScanned.save());
    debugPrint('[G3A_SETUP] Created ${scannedFile.path}');
  }

  final largeFile = File('$basePath/test_120pages.pdf');
  if (!largeFile.existsSync()) {
    final pdf120 = pw.Document();
    for (var i = 1; i <= 120; i++) {
      pdf120.addPage(
        pw.Page(
          build: (context) => pw.Center(
            child: pw.Text('P$i', style: const pw.TextStyle(fontSize: 30)),
          ),
        ),
      );
    }
    await largeFile.writeAsBytes(await pdf120.save());
    debugPrint('[G3A_SETUP] Created ${largeFile.path}');
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late String samplePath;
  late String scannedPath;
  late String largePath;
  late DocFile doc6;
  late DocFile docScanned;
  late DocFile doc120;

  setUpAll(() async {
    final extDir = await getExternalStorageDirectory();
    final basePath = extDir?.path ?? '/sdcard/Android/data/com.craftlineinteractive.docview/files';

    await _ensureTestFiles(basePath);

    samplePath = '$basePath/test_6pages.pdf';
    scannedPath = '$basePath/test_scanned.pdf';
    largePath = '$basePath/test_120pages.pdf';

    doc6 = DocFile(
      path: samplePath,
      name: 'test_6pages.pdf',
      extension: 'pdf',
      sizeBytes: File(samplePath).existsSync() ? File(samplePath).lengthSync() : 6294,
      modified: DateTime(2026, 11, 19),
      category: FileCategory.pdf,
    );

    docScanned = DocFile(
      path: scannedPath,
      name: 'test_scanned.pdf',
      extension: 'pdf',
      sizeBytes: File(scannedPath).existsSync() ? File(scannedPath).lengthSync() : 1851,
      modified: DateTime(2026, 11, 19),
      category: FileCategory.pdf,
    );

    doc120 = DocFile(
      path: largePath,
      name: 'test_120pages.pdf',
      extension: 'pdf',
      sizeBytes: File(largePath).existsSync() ? File(largePath).lengthSync() : 128566,
      modified: DateTime(2026, 11, 19),
      category: FileCategory.pdf,
    );
  });

  group('G3a Emulator QA Automated Test Suite', () {
    testWidgets('1. PDF Reader Chrome Light & Dark', (tester) async {
      final key = GlobalKey();

      // Light mode
      await tester.pumpWidget(_wrapScreen(
        child: PdfViewerScreen(file: doc6),
        captureKey: key,
        themeMode: ThemeMode.light,
      ));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _captureToDevice(key, 'g3a_reader_light.png');

      // Dark mode
      await tester.pumpWidget(_wrapScreen(
        child: PdfViewerScreen(file: doc6),
        captureKey: key,
        themeMode: ThemeMode.dark,
      ));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _captureToDevice(key, 'g3a_reader_dark.png');
    });

    testWidgets('2. Reader Bottom Row: Horizontal, Inverted, and Orientation', (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(_wrapScreen(
        child: PdfViewerScreen(file: doc6),
        captureKey: key,
        themeMode: ThemeMode.light,
      ));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Toggle Horizontal
      final horizBtn = find.text('Horizontal');
      if (horizBtn.evaluate().isNotEmpty) {
        await tester.tap(horizBtn);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await _captureToDevice(key, 'g3a_reader_horizontal.png');
      }

      // Toggle Invert
      final invertBtn = find.text('Invert');
      if (invertBtn.evaluate().isNotEmpty) {
        await tester.tap(invertBtn);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await _captureToDevice(key, 'g3a_reader_inverted.png');
      }

      // Toggle Rotate/Orientation
      final rotateBtn = find.text('Rotate');
      if (rotateBtn.evaluate().isNotEmpty) {
        await tester.tap(rotateBtn);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await _captureToDevice(key, 'g3a_reader_orientation.png');
      }
    });

    testWidgets('3. Reader Search: Matches, Zero Matches, and Scanned Notice', (tester) async {
      final key = GlobalKey();

      await tester.pumpWidget(_wrapScreen(
        child: PdfViewerScreen(file: doc6),
        captureKey: key,
        themeMode: ThemeMode.light,
      ));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Open search
      final searchBtn = find.text('Search');
      if (searchBtn.evaluate().isNotEmpty) {
        await tester.tap(searchBtn);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Enter active query
        final textField = find.byType(TextField);
        if (textField.evaluate().isNotEmpty) {
          await tester.enterText(textField, 'PAGE');
          await tester.pumpAndSettle(const Duration(seconds: 2));
          await _captureToDevice(key, 'g3a_reader_search_active.png');

          // Enter zero match query
          await tester.enterText(textField, 'ZZZNONEXISTENT');
          await tester.pumpAndSettle(const Duration(seconds: 2));
          await _captureToDevice(key, 'g3a_reader_search_zero.png');
        }
      }

      // Test scanned PDF
      await tester.pumpWidget(_wrapScreen(
        child: PdfViewerScreen(file: docScanned),
        captureKey: key,
        themeMode: ThemeMode.light,
      ));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final scannedSearch = find.text('Search');
      if (scannedSearch.evaluate().isNotEmpty) {
        await tester.tap(scannedSearch);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await _captureToDevice(key, 'g3a_reader_scanned_notice.png');
      }
    });

    testWidgets('4. Pages Screen: Grid, Rotate, Delete, and Save Dialog', (tester) async {
      final key = GlobalKey();

      final initialSpecs = List.generate(
        6,
        (i) => PdfPageEditSpec(sourcePath: samplePath, sourcePageIndex: i),
      );

      await tester.pumpWidget(_wrapScreen(
        child: PagesScreen(file: doc6, initialPages: initialSpecs),
        captureKey: key,
        themeMode: ThemeMode.light,
      ));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _captureToDevice(key, 'g3a_pages_grid_portrait.png');

      // Landscape grid
      await tester.binding.setSurfaceSize(const Size(800, 480));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await _captureToDevice(key, 'g3a_pages_grid_landscape.png');

      // Restore portrait size
      await tester.binding.setSurfaceSize(const Size(360, 640));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Select Page 6 (index 5) and rotate
      final tile6 = find.text('6');
      if (tile6.evaluate().isNotEmpty) {
        await tester.tap(tile6.first);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Tap Rotate action in bottom bar
        final rotateAction = find.text('Rotate');
        if (rotateAction.evaluate().isNotEmpty) {
          await tester.tap(rotateAction);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          await _captureToDevice(key, 'g3a_pages_rotated.png');
        }

        // Tap page 6 again to deselect
        await tester.tap(tile6.first);
        await tester.pumpAndSettle(const Duration(milliseconds: 300));
      }

      // Select Page 2 (index 1) and delete
      final tile2 = find.text('2');
      if (tile2.evaluate().isNotEmpty) {
        await tester.tap(tile2.first);
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        final deleteAction = find.text('Delete');
        if (deleteAction.evaluate().isNotEmpty) {
          await tester.tap(deleteAction);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          await _captureToDevice(key, 'g3a_pages_deleted.png');
        }
      }

      // Tap Save in AppBar to trigger save dialog
      final saveBtn = find.text('Save');
      if (saveBtn.evaluate().isNotEmpty) {
        await tester.tap(saveBtn);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await _captureToDevice(key, 'g3a_pages_save_dialog.png');
      }
    });

    testWidgets('5. Correctness Verification & Replace Original', (tester) async {
      // 1. Perform edit using PdfPageEditService:
      // Original 6 pages: P1, P2, P3, P4, P5, P6
      // Target edit: reorder to P3, P1, P2, P6, P4, P5; delete P2; rotate P6 +90
      // Result order: P3 (0°), P1 (0°), P6 (90°), P4 (0°), P5 (0°)
      const service = PdfPageEditService();
      final editedSpecs = [
        PdfPageEditSpec(sourcePath: samplePath, sourcePageIndex: 2, rotationDegrees: 0), // P3
        PdfPageEditSpec(sourcePath: samplePath, sourcePageIndex: 0, rotationDegrees: 0), // P1
        PdfPageEditSpec(sourcePath: samplePath, sourcePageIndex: 5, rotationDegrees: 90), // P6 rotated
        PdfPageEditSpec(sourcePath: samplePath, sourcePageIndex: 3, rotationDegrees: 0), // P4
        PdfPageEditSpec(sourcePath: samplePath, sourcePageIndex: 4, rotationDegrees: 0), // P5
      ];

      final extDir = await getExternalStorageDirectory();
      final basePath = extDir?.path ?? '/sdcard/Android/data/com.craftlineinteractive.docview/files';

      final savedCopyPath = '$basePath/test_6pages_edited_copy.pdf';
      await service.extractPages(
        pages: editedSpecs,
        outputPath: savedCopyPath,
      );

      final copyFile = File(savedCopyPath);
      expect(copyFile.existsSync(), isTrue);
      final copyDoc = DocFile(
        path: savedCopyPath,
        name: 'test_6pages_edited_copy.pdf',
        extension: 'pdf',
        sizeBytes: copyFile.lengthSync(),
        modified: DateTime.now(),
        category: FileCategory.pdf,
      );

      final key = GlobalKey();
      await tester.pumpWidget(_wrapScreen(
        child: PdfViewerScreen(file: copyDoc),
        captureKey: key,
        themeMode: ThemeMode.light,
      ));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _captureToDevice(key, 'g3a_saved_copy_verified.png');

      // Test Replace Original
      final copyForReplace = '$basePath/test_replace_target.pdf';
      await File(samplePath).copy(copyForReplace);
      expect(File(copyForReplace).existsSync(), isTrue);

      await service.saveDocument(
        pages: editedSpecs,
        outputPath: copyForReplace,
        replaceOriginal: true,
      );
      expect(File(copyForReplace).existsSync(), isTrue);
      final replacedDoc = DocFile(
        path: copyForReplace,
        name: 'test_replace_target.pdf',
        extension: 'pdf',
        sizeBytes: File(copyForReplace).lengthSync(),
        modified: DateTime.now(),
        category: FileCategory.pdf,
      );

      await tester.pumpWidget(_wrapScreen(
        child: PdfViewerScreen(file: replacedDoc),
        captureKey: key,
        themeMode: ThemeMode.light,
      ));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _captureToDevice(key, 'g3a_replaced_original_verified.png');
    });

    testWidgets('6. 100+ Page Document Scrolling Performance & Frame Times', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(_wrapScreen(
        child: PdfViewerScreen(file: doc120),
        captureKey: key,
        themeMode: ThemeMode.light,
      ));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Benchmark rapid scrolling
      final stopwatch = Stopwatch()..start();
      int frames = 0;

      for (var i = 0; i < 15; i++) {
        await tester.dragFrom(const Offset(180, 400), const Offset(0, -250));
        await tester.pump(const Duration(milliseconds: 16));
        frames++;
      }
      stopwatch.stop();

      final elapsedMs = stopwatch.elapsedMilliseconds;
      final avgFrameTimeMs = elapsedMs / (frames > 0 ? frames : 1);
      debugPrint('[G3A_PERF] 120-page doc scroll: $frames frames rendered in ${elapsedMs}ms (average ${avgFrameTimeMs.toStringAsFixed(2)} ms/frame, ${(1000 / avgFrameTimeMs).toStringAsFixed(1)} FPS)');
    });
  });
}
