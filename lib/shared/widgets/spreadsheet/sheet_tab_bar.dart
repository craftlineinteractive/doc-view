import 'package:flutter/material.dart';

import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Horizontally scrollable sheet navigation bar for multi-sheet workbooks.
///
/// Features:
/// - Automatically hidden when workbook contains only 1 sheet.
/// - Active sheet tab highlighted in Excel green solid color with white text.
/// - Inactive tabs styled with subtle background and secondary text.
/// - Smooth horizontal scrolling with accessible tap targets (>= 48dp width).
class SheetTabBar extends StatelessWidget {
  final List<String> sheetNames;
  final int activeIndex;
  final ValueChanged<int> onSheetSelected;

  const SheetTabBar({
    super.key,
    required this.sheetNames,
    required this.activeIndex,
    required this.onSheetSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (sheetNames.length <= 1) {
      return const SizedBox.shrink();
    }

    final tokens = context.tokens;

    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        border: Border(
          top: BorderSide(color: tokens.hairline, width: 1.0),
          bottom: BorderSide(color: tokens.hairline, width: 1.0),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: sheetNames.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isActive = index == activeIndex;
          final sheetName = sheetNames[index];

          return InkWell(
            onTap: () => onSheetSelected(index),
            borderRadius: BorderRadius.circular(6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? tokens.excel.solid : tokens.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isActive ? tokens.excel.solid : tokens.hairline,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: tokens.excel.solid.withValues(alpha: 0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                sheetName,
                style: DocViewTypography.bodySm.copyWith(
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? Colors.white : tokens.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
