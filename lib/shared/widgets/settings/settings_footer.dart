import 'package:flutter/material.dart';

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// Centered Settings footer displaying semantic app version + build number.
class SettingsFooter extends StatelessWidget {
  const SettingsFooter({
    super.key,
    required this.version,
    required this.buildNumber,
    this.onVersionLongPress,
  });

  final String version;
  final String buildNumber;
  final VoidCallback? onVersionLongPress;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 28),
      child: Center(
        child: Semantics(
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
      ),
    );
  }
}
