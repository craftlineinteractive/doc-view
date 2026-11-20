import 'package:flutter/material.dart';

import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Stepper widget for selecting page count between 1 and 100.
class PageCountStepper extends StatelessWidget {
  const PageCountStepper({
    required this.count,
    required this.onChanged,
    required this.countLabel,
    this.min = 1,
    this.max = 100,
    super.key,
  });

  final int count;
  final ValueChanged<int> onChanged;
  final String countLabel;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final canDecrement = count > min;
    final canIncrement = count < max;

    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.hairline, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement button
          Semantics(
            button: true,
            enabled: canDecrement,
            label: 'Decrease page count',
            child: InkWell(
              onTap: canDecrement ? () => onChanged(count - 1) : null,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: Icon(
                    Icons.remove,
                    size: 20,
                    color: canDecrement
                        ? tokens.textPrimary
                        : tokens.textSecondary.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),
          // Count label
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                countLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: DocViewTypography.labelMd.copyWith(
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ),
            ),
          ),
          // Increment button
          Semantics(
            button: true,
            enabled: canIncrement,
            label: 'Increase page count',
            child: InkWell(
              onTap: canIncrement ? () => onChanged(count + 1) : null,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(12),
              ),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: canIncrement
                        ? tokens.textPrimary
                        : tokens.textSecondary.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
