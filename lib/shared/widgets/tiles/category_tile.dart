import 'package:flutter/material.dart';
import '../../../core/constants/file_types.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// 4-column category grid item on the Home screen matching mockup precision.
/// Features a 32x38pt vibrant solid format badge container, label, and count/subtitle.
class CategoryTile extends StatelessWidget {
  final FileCategory? category;
  final String label;
  final IconData? icon;
  final dynamic count;
  final String? subtitle;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    this.category,
    required this.label,
    this.icon,
    this.count,
    this.subtitle,
    required this.onTap,
  });

  Widget _buildBadge(DocViewTokens tokens) {
    final Color bgColor;
    final Widget content;

    if (category == null) {
      if (label.toLowerCase() == 'folders' || label.toLowerCase() == 'directories') {
        bgColor = tokens.primaryBlue;
        content = const Icon(
          Icons.manage_search,
          size: 20,
          color: Colors.white,
        );
      } else {
        // 'All'
        bgColor = tokens.primaryBlue;
        content = const Icon(
          Icons.folder,
          size: 20,
          color: Colors.white,
        );
      }
    } else {
      switch (category!) {
        case FileCategory.pdf:
          bgColor = DocViewColors.pdfSolid;
          content = const Text(
            'PDF',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          );
        case FileCategory.word:
          bgColor = DocViewColors.wordSolid;
          content = const Text(
            'W',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case FileCategory.excel:
          bgColor = DocViewColors.excelSolid;
          content = const Text(
            'X',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case FileCategory.ppt:
          bgColor = DocViewColors.pptSolid;
          content = const Text(
            'P',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case FileCategory.txt:
          bgColor = DocViewColors.txtSolid;
          content = const Text(
            'TXT',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          );
        case FileCategory.image:
          bgColor = DocViewColors.imageSolid;
          content = const Icon(
            Icons.photo_camera_outlined,
            size: 19,
            color: Colors.white,
          );
        case FileCategory.other:
          bgColor = DocViewColors.txtSolid;
          content = const Icon(
            Icons.insert_drive_file,
            size: 18,
            color: Colors.white,
          );
      }
    }

    return Container(
      width: 32,
      height: 38,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: content,
    );
  }

  String _resolvedSubtitle() {
    if (subtitle != null) return subtitle!;
    if (count != null) return count.toString();
    if (label.toLowerCase() == 'folders' || label.toLowerCase() == 'directories') {
      return 'Browse';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final subText = _resolvedSubtitle();

    return Semantics(
      button: true,
      label: '$label, $subText',
      child: Material(
        color: tokens.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tokens.hairline, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBadge(tokens),
                const SizedBox(height: 6),
                // Category label
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DocViewTypography.labelMd.copyWith(
                      color: tokens.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                // Document count / subtitle
                if (subText.isNotEmpty)
                  Flexible(
                    child: Text(
                      subText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DocViewTypography.bodySm.copyWith(
                        color: tokens.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
