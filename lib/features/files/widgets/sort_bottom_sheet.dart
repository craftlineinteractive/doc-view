import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../data/models/sort_option.dart';
import '../../providers/providers.dart';

/// Bottom sheet allowing users to customize sorting by Date, Name, or Size
/// with ascending/descending directional toggle.
class SortBottomSheet extends ConsumerWidget {
  const SortBottomSheet({super.key});

  /// Convenience helper to display the sort modal bottom sheet.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const SortBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentSort = ref.watch(sortOptionProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? tokens.surface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: tokens.hairline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Text(
                'Sort by',
                style: DocViewTypography.headlineSm.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              // Sort Field Options
              _SortFieldOption(
                label: 'Date modified',
                field: SortField.date,
                selectedField: currentSort.field,
                onSelect: (field) {
                  ref
                      .read(sortOptionProvider.notifier)
                      .setSortOption(currentSort.copyWith(field: field));
                },
              ),
              _SortFieldOption(
                label: 'Document name',
                field: SortField.name,
                selectedField: currentSort.field,
                onSelect: (field) {
                  ref
                      .read(sortOptionProvider.notifier)
                      .setSortOption(currentSort.copyWith(field: field));
                },
              ),
              _SortFieldOption(
                label: 'File size',
                field: SortField.size,
                selectedField: currentSort.field,
                onSelect: (field) {
                  ref
                      .read(sortOptionProvider.notifier)
                      .setSortOption(currentSort.copyWith(field: field));
                },
              ),

              const SizedBox(height: 8),
              Divider(color: tokens.hairline, height: 1),
              const SizedBox(height: 12),

              // Ascending / Descending Direction Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: tokens.primaryBlue,
                title: Text(
                  'Ascending order',
                  style: DocViewTypography.titleMd.copyWith(
                    color: tokens.textPrimary,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  currentSort.direction == SortDirection.asc
                      ? 'Oldest first / A to Z / Smallest first'
                      : 'Newest first / Z to A / Largest first',
                  style: DocViewTypography.bodySm.copyWith(
                    color: tokens.textSecondary,
                  ),
                ),
                value: currentSort.direction == SortDirection.asc,
                onChanged: (isAsc) {
                  ref.read(sortOptionProvider.notifier).setSortOption(
                        currentSort.copyWith(
                          direction: isAsc
                              ? SortDirection.asc
                              : SortDirection.desc,
                        ),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortFieldOption extends StatelessWidget {
  final String label;
  final SortField field;
  final SortField selectedField;
  final ValueChanged<SortField> onSelect;

  const _SortFieldOption({
    required this.label,
    required this.field,
    required this.selectedField,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isSelected = field == selectedField;

    return InkWell(
      onTap: () => onSelect(field),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: DocViewTypography.bodyLg.copyWith(
                color: isSelected ? tokens.primaryBlue : tokens.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                size: 20,
                color: tokens.primaryBlue,
              ),
          ],
        ),
      ),
    );
  }
}
