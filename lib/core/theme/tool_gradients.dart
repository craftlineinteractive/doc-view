import 'package:flutter/material.dart';

/// Design system linear gradients for Tools tab icons and tool badges.
abstract final class ToolGradients {
  /// Warm gold to crimson gradient for Image to PDF tool.
  static const LinearGradient imageToPdf = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB300), Color(0xFFE02B2B)],
  );

  /// Cyan to teal gradient for Scan to PDF tool.
  static const LinearGradient scanToPdf = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00BCD4), Color(0xFF009688)],
  );

  /// Indigo to royal blue gradient for Manage Pages tool.
  static const LinearGradient managePages = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
  );

  /// Azure to deep blue gradient for Merge PDF tool.
  static const LinearGradient mergePdf = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
  );

  /// Emerald to forest green gradient for Split PDF tool.
  static const LinearGradient splitPdf = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E9E4F), Color(0xFF0E622F)],
  );

  /// Sky blue to cerulean gradient for Import Files tool.
  static const LinearGradient importFiles = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
  );

  /// Slate to charcoal gradient for Print PDF tool.
  static const LinearGradient printPdf = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF64748B), Color(0xFF334155)],
  );

  /// Amber to dark orange gradient for Create PDF tool (Phase G4b).
  static const LinearGradient createPdf = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
  );

  /// Cool gray gradient for Recycle Bin tool (Phase G4c).
  static const LinearGradient recycleBin = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF94A3B8), Color(0xFF64748B)],
  );

  /// Pink to deep rose gradient for Annotate tool (Phase G5).
  static const LinearGradient annotate = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
  );

  /// Purple to violet gradient for Add Text tool (Phase G5).
  static const LinearGradient addText = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
  );

  /// Deep teal gradient for Sign tool (Phase G5).
  static const LinearGradient sign = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
  );

  /// Word cobalt blue gradient for Word to PDF conversion (Phase G6).
  static const LinearGradient wordToPdf = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
  );

  /// PowerPoint rust amber gradient for PPT to PDF conversion (Phase G6).
  static const LinearGradient pptToPdf = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD97706), Color(0xFFB45309)],
  );
}
