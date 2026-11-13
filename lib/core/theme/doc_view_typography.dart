import 'package:flutter/material.dart';

/// Exact typography styles defined in docs/redesign/01_design_tokens.md.
/// Space Grotesk for headings; Inter for metadata, labels, and body copy.
abstract final class DocViewTypography {
  static const String fontSpaceGrotesk = 'Space Grotesk';
  static const String fontInter = 'Inter';

  // --- Space Grotesk (Headings) ---
  static const TextStyle headlineXl = TextStyle(
    fontFamily: fontSpaceGrotesk,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 38 / 32,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineLg = TextStyle(
    fontFamily: fontSpaceGrotesk,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 30 / 24,
    letterSpacing: -0.25,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: fontSpaceGrotesk,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    letterSpacing: 0.0,
  );

  // --- Inter (Titles, Labels, Body) ---
  static const TextStyle titleMd = TextStyle(
    fontFamily: fontInter,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 22 / 16,
    letterSpacing: 0.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle labelLg = TextStyle(
    fontFamily: fontInter,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 20 / 15,
    letterSpacing: 0.0,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: fontInter,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 18 / 13,
    letterSpacing: 0.0,
  );

  static const TextStyle labelXs = TextStyle(
    fontFamily: fontInter,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 14 / 11,
    letterSpacing: 0.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: fontInter,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 18 / 13,
    letterSpacing: 0.0,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontFamily: fontInter,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontInter,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 22 / 15,
    letterSpacing: 0.0,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontInter,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 18 / 13,
    letterSpacing: 0.0,
  );

  static const TextStyle bodyMedium = bodyMd;

  static const TextStyle bodySm = TextStyle(
    fontFamily: fontInter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle captionXs = TextStyle(
    fontFamily: fontInter,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 12 / 10,
    letterSpacing: 0.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

