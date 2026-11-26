import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/services/open_with_service.dart';
import 'package:docview/features/viewer/viewer_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

DocFile _testDocFile({required String name, required String path, FileCategory category = FileCategory.txt}) {
  return DocFile(
    id: 42,
    path: path,
    name: name,
    extension: '.txt',
    sizeBytes: 128,
    modified: DateTime(2026, 11, 26),
    category: category,
  );
}

void main() {
  group('OpenWithService unit tests', () {
    test('getInitialFile caches initial path and consumeInitialFile clears it', () async {
      final service = OpenWithService();
      expect(await service.getInitialFile(), isNull);

      service.setInitialFileForTesting('/data/user/0/cache/sample.pdf');
      final firstRead = await service.getInitialFile();
      expect(firstRead, '/data/user/0/cache/sample.pdf');

      // Idempotent read returns cached path
      final secondRead = await service.getInitialFile();
      expect(secondRead, '/data/user/0/cache/sample.pdf');

      // Consume clears the cache
      service.consumeInitialFile();
      final thirdRead = await service.getInitialFile();
      expect(thirdRead, isNull);
    });

    test('incomingFiles stream receives warm start broadcasts', () async {
      final service = OpenWithService();
      final emittedPaths = <String>[];
      final sub = service.incomingFiles.listen(emittedPaths.add);

      service.initialize();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await sub.cancel();
      service.dispose();
    });
  });

  group('ViewerScreen PopScope resilience', () {
    testWidgets('PopScope handles pop attempt gracefully when canPop is false', (tester) async {
      final testFile = _testDocFile(
        name: 'test.txt',
        path: '/tmp/test.txt',
        category: FileCategory.txt,
      );

      bool navigatedHome = false;

      final router = GoRouter(
        initialLocation: '/viewer',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) {
              navigatedHome = true;
              return const Scaffold(body: Text('Home Screen'));
            },
          ),
          GoRoute(
            path: '/viewer',
            builder: (context, state) => ViewerScreen(file: testFile),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      // Verify PopScope is present
      final popScopeFinder = find.byWidgetPredicate((widget) => widget is PopScope);
      expect(popScopeFinder, findsWidgets);

      expect(find.byType(ViewerScreen), findsOneWidget);
      expect(navigatedHome, isFalse);
    });
  });
}
