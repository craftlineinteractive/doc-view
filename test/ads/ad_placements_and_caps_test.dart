import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:docview/data/services/ads/ad_service.dart';
import 'package:docview/data/services/billing/billing_providers.dart';
import 'package:docview/shared/widgets/ads/ad_placeholders.dart';
import 'package:docview/shared/widgets/navigation/doc_scaffold.dart';
import 'package:docview/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AdConfig.forceReleaseModeForTesting = null;
    AdConfig.showPlaceholders = true;
  });

  tearDown(() {
    AdConfig.forceReleaseModeForTesting = null;
    AdConfig.showPlaceholders = true;
  });

  group('Ad Placements, Collapse & Frequency Capping', () {
    testWidgets('AdBannerSlot collapses to zero height when adsAllowed is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AdBannerSlot(isLoaded: true, adsAllowed: false),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final bannerBox = tester.renderObject(find.byType(AdBannerSlot)) as RenderBox;
      expect(bannerBox.size.height, equals(0.0));
      expect(find.text('AD'), findsNothing);
    });

    testWidgets('AdBannerSlot collapses to zero in release mode with empty ad ID', (tester) async {
      AdConfig.forceReleaseModeForTesting = true; // Simulates release mode (empty ad unit ID)

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isPremiumProvider.overrideWith((ref) => false),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: AdBannerSlot(isLoaded: true),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final bannerBox = tester.renderObject(find.byType(AdBannerSlot)) as RenderBox;
      expect(bannerBox.size.height, equals(0.0));
    });

    testWidgets('NativeAdRow collapses to zero height when adsAllowed is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: NativeAdRow(isLoaded: true, adsAllowed: false),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final nativeBox = tester.renderObject(find.byType(NativeAdRow)) as RenderBox;
      expect(nativeBox.size.height, equals(0.0));
    });

    testWidgets('NativeAdRow collapses in release mode with empty ad ID', (tester) async {
      AdConfig.forceReleaseModeForTesting = true;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isPremiumProvider.overrideWith((ref) => false),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: NativeAdRow(isLoaded: true),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final nativeBox = tester.renderObject(find.byType(NativeAdRow)) as RenderBox;
      expect(nativeBox.size.height, equals(0.0));
    });

    test('Interstitial frequency capping: 3-minute interval and 3-per-day limit', () async {
      final container = ProviderContainer(
        overrides: [
          isPremiumProvider.overrideWith((ref) => false),
        ],
      );

      final adService = container.read(adServiceProvider);

      // Initially eligible
      expect(await adService.canShowInterstitial(), isTrue);

      // Simulate first impression
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final todayStr = '${now.year}-${now.month}-${now.day}';

      await prefs.setInt('ad_interstitial_last_time_ms', now.millisecondsSinceEpoch);
      await prefs.setString('ad_interstitial_daily_date', todayStr);
      await prefs.setInt('ad_interstitial_daily_count', 1);

      // Immediately checking again must be BLOCKED by 3-minute interval
      expect(await adService.canShowInterstitial(), isFalse,
          reason: 'Must enforce minimum 3-minute interval between interstitials');

      // Fast-forward last impression time by 4 minutes
      final pastTime = now.subtract(const Duration(minutes: 4));
      await prefs.setInt('ad_interstitial_last_time_ms', pastTime.millisecondsSinceEpoch);
      expect(await adService.canShowInterstitial(), isTrue);

      // Set daily count to 3 (daily cap reached)
      await prefs.setInt('ad_interstitial_daily_count', 3);
      expect(await adService.canShowInterstitial(), isFalse,
          reason: 'Must enforce maximum 3 interstitials per day cap');
    });

    testWidgets('DocScaffold enforces 16pt clearance padding for FAB above docked banner', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isPremiumProvider.overrideWith((ref) => false),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: DocScaffold(
              showDockedBanner: true,
              isAdLoaded: true,
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
              body: const Center(child: Text('Content')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the Padding widget wrapping the FAB
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      final paddingAncestor = find.ancestor(
        of: fabFinder,
        matching: find.byType(Padding),
      );
      expect(paddingAncestor, findsWidgets);

      final paddingWidget = tester.widget<Padding>(paddingAncestor.first);
      expect((paddingWidget.padding as EdgeInsets).bottom, equals(16.0));
    });

    testWidgets('AdBannerSlot height is strictly <= 64 dp at 360 dp and 393 dp viewport widths', (tester) async {
      for (final width in [360.0, 393.0]) {
        tester.view.physicalSize = Size(width * 2.0, 800 * 2.0);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(
          const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: AdBannerSlot(isLoaded: true),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final bannerBox = tester.renderObject(find.byType(AdBannerSlot)) as RenderBox;
        expect(bannerBox.size.height, lessThanOrEqualTo(64.0));
        expect(bannerBox.size.height, equals(60.0));
      }
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });

    test('PREMIUM USERS NEVER INITIALIZE THE ADS SDK: AdService aborts early without calling MobileAds initialize', () async {
      final container = ProviderContainer(
        overrides: [
          isPremiumProvider.overrideWith((ref) => true),
        ],
      );
      addTearDown(container.dispose);

      final adService = AdService(container.read(Provider((ref) => ref)));
      expect(adService.isSdkInitialized, isFalse);

      await adService.initializeSdkIfAllowed();

      // Invariant: Must remain uninitialized for premium users
      expect(adService.isSdkInitialized, isFalse);
    });
  });
}
