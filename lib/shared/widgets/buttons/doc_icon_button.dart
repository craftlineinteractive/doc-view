import 'package:flutter/material.dart';
import '../../../core/theme/doc_view_tokens.dart';

/// Accessible icon button enforcing >= 48x48 touch target and mandatory tooltip/semantics.
class DocIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final EdgeInsetsGeometry padding;

  const DocIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.color,
    this.size = 24,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final iconColor = color ?? tokens.textPrimary;

    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: InkResponse(
          onTap: onPressed,
          radius: 24,
          highlightShape: BoxShape.circle,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            child: Padding(
              padding: padding,
              child: Center(
                child: Icon(
                  icon,
                  size: size,
                  color: onPressed != null ? iconColor : tokens.textSecondary.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

