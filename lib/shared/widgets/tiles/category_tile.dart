import 'package:flutter/material.dart';
import '../../../core/constants/file_types.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import 'doc_folded_icon.dart';

/// 4-column category grid item on the Home screen.
/// Features a vibrant document icon with folded top-right corner,
/// category label, and document count / subtitle.
/// Border/card background removed for a clean, borderless appearance.
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

  String _resolvedSubtitle() {
    if (subtitle != null) return subtitle!;
    if (count != null) return count.toString();
    if (label.toLowerCase() == 'folders' || label.toLowerCase() == 'directories') {
      return 'Browse';
    }
    return '';
  }

  Widget _buildIcon() {
    if (category == null) {
      final isFolders =
          label.toLowerCase() == 'folders' || label.toLowerCase() == 'directories';
      return DocFoldedIcon(
        icon: icon ?? (isFolders ? Icons.manage_search : Icons.folder),
        width: 36,
        height: 44,
      );
    }

    return DocFoldedIcon(
      category: category,
      icon: icon,
      width: 36,
      height: 44,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final subText = _resolvedSubtitle();

    return Semantics(
      button: true,
      label: '$label, $subText',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(),
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
