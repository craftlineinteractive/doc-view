import 'package:flutter/material.dart';
import '../../../core/constants/file_types.dart';
import '../../../core/theme/doc_view_colors.dart';
import 'doc_folded_icon.dart';

/// Supported sizes for [FileTypeBadge].
enum BadgeSize {
  small(24, 18, 8, 3),
  medium(34, 22, 9, 4),
  large(48, 56, 9, 10);

  final double width;
  final double height;
  final double fontSize;
  final double radius;

  const BadgeSize(this.width, this.height, this.fontSize, this.radius);
}

/// Precision document format badge matching mockups.
/// For [BadgeSize.large] (48x56), renders a realistic mini document card with
/// folded top-right corner and centered format name.
/// For smaller sizes, renders a standalone format pill.
class FileTypeBadge extends StatelessWidget {
  final FileCategory category;
  final BadgeSize size;
  final String? customLabel;

  const FileTypeBadge({
    super.key,
    required this.category,
    this.size = BadgeSize.medium,
    this.customLabel,
  });

  String _formatTag() {
    if (customLabel != null) return customLabel!;
    switch (category) {
      case FileCategory.pdf:
        return 'PDF';
      case FileCategory.word:
        return 'DOCX';
      case FileCategory.excel:
        return 'XLSX';
      case FileCategory.ppt:
        return 'PPT';
      case FileCategory.txt:
        return 'TXT';
      case FileCategory.image:
        return 'IMG';
      case FileCategory.other:
        return 'FILE';
    }
  }

  Color _formatColor() {
    switch (category) {
      case FileCategory.pdf:
        return DocViewColors.pdfSolid;
      case FileCategory.word:
        return DocViewColors.wordSolid;
      case FileCategory.excel:
        return DocViewColors.excelSolid;
      case FileCategory.ppt:
        return DocViewColors.pptSolid;
      case FileCategory.txt:
        return DocViewColors.txtSolid;
      case FileCategory.image:
        return DocViewColors.imageSolid;
      case FileCategory.other:
        return DocViewColors.txtSolid;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatTag = _formatTag();
    final formatColor = _formatColor();

    if (size != BadgeSize.large) {
      // Small/medium compact pill badge
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: formatColor,
          borderRadius: BorderRadius.circular(size.radius),
        ),
        child: Text(
          formatTag,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
            height: 1.0,
          ),
        ),
      );
    }

    // Large format renders the document icon with folded top-right corner
    return DocFoldedIcon(
      category: category,
      label: formatTag,
      width: size.width,
      height: size.height,
      borderRadius: size.radius,
    );
  }
}
