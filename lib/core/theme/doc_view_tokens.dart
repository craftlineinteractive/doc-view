import 'package:flutter/material.dart';
import '../constants/file_types.dart';
import 'doc_view_colors.dart';

/// Semantic colors for a specific file type category.
@immutable
class FileTypeColors {
  final Color solid;
  final Color tint;

  const FileTypeColors({
    required this.solid,
    required this.tint,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileTypeColors &&
          runtimeType == other.runtimeType &&
          solid == other.solid &&
          tint == other.tint;

  @override
  int get hashCode => Object.hash(solid, tint);
}

/// ThemeExtension providing custom semantic tokens across Doc View.
@immutable
class DocViewTokens extends ThemeExtension<DocViewTokens> {
  final Color surface;
  final Color surfaceHover;
  final Color surfaceAlt;
  final Color dividerBand;
  final Color hairline;
  final Color textPrimary;
  final Color textSecondary;
  final Color sectionHeader;
  final Color primaryBlue;
  final Color interactiveBlue;
  final Color blueTint;
  final Color sheetScrim;
  final Color readerCanvas;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color headerGradientStart;
  final Color headerGradientEnd;

  // File type semantic mapping
  final FileTypeColors pdf;
  final FileTypeColors word;
  final FileTypeColors excel;
  final FileTypeColors ppt;
  final FileTypeColors txt;
  final FileTypeColors image;
  final FileTypeColors folder;
  final FileTypeColors other;

  Color get error => DocViewColors.error;

  const DocViewTokens({
    required this.surface,
    required this.surfaceHover,
    required this.surfaceAlt,
    required this.dividerBand,
    required this.hairline,
    required this.textPrimary,
    required this.textSecondary,
    required this.sectionHeader,
    required this.primaryBlue,
    required this.interactiveBlue,
    required this.blueTint,
    required this.sheetScrim,
    required this.readerCanvas,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.headerGradientStart,
    required this.headerGradientEnd,
    required this.pdf,
    required this.word,
    required this.excel,
    required this.ppt,
    required this.txt,
    required this.image,
    required this.folder,
    required this.other,
  });

  /// Light theme preset tokens.
  static const DocViewTokens light = DocViewTokens(
    surface: DocViewColors.surfaceLight,
    surfaceHover: DocViewColors.surfaceHoverLight,
    surfaceAlt: DocViewColors.surfaceAltLight,
    dividerBand: DocViewColors.dividerBandLight,
    hairline: DocViewColors.hairlineLight,
    textPrimary: DocViewColors.textPrimaryLight,
    textSecondary: DocViewColors.textSecondaryLight,
    sectionHeader: DocViewColors.sectionHeaderLight,
    primaryBlue: DocViewColors.primaryBlue,
    interactiveBlue: DocViewColors.interactiveBlue,
    blueTint: DocViewColors.blueTintLight,
    sheetScrim: DocViewColors.sheetScrimLight,
    readerCanvas: DocViewColors.readerCanvasLight,
    shimmerBase: DocViewColors.skeletonBaseLight,
    shimmerHighlight: DocViewColors.skeletonHighlightLight,
    headerGradientStart: DocViewColors.headerGradientStartLight,
    headerGradientEnd: DocViewColors.headerGradientEndLight,
    pdf: FileTypeColors(solid: DocViewColors.pdfSolid, tint: DocViewColors.pdfTintLight),
    word: FileTypeColors(solid: DocViewColors.wordSolid, tint: DocViewColors.wordTintLight),
    excel: FileTypeColors(solid: DocViewColors.excelSolid, tint: DocViewColors.excelTintLight),
    ppt: FileTypeColors(solid: DocViewColors.pptSolid, tint: DocViewColors.pptTintLight),
    txt: FileTypeColors(solid: DocViewColors.txtSolid, tint: DocViewColors.txtTintLight),
    image: FileTypeColors(solid: DocViewColors.imageSolid, tint: DocViewColors.imageTintLight),
    folder: FileTypeColors(solid: DocViewColors.folderSolid, tint: DocViewColors.folderTintLight),
    other: FileTypeColors(solid: DocViewColors.txtSolid, tint: DocViewColors.txtTintLight),
  );

  /// Dark theme preset tokens (Deep Navy).
  static const DocViewTokens dark = DocViewTokens(
    surface: DocViewColors.surfaceDark,
    surfaceHover: DocViewColors.surfaceHoverDark,
    surfaceAlt: DocViewColors.surfaceAltDark,
    dividerBand: DocViewColors.dividerBandDark,
    hairline: DocViewColors.hairlineDark,
    textPrimary: DocViewColors.textPrimaryDark,
    textSecondary: DocViewColors.textSecondaryDark,
    sectionHeader: DocViewColors.sectionHeaderDark,
    primaryBlue: DocViewColors.primaryButtonDark,
    interactiveBlue: DocViewColors.activeBlueDark,
    blueTint: DocViewColors.blueTintDark,
    sheetScrim: DocViewColors.sheetScrimDark,
    readerCanvas: DocViewColors.readerCanvasDark,
    shimmerBase: DocViewColors.skeletonBaseDark,
    shimmerHighlight: DocViewColors.skeletonHighlightDark,
    headerGradientStart: DocViewColors.headerGradientStartDark,
    headerGradientEnd: DocViewColors.headerGradientEndDark,
    pdf: FileTypeColors(solid: DocViewColors.pdfSolid, tint: DocViewColors.pdfTintDark),
    word: FileTypeColors(solid: DocViewColors.wordSolid, tint: DocViewColors.wordTintDark),
    excel: FileTypeColors(solid: DocViewColors.excelSolid, tint: DocViewColors.excelTintDark),
    ppt: FileTypeColors(solid: DocViewColors.pptSolid, tint: DocViewColors.pptTintDark),
    txt: FileTypeColors(solid: DocViewColors.txtSolid, tint: DocViewColors.txtTintDark),
    image: FileTypeColors(solid: DocViewColors.imageSolid, tint: DocViewColors.imageTintDark),
    folder: FileTypeColors(solid: DocViewColors.folderSolid, tint: DocViewColors.folderTintDark),
    other: FileTypeColors(solid: DocViewColors.txtSolid, tint: DocViewColors.txtTintDark),
  );

  /// Helper to get colors for a given [FileCategory].
  FileTypeColors categoryColors(FileCategory category) {
    switch (category) {
      case FileCategory.pdf:
        return pdf;
      case FileCategory.word:
        return word;
      case FileCategory.excel:
        return excel;
      case FileCategory.ppt:
        return ppt;
      case FileCategory.txt:
        return txt;
      case FileCategory.image:
        return image;
      case FileCategory.other:
        return other;
    }
  }

  @override
  DocViewTokens copyWith({
    Color? surface,
    Color? surfaceHover,
    Color? surfaceAlt,
    Color? dividerBand,
    Color? hairline,
    Color? textPrimary,
    Color? textSecondary,
    Color? sectionHeader,
    Color? primaryBlue,
    Color? interactiveBlue,
    Color? blueTint,
    Color? sheetScrim,
    Color? readerCanvas,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? headerGradientStart,
    Color? headerGradientEnd,
    FileTypeColors? pdf,
    FileTypeColors? word,
    FileTypeColors? excel,
    FileTypeColors? ppt,
    FileTypeColors? txt,
    FileTypeColors? image,
    FileTypeColors? folder,
    FileTypeColors? other,
  }) {
    return DocViewTokens(
      surface: surface ?? this.surface,
      surfaceHover: surfaceHover ?? this.surfaceHover,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      dividerBand: dividerBand ?? this.dividerBand,
      hairline: hairline ?? this.hairline,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      sectionHeader: sectionHeader ?? this.sectionHeader,
      primaryBlue: primaryBlue ?? this.primaryBlue,
      interactiveBlue: interactiveBlue ?? this.interactiveBlue,
      blueTint: blueTint ?? this.blueTint,
      sheetScrim: sheetScrim ?? this.sheetScrim,
      readerCanvas: readerCanvas ?? this.readerCanvas,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      headerGradientStart: headerGradientStart ?? this.headerGradientStart,
      headerGradientEnd: headerGradientEnd ?? this.headerGradientEnd,
      pdf: pdf ?? this.pdf,
      word: word ?? this.word,
      excel: excel ?? this.excel,
      ppt: ppt ?? this.ppt,
      txt: txt ?? this.txt,
      image: image ?? this.image,
      folder: folder ?? this.folder,
      other: other ?? this.other,
    );
  }

  @override
  DocViewTokens lerp(ThemeExtension<DocViewTokens>? other, double t) {
    if (other is! DocViewTokens) return this;
    return DocViewTokens(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceHover: Color.lerp(surfaceHover, other.surfaceHover, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      dividerBand: Color.lerp(dividerBand, other.dividerBand, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      sectionHeader: Color.lerp(sectionHeader, other.sectionHeader, t)!,
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t)!,
      interactiveBlue: Color.lerp(interactiveBlue, other.interactiveBlue, t)!,
      blueTint: Color.lerp(blueTint, other.blueTint, t)!,
      sheetScrim: Color.lerp(sheetScrim, other.sheetScrim, t)!,
      readerCanvas: Color.lerp(readerCanvas, other.readerCanvas, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      headerGradientStart: Color.lerp(headerGradientStart, other.headerGradientStart, t)!,
      headerGradientEnd: Color.lerp(headerGradientEnd, other.headerGradientEnd, t)!,
      pdf: FileTypeColors(
        solid: Color.lerp(pdf.solid, other.pdf.solid, t)!,
        tint: Color.lerp(pdf.tint, other.pdf.tint, t)!,
      ),
      word: FileTypeColors(
        solid: Color.lerp(word.solid, other.word.solid, t)!,
        tint: Color.lerp(word.tint, other.word.tint, t)!,
      ),
      excel: FileTypeColors(
        solid: Color.lerp(excel.solid, other.excel.solid, t)!,
        tint: Color.lerp(excel.tint, other.excel.tint, t)!,
      ),
      ppt: FileTypeColors(
        solid: Color.lerp(ppt.solid, other.ppt.solid, t)!,
        tint: Color.lerp(ppt.tint, other.ppt.tint, t)!,
      ),
      txt: FileTypeColors(
        solid: Color.lerp(txt.solid, other.txt.solid, t)!,
        tint: Color.lerp(txt.tint, other.txt.tint, t)!,
      ),
      image: FileTypeColors(
        solid: Color.lerp(image.solid, other.image.solid, t)!,
        tint: Color.lerp(image.tint, other.image.tint, t)!,
      ),
      folder: FileTypeColors(
        solid: Color.lerp(folder.solid, other.folder.solid, t)!,
        tint: Color.lerp(folder.tint, other.folder.tint, t)!,
      ),
      other: FileTypeColors(
        solid: Color.lerp(this.other.solid, other.other.solid, t)!,
        tint: Color.lerp(this.other.tint, other.other.tint, t)!,
      ),
    );
  }
}

/// Convenience extension on [BuildContext] to access [DocViewTokens].
extension DocViewTokensExtension on BuildContext {
  DocViewTokens get tokens {
    final t = Theme.of(this).extension<DocViewTokens>();
    if (t != null) return t;
    return Theme.of(this).brightness == Brightness.dark
        ? DocViewTokens.dark
        : DocViewTokens.light;
  }
}
