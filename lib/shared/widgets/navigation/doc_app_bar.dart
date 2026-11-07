import 'package:flutter/material.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../buttons/doc_icon_button.dart';

/// Top App Bar for the Home screen.
/// Features "Doc View" brand headline, Search action button, and Multi-select trigger.
class DocHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onSelectTap;
  final VoidCallback? onScanTap;

  const DocHomeAppBar({
    super.key,
    required this.onSearchTap,
    required this.onSelectTap,
    this.onScanTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      title: Text(
        'Doc View',
        style: DocViewTypography.headlineLg.copyWith(
          color: tokens.textPrimary,
        ),
      ),
      actions: [
        if (onScanTap != null)
          DocIconButton(
            icon: AppIcons.refresh,
            tooltip: 'Rescan documents',
            onPressed: onScanTap,
          ),
        DocIconButton(
          icon: AppIcons.search,
          tooltip: 'Search documents',
          onPressed: onSearchTap,
        ),
        DocIconButton(
          icon: AppIcons.selectAll,
          tooltip: 'Select files',
          onPressed: onSelectTap,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

/// Standard Sub-screen App Bar with back navigation, centered or start title, and actions.
class DocSubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  const DocSubAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.leading,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(56 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: leading ??
          (Navigator.canPop(context) || onBack != null
              ? DocIconButton(
                  icon: AppIcons.back,
                  tooltip: 'Back',
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                )
              : null),
      title: Text(
        title,
        style: DocViewTypography.headlineSm.copyWith(
          color: tokens.textPrimary,
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}

/// App Bar displayed when multi-selection mode is active.
class DocSelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedCount;
  final int totalCount;
  final VoidCallback onSelectAll;
  final VoidCallback onCancel;
  final VoidCallback? onDelete;

  const DocSelectionAppBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.onSelectAll,
    required this.onCancel,
    this.onDelete,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final allSelected = selectedCount > 0 && selectedCount == totalCount;

    return AppBar(
      backgroundColor: tokens.surfaceAlt,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: DocIconButton(
        icon: AppIcons.close,
        tooltip: 'Cancel selection',
        onPressed: onCancel,
      ),
      title: Text(
        '$selectedCount selected',
        style: DocViewTypography.headlineSm.copyWith(
          color: tokens.textPrimary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onSelectAll,
          child: Text(
            allSelected ? 'Deselect all' : 'Select all',
            style: DocViewTypography.labelMd.copyWith(
              color: tokens.primaryBlue,
            ),
          ),
        ),
        if (onDelete != null && selectedCount > 0)
          DocIconButton(
            icon: AppIcons.delete,
            tooltip: 'Delete selected',
            color: DocViewColors.error,
            onPressed: onDelete,
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}

/// Search App Bar featuring pill-style search input with back navigation.
class DocSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onBack;
  final String hintText;
  final bool autofocus;

  const DocSearchAppBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.onBack,
    this.hintText = 'Search documents, folders...',
    this.autofocus = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: DocIconButton(
        icon: AppIcons.back,
        tooltip: 'Back',
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      ),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: tokens.hairline, width: 1),
          ),
          child: TextField(
            controller: controller,
            autofocus: autofocus,
            onChanged: onChanged,
            style: DocViewTypography.bodyLg.copyWith(color: tokens.textPrimary),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: DocViewTypography.bodyMd.copyWith(color: tokens.textSecondary),
              prefixIcon: Icon(AppIcons.search, size: 20, color: tokens.textSecondary),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(AppIcons.close, size: 18),
                      tooltip: 'Clear search',
                      onPressed: () {
                        controller.clear();
                        onClear?.call();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ),
      ),
    );
  }
}
