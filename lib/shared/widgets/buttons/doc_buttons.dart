import 'package:flutter/material.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Primary call-to-action button (56pt height, 16pt radius).
class DocPrimaryButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double? width;

  const DocPrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.height = 56,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: tokens.primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: tokens.primaryBlue.withValues(alpha: 0.4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: const SizedBox(
                  width: 48,
                  height: 3,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: DocViewTypography.labelLg.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Outlined secondary button with 1px border.
class DocSecondaryButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final double height;
  final double? width;

  const DocSecondaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.height = 56,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: tokens.textPrimary,
          side: BorderSide(color: tokens.hairline, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: DocViewTypography.labelLg.copyWith(
                color: tokens.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tonal surface button for secondary actions.
class DocTonalButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final double height;
  final double? width;

  const DocTonalButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.height = 56,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: tokens.surface,
          foregroundColor: tokens.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: tokens.hairline, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: DocViewTypography.labelLg.copyWith(
                color: tokens.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Destructive action button (Crimson Red #E5484D).
class DocDestructiveButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isFilled;
  final double height;

  const DocDestructiveButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isFilled = true,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFilled ? DocViewColors.error : DocViewColors.errorTintLight,
          foregroundColor: isFilled ? Colors.white : DocViewColors.error,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: DocViewTypography.labelLg.copyWith(
                color: isFilled ? Colors.white : DocViewColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating action button enforcing 56x56 geometry and 16pt rounded corners.
class DocFab extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const DocFab({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            heroTag: null,
            elevation: 3,
            backgroundColor: tokens.primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onPressed: onPressed,
            child: Icon(icon, size: 26),
          ),
        ),
      ),
    );
  }
}

/// Docked bottom action bar container for single or dual action buttons.
class DocBottomActionBar extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const DocBottomActionBar({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        border: Border(
          top: BorderSide(color: tokens.hairline, width: 1),
        ),
      ),
      padding: padding,
      child: SafeArea(
        top: false,
        child: Row(
          children: children
              .map((c) => Expanded(child: c))
              .expand((w) => [w, const SizedBox(width: 12)])
              .toList()
            ..removeLast(),
        ),
      ),
    );
  }
}

