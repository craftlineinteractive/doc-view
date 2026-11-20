import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../tool_registry.dart';

/// Compact, accessible grid tile for tools on the redesigned Tools tab.
///
/// Specs:
/// - 64dp square container with hairline border and `surfaceAlt` fill
/// - 36dp glossy gradient icon inside
/// - 2-line centered label underneath with ellipsis
/// - Minimum 48dp interactive touch target
class ToolGridTile extends StatelessWidget {
  const ToolGridTile({
    required this.tool,
    this.onTap,
    super.key,
  });

  final ToolDef tool;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final title = tool.title(context.l10n);
    final subtitle = tool.subtitle(context.l10n);

    return Semantics(
      button: true,
      label: '$title, $subtitle',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: tokens.primaryBlue.withValues(alpha: 0.12),
          highlightColor: tokens.surfaceHover,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 64x64 container with hairline border & surfaceAlt fill
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: tokens.surfaceAlt,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: tokens.hairline,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: tokens.hairline.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: tool.gradient,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: tool.gradient.colors.last.withValues(alpha: 0.28),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        tool.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Label underneath centered, max 2 lines
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 32),
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: DocViewTypography.captionXs.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 1.2,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
