import 'package:flutter/material.dart';
import 'shimmer.dart';

/// Skeleton placeholder for a 68pt document list item ([FileRow]).
class SkeletonFileRow extends StatelessWidget {
  const SkeletonFileRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 68,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            // Thumbnail: 48x56 with 10pt radius
            SkeletonBox(width: 48, height: 56, borderRadius: 10),
            SizedBox(width: 14),
            // Title & metadata column
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 160, height: 16, borderRadius: 4),
                  SizedBox(height: 8),
                  SkeletonBox(width: 90, height: 12, borderRadius: 4),
                ],
              ),
            ),
            SizedBox(width: 12),
            // Actions placeholder (star & 3-dot)
            SkeletonBox(width: 24, height: 24, borderRadius: 12),
            SizedBox(width: 12),
            SkeletonBox(width: 24, height: 24, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder for a list of file rows.
class SkeletonFileList extends StatelessWidget {
  final int itemCount;

  const SkeletonFileList({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) => const SkeletonFileRow(),
      ),
    );
  }
}

/// Skeleton placeholder for the 4-column category grid on Home.
class SkeletonTileGrid extends StatelessWidget {
  final int itemCount;

  const SkeletonTileGrid({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.72,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SkeletonBox(width: 36, height: 44, borderRadius: 5),
              SizedBox(height: 6),
              SkeletonBox(width: 36, height: 12, borderRadius: 3),
              SizedBox(height: 4),
              SkeletonBox(width: 44, height: 10, borderRadius: 2),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton placeholder for a directory / folder row.
class SkeletonFolderRow extends StatelessWidget {
  const SkeletonFolderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 56,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SkeletonBox(width: 36, height: 36, borderRadius: 8),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 140, height: 15, borderRadius: 4),
                  SizedBox(height: 6),
                  SkeletonBox(width: 70, height: 11, borderRadius: 4),
                ],
              ),
            ),
            SkeletonBox(width: 18, height: 18, borderRadius: 9),
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder for a tool card on the Tools tab.
class SkeletonToolCard extends StatelessWidget {
  const SkeletonToolCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 92,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: SkeletonBox(borderRadius: 20),
      ),
    );
  }
}

/// Skeleton placeholder for a settings row.
class SkeletonSettingsRow extends StatelessWidget {
  const SkeletonSettingsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 56,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SkeletonBox(width: 24, height: 24, borderRadius: 6),
            SizedBox(width: 16),
            Expanded(
              child: SkeletonBox(width: 120, height: 15, borderRadius: 4),
            ),
            SkeletonBox(width: 20, height: 20, borderRadius: 10),
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder for a document reader page.
class SkeletonPdfPage extends StatelessWidget {
  const SkeletonPdfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Center(
        child: AspectRatio(
          aspectRatio: 1 / 1.414, // A4 ratio
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SkeletonBox(
              borderRadius: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Skeleton placeholder for the 60pt docked AdMob banner.
class SkeletonAdSlot extends StatelessWidget {
  const SkeletonAdSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 60,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            SkeletonBox(width: 24, height: 16, borderRadius: 4),
            SizedBox(width: 12),
            Expanded(child: SkeletonBox(height: 48, borderRadius: 8)),
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder for the 3-column image gallery grid.
class SkeletonImageGrid extends StatelessWidget {
  final int itemCount;

  const SkeletonImageGrid({super.key, this.itemCount = 18});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: GridView.builder(
        padding: const EdgeInsets.all(4),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1.0,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => const SkeletonBox(
          borderRadius: 8,
        ),
      ),
    );
  }
}


