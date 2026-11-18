import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/l10n_extension.dart';
import '../../core/l10n/language_catalog.dart';
import '../../core/theme/app_icons.dart';
import '../../shared/widgets/inputs/doc_inputs.dart';
import '../../shared/widgets/navigation/doc_app_bar.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';
import '../../shared/widgets/settings/language_tile.dart';
import '../../shared/widgets/status/doc_status_widgets.dart';
import '../../shared/widgets/tiles/settings_row.dart';
import '../providers/providers.dart';

/// Language selection screen copying Scan Settings radio-card layout plus
/// SearchScreen's search field pattern. Applies selections live via [localeProvider].
class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({
    super.key,
    this.isReleaseOverride,
  });

  /// Optional test override to exercise release vs debug language visibility.
  final bool? isReleaseOverride;

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final selectedCode = settings.localeCode;
    final isRelease = widget.isReleaseOverride ?? kReleaseMode;

    final allLanguages = LanguageCatalog.visibleLanguages(
      context,
      isRelease: isRelease,
    );

    final trimmedQuery = _query.trim().toLowerCase();
    final showSystemDefault = trimmedQuery.isEmpty ||
        context.l10n.languageSystemDefault.toLowerCase().contains(trimmedQuery) ||
        context.l10n.languageSystemDefaultSubtitle
            .toLowerCase()
            .contains(trimmedQuery);

    final filteredLanguages = trimmedQuery.isEmpty
        ? allLanguages
        : allLanguages.where((lang) {
            return lang.nativeName.toLowerCase().contains(trimmedQuery) ||
                lang.englishName.toLowerCase().contains(trimmedQuery) ||
                lang.code.toLowerCase().contains(trimmedQuery);
          }).toList(growable: false);

    final rows = <Widget>[
      if (showSystemDefault)
        LanguageTile(
          key: const Key('lang_system_default'),
          title: context.l10n.languageSystemDefault,
          subtitle: context.l10n.languageSystemDefaultSubtitle,
          isSelected: selectedCode == null,
          onTap: () {
            ref.read(settingsProvider.notifier).setLocaleCode(null);
          },
        ),
      for (final lang in filteredLanguages)
        LanguageTile(
          key: Key('lang_${lang.code}'),
          title: lang.nativeName,
          subtitle:
              lang.nativeName == lang.englishName ? null : lang.englishName,
          trailingBadge: (!lang.isShipped && !lang.isPseudo)
              ? context.l10n.languageNotTranslatedBadge
              : null,
          isSelected: selectedCode == lang.code,
          isEnabled: lang.isShipped || (!isRelease && lang.isPseudo),
          onTap: () {
            if (lang.isShipped || (!isRelease && lang.isPseudo)) {
              ref.read(settingsProvider.notifier).setLocaleCode(lang.code);
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.languageNotTranslatedSnack),
                ),
              );
            }
          },
        ),
    ];

    return DocScaffold(
      applyHeaderGradient: true,
      showDockedBanner: true,
      isAdLoaded: true,
      appBar: DocSubAppBar(
        title: context.l10n.languageScreenTitle,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 8),
            child: DocSearchField(
              controller: _searchController,
              hintText: context.l10n.languageSearchHint,
              onChanged: (value) => setState(() => _query = value),
              onClear: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
          ),
          Expanded(
            child: rows.isEmpty
                ? DocEmptyState(
                    icon: AppIcons.search,
                    title: context.l10n.languageNoResults,
                    message: context.l10n.languageSearchHint,
                  )
                : ListView(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      20,
                      8,
                      20,
                      24,
                    ),
                    children: [
                      SettingsGroupCard(children: rows),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
