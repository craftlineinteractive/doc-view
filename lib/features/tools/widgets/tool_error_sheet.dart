import 'package:flutter/material.dart';

import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../shared/widgets/buttons/doc_buttons.dart';

/// Modal bottom sheet presented upon an unrecoverable failure during a PDF operation.
/// Displays the genuine error message from the service and provides Retry/Close CTAs.
class ToolErrorSheet extends StatelessWidget {
  final String title;
  final String errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const ToolErrorSheet({
    super.key,
    this.title = "Couldn't create PDF",
    required this.errorMessage,
    this.onRetry,
    this.onClose,
  });

  /// Displays the modal error sheet.
  static Future<void> show(
    BuildContext context, {
    String title = "Couldn't create PDF",
    required String errorMessage,
    VoidCallback? onRetry,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => ToolErrorSheet(
        title: title,
        errorMessage: errorMessage,
        onRetry: onRetry,
        onClose: onClose,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: tokens.hairline, width: 1)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.paddingOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          const SizedBox(height: 20),

          // Error Header
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: DocViewColors.error.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: DocViewColors.error,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DocViewTypography.headlineSm.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: tokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'An unexpected error occurred during processing',
                      style: DocViewTypography.bodySm.copyWith(
                        color: tokens.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Error details container
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: tokens.hairline, width: 1),
            ),
            child: Text(
              errorMessage,
              style: DocViewTypography.bodySm.copyWith(
                color: tokens.textPrimary,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              if (onRetry != null) ...[
                Expanded(
                  child: DocPrimaryButton(
                    label: 'Retry',
                    icon: const Icon(Icons.refresh_rounded, size: 20, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRetry?.call();
                    },
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: DocSecondaryButton(
                  label: 'Close',
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClose?.call();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
