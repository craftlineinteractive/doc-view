import 'package:flutter/material.dart';

import '../../../core/theme/doc_view_tokens.dart';
import '../../../shared/widgets/skeletons/shimmer.dart';

/// Shimmer skeleton placeholder for the tools grid matching reference density.
class ToolGridSkeleton extends StatelessWidget {
  const ToolGridSkeleton({
    this.columnCount = 4,
    this.itemCount = 4,
    super.key,
  });

  final int columnCount;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Shimmer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalSpacing = (columnCount - 1) * 12.0;
          final itemWidth = (constraints.maxWidth - totalSpacing) / columnCount;

          return Wrap(
            spacing: 12,
            runSpacing: 16,
            children: List.generate(itemCount, (index) {
              return SizedBox(
                width: itemWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: tokens.shimmerBase,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 48,
                      height: 12,
                      decoration: BoxDecoration(
                        color: tokens.shimmerBase,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
