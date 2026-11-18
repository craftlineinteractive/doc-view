import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Centered Settings footer displaying semantic app version + build number
/// and a small "Open-source licenses" link directly underneath.
class SettingsFooter extends StatelessWidget {
  const SettingsFooter({
    super.key,
    required this.version,
    required this.buildNumber,
    required this.onOpenLicenses,
    this.onVersionLongPress,
  });

  final String version;
  final String buildNumber;
  final VoidCallback onOpenLicenses;
  final VoidCallback? onVersionLongPress;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: context.l10n.settingsVersionSemantics(version, buildNumber),
            child: GestureDetector(
              key: const Key('settings_version'),
              onLongPress: onVersionLongPress,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ExcludeSemantics(
                  child: Text(
                    context.l10n.settingsVersionDisplay(version, buildNumber),
                    textAlign: TextAlign.center,
                    style: DocViewTypography.bodySm.copyWith(
                      color: tokens.textSecondary,
                      fontWeight: FontWeight.w500,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          TextButton(
            key: const Key('settings_licenses'),
            onPressed: onOpenLicenses,
            style: TextButton.styleFrom(
              foregroundColor: tokens.textSecondary,
              minimumSize: const Size(48, 48),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.padded,
            ),
            child: Text(
              context.l10n.settingsOpenSourceLicenses,
              textAlign: TextAlign.center,
              style: DocViewTypography.captionXs.copyWith(
                color: tokens.textSecondary,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: tokens.textSecondary.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
