import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

/// Extension on [BuildContext] providing quick and typed access to [AppLocalizations].
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    assert(
      localizations != null,
      'No AppLocalizations found in context. Ensure MaterialApp defines AppLocalizations.localizationsDelegates.',
    );
    return localizations!;
  }
}
