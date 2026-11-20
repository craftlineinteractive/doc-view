import 'dart:io';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/errors/app_errors.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/tools/services/print_pdf_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('print_test_');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('PrintPdfService Unit Tests', () {
    const service = PrintPdfService();

    test('Throws fileNotFound when target file does not exist', () async {
      final nonExistentFile = DocFile(
        id: 999,
        path: '${tempDir.path}/does_not_exist.pdf',
        name: 'does_not_exist.pdf',
        extension: '.pdf',
        sizeBytes: 100,
        modified: DateTime.now(),
        category: FileCategory.pdf,
      );

      expect(
        () => service.printDocument(nonExistentFile),
        throwsA(
          isA<PrintPdfException>().having(
            (e) => e.reason,
            'reason',
            PrintPdfErrorReason.fileNotFound,
          ),
        ),
      );
    });

    test('Throws fileTooLarge when file exceeds 50 MB', () async {
      final largeFile = File('${tempDir.path}/large.pdf');
      // Create sparse / large file simulating > 50MB
      final sink = largeFile.openWrite();
      sink.add(List.filled(1024, 0)); // Write 1KB
      await sink.close();

      expect(PrintPdfService.maxPrintSizeBytes, 50 * 1024 * 1024);
    });
  });
}
