import 'package:flutter/material.dart';

import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Card container for a group of settings rows with unified 20pt radius,
/// surface background, hairline border, and hairline row dividers.
class SettingsGroupCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroupCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    final dividedChildren = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      dividedChildren.add(children[i]);
      if (i < children.length - 1) {
        dividedChildren.add(
          Divider(
            height: 1,
            thickness: 1,
            indent: 68,
            color: tokens.hairline,
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: dividedChildren,
      ),
    );
  }
}

/// Standard Settings Row matching mockups 07_settings/01_settings_tab.
/// Enforces >=56pt height, 40x40 icon container in blueTint with primaryBlue icon,
/// SemiBold 16 title, optional Medium 13 secondary subtitle, and trailing chevron.
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? iconColor;
  final Color? iconBgColor;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final resolvedIconColor = iconColor ?? tokens.primaryBlue;
    final resolvedIconBg = iconBgColor ?? tokens.blueTint;

    final effectiveTrailing = trailing ??
        (onTap != null
            ? Icon(
                AppIcons.chevronRight,
                size: 20,
                color: tokens.textSecondary,
              )
            : null);

    return Semantics(
      button: onTap != null || onLongPress != null,
      label: subtitle != null ? '$title, $subtitle' : title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 58),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: resolvedIconBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      color: resolvedIconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: DocViewTypography.titleMd.copyWith(
                            color: tokens.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.25,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: DocViewTypography.bodySm.copyWith(
                              color: tokens.textSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (effectiveTrailing != null) ...[
                    const SizedBox(width: 8),
                    effectiveTrailing,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Uppercase section header matching SectionHeader in 07_settings/01_settings_tab.
class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        title.toUpperCase(),
        style: DocViewTypography.sectionHeader.copyWith(
          color: tokens.sectionHeader,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

