import 'dart:io';

import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/utils/document_scanner_facade.dart';
import 'package:docview/core/utils/file_ingest_helper.dart';
import 'package:docview/core/utils/page_range_parser.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/repositories/file_repository.dart';
import 'package:docview/data/services/pdf/pdf_merge_service.dart';
import 'package:docview/data/services/pdf/pdf_output_service.dart';
import 'package:docview/data/services/pdf/pdf_split_service.dart';
import 'package:docview/data/services/permission_service.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/tools/create_pdf/create_pdf_service.dart';
import 'package:docview/features/tools/create_pdf/paper_template.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;

class _MockFileRepository implements FileRepository {
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

class _MockFileActionsController implements FileActionsController {
  bool invalidated = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  void invalidateAll() {
    invalidated = true;
  }
}

class _MockPermissionService implements PermissionService {
  bool granted = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<bool> hasAllFilesAccess() async => granted;
}

class _TestScopedPdfOutputService extends PdfOutputService {
  _TestScopedPdfOutputService({
    required this.tempAppDir,
    required _MockFileRepository repo,
    required _MockFileActionsController actions,
    required PermissionService permissionService,
  }) : super(
          repository: repo,
          actionsController: actions,
          permissionService: permissionService,
        );

  final Directory tempAppDir;

  @override
  Future<Directory> getOutputDir() async => tempAppDir;

  @override
  Future<File> uniqueFile(String baseName) async {
    return PdfOutputService.uniqueFileInDir(tempAppDir, baseName);
  }
}

Future<File> _createPdf(String path, int pageCount) async {
  final doc = pw.Document();
  for (var i = 1; i <= pageCount; i++) {
    doc.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Text('Page $i', style: const pw.TextStyle(fontSize: 30)),
        ),
      ),
    );
  }
  final file = File(path);
  await file.writeAsBytes(await doc.save());
  return file;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory testRoot;
  late Directory tempAppPrivateDir;
  late Directory tempCacheDir;
  late _MockFileRepository fakeRepo;
  late _MockFileActionsController fakeActions;
  late _MockPermissionService fakePermissions;
  late _TestScopedPdfOutputService outputService;

  setUp(() async {
    testRoot = await Directory.systemTemp.createTemp('storage_resilience_');
    tempAppPrivateDir = Directory('${testRoot.path}/app_flutter/created');
    tempCacheDir = Directory('${testRoot.path}/app_flutter/cache');
    await tempAppPrivateDir.create(recursive: true);
    await tempCacheDir.create(recursive: true);
    FileIngestHelper.tempDirOverride = tempCacheDir;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall call) async {
        if (call.method == 'getTemporaryDirectory') {
          return tempCacheDir.path;
        }
        if (call.method == 'getApplicationDocumentsDirectory') {
          return tempAppPrivateDir.path;
        }
        return tempCacheDir.path;
      },
    );

    fakeRepo = _MockFileRepository();
    fakeActions = _MockFileActionsController();
    fakePermissions = _MockPermissionService();

    outputService = _TestScopedPdfOutputService(
      tempAppDir: tempAppPrivateDir,
      repo: fakeRepo,
      actions: fakeActions,
      permissionService: fakePermissions,
    );
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
    DocumentScannerFacade.testScans = null;
    FileIngestHelper.tempDirOverride = null;
    if (await testRoot.exists()) {
      await testRoot.delete(recursive: true);
    }
  });

  group('Tool Storage Resilience & Scoped Storage', () {
    test('DocumentScannerFacade provides mocked scans in test mode', () async {
      DocumentScannerFacade.testScans = ['/dummy/scan1.jpg', '/dummy/scan2.jpg'];
      final scans = await DocumentScannerFacade.getPictures();
      expect(scans, ['/dummy/scan1.jpg', '/dummy/scan2.jpg']);
    });

    test('FileIngestHelper copies external file into target cache safely', () async {
      final sourceFile = File('${testRoot.path}/external_sample.txt');
      await sourceFile.writeAsString('DocView Ingest Test');

      final ingestedFile = await FileIngestHelper.ingestToCache(
        sourceFile.path,
        subDir: 'test_ingest',
      );

      expect(await ingestedFile.exists(), isTrue);
      expect(await ingestedFile.readAsString(), 'DocView Ingest Test');
      expect(ingestedFile.path, contains('test_ingest'));
    });

    test('FileIngestHelper.ingestAll batches multiple files safely', () async {
      final file1 = File('${testRoot.path}/ext1.txt');
      await file1.writeAsString('1');
      final file2 = File('${testRoot.path}/ext2.txt');
      await file2.writeAsString('2');

      final ingestedPaths = await FileIngestHelper.ingestAll(
        [file1.path, file2.path],
        subDir: 'test_batch',
      );

      expect(ingestedPaths.length, 2);
      expect(File(ingestedPaths[0]).existsSync(), isTrue);
      expect(File(ingestedPaths[1]).existsSync(), isTrue);
    });

    test('PdfOutputService registers output in DB and succeeds when AllFilesAccess is false', () async {
      fakePermissions.granted = false;

      final testFile = File('${tempAppPrivateDir.path}/DocView_output.pdf');
      await testFile.writeAsString('%PDF-1.4 dummy content');

      final doc = await outputService.registerOutput(testFile);

      expect(doc, isNotNull);
      expect(fakeRepo.registeredFiles.length, 1);
      expect(fakeRepo.registeredFiles.first.path, testFile.path);
      expect(fakeActions.invalidated, isTrue);
    });

    test('CreatePdfService generates valid PDF without requiring AllFilesAccess permission', () async {
      fakePermissions.granted = false;
      final createService = CreatePdfService(outputService: outputService);

      final doc = await createService.generateTemplatePdf(
        template: PaperTemplate.blank,
        pageSize: PaperPageSize.a4,
        orientation: PaperOrientation.portrait,
        colorSwatch: PaperColorSwatch.white,
        pageCount: 1,
        fileName: 'ScopedStorageDoc',
      );

      expect(doc, isNotNull);
      final file = File(doc.path);
      expect(await file.exists(), isTrue);
      expect(file.path, startsWith(tempAppPrivateDir.path));
      expect(fakeRepo.registeredFiles.any((f) => f.path == doc.path), isTrue);
    });

    test('PdfMergeService merges multiple files safely into app-private storage', () async {
      fakePermissions.granted = false;
      final mergeService = PdfMergeService(outputService: outputService);

      final pdf1 = await _createPdf('${tempAppPrivateDir.path}/input1.pdf', 1);
      final pdf2 = await _createPdf('${tempAppPrivateDir.path}/input2.pdf', 2);

      final docFile = await mergeService.merge(
        [pdf1.path, pdf2.path],
        name: 'MergedOutput.pdf',
      );

      expect(docFile, isNotNull);
      expect(File(docFile.path).existsSync(), isTrue);
      expect(fakeRepo.registeredFiles.any((f) => f.path == docFile.path), isTrue);
    });

    test('PdfSplitService splits a PDF into app-private outputs safely', () async {
      fakePermissions.granted = false;
      final splitService = PdfSplitService(outputService: outputService);

      final multiPagePdf = await _createPdf('${tempAppPrivateDir.path}/multi.pdf', 3);

      final docFiles = await splitService.split(
        multiPagePdf.path,
        [
          PageRange(1, 1),
          PageRange(2, 3),
        ],
        namePrefix: 'SplitPart',
      );

      expect(docFiles.length, 2);
      for (final f in docFiles) {
        expect(File(f.path).existsSync(), isTrue);
        expect(fakeRepo.registeredFiles.any((r) => r.path == f.path), isTrue);
      }
    });
  });
}
