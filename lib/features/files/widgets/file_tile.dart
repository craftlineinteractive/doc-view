import 'package:flutter/material.dart';

import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';

/// Reusable list tile displaying a document with category icon, title, metadata, and quick action icons.
class FileTile extends StatelessWidget {
  const FileTile({
    required this.file,
    this.onTap,
    super.key,
  });

  final DocFile file;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = file.category.color;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(
          file.category.icon,
          color: categoryColor,
          size: 24,
        ),
      ),
      title: Text(
        file.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          FormatUtils.formatSubtitle(file.modified, file.sizeBytes),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              file.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              size: 20,
              color: file.isBookmarked
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color?.withValues(alpha: 0.6),
            ),
            tooltip: 'Bookmark',
            onPressed: () {
              // Non-functional in Phase 1B
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 20,
              color: theme.iconTheme.color?.withValues(alpha: 0.6),
            ),
            tooltip: 'More actions',
            onPressed: () {
              // Non-functional in Phase 1B
            },
          ),
        ],
      ),
    );
  }
}
