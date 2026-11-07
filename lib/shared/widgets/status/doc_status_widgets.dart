import 'package:flutter/material.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../buttons/doc_buttons.dart';

/// Lightweight info or warning banner (e.g. storage indexing, scanning status).
class InfoBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? color;
  final Widget? trailing;

  const InfoBanner({
    super.key,
    required this.message,
    this.icon = AppIcons.info,
    this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final accent = color ?? tokens.primaryBlue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(color: accent.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: DocViewTypography.bodySm.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Floating pill overlay showing current reader page ("4 / 12").
class PageNumberPill extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageNumberPill({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$currentPage / $totalPages',
        style: DocViewTypography.labelXs.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Illustrated empty state presentation.
class DocEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const DocEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: tokens.surface,
                shape: BoxShape.circle,
                border: Border.all(color: tokens.hairline, width: 1.5),
              ),
              child: Icon(icon, size: 36, color: tokens.textSecondary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: DocViewTypography.headlineSm.copyWith(
                color: tokens.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: DocViewTypography.bodyMd.copyWith(
                color: tokens.textSecondary,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              DocTonalButton(
                label: actionLabel!,
                width: 180,
                height: 48,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Generic error state widget with Retry button.
class DocErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DocErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: DocViewColors.errorTintLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(AppIcons.error, size: 32, color: DocViewColors.error),
            ),
            const SizedBox(height: 18),
            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: DocViewTypography.headlineSm.copyWith(color: tokens.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: DocViewTypography.bodyMd.copyWith(color: tokens.textSecondary),
            ),
            const SizedBox(height: 24),
            DocSecondaryButton(
              label: 'Retry',
              icon: const Icon(AppIcons.refresh, size: 18),
              width: 150,
              height: 46,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

/// Explanatory permission required state for All Files Access.
class DocPermissionRequiredState extends StatelessWidget {
  final VoidCallback onGrantAccess;
  final VoidCallback onImportFiles;

  const DocPermissionRequiredState({
    super.key,
    required this.onGrantAccess,
    required this.onImportFiles,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: tokens.folder.tint,
                shape: BoxShape.circle,
              ),
              child: Icon(AppIcons.folderOpen, size: 42, color: tokens.folder.solid),
            ),
            const SizedBox(height: 24),
            Text(
              'All Files Access Required',
              textAlign: TextAlign.center,
              style: DocViewTypography.headlineSm.copyWith(color: tokens.textPrimary),
            ),
            const SizedBox(height: 10),
            Text(
              'Doc View needs All files access to browse folders and organize your documents completely offline.',
              textAlign: TextAlign.center,
              style: DocViewTypography.bodyMd.copyWith(color: tokens.textSecondary),
            ),
            const SizedBox(height: 28),
            DocPrimaryButton(
              label: 'Grant Access',
              onPressed: onGrantAccess,
            ),
            const SizedBox(height: 12),
            DocSecondaryButton(
              label: 'Import Files Instead',
              onPressed: onImportFiles,
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings grouped list item with leading icon, title, subtitle, and chevron/switch.
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: tokens.hairline, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: tokens.textSecondary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DocViewTypography.titleMd.copyWith(
                        fontSize: 15,
                        color: tokens.textPrimary,
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
              if (trailing != null)
                trailing!
              else if (onTap != null)
                Icon(AppIcons.chevronRight, size: 18, color: tokens.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Uppercase section header label for grouped lists.
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: DocViewTypography.labelXs.copyWith(
          color: tokens.sectionHeader,
          letterSpacing: 1.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Expandable accordion FAQ card with rotating chevron.
class ExpandableFaqCard extends StatefulWidget {
  final String question;
  final String answer;

  const ExpandableFaqCard({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<ExpandableFaqCard> createState() => _ExpandableFaqCardState();
}

class _ExpandableFaqCardState extends State<ExpandableFaqCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.hairline, width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
          trailing: AnimatedRotation(
            turns: _isExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(AppIcons.chevronDown, color: tokens.textSecondary),
          ),
          title: Text(
            widget.question,
            style: DocViewTypography.titleMd.copyWith(
              fontSize: 15,
              color: tokens.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(
              widget.answer,
              style: DocViewTypography.bodyMd.copyWith(
                color: tokens.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

