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
  final List<DocFile> registeredFiles = [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<void> upsertBatch(List<DocFile> files) async {
    registeredFiles.addAll(files);
  }

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
  bool invalidated = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  void invalidateAll() {
    invalidated = true;
  }
}

class _TestPdfOutputService extends PdfOutputService {
  _TestPdfOutputService(this.tempDir, this.fakeRepo, this.fakeActions)
      : super(
          repository: fakeRepo,
          actionsController: fakeActions,
        );

  final Directory tempDir;
  final _FakeFileRepository fakeRepo;
  final _FakeFileActionsController fakeActions;

  @override
  Future<Directory> getOutputDir() async => tempDir;

  @override
  Future<File> uniqueFile(String baseName) async {
    return PdfOutputService.uniqueFileInDir(tempDir, baseName);
  }
}

void main() {
  late Directory tempDir;
  late _FakeFileRepository fakeRepo;
  late _FakeFileActionsController fakeActions;
  late _TestPdfOutputService outputService;
  late CreatePdfService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('create_pdf_test_');
    fakeRepo = _FakeFileRepository();
    fakeActions = _FakeFileActionsController();
    outputService = _TestPdfOutputService(tempDir, fakeRepo, fakeActions);
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

  group('CreatePdfService Generation, Metadata, and Contract Coverage', () {
    test('Generates real valid PDF for Cornell template, registers in DB, and includes title and progress', () async {
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

      // Verify DB registration
      expect(fakeRepo.registeredFiles.length, 1);
      expect(fakeRepo.registeredFiles.first.path, docFile.path);
      expect(fakeActions.invalidated, isTrue);

      final file = File(docFile.path);
      expect(await file.exists(), isTrue);
      final bytes = await file.readAsBytes();
      final pdfStr = String.fromCharCodes(bytes);

      // PDF Magic bytes header: %PDF-
      expect(pdfStr.startsWith('%PDF-'), isTrue);

      // Document title metadata check
      expect(pdfStr, contains('/Title(CornellNotes)'));
      expect(pdfStr, contains('/Creator(Doc View)'));

      // Page count check in PDF page tree: /Count 3
      expect(pdfStr, contains('/Count 3'));

      // Progress updates received
      expect(progressUpdates, containsAll([1, 2, 3]));
    });

    test('Sampled background color matches selected swatch', () async {
      const swatch = PaperColorSwatch.cream; // #FFF8E7 -> R:255, G:248, B:231
      final docFile = await service.generateTemplatePdf(
        template: PaperTemplate.blank,
        pageSize: PaperPageSize.a4,
        orientation: PaperOrientation.portrait,
        colorSwatch: swatch,
        pageCount: 1,
        fileName: 'CreamTest',
        compress: false,
      );

      final bytes = await File(docFile.path).readAsBytes();
      final pdfStr = String.fromCharCodes(bytes);

      // In uncompressed PDF content streams, color is written as: "r g b rg" with floats between 0 and 1
      // R: 255/255 = 1, G: 248/255 = 0.9725..., B: 231/255 = 0.9058...
      // e.g. "1 0.972549 0.905882 rg"
      expect(pdfStr, contains('0.9725'));
      expect(pdfStr, contains('0.9058'));
      expect(pdfStr, contains('rg'));
    });

    test('Page size in points (+/- 0.5) verified for all 7 sizes in both portrait and landscape', () async {
      final mediaBoxRegex = RegExp(r'/MediaBox\s*\[\s*0\s+0\s+([0-9.]+)\s+([0-9.]+)\s*\]');

      for (final pageSize in PaperPageSize.values) {
        for (final orientation in PaperOrientation.values) {
          final expectedWidth = pageSize.getWidth(orientation);
          final expectedHeight = pageSize.getHeight(orientation);

          final doc = await service.generateTemplatePdf(
            template: PaperTemplate.blank,
            pageSize: pageSize,
            orientation: orientation,
            colorSwatch: PaperColorSwatch.white,
            pageCount: 1,
            fileName: 'Size_${pageSize.name}_${orientation.name}',
          );

          final bytes = await File(doc.path).readAsBytes();
          final pdfStr = String.fromCharCodes(bytes);

          final match = mediaBoxRegex.firstMatch(pdfStr);
          expect(match, isNotNull, reason: 'MediaBox must exist in PDF for ${pageSize.name} ${orientation.name}');

          final parsedWidth = double.parse(match!.group(1)!);
          final parsedHeight = double.parse(match.group(2)!);

          expect(
            parsedWidth,
            closeTo(expectedWidth, 0.5),
            reason: '${pageSize.name} ${orientation.name} width matches within +/- 0.5 pt',
          );
          expect(
            parsedHeight,
            closeTo(expectedHeight, 0.5),
            reason: '${pageSize.name} ${orientation.name} height matches within +/- 0.5 pt',
          );
        }
      }
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
