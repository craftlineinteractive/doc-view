import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_icons.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/shared/widgets/ads/ad_placeholders.dart';
import 'package:docview/shared/widgets/buttons/doc_buttons.dart';
import 'package:docview/shared/widgets/buttons/doc_icon_button.dart';
import 'package:docview/shared/widgets/inputs/doc_inputs.dart';
import 'package:docview/shared/widgets/skeletons/shimmer.dart';
import 'package:docview/shared/widgets/tabs/doc_tabs_and_filters.dart';
import 'package:docview/shared/widgets/tiles/category_tile.dart';
import 'package:docview/shared/widgets/tiles/file_and_folder_rows.dart';
import 'package:docview/shared/widgets/tiles/file_thumbnail.dart';
import 'package:docview/shared/widgets/tiles/file_type_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {bool isDark = false, bool disableAnimations = false}) {
  return MaterialApp(
    theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

class _FailingThumbnailSource implements ThumbnailSource {
  @override
  Future<ImageProvider?> loadThumbnail({
    required String filePath,
    required double width,
    required double height,
  }) async {
    return null; // Simulate failure/null
  }
}

void main() {
  group('Doc View Component Library Tests', () {
    // 1. FileRow States
    testWidgets('FileRow renders default, bookmarked, and selection states', (tester) async {
      bool bookmarked = false;
      bool tapped = false;

      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return FileRow(
                title: 'Test_Doc.pdf',
                metadata: '2.4 MB • Oct 24',
                category: FileCategory.pdf,
                filePath: '/path/test.pdf',
                isBookmarked: bookmarked,
                isSelectionMode: false,
                onTap: () => tapped = true,
                onToggleBookmark: () => setState(() => bookmarked = !bookmarked),
              );
            },
          ),
        ),
      );

      expect(find.text('Test_Doc.pdf'), findsOneWidget);
      expect(find.text('2.4 MB • Oct 24'), findsOneWidget);
      expect(find.byIcon(AppIcons.bookmarkOutline), findsOneWidget);

      // Tap bookmark
      await tester.tap(find.byIcon(AppIcons.bookmarkOutline));
      await tester.pump();
      expect(find.byIcon(AppIcons.bookmark), findsOneWidget);

      // Tap row
      await tester.tap(find.text('Test_Doc.pdf'));
      expect(tapped, isTrue);

      // Now verify selection mode
      await tester.pumpWidget(
        _wrap(
          FileRow(
            title: 'Test_Doc.pdf',
            metadata: '2.4 MB • Oct 24',
            category: FileCategory.pdf,
            filePath: '/path/test.pdf',
            isSelectionMode: true,
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      expect(find.byIcon(AppIcons.check), findsOneWidget);
    });

    // 2. Button Heights >= 48pt and Primary == 56pt
    testWidgets('Buttons meet height specifications (primary 56pt, icon >= 48pt)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Column(
            children: [
              DocPrimaryButton(label: 'Primary', onPressed: () {}),
              DocSecondaryButton(label: 'Secondary', onPressed: () {}),
              DocIconButton(icon: AppIcons.search, tooltip: 'Search', onPressed: () {}),
            ],
          ),
        ),
      );

      final primarySize = tester.getSize(find.byType(DocPrimaryButton));
      expect(primarySize.height, equals(56.0));

      final secondarySize = tester.getSize(find.byType(DocSecondaryButton));
      expect(secondarySize.height, equals(56.0));

      final iconSize = tester.getSize(find.byType(DocIconButton));
      expect(iconSize.width, greaterThanOrEqualTo(48.0));
      expect(iconSize.height, greaterThanOrEqualTo(48.0));
    });

    // 3. Text Field Error Validation
    testWidgets('DocTextField displays validation error message', (tester) async {
      final ctrl = TextEditingController();

      await tester.pumpWidget(
        _wrap(
          DocTextField(
            controller: ctrl,
            label: 'Document Name',
            errorText: 'File name cannot be empty',
          ),
        ),
      );

      expect(find.text('Document Name'), findsOneWidget);
      expect(find.text('File name cannot be empty'), findsOneWidget);
    });

    // 4. Skeleton Shimmer with Reduced Motion
    testWidgets('Shimmer respects reduced motion without crashing or animating', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Shimmer(
            child: SkeletonBox(width: 100, height: 20),
          ),
          disableAnimations: true,
        ),
      );

      expect(find.byType(SkeletonBox), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      // No exceptions thrown under reduced motion
    });

    // 5. Ad Slot Collapse
    testWidgets('AdBannerSlot collapses to zero height when isLoaded is false', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AdBannerSlot(isLoaded: false),
        ),
      );

      final size = tester.getSize(find.byType(AdBannerSlot));
      expect(size.height, equals(0.0));

      // Loaded state expands to 60pt
      await tester.pumpWidget(
        _wrap(
          const AdBannerSlot(isLoaded: true),
        ),
      );
      await tester.pumpAndSettle();

      final loadedSize = tester.getSize(find.byType(AdBannerSlot));
      expect(loadedSize.height, equals(60.0));
    });

    // 6. Thumbnail Fallback to Glyph
    testWidgets('FileThumbnail falls back to FileTypeBadge when source returns null', (tester) async {
      await tester.pumpWidget(
        _wrap(
          FileThumbnail(
            filePath: '/sample.pdf',
            category: FileCategory.pdf,
            source: _FailingThumbnailSource(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(FileTypeBadge), findsOneWidget);
      expect(find.text('PDF'), findsOneWidget);
    });

    // 7. Segmented Control Selection
    testWidgets('DocSegmentedControl updates selection on tap', (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return DocSegmentedControl<int>(
                options: const {0: 'A4', 1: 'Fit'},
                selectedValue: selected,
                onValueChanged: (val) => setState(() => selected = val),
              );
            },
          ),
        ),
      );

      expect(find.text('A4'), findsOneWidget);
      expect(find.text('Fit'), findsOneWidget);

      await tester.tap(find.text('Fit'));
      await tester.pumpAndSettle();

      expect(selected, equals(1));
    });

    // 8. Category Tile Layout & Touch Target
    testWidgets('CategoryTile renders count, label, and accessible semantics', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _wrap(
          CategoryTile(
            category: FileCategory.word,
            label: 'Word',
            icon: AppIcons.word,
            count: 42,
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Word'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);

      await tester.tap(find.byType(CategoryTile));
      expect(tapped, isTrue);
    });

    // 9. Underline Tabs Switching
    testWidgets('DocUnderlineTabs displays badges and triggers selection', (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return DocUnderlineTabs(
                selectedIndex: selected,
                recentCount: 12,
                bookmarksCount: 4,
                onTabSelected: (val) => setState(() => selected = val),
              );
            },
          ),
        ),
      );

      expect(find.text('Recent'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Bookmarks'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);

      await tester.tap(find.text('Bookmarks'));
      await tester.pumpAndSettle();

      expect(selected, equals(1));
    });

    // 10. Breadcrumb Bar Navigation
    testWidgets('DocBreadcrumbBar renders segments and triggers ancestor callback', (tester) async {
      int tappedIndex = -1;

      await tester.pumpWidget(
        _wrap(
          DocBreadcrumbBar(
            pathSegments: const ['Root', 'Download', 'Subfolder'],
            onSegmentTap: (index) => tappedIndex = index,
          ),
        ),
      );

      expect(find.text('Root'), findsOneWidget);
      expect(find.text('Download'), findsOneWidget);
      expect(find.text('Subfolder'), findsOneWidget);

      // Tapping 'Root' (index 0) triggers callback
      await tester.tap(find.text('Root'));
      expect(tappedIndex, equals(0));

      // Tapping last segment does not trigger
      tappedIndex = -1;
      await tester.tap(find.text('Subfolder'));
      expect(tappedIndex, equals(-1));
    });
  });
}

