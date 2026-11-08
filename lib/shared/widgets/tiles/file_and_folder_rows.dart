import 'package:flutter/material.dart';
import '../../../core/constants/file_types.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../buttons/doc_icon_button.dart';
import 'file_thumbnail.dart';
import 'pdf_thumbnail_source.dart';

/// 68pt document row matching the precision mockup layout.
/// Supports default, bookmarked, and multi-selection states.
class FileRow extends StatelessWidget {
  final String title;
  final String metadata;
  final FileCategory category;
  final String filePath;
  final ThumbnailSource? thumbnailSource;
  final bool isBookmarked;
  final bool isSelected;
  final bool isSelectionMode;
  final String? highlightQuery;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onToggleBookmark;
  final VoidCallback? onOptions;

  const FileRow({
    super.key,
    required this.title,
    required this.metadata,
    required this.category,
    required this.filePath,
    this.thumbnailSource,
    this.isBookmarked = false,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.highlightQuery,
    required this.onTap,
    this.onLongPress,
    this.onToggleBookmark,
    this.onOptions,
  });

  Widget _buildTitle(DocViewTokens tokens) {
    if (highlightQuery == null || highlightQuery!.trim().isEmpty) {
      return Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: DocViewTypography.titleMd.copyWith(
          fontSize: 15,
          color: tokens.textPrimary,
        ),
      );
    }

    final query = highlightQuery!.toLowerCase();
    final lowerTitle = title.toLowerCase();
    if (!lowerTitle.contains(query)) {
      return Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: DocViewTypography.titleMd.copyWith(
          fontSize: 15,
          color: tokens.textPrimary,
        ),
      );
    }

    final spans = <TextSpan>[];
    int start = 0;
    while (true) {
      final index = lowerTitle.indexOf(query, start);
      if (index == -1) {
        if (start < title.length) {
          spans.add(TextSpan(
            text: title.substring(start),
            style: DocViewTypography.titleMd.copyWith(
              fontSize: 15,
              color: tokens.textPrimary,
            ),
          ));
        }
        break;
      }
      if (index > start) {
        spans.add(TextSpan(
          text: title.substring(start, index),
          style: DocViewTypography.titleMd.copyWith(
            fontSize: 15,
            color: tokens.textPrimary,
          ),
        ));
      }
      spans.add(TextSpan(
        text: title.substring(index, index + query.length),
        style: DocViewTypography.titleMd.copyWith(
          fontSize: 15,
          color: tokens.primaryBlue,
          fontWeight: FontWeight.w700,
        ),
      ));
      start = index + query.length;
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final semanticsLabel = '${category.label}, $title, $metadata, ${isBookmarked ? "bookmarked" : "not bookmarked"}';

    return Semantics(
      label: semanticsLabel,
      button: true,
      selected: isSelectionMode ? isSelected : null,
      child: Material(
        color: isSelected ? tokens.blueTint : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: tokens.hairline, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Leading: selection checkbox OR thumbnail
                if (isSelectionMode) ...[
                  SizedBox(
                    width: 48,
                    height: 56,
                    child: Center(
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? tokens.primaryBlue : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? tokens.primaryBlue : tokens.textSecondary,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(AppIcons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                ] else ...[
                  FileThumbnail(
                    filePath: filePath,
                    category: category,
                    source: thumbnailSource ??
                        (category == FileCategory.pdf
                            ? PdfThumbnailSource.instance
                            : null),
                  ),
                ],
                const SizedBox(width: 14),
                // Title and metadata column
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(tokens),
                      const SizedBox(height: 4),
                      Text(
                        metadata,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Trailing actions (bookmark & options) - suppressed in selection mode
                if (!isSelectionMode) ...[
                  DocIconButton(
                    icon: isBookmarked ? AppIcons.bookmark : AppIcons.bookmarkOutline,
                    tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
                    color: isBookmarked ? DocViewColors.warning : tokens.textSecondary,
                    onPressed: onToggleBookmark,
                  ),
                  DocIconButton(
                    icon: AppIcons.moreVert,
                    tooltip: 'File options for $title',
                    color: tokens.textSecondary,
                    onPressed: onOptions,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Directory list item in the folder browser.
class FolderRow extends StatelessWidget {
  final String folderName;
  final String? subtitle;
  final VoidCallback onTap;

  const FolderRow({
    super.key,
    required this.folderName,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Semantics(
      button: true,
      label: 'Folder, $folderName${subtitle != null ? ", $subtitle" : ""}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: tokens.hairline, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Folder icon in accent container
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: tokens.folder.tint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(AppIcons.folderFilled, size: 20, color: tokens.folder.solid),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        folderName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DocViewTypography.titleMd.copyWith(
                          fontSize: 15,
                          color: tokens.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: DocViewTypography.bodySm.copyWith(
                            color: tokens.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(AppIcons.chevronRight, size: 20, color: tokens.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Image category photo grid tile with optional selection check badge.
class ImageGridTile extends StatelessWidget {
  final ImageProvider imageProvider;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ImageGridTile({
    super.key,
    required this.imageProvider,
    this.isSelected = false,
    this.isSelectionMode = false,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
          if (isSelected)
            Container(
              decoration: BoxDecoration(
                color: tokens.primaryBlue.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: tokens.primaryBlue, width: 2),
              ),
            ),
          if (isSelectionMode)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? tokens.primaryBlue : Colors.black.withValues(alpha: 0.4),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: isSelected
                    ? const Icon(AppIcons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

