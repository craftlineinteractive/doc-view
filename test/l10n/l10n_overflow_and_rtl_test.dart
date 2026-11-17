import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/features/home/home_screen.dart';
import 'package:docview/features/onboarding/onboarding_screen.dart';
import 'package:docview/features/providers/providers.dart';
import 'package:docview/features/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'recent_searches': ['financial report', 'invoice nov'],
    });
  });

  final sampleDoc = DocFile(
    path: '/storage/emulated/0/Download/Sample_Contract_2026.pdf',
    name: 'Sample_Contract_2026.pdf',
    extension: 'pdf',
    sizeBytes: 2048576,
    modified: DateTime(2026, 11, 15, 14, 30),
    category: FileCategory.pdf,
  );

  final testOverrides = [
    categoryCountsProvider.overrideWith((ref) async => {
          FileCategory.pdf: 14,
          FileCategory.word: 8,
          FileCategory.excel: 3,
          FileCategory.ppt: 2,
          FileCategory.txt: 1,
          FileCategory.image: 25,
        }),
    recentsProvider.overrideWith((ref) async => [sampleDoc]),
    bookmarksProvider.overrideWith((ref) async => [sampleDoc]),
    searchResultsProvider.overrideWith((ref) async => [sampleDoc]),
  ];

  group('L10n & RTL Overflow Testing Harness', () {
    final configurations = <String, ({Locale locale, TextDirection direction, double scale})>{
      'en_LTR_1.0x': (
        locale: const Locale('en'),
        direction: TextDirection.ltr,
        scale: 1.0,
      ),
      'en_LTR_2.0x': (
        locale: const Locale('en'),
        direction: TextDirection.ltr,
        scale: 2.0,
      ),
      'pseudo_en_XA_LTR_1.0x': (
        locale: const Locale('en', 'XA'),
        direction: TextDirection.ltr,
        scale: 1.0,
      ),
      'pseudo_en_XA_LTR_2.0x': (
        locale: const Locale('en', 'XA'),
        direction: TextDirection.ltr,
        scale: 2.0,
      ),
      'pseudo_en_XA_RTL_1.0x': (
        locale: const Locale('en', 'XA'),
        direction: TextDirection.rtl,
        scale: 1.0,
      ),
      'pseudo_en_XA_RTL_2.0x': (
        locale: const Locale('en', 'XA'),
        direction: TextDirection.rtl,
        scale: 2.0,
      ),
    };

    final screens = <String, Widget Function()>{
      'HomeScreen': () => const HomeScreen(),
      'SearchScreen': () => const SearchScreen(),
      'OnboardingScreen': () => const OnboardingScreen(),
    };

    for (final configEntry in configurations.entries) {
      final configName = configEntry.key;
      final config = configEntry.value;

      for (final screenEntry in screens.entries) {
        final screenName = screenEntry.key;

        testWidgets(
          '$screenName renders without overflow in $configName',
          (tester) async {
            FlutterErrorDetails? overflowError;
            final originalOnError = FlutterError.onError;
            FlutterError.onError = (details) {
              if (details.toString().contains('overflowed by') ||
                  details.toString().contains('RenderFlex overflowed')) {
                overflowError = details;
              }
              originalOnError?.call(details);
            };
            addTearDown(() => FlutterError.onError = originalOnError);

            tester.view.physicalSize = const Size(1080, 2400); // 360x800 @ 3.0 DPR
            tester.view.devicePixelRatio = 3.0;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);

            await tester.pumpApp(
              screenEntry.value(),
              locale: config.locale,
              textDirection: config.direction,
              textScale: config.scale,
              overrides: testOverrides,
            );

            await tester.pumpAndSettle();

            expect(
              overflowError,
              isNull,
              reason: 'Layout overflow detected in $screenName under $configName: '
                  '${overflowError?.summary}',
            );
          },
        );
      }
    }
  });
}
