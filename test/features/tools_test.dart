import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/tools/image_list_editor_screen.dart';
import 'package:docview/features/tools/tools_screen.dart';
import 'package:docview/features/tools/widgets/tool_error_sheet.dart';
import 'package:docview/features/tools/widgets/tool_progress_dialog.dart';
import 'package:docview/features/tools/widgets/tool_result_sheet.dart';
import 'package:docview/shared/widgets/ads/ad_placeholders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

DocFile _mockDocFile({
  required int id,
  required String name,
  int sizeBytes = 1024 * 1024,
}) {
  return DocFile(
    id: id,
    path: '/mock/path/$name',
    name: name,
    extension: '.pdf',
    sizeBytes: sizeBytes,
    modified: DateTime(2026, 11, 1),
    category: FileCategory.pdf,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Tools Tab Contract & Compliance Tests', () {
    testWidgets('Strict 4-Tool contract: contains exactly 4 cards with specified keys', (tester) async {
      tester.view.physicalSize = const Size(393 * 2, 852 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            createdFilesProvider.overrideWith((ref) => Future.value([])),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ToolsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Exactly 4 tools present with specified keys
      expect(find.byKey(const Key('tool_image_to_pdf')), findsOneWidget);
      expect(find.byKey(const Key('tool_scan_to_pdf')), findsOneWidget);
      expect(find.byKey(const Key('tool_merge_pdf')), findsOneWidget);
      expect(find.byKey(const Key('tool_split_pdf')), findsOneWidget);

      // Section titles
      expect(find.text('WORKSPACE'), findsOneWidget);
      expect(find.text('Tools'), findsOneWidget);
      expect(find.text('CONVERT & CREATE'), findsOneWidget);
      expect(find.text('EDIT & MANAGE'), findsOneWidget);
      expect(find.text('Created by you'), findsOneWidget);

      // Empty state card for Created by you
      expect(find.text('PDFs you create appear here'), findsOneWidget);

      // FORBIDDEN STRINGS: strictly ZERO hits
      expect(find.textContaining('Engine 4.18'), findsNothing);
      expect(find.textContaining('2 Utilities'), findsNothing);
      expect(find.textContaining('OCR'), findsNothing);
      expect(find.textContaining('Compress'), findsNothing);
      expect(find.textContaining('Add Password'), findsNothing);
      expect(find.textContaining('Unlock'), findsNothing);
      expect(find.textContaining('Signature'), findsNothing);
      expect(find.textContaining('Share via Secure Link'), findsNothing);
      expect(find.textContaining('256-bit encryption'), findsNothing);
    });
  });

  group('Shared Operation UI Tests', () {
    testWidgets('ToolProgressDialog renders title, message, percentage, and respects onCancel', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ToolProgressDialog(
              title: 'Creating PDF',
              message: 'Processing image 2 of 4...',
              progress: 0.5,
              onCancel: null, // Cancel hidden
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Creating PDF'), findsOneWidget);
      expect(find.text('Processing image 2 of 4...'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
      expect(find.text('Cancel'), findsNothing);
    });

    testWidgets('ToolProgressDialog shows Cancel when onCancel provided', (tester) async {
      var cancelled = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ToolProgressDialog(
              title: 'Creating PDF',
              message: 'Processing image 1 of 2...',
              progress: 0.5,
              onCancel: () => cancelled = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      expect(cancelled, isTrue);
    });

    testWidgets('ToolResultSheet single-file mode displays Open, Share, and Done', (tester) async {
      final file = _mockDocFile(id: 1, name: 'Report_Final.pdf', sizeBytes: 2 * 1024 * 1024);
      var doneCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: ToolResultSheet(
                files: [file],
                onDone: () => doneCalled = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('PDF Created'), findsOneWidget);
      expect(find.text('Saved to your Created folder'), findsOneWidget);
      expect(find.text('Report_Final.pdf'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      await tester.tap(find.text('Done'));
      expect(doneCalled, isTrue);
    });

    testWidgets('ToolResultSheet multi-file mode displays Share All and Done', (tester) async {
      final files = [
        _mockDocFile(id: 1, name: 'Part_1.pdf'),
        _mockDocFile(id: 2, name: 'Part_2.pdf'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: ToolResultSheet(
                files: files,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2 PDFs Created'), findsOneWidget);
      expect(find.text('Part_1.pdf'), findsOneWidget);
      expect(find.text('Part_2.pdf'), findsOneWidget);
      expect(find.text('Share All'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('ToolErrorSheet displays genuine service error and triggers Retry', (tester) async {
      var retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ToolErrorSheet(
              errorMessage: 'Corrupted image header at /storage/img.jpg',
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("Couldn't create PDF"), findsOneWidget);
      expect(find.text('Corrupted image header at /storage/img.jpg'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      expect(retryCalled, isTrue);
    });

    testWidgets('ToolErrorSheet triggers Close callback', (tester) async {
      var closeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ToolErrorSheet(
              errorMessage: 'I/O failure',
              onClose: () => closeCalled = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Close'));
      expect(closeCalled, isTrue);
    });
  });

  group('Image to PDF Editor Screen Tests', () {
    testWidgets('Empty state renders when no images are provided', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ImageListEditorScreen(
              initialImagePaths: [],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add images to start'), findsOneWidget);
      expect(find.text('Choose photos'), findsOneWidget);
      expect(find.text('Scan paper'), findsOneWidget);
      expect(find.text('Create PDF'), findsOneWidget);

      // Create PDF button should be disabled when empty
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Create PDF'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Name validation disables CTA when text field is cleared', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ImageListEditorScreen(
              initialImagePaths: ['/test/dummy1.jpg'],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // CTA is initially enabled
      var button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Create PDF'),
      );
      expect(button.onPressed, isNotNull);

      // Clear the name field
      await tester.enterText(find.byType(TextField), '   ');
      await tester.pumpAndSettle();

      // CTA is now disabled
      button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Create PDF'),
      );
      expect(button.onPressed, isNull);
    });
  });

  group('Ad Placeholders Release Collapse Tests', () {
    testWidgets('AdBannerSlot, NativeAdRow, NativeAdCard collapse to 0 height when showPlaceholders is false', (tester) async {
      AdConfig.showPlaceholders = false;
      addTearDown(() => AdConfig.showPlaceholders = true);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Column(
              children: [
                AdBannerSlot(),
                NativeAdRow(),
                NativeAdCard(),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // In release mode (showPlaceholders == false), all 3 widgets collapse to SizedBox.shrink()
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox)).where(
        (sb) => sb.width == 0.0 && sb.height == 0.0,
      );
      expect(sizedBoxes.length, greaterThanOrEqualTo(3));

      // No placeholder text should be visible
      expect(find.text('CloudDrive Pro'), findsNothing);
      expect(find.text('Sponsored Ad'), findsNothing);
    });

    testWidgets('Ad placeholders render normally when showPlaceholders is true', (tester) async {
      AdConfig.showPlaceholders = true;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Column(
              children: [
                NativeAdRow(),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('CloudDrive Pro'), findsOneWidget);
      expect(find.text('AD'), findsOneWidget);
    });
  });
}
