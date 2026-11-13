import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/file_types.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../../shared/widgets/tiles/file_type_badge.dart';
import '../../providers/providers.dart';
import '../open_document.dart';
import 'file_options_sheet.dart';

/// Reusable list tile displaying a document with category icon, title, metadata,
/// quick action icons, and multi-selection support.
class FileTile extends ConsumerWidget {
  const FileTile({
    required this.file,
    this.onTap,
    this.onLongPress,
    this.selectionMode = false,
    this.selected = false,
    this.onSelectChanged,
    super.key,
  });

  final DocFile file;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selectionMode;
  final bool selected;
  final ValueChanged<bool?>? onSelectChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tokens = context.tokens;

    final bookmarkLabel = file.isBookmarked ? ', bookmarked' : '';
    final selectionLabel =
        selectionMode ? (selected ? ', selected' : ', not selected') : '';
    final formattedSubtitle =
        FormatUtils.formatSubtitle(file.modified, file.sizeBytes);
    final semanticDescription =
        '${file.category.label}, ${file.name}, $formattedSubtitle$bookmarkLabel$selectionLabel';
    final tapHint = selectionMode
        ? (selected ? 'Deselect file' : 'Select file')
        : 'Open document';
    final longPressHint =
        selectionMode ? null : 'Select or view actions';

    return Semantics(
      container: true,
      label: semanticDescription,
      hint: tapHint,
      onLongPressHint: longPressHint,
      button: true,
      child: ListTile(
        onTap: () {
          if (selectionMode) {
            if (onTap != null) {
              onTap!();
            } else if (onSelectChanged != null) {
              onSelectChanged!(!selected);
            }
          } else {
            if (onTap != null) {
              onTap!();
            } else {
              openDocument(context, ref, file);
            }
          }
        },
        onLongPress: onLongPress,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: file.category == FileCategory.image
            ? Container(
                width: 48,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: tokens.hairline,
                    width: 0.8,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9.2),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.file(
                          File(file.path),
                          width: 48,
                          height: 56,
                          cacheWidth: 120,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                          gaplessPlayback: true,
                          errorBuilder: (context, error, stackTrace) =>
                              const FileTypeBadge(
                            category: FileCategory.image,
                            size: BadgeSize.large,
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 4,
                        bottom: 4,
                        child: FileTypeBadge(
                          category: FileCategory.image,
                          size: BadgeSize.small,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : FileTypeBadge(
                category: file.category,
                size: BadgeSize.large,
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
            formattedSubtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
        ),
        trailing: selectionMode
            ? ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                child: Checkbox(
                  value: selected,
                  onChanged: onSelectChanged ?? (_) => onTap?.call(),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    constraints:
                        const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: Icon(
                      file.isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      size: 22,
                      color: file.isBookmarked
                          ? theme.colorScheme.primary
                          : theme.iconTheme.color?.withValues(alpha: 0.6),
                    ),
                    tooltip:
                        file.isBookmarked ? 'Remove bookmark' : 'Bookmark',
                    onPressed: () {
                      ref
                          .read(fileActionsControllerProvider)
                          .toggleBookmark(file);
                    },
                  ),
                  IconButton(
                    constraints:
                        const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: Icon(
                      Icons.more_vert,
                      size: 20,
                      color: theme.iconTheme.color?.withValues(alpha: 0.6),
                    ),
                    tooltip: 'More actions',
                    onPressed: () {
                      FileOptionsSheet.show(context, file);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
