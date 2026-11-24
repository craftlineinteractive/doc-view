import 'package:docview/core/config/iap_config.dart';
import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/models/doc_file.dart';
import 'package:docview/data/services/billing/billing_providers.dart';
import 'package:docview/data/services/billing/fake_purchase_gateway.dart';
import 'package:docview/data/services/billing/premium_controller.dart';
import 'package:docview/data/services/pdf/pdf_page_edit_service.dart';
import 'package:docview/features/premium/premium_screen.dart';
import 'package:docview/features/tools/tools_screen.dart';
import 'package:docview/features/viewer/pages_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePurchaseGateway fakeGateway;
  late PremiumController premiumController;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    fakeGateway = FakePurchaseGateway();
    final prefs = await SharedPreferences.getInstance();
    premiumController = PremiumController(gateway: fakeGateway, prefs: prefs);
    await Future<void>.delayed(const Duration(milliseconds: 50));
  });

  tearDown(() {
    premiumController.dispose();
  });

  group('PremiumScreen UI and Interaction Tests', () {
    testWidgets('renders crown badge, headline, benefits, 2 plan cards, and sticky CTA', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpApp(
        const PremiumScreen(),
        overrides: [
          purchaseGatewayProvider.overrideWithValue(fakeGateway),
          premiumControllerProvider.overrideWithValue(premiumController),
        ],
      );
      await tester.pumpAndSettle();

      // Crown icon and titles
      expect(find.byType(PremiumScreen), findsOneWidget);
      expect(find.text('Doc View Premium'), findsWidgets);
      expect(find.textContaining('Unlock all editing tools'), findsOneWidget);

      // Benefits list
      expect(find.text('All 5 editing & conversion tools'), findsOneWidget);
      expect(find.text('100% Ad-Free Experience'), findsOneWidget);
      expect(find.text('Unlimited local conversions'), findsOneWidget);
      expect(find.text('100% Private & On-Device'), findsOneWidget);

      // Plan Cards
      expect(find.byKey(const Key('plan_card_yearly')), findsOneWidget);
      expect(find.byKey(const Key('plan_card_monthly')), findsOneWidget);
      expect(find.text('Annual Subscription'), findsOneWidget);
      expect(find.text('BEST VALUE'), findsOneWidget);
      expect(find.text('Monthly Subscription'), findsOneWidget);

      // Default CTA for yearly
      expect(find.byKey(const Key('premium_cta_button')), findsOneWidget);
      expect(find.text('Start 7-Day Free Trial'), findsOneWidget);

      // Legal & Disclaimer
      expect(find.textContaining('Renews automatically'), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('switching to monthly plan changes CTA button text to Subscribe', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpApp(
        const PremiumScreen(),
        overrides: [
          purchaseGatewayProvider.overrideWithValue(fakeGateway),
          premiumControllerProvider.overrideWithValue(premiumController),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Start 7-Day Free Trial'), findsOneWidget);

      // Tap monthly plan card
      await tester.tap(find.byKey(const Key('plan_card_monthly')));
      await tester.pumpAndSettle();

      expect(find.text('Subscribe'), findsOneWidget);

      // Tap back to yearly plan card
      await tester.tap(find.byKey(const Key('plan_card_yearly')));
      await tester.pumpAndSettle();

      expect(find.text('Start 7-Day Free Trial'), findsOneWidget);
    });

    testWidgets('tapping restore purchases calls controller and handles result', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpApp(
        const PremiumScreen(),
        overrides: [
          purchaseGatewayProvider.overrideWithValue(fakeGateway),
          premiumControllerProvider.overrideWithValue(premiumController),
        ],
      );
      await tester.pumpAndSettle();

      final restoreBtn = find.text('Restore Purchases');
      expect(restoreBtn, findsOneWidget);

      await tester.tap(restoreBtn);
      await tester.pumpAndSettle();

      // Free user has no active purchases to restore
      expect(find.text('No active subscriptions found.'), findsOneWidget);
    });

    testWidgets('when user has active subscription, renders active subscriber banner', (tester) async {
      premiumController.setSimulatedState(
        isPremium: true,
        isGracePeriod: false,
        activeProductId: IapConfig.yearlySubscriptionId,
        verifiedAt: DateTime.now(),
      );

      await tester.pumpApp(
        const PremiumScreen(),
        overrides: [
          purchaseGatewayProvider.overrideWithValue(fakeGateway),
          premiumControllerProvider.overrideWithValue(premiumController),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('You are a Premium subscriber'), findsOneWidget);
      expect(find.text('Manage'), findsOneWidget);
    });

    testWidgets('when offline grace period is active, renders grace period banner', (tester) async {
      premiumController.setSimulatedState(
        isPremium: true,
        isGracePeriod: true,
        activeProductId: IapConfig.yearlySubscriptionId,
        verifiedAt: DateTime.now().subtract(const Duration(days: 3)),
      );

      await tester.pumpApp(
        const PremiumScreen(),
        overrides: [
          purchaseGatewayProvider.overrideWithValue(fakeGateway),
          premiumControllerProvider.overrideWithValue(premiumController),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Offline grace period active'), findsOneWidget);
    });
  });

  group('Premium Gating Integration Tests', () {
    testWidgets('ToolsScreen renders gold Crown badges on gated tools for free users', (tester) async {
      premiumController.setSimulatedState(isPremium: false);

      await tester.pumpApp(
        const ToolsScreen(),
        overrides: [
          premiumControllerProvider.overrideWithValue(premiumController),
        ],
      );
      await tester.pumpAndSettle();

      // Top app bar crown button
      expect(find.byKey(const Key('tools_crown_button')), findsOneWidget);

      // Verify badges exist on gated tools
      expect(find.byKey(const Key('tool_crown_badge_pdf_to_word')), findsOneWidget);
      expect(find.byKey(const Key('tool_crown_badge_annotate')), findsOneWidget);
      expect(find.byKey(const Key('tool_crown_badge_add_text')), findsOneWidget);
      expect(find.byKey(const Key('tool_crown_badge_sign')), findsOneWidget);
      expect(find.byKey(const Key('tool_crown_badge_manage_pages')), findsOneWidget);

      // Non-gated tools do NOT have crown badge
      expect(find.byKey(const Key('tool_crown_badge_image_to_pdf')), findsNothing);
      expect(find.byKey(const Key('tool_crown_badge_scan_to_pdf')), findsNothing);
    });

    testWidgets('ToolsScreen hides crown badges when user is premium', (tester) async {
      premiumController.setSimulatedState(
        isPremium: true,
        activeProductId: IapConfig.yearlySubscriptionId,
      );

      await tester.pumpApp(
        const ToolsScreen(),
        overrides: [
          premiumControllerProvider.overrideWithValue(premiumController),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('tool_crown_badge_pdf_to_word')), findsNothing);
      expect(find.byKey(const Key('tool_crown_badge_annotate')), findsNothing);
      expect(find.byKey(const Key('tool_crown_badge_manage_pages')), findsNothing);
    });

    testWidgets('PagesScreen blocks editing actions with upgrade dialog for free users', (tester) async {
      premiumController.setSimulatedState(isPremium: false);

      final dummyFile = DocFile(
        path: '/tmp/test.pdf',
        name: 'test.pdf',
        extension: 'pdf',
        sizeBytes: 1024,
        modified: DateTime(2026, 11, 24),
        category: FileCategory.pdf,
      );

      final dummyPages = [
        const PdfPageEditSpec(sourcePath: '/tmp/test.pdf', sourcePageIndex: 0),
        const PdfPageEditSpec(sourcePath: '/tmp/test.pdf', sourcePageIndex: 1),
      ];

      await tester.pumpApp(
        PagesScreen(file: dummyFile, initialPages: dummyPages),
        overrides: [
          premiumControllerProvider.overrideWithValue(premiumController),
        ],
      );
      await tester.pumpAndSettle();

      // Free user can view page thumbnails and page count
      expect(find.text('2 Pages'), findsOneWidget);

      // Select page 0
      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();

      // Tap Rotate action
      await tester.tap(find.byIcon(Icons.rotate_right_rounded));
      await tester.pumpAndSettle();

      // Upgrade Dialog MUST appear
      expect(find.text('Doc View Premium'), findsOneWidget);
      expect(
        find.text('Reordering, rotating, and deleting pages requires a Premium subscription.'),
        findsOneWidget,
      );
      expect(find.text('Upgrade to Premium'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Reordering, rotating, and deleting pages requires a Premium subscription.'), findsNothing);
    });
  });
}
