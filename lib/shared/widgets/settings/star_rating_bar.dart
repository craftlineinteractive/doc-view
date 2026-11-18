import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';

/// Five tappable star buttons (`>= 48x48` each) that follow reading direction
/// in RTL and skip fill animations when reduced motion is enabled.
class StarRatingBar extends StatelessWidget {
  const StarRatingBar({
    super.key,
    required this.rating,
    required this.onRatingSelected,
    this.maxStars = 5,
  });

  final int rating;
  final ValueChanged<int> onRatingSelected;
  final int maxStars;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final animDuration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 160);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        final starValue = index + 1;
        final isFilled = rating >= starValue;
        final semanticLabel = context.l10n.rateStarSemantics(starValue);

        return Semantics(
          button: true,
          selected: isFilled,
          label: semanticLabel,
          child: Tooltip(
            message: semanticLabel,
            child: InkWell(
              key: Key('rate_star_$starValue'),
              borderRadius: BorderRadius.circular(24),
              onTap: () => onRatingSelected(starValue),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: AnimatedScale(
                    scale: isFilled ? 1.12 : 1.0,
                    duration: animDuration,
                    curve: Curves.easeOutBack,
                    child: Icon(
                      isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 34,
                      color: isFilled
                          ? const Color(0xFFF59E0B)
                          : tokens.textSecondary.withValues(alpha: 0.65),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
