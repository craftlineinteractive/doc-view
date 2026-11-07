import 'package:flutter/material.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../buttons/doc_buttons.dart';

/// Modal bottom sheet chassis with 28pt top radius and 36x4 drag handle.
class DocBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final Widget? bottomActions;

  const DocBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.bottomActions,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    Widget? bottomActions,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DocBottomSheet(
        title: title,
        bottomActions: bottomActions,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? tokens.surface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: tokens.hairline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (title != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  title!,
                  style: DocViewTypography.headlineSm.copyWith(
                    color: tokens.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Divider(color: tokens.hairline, height: 1),
            ] else ...[
              const SizedBox(height: 12),
            ],
            Flexible(child: child),
            if (bottomActions != null) ...[
              Divider(color: tokens.hairline, height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: bottomActions!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 56pt height action row inside a bottom sheet.
class OptionsListTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final bool isDestructive;
  final VoidCallback onTap;

  const OptionsListTile({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = isDestructive ? DocViewColors.error : tokens.textPrimary;
    final iconColor = isDestructive ? DocViewColors.error : tokens.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          onTap();
        },
        child: Container(
          height: subtitle != null ? 64 : 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: DocViewTypography.titleMd.copyWith(
                        fontSize: 15,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal Dialog with 24pt corner radius.
class DocDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const DocDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required Widget content,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DocDialog(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? tokens.surface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: DocViewTypography.headlineSm.copyWith(
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            content,
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    onCancel?.call();
                  },
                  child: Text(
                    cancelLabel,
                    style: DocViewTypography.labelLg.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (isDestructive)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DocViewColors.error,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(confirmLabel),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tokens.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(confirmLabel),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Determinate progress sheet shown during conversion, merge, or split operations.
class ProgressSheet extends StatelessWidget {
  final String title;
  final String statusText;
  final double progress; // 0.0 to 1.0
  final VoidCallback? onCancel;

  const ProgressSheet({
    super.key,
    required this.title,
    required this.statusText,
    required this.progress,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final percent = (progress * 100).toInt().clamp(0, 100);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: DocViewTypography.titleMd.copyWith(color: tokens.textPrimary),
              ),
              Text(
                '$percent%',
                style: DocViewTypography.headlineSm.copyWith(color: tokens.primaryBlue),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress > 0 ? progress : null,
              minHeight: 8,
              backgroundColor: tokens.hairline,
              valueColor: AlwaysStoppedAnimation<Color>(tokens.primaryBlue),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            statusText,
            style: DocViewTypography.bodySm.copyWith(color: tokens.textSecondary),
          ),
          if (onCancel != null) ...[
            const SizedBox(height: 20),
            DocSecondaryButton(
              label: 'Cancel Operation',
              height: 44,
              onPressed: onCancel,
            ),
          ],
        ],
      ),
    );
  }
}

/// Result sheet shown upon successful PDF generation (image-to-pdf, merge, split).
class ResultSheet extends StatelessWidget {
  final String title;
  final String fileName;
  final String metadata;
  final VoidCallback onOpen;
  final VoidCallback onShare;
  final VoidCallback? onClose;

  const ResultSheet({
    super.key,
    this.title = 'Operation Complete',
    required this.fileName,
    required this.metadata,
    required this.onOpen,
    required this.onShare,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Green success badge
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DocViewColors.successTintLight,
            ),
            child: const Icon(AppIcons.check, size: 32, color: DocViewColors.success),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: DocViewTypography.headlineSm.copyWith(color: tokens.textPrimary),
          ),
          const SizedBox(height: 16),
          // Output file preview card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tokens.hairline, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: tokens.pdf.tint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(AppIcons.pdf, size: 24, color: tokens.pdf.solid),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DocViewTypography.titleMd.copyWith(color: tokens.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        metadata,
                        style: DocViewTypography.bodySm.copyWith(color: tokens.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Action buttons: Open PDF (Primary), Share (Secondary)
          DocPrimaryButton(
            label: 'Open Document',
            icon: const Icon(AppIcons.openWith, size: 20),
            onPressed: onOpen,
          ),
          const SizedBox(height: 10),
          DocSecondaryButton(
            label: 'Share Document',
            icon: const Icon(AppIcons.share, size: 20),
            onPressed: onShare,
          ),
        ],
      ),
    );
  }
}

