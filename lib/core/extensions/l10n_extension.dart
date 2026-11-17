import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

/// Extension providing easy, type-safe access to [AppLocalizations].
/// Falls back to default English localizations if no delegate is found in context
/// (e.g. lightweight widget unit tests).
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n {
    return AppLocalizations.of(this) ?? lookupAppLocalizations(const Locale('en'));
  }
}
