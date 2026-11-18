import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../shared/widgets/sheets/doc_bottom_sheet.dart';
import '../../providers/providers.dart';

/// Interactive App Theme selection bottom sheet matching mockups 07_settings/02_settings_sub_screens.
/// Displays 3 mini phone preview cards ("System default", "Light", "Dark") and updates theme live on Apply.
class ThemeSelectionSheet extends ConsumerStatefulWidget {
  const ThemeSelectionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ThemeSelectionSheet(),
    );
  }

  @override
  ConsumerState<ThemeSelectionSheet> createState() => _ThemeSelectionSheetState();
}

class _ThemeSelectionSheetState extends ConsumerState<ThemeSelectionSheet> {
  late ThemeMode _selectedMode;

  @override
  void initState() {
    super.initState();
    _selectedMode = ref.read(settingsProvider).themeMode;
  }

  void _applyTheme() {
    ref.read(settingsProvider.notifier).setThemeMode(_selectedMode);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DocBottomSheet(
      title: context.l10n.themeSheetTitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.themeSheetSubtitle,
            style: DocViewTypography.bodySm.copyWith(
              color: tokens.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ThemePreviewCard(
                  key: const Key('theme_card_system'),
                  title: context.l10n.themeModeSystem,
                  subtitle: context.l10n.themeModeSystemSubtitle,
                  isSelected: _selectedMode == ThemeMode.system,
                  onTap: () => setState(() => _selectedMode = ThemeMode.system),
                  preview: const _SystemPreview(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ThemePreviewCard(
                  key: const Key('theme_card_light'),
                  title: context.l10n.themeModeLight,
                  subtitle: context.l10n.themeModeLightSubtitle,
                  isSelected: _selectedMode == ThemeMode.light,
                  onTap: () => setState(() => _selectedMode = ThemeMode.light),
                  preview: const _LightPreview(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ThemePreviewCard(
                  key: const Key('theme_card_dark'),
                  title: context.l10n.themeModeDark,
                  subtitle: context.l10n.themeModeDarkSubtitle,
                  isSelected: _selectedMode == ThemeMode.dark,
                  onTap: () => setState(() => _selectedMode = ThemeMode.dark),
                  preview: const _DarkPreview(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              key: const Key('btn_apply_theme'),
              onPressed: _applyTheme,
              style: ElevatedButton.styleFrom(
                backgroundColor: tokens.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                context.l10n.themeActionApply,
                style: DocViewTypography.labelLg.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget preview;

  const _ThemePreviewCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title $subtitle, ${isSelected ? context.l10n.semanticSelected : context.l10n.semanticNotSelected}',
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? tokens.primaryBlue : tokens.hairline,
                  width: isSelected ? 2.0 : 1.0,
                ),
              ),
              child: Column(
                children: [
                  preview,
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: DocViewTypography.labelMd.copyWith(
                      color: isSelected ? tokens.primaryBlue : tokens.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: DocViewTypography.captionXs.copyWith(
                      color: tokens.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              PositionedDirectional(
                top: -6,
                end: -4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: tokens.primaryBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SystemPreview extends StatelessWidget {
  const _SystemPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E9F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Row(
            children: [
              // Light half
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9F2FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 4,
                        width: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F5FA),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F5FA),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Dark half
              Expanded(
                child: Container(
                  color: const Color(0xFF1A1D29),
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3042),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 4,
                        width: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF232838),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF232838),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Center split badge
          Center(
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.brightness_medium_rounded,
                size: 14,
                color: Color(0xFF1A66E8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LightPreview extends StatelessWidget {
  const _LightPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E9F0)),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE9F2FF), Colors.white],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5FA),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5FA),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5FA),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Spacer(),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              context.l10n.themePreviewLight,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A66E8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkPreview extends StatelessWidget {
  const _DarkPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A3042)),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF232838),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF232838),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF232838),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF232838),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Spacer(),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A45),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              context.l10n.themePreviewNavy,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D8FF7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

