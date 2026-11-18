import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../extensions/l10n_extension.dart';

/// Descriptor for a supported or planned application language.
@immutable
class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.nativeName,
    required this.englishName,
    this.isRtl = false,
    required this.isShipped,
    this.isPseudo = false,
  });

  final String code;
  final String nativeName;
  final String englishName;
  final bool isRtl;
  final bool isShipped;
  final bool isPseudo;

  /// Whether selecting this entry can actively switch the app's live locale.
  bool get isSelectable => isShipped || (!kReleaseMode && isPseudo);
}

/// Central catalog of shipped, planned, and debug pseudo-locale languages.
class LanguageCatalog {
  const LanguageCatalog._();

  static const String pseudoLocaleCode = 'en_XA';

  /// Locale codes backed by a shipped ARB file in [AppLocalizations.supportedLocales],
  /// excluding the debug pseudo-locale (`en_XA`).
  static Set<String> get shippedCodes {
    final codes = <String>{};
    for (final locale in AppLocalizations.supportedLocales) {
      final code = locale.countryCode != null && locale.countryCode!.isNotEmpty
          ? '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;
      if (code == pseudoLocaleCode) continue;
      codes.add(code);
    }
    return codes;
  }

  static bool _isCodeShipped(String code) {
    final normalized = code.replaceAll('-', '_');
    return shippedCodes.contains(normalized);
  }

  /// All planned Doc View languages with live [isShipped] detection.
  static List<AppLanguage> get plannedLanguages => <AppLanguage>[
        AppLanguage(
          code: 'en',
          nativeName: 'English',
          englishName: 'English',
          isShipped: _isCodeShipped('en'),
        ),
        AppLanguage(
          code: 'hi',
          nativeName: 'हिन्दी',
          englishName: 'Hindi',
          isShipped: _isCodeShipped('hi'),
        ),
        AppLanguage(
          code: 'gu',
          nativeName: 'ગુજરાતી',
          englishName: 'Gujarati',
          isShipped: _isCodeShipped('gu'),
        ),
        AppLanguage(
          code: 'es',
          nativeName: 'Español',
          englishName: 'Spanish',
          isShipped: _isCodeShipped('es'),
        ),
        AppLanguage(
          code: 'pt-BR',
          nativeName: 'Português (Brasil)',
          englishName: 'Portuguese (Brazil)',
          isShipped: _isCodeShipped('pt-BR'),
        ),
        AppLanguage(
          code: 'fr',
          nativeName: 'Français',
          englishName: 'French',
          isShipped: _isCodeShipped('fr'),
        ),
        AppLanguage(
          code: 'de',
          nativeName: 'Deutsch',
          englishName: 'German',
          isShipped: _isCodeShipped('de'),
        ),
        AppLanguage(
          code: 'ar',
          nativeName: 'العربية',
          englishName: 'Arabic',
          isRtl: true,
          isShipped: _isCodeShipped('ar'),
        ),
        AppLanguage(
          code: 'id',
          nativeName: 'Bahasa Indonesia',
          englishName: 'Indonesian',
          isShipped: _isCodeShipped('id'),
        ),
        AppLanguage(
          code: 'ru',
          nativeName: 'Русский',
          englishName: 'Russian',
          isShipped: _isCodeShipped('ru'),
        ),
      ];

  /// Only languages whose ARB files are actually shipped.
  static List<AppLanguage> get shippedLanguages =>
      plannedLanguages.where((l) => l.isShipped).toList(growable: false);

  /// Debug-only pseudo-locale entry.
  static AppLanguage pseudoLocale(BuildContext context) => AppLanguage(
        code: pseudoLocaleCode,
        nativeName: context.l10n.languagePseudoLocaleName,
        englishName: context.l10n.languagePseudoLocaleSubtitle,
        isShipped: false,
        isPseudo: true,
      );

  /// Returns languages visible on the Language screen for the given build mode.
  /// Release builds show ONLY shipped languages; debug builds also include
  /// the pseudo-locale (`en_XA`) and planned unshipped languages.
  static List<AppLanguage> visibleLanguages(
    BuildContext context, {
    bool isRelease = kReleaseMode,
  }) {
    if (isRelease) {
      return shippedLanguages;
    }
    final shipped = shippedLanguages;
    final unshipped =
        plannedLanguages.where((l) => !l.isShipped).toList(growable: false);
    return <AppLanguage>[
      ...shipped,
      pseudoLocale(context),
      ...unshipped,
    ];
  }

  /// Whether the "Language" row should appear in Settings.
  /// Shown in release ONLY when more than one language is shipped; always shown in debug.
  static bool shouldShowLanguageSetting({
    bool isRelease = kReleaseMode,
    int? shippedCountOverride,
  }) {
    if (!isRelease) return true;
    final count = shippedCountOverride ?? shippedLanguages.length;
    return count > 1;
  }

  /// Returns the display label in native script for the currently active [localeCode].
  static String displayNameForCode(BuildContext context, String? localeCode) {
    if (localeCode == null) {
      return context.l10n.languageSystemDefault;
    }
    if (localeCode == pseudoLocaleCode) {
      return context.l10n.languagePseudoLocaleName;
    }
    final normalized = localeCode.replaceAll('_', '-');
    for (final lang in plannedLanguages) {
      if (lang.code == localeCode || lang.code == normalized) {
        return lang.nativeName;
      }
    }
    return context.l10n.languageSystemDefault;
  }
}
