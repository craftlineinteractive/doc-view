import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';

/// Floating zoom indicator pill displaying the current grid scale percentage.
///
/// Features:
/// - Tabular figures showing `"{percent}%"`.
/// - Tapping resets zoom to 100% (1.0x).
/// - Accessible tooltip and touch target.
class ZoomPill extends StatelessWidget {
  final double scale;
  final VoidCallback onReset;

  const ZoomPill({
    super.key,
    required this.scale,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final percent = (scale * 100).round();

    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: l10n.viewerSpreadsheetResetZoomTooltip,
        child: InkWell(
          onTap: onReset,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.viewerSpreadsheetZoomPill(percent),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                if ((scale - 1.0).abs() > 0.05) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.restart_alt_rounded,
                    size: 14,
                    color: Colors.white70,
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
