import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/doc_view_tokens.dart';

/// Floating context menu displayed over selected PDF text offering markup and copy actions.
class SelectionMenu extends StatelessWidget {
  const SelectionMenu({
    required this.onHighlight,
    required this.onUnderline,
    required this.onStrikethrough,
    required this.onCopy,
    super.key,
  });

  final VoidCallback onHighlight;
  final VoidCallback onUnderline;
  final VoidCallback onStrikethrough;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark
        ? const Color(0xEB232838)
        : const Color(0xF5FFFFFF);

    return Material(
      color: Colors.transparent,
      elevation: 6,
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: tokens.hairline.withValues(alpha: 0.6),
                width: 0.75,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SelectionButton(
                  key: const Key('selection_action_copy'),
                  icon: Icons.copy_outlined,
                  tooltip: l10n.annotateToolbarCopy,
                  onPressed: onCopy,
                ),
                _divider(tokens),
                _SelectionButton(
                  key: const Key('selection_action_highlight'),
                  icon: Icons.border_color_outlined,
                  tooltip: l10n.annotateToolbarHighlight,
                  onPressed: onHighlight,
                ),
                _SelectionButton(
                  key: const Key('selection_action_underline'),
                  icon: Icons.format_underlined_outlined,
                  tooltip: l10n.annotateToolbarUnderline,
                  onPressed: onUnderline,
                ),
                _SelectionButton(
                  key: const Key('selection_action_strikethrough'),
                  icon: Icons.format_strikethrough_outlined,
                  tooltip: l10n.annotateToolbarStrikethrough,
                  onPressed: onStrikethrough,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider(DocViewTokens tokens) {
    return Container(
      width: 1,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: tokens.hairline,
    );
  }
}

class _SelectionButton extends StatelessWidget {
  const _SelectionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: Icon(
                icon,
                size: 20,
                color: tokens.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
