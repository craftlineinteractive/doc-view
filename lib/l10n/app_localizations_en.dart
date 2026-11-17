// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Doc View';

  @override
  String get navHome => 'All files';

  @override
  String get navTools => 'Tools';

  @override
  String get navSettings => 'Settings';
}

/// The translations for English (`en_XA`).
class AppLocalizationsEnXa extends AppLocalizationsEn {
  AppLocalizationsEnXa() : super('en_XA');

  @override
  String get appTitle => '[Ðôç Ṽîéŵ ẋẋẋẋ]';

  @override
  String get navHome => '[Åłł ƒîłéš ẋẋẋẋ]';

  @override
  String get navTools => '[Ťôôłš ẋẋ]';

  @override
  String get navSettings => '[Šéţţîñĝš ẋẋẋẋ]';
}
