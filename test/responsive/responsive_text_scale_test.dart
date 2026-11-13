import 'package:docview/core/constants/file_types.dart';
import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/directories/directories_screen.dart';
import 'package:docview/features/home/home_screen.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/settings/faq_screen.dart';
import 'package:docview/features/settings/scan_settings_screen.dart';
import 'package:docview/features/settings/settings_screen.dart';
import 'package:docview/features/tools/split_screen.dart';
import 'package:docview/features/tools/tools_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  const screenSizes = <String, Size>{
    'compact_360x640': Size(360, 640),
    'standard_393x852': Size(393, 852),
    'large_412x915': Size(412, 915),
  };

  const textScales = <double>[1.0, 1.3, 2.0];

  final sampleDoc = DocFile(
    path: '/storage/sample.pdf',
    name: 'sample.pdf',
    extension: 'pdf',
    sizeBytes: 1024,
    modified: DateTime(2026, 11, 1),
    category: FileCategory.pdf,
  );

  final screens = <String, Widget Function()>{
    'HomeScreen': () => const HomeScreen(),
    'ToolsScreen': () => const ToolsScreen(),
    'SettingsScreen': () => const SettingsScreen(),
    'FaqScreen': () => const FaqScreen(),
    'ScanSettingsScreen': () => const ScanSettingsScreen(),
    'DirectoriesScreen': () => const DirectoriesScreen(),
    'SplitScreen': () => SplitScreen(file: sampleDoc),
  };

  group('Responsive & High Text-Scale Layout Harness', () {
    for (final sizeEntry in screenSizes.entries) {
      for (final scale in textScales) {
        for (final screenEntry in screens.entries) {
          testWidgets('${screenEntry.key} renders cleanly on ${sizeEntry.key} at scale $scale', (tester) async {
            FlutterErrorDetails? errorDetails;
            final originalOnError = FlutterError.onError;
            FlutterError.onError = (details) {
              errorDetails = details;
              originalOnError?.call(details);
            };
            addTearDown(() => FlutterError.onError = originalOnError);
            tester.view.physicalSize = Size(
              sizeEntry.value.width * 2,
              sizeEntry.value.height * 2,
            );
            tester.view.devicePixelRatio = 2.0;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);

            await tester.pumpWidget(
              ProviderScope(
                overrides: [
                  categoryCountsProvider.overrideWith((ref) async => {
                    FileCategory.pdf: 1,
                    FileCategory.word: 2,
                    FileCategory.excel: 3,
                    FileCategory.ppt: 4,
                    FileCategory.txt: 5,
                    FileCategory.image: 6,
                  }),
                  recentsProvider.overrideWith((ref) async => [sampleDoc]),
                  bookmarksProvider.overrideWith((ref) async => [sampleDoc]),
                ],
                child: MaterialApp(
                  theme: AppTheme.lightTheme,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: TextScaler.linear(scale),
                      ),
                      child: child!,
                    );
                  },
                  home: screenEntry.value(),
                ),
              ),
            );
            await tester.pumpAndSettle();
            if (errorDetails != null) {
              debugPrint('ERROR SUMMARY: ${errorDetails?.summary}');
              final info = errorDetails?.informationCollector?.call();
              if (info != null) {
                for (final node in info) {
                  debugPrint('INFO NODE: ${node.toStringDeep()}');
                }
              }
            }
            expect(tester.takeException(), isNull);
          });
        }
      }
    }

    testWidgets('Landscape orientation on HomeScreen renders without overflow', (tester) async {
      tester.view.physicalSize = const Size(852 * 2, 393 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoryCountsProvider.overrideWith((ref) async => {
              FileCategory.pdf: 1,
              FileCategory.word: 2,
              FileCategory.excel: 3,
              FileCategory.ppt: 4,
              FileCategory.txt: 5,
              FileCategory.image: 6,
            }),
            recentsProvider.overrideWith((ref) async => [sampleDoc]),
            bookmarksProvider.overrideWith((ref) async => [sampleDoc]),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
