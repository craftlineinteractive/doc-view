import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:docview/core/config/ad_config.dart';

void main() {
  group('Ad Security & Guardrails', () {
    test('No production AdMob publisher IDs exist in repository', () {
      final rootDir = Directory.current;
      final allowedTestPublisherId = '3940256099942544';
      final pubIdPattern = RegExp(r'pub-(\d{10,20})');

      final violations = <String>[];

      void scanDirectory(Directory dir) {
        for (final entity in dir.listSync(followLinks: false)) {
          final path = entity.path.replaceAll(r'\', '/');
          final name = entity.uri.pathSegments.isNotEmpty
              ? entity.uri.pathSegments.reversed.skip(1).first
              : '';

          if (entity is Directory) {
            if (name == '.git' ||
                name == 'build' ||
                name == '.dart_tool' ||
                name == '.gradle' ||
                name == '.idea') {
              continue;
            }
            scanDirectory(entity);
          } else if (entity is File) {
            if (path.contains('/test/ads/no_real_ad_ids_test.dart') ||
                path.endsWith('release_ads.json') ||
                path.endsWith('.png') ||
                path.endsWith('.apk') ||
                path.endsWith('.aab') ||
                path.endsWith('.jar') ||
                path.endsWith('.so') ||
                path.endsWith('.keystore')) {
              continue;
            }

            try {
              final content = entity.readAsStringSync();
              final matches = pubIdPattern.allMatches(content);
              for (final m in matches) {
                final idNumber = m.group(1);
                if (idNumber != allowedTestPublisherId) {
                  violations.add(
                    'Found unauthorized AdMob ID "pub-$idNumber" in $path',
                  );
                }
              }
            } catch (_) {
              // Skip binary files or unreadable encodings
            }
          }
        }
      }

      scanDirectory(rootDir);

      expect(
        violations,
        isEmpty,
        reason: 'Repository must not contain production AdMob publisher IDs:\n${violations.join('\n')}',
      );
    });

    test('Release mode with empty unit IDs yields disabled ads (no requests)', () {
      AdConfig.forceReleaseModeForTesting = true;

      try {
        expect(AdConfig.getAdUnitId(AdType.banner), isEmpty);
        expect(AdConfig.getAdUnitId(AdType.native), isEmpty);
        expect(AdConfig.getAdUnitId(AdType.interstitial), isEmpty);

        expect(AdConfig.isAdEnabled(AdType.banner), isFalse);
        expect(AdConfig.isAdEnabled(AdType.native), isFalse);
        expect(AdConfig.isAdEnabled(AdType.interstitial), isFalse);
      } finally {
        AdConfig.forceReleaseModeForTesting = null;
      }
    });

    test('Debug mode uses Google public test IDs', () {
      AdConfig.forceReleaseModeForTesting = false;

      try {
        expect(
          AdConfig.getAdUnitId(AdType.banner),
          equals('ca-app-pub-3940256099942544/6300978111'),
        );
        expect(
          AdConfig.getAdUnitId(AdType.native),
          equals('ca-app-pub-3940256099942544/2247696110'),
        );
        expect(
          AdConfig.getAdUnitId(AdType.interstitial),
          equals('ca-app-pub-3940256099942544/1033173712'),
        );

        expect(AdConfig.isAdEnabled(AdType.banner), isTrue);
        expect(AdConfig.isAdEnabled(AdType.native), isTrue);
        expect(AdConfig.isAdEnabled(AdType.interstitial), isTrue);
      } finally {
        AdConfig.forceReleaseModeForTesting = null;
      }
    });
  });
}
