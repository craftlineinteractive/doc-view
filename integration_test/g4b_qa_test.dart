import 'dart:io';
import 'dart:ui' as ui;

import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/tools/create_pdf/create_pdf_screen.dart';
import 'package:docview/features/tools/tools_screen.dart';
import 'package:docview/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> _captureToSdcard(GlobalKey key, String fileName) async {
  try {
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      final image = await boundary.toImage(pixelRatio: 1.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final bytes = byteData.buffer.asUint8List();
        final file = File('/sdcard/Download/$fileName');
        await file.writeAsBytes(bytes);
        debugPrint('[G4B_QA] Saved screenshot to ${file.path} (${bytes.length} bytes)');
      }
    }
  } catch (e) {
    debugPrint('[G4B_QA] Error capturing screenshot $fileName: $e');
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('G4b QA: Capture Tools tab and Create PDF screen variants', (tester) async {
    final captureKey = GlobalKey();

    // 1. Capture Tools tab showing Create PDF tile in Convert & Create
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          createdFilesProvider.overrideWith((ref) => Future.value([])),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RepaintBoundary(
            key: captureKey,
            child: const ToolsScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tool_create_pdf')), findsOneWidget);
    await _captureToSdcard(captureKey, 'tools_tab_create_pdf.png');

    // 2. Capture Create PDF screen default state
    final createKey = GlobalKey();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          createdFilesProvider.overrideWith((ref) => Future.value([])),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RepaintBoundary(
            key: createKey,
            child: const CreatePdfScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _captureToSdcard(createKey, 'create_pdf_default.png');

    // 3. Select Cornell template, Cream swatch, and Landscape orientation
    await tester.ensureVisible(find.byKey(const Key('template_card_cornell')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('template_card_cornell')));
    await tester.pumpAndSettle();

    final creamSwatch = find.bySemanticsLabel('Cream');
    if (creamSwatch.evaluate().isNotEmpty) {
      await tester.tap(creamSwatch);
      await tester.pumpAndSettle();
    }

    await tester.ensureVisible(find.text('Landscape'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Landscape'));
    await tester.pumpAndSettle();

    await _captureToSdcard(createKey, 'create_pdf_cornell_landscape.png');

    // 4. Select Grid template, Light Mint swatch, increment page count to 3
    await tester.ensureVisible(find.byKey(const Key('template_card_grid')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('template_card_grid')));
    await tester.pumpAndSettle();

    final mintSwatch = find.bySemanticsLabel('Light Mint');
    if (mintSwatch.evaluate().isNotEmpty) {
      await tester.tap(mintSwatch);
      await tester.pumpAndSettle();
    }

    await tester.ensureVisible(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await _captureToSdcard(createKey, 'create_pdf_grid_mint.png');

    debugPrint('[G4B_QA] All screenshots captured successfully.');
  });
}
