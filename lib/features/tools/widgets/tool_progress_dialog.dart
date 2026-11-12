import 'package:flutter/material.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../shared/widgets/buttons/doc_buttons.dart';

/// Modal dialog displaying determinate operation progress for PDF creation/manipulation.
/// Non-dismissible during operation. Cancel button is omitted when [onCancel] is null.
class ToolProgressDialog extends StatelessWidget {
  final String title;
  final String? message;
  final double? progress; // 0.0 to 1.0, or null for indeterminate
  final VoidCallback? onCancel;

  const ToolProgressDialog({
    super.key,
    required this.title,
    this.message,
    this.progress,
    this.onCancel,
  });

  /// Displays the progress dialog.
  static Future<void> show(
    BuildContext context, {
    required String title,
    String? message,
    double? progress,
    VoidCallback? onCancel,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ToolProgressDialog(
        title: title,
        message: message,
        progress: progress,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final int percent = ((progress ?? 0.0) * 100).clamp(0, 100).toInt();

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: tokens.surfaceAlt,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: tokens.hairline, width: 1),
        ),
        elevation: 8,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: DocViewTypography.headlineSm.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              // Determinate / Indeterminate Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: tokens.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(tokens.primaryBlue),
                ),
              ),
              const SizedBox(height: 12),
              // Status text and percentage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      message ?? 'Please wait...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DocViewTypography.bodySm.copyWith(
                        color: tokens.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (progress != null)
                    Text(
                      '$percent%',
                      style: DocViewTypography.labelMd.copyWith(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
              if (onCancel != null) ...[
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: DocSecondaryButton(
                    label: 'Cancel',
                    onPressed: onCancel,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
