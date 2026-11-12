import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../../shared/widgets/skeletons/shimmer.dart';
import '../../../shared/widgets/tiles/file_thumbnail.dart';
import '../../files/open_document.dart';
import '../../providers/providers.dart';

/// "Created by you" section showing horizontal preview cards of generated PDFs
/// or an informative empty state card.
class CreatedByYouSection extends StatelessWidget {
  final VoidCallback onSeeAll;

  const CreatedByYouSection({
    super.key,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    bool hasScope = true;
    try {
      ProviderScope.containerOf(context, listen: false);
    } catch (_) {
      hasScope = false;
    }

    if (!hasScope) {
      return _buildContent(context, const AsyncValue.data([]));
    }

    return Consumer(
      builder: (context, ref, child) {
        final createdFilesAsync = ref.watch(createdFilesProvider);
        return _buildContent(context, createdFilesAsync);
      },
    );
  }

  Widget _buildContent(BuildContext context, AsyncValue<List<DocFile>> createdFilesAsync) {
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with See All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Created by you',
                style: DocViewTypography.headlineSm.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(48, 36),
              ),
              child: Text(
                'See All',
                style: DocViewTypography.labelMd.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? tokens.interactiveBlue
                      : const Color(0xFF0050C7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Content: Loading Skeleton, Empty Card, or Horizontal List
        createdFilesAsync.when(
          loading: () => const _CreatedFilesSkeleton(),
          error: (_, _) => const SizedBox.shrink(),
          data: (files) {
            if (files.isEmpty) {
              return _EmptyCreatedCard(tokens: tokens);
            }

            return SizedBox(
              height: 196,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: files.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final file = files[index];
                  return _CreatedFileCard(file: file);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CreatedFileCard extends ConsumerWidget {
  final DocFile file;

  const _CreatedFileCard({required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final dateStr = FormatUtils.formatDate(file.modified);
    final sizeStr = FormatUtils.formatFileSize(file.sizeBytes);

    return Semantics(
      button: true,
      label: '${file.name}, $sizeStr, created $dateStr',
      child: Material(
        color: tokens.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => openDocument(context, ref, file),
          borderRadius: BorderRadius.circular(16),
          hoverColor: tokens.surfaceHover,
          child: Container(
            width: 148,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.hairline, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: FileThumbnail(
                    filePath: file.path,
                    category: file.category,
                    width: 148,
                    height: 116,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DocViewTypography.bodyMd.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: tokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$dateStr • $sizeStr',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DocViewTypography.bodySm.copyWith(
                          fontSize: 11,
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
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

class _EmptyCreatedCard extends StatelessWidget {
  final DocViewTokens tokens;

  const _EmptyCreatedCard({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.hairline, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tokens.hairline, width: 1),
            ),
            child: Icon(
              Icons.note_add_outlined,
              color: tokens.primaryBlue,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PDFs you create appear here',
                  style: DocViewTypography.titleMd.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Converted, scanned, or merged documents will be saved locally.',
                  style: DocViewTypography.bodySm.copyWith(
                    fontSize: 12,
                    color: tokens.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatedFilesSkeleton extends StatelessWidget {
  const _CreatedFilesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: SizedBox(
        height: 196,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, _) => Container(
            width: 148,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
