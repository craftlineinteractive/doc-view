import 'dart:io';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/repositories/file_repository.dart';
import 'package:docview/data/services/pdf/pdf_output_service.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/tools/create_pdf/create_pdf_service.dart';
import 'package:docview/features/tools/create_pdf/paper_template.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFileRepository implements FileRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<void> upsertBatch(List<DocFile> files) async {}

  @override
  Future<DocFile?> getFileByPath(String path) async {
    final file = File(path);
    final stat = await file.stat();
    return DocFile(
      path: path,
      name: file.uri.pathSegments.last,
      extension: 'pdf',
      sizeBytes: stat.size,
      modified: stat.modified,
      category: FileCategory.pdf,
      isBookmarked: false,
      isImported: true,
    );
  }
}

class _FakeFileActionsController implements FileActionsController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  void invalidateAll() {}
}

class _TestPdfOutputService extends PdfOutputService {
  _TestPdfOutputService(this.tempDir)
      : super(
          repository: _FakeFileRepository(),
          actionsController: _FakeFileActionsController(),
        );

  final Directory tempDir;

  @override
  Future<Directory> getOutputDir() async => tempDir;

  @override
  Future<File> uniqueFile(String baseName) async {
    return PdfOutputService.uniqueFileInDir(tempDir, baseName);
  }
}

void main() {
  late Directory tempDir;
  late _TestPdfOutputService outputService;
  late CreatePdfService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('create_pdf_test_');
    outputService = _TestPdfOutputService(tempDir);
    service = CreatePdfService(outputService: outputService);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('CreatePdfService Validation Tests', () {
    test('Throws pageCountOutOfRange when page count < 1', () async {
      expect(
        () => service.generateTemplatePdf(
          template: PaperTemplate.blank,
          pageSize: PaperPageSize.a4,
          orientation: PaperOrientation.portrait,
          colorSwatch: PaperColorSwatch.white,
          pageCount: 0,
          fileName: 'Test',
        ),
        throwsA(
          isA<CreatePdfException>().having(
            (e) => e.reason,
            'reason',
            CreatePdfErrorReason.pageCountOutOfRange,
          ),
        ),
      );
    });

    test('Throws pageCountOutOfRange when page count > 100', () async {
      expect(
        () => service.generateTemplatePdf(
          template: PaperTemplate.blank,
          pageSize: PaperPageSize.a4,
          orientation: PaperOrientation.portrait,
          colorSwatch: PaperColorSwatch.white,
          pageCount: 101,
          fileName: 'Test',
        ),
        throwsA(
          isA<CreatePdfException>().having(
            (e) => e.reason,
            'reason',
            CreatePdfErrorReason.pageCountOutOfRange,
          ),
        ),
      );
    });
  });

  group('CreatePdfService Generation & Output Tests', () {
    test('Generates real valid PDF for Cornell template and registers file', () async {
      final progressUpdates = <int>[];

      final docFile = await service.generateTemplatePdf(
        template: PaperTemplate.cornell,
        pageSize: PaperPageSize.a4,
        orientation: PaperOrientation.portrait,
        colorSwatch: PaperColorSwatch.cream,
        pageCount: 3,
        fileName: 'CornellNotes',
        onProgress: (done, total) {
          progressUpdates.add(done);
          expect(total, 3);
        },
      );

      expect(docFile, isNotNull);
      expect(docFile.name, 'CornellNotes.pdf');
      expect(docFile.category, FileCategory.pdf);

      final file = File(docFile.path);
      expect(await file.exists(), isTrue);
      final bytes = await file.readAsBytes();
      expect(bytes.length, greaterThan(100));

      // PDF Magic bytes header: %PDF-
      final header = String.fromCharCodes(bytes.take(5));
      expect(header, '%PDF-');

      // Progress updates received
      expect(progressUpdates, containsAll([1, 2, 3]));
    });

    test('Generates valid PDF for all 7 paper templates without errors', () async {
      for (final template in PaperTemplate.values) {
        final doc = await service.generateTemplatePdf(
          template: template,
          pageSize: PaperPageSize.a5,
          orientation: PaperOrientation.landscape,
          colorSwatch: PaperColorSwatch.lightMint,
          pageCount: 1,
          fileName: 'Template_${template.name}',
        );

        final file = File(doc.path);
        expect(await file.exists(), isTrue);
        final bytes = await file.readAsBytes();
        expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      }
    });
  });
}
