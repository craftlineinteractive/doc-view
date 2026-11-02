import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../providers/providers.dart';
import '../open_document.dart';

/// Reusable list tile displaying a document with category icon, title, metadata, and quick action icons.
class FileTile extends ConsumerWidget {
  const FileTile({
    required this.file,
    this.onTap,
    super.key,
  });

  final DocFile file;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoryColor = file.category.color;

    return ListTile(
      onTap: onTap ?? () => openDocument(context, ref, file),
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
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              file.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              size: 22,
              color: file.isBookmarked
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color?.withValues(alpha: 0.6),
            ),
            tooltip: file.isBookmarked ? 'Remove bookmark' : 'Bookmark',
            onPressed: () {
              ref.read(fileActionsControllerProvider).toggleBookmark(file);
            },
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              Icons.more_vert,
              size: 20,
              color: theme.iconTheme.color?.withValues(alpha: 0.6),
            ),
            tooltip: 'More actions',
            onPressed: () {
              // Non-functional in Phase 1B / 2A (coming in Phase 4A)
            },
          ),
        ],
      ),
    );
  }
}

