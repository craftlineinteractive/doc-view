import 'package:flutter/material.dart';
import '../../../core/constants/file_types.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';

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
/// format-specific preview strokes and an anchored bottom-left format indicator.
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

  Color _cardBackground(DocViewTokens tokens, bool isDark) {
    if (isDark) return tokens.surfaceAlt;
    switch (category) {
      case FileCategory.pdf:
        return Colors.white;
      case FileCategory.word:
        return const Color(0xFFEDF3FD);
      case FileCategory.excel:
        return const Color(0xFFEEF9F2);
      case FileCategory.ppt:
        return const Color(0xFFFFF3EB);
      case FileCategory.txt:
        return const Color(0xFFF1F3F8);
      case FileCategory.image:
        return const Color(0xFFFFF8E6);
      case FileCategory.other:
        return const Color(0xFFF1F3F8);
    }
  }

  Widget _buildPreviewStrokes(bool isDark) {
    switch (category) {
      case FileCategory.pdf:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 2.5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3F465B) : const Color(0xFFD8DCE6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 32,
              height: 2.5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2E3445) : const Color(0xFFE8EBF2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 28,
              height: 2.5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2E3445) : const Color(0xFFE8EBF2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        );

      case FileCategory.word:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 3,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3B70) : const Color(0xFFC5D7F8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 3.5),
            Container(
              width: 22,
              height: 3,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3B70) : const Color(0xFFDBE5FA),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        );

      case FileCategory.excel:
        final gridColor1 = isDark ? const Color(0xFF1B4D30) : const Color(0xFFA8E2BD);
        final gridColor2 = isDark ? const Color(0xFF173F28) : const Color(0xFFC2EDD2);
        return SizedBox(
          width: 32,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(height: 5, decoration: BoxDecoration(color: gridColor1, borderRadius: BorderRadius.circular(1.5))),
                    const SizedBox(height: 2),
                    Container(height: 5, decoration: BoxDecoration(color: gridColor2, borderRadius: BorderRadius.circular(1.5))),
                  ],
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Column(
                  children: [
                    Container(height: 5, decoration: BoxDecoration(color: gridColor2, borderRadius: BorderRadius.circular(1.5))),
                    const SizedBox(height: 2),
                    Container(height: 5, decoration: BoxDecoration(color: gridColor1, borderRadius: BorderRadius.circular(1.5))),
                  ],
                ),
              ),
            ],
          ),
        );

      case FileCategory.ppt:
        return Container(
          width: 32,
          height: 14,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF4A2A18) : const Color(0xFFFFDEC9),
            borderRadius: BorderRadius.circular(3),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 14,
            height: 2,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF8C461F) : const Color(0xFFF26B1D),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );

      case FileCategory.txt:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26,
              height: 2.5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF384055) : const Color(0xFFCED4E2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 32,
              height: 2.5,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF282E3E) : const Color(0xFFE2E6F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        );

      case FileCategory.image:
        return Container(
          width: 32,
          height: 16,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF47360E) : const Color(0xFFFFE299),
            borderRadius: BorderRadius.circular(3),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.photo_camera,
            size: 11,
            color: isDark ? const Color(0xFFFFB300) : const Color(0xFFB27D00),
          ),
        );

      case FileCategory.other:
        return Container(
          width: 24,
          height: 2.5,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF384055) : const Color(0xFFCED4E2),
            borderRadius: BorderRadius.circular(2),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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

    // 48x56pt full document preview card
    final cardBg = _cardBackground(tokens, isDark);

    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(size.radius),
        border: Border.all(color: tokens.hairline, width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPreviewStrokes(isDark),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
            decoration: BoxDecoration(
              color: formatColor,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              formatTag,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
