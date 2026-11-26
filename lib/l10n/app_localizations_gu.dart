// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'Doc View';

  @override
  String get navHome => 'બધી ફાઇલો';

  @override
  String get navTools => 'ટૂલ્સ';

  @override
  String get navSettings => 'સેટિંગ્સ';

  @override
  String get noDocumentSelected => 'કોઈ દસ્તાવેજ પસંદ કરેલ નથી';

  @override
  String get tooltipCloseAd => 'જાહેરાત બંધ કરો';

  @override
  String get tooltipClose => 'બંધ કરો';

  @override
  String get tooltipRescan => 'દસ્તાવેજો ફરી સ્કેન કરો';

  @override
  String get tooltipSearch => 'દસ્તાવેજો શોધો';

  @override
  String get tooltipSelectFiles => 'ફાઇલો પસંદ કરો';

  @override
  String get tooltipBack => 'પાછળ';

  @override
  String get tooltipCancelSelection => 'પસંદગી રદ કરો';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પસંદ કરેલ',
      one: '1 પસંદ કરેલ',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'બધું પસંદ કરો';

  @override
  String get actionDeselectAll => 'બધી પસંદગી દૂર કરો';

  @override
  String get tooltipDeleteSelected => 'પસંદ કરેલ કાઢી નાખો';

  @override
  String get tooltipClearSearch => 'શોધ સાફ કરો';

  @override
  String get searchHint => 'દસ્તાવેજો, ફોલ્ડર્સ શોધો...';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return '$total માંથી પેજ $page';
  }

  @override
  String get errorGenericTitle => 'કંઈક ખોટું થયું';

  @override
  String get actionRetry => 'ફરી પ્રયાસ કરો';

  @override
  String get permissionAllFilesTitle => 'બધી ફાઇલોની ઍક્સેસ જરૂરી છે';

  @override
  String get permissionAllFilesExplanation =>
      'ફોલ્ડર્સ બ્રાઉઝ કરવા અને તમારા દસ્તાવેજોને સંપૂર્ણપણે ઓફલાઇન ગોઠવવા માટે Doc View ને બધી ફાઇલોની ઍક્સેસની જરૂર છે.';

  @override
  String get actionGrantAccess => 'ઍક્સેસ આપો';

  @override
  String get actionImportFilesInstead => 'તેના બદલે ફાઇલો આયાત કરો';

  @override
  String get tooltipRemoveBookmark => 'બુકમાર્ક દૂર કરો';

  @override
  String get tooltipAddBookmark => 'બુકમાર્ક ઉમેરો';

  @override
  String tooltipFileOptions(String title) {
    return '$title માટે ફાઇલ વિકલ્પો';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return 'ફોલ્ડર, $name$subtitle';
  }

  @override
  String get adAdvertisementBadge => 'જાહેરાત';

  @override
  String get actionConfirm => 'પુષ્ટિ કરો';

  @override
  String get actionCancel => 'રદ કરો';

  @override
  String get tabRecent => 'તાજેતરનું';

  @override
  String get tabBookmarks => 'બુકમાર્ક્સ';

  @override
  String get filterCategoryAll => 'બધું';

  @override
  String get actionBrowse => 'બ્રાઉઝ કરો';

  @override
  String get actionCancelOperation => 'પ્રક્રિયા રદ કરો';

  @override
  String get operationComplete => 'પ્રક્રિયા પૂર્ણ થઈ';

  @override
  String get actionOpenDocument => 'દસ્તાવેજ ખોલો';

  @override
  String get actionShareDocument => 'દસ્તાવેજ શેર કરો';

  @override
  String get splashTagline => 'તમારા બધા દસ્તાવેજો, એક જ જગ્યાએ.';

  @override
  String appVersion(String version) {
    return 'સંસ્કરણ $version';
  }

  @override
  String onboardingStep(int current, int total) {
    return '$total માંથી પગલું $current';
  }

  @override
  String get actionSkip => 'છોડો';

  @override
  String get actionBack => 'પાછળ';

  @override
  String get actionNext => 'આગળ';

  @override
  String get actionGetStarted => 'શરૂ કરો';

  @override
  String get onboardingPage1Title => 'તમારા બધા દસ્તાવેજો,\nએક જ જગ્યાએ';

  @override
  String get onboardingPage1Desc =>
      'Doc View તમારા ફોન પર PDF, Word, Excel, PowerPoint, ટેક્સ્ટ ફાઇલો અને ઇમેજ આપમેળે શોધે છે અને તમારા માટે ગોઠવે છે.';

  @override
  String get onboardingPage2Title => 'કંઈપણ વાંચો,\nસરળતાથી અને સુંદર રીતે';

  @override
  String get onboardingPage2Desc =>
      'ઝડપી અને સ્વચ્છ રીડર સાથે PDF, Word, Excel અને PowerPoint ફાઇલો ખોલો. શોધો, બુકમાર્ક કરો અને જ્યાંથી અટક્યા હતા ત્યાંથી ફરી શરૂ કરો.';

  @override
  String get onboardingPage3Title => 'શક્તિશાળી PDF ટૂલ્સ, ઓફલાઇન';

  @override
  String get onboardingPage3Desc =>
      'ફોટાને PDF માં ફેરવો, દસ્તાવેજો સ્કેન કરો, ફાઇલો મર્જ અને સ્પ્લિટ કરો. બધું જ તમારા ડિવાઇસ પર રહે છે.';

  @override
  String get onboardingOfflineGuarantee =>
      'તમારી ફાઇલો તમારા ડિવાઇસ પર જ રહે છે';

  @override
  String get toolImageToPdf => 'ઇમેજથી PDF';

  @override
  String get toolImageToPdfSub => 'JPG અને PNG કન્વર્ટ કરો';

  @override
  String get toolScanToPdf => 'સ્કેનથી PDF';

  @override
  String get toolScanToPdfSub => 'કેમેરા એજ ડિટેક્ટ';

  @override
  String get toolMergePdf => 'PDF મર્જ કરો';

  @override
  String get toolMergePdfSub => 'એકમાં જોડો';

  @override
  String get toolSplitPdf => 'PDF સ્પ્લિટ કરો';

  @override
  String get toolSplitPdfSub => 'કોઈપણ રેન્જ અલગ કરો';

  @override
  String get permissionTagStorage => 'ડિવાઇસ સ્ટોરેજ ઍક્સેસ';

  @override
  String get permissionStorageHeadline =>
      'Doc View ને તમારા દસ્તાવેજો શોધવા દો';

  @override
  String get permissionStorageBody =>
      'કોઈપણ એપ દ્વારા સેવ કરેલી PDF, Word, Excel અને અન્ય ફાઇલોની યાદી બનાવવા માટે, Android ને બધી ફાઇલોની ઍક્સેસ માટે તમારી પરવાનગીની જરૂર છે. તમારી ફાઇલો ક્યારેય તમારા ફોનની બહાર જતી નથી.';

  @override
  String get permissionReassuranceOfflineTitle => 'ફાઇલો ક્યારેય અપલોડ થતી નથી';

  @override
  String get permissionReassuranceOfflineDesc =>
      'તમારા દસ્તાવેજોની પ્રક્રિયા તમારા ડિવાઇસ પર જ સ્થાનિક રીતે થાય છે.';

  @override
  String get permissionReassuranceNoUploadsTitle => 'કોઈ અપલોડ નહીં';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      'શૂન્ય ક્લાઉડ સર્વર. તમારી ફાઇલો સંપૂર્ણપણે ફોનની મેમરીમાં જ રહે છે.';

  @override
  String get permissionReassuranceChangeTitle =>
      'તમે આને ગમે ત્યારે બદલી શકો છો';

  @override
  String get permissionReassuranceChangeDesc =>
      'તમારા Android સિસ્ટમ એપ સેટિંગ્સમાં સરળતાથી બદલો.';

  @override
  String get permissionTagIOS => 'iOS સ્ટોરેજ માર્ગદર્શિકા';

  @override
  String get permissionIOSHeadline => 'તમારા દસ્તાવેજો Doc View માં લાવો';

  @override
  String get permissionIOSBody =>
      'Apple ની પ્રાઇવસી સુરક્ષાને કારણે, iOS કોઈપણ એપને તમારો આખો ફોન આપમેળે સ્કેન કરવાની મંજૂરી આપતું નથી. તમે તમારી ફાઇલો કેવી રીતે વાંચવા માંગો છો તે પસંદ કરો:';

  @override
  String get permissionIOSOptionImportTitle => 'ફાઇલો આયાત કરો';

  @override
  String get permissionIOSBadgeFastest => 'સૌથી ઝડપી';

  @override
  String get permissionIOSOptionImportDesc =>
      'તમારા iCloud Drive, Downloads અથવા કોઈપણ ફોલ્ડરમાંથી સેકન્ડોમાં સીધા દસ્તાવેજો પસંદ કરો.';

  @override
  String get permissionIOSOptionFolderTitle =>
      'Files એપમાં Doc View ફોલ્ડર ખોલો';

  @override
  String get permissionIOSOptionFolderDesc =>
      'ત્વરિત સિંક માટે iOS Files એપમાંના \"Doc View\" ફોલ્ડરમાં દસ્તાવેજો સીધા સેવ કરો અથવા AirDrop કરો.';

  @override
  String get actionImportFiles => 'ફાઇલો આયાત કરો';

  @override
  String get actionContinueToApp => 'એપ પર આગળ વધો';

  @override
  String get permissionTagConsent => 'પારદર્શિતા અને સંમતિ';

  @override
  String get permissionBadgeFree => '100% મફત એપ';

  @override
  String get permissionBadgeMinimalAds => 'ઓછામાં ઓછી જાહેરાતો';

  @override
  String get permissionConsentHeadline => 'જાહેરાતો સાથે મફત';

  @override
  String get permissionConsentBody =>
      'જાહેરાતોને કારણે Doc View મફત છે. આગળ અમે તમને વ્યક્તિગત જાહેરાતો માટે તમારી પસંદગી પૂછીશું.';

  @override
  String get permissionConsentAdsTitle => 'તમને કેવી જાહેરાતો દેખાઈ શકે છે';

  @override
  String get permissionConsentAdsDesc =>
      'નાની બેનર જાહેરાતો અને બિન-અવરોધક સ્પોન્સર કાર્ડ્સ. વાંચતી વખતે કોઈ પોપઅપ કે વીડિયો વિક્ષેપ નહીં.';

  @override
  String get permissionConsentPrivateTitle =>
      'દસ્તાવેજો સંપૂર્ણપણે ખાનગી રહે છે';

  @override
  String get permissionConsentPrivateDesc =>
      'જાહેરાત ભાગીદારોને તમારા દસ્તાવેજના નામ, ટેક્સ્ટ સામગ્રી અથવા ફાઇલ સ્થાનની ક્યારેય ઍક્સેસ હોતી નથી.';

  @override
  String get permissionConsentSettingsTitle =>
      'તમે સેટિંગ્સમાં તમારી પસંદગી બદલી શકો છો';

  @override
  String get permissionConsentSettingsDesc =>
      'Doc View સેટિંગ્સમાં ગમે ત્યારે વ્યક્તિગત જાહેરાત સંમતિ અથવા પ્રાઇવસી પસંદગીઓ અપડેટ કરો.';

  @override
  String get actionContinue => 'ચાલુ રાખો';

  @override
  String get actionPrivacyPolicy => 'પ્રાઇવસી પોલિસી';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફાઇલો આયાત કરી',
      one: '1 ફાઇલ આયાત કરી',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => 'ફાઇલો આયાત કરવામાં નિષ્ફળ';

  @override
  String get tooltipImportDocuments => 'દસ્તાવેજો આયાત કરો';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફાઇલો મળી',
      one: '1 ફાઇલ મળી',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => 'સ્કેન થઈ રહ્યું છે...';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફાઇલો',
      one: '1 ફાઇલ',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => 'ફોલ્ડર્સ';

  @override
  String get errorLoadingRecent => 'તાજેતરની ફાઇલો લોડ કરવામાં ભૂલ';

  @override
  String get emptyStateTitle => 'ખાલી';

  @override
  String get emptyRecentDescription => 'તાજેતરમાં ખોલેલી ફાઇલો અહીં દેખાશે';

  @override
  String get errorLoadingBookmarks => 'બુકમાર્ક કરેલી ફાઇલો લોડ કરવામાં ભૂલ';

  @override
  String get emptyBookmarksDescription =>
      'બુકમાર્ક કરેલા દસ્તાવેજો અહીં દેખાશે';

  @override
  String get dialogDeleteTitle => 'પસંદ કરેલી ફાઇલો કાઢી નાખવી?';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફાઇલો કાઢી નાખવી? આ ક્રિયા પૂર્વવત કરી શકાતી નથી.',
      one: '1 ફાઇલ કાઢી નાખવી? આ ક્રિયા પૂર્વવત કરી શકાતી નથી.',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફાઇલો કાઢી નાખી',
      one: '1 ફાઇલ કાઢી નાખી',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => 'ફાઇલો કાઢી નાખવામાં નિષ્ફળ';

  @override
  String get actionDelete => 'કાઢી નાખો';

  @override
  String get searchRecentSearchesHeader => 'તાજેતરની શોધો';

  @override
  String get actionClear => 'સાફ કરો';

  @override
  String get searchPromptTitle => 'દસ્તાવેજો શોધવા માટે ટાઇપ કરો';

  @override
  String get searchPromptMessage =>
      'ફાઇલના નામ અથવા એક્સ્ટેંશન દ્વારા બધા સ્થાનિક ફોલ્ડર્સમાં શોધો';

  @override
  String get searchError => 'દસ્તાવેજો શોધવામાં ભૂલ';

  @override
  String get searchNoResultsTitle => 'કોઈ મેળ ખાતા દસ્તાવેજો મળ્યા નથી';

  @override
  String get searchNoResultsMessage =>
      'અલગ ફાઇલનામ કીવર્ડ અથવા ફોર્મેટ ફિલ્ટર સાથે શોધવાનો પ્રયાસ કરો';

  @override
  String get tooltipSortOptions => 'ક્રમબદ્ધ કરવાના વિકલ્પો';

  @override
  String get sortSheetTitle => 'આના દ્વારા ક્રમબદ્ધ કરો';

  @override
  String get sortOptionDate => 'ફેરફારની તારીખ';

  @override
  String get sortOptionName => 'દસ્તાવેજનું નામ';

  @override
  String get sortOptionSize => 'ફાઇલનું કદ';

  @override
  String get sortAscendingOrder => 'ચઢતો ક્રમ';

  @override
  String get sortAscendingSubtitle =>
      'સૌથી જૂનું પહેલાં / A થી Z / સૌથી નાનું પહેલાં';

  @override
  String get sortDescendingSubtitle =>
      'સૌથી નવું પહેલાં / Z થી A / સૌથી મોટું પહેલાં';

  @override
  String get categoryAllFiles => 'બધી ફાઇલો';

  @override
  String get loadingStatus => 'લોડ થઈ રહ્યું છે...';

  @override
  String get emptyCategoryImagesTitle => 'કોઈ ઇમેજ મળી નથી';

  @override
  String get emptyCategoryImagesMessage => 'આ ડિવાઇસ પર મળેલી ઇમેજ અહીં દેખાશે';

  @override
  String get emptyCategoryDocsTitle => 'કોઈ દસ્તાવેજો મળ્યા નથી';

  @override
  String get emptyCategoryDocsMessage =>
      'સ્કેન કર્યા પછી આ ફોર્મેટના દસ્તાવેજો અહીં દેખાશે';

  @override
  String get actionOpen => 'ખોલો';

  @override
  String get actionShare => 'શેર કરો';

  @override
  String get actionRename => 'નામ બદલો';

  @override
  String get actionBookmark => 'બુકમાર્ક કરો';

  @override
  String get actionRemoveBookmark => 'બુકમાર્ક દૂર કરો';

  @override
  String get actionOpenInAnotherApp => 'અન્ય એપમાં ખોલો';

  @override
  String get actionDetails => 'વિગતો';

  @override
  String get actionOpenFile => 'ફાઇલ ખોલો';

  @override
  String get actionShareAll => 'બધું શેર કરો';

  @override
  String get actionDone => 'પૂર્ણ';

  @override
  String get actionSeeAll => 'બધું જુઓ';

  @override
  String get actionAllow => 'મંજૂરી આપો';

  @override
  String get actionNotNow => 'અત્યારે નહીં';

  @override
  String get tooltipMoreActions => 'વધુ ક્રિયાઓ';

  @override
  String get tooltipCopyPath => 'પાથ કૉપિ કરો';

  @override
  String get tooltipRotatePage => 'પેજ ફેરવો';

  @override
  String get tooltipRemovePage => 'પેજ દૂર કરો';

  @override
  String get renameFileTitle => 'ફાઇલનું નામ બદલો';

  @override
  String get renameFileNameLabel => 'ફાઇલનું નામ';

  @override
  String renamedSuccess(String fileName) {
    return 'નામ બદલીને $fileName કર્યું';
  }

  @override
  String get deleteFileTitle => 'ફાઇલ કાઢી નાખવી?';

  @override
  String deleteFileConfirmation(String fileName) {
    return '\"$fileName\" કાઢી નાખવી? આ પૂર્વવત કરી શકાતું નથી.';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return '\"$fileName\" કાઢી નાખી';
  }

  @override
  String get fileDetailsTitle => 'દસ્તાવેજની વિગતો';

  @override
  String get fileDetailsLabelName => 'નામ';

  @override
  String get fileDetailsLabelType => 'પ્રકાર';

  @override
  String get fileDetailsLabelSize => 'કદ';

  @override
  String get fileDetailsLabelModified => 'ફેરફાર કરેલ';

  @override
  String get fileDetailsLabelBookmarked => 'બુકમાર્ક કરેલ';

  @override
  String get fileDetailsValueYes => 'હા';

  @override
  String get fileDetailsValueNo => 'ના';

  @override
  String get fileDetailsLabelLocation => 'સ્થાન';

  @override
  String get fileDetailsPathCopied => 'પાથ ક્લિપબોર્ડ પર કૉપિ થયો';

  @override
  String get directoriesTitle => 'ડિરેક્ટરીઓ';

  @override
  String get directoriesGoBack => 'પાછા જાઓ';

  @override
  String get directoriesGoToRoot => 'રૂટ પર જાઓ';

  @override
  String get directoriesRetry => 'ફરી પ્રયાસ કરો';

  @override
  String get directoriesFileNoLongerExists => 'ફાઇલ હવે અસ્તિત્વમાં નથી';

  @override
  String get directoriesFolderNoLongerExists => 'આ ફોલ્ડર હવે અસ્તિત્વમાં નથી.';

  @override
  String get directoriesNoDocsInFolder => 'આ ફોલ્ડરમાં કોઈ દસ્તાવેજો નથી';

  @override
  String get directoriesFilesAppearHere => 'ઉમેર્યા પછી ફાઇલો અહીં દેખાશે';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count આઇટમ્સ',
      one: '1 આઇટમ',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => 'ફોલ્ડર';

  @override
  String get directoriesPermissionPromptTitle =>
      'ડિરેક્ટરીઓ જોવા માટે ઍક્સેસ જરૂરી છે';

  @override
  String get directoriesPermissionPromptBody =>
      'તમારા ફોલ્ડર્સ બ્રાઉઝ કરવા માટે Doc View ને બધી ફાઇલોની ઍક્સેસની જરૂર છે.';

  @override
  String get directoriesGrantAccess => 'ઍક્સેસ આપો';

  @override
  String get directoriesImportInstead => 'તેના બદલે ફાઇલો આયાત કરો';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફાઇલો આયાત કરી',
      one: '1 ફાઇલ આયાત કરી',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => 'એક સ્તર ઉપર';

  @override
  String get storageAccessRequiredTitle => 'સ્ટોરેજ ઍક્સેસ જરૂરી છે';

  @override
  String get storageAccessRequiredBody =>
      'તમારા ડિવાઇસ પર સંગ્રહિત દસ્તાવેજો (PDF, Word, Excel, PPT, TXT, ઇમેજ) સ્કેન કરવા અને બતાવવા માટે Doc View ને સ્ટોરેજ ઍક્સેસની જરૂર છે.\n\nતમારી ફાઇલો તમારા ડિવાઇસ પર સંપૂર્ણપણે ખાનગી અને ઓફલાઇન રહે છે.';

  @override
  String errorCouldNotOpenDocument(String error) {
    return 'દસ્તાવેજ ખોલી શકાયો નહીં: $error';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'સ્કેન પૂર્ણ: $count ફાઇલો',
      one: 'સ્કેન પૂર્ણ: 1 ફાઇલ',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => 'શોધ ઇતિહાસ સાફ કરવો?';

  @override
  String get dialogClearSearchMessage =>
      'બધી તાજેતરની શોધો કાયમી ધોરણે સાફ થઈ જશે.';

  @override
  String imageListEditorMaxLimit(int max) {
    return 'મહત્તમ $max ઇમેજની મર્યાદા પૂરી થઈ ગઈ છે.';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return 'સ્કેન કરવામાં નિષ્ફળ: $error';
  }

  @override
  String get imageListEditorPageSize => 'પેજનું કદ:';

  @override
  String get imageListEditorA4Mode => 'A4';

  @override
  String get imageListEditorFitMode => 'ઇમેજ પ્રમાણે ફિટ કરો';

  @override
  String get imageListEditorRemoveImageTooltip => 'ઇમેજ દૂર કરો';

  @override
  String get mergeScreenTitle => 'ગોઠવો અને મર્જ કરો';

  @override
  String get mergeScreenDefaultMergedName => 'મર્જ_દસ્તાવેજ';

  @override
  String get mergePickerSearchHint => 'PDF શોધો...';

  @override
  String get mergePickerNext => 'આગળ';

  @override
  String mergePickerErrorLoading(String error) {
    return 'PDF લોડ કરવામાં ભૂલ: $error';
  }

  @override
  String get splitScreenTitle => 'PDF સ્પ્લિટ કરો';

  @override
  String get splitScreenRangeHint => 'દા.ત. 1-3, 5, 8-10';

  @override
  String get splitScreenClearRange => 'રેન્જ સાફ કરો';

  @override
  String get splitPickerSearchHint => 'PDF શોધો...';

  @override
  String splitPickerErrorLoading(String error) {
    return 'ફાઇલો લોડ કરવામાં ભૂલ: $error';
  }

  @override
  String get createdSectionTitle => 'તમારા દ્વારા બનાવેલ';

  @override
  String get createdSectionEmptyTitle => 'તમે બનાવેલી PDF અહીં દેખાશે';

  @override
  String get createdSectionEmptySubtitle =>
      'કન્વર્ટ કરેલા, સ્કેન કરેલા અથવા મર્જ કરેલા દસ્તાવેજો સ્થાનિક રીતે સેવ થશે.';

  @override
  String get emptyCreatedDocsTitle => 'હજુ સુધી કોઈ દસ્તાવેજ બનાવ્યો નથી';

  @override
  String get emptyCreatedDocsMessage =>
      'કન્વર્ટ કરેલા, સ્કેન કરેલા અથવા મર્જ કરેલા દસ્તાવેજો અહીં દેખાશે.';

  @override
  String errorLoadingCreatedFiles(String error) {
    return 'બનાવેલી ફાઇલો લોડ કરવામાં નિષ્ફળ: $error';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDF બની ગઈ',
      one: 'PDF બની ગઈ',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle => 'તમારા બનાવેલા ફોલ્ડરમાં સેવ થયું';

  @override
  String get toolErrorDefaultTitle => 'PDF બનાવી શકાઈ નહીં';

  @override
  String get toolErrorSubtitle => 'પ્રક્રિયા દરમિયાન અણધારી ભૂલ આવી';

  @override
  String get themeSheetTitle => 'એપ થીમ';

  @override
  String get themeSheetSubtitle => 'Doc View માટે દૃશ્ય દેખાવ પસંદ કરો';

  @override
  String get themeModeSystem => 'સિસ્ટમ';

  @override
  String get themeModeSystemSubtitle => 'ડિફોલ્ટ';

  @override
  String get themeModeLight => 'લાઇટ';

  @override
  String get themeModeLightSubtitle => 'સ્વચ્છ સફેદ';

  @override
  String get themeModeDark => 'ડાર્ક';

  @override
  String get themeModeDarkSubtitle => 'ઘેરો નેવી';

  @override
  String get themeActionApply => 'થીમ લાગુ કરો';

  @override
  String get scanSettingsTitle => 'સ્કેન સેટિંગ્સ';

  @override
  String get scanSettingsFrequencyHeader => 'સ્કેન આવૃત્તિ';

  @override
  String get scanSettingsOnOpenTitle => 'એપ ખોલવા પર સ્કેન કરો';

  @override
  String get scanSettingsOnOpenSubtitle =>
      'જ્યારે તમે Doc View ખોલો ત્યારે આપમેળે નવી ફાઇલો શોધો.';

  @override
  String get scanSettingsManualTitle => 'માત્ર મેન્યુઅલ';

  @override
  String get scanSettingsManualSubtitle =>
      'જ્યારે તમે રિફ્રેશ કરવા ખેંચો અથવા ફરી સ્કેન પર ટૅપ કરો ત્યારે જ સ્કેન કરો.';

  @override
  String get scanSettingsMediaFiltersHeader => 'મીડિયા ફિલ્ટર્સ';

  @override
  String get scanSettingsIncludeImagesTitle => 'સ્કેનમાં ઇમેજ શામેલ કરો';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      'સ્ટોરેજમાં PNG, JPG અને WEBP ઇમેજ ફાઇલોને ઇન્ડેક્સ કરો.';

  @override
  String get scanSettingsDiagnosticsHeader => 'સ્ટોરેજ અને ડાયગ્નોસ્ટિક્સ';

  @override
  String get scanSettingsPermissionStatus => 'બધી ફાઇલોની ઍક્સેસ';

  @override
  String get scanSettingsPermissionGranted => 'આપેલ છે';

  @override
  String get scanSettingsPermissionNotGranted => 'આપેલ નથી';

  @override
  String get scanSettingsTotalIndexed => 'ઇન્ડેક્સ થયેલી ફાઇલો';

  @override
  String get scanSettingsLastScan => 'છેલ્લે સ્કેન કરેલ';

  @override
  String get scanSettingsUpdatedSnackbar => 'સ્કેન સેટિંગ્સ અપડેટ થઈ';

  @override
  String get faqScreenTitle => 'વારંવાર પૂછાતા પ્રશ્નો';

  @override
  String faqHeaderTopics(int count) {
    return '$count વિષયો';
  }

  @override
  String get faqHeaderSubtitle => 'પ્રશ્નો છે? અહીં સ્પષ્ટ જવાબો મેળવો.';

  @override
  String get faqSendFeedback => 'પ્રતિભાવ મોકલો';

  @override
  String get faqQuestion1 => 'Doc View ને બધી ફાઇલોની ઍક્સેસની જરૂર કેમ છે?';

  @override
  String get faqAnswer1 =>
      'Downloads અને Documents જેવા શેર કરેલા ફોલ્ડર્સમાં સંગ્રહિત સમર્થિત દસ્તાવેજો (PDF, Word, Excel, PowerPoint, ટેક્સ્ટ અને ઇમેજ) શોધવા અને ઇન્ડેક્સ કરવા માટે Android 11+ પર Doc View ને બધી ફાઇલોની ઍક્સેસ (MANAGE_EXTERNAL_STORAGE) ની જરૂર છે.\n\nઆ પરવાનગી વિના, Android ફાઇલ ઍક્સેસને એપના ખાનગી આંતરિક ફોલ્ડર સુધી મર્યાદિત કરે છે, જેનાથી Doc View તમારા ડિવાઇસમાં રહેલી ફાઇલો બ્રાઉઝ કરી શકતું નથી કે ખોલી શકતું નથી.';

  @override
  String get faqQuestion2 => 'તે મારો આખો iPhone સ્કેન કેમ કરતું નથી?';

  @override
  String get faqAnswer2 =>
      'ડિવાઇસની પ્રાઇવસી સુરક્ષિત રાખવા માટે iOS કડક એપ સેન્ડબોક્સિંગનો ઉપયોગ કરે છે. એપ્સ ફક્ત Files એપમાં સ્પષ્ટપણે સેવ કરેલા અથવા સિસ્ટમ Share Sheet દ્વારા શેર કરેલા દસ્તાવેજોને જ ઍક્સેસ કરી શકે છે.\n\niOS પર ફાઇલો જોવા માટે, તેમને મૂળ Files એપમાંના Doc View ફોલ્ડરમાં આયાત કરો અથવા સેટિંગ્સમાં ફાઇલો આયાત કરો વિકલ્પનો ઉપયોગ કરો.';

  @override
  String get faqQuestion3 => 'હું બનાવું છું તે PDF ક્યાં સેવ થાય છે?';

  @override
  String get faqAnswer3 =>
      'તમે આયાત કરો છો અથવા બનાવો છો તે ફાઇલો (જેમ કે કન્વર્ટ કરેલી PDF, મર્જ કરેલા દસ્તાવેજો અથવા સ્પ્લિટ પેજ) તમારા ડિવાઇસ સ્ટોરેજમાં DocView/Created અથવા ખાનગી એપ સ્ટોરેજમાં સુરક્ષિત રીતે સેવ થાય છે. તમે તેમને ગમે ત્યારે ટૂલ્સ ટેબ પર \'તમારા દ્વારા બનાવેલ\' વિભાગમાં જોઈ શકો છો.';

  @override
  String get faqQuestion4 => 'મારી Word ફાઇલ અલગ કેમ દેખાય છે?';

  @override
  String get faqAnswer4 =>
      'Doc View ખાનગી ડેટાને ક્લાઉડ કન્વર્ટર્સ પર મોકલ્યા વિના સ્થાનિક ઓફલાઇન પાર્સર્સનો ઉપયોગ કરીને તમારા ડિવાઇસ પર સીધી ફાઇલો રેન્ડર કરે છે. જટિલ ફોર્મેટિંગ અથવા કસ્ટમ આકારો નેટિવ ઓફલાઇન અંદાજો સાથે રેન્ડર થાય છે.';

  @override
  String get faqQuestion5 => 'શું હું પાસવર્ડ-સુરક્ષિત ફાઇલો ખોલી શકું છું?';

  @override
  String get faqAnswer5 =>
      'હા, Doc View પાસવર્ડ-સુરક્ષિત PDF દસ્તાવેજો ખોલવાનું સમર્થન કરે છે. એન્ક્રિપ્ટેડ PDF ખોલતી વખતે, તમારા ડિવાઇસ પર દસ્તાવેજને ડિક્રિપ્ટ કરવા અને જોવા માટે ડાયલોગમાં પાસવર્ડ દાખલ કરો.';

  @override
  String get faqQuestion6 => 'શું મારો ડેટા ક્યાંય અપલોડ થાય છે?';

  @override
  String get faqAnswer6 =>
      'તમારા દસ્તાવેજો ક્યારેય તમારા ડિવાઇસની બહાર જતા નથી. Doc View ફાઇલોને સ્થાનિક રીતે ખોલે છે, કન્વર્ટ કરે છે અને સ્ટોર કરે છે. એપ Google AdMob દ્વારા આપવામાં આવતી જાહેરાતો બતાવે છે, જે અમારી પ્રાઇવસી પોલિસીમાં વર્ણવ્યા મુજબ મર્યાદિત ડિવાઇસ ડેટાનો ઉપયોગ કરી શકે છે.';

  @override
  String get faqQuestion7 => 'PDF થી Word કરવાથી મારું લેઆઉટ કેમ બદલાઈ ગયું?';

  @override
  String get faqAnswer7 =>
      'Doc View તમારા ડિવાઇસ પર ફક્ત ટેક્સ્ટને જ કન્વર્ટ કરે છે. ટેબલ, ઇમેજ, રંગો અને લેઆઉટ જળવાતા નથી. સ્કેન કરેલી PDF કન્વર્ટ કરી શકાતી નથી કારણ કે તેમાં વાંચવા માટે કોઈ ટેક્સ્ટ હોતી નથી.';

  @override
  String get toolPdfToWord => 'PDF થી Word';

  @override
  String get toolPdfToWordSub =>
      'PDF ને એડિટ કરી શકાય તેવા Word દસ્તાવેજમાં કન્વર્ટ કરો';

  @override
  String get pdfToWordScreenTitle => 'PDF થી Word';

  @override
  String get pdfToWordBannerText =>
      'ફક્ત ટેક્સ્ટ જ કન્વર્ટ થાય છે. ટેબલ, ઇમેજ, રંગો અને લેઆઉટ જળવાતા નથી.';

  @override
  String get pdfToWordPageBreaks => 'PDF પેજ વચ્ચે પેજ બ્રેક ઉમેરો';

  @override
  String get pdfToWordPageBreaksSubtitle =>
      'પેજમાં દસ્તાવેજનું માળખું જાળવી રાખે છે';

  @override
  String get pdfToWordSelectPdf => 'PDF પસંદ કરો';

  @override
  String get pdfToWordChangeFile => 'ફાઇલ બદલો';

  @override
  String get pdfToWordConvertAction => 'Word માં કન્વર્ટ કરો';

  @override
  String get pdfToWordConverting => 'Word માં કન્વર્ટ થઈ રહ્યું છે...';

  @override
  String pdfToWordConvertingProgress(int current, int total) {
    return '$total માંથી પેજ $current કન્વર્ટ થઈ રહ્યું છે...';
  }

  @override
  String get pdfToWordSuccess => 'Word માં સફળતાપૂર્વક કન્વર્ટ થયું';

  @override
  String get pdfToWordOpenInViewer => 'Doc View માં ખોલો';

  @override
  String get pdfToWordOpenWith => 'આની સાથે ખોલો...';

  @override
  String get pdfToWordShare => 'શેર કરો';

  @override
  String get pdfToWordNoTextTitle => 'કોઈ ટેક્સ્ટ મળી નથી';

  @override
  String get pdfToWordNoTextMessage =>
      'આ PDF માં કોઈ ટેક્સ્ટ મળી નથી. સ્કેન કરેલા દસ્તાવેજો કન્વર્ટ કરી શકાતા નથી.';

  @override
  String get pdfToWordLargeFileWarning =>
      'મોટો દસ્તાવેજ: કન્વર્ટ થવામાં ઘણી મિનિટો લાગી શકે છે.';

  @override
  String get pdfToWordInvalidFileName => 'અમાન્ય ફાઇલ નામ';

  @override
  String get pdfToWordActionCancel => 'રદ કરો';

  @override
  String get pdfToWordEncryptedError =>
      'પસંદ કરેલી PDF પાસવર્ડ-સુરક્ષિત છે. કન્વર્ટ કરવા માટે કૃપા કરીને તેને અનલોક કરો.';

  @override
  String get pdfToWordPageLimitError =>
      'દસ્તાવેજ 1,000 પેજની મર્યાદા કરતાં વધી ગયો છે.';

  @override
  String get pdfToWordTextLimitError =>
      'દસ્તાવેજ 20 MB ટેક્સ્ટની મર્યાદા કરતાં વધી ગયો છે.';

  @override
  String get pdfToWordGeneralError =>
      'PDF ને Word માં કન્વર્ટ કરવામાં નિષ્ફળ. કૃપા કરીને બીજી ફાઇલ અજમાવો.';

  @override
  String get pdfGotoPageTitle => 'પેજ પર જાઓ';

  @override
  String pdfGotoPageHint(int pageCount) {
    return '1 અને $pageCount વચ્ચેનું પેજ દાખલ કરો';
  }

  @override
  String get pdfGotoPageAction => 'જાઓ';

  @override
  String get pdfGotoPageErrorEmpty => 'પેજ નંબર દાખલ કરો';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return '1 અને $pageCount વચ્ચેનું પેજ દાખલ કરો';
  }

  @override
  String get pdfPasswordTitle => 'આ PDF પાસવર્ડ-સુરક્ષિત છે';

  @override
  String get pdfPasswordSubtitle =>
      'સામગ્રી જોવા અને ડિક્રિપ્ટ કરવા માટે પાસવર્ડ દાખલ કરો.';

  @override
  String get pdfPasswordHint => 'પાસવર્ડ દાખલ કરો';

  @override
  String get pdfPasswordErrorIncorrect => 'ખોટો પાસવર્ડ. ફરી પ્રયાસ કરો.';

  @override
  String get pdfPasswordActionUnlock => 'અનલોક કરો';

  @override
  String get errorFileNameEmpty => 'ફાઇલનું નામ ખાલી હોઈ શકે નહીં';

  @override
  String get errorFileNameTooLong =>
      'ફાઇલનું નામ 120 અક્ષરોથી વધુ હોઈ શકે નહીં';

  @override
  String get errorFileNameReserved =>
      'ફાઇલનું નામ \'.\' અથવા \'..\' હોઈ શકે નહીં';

  @override
  String get errorFileNameStartsWithDot =>
      'ફાઇલનું નામ ટપકાં (.) થી શરૂ થઈ શકે નહીં';

  @override
  String get errorFileNameInvalidChars => 'ફાઇલના નામમાં અમાન્ય અક્ષરો છે';

  @override
  String get errorRenameAlreadyExists =>
      'આ ફોલ્ડરમાં આ નામની ફાઇલ પહેલેથી જ અસ્તિત્વમાં છે';

  @override
  String get errorRenameSourceNotFound =>
      'સ્રોત ફાઇલ હવે ડિસ્ક પર અસ્તિત્વમાં નથી';

  @override
  String errorRenameFailed(String details) {
    return 'ફાઇલનું નામ બદલવામાં નિષ્ફળ: $details';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      'ફાઇલો ડિસ્કમાંથી કાઢી નાખી પરંતુ ડેટાબેઝ અપડેટ નિષ્ફળ ગયું';

  @override
  String errorDeleteFailed(String details) {
    return 'ફાઇલો કાઢી નાખવામાં નિષ્ફળ: $details';
  }

  @override
  String get errorPageRangeDocNoPages => 'દસ્તાવેજમાં કોઈ પેજ નથી';

  @override
  String get errorPageRangeEmpty => 'પેજ રેન્જ ખાલી હોઈ શકે નહીં';

  @override
  String get errorPageRangeEmptySegment =>
      'ખાલી રેન્જ ભાગ મળ્યો. વધારાના અલ્પવિરામ દૂર કરો.';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return 'અમાન્ય રેન્જ ફોર્મેટ: \'$token\'';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return 'અપૂર્ણ રેન્જ: \'$token\'';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return 'રેન્જમાં બિન-સંખ્યાત્મક મૂલ્યો: \'$token\'';
  }

  @override
  String get errorPageRangeBelowMinimum => 'પેજ નંબર 1 કે તેથી વધુ હોવો જોઈએ';

  @override
  String errorPageRangeReversed(int start, int end) {
    return 'ઊલટી રેન્જ \'$start-$end\': શરૂઆત અંત કરતાં મોટી છે';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return 'રેન્જ \'$token\' કુલ પેજ ($totalPages) કરતાં વધી જાય છે';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return 'અમાન્ય પેજ નંબર: \'$token\'';
  }

  @override
  String get errorImageToPdfNoImages =>
      'કૃપા કરીને ઓછામાં ઓછી એક ઇમેજ પસંદ કરો';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return 'એક સમયે મહત્તમ $max ઇમેજની મંજૂરી છે';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return 'ઇમેજ પ્રોસેસ કરવામાં નિષ્ફળ: $path';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return 'ઇમેજમાંથી PDF બનાવવામાં નિષ્ફળ: $details';
  }

  @override
  String get errorPdfMergeInsufficient =>
      'કૃપા કરીને મર્જ કરવા માટે ઓછામાં ઓછી 2 PDF ફાઇલો પસંદ કરો';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return '$fileName પાસવર્ડ-સુરક્ષિત અથવા ક્ષતિગ્રસ્ત છે';
  }

  @override
  String get errorPdfMergeNoPages => 'પસંદ કરેલા દસ્તાવેજોમાં કોઈ પેજ નથી';

  @override
  String errorPdfMergeFailed(String details) {
    return 'PDF મર્જ કરવામાં નિષ્ફળ: $details';
  }

  @override
  String get errorPdfSplitNoRanges =>
      'કૃપા કરીને ઓછામાં ઓછી એક પેજ રેન્જ નિર્દિષ્ટ કરો';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return '$fileName પાસવર્ડ-સુરક્ષિત અથવા ક્ષતિગ્રસ્ત છે';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return '$fileName માટે રેન્જ $start-$end મર્યાદાની બહાર છે';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return 'PDF સ્પ્લિટ કરવામાં નિષ્ફળ: $details';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return 'પેજ $current/$total';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '($bytes બાઇટ્સ)';
  }

  @override
  String get directoriesProtectedTitle =>
      'આ ફોલ્ડર Android દ્વારા સુરક્ષિત છે.';

  @override
  String get directoriesProtectedDesc =>
      'Android સિસ્ટમ અને એપના ખાનગી ફોલ્ડર્સની ઍક્સેસ પ્રતિબંધિત કરે છે.';

  @override
  String get directoriesNotFoundTitle => 'આ ફોલ્ડર હવે અસ્તિત્વમાં નથી.';

  @override
  String get directoriesEmpty => 'અહીં કોઈ સમર્થિત ફાઇલો અથવા ફોલ્ડર્સ નથી.';

  @override
  String get directoriesErrorOpening => 'ફોલ્ડર ખોલવામાં ભૂલ';

  @override
  String get directoriesRoot => 'રૂટ';

  @override
  String get scanSettingsSectionFrequency => 'સ્કેન આવૃત્તિ';

  @override
  String get scanSettingsSectionFilters => 'દસ્તાવેજ ફિલ્ટર્સ';

  @override
  String get scanSettingsIncludeImages => 'ઇમેજ શામેલ કરો';

  @override
  String get scanSettingsIncludeImagesDesc =>
      'તમારી દસ્તાવેજ સૂચિમાંથી હજારો ફોટા છુપાવવા માટે બંધ કરો';

  @override
  String get scanSettingsImageListUpdated => 'ઇમેજ સૂચિ અપડેટ થઈ';

  @override
  String get scanSettingsActionRescanNow => 'હમણાં ફરી સ્કેન કરો';

  @override
  String get scanSettingsSectionDiagnostics => 'સ્ટોરેજ ડાયગ્નોસ્ટિક્સ';

  @override
  String get scanSettingsAllFilesAccessGranted => 'બધી ફાઇલોની ઍક્સેસ આપેલ છે';

  @override
  String get scanSettingsAllFilesAccessNeeded => 'બધી ફાઇલોની ઍક્સેસ જરૂરી છે';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      'Doc View ને Downloads અને SD કાર્ડમાં ફાઇલો શોધવાની પરવાનગી છે.';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      'ડાઉનલોડ્સ અને બાહ્ય સ્ટોરેજ ફોલ્ડર્સ સ્કેન કરવા માટે પરવાનગી જરૂરી છે.';

  @override
  String get scanSettingsActionOpenSettings => 'સેટિંગ્સ ખોલો';

  @override
  String scanSettingsScanningFiles(int count) {
    return 'સ્કેન થઈ રહ્યું છે... $count ફાઇલો મળી';
  }

  @override
  String get faqStillNeedHelp => 'હજુ પણ મદદ જોઈએ છે? પ્રતિભાવ મોકલો';

  @override
  String get toolsLabelFileName => 'ફાઇલનું નામ';

  @override
  String get toolsAddImagesToStart => 'શરૂ કરવા માટે ઇમેજ ઉમેરો';

  @override
  String get toolsAddImagesDesc =>
      'PDF બનાવવા માટે ફોટા પસંદ કરો અથવા કાગળના દસ્તાવેજો સ્કેન કરો.';

  @override
  String get toolsChoosePhotos => 'ફોટા પસંદ કરો';

  @override
  String get toolsScanPaper => 'કાગળ સ્કેન કરો';

  @override
  String toolsPageNumber(int page) {
    return 'પેજ $page';
  }

  @override
  String get toolsTooltipRotatePage => 'પેજ ફેરવો';

  @override
  String get toolsTooltipRemovePage => 'પેજ દૂર કરો';

  @override
  String get toolsAddMoreScans => 'વધુ સ્કેન ઉમેરો';

  @override
  String get toolsAddMoreImages => 'વધુ ઇમેજ ઉમેરો';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ઇમેજ · અંદાજિત ~ $size',
      one: '1 ઇમેજ · અંદાજિત ~ $size',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return '$count પસંદ કરેલ';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return 'ઓછામાં ઓછી $min ફાઇલો પસંદ કરો';
  }

  @override
  String toolsPagesTotal(int count) {
    return 'કુલ $count પેજ';
  }

  @override
  String get toolsPagesTotalLabel => 'કુલ પેજ';

  @override
  String get toolsNoPdfsFound => 'કોઈ PDF દસ્તાવેજો મળ્યા નથી';

  @override
  String get semanticBookmarked => 'બુકમાર્ક કરેલ';

  @override
  String get semanticSelected => 'પસંદ કરેલ';

  @override
  String get semanticNotSelected => 'પસંદ કરેલ નથી';

  @override
  String get actionDeselectFile => 'ફાઇલ પસંદગી દૂર કરો';

  @override
  String get actionSelectFile => 'ફાઇલ પસંદ કરો';

  @override
  String get actionCreatePdf => 'PDF બનાવો';

  @override
  String get hintSelectOrViewActions => 'પસંદ કરો અથવા ક્રિયાઓ જુઓ';

  @override
  String get actionClose => 'બંધ કરો';

  @override
  String get actionReset => 'રીસેટ કરો';

  @override
  String get labelPleaseWait => 'કૃપા કરીને રાહ જુઓ...';

  @override
  String get tooltipCloseSearch => 'શોધ બંધ કરો';

  @override
  String get semanticAdvertisement => 'જાહેરાત';

  @override
  String get themePreviewLight => 'લાઇટ';

  @override
  String get themePreviewNavy => 'નેવી';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '$name, $size, $date ના રોજ બનાવેલ';
  }

  @override
  String get toolsCreatingPdfFromScans => 'સ્કેનમાંથી PDF બનાવી રહ્યું છે';

  @override
  String get toolsCreatingPdf => 'PDF બનાવી રહ્યું છે';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return '$total માંથી ઇમેજ $done પ્રોસેસ થઈ રહી છે...';
  }

  @override
  String get toolsErrorCreatePdfTitle => 'PDF બનાવી શકાઈ નહીં';

  @override
  String get toolsBadgeProtectedOrDamaged => 'સુરક્ષિત અથવા ક્ષતિગ્રસ્ત';

  @override
  String toolsPageCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પેજ',
      one: '1 પેજ',
    );
    return '$_temp0';
  }

  @override
  String get toolsPagesAbbrev => 'પેજ';

  @override
  String get mergeAddMoreTitle => 'વધુ PDF ઉમેરો';

  @override
  String get mergeProgressTitle => 'PDF મર્જ થઈ રહી છે';

  @override
  String mergeProgressMessage(int done, int total) {
    return '$total માંથી દસ્તાવેજ $done મર્જ થઈ રહ્યો છે...';
  }

  @override
  String get mergeErrorTitle => 'PDF મર્જ કરી શકાઈ નહીં';

  @override
  String get mergeDragInstruction => 'ક્રમ બદલવા માટે હેન્ડલ્સ ખેંચો';

  @override
  String get mergeAddPdf => 'PDF ઉમેરો';

  @override
  String get mergeOutputFileNameLabel => 'આઉટપુટ ફાઇલનું નામ';

  @override
  String mergeItemPageCountAndSize(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પેજ · $size',
      one: '1 પેજ · $size',
    );
    return '$_temp0';
  }

  @override
  String mergeItemLoadingPagesAndSize(String size) {
    return 'પેજ લોડ થઈ રહ્યા છે... · $size';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count અમાન્ય ફાઇલો મળી',
      one: '1 અમાન્ય ફાઇલ મળી',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => 'મર્જ કરવા માટે તૈયાર';

  @override
  String get mergeRemoveProtectedHint =>
      'કૃપા કરીને પાસવર્ડ-સુરક્ષિત દસ્તાવેજો દૂર કરો';

  @override
  String mergeSummary(int files, int pages, String size) {
    return '$files ફાઇલો · $pages પેજ · ~ $size';
  }

  @override
  String get mergeReadyBadge => 'તૈયાર';

  @override
  String get mergeBlockedCta => 'મર્જ અવરોધિત છે (ભૂલો ઉકેલો)';

  @override
  String mergeActionCta(int files, int pages) {
    return '$files PDF મર્જ કરો ($pages પેજ)';
  }

  @override
  String get mergePickerDefaultTitle => 'PDF પસંદ કરો';

  @override
  String mergePickerTabAllPdfs(int count) {
    return 'બધી PDF ($count)';
  }

  @override
  String get mergePickerTabRecent => 'તાજેતરનું';

  @override
  String get mergePickerTabDownloads => 'ડાઉનલોડ્સ';

  @override
  String get mergePickerTabICloud => 'iCloud Drive';

  @override
  String get splitProgressTitle => 'PDF સ્પ્લિટ થઈ રહી છે';

  @override
  String splitProgressMessage(int done, int total) {
    return '$total માંથી ફાઇલ $done બની રહી છે...';
  }

  @override
  String get splitErrorTitle => 'PDF સ્પ્લિટ કરી શકાઈ નહીં';

  @override
  String get splitPageRangesLabel => 'પેજ રેન્જ';

  @override
  String get splitPageRangesSyntax => 'ફોર્મેટ: 1-3, 5, 8-10';

  @override
  String get splitRangeHelpText => 'દરેક રેન્જ એક અલગ PDF ફાઇલ બને છે.';

  @override
  String splitGeneratedFilesHeader(int count) {
    return 'બનાવેલી ફાઇલો ($count)';
  }

  @override
  String get splitChipsSuspendedTitle => 'લાઇવ ચિપ્સ સ્થગિત';

  @override
  String get splitChipsSuspendedDesc =>
      'એક્સ્ટ્રેક્શન પાઇપલાઇન ફરી બનાવવા માટે ઉપરની સિન્ટેક્સ ભૂલ ઉકેલો.';

  @override
  String get splitEmptyRangesHint =>
      'PDF ભાગો બનાવવા માટે ઉપર પેજ રેન્જ દાખલ કરો';

  @override
  String splitChipSinglePage(int page) {
    return 'પેજ $page';
  }

  @override
  String splitChipPageRange(int start, int end) {
    return 'પેજ $start–$end';
  }

  @override
  String splitChipPageCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પેજ',
      one: '1 પેજ',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => 'ઝડપી પસંદગી';

  @override
  String get splitMacroAllPages => 'બધા પેજ';

  @override
  String get splitMacroEvery5Pages => 'દર 5 પેજ';

  @override
  String get splitMacroLimitHint =>
      'ડિવાઇસ મેમરીને સુરક્ષિત રાખવા માટે 100 થી વધુ ફાઇલો બનાવતા મેક્રો અક્ષમ છે';

  @override
  String splitOutputSummary(int files, int pages) {
    return 'આઉટપુટ: $files ફાઇલો · $pages પેજ કાઢ્યા';
  }

  @override
  String splitEstSize(String size) {
    return 'અંદાજિત ~ $size';
  }

  @override
  String splitActionCtaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDF માં સ્પ્લિટ કરો',
      one: '1 PDF માં સ્પ્લિટ કરો',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => 'PDF માં સ્પ્લિટ કરો';

  @override
  String splitPickerAllLocalDocs(int count) {
    return 'બધા સ્થાનિક દસ્તાવેજો ($count)';
  }

  @override
  String get splitPickerSortByDate => 'તારીખ મુજબ ક્રમ';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return 'પેજ · $size';
  }

  @override
  String get splitPickerTitle => 'સ્પ્લિટ કરવા માટે PDF પસંદ કરો';

  @override
  String get faqShortTitle => 'FAQ';

  @override
  String splitPickerSelectedCount(int count) {
    return '$count PDF પસંદ કરેલ';
  }

  @override
  String get splitPickerSelectDocumentHint => 'આગળ વધવા માટે દસ્તાવેજ પસંદ કરો';

  @override
  String splitPickerPagesActive(int count) {
    return '$count પેજ સક્રિય';
  }

  @override
  String get splitPickerPagesActiveLabel => 'પેજ સક્રિય';

  @override
  String get settingsTitle => 'સેટિંગ્સ';

  @override
  String get settingsSectionGeneral => 'સામાન્ય';

  @override
  String get settingsSectionOthers => 'અન્ય';

  @override
  String get settingsFileManagerTitle => 'ફાઇલ મેનેજર';

  @override
  String get settingsFileManagerSubtitle =>
      'સ્ટોરેજ ડિરેક્ટરીઓ અને ફોલ્ડર્સ બ્રાઉઝ કરો';

  @override
  String get settingsFaqTitle => 'FAQ';

  @override
  String get settingsFaqSubtitle => 'વારંવાર પૂછાતા પ્રશ્નો';

  @override
  String get settingsShareTitle => 'શેર કરો';

  @override
  String get settingsShareSubtitle => 'મિત્રોને Doc View ની ભલામણ કરો';

  @override
  String settingsShareMessage(String url) {
    return 'Doc View અજમાવો - ઝડપી, ખાનગી, ઓફલાઇન દસ્તાવેજ રીડર: $url';
  }

  @override
  String get settingsScanSettingsTitle => 'સ્કેન સેટિંગ્સ';

  @override
  String get settingsScanModeOnOpen => 'ખોલવા પર સ્કેન';

  @override
  String get settingsScanModeManual => 'માત્ર મેન્યુઅલ';

  @override
  String get settingsAppThemeTitle => 'એપ થીમ';

  @override
  String get settingsThemeSystem => 'સિસ્ટમ ડિફોલ્ટ';

  @override
  String get settingsThemeLight => 'લાઇટ';

  @override
  String get settingsThemeDark => 'ડાર્ક';

  @override
  String get settingsLanguageTitle => 'ભાષા';

  @override
  String get settingsRateUsTitle => 'અમને રેટ કરો';

  @override
  String get settingsRateUsSubtitle => 'તમારો પ્રતિભાવ અમારી સાથે શેર કરો';

  @override
  String get settingsAddWidgetTitle => 'વિજેટ ઉમેરો';

  @override
  String get settingsAddWidgetSubtitle => 'તમારી હોમ સ્ક્રીન પરથી ઝડપી ઍક્સેસ';

  @override
  String get settingsTermsTitle => 'ઉપયોગની શરતો';

  @override
  String get settingsTermsSubtitle => 'અમારી સેવાની શરતો વાંચો';

  @override
  String get settingsPrivacyTitle => 'પ્રાઇવસી પોલિસી';

  @override
  String get settingsPrivacySubtitle => 'અમારી પ્રાઇવસી પોલિસી વાંચો';

  @override
  String get settingsManageSubscriptionsTitle => 'સબ્સ્ક્રિપ્શન્સ મેનેજ કરો';

  @override
  String get settingsManageSubscriptionsSubtitle =>
      'તમારું સ્ટોર સબ્સ્ક્રિપ્શન મેનેજ કરો';

  @override
  String settingsVersionDisplay(String version, String build) {
    return 'સંસ્કરણ $version ($build)';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return 'સંસ્કરણ $version બિલ્ડ $build';
  }

  @override
  String get settingsOpenSourceLicenses => 'ઓપન-સોર્સ લાયસન્સ';

  @override
  String get rateSheetTitle => 'Doc View ને રેટ કરો';

  @override
  String get rateSheetSubtitle => 'તમારો પ્રતિભાવ અમને સુધારવામાં મદદ કરે છે';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count સ્ટાર',
      one: '1 સ્ટાર',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => 'તમને તે ગમ્યું જાણીને આનંદ થયો!';

  @override
  String get rateResponseMedium =>
      'આભાર! અમે વધુ સારું કેવી રીતે કરી શકીએ તે અમને જણાવો.';

  @override
  String get rateResponseLow =>
      'માફ કરશો, તે અપેક્ષા મુજબ ન રહ્યું. શું સુધારવું તે અમને જણાવો.';

  @override
  String get rateActionStore => 'Google Play પર રેટ કરો';

  @override
  String get rateActionHelpFeedback => 'મદદ અને પ્રતિભાવ';

  @override
  String get faqFromRatingBanner =>
      'તે સાંભળીને દુઃખ થયું. નીચેના જવાબો જુઓ અથવા અમારો સંપર્ક કરો; અમે દરેક સંદેશ વાંચીએ છીએ.';

  @override
  String get faqActionContactUs => 'અમારો સંપર્ક કરો';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return 'Doc View પ્રતિભાવ ($version+$build)';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '\n\n---\nએપ: Doc View $version (બિલ્ડ $build)\n';
  }

  @override
  String get faqEmailClientUnavailable => 'ઈમેલ ક્લાયન્ટ ખોલી શકાયું નહીં';

  @override
  String get languageScreenTitle => 'ભાષા';

  @override
  String get languageSearchHint => 'ભાષાઓ શોધો...';

  @override
  String get languageSystemDefault => 'સિસ્ટમ ડિફોલ્ટ';

  @override
  String get languageSystemDefaultSubtitle => 'ડિવાઇસની ભાષા અનુસરો';

  @override
  String get languageNotTranslatedBadge => '(અનુવાદિત નથી)';

  @override
  String get languageNotTranslatedSnack => 'આ ભાષા હજુ સુધી અનુવાદિત નથી';

  @override
  String get languageNoResults => 'કોઈ મેળ ખાતી ભાષાઓ નથી';

  @override
  String get languagePseudoLocaleName => 'સ્યુડો-લોકેલ (en_XA)';

  @override
  String get languagePseudoLocaleSubtitle => 'ડીબગ એક્સપાન્શન ટેસ્ટિંગ';

  @override
  String get scanSettingsSectionHistory => 'ઇતિહાસ';

  @override
  String get scanSettingsClearHistoryTitle => 'તાજેતરનો ઇતિહાસ સાફ કરો';

  @override
  String get scanSettingsClearHistorySubtitle =>
      'ખોલેલા દસ્તાવેજોનો ઇતિહાસ સાફ કરો';

  @override
  String get scanSettingsClearHistoryDialogTitle => 'તાજેતરનો ઇતિહાસ સાફ કરવો?';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      'ફાઇલો \'તાજેતરનું\' માંથી દૂર કરવામાં આવશે. તમારી ફાઇલો અને બુકમાર્ક્સને અસર થશે નહીં.';

  @override
  String get scanSettingsRecentHistoryCleared => 'તાજેતરનો ઇતિહાસ સાફ થયો';

  @override
  String get scanSettingsLastScanToday => 'આજે';

  @override
  String get scanSettingsLastScanYesterday => 'ગઈકાલે';

  @override
  String get scanSettingsNeverScanned => 'ક્યારેય સ્કેન કર્યું નથી';

  @override
  String get scanSettingsLastScanPrefix => 'છેલ્લું સ્કેન:';

  @override
  String get readerActionVertical => 'ઊભું';

  @override
  String get readerActionHorizontal => 'આડું';

  @override
  String get readerActionRotate => 'ફેરવો';

  @override
  String get readerActionSearch => 'શોધો';

  @override
  String get readerActionInvert => 'ઊલટાવો';

  @override
  String get readerActionShare => 'શેર કરો';

  @override
  String get readerActionPages => 'પેજ';

  @override
  String get readerSearchHint => 'દસ્તાવેજમાં શોધો...';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '$total માંથી $current';
  }

  @override
  String get readerSearchMatchCap => '500+';

  @override
  String get readerSearchNoMatches => '0 માંથી 0';

  @override
  String get readerSearchNoTextLayer => 'આ PDF માં શોધી શકાય તેવું ટેક્સ્ટ નથી';

  @override
  String get readerSearchPrevMatch => 'પહેલાંનું પરિણામ';

  @override
  String get readerSearchNextMatch => 'આગળનું પરિણામ';

  @override
  String readerTopPagesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પેજ • $size',
      one: '1 પેજ • $size',
    );
    return '$_temp0';
  }

  @override
  String get readerMenuGoToPage => 'પેજ પર જાઓ';

  @override
  String get readerMenuAddBookmark => 'બુકમાર્ક ઉમેરો';

  @override
  String get readerMenuRemoveBookmark => 'બુકમાર્ક દૂર કરો';

  @override
  String get readerMenuDetails => 'વિગતો';

  @override
  String get readerMenuOpenInAnotherApp => 'અન્ય એપમાં ખોલો';

  @override
  String get readerTooltipConvertToWord => 'Word માં કન્વર્ટ કરો';

  @override
  String get pagesScreenTitle => 'પેજ';

  @override
  String pagesScreenPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પેજ',
      one: '1 પેજ',
    );
    return '$_temp0';
  }

  @override
  String get pagesActionSelectAll => 'બધું પસંદ કરો';

  @override
  String get pagesActionClearSelection => 'સાફ કરો';

  @override
  String get pagesActionSave => 'સેવ કરો';

  @override
  String get pagesActionInsert => 'ઉમેરો';

  @override
  String get pagesActionRotate => 'ફેરવો';

  @override
  String get pagesActionExtract => 'કાઢો';

  @override
  String get pagesActionDelete => 'કાઢી નાખો';

  @override
  String get pagesActionUndo => 'પૂર્વવત કરો';

  @override
  String get pagesInsertSheetTitle => 'પેજ ઉમેરો';

  @override
  String get pagesInsertPagesFromPdf => 'અન્ય PDF માંથી પેજ';

  @override
  String get pagesDeleteAllBlocked =>
      'બધા પેજ કાઢી શકાતા નથી. દસ્તાવેજમાં ઓછામાં ઓછું એક પેજ હોવું જરૂરી છે.';

  @override
  String get pagesSaveDialogTitle => 'ફેરફારો સેવ કરો';

  @override
  String get pagesSaveAsNew => 'નવી ફાઇલ તરીકે સેવ કરો';

  @override
  String get pagesSaveReplace => 'મૂળ ફાઇલ બદલો';

  @override
  String get pagesSaveReplaceWarning => 'આ મૂળ ફાઇલ પર ફરીથી લખી દેશે.';

  @override
  String get pagesSaveFileNameLabel => 'ફાઇલનું નામ';

  @override
  String get pagesDiscardDialogTitle => 'ફેરફારો રદ કરવા?';

  @override
  String get pagesDiscardDialogBody =>
      'તમારી પાસે સેવ ન કરેલા ફેરફારો છે. શું તમે ખરેખર તેમને રદ કરવા માંગો છો?';

  @override
  String get pagesDiscardButton => 'રદ કરો';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પેજ કાઢ્યા',
      one: '1 પેજ કાઢ્યું',
    );
    return '$_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      'આ PDF એડિટ કરી શકાતી નથી કારણ કે તે એન્ક્રિપ્ટેડ છે અથવા વાંચી શકાતી નથી.';

  @override
  String get viewerErrorCorruptTitle => 'આ દસ્તાવેજ ખોલી શકાતો નથી';

  @override
  String get viewerErrorCorruptMessage =>
      'આ ફાઇલ ક્ષતિગ્રસ્ત લાગે છે અથવા માન્ય દસ્તાવેજ નથી.';

  @override
  String get viewerErrorMissingTitle => 'આ ફાઇલ હવે અસ્તિત્વમાં નથી';

  @override
  String get viewerErrorMissingMessage =>
      'ફાઇલ ડિવાઇસ સ્ટોરેજમાંથી કાઢી નાખવામાં આવી છે અથવા ખસેડવામાં આવી છે.';

  @override
  String get viewerErrorBackToFiles => 'ફાઇલો પર પાછા જાઓ';

  @override
  String get viewerErrorNoAppFound => 'આ ફાઇલ ખોલવા માટે કોઈ એપ મળી નથી';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પરિણામો',
      one: '1 પરિણામ',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count એકમો • $ext',
      one: '1 એકમ • $ext',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner => 'જૂનું ફોર્મેટ: ફક્ત ટેક્સ્ટ';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      'મોટી વર્કબુક: પ્રથમ 20,000 પંક્તિઓ અને 100 કૉલમ બતાવે છે';

  @override
  String viewerSectionTitle(int number) {
    return 'વિભાગ $number';
  }

  @override
  String get viewerMenuOutline => 'રૂપરેખા';

  @override
  String get viewerOutlineTitle => 'દસ્તાવેજની રૂપરેખા';

  @override
  String get viewerCloseOutline => 'રૂપરેખા બંધ કરો';

  @override
  String get viewerNoSections => 'આ દસ્તાવેજમાં કોઈ વિભાગો મળ્યા નથી';

  @override
  String get viewerOutlineTooltip => 'વિષયસૂચિ';

  @override
  String get viewerActionOpenExternal => 'અન્ય એપમાં ખોલો';

  @override
  String get viewerErrorCantOpenTitle => 'આ દસ્તાવેજ ખોલી શકાતો નથી';

  @override
  String get viewerErrorCantOpenMessage =>
      'દસ્તાવેજ ઓફલાઇન રેન્ડર થઈ શક્યો નહીં.';

  @override
  String get viewerOpeningDocument => 'દસ્તાવેજ ખોલી રહ્યું છે...';

  @override
  String get viewerErrorEncryptedTitle => 'આ દસ્તાવેજ એન્ક્રિપ્ટેડ છે';

  @override
  String get viewerErrorEncryptedMessage =>
      'પાસવર્ડ-સુરક્ષિત ફાઇલો ઓફલાઇન રીડરમાં જોઈ શકાતી નથી.';

  @override
  String get viewerErrorTooLargeTitle =>
      'આ ફાઇલ જોવાની મર્યાદા કરતાં વધી ગઈ છે';

  @override
  String get viewerErrorTooLargeMessage =>
      'મોટા દસ્તાવેજો બાહ્ય Office વ્યૂઅરનો ઉપયોગ કરીને ખોલવા જોઈએ.';

  @override
  String get viewerErrorUnsupportedFormatTitle => 'આ ફોર્મેટ સમર્થિત નથી';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      'Doc View આ ફાઇલ ફોર્મેટને સીધું પાર્સ કરી શકતું નથી.';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count આઇટમ્સ',
      one: '1 આઇટમ',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => 'ટાઇપોગ્રાફી';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get txtViewerMonospaceLabel => 'મોનોસ્પેસ ફોન્ટ';

  @override
  String get txtViewerTruncationBanner =>
      'ફાઇલ 1 MB કરતાં મોટી છે: પ્રથમ 1 MB બતાવે છે';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count લીટીઓ • $size',
      one: '1 લીટી • $size',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => 'ટાઇપોગ્રાફી સેટિંગ્સ';

  @override
  String get txtViewerTooltipDecreaseFont => 'ફોન્ટનું કદ ઘટાડો';

  @override
  String get txtViewerTooltipIncreaseFont => 'ફોન્ટનું કદ વધારો';

  @override
  String get txtViewerTooltipToggleMonospace => 'મોનોસ્પેસ ફોન્ટ બદલો';

  @override
  String get txtViewerMonospaceSubtitle =>
      'કોડ અને લોગ્સ માટે નિશ્ચિત-પહોળાઈના અક્ષરો';

  @override
  String get txtViewerPreviewLabel => 'પૂર્વાવલોકન';

  @override
  String get txtViewerPreviewText => 'ઝડપી ભૂરો શિયાળ આળસુ કૂતરા પર કૂદે છે.';

  @override
  String get txtViewerErrorTitle => 'આ ટેક્સ્ટ ફાઇલ વાંચી શકાતી નથી';

  @override
  String get txtViewerErrorMessage =>
      'ફાઇલ ફોર્મેટ અથવા એન્કોડિંગ પાર્સ થઈ શક્યું નહીં.';

  @override
  String get txtViewerActionRetry => 'ફરી પ્રયાસ કરો';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '$width × $height • $size';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get imageViewerTooltipFitToScreen => 'સ્ક્રીન પર ફિટ કરો';

  @override
  String get imageViewerErrorCorrupt => 'ઇમેજ લોડ કરવામાં અસમર્થ';

  @override
  String get imageViewerLoading => 'ઇમેજ લોડ થઈ રહી છે…';

  @override
  String get viewerDispatcherFileMissing => 'ફાઇલ હવે અસ્તિત્વમાં નથી';

  @override
  String get viewerSpreadsheetFormulaBarEmpty => '-';

  @override
  String get viewerSpreadsheetAllCells => 'બધું';

  @override
  String viewerSpreadsheetColumnLabel(String col) {
    return 'કૉલમ $col';
  }

  @override
  String viewerSpreadsheetRowLabel(int row) {
    return 'પંક્તિ $row';
  }

  @override
  String viewerSpreadsheetCellSemantics(String col, int row, String value) {
    return 'કૉલમ $col, પંક્તિ $row, $value';
  }

  @override
  String get viewerSpreadsheetEmptyCell => 'ખાલી';

  @override
  String get viewerSpreadsheetEmptySheet => 'આ શીટ ખાલી છે';

  @override
  String get viewerSpreadsheetCopiedSingle => 'સેલ કૉપિ થયો';

  @override
  String viewerSpreadsheetCopiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count સેલ કૉપિ થયા',
      one: '1 સેલ કૉપિ થયો',
    );
    return '$_temp0';
  }

  @override
  String get viewerSpreadsheetCopyLimitReached =>
      'પસંદગી 5,000 સેલ સુધી મર્યાદિત કરી છે';

  @override
  String get viewerSpreadsheetCellContentTitle => 'સેલની સામગ્રી';

  @override
  String get viewerSpreadsheetCopyAction => 'કૉપિ કરો';

  @override
  String get viewerSpreadsheetCloseAction => 'બંધ કરો';

  @override
  String viewerSpreadsheetZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get viewerSpreadsheetResetZoomTooltip => 'ઝૂમ 100% પર રીસેટ કરો';

  @override
  String get viewerSpreadsheetNoMatches => 'આ શીટમાં કોઈ પરિણામો નથી';

  @override
  String get viewerSpreadsheetSearchPlaceholder => 'શીટમાં શોધો…';

  @override
  String get viewerSpreadsheetPasswordTitle => 'પાસવર્ડ-સુરક્ષિત ફાઇલ';

  @override
  String get viewerSpreadsheetPasswordMessage =>
      'પાસવર્ડ-સુરક્ષિત ફાઇલો અહીં ખોલી શકાતી નથી.';

  @override
  String get viewerSpreadsheetErrorTitle => 'આ સ્પ્રેડશીટ વાંચી શકાતી નથી';

  @override
  String get viewerSpreadsheetCorruptMessage =>
      'સ્પ્રેડશીટ ફાઇલ ક્ષતિગ્રસ્ત છે અથવા ડિકોડ થઈ શકી નથી.';

  @override
  String get viewerSpreadsheetTimeoutMessage =>
      '20 સેકન્ડ પછી સ્પ્રેડશીટ ખોલવાનો સમય સમાપ્ત થયો.';

  @override
  String get viewerSpreadsheetTooLargeMessage =>
      'આ ફાઇલ 25 MB જોવાની મર્યાદા કરતાં વધી ગઈ છે.';

  @override
  String get viewerSpreadsheetOpenBasicViewer => 'બેઝિક વ્યૂઅરમાં ખોલો';

  @override
  String get viewerSpreadsheetOpenAnotherApp => 'અન્ય એપમાં ખોલો';

  @override
  String get toolsWorkspaceOverline => 'વર્કસ્પેસ';

  @override
  String get toolsTitle => 'ટૂલ્સ';

  @override
  String get toolsSectionConvertCreate => 'કન્વર્ટ અને બનાવો';

  @override
  String get toolsSectionEditManage => 'એડિટ અને મેનેજ કરો';

  @override
  String get toolsSectionOthers => 'અન્ય';

  @override
  String get toolsCreatedByYou => 'તમારા દ્વારા બનાવેલ';

  @override
  String get toolsCreatedByYouEmpty => 'તમે બનાવેલી PDF અહીં દેખાશે';

  @override
  String get toolsCreatedByYouSeeAll => 'બધું જુઓ';

  @override
  String get toolManagePages => 'પેજ મેનેજ કરો';

  @override
  String get toolManagePagesSub => 'ક્રમ બદલો, ફેરવો અને કાઢી નાખો';

  @override
  String get toolImportFiles => 'ફાઇલો આયાત કરો';

  @override
  String get toolImportFilesSub => 'અન્ય એપ્સમાંથી ઉમેરો';

  @override
  String get toolPrintPdf => 'PDF પ્રિન્ટ કરો';

  @override
  String get toolPrintPdfSub => 'કોઈપણ પ્રિન્ટર પર મોકલો';

  @override
  String get toolCreatePdf => 'PDF બનાવો';

  @override
  String get toolCreatePdfSub => 'ખાલી દસ્તાવેજ અથવા ટેમ્પલેટ';

  @override
  String get toolRecycleBin => 'રિસાઇકલ બિન';

  @override
  String get toolRecycleBinSub => 'કાઢી નાખેલી ફાઇલો પાછી મેળવો';

  @override
  String get toolAnnotate => 'એનોટેટ કરો';

  @override
  String get toolAnnotateSub => 'હાઇલાઇટ, ડ્રો અને માર્ક કરો';

  @override
  String get toolAddText => 'ટેક્સ્ટ ઉમેરો';

  @override
  String get toolAddTextSub => 'ટેક્સ્ટ અને તારીખો ઉમેરો';

  @override
  String get toolSign => 'સહી કરો';

  @override
  String get toolSignSub => 'ફોર્મ ભરો અને સહી કરો';

  @override
  String get toolWordToPdf => 'Word થી PDF';

  @override
  String get toolWordToPdfSub => 'DOCX ને PDF માં કન્વર્ટ કરો';

  @override
  String get toolPptToPdf => 'PPT થી PDF';

  @override
  String get toolPptToPdfSub => 'PPTX ને PDF માં કન્વર્ટ કરો';

  @override
  String get printPdfErrorTooLarge =>
      'PDF ફાઇલ 50 MB પ્રિન્ટ મર્યાદા કરતાં વધી ગઈ છે.';

  @override
  String get printPdfErrorUnreadable => 'પ્રિન્ટિંગ માટે PDF વાંચવામાં અસમર્થ.';

  @override
  String get printPdfErrorPassword =>
      'પાસવર્ડ-સુરક્ષિત PDF સીધી પ્રિન્ટ કરી શકાતી નથી.';

  @override
  String get printPdfErrorFailed => 'પ્રિન્ટિંગ નિષ્ફળ ગયું.';

  @override
  String get printPdfSuccess => 'દસ્તાવેજ પ્રિન્ટર પર મોકલ્યો.';

  @override
  String get toolPickerTitleSelectPdf => 'PDF પસંદ કરો';

  @override
  String get toolPickerTitleSelectPdfs => 'PDF પસંદ કરો';

  @override
  String get toolPickerBrowseFiles => 'ફાઇલો બ્રાઉઝ કરો';

  @override
  String get toolPickerTabAll => 'બધી PDF';

  @override
  String get toolPickerTabRecent => 'તાજેતરનું';

  @override
  String get toolPickerTabDownloads => 'ડાઉનલોડ્સ';

  @override
  String get toolPickerTabICloud => 'iCloud Drive';

  @override
  String get toolPickerActionPrint => 'પ્રિન્ટ';

  @override
  String get toolPickerActionManage => 'મેનેજ કરો';

  @override
  String get toolPickerActionSelect => 'પસંદ કરો';

  @override
  String get toolsImportActionView => 'જુઓ';

  @override
  String get createPdfTemplateBlank => 'ખાલી';

  @override
  String get createPdfTemplateLine1 => 'લાઇન 1';

  @override
  String get createPdfTemplateLine2 => 'લાઇન 2';

  @override
  String get createPdfTemplateNotebook => 'નોટબુક';

  @override
  String get createPdfTemplateCornell => 'કોર્નેલ';

  @override
  String get createPdfTemplateGrid => 'ગ્રીડ';

  @override
  String get createPdfTemplateGraph => 'ગ્રાફ';

  @override
  String get createPdfSwatchWhite => 'સફેદ';

  @override
  String get createPdfSwatchCream => 'ક્રીમ';

  @override
  String get createPdfSwatchLightYellow => 'આછો પીળો';

  @override
  String get createPdfSwatchLightPeach => 'આછો પીચ';

  @override
  String get createPdfSwatchLightPink => 'આછો ગુલાબી';

  @override
  String get createPdfSwatchLightLavender => 'આછો લવેન્ડર';

  @override
  String get createPdfSwatchLightBlue => 'આછો વાદળી';

  @override
  String get createPdfSwatchLightMint => 'આછો મિન્ટ';

  @override
  String get createPdfSwatchLightGreen => 'આછો લીલો';

  @override
  String get createPdfSwatchLightGray => 'આછો રાખોડી';

  @override
  String get createPdfOrientationPortrait => 'પોટ્રેટ';

  @override
  String get createPdfOrientationLandscape => 'લેન્ડસ્કેપ';

  @override
  String get createPdfSectionTemplate => 'ટેમ્પલેટ';

  @override
  String get createPdfSectionPageSize => 'પેજનું કદ';

  @override
  String get createPdfSectionOrientation => 'ઓરિએન્ટેશન';

  @override
  String get createPdfSectionPageColor => 'પેજનો રંગ';

  @override
  String get createPdfSectionPageCount => 'પેજની સંખ્યા';

  @override
  String createPdfPagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count પેજ',
      one: '1 પેજ',
    );
    return '$_temp0';
  }

  @override
  String createPdfSummary(String pages, String size, String orientation) {
    return '$pages • $size • $orientation';
  }

  @override
  String get createPdfCreating => 'PDF બની રહી છે...';

  @override
  String createPdfProgress(int done, int total) {
    return '$total માંથી પેજ $done બની રહ્યું છે...';
  }

  @override
  String get createPdfErrorTitle => 'PDF બનાવવામાં અસમર્થ';

  @override
  String get createPdfErrorPageCount =>
      'પેજની સંખ્યા 1 અને 100 ની વચ્ચે હોવી જોઈએ.';

  @override
  String get createPdfErrorInvalidName => 'કૃપા કરીને માન્ય ફાઇલ નામ દાખલ કરો.';

  @override
  String get createPdfErrorGeneration =>
      'PDF દસ્તાવેજ બનાવવામાં નિષ્ફળ. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get trashErrorTooLarge =>
      'ફાઇલ રિસાઇકલ બિન માટે ખૂબ મોટી છે (200 MB મર્યાદા)';

  @override
  String get trashErrorNotEnoughSpace =>
      'રિસાઇકલ બિનમાં પૂરતી સ્ટોરેજ જગ્યા નથી';

  @override
  String trashErrorGeneric(String details) {
    return 'રિસાઇકલ બિન પ્રક્રિયા નિષ્ફળ: $details';
  }

  @override
  String get trashDialogMoveTitle => 'રિસાઇકલ બિનમાં ખસેડવી?';

  @override
  String trashDialogMoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ફાઇલો રિસાઇકલ બિનમાં ખસેડવી? તમે તેમને 30 દિવસ સુધી ટૂલ્સ > રિસાઇકલ બિનમાંથી પાછી મેળવી શકો છો.',
      one:
          '1 ફાઇલ રિસાઇકલ બિનમાં ખસેડવી? તમે તેને 30 દિવસ સુધી ટૂલ્સ > રિસાઇકલ બિનમાંથી પાછી મેળવી શકો છો.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionMove => 'રિસાઇકલ બિનમાં ખસેડો';

  @override
  String trashMovedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફાઇલો રિસાઇકલ બિનમાં ખસેડી',
      one: '1 ફાઇલ રિસાઇકલ બિનમાં ખસેડી',
    );
    return '$_temp0';
  }

  @override
  String get trashActionUndo => 'પૂર્વવત કરો';

  @override
  String trashRestoredSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફાઇલો પાછી મેળવી',
      one: '1 ફાઇલ પાછી મેળવી',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogDeleteForeverTitle => 'કાયમ માટે કાઢી નાખવી?';

  @override
  String trashDialogDeleteForeverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફાઇલો કાયમ માટે કાઢી નાખવી? આ પૂર્વવત કરી શકાતું નથી.',
      one: '1 ફાઇલ કાયમ માટે કાઢી નાખવી? આ પૂર્વવત કરી શકાતું નથી.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionDeleteForever => 'કાયમ માટે કાઢી નાખો';

  @override
  String trashDeletedForeverSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફાઇલો કાયમ માટે કાઢી નાખી',
      one: '1 ફાઇલ કાયમ માટે કાઢી નાખી',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogEmptyTitle => 'રિસાઇકલ બિન ખાલી કરવું?';

  @override
  String trashDialogEmptyBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફાઇલો',
      one: '1 ફાઇલ',
    );
    return 'બધી $_temp0 કાયમ માટે કાઢી નાખવી? આ પૂર્વવત કરી શકાતું નથી.';
  }

  @override
  String get trashActionEmptyBin => 'બિન ખાલી કરો';

  @override
  String get trashEmptyTitle => 'રિસાઇકલ બિન ખાલી છે';

  @override
  String get trashEmptySubtitle =>
      'રિસાઇકલ બિનમાં ખસેડેલી ફાઇલો કાયમી ધોરણે કાઢી નાખવામાં આવે તે પહેલાં 30 દિવસ સુધી અહીં રહેશે.';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count દિવસ બાકી',
      one: '1 દિવસ બાકી',
    );
    return '$_temp0';
  }

  @override
  String trashSubtitle(String date, String size) {
    return '$date ના રોજ કાઢી નાખી · $size';
  }

  @override
  String get trashDialogTooLargeTitle => 'રિસાઇકલ બિન માટે ખૂબ મોટી છે';

  @override
  String trashDialogTooLargeBody(String fileName) {
    return '\"$fileName\" 200 MB કરતાં મોટી છે અને તેને રિસાઇકલ બિનમાં ખસેડી શકાતી નથી. શું તમે તેને કાયમી ધોરણે કાઢી નાખવા માંગો છો?';
  }

  @override
  String get trashActionDeletePermanently => 'કાયમી ધોરણે કાઢી નાખો';

  @override
  String get trashInfoBanner =>
      'રિસાઇકલ બિનમાંની આઇટમ્સ 30 દિવસ પછી કાયમી ધોરણે કાઢી નાખવામાં આવે છે.';

  @override
  String get trashSheetRestore => 'પાછી મેળવો';

  @override
  String get trashSheetDeleteForever => 'કાયમ માટે કાઢી નાખો';

  @override
  String get trashSheetDetails => 'વિગતો';

  @override
  String get trashDetailsOriginalLocation => 'મૂળ સ્થાન';

  @override
  String get trashDetailsDateDeleted => 'કાઢી નાખ્યાની તારીખ';

  @override
  String get trashDetailsExpiresIn => 'આટલા સમયમાં સમાપ્ત થશે';

  @override
  String trashRestoredToFallbackSuccess(String location) {
    return '$location પર પાછી મેળવી (મૂળ ફોલ્ડર મળ્યું નહીં)';
  }

  @override
  String get trashDialogCopyFailedTitle => 'રિસાઇકલ બિનમાં ખસેડી શકાઈ નહીં';

  @override
  String trashDialogCopyFailedBody(String fileName) {
    return '\"$fileName\" ને રિસાઇકલ બિનમાં ખસેડી શકાઈ નહીં. શું તમે તેને કાયમી ધોરણે કાઢી નાખવા માંગો છો? આ પૂર્વવત કરી શકાતું નથી.';
  }

  @override
  String get trashDialogEmptyProgress => 'રિસાઇકલ બિન ખાલી થઈ રહ્યું છે...';

  @override
  String get trashDialogMoveProgress => 'ફાઇલો રિસાઇકલ બિનમાં ખસેડાઈ રહી છે...';

  @override
  String get trashDialogNotEnoughSpaceTitle => 'પૂરતી સ્ટોરેજ જગ્યા નથી';

  @override
  String get trashDialogNotEnoughSpaceBody =>
      'રિસાઇકલ બિનમાં ખસેડવા માટે પૂરતી સ્ટોરેજ જગ્યા નથી. બિન ખાલી કરીને જગ્યા ખાલી કરો.';

  @override
  String get trashActionFreeUpSpace => 'જગ્યા ખાલી કરો';

  @override
  String get trashDialogDeleteForeverProgress =>
      'ફાઇલો કાયમ માટે કાઢી નાખવામાં આવી રહી છે...';

  @override
  String get galleryDebugAgeTrash => 'ટ્રેશની બધી આઇટમ્સને 29 દિવસ જૂની કરો';

  @override
  String get galleryDebugSlowCopy => 'ધીમી ટ્રેશ કૉપિ (ટેસ્ટિંગ)';

  @override
  String get galleryDebugSlowCopySubtitle =>
      'કિલ ટેસ્ટિંગ માટે કૉપિ લૂપને ~20 MB/s સુધી ધીમું કરે છે';

  @override
  String get galleryDebugSlowSave => 'ધીમું એડિટર સેવ (ટેસ્ટિંગ)';

  @override
  String get galleryDebugSlowSaveSubtitle =>
      'કિલ ટેસ્ટિંગ માટે સેવ લૂપને ~8s સુધી ધીમું કરે છે';

  @override
  String get galleryDebugSaveAnnotate => 'સેમ્પલ 100p સેવ કરો (એનોટેટ ટેસ્ટ)';

  @override
  String get galleryDebugSaveSign => 'સેમ્પલ 100p સેવ કરો (સહી ટેસ્ટ)';

  @override
  String get galleryDebugSaveText =>
      'સેમ્પલ 100p સેવ કરો (ટેક્સ્ટ ઉમેરો ટેસ્ટ)';

  @override
  String get galleryDebugMove190Mb => '190MB ટેસ્ટ ફાઇલ ટ્રેશમાં ખસેડો';

  @override
  String get galleryDebugRestoreLastTrash => 'છેલ્લી ટ્રેશ આઇટમ પાછી મેળવો';

  @override
  String get galleryDebugEmptyTrash => 'રિસાઇકલ બિન ખાલી કરો';

  @override
  String galleryDebugAgeTrashSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count આઇટમ્સ',
      one: '1 આઇટમ',
    );
    return '$_temp0 ને 29 દિવસ જૂની કરી';
  }

  @override
  String get annotateErrorPasswordProtected => 'આ PDF પાસવર્ડ-સુરક્ષિત છે.';

  @override
  String get annotateErrorCorrupt =>
      'આ PDF ક્ષતિગ્રસ્ત છે અથવા વાંચી શકાતી નથી.';

  @override
  String get annotateSignedReplaceBlocked =>
      'મૂળ સહી કરેલી PDF ને બદલવાની પરવાનગી નથી. કૃપા કરીને નવી ફાઇલ તરીકે સેવ કરો.';

  @override
  String annotateErrorSaveFailed(String details) {
    return 'એનોટેશન્સ સેવ કરવામાં નિષ્ફળ: $details';
  }

  @override
  String get annotateErrorScannedPdf =>
      'આ દસ્તાવેજ સ્કેન કરેલો લાગે છે અથવા તેમાં પસંદ કરી શકાય તેવી ટેક્સ્ટ નથી.';

  @override
  String get annotateSignedBanner =>
      'ડિજિટલી સહી કરેલી PDF: સહી જાળવી રાખવા માટે સેવ કરવાથી નવી કૉપિ બનશે.';

  @override
  String get annotateActionSaveNew => 'નવી ફાઇલ તરીકે સેવ કરો';

  @override
  String get annotateActionReplace => 'મૂળ ફાઇલ બદલો';

  @override
  String get annotateDiscardDialogTitle => 'સેવ ન કરેલા એનોટેશન્સ રદ કરવા?';

  @override
  String get annotateDiscardDialogBody =>
      'તમારી પાસે સેવ ન કરેલા માર્કઅપ્સ છે. જો તમે હમણાં બહાર નીકળશો, તો તમારા ફેરફારો ખોવાઈ જશે.';

  @override
  String get annotateDiscardDialogActionDiscard => 'રદ કરો';

  @override
  String get annotateDiscardDialogActionKeep => 'એડિટ કરવાનું ચાલુ રાખો';

  @override
  String get annotateSaveSuccess => 'એનોટેશન્સ સફળતાપૂર્વક સેવ થયા';

  @override
  String get annotateToolbarHighlight => 'હાઇલાઇટ';

  @override
  String get annotateToolbarUnderline => 'અંડરલાઇન';

  @override
  String get annotateToolbarStrikethrough => 'સ્ટ્રાઇકથ્રુ';

  @override
  String get annotateToolbarCopy => 'કૉપિ';

  @override
  String get annotateColorYellow => 'પીળો';

  @override
  String get annotateColorGreen => 'લીલો';

  @override
  String get annotateColorCyan => 'સ્યાન';

  @override
  String get annotateColorPink => 'ગુલાબી';

  @override
  String get annotateColorOrange => 'નારંગી';

  @override
  String get annotateSaveTitle => 'એનોટેશન્સ સેવ કરો';

  @override
  String get annotateSaveProgress => 'એનોટેશન્સ સેવ થઈ રહ્યા છે...';

  @override
  String get annotateNoChanges => 'સેવ કરવા માટે કોઈ એનોટેશન્સ નથી';

  @override
  String get annotateTooltipUndo => 'પૂર્વવત કરો';

  @override
  String get annotateTooltipRedo => 'ફરી કરો';

  @override
  String get annotateTooltipSave => 'સેવ કરો';

  @override
  String get annotateCopiedToClipboard => 'ક્લિપબોર્ડ પર કૉપિ થયું';

  @override
  String get annotateToolbarPen => 'પેન';

  @override
  String get annotatePenTipBanner =>
      'એક આંગળીથી દોરો. બે આંગળીથી ખસેડો અને ઝૂમ કરો.';

  @override
  String get annotatePenSheetTitle => 'પેન સેટિંગ્સ';

  @override
  String get annotatePenStrokeWidth => 'સ્ટ્રોકની પહોળાઈ';

  @override
  String get annotatePenEraserMode => 'ઇરેઝર';

  @override
  String get annotateColorBlack => 'કાળો';

  @override
  String get annotateColorRed => 'લાલ';

  @override
  String get annotateColorPurple => 'જાંબલી';

  @override
  String get annotateColorBlue => 'વાદળી';

  @override
  String get toolSignPdf => 'PDF પર સહી કરો';

  @override
  String get toolSignPdfSubtitle => 'દસ્તાવેજોમાં સહી અને તારીખ ઉમેરો';

  @override
  String get signToolbarSign => 'સહી કરો';

  @override
  String get signToolbarDate => 'તારીખ';

  @override
  String get signToolbarClearAll => 'બધું સાફ કરો';

  @override
  String get signPadTitle => 'તમારી સહી દોરો';

  @override
  String get signPadClear => 'સાફ કરો';

  @override
  String get signPadSave => 'સહી સેવ કરો';

  @override
  String get signSheetTitle => 'સેવ કરેલી સહીઓ';

  @override
  String get signSheetCreateNew => 'નવી સહી બનાવો';

  @override
  String get signMaxSignaturesReached =>
      'મહત્તમ 5 સેવ કરેલી સહીઓની મર્યાદા પૂરી થઈ';

  @override
  String get signMaxPlacedReached =>
      'દસ્તાવેજ દીઠ મહત્તમ 20 સહીઓની મર્યાદા પૂરી થઈ';

  @override
  String get signDeleteSignatureTitle => 'સહી કાઢી નાખવી?';

  @override
  String get signDeleteSignatureBody =>
      'આ સહી તમારી સેવ કરેલી સહીઓમાંથી દૂર કરવામાં આવશે.';

  @override
  String get signConfirmClearAllTitle => 'બધી સહીઓ સાફ કરવી?';

  @override
  String get signConfirmClearAllBody =>
      'આ દસ્તાવેજ પર મૂકેલી બધી સહીઓ અને તારીખો દૂર કરવામાં આવશે.';

  @override
  String get signSaveSuccess => 'દસ્તાવેજ પર સફળતાપૂર્વક સહી થઈ';

  @override
  String get signNoSignaturesToSave => 'દસ્તાવેજ પર કોઈ સહી મૂકેલી નથી';

  @override
  String get signPlacedSignatureDelete => 'કાઢી નાખો';

  @override
  String get signPlacedSignatureApply => 'લાગુ કરો';

  @override
  String get signTooltipUndo => 'પૂર્વવત કરો';

  @override
  String get signTooltipRedo => 'ફરી કરો';

  @override
  String get signTooltipSave => 'સેવ કરો';

  @override
  String annotatePenStrokeWidthValue(String width) {
    return '$width pt';
  }

  @override
  String get annotateErrorTooManyStrokes =>
      'દસ્તાવેજ મહત્તમ 5,000 સ્ટ્રોક અથવા 300,000 પોઇન્ટ્સ સુધી પહોંચી ગયો છે.';

  @override
  String annotateChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ફેરફારો',
      one: '1 ફેરફાર',
    );
    return '$_temp0';
  }

  @override
  String get annotatePenNotice =>
      'પેન સ્ટ્રોક સેવ કર્યા પછી પેજનો ભાગ બની જાય છે અને પછીથી એડિટ કરી શકાતા નથી.';

  @override
  String get annotatePenNoticeDismiss => 'સમજાઈ ગયું';

  @override
  String get signPadBaselineHint => 'અહીં સહી કરો';

  @override
  String get signPadUndo => 'પૂર્વવત કરો';

  @override
  String get signPadUseOnce => 'એકવાર વાપરો';

  @override
  String get signPadSaveAndUse => 'સેવ કરો અને વાપરો';

  @override
  String get tool_add_text => 'ટેક્સ્ટ ઉમેરો';

  @override
  String get tool_add_text_desc => 'પેજ પર ટેક્સ્ટ બોક્સ અને નોંધો ઉમેરો';

  @override
  String get addTextNoticePermanent =>
      'ઉમેરેલી ટેક્સ્ટ પેજનો ભાગ બની જાય છે અને સેવ કર્યા પછી એડિટ કરી શકાતી નથી.';

  @override
  String get addTextNoticeRaster =>
      'આ ભાષામાં ટેક્સ્ટ ઇમેજ તરીકે ઉમેરવામાં આવે છે અને પસંદ કરી શકાતી નથી.';

  @override
  String get addTextNoticeGotIt => 'સમજાઈ ગયું';

  @override
  String get addTextActionAdd => 'ટેક્સ્ટ ઉમેરો';

  @override
  String get addTextActionStyle => 'શૈલી';

  @override
  String get addTextActionDelete => 'કાઢી નાખો';

  @override
  String get addTextStyleSheetTitle => 'ટેક્સ્ટ શૈલી';

  @override
  String get addTextFontSize => 'ફોન્ટનું કદ';

  @override
  String get addTextColor => 'રંગ';

  @override
  String get addTextStyle => 'શૈલી';

  @override
  String get addTextAlign => 'ગોઠવણી';

  @override
  String get addTextBold => 'બોલ્ડ';

  @override
  String get addTextItalic => 'ઇટાલિક';

  @override
  String get addTextAlignStart => 'શરૂઆત';

  @override
  String get addTextAlignCenter => 'મધ્યમાં';

  @override
  String get addTextAlignEnd => 'અંત';

  @override
  String get addTextErrorTooManyBoxes =>
      'મહત્તમ 30 ટેક્સ્ટ બોક્સની મર્યાદા પૂરી થઈ';

  @override
  String get addTextErrorBoxTooLong =>
      'ટેક્સ્ટ બોક્સ 2,000 અક્ષરોથી વધુ હોઈ શકે નહીં';

  @override
  String get addTextPlaceholder => 'અહીં ટેક્સ્ટ લખો';

  @override
  String get addTextSamplePreview => 'નમૂના પૂર્વાવલોકન';

  @override
  String addTextFontSizePt(int size) {
    return '$size pt';
  }

  @override
  String get premiumTitle => 'Doc View પ્રીમિયમ';

  @override
  String get premiumSubtitle =>
      'એનોટેટ અને સહી ટૂલ્સ અનલોક કરો અને સંપૂર્ણપણે જાહેરાત-મુક્ત અનુભવ માણો.';

  @override
  String get premiumFeatureAllTools => 'એનોટેટ અને PDF સહી ટૂલ્સ';

  @override
  String get premiumFeatureAllToolsSub =>
      'સરળતાથી માર્કઅપ દોરો, દસ્તાવેજો હાઇલાઇટ કરો અને PDF પર સહી કરો';

  @override
  String get premiumFeatureAdFree => '100% જાહેરાત-મુક્ત અનુભવ';

  @override
  String get premiumFeatureAdFreeSub =>
      'ક્યાંય કોઈ બેનર, વિક્ષેપ કે અવરોધ નહીં';

  @override
  String get premiumFeatureUnlimitedConversions => 'અમર્યાદિત સ્થાનિક કન્વર્ઝન';

  @override
  String get premiumFeatureUnlimitedConversionsSub =>
      'શૂન્ય ફાઇલ મર્યાદા સાથે ડિવાઇસ પર દસ્તાવેજો કન્વર્ટ કરો';

  @override
  String get premiumFeaturePrivacyFirst => '100% ખાનગી અને ઓન-ડિવાઇસ';

  @override
  String get premiumFeaturePrivacyFirstSub =>
      'ફાઇલો સ્થાનિક રીતે પ્રોસેસ થાય છે અને ક્યારેય કોઈ સર્વર પર અપલોડ થતી નથી';

  @override
  String get premiumPlanYearly => 'વાર્ષિક સબ્સ્ક્રિપ્શન';

  @override
  String premiumPlanYearlyTrial(int days, String price) {
    return '$days દિવસ મફત, પછી $price/વર્ષ';
  }

  @override
  String get premiumPlanMonthly => 'માસિક સબ્સ્ક્રિપ્શન';

  @override
  String premiumPlanMonthlySub(String price) {
    return '$price/મહિનો';
  }

  @override
  String premiumPlanYearlySub(String price) {
    return '$price/વર્ષ';
  }

  @override
  String premiumPlanMonthlyTrial(int days, String price) {
    return '$days દિવસ મફત, પછી $price/મહિનો';
  }

  @override
  String premiumSavePercent(int percent) {
    return '$percent% બચાવો';
  }

  @override
  String get premiumSaveUnknown => '-% બચાવો';

  @override
  String premiumActionStartTrial(int days) {
    return '$days-દિવસની મફત ટ્રાયલ શરૂ કરો';
  }

  @override
  String get premiumSubscriptionsAvailableSoon =>
      'સબ્સ્ક્રિપ્શન્સ ટૂંક સમયમાં ઉપલબ્ધ થશે.';

  @override
  String get premiumLoadPlansFailed => 'Could not load plans. Tap to retry';

  @override
  String errorCodeLabel(String code) {
    return 'Error code: $code';
  }

  @override
  String get pagesEditPagesAction => 'પેજ એડિટ કરો';

  @override
  String get premiumCancelAnytime => 'ગમે ત્યારે રદ કરો';

  @override
  String get premiumPendingStatus =>
      'તમારી ખરીદી Google Play દ્વારા પ્રોસેસ થઈ રહી છે. પુષ્ટિ થતાં જ સુવિધાઓ સક્રિય થઈ જશે.';

  @override
  String get premiumRenewalDisclosurePricingUnavailable =>
      'આપમેળે રિન્યુ થાય છે. ચેકઆઉટ વખતે Google Play દ્વારા કિંમતની પુષ્ટિ કરવામાં આવશે. Google Play સબ્સ્ક્રિપ્શન્સમાં ગમે ત્યારે રદ કરો.';

  @override
  String get premiumActionSubscribe => 'સબ્સ્ક્રાઇબ કરો';

  @override
  String get premiumActionRestore => 'ખરીદીઓ પાછી મેળવો';

  @override
  String get premiumBillingDisclaimer =>
      'આપમેળે રિન્યુ થાય છે. Google Play સબ્સ્ક્રિપ્શન્સમાં ગમે ત્યારે રદ કરો.';

  @override
  String get premiumTerms => 'સેવાની શરતો';

  @override
  String get premiumPrivacy => 'પ્રાઇવસી પોલિસી';

  @override
  String get premiumActiveStatus => 'તમે પ્રીમિયમ સબ્સ્ક્રાઇબર છો';

  @override
  String get premiumGraceStatus => 'ઓફલાઇન ગ્રેસ પીરિયડ સક્રિય છે';

  @override
  String get premiumExpiredStatus => 'સબ્સ્ક્રિપ્શન સમાપ્ત થયું';

  @override
  String get premiumRestoreSuccess => 'ખરીદીઓ સફળતાપૂર્વક પાછી મેળવી.';

  @override
  String get premiumRestoreNone => 'કોઈ સક્રિય સબ્સ્ક્રિપ્શન મળ્યું નથી.';

  @override
  String get premiumErrorGeneral =>
      'ખરીદી પૂર્ણ કરવામાં અસમર્થ. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get premiumPagesGateTitle => 'Doc View પ્રીમિયમ';

  @override
  String get premiumPagesGateBody =>
      'પેજનો ક્રમ બદલવા, ફેરવવા અને કાઢી નાખવા માટે પ્રીમિયમ સબ્સ્ક્રિપ્શન જરૂરી છે.';

  @override
  String get premiumPagesGateUpgrade => 'પ્રીમિયમમાં અપગ્રેડ કરો';

  @override
  String get premiumTooltip => 'Doc View પ્રીમિયમ';

  @override
  String get premiumManageInPlay => 'મેનેજ કરો';

  @override
  String get faqQuestion8 => 'Doc View પ્રીમિયમમાં શું શામેલ છે?';

  @override
  String get faqAnswer8 =>
      'Doc View પ્રીમિયમ PDF પેજ ક્રમ બદલવા, ફેરવવા, કાઢી નાખવા, PDF થી Word કન્વર્ઝન, એનોટેશન્સ, સહીઓ અને કસ્ટમ ટેક્સ્ટ ઉમેરવા સહિત તમામ અદ્યતન દસ્તાવેજ એડિટિંગ ટૂલ્સને અનલોક કરે છે, અને સમગ્ર એપમાંથી બધી જાહેરાતો સંપૂર્ણપણે દૂર કરે છે. બધી દસ્તાવેજ પ્રક્રિયા 100% ઓન-ડિવાઇસ જ રહે છે.';

  @override
  String get faqQuestion9 =>
      'શું હું ઇન્ટરનેટ કનેક્શન વિના Doc View પ્રીમિયમનો ઉપયોગ કરી શકું છું?';

  @override
  String get faqAnswer9 =>
      'હા. એકવાર સક્રિય થઈ ગયા પછી, Doc View સતત 7 દિવસ સુધીના ઓફલાઇન ગ્રેસ પીરિયડ સાથે તમારા ડિવાઇસ પર તમારી સબ્સ્ક્રિપ્શન સ્થિતિને સુરક્ષિત રીતે કેશ કરે છે. તમે આ સમયગાળા દરમિયાન બધા એડિટિંગ ટૂલ્સનો ઓફલાઇન ઉપયોગ ચાલુ રાખી શકો છો.';

  @override
  String get galleryDebugIapSectionTitle =>
      '15. IAP અને પ્રીમિયમ સિમ્યુલેટર (G7)';

  @override
  String get galleryDebugIapStateFree => 'મફત સેટ કરો';

  @override
  String get galleryDebugIapStateYearly => 'વાર્ષિક પ્રીમિયમ સેટ કરો';

  @override
  String get galleryDebugIapStateMonthly => 'માસિક પ્રીમિયમ સેટ કરો';

  @override
  String get galleryDebugIapStateGrace => 'ઓફલાઇન ગ્રેસ સેટ કરો (સક્રિય)';

  @override
  String get galleryDebugIapStateGraceExpired =>
      'ઓફલાઇન ગ્રેસ સેટ કરો (સમાપ્ત)';

  @override
  String get galleryDebugOpenPremium => '/premium સ્ક્રીન ખોલો';

  @override
  String get galleryDebugIapProductSeenTrue => 'પ્રોડક્ટ જોયેલ સેટ કરો: True';

  @override
  String get galleryDebugIapProductSeenFalse => 'પ્રોડક્ટ જોયેલ સેટ કરો: False';

  @override
  String get addWidgetSheetTitle => 'હોમ સ્ક્રીન પર ઉમેરો';

  @override
  String get addWidgetSheetSubtitle =>
      'તમારી હોમ સ્ક્રીન પર ઉમેરવા માટે વિજેટ પસંદ કરો';

  @override
  String get widgetRecentFilesTitle => 'તાજેતરની ફાઇલો';

  @override
  String get widgetRecentFilesBadge => '4 × 2';

  @override
  String get widgetRecentFilesDesc =>
      'તમારી હોમ સ્ક્રીન પરથી સીધી તમારી તાજેતરમાં વપરાયેલી ફાઇલો જુઓ અને ખોલો';

  @override
  String get widgetQuickToolsTitle => 'ઝડપી ટૂલ્સ';

  @override
  String get widgetQuickToolsBadge => '4 × 1';

  @override
  String get widgetQuickToolsDesc =>
      'સીધા સ્કેન, ઇમેજથી PDF, શોધ અથવા આયાત પર જાઓ';

  @override
  String get addWidgetButton => 'વિજેટ ઉમેરો';

  @override
  String get addWidgetManualTitle => 'મેન્યુઅલી વિજેટ ઉમેરો';

  @override
  String get addWidgetManualMessage =>
      'તમારી હોમ સ્ક્રીન પર ખાલી જગ્યાને ટચ કરીને દબાવી રાખો, વિજેટ્સ પર ટૅપ કરો, Doc View શોધો અને તેને તમારી સ્ક્રીન પર ખેંચો.';

  @override
  String get settingsQuickAccessNotificationTitle => 'ઝડપી ઍક્સેસ નોટિફિકેશન';

  @override
  String get settingsQuickAccessNotificationSubtitle =>
      'નોટિફિકેશન બારમાં ઝડપી ટૂલ્સ બતાવો';

  @override
  String get notificationPermissionDialogTitle => 'નોટિફિકેશન્સની મંજૂરી આપો';

  @override
  String get notificationPermissionDialogDesc =>
      'તમારી નોટિફિકેશન ટ્રેમાં ઝડપી ઍક્સેસ બાર બતાવવા માટે Doc View ને નોટિફિકેશન પરવાનગીની જરૂર છે.';

  @override
  String get notificationTitle => 'Doc View ઝડપી ટૂલ્સ';

  @override
  String get notificationBody => 'દસ્તાવેજો સ્કેન કરો, કન્વર્ટ કરો અથવા શોધો';

  @override
  String get notificationActionScan => 'સ્કેન';

  @override
  String get notificationActionImageToPdf => 'ઇમેજથી PDF';

  @override
  String get notificationActionSearch => 'શોધો';

  @override
  String get settingsAdChoicesTitle => 'જાહેરાત પસંદગીઓ';

  @override
  String get settingsAdChoicesSubtitle =>
      'પ્રાઇવસી અને જાહેરાત પસંદગીઓ મેનેજ કરો';

  @override
  String get faqQuestion10 => 'Doc View જાહેરાતો કેમ બતાવે છે?';

  @override
  String get faqAnswer10 =>
      'જાહેરાતો Doc View ને મફત રાખે છે. પ્રીમિયમ તેમને દૂર કરે છે. જાહેરાતો Google AdMob દ્વારા આપવામાં આવે છે અને તે તમારા દસ્તાવેજો ક્યારેય જોતી નથી.';
}
