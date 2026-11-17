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

  @override
  String get noDocumentSelected => 'No document selected';

  @override
  String get tooltipCloseAd => 'Close ad';

  @override
  String get tooltipClose => 'Close';

  @override
  String get tooltipRescan => 'Rescan documents';

  @override
  String get tooltipSearch => 'Search documents';

  @override
  String get tooltipSelectFiles => 'Select files';

  @override
  String get tooltipBack => 'Back';

  @override
  String get tooltipCancelSelection => 'Cancel selection';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'Select all';

  @override
  String get actionDeselectAll => 'Deselect all';

  @override
  String get tooltipDeleteSelected => 'Delete selected';

  @override
  String get tooltipClearSearch => 'Clear search';

  @override
  String get searchHint => 'Search documents, folders...';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return 'Page $page of $total';
  }

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get actionRetry => 'Retry';

  @override
  String get permissionAllFilesTitle => 'All Files Access Required';

  @override
  String get permissionAllFilesExplanation =>
      'Doc View needs All files access to browse folders and organize your documents completely offline.';

  @override
  String get actionGrantAccess => 'Grant Access';

  @override
  String get actionImportFilesInstead => 'Import Files Instead';

  @override
  String get tooltipRemoveBookmark => 'Remove bookmark';

  @override
  String get tooltipAddBookmark => 'Add bookmark';

  @override
  String tooltipFileOptions(String title) {
    return 'File options for $title';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return 'Folder, $name$subtitle';
  }

  @override
  String get adAdvertisementBadge => 'ADVERTISEMENT';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get tabRecent => 'Recent';

  @override
  String get tabBookmarks => 'Bookmarks';

  @override
  String get filterCategoryAll => 'All';

  @override
  String get actionBrowse => 'Browse';

  @override
  String get actionCancelOperation => 'Cancel Operation';

  @override
  String get operationComplete => 'Operation Complete';

  @override
  String get actionOpenDocument => 'Open Document';

  @override
  String get actionShareDocument => 'Share Document';
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

  @override
  String get noDocumentSelected => '[Ñô đôçûɱéñţ šéłéçţéđ ẋẋẋẋẋẋẋẋ]';

  @override
  String get tooltipCloseAd => '[Çłôšé àđ ẋẋẋẋ]';

  @override
  String get tooltipClose => '[Çłôšé ẋẋ]';

  @override
  String get tooltipRescan => '[Řéšçàñ đôçûɱéñţš ẋẋẋẋẋẋẋ]';

  @override
  String get tooltipSearch => '[Šéàřçĥ đôçûɱéñţš ẋẋẋẋẋẋẋ]';

  @override
  String get tooltipSelectFiles => '[Šéłéçţ ƒîłéš ẋẋẋẋẋ]';

  @override
  String get tooltipBack => '[Ɓàçƙ ẋẋ]';

  @override
  String get tooltipCancelSelection => '[Çàñçéł šéłéçţîôñ ẋẋẋẋẋẋẋ]';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count šéłéçţéđ ẋẋẋẋẋẋẋ]',
      one: '[1 šéłéçţéđ ẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => '[Šéłéçţ àłł ẋẋẋẋ]';

  @override
  String get actionDeselectAll => '[Ðéšéłéçţ àłł ẋẋẋẋẋ]';

  @override
  String get tooltipDeleteSelected => '[Ðéłéţé šéłéçţéđ ẋẋẋẋẋẋ]';

  @override
  String get tooltipClearSearch => '[Çłéàř šéàřçĥ ẋẋẋẋẋ]';

  @override
  String get searchHint => '[Šéàřçĥ đôçûɱéñţš, ƒôłđéřš... ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return '[Þàĝé $page ôƒ $total ẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get errorGenericTitle => '[Šôɱéţĥîñĝ ŵéñţ ŵřôñĝ ẋẋẋẋẋẋẋẋ]';

  @override
  String get actionRetry => '[Řéţřý ẋẋ]';

  @override
  String get permissionAllFilesTitle =>
      '[Åłł Ƒîłéš Åççéšš Řéʠûîřéđ ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionAllFilesExplanation =>
      '[Ðôç Ṽîéŵ ñééđš Åłł ƒîłéš àççéšš ţô ƀřôŵšé ƒôłđéřš àñđ ôřĝàñîžé ýôûř đôçûɱéñţš çôɱþłéţéłý ôƒƒłîñé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get actionGrantAccess => '[Ĝřàñţ Åççéšš ẋẋẋẋẋ]';

  @override
  String get actionImportFilesInstead => '[Îɱþôřţ Ƒîłéš Îñšţéàđ ẋẋẋẋẋẋẋẋ]';

  @override
  String get tooltipRemoveBookmark => '[Řéɱôṽé ƀôôƙɱàřƙ ẋẋẋẋẋẋ]';

  @override
  String get tooltipAddBookmark => '[Åđđ ƀôôƙɱàřƙ ẋẋẋẋẋ]';

  @override
  String tooltipFileOptions(String title) {
    return '[Ƒîłé ôþţîôñš ƒôř $title ẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return '[Ƒôłđéř, $name$subtitle ẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get adAdvertisementBadge => '[ÅÐṼÉŘŤÎŠÉṀÉÑŤ ẋẋẋẋẋẋ]';

  @override
  String get actionConfirm => '[Çôñƒîřɱ ẋẋẋ]';

  @override
  String get actionCancel => '[Çàñçéł ẋẋẋ]';

  @override
  String get tabRecent => '[Řéçéñţ ẋẋẋ]';

  @override
  String get tabBookmarks => '[Ɓôôƙɱàřƙš ẋẋẋẋ]';

  @override
  String get filterCategoryAll => '[Åłł ẋẋ]';

  @override
  String get actionBrowse => '[Ɓřôŵšé ẋẋẋ]';

  @override
  String get actionCancelOperation => '[Çàñçéł Öþéřàţîôñ ẋẋẋẋẋẋẋ]';

  @override
  String get operationComplete => '[Öþéřàţîôñ Çôɱþłéţé ẋẋẋẋẋẋẋẋ]';

  @override
  String get actionOpenDocument => '[Öþéñ Ðôçûɱéñţ ẋẋẋẋẋẋ]';

  @override
  String get actionShareDocument => '[Šĥàřé Ðôçûɱéñţ ẋẋẋẋẋẋ]';
}
