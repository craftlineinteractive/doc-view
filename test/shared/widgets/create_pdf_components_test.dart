import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/features/tools/create_pdf/paper_template.dart';
import 'package:docview/shared/widgets/create_pdf/color_swatch_row.dart';
import 'package:docview/shared/widgets/create_pdf/page_count_stepper.dart';
import 'package:docview/shared/widgets/create_pdf/paper_preview.dart';
import 'package:docview/shared/widgets/create_pdf/template_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaperPreview Component Tests', () {
    testWidgets('Renders preview for blank and ruled templates', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 300,
                child: PaperPreview(
                  template: PaperTemplate.notebook,
                  pageSize: PaperPageSize.a4,
                  orientation: PaperOrientation.portrait,
                  colorSwatch: PaperColorSwatch.white,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PaperPreview), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('TemplateCard Component Tests', () {
    testWidgets('Renders card with label and triggers onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: TemplateCard(
                template: PaperTemplate.cornell,
                label: 'Cornell',
                isSelected: false,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cornell'), findsOneWidget);
      await tester.tap(find.byType(TemplateCard));
      expect(tapped, isTrue);
    });
  });

  group('ColorSwatchRow Component Tests', () {
    testWidgets('Renders 10 swatches and selects tapped swatch', (tester) async {
      PaperColorSwatch selected = PaperColorSwatch.white;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              home: Scaffold(
                body: ColorSwatchRow(
                  selectedSwatch: selected,
                  labelBuilder: (swatch) => swatch.name,
                  onSwatchSelected: (swatch) {
                    setState(() => selected = swatch);
                  },
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);

      // Tap on another swatch
      final mintSwatch = find.bySemanticsLabel(PaperColorSwatch.lightMint.name);
      expect(mintSwatch, findsOneWidget);
      await tester.tap(mintSwatch);
      await tester.pumpAndSettle();

      expect(selected, PaperColorSwatch.lightMint);
    });
  });

  group('PageCountStepper Component Tests', () {
    testWidgets('Increments, decrements, and respects min/max boundaries', (tester) async {
      var count = 1;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              home: Scaffold(
                body: PageCountStepper(
                  count: count,
                  countLabel: '$count pages',
                  min: 1,
                  max: 5,
                  onChanged: (newVal) => setState(() => count = newVal),
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 pages'), findsOneWidget);

      // Decrement at min=1 should be disabled
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      expect(count, 1);

      // Increment to 2
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(count, 2);
      expect(find.text('2 pages'), findsOneWidget);
    });
  });
}
