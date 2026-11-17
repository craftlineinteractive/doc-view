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

  @override
  String get splashTagline => 'All your documents, one place.';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionBack => 'Back';

  @override
  String get actionNext => 'Next';

  @override
  String get actionGetStarted => 'Get started';

  @override
  String get onboardingPage1Title => 'All your documents,\none place';

  @override
  String get onboardingPage1Desc =>
      'Doc View automatically finds PDFs, Word, Excel, PowerPoint, text files and images on your phone and organizes them for you.';

  @override
  String get onboardingPage2Title => 'Read anything,\nbeautifully';

  @override
  String get onboardingPage2Desc =>
      'Open PDFs, Word, Excel and PowerPoint files with a fast, clean reader. Search, bookmark and pick up where you left off.';

  @override
  String get onboardingPage3Title => 'Powerful PDF tools, offline';

  @override
  String get onboardingPage3Desc =>
      'Turn photos into PDFs, scan documents, merge and split files. Everything stays on your device.';

  @override
  String get onboardingOfflineGuarantee => '100% Offline • Private & Secure';

  @override
  String get toolImageToPdf => 'Image to PDF';

  @override
  String get toolImageToPdfSub => 'Convert JPG & PNG';

  @override
  String get toolScanToPdf => 'Scan to PDF';

  @override
  String get toolScanToPdfSub => 'Camera edge detect';

  @override
  String get toolMergePdf => 'Merge PDF';

  @override
  String get toolMergePdfSub => 'Combine into one';

  @override
  String get toolSplitPdf => 'Split PDF';

  @override
  String get toolSplitPdfSub => 'Extract any range';

  @override
  String get permissionTagStorage => 'Device Storage Access';

  @override
  String get permissionStorageHeadline => 'Let Doc View find your documents';

  @override
  String get permissionStorageBody =>
      'To list PDFs, Word, Excel and other files saved by any app, Android needs your permission to access all files. Your files never leave your phone.';

  @override
  String get permissionReassuranceOfflineTitle => 'Works offline';

  @override
  String get permissionReassuranceOfflineDesc =>
      'No internet connection required. Operates 100% locally.';

  @override
  String get permissionReassuranceNoUploadsTitle => 'No uploads';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      'Zero cloud servers. Your files stay strictly in phone memory.';

  @override
  String get permissionReassuranceChangeTitle => 'You can change this any time';

  @override
  String get permissionReassuranceChangeDesc =>
      'Easily toggle in your Android System App Settings.';

  @override
  String get permissionTagIOS => 'iOS Storage Guide';

  @override
  String get permissionIOSHeadline => 'Bring your documents to Doc View';

  @override
  String get permissionIOSBody =>
      'Due to Apple\'s privacy architecture, iOS doesn\'t allow any app to scan your entire phone automatically. Choose how you\'d like to read your files:';

  @override
  String get permissionIOSOptionImportTitle => 'Import files';

  @override
  String get permissionIOSBadgeFastest => 'FASTEST';

  @override
  String get permissionIOSOptionImportDesc =>
      'Pick documents directly from your iCloud Drive, Downloads, or any folder in seconds.';

  @override
  String get permissionIOSOptionFolderTitle =>
      'Open Doc View folder in Files app';

  @override
  String get permissionIOSOptionFolderDesc =>
      'Save or AirDrop documents directly into the \"Doc View\" folder in the iOS Files app for instant sync.';

  @override
  String get actionImportFiles => 'Import files';

  @override
  String get actionContinueToApp => 'Continue to app';

  @override
  String get permissionTagConsent => 'Transparency & Consent';

  @override
  String get permissionBadgeFree => '100% Free App';

  @override
  String get permissionBadgeMinimalAds => 'Minimal Ads';

  @override
  String get permissionConsentHeadline => 'Free with ads';

  @override
  String get permissionConsentBody =>
      'Doc View is free thanks to ads. We\'ll ask for your choice about personalised ads next.';

  @override
  String get permissionConsentAdsTitle => 'What ads you may see';

  @override
  String get permissionConsentAdsDesc =>
      'Small banner ads and non-intrusive sponsor cards. No popups or video interruptions while reading.';

  @override
  String get permissionConsentPrivateTitle =>
      'Documents stay completely private';

  @override
  String get permissionConsentPrivateDesc =>
      'Ad partners never have access to your document names, text contents, or file locations.';

  @override
  String get permissionConsentSettingsTitle =>
      'You can change your choice in Settings';

  @override
  String get permissionConsentSettingsDesc =>
      'Update personalized ad consent or privacy preferences anytime in Doc View Settings.';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionPrivacyPolicy => 'Privacy policy';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imported $count files',
      one: 'Imported 1 file',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => 'Failed to import files';

  @override
  String get tooltipImportDocuments => 'Import documents';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files found',
      one: '1 file found',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => 'Scanning...';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files',
      one: '1 file',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => 'Folders';

  @override
  String get errorLoadingRecent => 'Error loading recent files';

  @override
  String get emptyStateTitle => 'Empty';

  @override
  String get emptyRecentDescription => 'Recently opened files will appear here';

  @override
  String get errorLoadingBookmarks => 'Error loading bookmarked files';

  @override
  String get emptyBookmarksDescription =>
      'Bookmarked documents will appear here';

  @override
  String get dialogDeleteTitle => 'Delete selected files?';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count files? This cannot be undone.',
      one: 'Delete 1 file? This cannot be undone.',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deleted $count files',
      one: 'Deleted 1 file',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => 'Failed to delete files';

  @override
  String get actionDelete => 'Delete';

  @override
  String get searchRecentSearchesHeader => 'RECENT SEARCHES';

  @override
  String get actionClear => 'Clear';

  @override
  String get searchPromptTitle => 'Type to search documents';

  @override
  String get searchPromptMessage =>
      'Search across all local folders by filename or extension';

  @override
  String get searchError => 'Error searching documents';

  @override
  String get searchNoResultsTitle => 'No matching documents found';

  @override
  String get searchNoResultsMessage =>
      'Try searching with a different filename keyword or format filter';

  @override
  String get tooltipSortOptions => 'Sort options';

  @override
  String get sortSheetTitle => 'Sort by';

  @override
  String get sortOptionDate => 'Date modified';

  @override
  String get sortOptionName => 'Document name';

  @override
  String get sortOptionSize => 'File size';

  @override
  String get sortAscendingOrder => 'Ascending order';

  @override
  String get sortAscendingSubtitle => 'Oldest first / A to Z / Smallest first';

  @override
  String get sortDescendingSubtitle => 'Newest first / Z to A / Largest first';

  @override
  String get categoryAllFiles => 'All files';

  @override
  String get loadingStatus => 'Loading...';

  @override
  String get emptyCategoryImagesTitle => 'No images found';

  @override
  String get emptyCategoryImagesMessage =>
      'Images found on this device will appear here';

  @override
  String get emptyCategoryDocsTitle => 'No documents found';

  @override
  String get emptyCategoryDocsMessage =>
      'Documents of this format will appear here after scanning';
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

  @override
  String get splashTagline => '[Åłł ýôûř đôçûɱéñţš, ôñé þłàçé. ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String appVersion(String version) {
    return '[Ṽéřšîôñ $version ẋẋẋẋẋẋẋ]';
  }

  @override
  String onboardingStep(int current, int total) {
    return '[Šţéþ $current ôƒ $total ẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get actionSkip => '[Šƙîþ ẋẋ]';

  @override
  String get actionBack => '[Ɓàçƙ ẋẋ]';

  @override
  String get actionNext => '[Ñéẋţ ẋẋ]';

  @override
  String get actionGetStarted => '[Ĝéţ šţàřţéđ ẋẋẋẋẋ]';

  @override
  String get onboardingPage1Title =>
      '[Åłł ýôûř đôçûɱéñţš,\nôñé þłàçé ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get onboardingPage1Desc =>
      '[Ðôç Ṽîéŵ àûţôɱàţîçàłłý ƒîñđš ÞÐƑš, Ŵôřđ, Éẋçéł, ÞôŵéřÞôîñţ, ţéẋţ ƒîłéš àñđ îɱàĝéš ôñ ýôûř þĥôñé àñđ ôřĝàñîžéš ţĥéɱ ƒôř ýôû. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get onboardingPage2Title =>
      '[Řéàđ àñýţĥîñĝ,\nƀéàûţîƒûłłý ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get onboardingPage2Desc =>
      '[Öþéñ ÞÐƑš, Ŵôřđ, Éẋçéł àñđ ÞôŵéřÞôîñţ ƒîłéš ŵîţĥ à ƒàšţ, çłéàñ řéàđéř. Šéàřçĥ, ƀôôƙɱàřƙ àñđ þîçƙ ûþ ŵĥéřé ýôû łéƒţ ôƒƒ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get onboardingPage3Title =>
      '[Þôŵéřƒûł ÞÐƑ ţôôłš, ôƒƒłîñé ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get onboardingPage3Desc =>
      '[Ťûřñ þĥôţôš îñţô ÞÐƑš, šçàñ đôçûɱéñţš, ɱéřĝé àñđ šþłîţ ƒîłéš. Éṽéřýţĥîñĝ šţàýš ôñ ýôûř đéṽîçé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get onboardingOfflineGuarantee =>
      '[100% Öƒƒłîñé • Þřîṽàţé & Šéçûřé ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get toolImageToPdf => '[Îɱàĝé ţô ÞÐƑ ẋẋẋẋẋ]';

  @override
  String get toolImageToPdfSub => '[Çôñṽéřţ ĴÞĜ & ÞÑĜ ẋẋẋẋẋẋẋ]';

  @override
  String get toolScanToPdf => '[Šçàñ ţô ÞÐƑ ẋẋẋẋẋ]';

  @override
  String get toolScanToPdfSub => '[Çàɱéřà éđĝé đéţéçţ ẋẋẋẋẋẋẋẋ]';

  @override
  String get toolMergePdf => '[Ṁéřĝé ÞÐƑ ẋẋẋẋ]';

  @override
  String get toolMergePdfSub => '[Çôɱƀîñé îñţô ôñé ẋẋẋẋẋẋẋ]';

  @override
  String get toolSplitPdf => '[Šþłîţ ÞÐƑ ẋẋẋẋ]';

  @override
  String get toolSplitPdfSub => '[Éẋţřàçţ àñý řàñĝé ẋẋẋẋẋẋẋ]';

  @override
  String get permissionTagStorage => '[Ðéṽîçé Šţôřàĝé Åççéšš ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionStorageHeadline =>
      '[Łéţ Ðôç Ṽîéŵ ƒîñđ ýôûř đôçûɱéñţš ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionStorageBody =>
      '[Ťô łîšţ ÞÐƑš, Ŵôřđ, Éẋçéł àñđ ôţĥéř ƒîłéš šàṽéđ ƀý àñý àþþ, Åñđřôîđ ñééđš ýôûř þéřɱîššîôñ ţô àççéšš àłł ƒîłéš. Ýôûř ƒîłéš ñéṽéř łéàṽé ýôûř þĥôñé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionReassuranceOfflineTitle => '[Ŵôřƙš ôƒƒłîñé ẋẋẋẋẋẋ]';

  @override
  String get permissionReassuranceOfflineDesc =>
      '[Ñô îñţéřñéţ çôññéçţîôñ řéʠûîřéđ. Öþéřàţéš 100% łôçàłłý. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionReassuranceNoUploadsTitle => '[Ñô ûþłôàđš ẋẋẋẋ]';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      '[Žéřô çłôûđ šéřṽéřš. Ýôûř ƒîłéš šţàý šţřîçţłý îñ þĥôñé ɱéɱôřý. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionReassuranceChangeTitle =>
      '[Ýôû çàñ çĥàñĝé ţĥîš àñý ţîɱé ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionReassuranceChangeDesc =>
      '[Éàšîłý ţôĝĝłé îñ ýôûř Åñđřôîđ Šýšţéɱ Åþþ Šéţţîñĝš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionTagIOS => '[îÖŠ Šţôřàĝé Ĝûîđé ẋẋẋẋẋẋẋ]';

  @override
  String get permissionIOSHeadline =>
      '[Ɓřîñĝ ýôûř đôçûɱéñţš ţô Ðôç Ṽîéŵ ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionIOSBody =>
      '[Ðûé ţô Åþþłé\'š þřîṽàçý àřçĥîţéçţûřé, îÖŠ đôéšñ\'ţ àłłôŵ àñý àþþ ţô šçàñ ýôûř éñţîřé þĥôñé àûţôɱàţîçàłłý. Çĥôôšé ĥôŵ ýôû\'đ łîƙé ţô řéàđ ýôûř ƒîłéš: ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionIOSOptionImportTitle => '[Îɱþôřţ ƒîłéš ẋẋẋẋẋ]';

  @override
  String get permissionIOSBadgeFastest => '[ƑÅŠŤÉŠŤ ẋẋẋ]';

  @override
  String get permissionIOSOptionImportDesc =>
      '[Þîçƙ đôçûɱéñţš đîřéçţłý ƒřôɱ ýôûř îÇłôûđ Ðřîṽé, Ðôŵñłôàđš, ôř àñý ƒôłđéř îñ šéçôñđš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionIOSOptionFolderTitle =>
      '[Öþéñ Ðôç Ṽîéŵ ƒôłđéř îñ Ƒîłéš àþþ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionIOSOptionFolderDesc =>
      '[Šàṽé ôř ÅîřÐřôþ đôçûɱéñţš đîřéçţłý îñţô ţĥé \"Ðôç Ṽîéŵ\" ƒôłđéř îñ ţĥé îÖŠ Ƒîłéš àþþ ƒôř îñšţàñţ šýñç. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get actionImportFiles => '[Îɱþôřţ ƒîłéš ẋẋẋẋẋ]';

  @override
  String get actionContinueToApp => '[Çôñţîñûé ţô àþþ ẋẋẋẋẋẋ]';

  @override
  String get permissionTagConsent => '[Ťřàñšþàřéñçý & Çôñšéñţ ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionBadgeFree => '[100% Ƒřéé Åþþ ẋẋẋẋẋẋ]';

  @override
  String get permissionBadgeMinimalAds => '[Ṁîñîɱàł Åđš ẋẋẋẋẋ]';

  @override
  String get permissionConsentHeadline => '[Ƒřéé ŵîţĥ àđš ẋẋẋẋẋẋ]';

  @override
  String get permissionConsentBody =>
      '[Ðôç Ṽîéŵ îš ƒřéé ţĥàñƙš ţô àđš. Ŵé\'łł àšƙ ƒôř ýôûř çĥôîçé àƀôûţ þéřšôñàłîšéđ àđš ñéẋţ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionConsentAdsTitle => '[Ŵĥàţ àđš ýôû ɱàý šéé ẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionConsentAdsDesc =>
      '[Šɱàłł ƀàññéř àđš àñđ ñôñ-îñţřûšîṽé šþôñšôř çàřđš. Ñô þôþûþš ôř ṽîđéô îñţéřřûþţîôñš ŵĥîłé řéàđîñĝ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionConsentPrivateTitle =>
      '[Ðôçûɱéñţš šţàý çôɱþłéţéłý þřîṽàţé ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionConsentPrivateDesc =>
      '[Åđ þàřţñéřš ñéṽéř ĥàṽé àççéšš ţô ýôûř đôçûɱéñţ ñàɱéš, ţéẋţ çôñţéñţš, ôř ƒîłé łôçàţîôñš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionConsentSettingsTitle =>
      '[Ýôû çàñ çĥàñĝé ýôûř çĥôîçé îñ Šéţţîñĝš ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get permissionConsentSettingsDesc =>
      '[Ûþđàţé þéřšôñàłîžéđ àđ çôñšéñţ ôř þřîṽàçý þřéƒéřéñçéš àñýţîɱé îñ Ðôç Ṽîéŵ Šéţţîñĝš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get actionContinue => '[Çôñţîñûé ẋẋẋẋ]';

  @override
  String get actionPrivacyPolicy => '[Þřîṽàçý þôłîçý ẋẋẋẋẋẋ]';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[Îɱþôřţéđ $count ƒîłéš ẋẋẋẋẋẋẋẋẋ]',
      one: '[Îɱþôřţéđ 1 ƒîłé ẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => '[Ƒàîłéđ ţô îɱþôřţ ƒîłéš ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get tooltipImportDocuments => '[Îɱþôřţ đôçûɱéñţš ẋẋẋẋẋẋẋ]';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count ƒîłéš ƒôûñđ ẋẋẋẋẋẋẋẋ]',
      one: '[1 ƒîłé ƒôûñđ ẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => '[Šçàññîñĝ... ẋẋẋẋẋ]';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count ƒîłéš ẋẋẋẋẋẋ]',
      one: '[1 ƒîłé ẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => '[Ƒôłđéřš ẋẋẋ]';

  @override
  String get errorLoadingRecent => '[Éřřôř łôàđîñĝ řéçéñţ ƒîłéš ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get emptyStateTitle => '[Éɱþţý ẋẋ]';

  @override
  String get emptyRecentDescription =>
      '[Řéçéñţłý ôþéñéđ ƒîłéš ŵîłł àþþéàř ĥéřé ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get errorLoadingBookmarks =>
      '[Éřřôř łôàđîñĝ ƀôôƙɱàřƙéđ ƒîłéš ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get emptyBookmarksDescription =>
      '[Ɓôôƙɱàřƙéđ đôçûɱéñţš ŵîłł àþþéàř ĥéřé ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get dialogDeleteTitle => '[Ðéłéţé šéłéçţéđ ƒîłéš? ẋẋẋẋẋẋẋẋẋ]';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[Ðéłéţé $count ƒîłéš? Ťĥîš çàññôţ ƀé ûñđôñé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]',
      one: '[Ðéłéţé 1 ƒîłé? Ťĥîš çàññôţ ƀé ûñđôñé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[Ðéłéţéđ $count ƒîłéš ẋẋẋẋẋẋẋẋẋ]',
      one: '[Ðéłéţéđ 1 ƒîłé ẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => '[Ƒàîłéđ ţô đéłéţé ƒîłéš ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get actionDelete => '[Ðéłéţé ẋẋẋ]';

  @override
  String get searchRecentSearchesHeader => '[ŘÉÇÉÑŤ ŠÉÅŘÇĦÉŠ ẋẋẋẋẋẋ]';

  @override
  String get actionClear => '[Çłéàř ẋẋ]';

  @override
  String get searchPromptTitle => '[Ťýþé ţô šéàřçĥ đôçûɱéñţš ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get searchPromptMessage =>
      '[Šéàřçĥ àçřôšš àłł łôçàł ƒôłđéřš ƀý ƒîłéñàɱé ôř éẋţéñšîôñ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get searchError => '[Éřřôř šéàřçĥîñĝ đôçûɱéñţš ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get searchNoResultsTitle =>
      '[Ñô ɱàţçĥîñĝ đôçûɱéñţš ƒôûñđ ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get searchNoResultsMessage =>
      '[Ťřý šéàřçĥîñĝ ŵîţĥ à đîƒƒéřéñţ ƒîłéñàɱé ƙéýŵôřđ ôř ƒôřɱàţ ƒîłţéř ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get tooltipSortOptions => '[Šôřţ ôþţîôñš ẋẋẋẋẋ]';

  @override
  String get sortSheetTitle => '[Šôřţ ƀý ẋẋẋ]';

  @override
  String get sortOptionDate => '[Ðàţé ɱôđîƒîéđ ẋẋẋẋẋẋ]';

  @override
  String get sortOptionName => '[Ðôçûɱéñţ ñàɱé ẋẋẋẋẋẋ]';

  @override
  String get sortOptionSize => '[Ƒîłé šîžé ẋẋẋẋ]';

  @override
  String get sortAscendingOrder => '[Åšçéñđîñĝ ôřđéř ẋẋẋẋẋẋ]';

  @override
  String get sortAscendingSubtitle =>
      '[Öłđéšţ ƒîřšţ / Å ţô Ž / Šɱàłłéšţ ƒîřšţ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get sortDescendingSubtitle =>
      '[Ñéŵéšţ ƒîřšţ / Ž ţô Å / Łàřĝéšţ ƒîřšţ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get categoryAllFiles => '[Åłł ƒîłéš ẋẋẋẋ]';

  @override
  String get loadingStatus => '[Łôàđîñĝ... ẋẋẋẋ]';

  @override
  String get emptyCategoryImagesTitle => '[Ñô îɱàĝéš ƒôûñđ ẋẋẋẋẋẋ]';

  @override
  String get emptyCategoryImagesMessage =>
      '[Îɱàĝéš ƒôûñđ ôñ ţĥîš đéṽîçé ŵîłł àþþéàř ĥéřé ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get emptyCategoryDocsTitle => '[Ñô đôçûɱéñţš ƒôûñđ ẋẋẋẋẋẋẋẋ]';

  @override
  String get emptyCategoryDocsMessage =>
      '[Ðôçûɱéñţš ôƒ ţĥîš ƒôřɱàţ ŵîłł àþþéàř ĥéřé àƒţéř šçàññîñĝ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
}
