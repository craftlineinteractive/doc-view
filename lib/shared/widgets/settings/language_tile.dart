import 'package:flutter/material.dart';

import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Shared radio selection row for the Language screen, matching the geometry
/// and tokens of Scan Settings radio tiles (`>= 56pt` height, RTL-ready).
class LanguageTile extends StatelessWidget {
  const LanguageTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingBadge,
    required this.isSelected,
    this.isEnabled = true,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final String? trailingBadge;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final semanticParts = <String>[
      title,
      if (subtitle != null && subtitle!.isNotEmpty) subtitle!,
      if (trailingBadge != null && trailingBadge!.isNotEmpty) trailingBadge!,
    ];

    return Semantics(
      button: true,
      selected: isSelected,
      label: semanticParts.join(', '),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? tokens.primaryBlue
                            : isEnabled
                                ? tokens.textSecondary
                                : tokens.textSecondary.withValues(alpha: 0.45),
                        width: 2.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: isSelected
                        ? Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tokens.primaryBlue,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: DocViewTypography.titleMd.copyWith(
                            color: isEnabled
                                ? tokens.textPrimary
                                : tokens.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            height: 1.25,
                          ),
                        ),
                        if (subtitle != null && subtitle!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: DocViewTypography.bodySm.copyWith(
                              color: tokens.textSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              height: 1.25,
                            ),
                          ),
                        ],
                        if (trailingBadge != null &&
                            trailingBadge!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            trailingBadge!,
                            style: DocViewTypography.captionXs.copyWith(
                              color: tokens.textSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
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
