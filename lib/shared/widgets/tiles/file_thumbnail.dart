import 'package:flutter/material.dart';
import '../../../core/constants/file_types.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../skeletons/shimmer.dart';
import 'file_type_badge.dart';

/// Abstract contract for asynchronous document thumbnail extraction.
/// The concrete pdfrx implementation is introduced in Phase 2 (R-C).
abstract interface class ThumbnailSource {
  Future<ImageProvider?> loadThumbnail({
    required String filePath,
    required double width,
    required double height,
  });
}

/// 48x56pt document preview thumbnail.
/// Displays an animated skeleton during loading, and safely falls back
/// to [FileTypeBadge] if the source is unavailable, encrypted, or encounters an error.
class FileThumbnail extends StatelessWidget {
  final String filePath;
  final FileCategory category;
  final ThumbnailSource? source;
  final double width;
  final double height;
  final double borderRadius;

  const FileThumbnail({
    super.key,
    required this.filePath,
    required this.category,
    this.source,
    this.width = 48,
    this.height = 56,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final fallback = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: tokens.hairline, width: 0.5),
        ),
        child: Center(
          child: FileTypeBadge(
            category: category,
            size: BadgeSize.large,
          ),
        ),
      ),
    );

    if (source == null) return fallback;

    return FutureBuilder<ImageProvider?>(
      future: source!.loadThumbnail(
        filePath: filePath,
        width: width,
        height: height,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer(
            child: SkeletonBox(
              width: width,
              height: height,
              borderRadius: borderRadius,
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return fallback;
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: tokens.hairline, width: 0.5),
              image: DecorationImage(
                image: snapshot.data!,
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: FileTypeBadge(
                  category: category,
                  size: BadgeSize.small,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

