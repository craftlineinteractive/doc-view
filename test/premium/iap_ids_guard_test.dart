import 'dart:io';

import 'package:docview/core/config/iap_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IAP-ID Guardrails & Consistency Tests', () {
    test('Exact product ID is docview_premium and exactly one product exists', () {
      expect(IapConfig.subscriptionProductId, 'docview_premium');
      expect(IapConfig.subscriptionProductIds, {'docview_premium'});
      expect(IapConfig.subscriptionProductIds.length, 1);
    });

    test('Exact base plan IDs are yearly and monthly', () {
      expect(IapConfig.yearlyBasePlanId, 'yearly');
      expect(IapConfig.monthlyBasePlanId, 'monthly');
    });

    test('Exact free trial offer ID is freetrial-7d', () {
      expect(IapConfig.freeTrialOfferId, 'freetrial-7d');
    });

    test('Exact billing periods are P1Y and P1M', () {
      expect(IapConfig.periodYearly, 'P1Y');
      expect(IapConfig.periodMonthly, 'P1M');
    });

    test('docs/release/iap_products.txt matches exact IAP structure and IDs', () {
      final file = File('docs/release/iap_products.txt');
      expect(file.existsSync(), isTrue, reason: 'docs/release/iap_products.txt must exist');

      final content = file.readAsStringSync();
      expect(content, contains('Product ID: docview_premium'));
      expect(content, contains('Base Plan ID: yearly'));
      expect(content, contains('Base Plan ID: monthly'));
      expect(content, contains('Billing Period: P1Y'));
      expect(content, contains('Billing Period: P1M'));
      expect(content, contains('Offer ID: freetrial-7d'));
    });

    test('No unauthorized IAP product identifiers or base plan identifiers exist in lib/', () {
      final libDir = Directory('lib');
      final forbiddenProductIds = [
        'docview_pro',
        'docview_sub',
        'doc_view_premium',
        'lifetime',
        'weekly',
        'quarterly',
      ];

      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          final text = entity.readAsStringSync();
          for (final forbidden in forbiddenProductIds) {
            expect(
              text.contains("'$forbidden'") || text.contains('"$forbidden"'),
              isFalse,
              reason: 'Found forbidden IAP identifier "$forbidden" in ${entity.path}',
            );
          }
        }
      }
    });
  });
}
