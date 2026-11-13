import 'package:docview/core/theme/app_theme.dart';
import 'package:docview/features/home/home_screen.dart';
import 'package:docview/features/onboarding/onboarding_screen.dart';
import 'package:docview/features/permissions/permissions_screen.dart';
import 'package:docview/features/splash/splash_screen.dart';
import 'package:docview/features/tools/tools_screen.dart';
import 'package:docview/shared/widgets/ads/ad_placeholders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AdConfig.showPlaceholders = true;
  });

  tearDown(() {
    AdConfig.showPlaceholders = true;
  });

  group('Ad Placement & Clearance Tests', () {
    testWidgets('Ad-free screens contain zero ad placeholder widgets', (tester) async {
      tester.view.physicalSize = const Size(393 * 2, 852 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // 1. Splash Screen
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SplashScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AdBannerSlot), findsNothing);
      expect(find.byType(NativeAdRow), findsNothing);
      expect(find.byType(NativeAdCard), findsNothing);

      // 2. Onboarding Screen
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AdBannerSlot), findsNothing);
      expect(find.byType(NativeAdRow), findsNothing);

      // 3. Permissions Screen
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const PermissionsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AdBannerSlot), findsNothing);
      expect(find.byType(NativeAdRow), findsNothing);
    });

    testWidgets('Release collapse: Ad placeholders collapse to zero size when showPlaceholders is false', (tester) async {
      AdConfig.showPlaceholders = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Column(
              children: [
                const Text('Before Ad'),
                const AdBannerSlot(),
                const NativeAdRow(
                  ad: AdPlaceholderModel(
                    title: 'Test Ad',
                    description: 'Test description',
                    ctaLabel: 'Install',
                    icon: Icons.star,
                  ),
                ),
                const NativeAdCard(
                  ad: AdPlaceholderModel(
                    title: 'Card Ad',
                    description: 'Card desc',
                    ctaLabel: 'Open',
                    icon: Icons.star,
                  ),
                ),
                const Text('After Ad'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final bannerRenderBox = tester.renderObject<RenderBox>(find.byType(AdBannerSlot));
      expect(bannerRenderBox.size, equals(Size.zero));

      final rowRenderBox = tester.renderObject<RenderBox>(find.byType(NativeAdRow));
      expect(rowRenderBox.size, equals(Size.zero));

      final cardRenderBox = tester.renderObject<RenderBox>(find.byType(NativeAdCard));
      expect(cardRenderBox.size, equals(Size.zero));
    });

    testWidgets('Home and Tools screens render docked AdBannerSlot when placeholders enabled', (tester) async {
      tester.view.physicalSize = const Size(393 * 2, 852 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Home Screen
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AdBannerSlot), findsOneWidget);

      // Tools Screen
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ToolsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AdBannerSlot), findsOneWidget);
    });
  });
}

