import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/repositories/file_repository.dart';
import 'package:docview/data/services/widgets/deep_link_service.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class MockFileRepository implements FileRepository {
  final Map<int, DocFile> files = {};

  @override
  Future<DocFile?> getFileById(int id) async => files[id];

  @override
  Future<void> markOpened(int id) async {}

  @override
  Future<List<DocFile>> getRecents({int limit = 30}) async => [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeGoRouter implements GoRouter {
  String? lastPushed;
  String? lastWent;
  Object? lastExtra;

  @override
  void go(String location, {Object? extra}) {
    lastWent = location;
    lastExtra = extra;
  }

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) async {
    lastPushed = location;
    lastExtra = extra;
    return null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockFileRepository mockRepo;
  late FakeGoRouter fakeRouter;
  late ProviderContainer container;
  late DeepLinkService service;

  setUp(() {
    mockRepo = MockFileRepository();
    fakeRouter = FakeGoRouter();

    container = ProviderContainer(
      overrides: [
        fileRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );

    service = DeepLinkService(
      ref: container.read(Provider((ref) => ref)),
      router: fakeRouter,
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('DeepLinkService Routing & Security Validation Tests', () {
    test('routes docview://home to /home', () async {
      await service.handleUri(Uri.parse('docview://home'));
      expect(fakeRouter.lastWent, '/home');
    });

    test('routes docview://search to /search', () async {
      await service.handleUri(Uri.parse('docview://search'));
      expect(fakeRouter.lastPushed, '/search');
    });

    test('routes docview://tools/scan to /tools/scan', () async {
      await service.handleUri(Uri.parse('docview://tools/scan'));
      expect(fakeRouter.lastPushed, '/tools/scan');
    });

    test('routes docview://tools/image-to-pdf to /tools/image-to-pdf', () async {
      await service.handleUri(Uri.parse('docview://tools/image-to-pdf'));
      expect(fakeRouter.lastPushed, '/tools/image-to-pdf');
    });

    test('routes docview://tools/import to /tools/import', () async {
      await service.handleUri(Uri.parse('docview://tools/import'));
      expect(fakeRouter.lastPushed, '/tools/import');
    });

    test('SECURITY: rejects malicious traversal or injection in file id and redirects to /home', () async {
      await service.handleUri(Uri.parse('docview://open?id=../../etc/passwd'));
      expect(fakeRouter.lastWent, '/home');

      await service.handleUri(Uri.parse('docview://open?id=1;DROP%20TABLE%20files;'));
      expect(fakeRouter.lastWent, '/home');

      await service.handleUri(Uri.parse('docview://open?id=<script>'));
      expect(fakeRouter.lastWent, '/home');

      await service.handleUri(Uri.parse('docview://open'));
      expect(fakeRouter.lastWent, '/home');
    });

    test('opens viewer when file exists in repository', () async {
      final doc = DocFile(
        id: 42,
        path: '/test/path.pdf',
        name: 'Report.pdf',
        extension: 'pdf',
        sizeBytes: 2048,
        modified: DateTime.now(),
        category: FileCategory.pdf,
      );
      mockRepo.files[42] = doc;

      await service.handleUri(Uri.parse('docview://open?id=42'));
      expect(fakeRouter.lastPushed, '/viewer');
      expect(fakeRouter.lastExtra, doc);
    });

    test('safely falls back to /home when file does not exist in repository', () async {
      await service.handleUri(Uri.parse('docview://open?id=999'));
      expect(fakeRouter.lastWent, '/home');
    });
  });
}
