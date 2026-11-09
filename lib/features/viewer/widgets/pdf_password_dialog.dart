import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Password-protected PDF decryption dialog matching mockup specifications.
/// Displays over a blurred backdrop with a lock icon, show/hide eye toggle,
/// inline 1.5px red error border on retry, and Cancel / Unlock buttons.
class PdfPasswordDialog extends StatefulWidget {
  final bool isRetry;

  const PdfPasswordDialog({
    super.key,
    this.isRetry = false,
  });

  static Future<String?> show(BuildContext context, {bool isRetry = false}) {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => PdfPasswordDialog(isRetry: isRetry),
    );
  }

  @override
  State<PdfPasswordDialog> createState() => _PdfPasswordDialogState();
}

class _PdfPasswordDialogState extends State<PdfPasswordDialog> {
  late final TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _controller.text;
    Navigator.of(context).pop(password);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: isDark ? DocViewColors.backgroundDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lock Icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: tokens.blueTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: 26,
                  color: tokens.primaryBlue,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'This PDF is password-protected',
                textAlign: TextAlign.center,
                style: DocViewTypography.headlineSm.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                'Enter password to view and decrypt the contents.',
                textAlign: TextAlign.center,
                style: DocViewTypography.bodyMd.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Password Input Field with Error Outline
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: widget.isRetry ? const Color(0xFFE5484D) : tokens.hairline,
                    width: widget.isRetry ? 1.5 : 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        obscureText: _obscureText,
                        autofocus: true,
                        style: TextStyle(
                          color: tokens.textPrimary,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: TextStyle(
                            color: tokens.textSecondary.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: tokens.textSecondary,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Error banner if retry
              if (widget.isRetry) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 16,
                      color: Color(0xFFE5484D),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Incorrect password. Try again.',
                      style: DocViewTypography.bodySm.copyWith(
                        color: const Color(0xFFE5484D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              // Action Buttons: Cancel and Unlock
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: tokens.textPrimary,
                          side: BorderSide(color: tokens.hairline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: tokens.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Unlock'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

