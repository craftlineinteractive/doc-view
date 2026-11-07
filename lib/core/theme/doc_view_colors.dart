import 'package:flutter/material.dart';

/// Exact color tokens defined in docs/redesign/01_design_tokens.md
abstract final class DocViewColors {
  // --- Light Palette ---
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color headerGradientStartLight = Color(0xFFE9F2FF);
  static const Color headerGradientEndLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF3F5FA);
  static const Color surfaceHoverLight = Color(0xFFE9EDF6);
  static const Color surfaceAltLight = Color(0xFFF8FAFD);
  static const Color dividerBandLight = Color(0xFFF1F3F8);
  static const Color hairlineLight = Color(0xFFE6E9F0);
  static const Color textPrimaryLight = Color(0xFF11141C);
  static const Color textSecondaryLight = Color(0xFF8A8F9C);
  static const Color sectionHeaderLight = Color(0xFF8A94AE);
  static const Color primaryBlue = Color(0xFF1A66E8);
  static const Color interactiveBlue = Color(0xFF2F7BEA);
  static const Color blueTintLight = Color(0xFFE8F0FE);
  static const Color sheetScrimLight = Color(0x7311141C); // rgba(17, 20, 28, 0.45)
  static const Color readerCanvasLight = Color(0xFFEEF0F5);
  static const Color skeletonBaseLight = Color(0xFFE9EDF5);
  static const Color skeletonHighlightLight = Color(0xFFF5F7FB);

  // --- Dark Palette (Deep Navy) ---
  static const Color backgroundDark = Color(0xFF1A1D29);
  static const Color headerGradientStartDark = Color(0xFF1E2333);
  static const Color headerGradientEndDark = Color(0xFF1A1D29);
  static const Color surfaceDark = Color(0xFF232838);
  static const Color surfaceHoverDark = Color(0xFF2B3144);
  static const Color surfaceAltDark = Color(0xFF1E2333);
  static const Color dividerBandDark = Color(0xFF141722);
  static const Color hairlineDark = Color(0xFF2A3042);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF858B9C);
  static const Color sectionHeaderDark = Color(0xFF7F8AA8);
  static const Color primaryButtonDark = Color(0xFF1A66E8);
  static const Color activeBlueDark = Color(0xFF4D8FF7);
  static const Color blueTintDark = Color(0xFF1E2A45);
  static const Color sheetScrimDark = Color(0xA60A0C12); // rgba(10, 12, 18, 0.65)
  static const Color readerCanvasDark = Color(0xFF11131B);
  static const Color skeletonBaseDark = Color(0xFF262B3A);
  static const Color skeletonHighlightDark = Color(0xFF30364A);

  // --- File Type Signifiers ---
  static const Color pdfSolid = Color(0xFFE02B2B);
  static const Color pdfTintLight = Color(0xFFFDE8E8);
  static const Color pdfTintDark = Color(0xFF3A1E22);

  static const Color wordSolid = Color(0xFF1E5FD8);
  static const Color wordTintLight = Color(0xFFEDF3FD);
  static const Color wordTintDark = Color(0xFF1B2A4A);

  static const Color excelSolid = Color(0xFF1E9E4F);
  static const Color excelTintLight = Color(0xFFEEF9F2);
  static const Color excelTintDark = Color(0xFF173324);

  static const Color pptSolid = Color(0xFFF26B1D);
  static const Color pptTintLight = Color(0xFFFEF0E8);
  static const Color pptTintDark = Color(0xFF38251B);

  static const Color txtSolid = Color(0xFF5B6B9A);
  static const Color txtTintLight = Color(0xFFEFF1F7);
  static const Color txtTintDark = Color(0xFF242838);

  static const Color imageSolid = Color(0xFFFFA000);
  static const Color imageTintLight = Color(0xFFFFF8E6);
  static const Color imageTintDark = Color(0xFF38311B);

  static const Color folderSolid = Color(0xFF2F7BEA);
  static const Color folderTintLight = Color(0xFFE8F0FE);
  static const Color folderTintDark = Color(0xFF1E2A45);

  // --- Semantic Feedback ---
  static const Color success = Color(0xFF1FA971);
  static const Color successTintLight = Color(0xFFE8F8F0);
  static const Color successTintDark = Color(0xFF1B3B2B);

  static const Color warning = Color(0xFFF5A524);
  static const Color warningTintLight = Color(0xFFFEF6E9);
  static const Color warningTintDark = Color(0xFF3A2E19);

  static const Color error = Color(0xFFE5484D);
  static const Color errorTintLight = Color(0xFFFDE8E9);
  static const Color errorTintDark = Color(0xFF3E1C1E);
}

