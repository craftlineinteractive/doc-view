import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Zero Price Literals Guardrail Test: no hardcoded prices or currency in code/ARB', () {
    final violations = <String>[];

    // Regex to detect price patterns like: $4.99, €9.99, ₹499, £2.99, 4.99 USD, etc.
    final priceRegex = RegExp(
      r'([$€₹£¥]\s*\d+([.,]\d{1,2})?)|(\d+([.,]\d{1,2})\s*(USD|EUR|INR|GBP|CAD|AUD))',
      caseSensitive: false,
    );

    // Scan lib/
    final libDir = Directory('lib');
    if (libDir.existsSync()) {
      for (final file in libDir.listSync(recursive: true).whereType<File>()) {
        if (!file.path.endsWith('.dart') && !file.path.endsWith('.arb')) continue;
        final lines = file.readAsLinesSync();
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          // Skip comments
          final trimmed = line.trim();
          if (trimmed.startsWith('//') || trimmed.startsWith('///')) continue;

          // Check for price matches
          final matches = priceRegex.allMatches(line);
          for (final match in matches) {
            // Check if it's a false positive (e.g. regex string definition or code variable like $1 or $2 or string interpolation)
            final matchText = match.group(0)!;
            if (line.contains('RegExp') || line.contains('r\'') || line.contains('r"')) continue;
            if (matchText.startsWith(r'$') && RegExp(r'^\$[a-zA-Z_]').hasMatch(matchText)) continue;

            violations.add('${file.path}:${i + 1}: Found hardcoded price literal "$matchText" in: $trimmed');
          }
        }
      }
    }

    // Scan docs/release/iap_products.txt (only product IDs, no price literals)
    final iapProductsFile = File('docs/release/iap_products.txt');
    if (iapProductsFile.existsSync()) {
      final lines = iapProductsFile.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (priceRegex.hasMatch(line)) {
          violations.add('docs/release/iap_products.txt:${i + 1}: Found price literal in product config: $line');
        }
      }
    }

    if (violations.isNotEmpty) {
      fail('Zero Price Literals Policy Violation:\n'
          'Prices must dynamically originate from the store gateway (ProductDetails.price).\n'
          'Hardcoded prices, currencies, and amounts are strictly forbidden.\n'
          '${violations.join('\n')}');
    }

    expect(violations, isEmpty, reason: 'Zero hardcoded price literals permitted across lib/ and ARB files.');
  });
}
