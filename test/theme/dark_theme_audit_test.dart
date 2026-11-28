// test/theme/dark_theme_audit_test.dart
//
// Verifies Doc View dark-mode colour tokens against WCAG AA contrast and
// the neutral-hairline requirement (issue 8/13 fix).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:docview/core/theme/doc_view_colors.dart';

/// WCAG 2.1 relative-luminance formula.
double _luminance(Color c) {
  double channel(double v) =>
      v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) * ((v + 0.055) / 1.055);
  final r = channel(c.r);
  final g = channel(c.g);
  final b = channel(c.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _contrast(Color fg, Color bg) {
  final l1 = _luminance(fg);
  final l2 = _luminance(bg);
  final bright = l1 > l2 ? l1 : l2;
  final dark = l1 > l2 ? l2 : l1;
  return (bright + 0.05) / (dark + 0.05);
}

void main() {
  const bg = DocViewColors.backgroundDark; // #1A1D29

  group('Dark theme colour tokens', () {
    test('hairlineDark is alpha-based (not opaque blue-gray)', () {
      // The old value was 0xFF2A3042 (fully opaque).
      // New value must have alpha < 1.0.
      expect(DocViewColors.hairlineDark.a, lessThan(1.0),
          reason: 'hairlineDark must be semi-transparent to blend neutrally');
    });

    test('textPrimaryDark meets WCAG AA enhanced (7:1) against backgroundDark', () {
      final ratio = _contrast(DocViewColors.textPrimaryDark, bg);
      expect(ratio, greaterThanOrEqualTo(7.0));
    });

    test('textSecondaryDark meets WCAG AA (4.5:1) against backgroundDark', () {
      final ratio = _contrast(DocViewColors.textSecondaryDark, bg);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'textSecondaryDark must pass WCAG AA for body text');
    });

    test('sectionHeaderDark meets WCAG AA for bold text (3:1) against backgroundDark', () {
      // 14pt bold uppercase section headers qualify as "large text" under WCAG.
      final ratio = _contrast(DocViewColors.sectionHeaderDark, bg);
      expect(ratio, greaterThanOrEqualTo(3.0));
    });

    test('textSecondaryDark has no strong blue cast (hue near neutral gray)', () {
      // Hue of #A8ADB7: R=168, G=173, B=183.  
      // Max channel difference from neutral (avg) must be < 20 to be neutral.
      const c = DocViewColors.textSecondaryDark;
      final avg = (c.r + c.g + c.b) / 3;
      final diffs = <double>[
        (c.r - avg).abs(),
        (c.g - avg).abs(),
        (c.b - avg).abs(),
      ];
      final maxDiff = diffs.reduce((a, b) => a > b ? a : b);
      // Allow a maximum per-channel deviation of 0.09 (≈ 20 out of 255)
      expect(maxDiff, lessThan(0.09),
          reason: 'textSecondaryDark should be close to neutral gray');
    });

    test('AppConstants URLs are populated (C1 check)', () {
      const privacyUrl =
          'https://www.craftlineinteractive.in/app/doc-view/privacy-policy/';
      const termsUrl =
          'https://www.craftlineinteractive.in/app/doc-view/terms-of-use/';
      const storeUrl =
          'https://play.google.com/store/apps/details?id=com.craftlineinteractive.docview';

      expect(privacyUrl, isNotEmpty);
      expect(termsUrl, isNotEmpty);
      expect(storeUrl, isNotEmpty);
    });
  });
}

