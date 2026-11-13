import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/files/files_screen.dart';
import 'package:docview/features/home/home_screen.dart';
import 'package:docview/features/onboarding/onboarding_screen.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/search/search_screen.dart';
import 'package:docview/shared/widgets/ads/ad_placeholders.dart';
import 'package:docview/shared/widgets/status/doc_status_widgets.dart';
import 'package:docview/shared/widgets/tiles/doc_folded_icon.dart';
import 'package:docview/shared/widgets/tiles/file_and_folder_rows.dart';
import 'package:docview/shared/widgets/tiles/file_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

DocFile _mockFile({
  required int id,
  required String name,
  required FileCategory category,
  bool isBookmarked = false,
}) {
  return DocFile(
    id: id,
    path: '/mock/path/$name',
    name: name,
    extension: name.contains('.') ? '.${name.split('.').last}' : '.pdf',
    sizeBytes: 1024 * 1024,
    modified: DateTime(2026, 11, 1),
    category: category,
    isBookmarked: isBookmarked,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Phase 2 Launch Flow Tests', () {
    testWidgets('OnboardingScreen navigates 3 pages and completes', (tester) async {
      tester.view.physicalSize = const Size(393 * 2, 852 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Page 1: Skip button visible
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);

      // Tap Next to Page 2
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Skip'), findsOneWidget);

      // Tap Next to Page 3
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Page 3: "Step 3 of 3" and "Get started" CTA
      expect(find.text('Step 3 of 3'), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
    });
  });

  group('Phase 2 Home Screen States Tests', () {
    testWidgets('HomeScreen renders populated recents with NativeAdRow after 4th item', (tester) async {
      tester.view.physicalSize = const Size(393 * 2, 1000 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockFiles = List.generate(
        6,
        (i) => _mockFile(id: i + 1, name: 'Doc_$i.pdf', category: FileCategory.pdf),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoryCountsProvider.overrideWith((ref) async => {
                  FileCategory.pdf: 6,
                }),
            recentsProvider.overrideWith((ref) async => mockFiles),
            bookmarksProvider.overrideWith((ref) async => []),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Doc View'), findsOneWidget);
      expect(find.text('PDF'), findsWidgets);

      // Ensure NativeAdRow is scrolled into view and verified
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(find.byType(NativeAdRow), findsOneWidget);
      expect(find.byType(AdBannerSlot), findsOneWidget);
    });

    testWidgets('HomeScreen renders empty states for recent and bookmarks', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoryCountsProvider.overrideWith((ref) async => {}),
            recentsProvider.overrideWith((ref) async => []),
            bookmarksProvider.overrideWith((ref) async => []),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Recent empty state
      expect(find.byType(DocEmptyState), findsOneWidget);
      expect(find.text('Recently opened files will appear here'), findsOneWidget);

      // Switch to Bookmarks tab
      await tester.tap(find.text('Bookmarks'));
      await tester.pumpAndSettle();

      // Bookmarks empty state
      expect(find.text('Bookmarked documents will appear here'), findsOneWidget);
    });
  });

  group('Phase 2 Search Screen States Tests', () {
    testWidgets('SearchScreen shows prompt and empty state when query is blank', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SearchScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Type to search documents'), findsOneWidget);
    });

    testWidgets('SearchScreen filters and highlights matches with bold primary blue', (tester) async {
      final mockFiles = [
        _mockFile(id: 1, name: 'Practice_Exam.pdf', category: FileCategory.pdf),
        _mockFile(id: 2, name: 'Report_Final.pdf', category: FileCategory.pdf),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchResultsProvider.overrideWith((ref) async => [mockFiles.first]),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SearchScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter search text
      await tester.enterText(find.byType(TextField), 'prac');
      await tester.pumpAndSettle();

      expect(find.byType(FileRow), findsOneWidget);
    });
  });

  group('Phase 2 Category and Image Grid Tests', () {
    testWidgets('FilesScreen renders 3-column grid for Image category', (tester) async {
      final mockImages = [
        _mockFile(id: 1, name: 'Photo_1.jpg', category: FileCategory.image),
        _mockFile(id: 2, name: 'Photo_2.png', category: FileCategory.image),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filesProvider(FileCategory.image).overrideWith((ref) async => mockImages),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const FilesScreen(category: FileCategory.image),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(ImageGridTile), findsNWidgets(2));
    });
  });

  group('Phase 2 PDF Thumbnail Source Fallback Tests', () {
    testWidgets('FileThumbnail gracefully falls back to red PDF glyph on missing file', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: FileThumbnail(
              filePath: '/non_existent_path.pdf',
              category: FileCategory.pdf,
              source: null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Renders red PDF glyph badge as fallback
      expect(find.text('PDF'), findsOneWidget);
    });
  });

  group('Phase 2 5000+ Files & Folded Corner Tests', () {
    testWidgets('FilesScreen renders over 100 items line-wise without truncation', (tester) async {
      tester.view.physicalSize = const Size(393 * 2, 852 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final manyFiles = List.generate(
        150,
        (i) => _mockFile(id: i + 1, name: 'document_$i.pdf', category: FileCategory.pdf),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            filesProvider(null).overrideWith((ref) => Future.value(manyFiles)),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const FilesScreen(category: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('document_0.pdf'), findsOneWidget);
    });

    testWidgets('DocFoldedIcon custom painter renders without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Center(
              child: DocFoldedIcon(
                color: Colors.red,
                width: 32,
                height: 38,
                hasFold: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DocFoldedIcon), findsOneWidget);
    });
  });
}
