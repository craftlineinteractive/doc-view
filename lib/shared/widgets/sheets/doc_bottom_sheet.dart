import 'package:flutter/material.dart';

import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Standard modal bottom sheet wrapper matching Doc View precision system.
/// Enforces 28pt top corner radius, surface background, drag handle, and title header.
class DocBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const DocBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.showCloseButton = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: tokens.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: tokens.textSecondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: DocViewTypography.headlineSm.copyWith(
                      color: tokens.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (showCloseButton)
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: tokens.textSecondary,
                      onPressed: onClose ?? () => Navigator.of(context).pop(),
                    ),
                ],
              ),
              const SizedBox(height: 4),

              // Content Body
              child,
            ],
          ),
        ),
      ),
    );
  }
}

