// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Doc View';

  @override
  String get navHome => 'सभी फ़ाइलें';

  @override
  String get navTools => 'टूल्स';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get noDocumentSelected => 'कोई दस्तावेज़ नहीं चुना गया';

  @override
  String get tooltipCloseAd => 'विज्ञापन बंद करें';

  @override
  String get tooltipClose => 'बंद करें';

  @override
  String get tooltipRescan => 'दस्तावेज़ फिर से स्कैन करें';

  @override
  String get tooltipSearch => 'दस्तावेज़ खोजें';

  @override
  String get tooltipSelectFiles => 'फ़ाइलें चुनें';

  @override
  String get tooltipBack => 'पीछे जाएं';

  @override
  String get tooltipCancelSelection => 'चयन रद्द करें';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चयनित',
      one: '1 चयनित',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'सभी चुनें';

  @override
  String get actionDeselectAll => 'सभी अचयनित करें';

  @override
  String get tooltipDeleteSelected => 'चयनित हटाएं';

  @override
  String get tooltipClearSearch => 'खोज साफ़ करें';

  @override
  String get searchHint => 'दस्तावेज़, फ़ोल्डर खोजें...';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return '$total में से पेज $page';
  }

  @override
  String get errorGenericTitle => 'कुछ गड़बड़ हो गई';

  @override
  String get actionRetry => 'पुनः प्रयास करें';

  @override
  String get permissionAllFilesTitle => 'सभी फ़ाइलों की अनुमति आवश्यक है';

  @override
  String get permissionAllFilesExplanation =>
      'फ़ोल्डर ब्राउज़ करने और आपके दस्तावेज़ों को पूरी तरह ऑफ़लाइन व्यवस्थित करने के लिए Doc View को सभी फ़ाइलों की अनुमति चाहिए।';

  @override
  String get actionGrantAccess => 'अनुमति दें';

  @override
  String get actionImportFilesInstead => 'इसके बजाय फ़ाइलें इम्पोर्ट करें';

  @override
  String get tooltipRemoveBookmark => 'बुकमार्क हटाएं';

  @override
  String get tooltipAddBookmark => 'बुकमार्क जोड़ें';

  @override
  String tooltipFileOptions(String title) {
    return '$title के लिए फ़ाइल विकल्प';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return 'फ़ोल्डर, $name$subtitle';
  }

  @override
  String get adAdvertisementBadge => 'विज्ञापन';

  @override
  String get actionConfirm => 'पुष्टि करें';

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get tabRecent => 'हालिया';

  @override
  String get tabBookmarks => 'बुकमार्क';

  @override
  String get filterCategoryAll => 'सभी';

  @override
  String get actionBrowse => 'ब्राउज़ करें';

  @override
  String get actionCancelOperation => 'प्रक्रिया रद्द करें';

  @override
  String get operationComplete => 'प्रक्रिया पूरी हुई';

  @override
  String get actionOpenDocument => 'दस्तावेज़ खोलें';

  @override
  String get actionShareDocument => 'दस्तावेज़ शेयर करें';

  @override
  String get splashTagline => 'आपके सभी दस्तावेज़, एक जगह।';

  @override
  String appVersion(String version) {
    return 'संस्करण $version';
  }

  @override
  String onboardingStep(int current, int total) {
    return '$total में से चरण $current';
  }

  @override
  String get actionSkip => 'छोड़ें';

  @override
  String get actionBack => 'पीछे';

  @override
  String get actionNext => 'आगे';

  @override
  String get actionGetStarted => 'शुरू करें';

  @override
  String get onboardingPage1Title => 'आपके सभी दस्तावेज़,\nएक जगह';

  @override
  String get onboardingPage1Desc =>
      'Doc View आपके फ़ोन पर मौजूद PDF, Word, Excel, PowerPoint, टेक्स्ट फ़ाइलें और इमेज अपने-आप ढूंढता है और उन्हें व्यवस्थित करता है।';

  @override
  String get onboardingPage2Title => 'कुछ भी पढ़ें,\nबेहतरीन अनुभव के साथ';

  @override
  String get onboardingPage2Desc =>
      'तेज़ और साफ़ रीडर के साथ PDF, Word, Excel और PowerPoint फ़ाइलें खोलें। खोजें, बुकमार्क करें और जहाँ छोड़ा था वहीं से फिर शुरू करें।';

  @override
  String get onboardingPage3Title => 'शक्तिशाली PDF टूल्स, ऑफ़लाइन';

  @override
  String get onboardingPage3Desc =>
      'फ़ोटो को PDF में बदलें, दस्तावेज़ स्कैन करें, फ़ाइलें मर्ज और स्प्लिट करें। सब कुछ आपके डिवाइस पर ही रहता है।';

  @override
  String get onboardingOfflineGuarantee =>
      'आपकी फ़ाइलें आपके डिवाइस पर ही रहती हैं';

  @override
  String get toolImageToPdf => 'इमेज से PDF';

  @override
  String get toolImageToPdfSub => 'JPG और PNG बदलें';

  @override
  String get toolScanToPdf => 'स्कैन से PDF';

  @override
  String get toolScanToPdfSub => 'कैमरा एज डिटेक्ट';

  @override
  String get toolMergePdf => 'PDF मर्ज करें';

  @override
  String get toolMergePdfSub => 'एक फ़ाइल में जोड़ें';

  @override
  String get toolSplitPdf => 'PDF स्प्लिट करें';

  @override
  String get toolSplitPdfSub => 'कोई भी रेंज निकालें';

  @override
  String get permissionTagStorage => 'डिवाइस स्टोरेज एक्सेस';

  @override
  String get permissionStorageHeadline =>
      'Doc View को अपने दस्तावेज़ ढूंढने दें';

  @override
  String get permissionStorageBody =>
      'किसी भी ऐप द्वारा सेव की गई PDF, Word, Excel और अन्य फ़ाइलों की सूची दिखाने के लिए, Android को सभी फ़ाइलों की अनुमति चाहिए। आपकी फ़ाइलें कभी आपके फ़ोन से बाहर नहीं जातीं।';

  @override
  String get permissionReassuranceOfflineTitle =>
      'फ़ाइलें कभी अपलोड नहीं होतीं';

  @override
  String get permissionReassuranceOfflineDesc =>
      'आपके दस्तावेज़ आपके डिवाइस पर ही स्थानीय रूप से प्रोसेस होते हैं।';

  @override
  String get permissionReassuranceNoUploadsTitle => 'कोई अपलोड नहीं';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      'कोई क्लाउड सर्वर नहीं। आपकी फ़ाइलें पूरी तरह फ़ोन मेमोरी में रहती हैं।';

  @override
  String get permissionReassuranceChangeTitle => 'आप इसे कभी भी बदल सकते हैं';

  @override
  String get permissionReassuranceChangeDesc =>
      'अपनी Android सिस्टम ऐप सेटिंग्स में आसानी से बदलें।';

  @override
  String get permissionTagIOS => 'iOS स्टोरेज गाइड';

  @override
  String get permissionIOSHeadline => 'अपने दस्तावेज़ Doc View में लाएं';

  @override
  String get permissionIOSBody =>
      'Apple की गोपनीयता नीति के कारण, iOS किसी भी ऐप को पूरे फ़ोन को अपने-आप स्कैन करने की अनुमति नहीं देता। चुनें कि आप अपनी फ़ाइलें कैसे पढ़ना चाहते हैं:';

  @override
  String get permissionIOSOptionImportTitle => 'फ़ाइलें इम्पोर्ट करें';

  @override
  String get permissionIOSBadgeFastest => 'सबसे तेज़';

  @override
  String get permissionIOSOptionImportDesc =>
      'कुछ ही सेकंड में सीधे अपने iCloud Drive, Downloads या किसी भी फ़ोल्डर से दस्तावेज़ चुनें।';

  @override
  String get permissionIOSOptionFolderTitle =>
      'Files ऐप में Doc View फ़ोल्डर खोलें';

  @override
  String get permissionIOSOptionFolderDesc =>
      'तुरंत सिंक के लिए iOS Files ऐप में सीधे \"Doc View\" फ़ोल्डर में दस्तावेज़ सेव या AirDrop करें।';

  @override
  String get actionImportFiles => 'फ़ाइलें इम्पोर्ट करें';

  @override
  String get actionContinueToApp => 'ऐप पर आगे बढ़ें';

  @override
  String get permissionTagConsent => 'पारदर्शिता और सहमति';

  @override
  String get permissionBadgeFree => '100% मुफ़्त ऐप';

  @override
  String get permissionBadgeMinimalAds => 'कम विज्ञापन';

  @override
  String get permissionConsentHeadline => 'विज्ञापनों के साथ मुफ़्त';

  @override
  String get permissionConsentBody =>
      'विज्ञापनों की वजह से Doc View मुफ़्त है। आगे हम आपसे व्यक्तिगत विज्ञापनों के बारे में आपकी पसंद पूछेंगे।';

  @override
  String get permissionConsentAdsTitle => 'आपको कौन से विज्ञापन दिख सकते हैं';

  @override
  String get permissionConsentAdsDesc =>
      'छोटे बैनर विज्ञापन और बिना बाधा वाले स्पॉन्सर कार्ड। पढ़ते समय कोई पॉपअप या वीडियो रुकावट नहीं।';

  @override
  String get permissionConsentPrivateTitle =>
      'दस्तावेज़ पूरी तरह निजी रहते हैं';

  @override
  String get permissionConsentPrivateDesc =>
      'विज्ञापन पार्टनर्स के पास कभी भी आपके दस्तावेज़ों के नाम, टेक्स्ट सामग्री या फ़ाइल लोकेशन की पहुंच नहीं होती।';

  @override
  String get permissionConsentSettingsTitle =>
      'आप सेटिंग्स में अपनी पसंद बदल सकते हैं';

  @override
  String get permissionConsentSettingsDesc =>
      'Doc View सेटिंग्स में कभी भी व्यक्तिगत विज्ञापन सहमति या गोपनीयता प्राथमिकताएं अपडेट करें।';

  @override
  String get actionContinue => 'जारी रखें';

  @override
  String get actionPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें इम्पोर्ट की गईं',
      one: '1 फ़ाइल इम्पोर्ट की गई',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => 'फ़ाइलें इम्पोर्ट करने में विफल';

  @override
  String get tooltipImportDocuments => 'दस्तावेज़ इम्पोर्ट करें';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें मिलीं',
      one: '1 फ़ाइल मिली',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => 'स्कैन हो रहा है...';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें',
      one: '1 फ़ाइल',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => 'फ़ोल्डर';

  @override
  String get errorLoadingRecent => 'हालिया फ़ाइलें लोड करने में त्रुटि';

  @override
  String get emptyStateTitle => 'खाली';

  @override
  String get emptyRecentDescription =>
      'हाल ही में खोली गई फ़ाइलें यहाँ दिखाई देंगी';

  @override
  String get errorLoadingBookmarks =>
      'बुकमार्क की गई फ़ाइलें लोड करने में त्रुटि';

  @override
  String get emptyBookmarksDescription =>
      'बुकमार्क किए गए दस्तावेज़ यहाँ दिखाई देंगे';

  @override
  String get dialogDeleteTitle => 'चयनित फ़ाइलें हटाएं?';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें हटाएं? इसे वापस नहीं लाया जा सकता।',
      one: '1 फ़ाइल हटाएं? इसे वापस नहीं लाया जा सकता।',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें हटाई गईं',
      one: '1 फ़ाइल हटाई गई',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => 'फ़ाइलें हटाने में विफल';

  @override
  String get actionDelete => 'हटाएं';

  @override
  String get searchRecentSearchesHeader => 'हालिया खोजें';

  @override
  String get actionClear => 'साफ़ करें';

  @override
  String get searchPromptTitle => 'दस्तावेज़ खोजने के लिए टाइप करें';

  @override
  String get searchPromptMessage =>
      'फ़ाइल नाम या एक्सटेंशन के आधार पर सभी स्थानीय फ़ोल्डरों में खोजें';

  @override
  String get searchError => 'दस्तावेज़ खोजने में त्रुटि';

  @override
  String get searchNoResultsTitle => 'कोई मिलता-जुलता दस्तावेज़ नहीं मिला';

  @override
  String get searchNoResultsMessage =>
      'किसी दूसरे फ़ाइल नाम कीवर्ड या फ़ॉर्मैट फ़िल्टर से खोजने का प्रयास करें';

  @override
  String get tooltipSortOptions => 'क्रमबद्ध करने के विकल्प';

  @override
  String get sortSheetTitle => 'इसके अनुसार क्रमबद्ध करें';

  @override
  String get sortOptionDate => 'संशोधित तिथि';

  @override
  String get sortOptionName => 'दस्तावेज़ का नाम';

  @override
  String get sortOptionSize => 'फ़ाइल का आकार';

  @override
  String get sortAscendingOrder => 'आरोही क्रम';

  @override
  String get sortAscendingSubtitle =>
      'सबसे पुरानी पहले / A से Z / सबसे छोटी पहले';

  @override
  String get sortDescendingSubtitle => 'सबसे नई पहले / Z से A / सबसे बड़ी पहले';

  @override
  String get categoryAllFiles => 'सभी फ़ाइलें';

  @override
  String get loadingStatus => 'लोड हो रहा है...';

  @override
  String get emptyCategoryImagesTitle => 'कोई इमेज नहीं मिली';

  @override
  String get emptyCategoryImagesMessage =>
      'इस डिवाइस पर मिली इमेज यहाँ दिखाई देंगी';

  @override
  String get emptyCategoryDocsTitle => 'कोई दस्तावेज़ नहीं मिला';

  @override
  String get emptyCategoryDocsMessage =>
      'स्कैन करने के बाद इस फ़ॉर्मैट के दस्तावेज़ यहाँ दिखाई देंगे';

  @override
  String get actionOpen => 'खोलें';

  @override
  String get actionShare => 'शेयर करें';

  @override
  String get actionRename => 'नाम बदलें';

  @override
  String get actionBookmark => 'बुकमार्क करें';

  @override
  String get actionRemoveBookmark => 'बुकमार्क हटाएं';

  @override
  String get actionOpenInAnotherApp => 'दूसरे ऐप में खोलें';

  @override
  String get actionDetails => 'विवरण';

  @override
  String get actionOpenFile => 'फ़ाइल खोलें';

  @override
  String get actionShareAll => 'सभी शेयर करें';

  @override
  String get actionDone => 'हो गया';

  @override
  String get actionSeeAll => 'सभी देखें';

  @override
  String get actionAllow => 'अनुमति दें';

  @override
  String get actionNotNow => 'अभी नहीं';

  @override
  String get tooltipMoreActions => 'अधिक क्रियाएं';

  @override
  String get tooltipCopyPath => 'पाथ कॉपी करें';

  @override
  String get tooltipRotatePage => 'पेज घुमाएं';

  @override
  String get tooltipRemovePage => 'पेज हटाएं';

  @override
  String get renameFileTitle => 'फ़ाइल का नाम बदलें';

  @override
  String get renameFileNameLabel => 'फ़ाइल का नाम';

  @override
  String renamedSuccess(String fileName) {
    return 'नाम बदलकर $fileName किया गया';
  }

  @override
  String get deleteFileTitle => 'फ़ाइल हटाएं?';

  @override
  String deleteFileConfirmation(String fileName) {
    return '\"$fileName\" को हटाएं? इसे वापस नहीं लाया जा सकता।';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return '\"$fileName\" हटाई गई';
  }

  @override
  String get fileDetailsTitle => 'दस्तावेज़ विवरण';

  @override
  String get fileDetailsLabelName => 'नाम';

  @override
  String get fileDetailsLabelType => 'प्रकार';

  @override
  String get fileDetailsLabelSize => 'आकार';

  @override
  String get fileDetailsLabelModified => 'संशोधित';

  @override
  String get fileDetailsLabelBookmarked => 'बुकमार्क किया गया';

  @override
  String get fileDetailsValueYes => 'हाँ';

  @override
  String get fileDetailsValueNo => 'नहीं';

  @override
  String get fileDetailsLabelLocation => 'स्थान';

  @override
  String get fileDetailsPathCopied => 'पाथ क्लिपबोर्ड पर कॉपी हो गया';

  @override
  String get directoriesTitle => 'डायरेक्टरी';

  @override
  String get directoriesGoBack => 'वापस जाएं';

  @override
  String get directoriesGoToRoot => 'रूट पर जाएं';

  @override
  String get directoriesRetry => 'पुनः प्रयास करें';

  @override
  String get directoriesFileNoLongerExists => 'फ़ाइल अब मौजूद नहीं है';

  @override
  String get directoriesFolderNoLongerExists => 'यह फ़ोल्डर अब मौजूद नहीं है।';

  @override
  String get directoriesNoDocsInFolder =>
      'इस फ़ोल्डर में कोई दस्तावेज़ नहीं है';

  @override
  String get directoriesFilesAppearHere =>
      'जोड़े जाने पर फ़ाइलें यहाँ दिखाई देंगी';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '1 आइटम',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => 'फ़ोल्डर';

  @override
  String get directoriesPermissionPromptTitle =>
      'डायरेक्टरी देखने के लिए अनुमति आवश्यक है';

  @override
  String get directoriesPermissionPromptBody =>
      'आपके फ़ोल्डर ब्राउज़ करने के लिए Doc View को सभी फ़ाइलों की अनुमति चाहिए।';

  @override
  String get directoriesGrantAccess => 'अनुमति दें';

  @override
  String get directoriesImportInstead => 'इसके बजाय फ़ाइलें इम्पोर्ट करें';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें इम्पोर्ट की गईं',
      one: '1 फ़ाइल इम्पोर्ट की गई',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => 'एक स्तर ऊपर';

  @override
  String get storageAccessRequiredTitle => 'स्टोरेज अनुमति आवश्यक है';

  @override
  String get storageAccessRequiredBody =>
      'आपके डिवाइस पर सेव किए गए दस्तावेज़ों (PDF, Word, Excel, PPT, TXT, इमेज) को स्कैन करने और दिखाने के लिए Doc View को स्टोरेज अनुमति चाहिए।\n\nआपकी फ़ाइलें आपके डिवाइस पर पूरी तरह निजी और ऑफ़लाइन रहती हैं।';

  @override
  String errorCouldNotOpenDocument(String error) {
    return 'दस्तावेज़ नहीं खुल सका: $error';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'स्कैन पूरा हुआ: $count फ़ाइलें',
      one: 'स्कैन पूरा हुआ: 1 फ़ाइल',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => 'खोज इतिहास साफ़ करें?';

  @override
  String get dialogClearSearchMessage =>
      'सभी हालिया खोजें स्थायी रूप से साफ़ हो जाएंगी।';

  @override
  String imageListEditorMaxLimit(int max) {
    return 'अधिकतम $max इमेज की सीमा पूरी हो गई है।';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return 'स्कैनिंग विफल रही: $error';
  }

  @override
  String get imageListEditorPageSize => 'पेज का आकार:';

  @override
  String get imageListEditorA4Mode => 'A4';

  @override
  String get imageListEditorFitMode => 'इमेज के अनुसार फ़िट करें';

  @override
  String get imageListEditorRemoveImageTooltip => 'इमेज हटाएं';

  @override
  String get mergeScreenTitle => 'व्यवस्थित और मर्ज करें';

  @override
  String get mergeScreenDefaultMergedName => 'मर्ज_दस्तावेज़';

  @override
  String get mergePickerSearchHint => 'PDF खोजें...';

  @override
  String get mergePickerNext => 'आगे';

  @override
  String mergePickerErrorLoading(String error) {
    return 'PDF लोड करने में त्रुटि: $error';
  }

  @override
  String get splitScreenTitle => 'PDF स्प्लिट करें';

  @override
  String get splitScreenRangeHint => 'जैसे 1-3, 5, 8-10';

  @override
  String get splitScreenClearRange => 'रेंज साफ़ करें';

  @override
  String get splitPickerSearchHint => 'PDF खोजें...';

  @override
  String splitPickerErrorLoading(String error) {
    return 'फ़ाइलें लोड करने में त्रुटि: $error';
  }

  @override
  String get createdSectionTitle => 'आपके द्वारा बनाए गए';

  @override
  String get createdSectionEmptyTitle =>
      'आपके द्वारा बनाई गई PDF यहाँ दिखती हैं';

  @override
  String get createdSectionEmptySubtitle =>
      'बदले गए, स्कैन किए गए या मर्ज किए गए दस्तावेज़ डिवाइस में सेव होंगे।';

  @override
  String get emptyCreatedDocsTitle => 'अभी तक कोई दस्तावेज़ नहीं बनाया गया';

  @override
  String get emptyCreatedDocsMessage =>
      'बदले गए, स्कैन किए गए या मर्ज किए गए दस्तावेज़ यहाँ दिखाई देंगे।';

  @override
  String errorLoadingCreatedFiles(String error) {
    return 'बनाई गई फ़ाइलें लोड करने में विफल: $error';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDF बनाई गईं',
      one: 'PDF बनाई गई',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle => 'आपके बनाए गए फ़ोल्डर में सेव किया गया';

  @override
  String get toolErrorDefaultTitle => 'PDF नहीं बन सकी';

  @override
  String get toolErrorSubtitle => 'प्रोसेसिंग के दौरान एक अनपेक्षित त्रुटि हुई';

  @override
  String get themeSheetTitle => 'ऐप थीम';

  @override
  String get themeSheetSubtitle => 'Doc View के लिए विज़ुअल रूप चुनें';

  @override
  String get themeModeSystem => 'सिस्टम';

  @override
  String get themeModeSystemSubtitle => 'डिफ़ॉल्ट';

  @override
  String get themeModeLight => 'लाइट';

  @override
  String get themeModeLightSubtitle => 'साफ़ सफ़ेद';

  @override
  String get themeModeDark => 'डार्क';

  @override
  String get themeModeDarkSubtitle => 'गहरा नेवी';

  @override
  String get themeActionApply => 'थीम लागू करें';

  @override
  String get scanSettingsTitle => 'स्कैन सेटिंग्स';

  @override
  String get scanSettingsFrequencyHeader => 'स्कैन आवृत्ति';

  @override
  String get scanSettingsOnOpenTitle => 'ऐप खुलने पर स्कैन करें';

  @override
  String get scanSettingsOnOpenSubtitle =>
      'Doc View खोलने पर नई फ़ाइलें अपने-आप ढूंढें।';

  @override
  String get scanSettingsManualTitle => 'केवल मैन्युअल';

  @override
  String get scanSettingsManualSubtitle =>
      'केवल तभी स्कैन करें जब आप रीफ़्रेश करने के लिए खींचें या फिर से स्कैन पर टैप करें।';

  @override
  String get scanSettingsMediaFiltersHeader => 'मीडिया फ़िल्टर';

  @override
  String get scanSettingsIncludeImagesTitle => 'स्कैन में इमेज शामिल करें';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      'स्टोरेज में PNG, JPG और WEBP इमेज फ़ाइलों को इंडेक्स करें।';

  @override
  String get scanSettingsDiagnosticsHeader => 'स्टोरेज और डायग्नोस्टिक्स';

  @override
  String get scanSettingsPermissionStatus => 'सभी फ़ाइलों की अनुमति';

  @override
  String get scanSettingsPermissionGranted => 'दी गई';

  @override
  String get scanSettingsPermissionNotGranted => 'नहीं दी गई';

  @override
  String get scanSettingsTotalIndexed => 'इंडेक्स की गई फ़ाइलें';

  @override
  String get scanSettingsLastScan => 'अंतिम स्कैन';

  @override
  String get scanSettingsUpdatedSnackbar => 'स्कैन सेटिंग्स अपडेट की गईं';

  @override
  String get faqScreenTitle => 'अक्सर पूछे जाने वाले प्रश्न';

  @override
  String faqHeaderTopics(int count) {
    return '$count विषय';
  }

  @override
  String get faqHeaderSubtitle => 'कोई सवाल है? यहाँ स्पष्ट उत्तर पाएं।';

  @override
  String get faqSendFeedback => 'फ़ीडबैक भेजें';

  @override
  String get faqQuestion1 => 'Doc View को सभी फ़ाइलों की अनुमति क्यों चाहिए?';

  @override
  String get faqAnswer1 =>
      'Downloads और Documents जैसे साझा फ़ोल्डरों में सेव किए गए समर्थित दस्तावेज़ों (PDF, Word, Excel, PowerPoint, टेक्स्ट और इमेज) को खोजने और इंडेक्स करने के लिए Android 11+ पर Doc View को सभी फ़ाइलों की अनुमति (MANAGE_EXTERNAL_STORAGE) चाहिए।\n\nइस अनुमति के बिना, Android फ़ाइल एक्सेस को ऐप के निजी आंतरिक फ़ोल्डर तक सीमित कर देता है, जिससे Doc View आपके डिवाइस पर मौजूद फ़ाइलों को ब्राउज़ या खोल नहीं पाता।';

  @override
  String get faqQuestion2 => 'यह मेरे पूरे iPhone को स्कैन क्यों नहीं करता?';

  @override
  String get faqAnswer2 =>
      'डिवाइस की गोपनीयता सुरक्षित रखने के लिए iOS सख्त ऐप सैंडबॉक्सिंग का उपयोग करता है। ऐप्स केवल उन्हीं दस्तावेज़ों तक पहुंच सकते हैं जिन्हें स्पष्ट रूप से Files ऐप में सेव किया गया हो या सिस्टम शेयर शीट के माध्यम से शेयर किया गया हो।\n\niOS पर फ़ाइलें देखने के लिए, उन्हें मूल Files ऐप के Doc View फ़ोल्डर में इम्पोर्ट करें या सेटिंग्स में फ़ाइलें इम्पोर्ट करें विकल्प का उपयोग करें।';

  @override
  String get faqQuestion3 => 'मेरे द्वारा बनाई गई PDF कहाँ सेव होती हैं?';

  @override
  String get faqAnswer3 =>
      'आपके द्वारा इम्पोर्ट या जेनरेट की गई फ़ाइलें (जैसे बदली गई PDF, मर्ज किए गए दस्तावेज़ या स्प्लिट किए गए पेज) आपके डिवाइस स्टोरेज में DocView/Created या निजी ऐप स्टोरेज में सुरक्षित रूप से सेव होती हैं। आप इन्हें कभी भी टूल्स टैब के \'आपके द्वारा बनाए गए\' सेक्शन में देख सकते हैं।';

  @override
  String get faqQuestion4 => 'मेरी Word फ़ाइल अलग क्यों दिखती है?';

  @override
  String get faqAnswer4 =>
      'Doc View निजी डेटा को क्लाउड कन्वर्टर्स पर भेजे बिना, स्थानीय ऑफ़लाइन पार्सर का उपयोग करके सीधे आपके डिवाइस पर फ़ाइलों को रेंडर करता है। जटिल फ़ॉर्मैटिंग या कस्टम आकृतियाँ ऑफ़लाइन अनुमान के अनुसार दिखाई देती हैं।';

  @override
  String get faqQuestion5 => 'क्या मैं पासवर्ड-सुरक्षित फ़ाइलें खोल सकता हूँ?';

  @override
  String get faqAnswer5 =>
      'हाँ, Doc View पासवर्ड-सुरक्षित PDF दस्तावेज़ खोलने का समर्थन करता है। एन्क्रिप्टेड PDF खोलते समय, अपने डिवाइस पर दस्तावेज़ को डिक्रिप्ट करने और देखने के लिए डायलॉग में पासवर्ड दर्ज करें।';

  @override
  String get faqQuestion6 => 'क्या मेरा डेटा कहीं अपलोड होता है?';

  @override
  String get faqAnswer6 =>
      'आपके दस्तावेज़ कभी भी आपके डिवाइस से बाहर नहीं जाते। Doc View फ़ाइलों को स्थानीय रूप से खोलता, बदलता और स्टोर करता है। ऐप Google AdMob द्वारा दिए जाने वाले विज्ञापन दिखाता है, जो हमारी गोपनीयता नीति में बताए अनुसार सीमित डिवाइस डेटा का उपयोग कर सकते हैं।';

  @override
  String get faqQuestion7 =>
      'PDF से Word में बदलने पर मेरा लेआउट क्यों बदल गया?';

  @override
  String get faqAnswer7 =>
      'Doc View आपके डिवाइस पर केवल टेक्स्ट को बदलता है। टेबल, इमेज, रंग और लेआउट सुरक्षित नहीं रखे जाते। स्कैन की गई PDF को बदला नहीं जा सकता क्योंकि उनमें पढ़ने के लिए कोई टेक्स्ट नहीं होता।';

  @override
  String get toolPdfToWord => 'PDF से Word';

  @override
  String get toolPdfToWordSub => 'PDF को संपादन योग्य Word दस्तावेज़ में बदलें';

  @override
  String get pdfToWordScreenTitle => 'PDF से Word';

  @override
  String get pdfToWordBannerText =>
      'केवल टेक्स्ट बदला जाता है। टेबल, इमेज, रंग और लेआउट सुरक्षित नहीं रखे जाते।';

  @override
  String get pdfToWordPageBreaks => 'PDF पेजों के बीच पेज ब्रेक डालें';

  @override
  String get pdfToWordPageBreaksSubtitle =>
      'पेजों में दस्तावेज़ की संरचना बनाए रखता है';

  @override
  String get pdfToWordSelectPdf => 'PDF चुनें';

  @override
  String get pdfToWordChangeFile => 'फ़ाइल बदलें';

  @override
  String get pdfToWordConvertAction => 'Word में बदलें';

  @override
  String get pdfToWordConverting => 'Word में बदला जा रहा है...';

  @override
  String pdfToWordConvertingProgress(int current, int total) {
    return '$total में से पेज $current बदला जा रहा है...';
  }

  @override
  String get pdfToWordSuccess => 'Word में सफलतापूर्वक बदला गया';

  @override
  String get pdfToWordOpenInViewer => 'Doc View में खोलें';

  @override
  String get pdfToWordOpenWith => 'इसके साथ खोलें...';

  @override
  String get pdfToWordShare => 'शेयर करें';

  @override
  String get pdfToWordNoTextTitle => 'कोई टेक्स्ट नहीं मिला';

  @override
  String get pdfToWordNoTextMessage =>
      'इस PDF में कोई टेक्स्ट नहीं मिला। स्कैन किए गए दस्तावेज़ों को बदला नहीं जा सकता।';

  @override
  String get pdfToWordLargeFileWarning =>
      'बड़ा दस्तावेज़: बदलने में कई मिनट लग सकते हैं।';

  @override
  String get pdfToWordInvalidFileName => 'अमान्य फ़ाइल नाम';

  @override
  String get pdfToWordActionCancel => 'रद्द करें';

  @override
  String get pdfToWordEncryptedError =>
      'चुनी गई PDF पासवर्ड-सुरक्षित है। बदलने के लिए कृपया इसे अनलॉक करें।';

  @override
  String get pdfToWordPageLimitError =>
      'दस्तावेज़ 1,000 पेजों की सीमा से अधिक है।';

  @override
  String get pdfToWordTextLimitError =>
      'दस्तावेज़ 20 MB टेक्स्ट सीमा से अधिक है।';

  @override
  String get pdfToWordGeneralError =>
      'PDF को Word में बदलने में विफल। कृपया कोई दूसरी फ़ाइल आज़माएं।';

  @override
  String get pdfGotoPageTitle => 'पेज पर जाएं';

  @override
  String pdfGotoPageHint(int pageCount) {
    return '1 से $pageCount के बीच एक पेज दर्ज करें';
  }

  @override
  String get pdfGotoPageAction => 'जाएं';

  @override
  String get pdfGotoPageErrorEmpty => 'पेज नंबर दर्ज करें';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return '1 से $pageCount के बीच एक पेज दर्ज करें';
  }

  @override
  String get pdfPasswordTitle => 'यह PDF पासवर्ड-सुरक्षित है';

  @override
  String get pdfPasswordSubtitle =>
      'सामग्री देखने और डिक्रिप्ट करने के लिए पासवर्ड दर्ज करें।';

  @override
  String get pdfPasswordHint => 'पासवर्ड दर्ज करें';

  @override
  String get pdfPasswordErrorIncorrect => 'गलत पासवर्ड। फिर से प्रयास करें।';

  @override
  String get pdfPasswordActionUnlock => 'अनलॉक करें';

  @override
  String get errorFileNameEmpty => 'फ़ाइल का नाम खाली नहीं हो सकता';

  @override
  String get errorFileNameTooLong =>
      'फ़ाइल का नाम 120 अक्षरों से अधिक नहीं हो सकता';

  @override
  String get errorFileNameReserved =>
      'फ़ाइल का नाम \'.\' या \'..\' नहीं हो सकता';

  @override
  String get errorFileNameStartsWithDot =>
      'फ़ाइल का नाम बिंदु (.) से शुरू नहीं हो सकता';

  @override
  String get errorFileNameInvalidChars => 'फ़ाइल के नाम में अमान्य अक्षर हैं';

  @override
  String get errorRenameAlreadyExists =>
      'इस फ़ोल्डर में इस नाम की फ़ाइल पहले से मौजूद है';

  @override
  String get errorRenameSourceNotFound => 'मूल फ़ाइल अब डिस्क पर मौजूद नहीं है';

  @override
  String errorRenameFailed(String details) {
    return 'फ़ाइल का नाम बदलने में विफल: $details';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      'फ़ाइलें डिस्क से हट गईं लेकिन डेटाबेस अपडेट विफल रहा';

  @override
  String errorDeleteFailed(String details) {
    return 'फ़ाइलें हटाने में विफल: $details';
  }

  @override
  String get errorPageRangeDocNoPages => 'दस्तावेज़ में कोई पेज नहीं है';

  @override
  String get errorPageRangeEmpty => 'पेज रेंज खाली नहीं हो सकती';

  @override
  String get errorPageRangeEmptySegment =>
      'खाली रेंज खंड मिला। अतिरिक्त अल्पविराम हटाएं।';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return 'अमान्य रेंज फ़ॉर्मैट: \'$token\'';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return 'अधूरी रेंज: \'$token\'';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return 'रेंज में गैर-संख्यात्मक मान: \'$token\'';
  }

  @override
  String get errorPageRangeBelowMinimum => 'पेज नंबर 1 या उससे अधिक होने चाहिए';

  @override
  String errorPageRangeReversed(int start, int end) {
    return 'उलटी रेंज \'$start-$end\': शुरुआती संख्या अंतिम से बड़ी है';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return 'रेंज \'$token\' कुल पेजों ($totalPages) से अधिक है';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return 'अमान्य पेज नंबर: \'$token\'';
  }

  @override
  String get errorImageToPdfNoImages => 'कृपया कम से कम एक इमेज चुनें';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return 'एक बार में अधिकतम $max इमेज की अनुमति है';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return 'इमेज प्रोसेस करने में विफल: $path';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return 'इमेज से PDF बनाने में विफल: $details';
  }

  @override
  String get errorPdfMergeInsufficient =>
      'मर्ज करने के लिए कृपया कम से कम 2 PDF फ़ाइलें चुनें';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return '$fileName पासवर्ड-सुरक्षित या क्षतिग्रस्त है';
  }

  @override
  String get errorPdfMergeNoPages => 'चयनित दस्तावेज़ों में कोई पेज नहीं है';

  @override
  String errorPdfMergeFailed(String details) {
    return 'PDF मर्ज करना विफल रहा: $details';
  }

  @override
  String get errorPdfSplitNoRanges =>
      'कृपया कम से कम एक पेज रेंज निर्दिष्ट करें';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return '$fileName पासवर्ड-सुरक्षित या क्षतिग्रस्त है';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return '$fileName के लिए रेंज $start-$end सीमा से बाहर है';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return 'PDF स्प्लिट करने में विफल: $details';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return 'पेज $current/$total';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '($bytes बाइट्स)';
  }

  @override
  String get directoriesProtectedTitle =>
      'यह फ़ोल्डर Android द्वारा सुरक्षित है।';

  @override
  String get directoriesProtectedDesc =>
      'Android सिस्टम और ऐप के निजी फ़ोल्डरों तक पहुंच को प्रतिबंधित करता है।';

  @override
  String get directoriesNotFoundTitle => 'यह फ़ोल्डर अब मौजूद नहीं है।';

  @override
  String get directoriesEmpty =>
      'यहाँ कोई समर्थित फ़ाइलें या फ़ोल्डर नहीं हैं।';

  @override
  String get directoriesErrorOpening => 'फ़ोल्डर खोलने में त्रुटि';

  @override
  String get directoriesRoot => 'रूट';

  @override
  String get scanSettingsSectionFrequency => 'स्कैन आवृत्ति';

  @override
  String get scanSettingsSectionFilters => 'दस्तावेज़ फ़िल्टर';

  @override
  String get scanSettingsIncludeImages => 'इमेज शामिल करें';

  @override
  String get scanSettingsIncludeImagesDesc =>
      'अपनी दस्तावेज़ सूची से हज़ारों फ़ोटो छिपाने के लिए इसे बंद करें';

  @override
  String get scanSettingsImageListUpdated => 'इमेज सूची अपडेट की गई';

  @override
  String get scanSettingsActionRescanNow => 'अभी फिर से स्कैन करें';

  @override
  String get scanSettingsSectionDiagnostics => 'स्टोरेज डायग्नोस्टिक्स';

  @override
  String get scanSettingsAllFilesAccessGranted => 'सभी फ़ाइलों की अनुमति दी गई';

  @override
  String get scanSettingsAllFilesAccessNeeded =>
      'सभी फ़ाइलों की अनुमति आवश्यक है';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      'Doc View के पास Downloads और SD कार्ड में फ़ाइलें ढूंढने की अनुमति है।';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      'डाउनलोड और बाहरी स्टोरेज फ़ोल्डरों को स्कैन करने के लिए अनुमति आवश्यक है।';

  @override
  String get scanSettingsActionOpenSettings => 'सेटिंग्स खोलें';

  @override
  String scanSettingsScanningFiles(int count) {
    return 'स्कैन हो रहा है... $count फ़ाइलें मिलीं';
  }

  @override
  String get faqStillNeedHelp => 'क्या आपको अभी भी मदद चाहिए? फ़ीडबैक भेजें';

  @override
  String get toolsLabelFileName => 'फ़ाइल का नाम';

  @override
  String get toolsAddImagesToStart => 'शुरू करने के लिए इमेज जोड़ें';

  @override
  String get toolsAddImagesDesc =>
      'PDF बनाने के लिए फ़ोटो चुनें या कागज़ी दस्तावेज़ स्कैन करें।';

  @override
  String get toolsChoosePhotos => 'फ़ोटो चुनें';

  @override
  String get toolsScanPaper => 'कागज़ स्कैन करें';

  @override
  String toolsPageNumber(int page) {
    return 'पेज $page';
  }

  @override
  String get toolsTooltipRotatePage => 'पेज घुमाएं';

  @override
  String get toolsTooltipRemovePage => 'पेज हटाएं';

  @override
  String get toolsAddMoreScans => 'और स्कैन जोड़ें';

  @override
  String get toolsAddMoreImages => 'और इमेज जोड़ें';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count इमेज · अनुमानित ~ $size',
      one: '1 इमेज · अनुमानित ~ $size',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return '$count चयनित';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return 'कम से कम $min फ़ाइलें चुनें';
  }

  @override
  String toolsPagesTotal(int count) {
    return 'कुल $count पेज';
  }

  @override
  String get toolsPagesTotalLabel => 'कुल पेज';

  @override
  String get toolsNoPdfsFound => 'कोई PDF दस्तावेज़ नहीं मिला';

  @override
  String get semanticBookmarked => 'बुकमार्क किया गया';

  @override
  String get semanticSelected => 'चयनित';

  @override
  String get semanticNotSelected => 'चयनित नहीं';

  @override
  String get actionDeselectFile => 'फ़ाइल अचयनित करें';

  @override
  String get actionSelectFile => 'फ़ाइल चुनें';

  @override
  String get actionCreatePdf => 'PDF बनाएं';

  @override
  String get hintSelectOrViewActions => 'चुनें या क्रियाएं देखें';

  @override
  String get actionClose => 'बंद करें';

  @override
  String get actionReset => 'रीसेट करें';

  @override
  String get labelPleaseWait => 'कृपया प्रतीक्षा करें...';

  @override
  String get tooltipCloseSearch => 'खोज बंद करें';

  @override
  String get semanticAdvertisement => 'विज्ञापन';

  @override
  String get themePreviewLight => 'लाइट';

  @override
  String get themePreviewNavy => 'नेवी';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '$name, $size, $date को बनाया गया';
  }

  @override
  String get toolsCreatingPdfFromScans => 'स्कैन से PDF बनाई जा रही है';

  @override
  String get toolsCreatingPdf => 'PDF बनाई जा रही है';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return '$total में से इमेज $done प्रोसेस हो रही है...';
  }

  @override
  String get toolsErrorCreatePdfTitle => 'PDF नहीं बन सकी';

  @override
  String get toolsBadgeProtectedOrDamaged => 'सुरक्षित या क्षतिग्रस्त';

  @override
  String toolsPageCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पेज',
      one: '1 पेज',
    );
    return '$_temp0';
  }

  @override
  String get toolsPagesAbbrev => 'पेज';

  @override
  String get mergeAddMoreTitle => 'और PDF जोड़ें';

  @override
  String get mergeProgressTitle => 'PDF मर्ज की जा रही हैं';

  @override
  String mergeProgressMessage(int done, int total) {
    return '$total में से दस्तावेज़ $done मर्ज हो रहा है...';
  }

  @override
  String get mergeErrorTitle => 'PDF मर्ज नहीं हो सकीं';

  @override
  String get mergeDragInstruction => 'क्रम बदलने के लिए हैंडल खींचें';

  @override
  String get mergeAddPdf => 'PDF जोड़ें';

  @override
  String get mergeOutputFileNameLabel => 'आउटपुट फ़ाइल का नाम';

  @override
  String mergeItemPageCountAndSize(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पेज · $size',
      one: '1 पेज · $size',
    );
    return '$_temp0';
  }

  @override
  String mergeItemLoadingPagesAndSize(String size) {
    return 'पेज लोड हो रहे हैं... · $size';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अमान्य फ़ाइलें मिलीं',
      one: '1 अमान्य फ़ाइल मिली',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => 'मर्ज करने के लिए तैयार';

  @override
  String get mergeRemoveProtectedHint =>
      'कृपया पासवर्ड-सुरक्षित दस्तावेज़ हटाएं';

  @override
  String mergeSummary(int files, int pages, String size) {
    return '$files फ़ाइलें · $pages पेज · ~ $size';
  }

  @override
  String get mergeReadyBadge => 'तैयार';

  @override
  String get mergeBlockedCta => 'मर्ज अवरुद्ध (त्रुटियां हल करें)';

  @override
  String mergeActionCta(int files, int pages) {
    return '$files PDF मर्ज करें ($pages पेज)';
  }

  @override
  String get mergePickerDefaultTitle => 'PDF चुनें';

  @override
  String mergePickerTabAllPdfs(int count) {
    return 'सभी PDF ($count)';
  }

  @override
  String get mergePickerTabRecent => 'हालिया';

  @override
  String get mergePickerTabDownloads => 'डाउनलोड';

  @override
  String get mergePickerTabICloud => 'iCloud Drive';

  @override
  String get splitProgressTitle => 'PDF स्प्लिट की जा रही है';

  @override
  String splitProgressMessage(int done, int total) {
    return '$total में से फ़ाइल $done बनाई जा रही है...';
  }

  @override
  String get splitErrorTitle => 'PDF स्प्लिट नहीं हो सकी';

  @override
  String get splitPageRangesLabel => 'पेज रेंज';

  @override
  String get splitPageRangesSyntax => 'सिंटैक्स: 1-3, 5, 8-10';

  @override
  String get splitRangeHelpText => 'प्रत्येक रेंज एक अलग PDF फ़ाइल बन जाती है।';

  @override
  String splitGeneratedFilesHeader(int count) {
    return 'बनाई गई फ़ाइलें ($count)';
  }

  @override
  String get splitChipsSuspendedTitle => 'लाइव चिप्स निलंबित';

  @override
  String get splitChipsSuspendedDesc =>
      'निकालने की प्रक्रिया फिर से बनाने के लिए ऊपर दी गई सिंटैक्स त्रुटि को ठीक करें।';

  @override
  String get splitEmptyRangesHint =>
      'PDF भाग बनाने के लिए ऊपर पेज रेंज दर्ज करें';

  @override
  String splitChipSinglePage(int page) {
    return 'पेज $page';
  }

  @override
  String splitChipPageRange(int start, int end) {
    return 'पेज $start–$end';
  }

  @override
  String splitChipPageCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पेज',
      one: '1 पेज',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => 'त्वरित चयन';

  @override
  String get splitMacroAllPages => 'सभी पेज';

  @override
  String get splitMacroEvery5Pages => 'हर 5 पेज';

  @override
  String get splitMacroLimitHint =>
      'डिवाइस मेमोरी सुरक्षित रखने के लिए 100 से अधिक फ़ाइलें बनाने वाले मैक्रो अक्षम हैं';

  @override
  String splitOutputSummary(int files, int pages) {
    return 'आउटपुट: $files फ़ाइलें · $pages पेज निकाले गए';
  }

  @override
  String splitEstSize(String size) {
    return 'अनुमानित ~ $size';
  }

  @override
  String splitActionCtaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDF में स्प्लिट करें',
      one: '1 PDF में स्प्लिट करें',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => 'PDF में स्प्लिट करें';

  @override
  String splitPickerAllLocalDocs(int count) {
    return 'सभी स्थानीय दस्तावेज़ ($count)';
  }

  @override
  String get splitPickerSortByDate => 'तिथि के अनुसार क्रमबद्ध करें';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return 'पेज · $size';
  }

  @override
  String get splitPickerTitle => 'स्प्लिट करने के लिए PDF चुनें';

  @override
  String get faqShortTitle => 'FAQ';

  @override
  String splitPickerSelectedCount(int count) {
    return '$count PDF चयनित';
  }

  @override
  String get splitPickerSelectDocumentHint =>
      'जारी रखने के लिए एक दस्तावेज़ चुनें';

  @override
  String splitPickerPagesActive(int count) {
    return '$count पेज सक्रिय';
  }

  @override
  String get splitPickerPagesActiveLabel => 'सक्रिय पेज';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsSectionGeneral => 'सामान्य';

  @override
  String get settingsSectionOthers => 'अन्य';

  @override
  String get settingsFileManagerTitle => 'फ़ाइल प्रबंधक';

  @override
  String get settingsFileManagerSubtitle =>
      'स्टोरेज डायरेक्टरी और फ़ोल्डर ब्राउज़ करें';

  @override
  String get settingsFaqTitle => 'सामान्य प्रश्न';

  @override
  String get settingsFaqSubtitle => 'अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get settingsShareTitle => 'शेयर करें';

  @override
  String get settingsShareSubtitle => 'दोस्तों को Doc View का सुझाव दें';

  @override
  String settingsShareMessage(String url) {
    return 'Doc View आज़माएं - तेज़, निजी, ऑफ़लाइन दस्तावेज़ रीडर: $url';
  }

  @override
  String get settingsScanSettingsTitle => 'स्कैन सेटिंग्स';

  @override
  String get settingsScanModeOnOpen => 'खुलने पर स्कैन करें';

  @override
  String get settingsScanModeManual => 'केवल मैन्युअल';

  @override
  String get settingsAppThemeTitle => 'ऐप थीम';

  @override
  String get settingsThemeSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get settingsThemeLight => 'लाइट';

  @override
  String get settingsThemeDark => 'डार्क';

  @override
  String get settingsLanguageTitle => 'भाषा';

  @override
  String get settingsRateUsTitle => 'हमें रेट करें';

  @override
  String get settingsRateUsSubtitle => 'हमें अपना फ़ीडबैक दें';

  @override
  String get settingsAddWidgetTitle => 'विजेट जोड़ें';

  @override
  String get settingsAddWidgetSubtitle => 'अपनी होम स्क्रीन से त्वरित पहुंच';

  @override
  String get settingsTermsTitle => 'उपयोग की शर्तें';

  @override
  String get settingsTermsSubtitle => 'हमारी सेवा की शर्तें पढ़ें';

  @override
  String get settingsPrivacyTitle => 'गोपनीयता नीति';

  @override
  String get settingsPrivacySubtitle => 'हमारी गोपनीयता नीति पढ़ें';

  @override
  String get settingsManageSubscriptionsTitle => 'सदस्यताएं प्रबंधित करें';

  @override
  String get settingsManageSubscriptionsSubtitle =>
      'अपनी स्टोर सदस्यता प्रबंधित करें';

  @override
  String settingsVersionDisplay(String version, String build) {
    return 'संस्करण $version ($build)';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return 'संस्करण $version बिल्ड $build';
  }

  @override
  String get settingsOpenSourceLicenses => 'ओपन-सोर्स लाइसेंस';

  @override
  String get rateSheetTitle => 'Doc View को रेट करें';

  @override
  String get rateSheetSubtitle =>
      'आपका फ़ीडबैक हमें बेहतर बनने में मदद करता है';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्टार',
      one: '1 स्टार',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => 'खुशी है कि आपको यह पसंद आया!';

  @override
  String get rateResponseMedium =>
      'धन्यवाद! हमें बताएं कि हम इसे और बेहतर कैसे बना सकते हैं।';

  @override
  String get rateResponseLow =>
      'असुविधा के लिए खेद है। हमें बताएं कि क्या ठीक करना है।';

  @override
  String get rateActionStore => 'Google Play पर रेट करें';

  @override
  String get rateActionHelpFeedback => 'मदद और फ़ीडबैक';

  @override
  String get faqFromRatingBanner =>
      'यह सुनकर दुख हुआ। नीचे दिए गए उत्तर देखें या हमसे संपर्क करें; हम हर संदेश पढ़ते हैं।';

  @override
  String get faqActionContactUs => 'हमसे संपर्क करें';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return 'Doc View फ़ीडबैक ($version+$build)';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '\n\n---\nऐप: Doc View $version (बिल्ड $build)\n';
  }

  @override
  String get faqEmailClientUnavailable => 'ईमेल क्लाइंट नहीं खुल सका';

  @override
  String get languageScreenTitle => 'भाषा';

  @override
  String get languageSearchHint => 'भाषाएं खोजें...';

  @override
  String get languageSystemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get languageSystemDefaultSubtitle => 'डिवाइस की भाषा का पालन करें';

  @override
  String get languageNotTranslatedBadge => '(अनुवादित नहीं)';

  @override
  String get languageNotTranslatedSnack => 'इस भाषा का अनुवाद अभी नहीं हुआ है';

  @override
  String get languageNoResults => 'कोई मिलती-जुलती भाषा नहीं मिली';

  @override
  String get languagePseudoLocaleName => 'स्यूडो-लोकेल (en_XA)';

  @override
  String get languagePseudoLocaleSubtitle => 'डीबग विस्तार परीक्षण';

  @override
  String get scanSettingsSectionHistory => 'इतिहास';

  @override
  String get scanSettingsClearHistoryTitle => 'हालिया इतिहास साफ़ करें';

  @override
  String get scanSettingsClearHistorySubtitle =>
      'खोले गए दस्तावेज़ों का इतिहास साफ़ करें';

  @override
  String get scanSettingsClearHistoryDialogTitle => 'हालिया इतिहास साफ़ करें?';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      'फ़ाइलें हालिया सूची से हटा दी जाएंगी। आपकी फ़ाइलों और बुकमार्क पर कोई असर नहीं पड़ेगा।';

  @override
  String get scanSettingsRecentHistoryCleared => 'हालिया इतिहास साफ़ किया गया';

  @override
  String get scanSettingsLastScanToday => 'आज';

  @override
  String get scanSettingsLastScanYesterday => 'कल';

  @override
  String get scanSettingsNeverScanned => 'कभी स्कैन नहीं किया गया';

  @override
  String get scanSettingsLastScanPrefix => 'अंतिम स्कैन:';

  @override
  String get readerActionVertical => 'लंबवत';

  @override
  String get readerActionHorizontal => 'क्षैतिज';

  @override
  String get readerActionRotate => 'घुमाएं';

  @override
  String get readerActionSearch => 'खोजें';

  @override
  String get readerActionInvert => 'रंग उलटें';

  @override
  String get readerActionShare => 'शेयर करें';

  @override
  String get readerActionPages => 'पेज';

  @override
  String get readerSearchHint => 'दस्तावेज़ में खोजें...';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '$total में से $current';
  }

  @override
  String get readerSearchMatchCap => '500+';

  @override
  String get readerSearchNoMatches => '0 में से 0';

  @override
  String get readerSearchNoTextLayer =>
      'इस PDF में खोजने योग्य टेक्स्ट नहीं है';

  @override
  String get readerSearchPrevMatch => 'पिछला परिणाम';

  @override
  String get readerSearchNextMatch => 'अगला परिणाम';

  @override
  String readerTopPagesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पेज • $size',
      one: '1 पेज • $size',
    );
    return '$_temp0';
  }

  @override
  String get readerMenuGoToPage => 'पेज पर जाएं';

  @override
  String get readerMenuAddBookmark => 'बुकमार्क जोड़ें';

  @override
  String get readerMenuRemoveBookmark => 'बुकमार्क हटाएं';

  @override
  String get readerMenuDetails => 'विवरण';

  @override
  String get readerMenuOpenInAnotherApp => 'दूसरे ऐप में खोलें';

  @override
  String get readerTooltipConvertToWord => 'Word में बदलें';

  @override
  String get pagesScreenTitle => 'पेज';

  @override
  String pagesScreenPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पेज',
      one: '1 पेज',
    );
    return '$_temp0';
  }

  @override
  String get pagesActionSelectAll => 'सभी चुनें';

  @override
  String get pagesActionClearSelection => 'साफ़ करें';

  @override
  String get pagesActionSave => 'सेव करें';

  @override
  String get pagesActionInsert => 'जोड़ें';

  @override
  String get pagesActionRotate => 'घुमाएं';

  @override
  String get pagesActionExtract => 'निकालें';

  @override
  String get pagesActionDelete => 'हटाएं';

  @override
  String get pagesActionUndo => 'पूर्ववत करें';

  @override
  String get pagesInsertSheetTitle => 'पेज जोड़ें';

  @override
  String get pagesInsertPagesFromPdf => 'किसी अन्य PDF से पेज';

  @override
  String get pagesDeleteAllBlocked =>
      'सभी पेज नहीं हटाए जा सकते। किसी दस्तावेज़ में कम से कम एक पेज होना आवश्यक है।';

  @override
  String get pagesSaveDialogTitle => 'बदलाव सेव करें';

  @override
  String get pagesSaveAsNew => 'नई फ़ाइल के रूप में सेव करें';

  @override
  String get pagesSaveReplace => 'मूल फ़ाइल बदलें';

  @override
  String get pagesSaveReplaceWarning => 'यह मूल फ़ाइल को ओवरराइट कर देगा।';

  @override
  String get pagesSaveFileNameLabel => 'फ़ाइल का नाम';

  @override
  String get pagesDiscardDialogTitle => 'बदलाव हटाएं?';

  @override
  String get pagesDiscardDialogBody =>
      'आपके पास बिना सेव किए गए बदलाव हैं। क्या आप वाकई इन्हें हटाना चाहते हैं?';

  @override
  String get pagesDiscardButton => 'हटाएं';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पेज निकाले गए',
      one: '1 पेज निकाला गया',
    );
    return '$_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      'यह PDF संपादित नहीं की जा सकती क्योंकि यह एन्क्रिप्टेड या अपठनीय है।';

  @override
  String get viewerErrorCorruptTitle => 'यह दस्तावेज़ नहीं खुल सका';

  @override
  String get viewerErrorCorruptMessage =>
      'यह फ़ाइल क्षतिग्रस्त प्रतीत होती है या मान्य दस्तावेज़ नहीं है।';

  @override
  String get viewerErrorMissingTitle => 'यह फ़ाइल अब मौजूद नहीं है';

  @override
  String get viewerErrorMissingMessage =>
      'फ़ाइल को डिवाइस स्टोरेज से हटा दिया गया है या कहीं और ले जाया गया है।';

  @override
  String get viewerErrorBackToFiles => 'फ़ाइलों पर वापस जाएं';

  @override
  String get viewerErrorNoAppFound =>
      'इस फ़ाइल को खोलने के लिए कोई ऐप नहीं मिला';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count परिणाम',
      one: '1 परिणाम',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count इकाइयां • $ext',
      one: '1 इकाई • $ext',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner => 'पुराना फ़ॉर्मैट: केवल टेक्स्ट';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      'बड़ी वर्कबुक: पहली 20,000 पंक्तियाँ और 100 कॉलम दिखाए जा रहे हैं';

  @override
  String viewerSectionTitle(int number) {
    return 'अनुभाग $number';
  }

  @override
  String get viewerMenuOutline => 'रूपरेखा';

  @override
  String get viewerOutlineTitle => 'दस्तावेज़ की रूपरेखा';

  @override
  String get viewerCloseOutline => 'रूपरेखा बंद करें';

  @override
  String get viewerNoSections => 'इस दस्तावेज़ में कोई अनुभाग नहीं मिला';

  @override
  String get viewerOutlineTooltip => 'विषय-सूची';

  @override
  String get viewerActionOpenExternal => 'दूसरे ऐप में खोलें';

  @override
  String get viewerErrorCantOpenTitle => 'यह दस्तावेज़ नहीं खुल सका';

  @override
  String get viewerErrorCantOpenMessage =>
      'दस्तावेज़ को ऑफ़लाइन रेंडर नहीं किया जा सका।';

  @override
  String get viewerOpeningDocument => 'दस्तावेज़ खुल रहा है...';

  @override
  String get viewerErrorEncryptedTitle => 'यह दस्तावेज़ एन्क्रिप्टेड है';

  @override
  String get viewerErrorEncryptedMessage =>
      'ऑफ़लाइन रीडर में पासवर्ड-सुरक्षित फ़ाइलें नहीं देखी जा सकतीं।';

  @override
  String get viewerErrorTooLargeTitle => 'यह फ़ाइल देखने की सीमा से बड़ी है';

  @override
  String get viewerErrorTooLargeMessage =>
      'बड़े दस्तावेज़ों को किसी बाहरी Office व्यूअर का उपयोग करके खोला जाना चाहिए।';

  @override
  String get viewerErrorUnsupportedFormatTitle => 'यह फ़ॉर्मैट समर्थित नहीं है';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      'Doc View इस फ़ाइल फ़ॉर्मैट को सीधे पार्स नहीं कर सकता।';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '1 आइटम',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => 'टाइपोग्राफ़ी';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get txtViewerMonospaceLabel => 'मोनोस्पेस फ़ॉन्ट';

  @override
  String get txtViewerTruncationBanner =>
      'फ़ाइल 1 MB से बड़ी है: पहला 1 MB दिखाया जा रहा है';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पंक्तियाँ • $size',
      one: '1 पंक्ति • $size',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => 'टाइपोग्राफ़ी सेटिंग्स';

  @override
  String get txtViewerTooltipDecreaseFont => 'फ़ॉन्ट आकार घटाएं';

  @override
  String get txtViewerTooltipIncreaseFont => 'फ़ॉन्ट आकार बढ़ाएं';

  @override
  String get txtViewerTooltipToggleMonospace => 'मोनोस्पेस फ़ॉन्ट टॉगल करें';

  @override
  String get txtViewerMonospaceSubtitle =>
      'कोड और लॉग के लिए समान चौड़ाई वाले अक्षर';

  @override
  String get txtViewerPreviewLabel => 'पूर्वावलोकन';

  @override
  String get txtViewerPreviewText =>
      'तेज़ भूरी लोमड़ी आलसी कुत्ते के ऊपर से कूद गई।';

  @override
  String get txtViewerErrorTitle => 'यह टेक्स्ट फ़ाइल नहीं पढ़ी जा सकी';

  @override
  String get txtViewerErrorMessage =>
      'फ़ाइल फ़ॉर्मैट या एन्कोडिंग को पार्स नहीं किया जा सका।';

  @override
  String get txtViewerActionRetry => 'पुनः प्रयास करें';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '$width × $height • $size';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get imageViewerTooltipFitToScreen => 'स्क्रीन पर फ़िट करें';

  @override
  String get imageViewerErrorCorrupt => 'इमेज लोड करने में असमर्थ';

  @override
  String get imageViewerLoading => 'इमेज लोड हो रही है…';

  @override
  String get viewerDispatcherFileMissing => 'फ़ाइल अब मौजूद नहीं है';

  @override
  String get viewerSpreadsheetFormulaBarEmpty => '-';

  @override
  String get viewerSpreadsheetAllCells => 'सभी';

  @override
  String viewerSpreadsheetColumnLabel(String col) {
    return 'कॉलम $col';
  }

  @override
  String viewerSpreadsheetRowLabel(int row) {
    return 'पंक्ति $row';
  }

  @override
  String viewerSpreadsheetCellSemantics(String col, int row, String value) {
    return 'कॉलम $col, पंक्ति $row, $value';
  }

  @override
  String get viewerSpreadsheetEmptyCell => 'खाली';

  @override
  String get viewerSpreadsheetEmptySheet => 'यह शीट खाली है';

  @override
  String get viewerSpreadsheetCopiedSingle => 'सेल कॉपी किया गया';

  @override
  String viewerSpreadsheetCopiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सेल कॉपी किए गए',
      one: '1 सेल कॉपी किया गया',
    );
    return '$_temp0';
  }

  @override
  String get viewerSpreadsheetCopyLimitReached =>
      'चयन 5,000 सेल तक सीमित किया गया';

  @override
  String get viewerSpreadsheetCellContentTitle => 'सेल सामग्री';

  @override
  String get viewerSpreadsheetCopyAction => 'कॉपी करें';

  @override
  String get viewerSpreadsheetCloseAction => 'बंद करें';

  @override
  String viewerSpreadsheetZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get viewerSpreadsheetResetZoomTooltip => 'ज़ूम को 100% पर रीसेट करें';

  @override
  String get viewerSpreadsheetNoMatches => 'इस शीट में कोई परिणाम नहीं मिला';

  @override
  String get viewerSpreadsheetSearchPlaceholder => 'शीट में खोजें…';

  @override
  String get viewerSpreadsheetPasswordTitle => 'पासवर्ड-सुरक्षित फ़ाइल';

  @override
  String get viewerSpreadsheetPasswordMessage =>
      'पासवर्ड-सुरक्षित फ़ाइलें यहाँ नहीं खोली जा सकतीं।';

  @override
  String get viewerSpreadsheetErrorTitle => 'यह स्प्रेडशीट नहीं पढ़ी जा सकी';

  @override
  String get viewerSpreadsheetCorruptMessage =>
      'स्प्रेडशीट फ़ाइल क्षतिग्रस्त है या इसे डिकोड नहीं किया जा सका।';

  @override
  String get viewerSpreadsheetTimeoutMessage =>
      '20 सेकंड के बाद स्प्रेडशीट खोलने का समय समाप्त हो गया।';

  @override
  String get viewerSpreadsheetTooLargeMessage =>
      'यह फ़ाइल 25 MB देखने की सीमा से अधिक है।';

  @override
  String get viewerSpreadsheetOpenBasicViewer => 'बेसिक व्यूअर में खोलें';

  @override
  String get viewerSpreadsheetOpenAnotherApp => 'दूसरे ऐप में खोलें';

  @override
  String get toolsWorkspaceOverline => 'कार्यक्षेत्र';

  @override
  String get toolsTitle => 'टूल्स';

  @override
  String get toolsSectionConvertCreate => 'बदलें और बनाएं';

  @override
  String get toolsSectionEditManage => 'संपादित और प्रबंधित करें';

  @override
  String get toolsSectionOthers => 'अन्य';

  @override
  String get toolsCreatedByYou => 'आपके द्वारा बनाए गए';

  @override
  String get toolsCreatedByYouEmpty => 'आपके द्वारा बनाई गई PDF यहाँ दिखती हैं';

  @override
  String get toolsCreatedByYouSeeAll => 'सभी देखें';

  @override
  String get toolManagePages => 'पेज प्रबंधित करें';

  @override
  String get toolManagePagesSub => 'क्रम बदलें, घुमाएं और हटाएं';

  @override
  String get toolImportFiles => 'फ़ाइलें इम्पोर्ट करें';

  @override
  String get toolImportFilesSub => 'दूसरे ऐप्स से जोड़ें';

  @override
  String get toolPrintPdf => 'PDF प्रिंट करें';

  @override
  String get toolPrintPdfSub => 'किसी भी प्रिंटर पर भेजें';

  @override
  String get toolCreatePdf => 'PDF बनाएं';

  @override
  String get toolCreatePdfSub => 'खाली दस्तावेज़ या टेम्पलेट';

  @override
  String get toolRecycleBin => 'रीसायकल बिन';

  @override
  String get toolRecycleBinSub => 'हटाई गई फ़ाइलें पुनर्स्थापित करें';

  @override
  String get toolAnnotate => 'एनोटेट करें';

  @override
  String get toolAnnotateSub => 'हाइलाइट करें, ड्रॉ और मार्क करें';

  @override
  String get toolAddText => 'टेक्स्ट जोड़ें';

  @override
  String get toolAddTextSub => 'टेक्स्ट और तारीखें डालें';

  @override
  String get toolSign => 'हस्ताक्षर करें';

  @override
  String get toolSignSub => 'फ़ॉर्म भरें और हस्ताक्षर करें';

  @override
  String get toolWordToPdf => 'Word से PDF';

  @override
  String get toolWordToPdfSub => 'DOCX को PDF में बदलें';

  @override
  String get toolPptToPdf => 'PPT से PDF';

  @override
  String get toolPptToPdfSub => 'PPTX को PDF में बदलें';

  @override
  String get printPdfErrorTooLarge => 'PDF फ़ाइल 50 MB प्रिंट सीमा से अधिक है।';

  @override
  String get printPdfErrorUnreadable =>
      'प्रिंट करने के लिए PDF पढ़ने में असमर्थ।';

  @override
  String get printPdfErrorPassword =>
      'पासवर्ड-सुरक्षित PDF को सीधे प्रिंट नहीं किया जा सकता।';

  @override
  String get printPdfErrorFailed => 'प्रिंटिंग विफल रही।';

  @override
  String get printPdfSuccess => 'दस्तावेज़ प्रिंटर पर भेजा गया।';

  @override
  String get toolPickerTitleSelectPdf => 'PDF चुनें';

  @override
  String get toolPickerTitleSelectPdfs => 'PDF चुनें';

  @override
  String get toolPickerBrowseFiles => 'फ़ाइलें ब्राउज़ करें';

  @override
  String get toolPickerTabAll => 'सभी PDF';

  @override
  String get toolPickerTabRecent => 'हालिया';

  @override
  String get toolPickerTabDownloads => 'डाउनलोड';

  @override
  String get toolPickerTabICloud => 'iCloud Drive';

  @override
  String get toolPickerActionPrint => 'प्रिंट करें';

  @override
  String get toolPickerActionManage => 'प्रबंधित करें';

  @override
  String get toolPickerActionSelect => 'चुनें';

  @override
  String get toolsImportActionView => 'देखें';

  @override
  String get createPdfTemplateBlank => 'खाली';

  @override
  String get createPdfTemplateLine1 => 'लाइन 1';

  @override
  String get createPdfTemplateLine2 => 'लाइन 2';

  @override
  String get createPdfTemplateNotebook => 'नोटबुक';

  @override
  String get createPdfTemplateCornell => 'कॉर्नेल';

  @override
  String get createPdfTemplateGrid => 'ग्रिड';

  @override
  String get createPdfTemplateGraph => 'ग्राफ़';

  @override
  String get createPdfSwatchWhite => 'सफ़ेद';

  @override
  String get createPdfSwatchCream => 'क्रीम';

  @override
  String get createPdfSwatchLightYellow => 'हल्का पीला';

  @override
  String get createPdfSwatchLightPeach => 'हल्का पीच';

  @override
  String get createPdfSwatchLightPink => 'हल्का गुलाबी';

  @override
  String get createPdfSwatchLightLavender => 'हल्का लैवेंडर';

  @override
  String get createPdfSwatchLightBlue => 'हल्का नीला';

  @override
  String get createPdfSwatchLightMint => 'हल्का मिंट';

  @override
  String get createPdfSwatchLightGreen => 'हल्का हरा';

  @override
  String get createPdfSwatchLightGray => 'हल्का स्लेटी';

  @override
  String get createPdfOrientationPortrait => 'पोर्ट्रेट';

  @override
  String get createPdfOrientationLandscape => 'लैंडस्केप';

  @override
  String get createPdfSectionTemplate => 'टेम्पलेट';

  @override
  String get createPdfSectionPageSize => 'पेज का आकार';

  @override
  String get createPdfSectionOrientation => 'अभिविन्यास';

  @override
  String get createPdfSectionPageColor => 'पेज का रंग';

  @override
  String get createPdfSectionPageCount => 'पेजों की संख्या';

  @override
  String createPdfPagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पेज',
      one: '1 पेज',
    );
    return '$_temp0';
  }

  @override
  String createPdfSummary(String pages, String size, String orientation) {
    return '$pages • $size • $orientation';
  }

  @override
  String get createPdfCreating => 'PDF बनाई जा रही है...';

  @override
  String createPdfProgress(int done, int total) {
    return '$total में से पेज $done बनाया जा रहा है...';
  }

  @override
  String get createPdfErrorTitle => 'PDF बनाने में असमर्थ';

  @override
  String get createPdfErrorPageCount =>
      'पेजों की संख्या 1 से 100 के बीच होनी चाहिए।';

  @override
  String get createPdfErrorInvalidName => 'कृपया एक मान्य फ़ाइल नाम दर्ज करें।';

  @override
  String get createPdfErrorGeneration =>
      'PDF दस्तावेज़ बनाने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get trashErrorTooLarge =>
      'फ़ाइल रीसायकल बिन के लिए बहुत बड़ी है (200 MB सीमा)';

  @override
  String get trashErrorNotEnoughSpace =>
      'रीसायकल बिन में पर्याप्त स्टोरेज स्थान नहीं है';

  @override
  String trashErrorGeneric(String details) {
    return 'रीसायकल बिन प्रक्रिया विफल रही: $details';
  }

  @override
  String get trashDialogMoveTitle => 'रीसायकल बिन में भेजें?';

  @override
  String trashDialogMoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count फ़ाइलों को रीसायकल बिन में भेजें? आप इन्हें 30 दिनों तक टूल्स > रीसायकल बिन से पुनर्स्थापित कर सकते हैं।',
      one:
          '1 फ़ाइल को रीसायकल बिन में भेजें? आप इसे 30 दिनों तक टूल्स > रीसायकल बिन से पुनर्स्थापित कर सकते हैं।',
    );
    return '$_temp0';
  }

  @override
  String get trashActionMove => 'रीसायकल बिन में भेजें';

  @override
  String trashMovedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें रीसायकल बिन में भेजी गईं',
      one: '1 फ़ाइल रीसायकल बिन में भेजी गई',
    );
    return '$_temp0';
  }

  @override
  String get trashActionUndo => 'पूर्ववत करें';

  @override
  String trashRestoredSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें पुनर्स्थापित की गईं',
      one: '1 फ़ाइल पुनर्स्थापित की गई',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogDeleteForeverTitle => 'हमेशा के लिए हटाएं?';

  @override
  String trashDialogDeleteForeverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count फ़ाइलों को हमेशा के लिए हटाएं? इसे वापस नहीं लाया जा सकता।',
      one: '1 फ़ाइल को हमेशा के लिए हटाएं? इसे वापस नहीं लाया जा सकता।',
    );
    return '$_temp0';
  }

  @override
  String get trashActionDeleteForever => 'हमेशा के लिए हटाएं';

  @override
  String trashDeletedForeverSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें हमेशा के लिए हटाई गईं',
      one: '1 फ़ाइल हमेशा के लिए हटाई गई',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogEmptyTitle => 'रीसायकल बिन खाली करें?';

  @override
  String trashDialogEmptyBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें',
      one: '1 फ़ाइल',
    );
    return 'सभी $_temp0 हमेशा के लिए हटाएं? इसे वापस नहीं लाया जा सकता।';
  }

  @override
  String get trashActionEmptyBin => 'बिन खाली करें';

  @override
  String get trashEmptyTitle => 'रीसायकल बिन खाली है';

  @override
  String get trashEmptySubtitle =>
      'रीसायकल बिन में भेजी गई फ़ाइलें स्थायी रूप से हटाए जाने से पहले 30 दिनों तक यहाँ रहेंगी।';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन शेष',
      one: '1 दिन शेष',
    );
    return '$_temp0';
  }

  @override
  String trashSubtitle(String date, String size) {
    return '$date को हटाई गई · $size';
  }

  @override
  String get trashDialogTooLargeTitle => 'रीसायकल बिन के लिए बहुत बड़ी है';

  @override
  String trashDialogTooLargeBody(String fileName) {
    return '\"$fileName\" 200 MB से बड़ी है और इसे रीसायकल बिन में नहीं भेजा जा सकता। क्या आप इसे स्थायी रूप से हटाना चाहते हैं?';
  }

  @override
  String get trashActionDeletePermanently => 'स्थायी रूप से हटाएं';

  @override
  String get trashInfoBanner =>
      'रीसायकल बिन में मौजूद आइटम 30 दिनों के बाद स्थायी रूप से हटा दिए जाते हैं।';

  @override
  String get trashSheetRestore => 'पुनर्स्थापित करें';

  @override
  String get trashSheetDeleteForever => 'हमेशा के लिए हटाएं';

  @override
  String get trashSheetDetails => 'विवरण';

  @override
  String get trashDetailsOriginalLocation => 'मूल स्थान';

  @override
  String get trashDetailsDateDeleted => 'हटाने की तिथि';

  @override
  String get trashDetailsExpiresIn => 'समाप्ति समय';

  @override
  String trashRestoredToFallbackSuccess(String location) {
    return '$location में पुनर्स्थापित किया गया (मूल फ़ोल्डर नहीं मिला)';
  }

  @override
  String get trashDialogCopyFailedTitle => 'रीसायकल बिन में नहीं भेजा जा सका';

  @override
  String trashDialogCopyFailedBody(String fileName) {
    return '\"$fileName\" को रीसायकल बिन में नहीं भेजा जा सका। क्या आप इसे स्थायी रूप से हटाना चाहते हैं? इसे वापस नहीं लाया जा सकता।';
  }

  @override
  String get trashDialogEmptyProgress => 'रीसायकल बिन खाली हो रहा है...';

  @override
  String get trashDialogMoveProgress =>
      'फ़ाइलें रीसायकल बिन में भेजी जा रही हैं...';

  @override
  String get trashDialogNotEnoughSpaceTitle => 'पर्याप्त स्टोरेज स्थान नहीं है';

  @override
  String get trashDialogNotEnoughSpaceBody =>
      'रीसायकल बिन में भेजने के लिए पर्याप्त स्टोरेज स्थान नहीं है। बिन खाली करके स्थान खाली करें।';

  @override
  String get trashActionFreeUpSpace => 'स्थान खाली करें';

  @override
  String get trashDialogDeleteForeverProgress =>
      'फ़ाइलें हमेशा के लिए हटाई जा रही हैं...';

  @override
  String get galleryDebugAgeTrash => 'सभी ट्रैश आइटम 29 दिन पुराने करें';

  @override
  String get galleryDebugSlowCopy => 'धीमी ट्रैश कॉपी (परीक्षण)';

  @override
  String get galleryDebugSlowCopySubtitle =>
      'किल टेस्टिंग के लिए कॉपी लूप को ~20 MB/s तक धीमा करता है';

  @override
  String get galleryDebugSlowSave => 'धीमा एडिटर सेव (परीक्षण)';

  @override
  String get galleryDebugSlowSaveSubtitle =>
      'किल टेस्टिंग के लिए सेव लूप को ~8s तक धीमा करता है';

  @override
  String get galleryDebugSaveAnnotate => 'सैंपल 100p सेव करें (एनोटेट परीक्षण)';

  @override
  String get galleryDebugSaveSign => 'सैंपल 100p सेव करें (हस्ताक्षर परीक्षण)';

  @override
  String get galleryDebugSaveText =>
      'सैंपल 100p सेव करें (टेक्स्ट जोड़ें परीक्षण)';

  @override
  String get galleryDebugMove190Mb => '190MB परीक्षण फ़ाइल ट्रैश में भेजें';

  @override
  String get galleryDebugRestoreLastTrash =>
      'अंतिम ट्रैश आइटम पुनर्स्थापित करें';

  @override
  String get galleryDebugEmptyTrash => 'रीसायकल बिन खाली करें';

  @override
  String galleryDebugAgeTrashSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '1 आइटम',
    );
    return '$_temp0 को 29 दिन पुराना किया गया';
  }

  @override
  String get annotateErrorPasswordProtected => 'यह PDF पासवर्ड-सुरक्षित है।';

  @override
  String get annotateErrorCorrupt =>
      'यह PDF क्षतिग्रस्त है या पढ़ी नहीं जा सकती।';

  @override
  String get annotateSignedReplaceBlocked =>
      'हस्ताक्षरित मूल PDF को बदलने की अनुमति नहीं है। कृपया नई फ़ाइल के रूप में सेव करें।';

  @override
  String annotateErrorSaveFailed(String details) {
    return 'एनोटेशन सेव करने में विफल: $details';
  }

  @override
  String get annotateErrorScannedPdf =>
      'यह दस्तावेज़ स्कैन किया हुआ प्रतीत होता है या इसमें चुनने योग्य टेक्स्ट नहीं है।';

  @override
  String get annotateSignedBanner =>
      'डिजिटल रूप से हस्ताक्षरित PDF: हस्ताक्षर सुरक्षित रखने के लिए सेव करने पर एक नई प्रति बनेगी।';

  @override
  String get annotateActionSaveNew => 'नई फ़ाइल के रूप में सेव करें';

  @override
  String get annotateActionReplace => 'मूल फ़ाइल बदलें';

  @override
  String get annotateDiscardDialogTitle => 'बिना सेव किए गए एनोटेशन हटाएं?';

  @override
  String get annotateDiscardDialogBody =>
      'आपके पास बिना सेव किए गए मार्कअप हैं। यदि आप अभी बाहर निकलते हैं, तो आपके बदलाव खो जाएंगे।';

  @override
  String get annotateDiscardDialogActionDiscard => 'हटाएं';

  @override
  String get annotateDiscardDialogActionKeep => 'संपादन जारी रखें';

  @override
  String get annotateSaveSuccess => 'एनोटेशन सफलतापूर्वक सेव किए गए';

  @override
  String get annotateToolbarHighlight => 'हाइलाइट';

  @override
  String get annotateToolbarUnderline => 'अंडरलाइन';

  @override
  String get annotateToolbarStrikethrough => 'स्ट्राइकथ्रू';

  @override
  String get annotateToolbarCopy => 'कॉपी करें';

  @override
  String get annotateColorYellow => 'पीला';

  @override
  String get annotateColorGreen => 'हरा';

  @override
  String get annotateColorCyan => 'सियान';

  @override
  String get annotateColorPink => 'गुलाबी';

  @override
  String get annotateColorOrange => 'नारंगी';

  @override
  String get annotateSaveTitle => 'एनोटेशन सेव करें';

  @override
  String get annotateSaveProgress => 'एनोटेशन सेव हो रहे हैं...';

  @override
  String get annotateNoChanges => 'सेव करने के लिए कोई एनोटेशन नहीं है';

  @override
  String get annotateTooltipUndo => 'पूर्ववत करें';

  @override
  String get annotateTooltipRedo => 'पुनः करें';

  @override
  String get annotateTooltipSave => 'सेव करें';

  @override
  String get annotateCopiedToClipboard => 'क्लिपबोर्ड पर कॉपी हो गया';

  @override
  String get annotateToolbarPen => 'पेन';

  @override
  String get annotatePenTipBanner =>
      'एक उंगली से लिखें। दो उंगलियों से पैन और ज़ूम करें।';

  @override
  String get annotatePenSheetTitle => 'पेन सेटिंग्स';

  @override
  String get annotatePenStrokeWidth => 'स्ट्रोक की मोटाई';

  @override
  String get annotatePenEraserMode => 'इरेज़र';

  @override
  String get annotateColorBlack => 'काला';

  @override
  String get annotateColorRed => 'लाल';

  @override
  String get annotateColorPurple => 'बैंगनी';

  @override
  String get annotateColorBlue => 'नीला';

  @override
  String get toolSignPdf => 'PDF पर हस्ताक्षर करें';

  @override
  String get toolSignPdfSubtitle => 'दस्तावेज़ों में हस्ताक्षर और तारीख जोड़ें';

  @override
  String get signToolbarSign => 'हस्ताक्षर';

  @override
  String get signToolbarDate => 'तारीख';

  @override
  String get signToolbarClearAll => 'सभी साफ़ करें';

  @override
  String get signPadTitle => 'अपना हस्ताक्षर बनाएं';

  @override
  String get signPadClear => 'साफ़ करें';

  @override
  String get signPadSave => 'हस्ताक्षर सेव करें';

  @override
  String get signSheetTitle => 'सेव किए गए हस्ताक्षर';

  @override
  String get signSheetCreateNew => 'नया हस्ताक्षर बनाएं';

  @override
  String get signMaxSignaturesReached =>
      'अधिकतम 5 सेव किए गए हस्ताक्षरों की सीमा पूरी हो गई';

  @override
  String get signMaxPlacedReached =>
      'प्रति दस्तावेज़ अधिकतम 20 हस्ताक्षरों की सीमा पूरी हो गई';

  @override
  String get signDeleteSignatureTitle => 'हस्ताक्षर हटाएं?';

  @override
  String get signDeleteSignatureBody =>
      'यह हस्ताक्षर आपके सेव किए गए हस्ताक्षरों से हटा दिया जाएगा।';

  @override
  String get signConfirmClearAllTitle => 'सभी हस्ताक्षर साफ़ करें?';

  @override
  String get signConfirmClearAllBody =>
      'इस दस्तावेज़ पर लगाए गए सभी हस्ताक्षर और तारीखें हटा दी जाएंगी।';

  @override
  String get signSaveSuccess => 'दस्तावेज़ पर सफलतापूर्वक हस्ताक्षर किए गए';

  @override
  String get signNoSignaturesToSave =>
      'दस्तावेज़ पर कोई हस्ताक्षर नहीं लगाया गया है';

  @override
  String get signPlacedSignatureDelete => 'हटाएं';

  @override
  String get signPlacedSignatureApply => 'लागू करें';

  @override
  String get signTooltipUndo => 'पूर्ववत करें';

  @override
  String get signTooltipRedo => 'पुनः करें';

  @override
  String get signTooltipSave => 'सेव करें';

  @override
  String annotatePenStrokeWidthValue(String width) {
    return '$width pt';
  }

  @override
  String get annotateErrorTooManyStrokes =>
      'दस्तावेज़ अधिकतम 5,000 स्ट्रोक या 300,000 पॉइंट्स की सीमा तक पहुंच गया है।';

  @override
  String annotateChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बदलाव',
      one: '1 बदलाव',
    );
    return '$_temp0';
  }

  @override
  String get annotatePenNotice =>
      'सेव करने पर पेन के निशान पेज का हिस्सा बन जाते हैं और बाद में उन्हें संपादित नहीं किया जा सकता।';

  @override
  String get annotatePenNoticeDismiss => 'समझ गया';

  @override
  String get signPadBaselineHint => 'यहाँ हस्ताक्षर करें';

  @override
  String get signPadUndo => 'पूर्ववत करें';

  @override
  String get signPadUseOnce => 'एक बार उपयोग करें';

  @override
  String get signPadSaveAndUse => 'सेव करें और उपयोग करें';

  @override
  String get tool_add_text => 'टेक्स्ट जोड़ें';

  @override
  String get tool_add_text_desc => 'पेजों पर टेक्स्ट बॉक्स और नोट्स जोड़ें';

  @override
  String get addTextNoticePermanent =>
      'जोड़ा गया टेक्स्ट पेज का हिस्सा बन जाता है और सेव करने के बाद इसे संपादित नहीं किया जा सकता।';

  @override
  String get addTextNoticeRaster =>
      'इस भाषा का टेक्स्ट इमेज के रूप में जोड़ा जाता है और इसे चुना नहीं जा सकता।';

  @override
  String get addTextNoticeGotIt => 'समझ गया';

  @override
  String get addTextActionAdd => 'टेक्स्ट जोड़ें';

  @override
  String get addTextActionStyle => 'शैली';

  @override
  String get addTextActionDelete => 'हटाएं';

  @override
  String get addTextStyleSheetTitle => 'टेक्स्ट शैली';

  @override
  String get addTextFontSize => 'फ़ॉन्ट आकार';

  @override
  String get addTextColor => 'रंग';

  @override
  String get addTextStyle => 'शैली';

  @override
  String get addTextAlign => 'संरेखण';

  @override
  String get addTextBold => 'बोल्ड';

  @override
  String get addTextItalic => 'इटैलिक';

  @override
  String get addTextAlignStart => 'शुरू';

  @override
  String get addTextAlignCenter => 'केंद्र';

  @override
  String get addTextAlignEnd => 'अंत';

  @override
  String get addTextErrorTooManyBoxes =>
      'अधिकतम 30 टेक्स्ट बॉक्स की सीमा पूरी हो गई';

  @override
  String get addTextErrorBoxTooLong =>
      'टेक्स्ट बॉक्स 2,000 अक्षरों से अधिक नहीं हो सकता';

  @override
  String get addTextPlaceholder => 'यहाँ टेक्स्ट टाइप करें';

  @override
  String get addTextSamplePreview => 'नमूना पूर्वावलोकन';

  @override
  String addTextFontSizePt(int size) {
    return '$size pt';
  }

  @override
  String get premiumTitle => 'Doc View Premium';

  @override
  String get premiumSubtitle =>
      'एनोटेट और हस्ताक्षर टूल्स अनलॉक करें और पूरी तरह विज्ञापन-मुक्त अनुभव का आनंद लें।';

  @override
  String get premiumFeatureAllTools => 'PDF एनोटेट और हस्ताक्षर टूल्स';

  @override
  String get premiumFeatureAllToolsSub =>
      'आसानी से मार्कअप बनाएं, दस्तावेज़ हाइलाइट करें और PDF पर हस्ताक्षर करें';

  @override
  String get premiumFeatureAdFree => '100% विज्ञापन-मुक्त अनुभव';

  @override
  String get premiumFeatureAdFreeSub =>
      'कहीं भी कोई बैनर, रुकावट या व्यवधान नहीं';

  @override
  String get premiumFeatureUnlimitedConversions => 'असीमित स्थानीय रूपांतरण';

  @override
  String get premiumFeatureUnlimitedConversionsSub =>
      'बिना किसी फ़ाइल सीमा के डिवाइस पर ही दस्तावेज़ बदलें';

  @override
  String get premiumFeaturePrivacyFirst => '100% निजी और ऑन-डिवाइस';

  @override
  String get premiumFeaturePrivacyFirstSub =>
      'फ़ाइलें स्थानीय रूप से प्रोसेस होती हैं और कभी किसी सर्वर पर अपलोड नहीं की जातीं';

  @override
  String get premiumPlanYearly => 'वार्षिक सदस्यता';

  @override
  String premiumPlanYearlyTrial(int days, String price) {
    return '$days दिन मुफ़्त, फिर $price/वर्ष';
  }

  @override
  String get premiumPlanMonthly => 'मासिक सदस्यता';

  @override
  String premiumPlanMonthlySub(String price) {
    return '$price/माह';
  }

  @override
  String premiumPlanYearlySub(String price) {
    return '$price/वर्ष';
  }

  @override
  String premiumPlanMonthlyTrial(int days, String price) {
    return '$days दिन मुफ़्त, फिर $price/माह';
  }

  @override
  String premiumSavePercent(int percent) {
    return '$percent% बचाएं';
  }

  @override
  String get premiumSaveUnknown => '-% बचाएं';

  @override
  String premiumActionStartTrial(int days) {
    return '$days-दिन का मुफ़्त ट्रायल शुरू करें';
  }

  @override
  String get premiumSubscriptionsAvailableSoon =>
      'सदस्यताएं जल्द ही उपलब्ध होंगी।';

  @override
  String get pagesEditPagesAction => 'पेज संपादित करें';

  @override
  String get premiumCancelAnytime => 'कभी भी रद्द करें';

  @override
  String get premiumPendingStatus =>
      'आपकी खरीदारी Google Play द्वारा प्रोसेस की जा रही है। पुष्टि होते ही सुविधाएं सक्रिय हो जाएंगी।';

  @override
  String get premiumRenewalDisclosurePricingUnavailable =>
      'स्वतः नवीनीकरण होता है। चेकआउट के समय Google Play द्वारा कीमत की पुष्टि की जाएगी। Google Play सदस्यताओं में कभी भी रद्द करें।';

  @override
  String get premiumActionSubscribe => 'सदस्यता लें';

  @override
  String get premiumActionRestore => 'खरीदारी पुनर्स्थापित करें';

  @override
  String get premiumBillingDisclaimer =>
      'स्वतः नवीनीकरण होता है। Google Play सदस्यताओं में कभी भी रद्द करें।';

  @override
  String get premiumTerms => 'सेवा की शर्तें';

  @override
  String get premiumPrivacy => 'गोपनीयता नीति';

  @override
  String get premiumActiveStatus => 'आप एक प्रीमियम सदस्य हैं';

  @override
  String get premiumGraceStatus => 'ऑफ़लाइन ग्रेस अवधि सक्रिय';

  @override
  String get premiumExpiredStatus => 'सदस्यता समाप्त हो गई';

  @override
  String get premiumRestoreSuccess => 'खरीदारी सफलतापूर्वक पुनर्स्थापित हो गई।';

  @override
  String get premiumRestoreNone => 'कोई सक्रिय सदस्यता नहीं मिली।';

  @override
  String get premiumErrorGeneral =>
      'खरीदारी पूरी करने में असमर्थ। कृपया पुनः प्रयास करें।';

  @override
  String get premiumPagesGateTitle => 'Doc View Premium';

  @override
  String get premiumPagesGateBody =>
      'पेजों का क्रम बदलने, घुमाने और हटाने के लिए प्रीमियम सदस्यता आवश्यक है।';

  @override
  String get premiumPagesGateUpgrade => 'प्रीमियम में अपग्रेड करें';

  @override
  String get premiumTooltip => 'Doc View Premium';

  @override
  String get premiumManageInPlay => 'प्रबंधित करें';

  @override
  String get faqQuestion8 => 'Doc View Premium में क्या शामिल है?';

  @override
  String get faqAnswer8 =>
      'Doc View Premium सभी उन्नत दस्तावेज़ संपादन टूल्स को अनलॉक करता है, जिनमें PDF पेज का क्रम बदलना, घुमाना, हटाना, PDF से Word रूपांतरण, एनोटेशन, हस्ताक्षर और कस्टम टेक्स्ट जोड़ना शामिल है, साथ ही पूरे ऐप से सभी विज्ञापन पूरी तरह हटा दिए जाते हैं। सभी दस्तावेज़ प्रोसेसिंग 100% ऑन-डिवाइस रहती है।';

  @override
  String get faqQuestion9 =>
      'क्या मैं बिना इंटरनेट कनेक्शन के Doc View Premium का उपयोग कर सकता हूँ?';

  @override
  String get faqAnswer9 =>
      'हाँ। सक्रिय होने के बाद, Doc View लगातार 7 दिनों तक की ऑफ़लाइन ग्रेस अवधि के साथ आपके डिवाइस पर आपकी सदस्यता स्थिति को सुरक्षित रूप से कैश करता है। इस अवधि के दौरान आप ऑफ़लाइन रहते हुए सभी संपादन टूल्स का उपयोग जारी रख सकते हैं।';

  @override
  String get galleryDebugIapSectionTitle =>
      '15. IAP और प्रीमियम सिम्युलेटर (G7)';

  @override
  String get galleryDebugIapStateFree => 'मुफ़्त सेट करें';

  @override
  String get galleryDebugIapStateYearly => 'वार्षिक प्रीमियम सेट करें';

  @override
  String get galleryDebugIapStateMonthly => 'मासिक प्रीमियम सेट करें';

  @override
  String get galleryDebugIapStateGrace => 'ऑफ़लाइन ग्रेस सेट करें (सक्रिय)';

  @override
  String get galleryDebugIapStateGraceExpired =>
      'ऑफ़लाइन ग्रेस सेट करें (समाप्त)';

  @override
  String get galleryDebugOpenPremium => '/premium स्क्रीन खोलें';

  @override
  String get galleryDebugIapProductSeenTrue => 'देखा गया उत्पाद सेट करें: True';

  @override
  String get galleryDebugIapProductSeenFalse =>
      'देखा गया उत्पाद सेट करें: False';

  @override
  String get addWidgetSheetTitle => 'होम स्क्रीन पर जोड़ें';

  @override
  String get addWidgetSheetSubtitle =>
      'अपनी होम स्क्रीन पर जोड़ने के लिए एक विजेट चुनें';

  @override
  String get widgetRecentFilesTitle => 'हालिया फ़ाइलें';

  @override
  String get widgetRecentFilesBadge => '4 × 2';

  @override
  String get widgetRecentFilesDesc =>
      'सीधे अपनी होम स्क्रीन से अपनी हाल ही में उपयोग की गई फ़ाइलें देखें और खोलें';

  @override
  String get widgetQuickToolsTitle => 'त्वरित टूल्स';

  @override
  String get widgetQuickToolsBadge => '4 × 1';

  @override
  String get widgetQuickToolsDesc =>
      'सीधे स्कैन, इमेज से PDF, खोज या इम्पोर्ट पर जाएं';

  @override
  String get addWidgetButton => 'विजेट जोड़ें';

  @override
  String get addWidgetManualTitle => 'मैन्युअल रूप से विजेट जोड़ें';

  @override
  String get addWidgetManualMessage =>
      'अपनी होम स्क्रीन पर किसी खाली जगह को दबाकर रखें, विजेट्स पर टैप करें, Doc View ढूंढें और उसे अपनी स्क्रीन पर खींचें।';

  @override
  String get settingsQuickAccessNotificationTitle => 'त्वरित पहुंच सूचना';

  @override
  String get settingsQuickAccessNotificationSubtitle =>
      'सूचना बार में त्वरित टूल्स दिखाएं';

  @override
  String get notificationPermissionDialogTitle => 'सूचनाओं की अनुमति दें';

  @override
  String get notificationPermissionDialogDesc =>
      'आपकी सूचना ट्रे में त्वरित पहुंच बार दिखाने के लिए Doc View को सूचना अनुमति की आवश्यकता है।';

  @override
  String get notificationTitle => 'Doc View त्वरित टूल्स';

  @override
  String get notificationBody => 'दस्तावेज़ स्कैन करें, बदलें या खोजें';

  @override
  String get notificationActionScan => 'स्कैन करें';

  @override
  String get notificationActionImageToPdf => 'इमेज से PDF';

  @override
  String get notificationActionSearch => 'खोजें';

  @override
  String get settingsAdChoicesTitle => 'विज्ञापन विकल्प';

  @override
  String get settingsAdChoicesSubtitle =>
      'गोपनीयता और विज्ञापन विकल्प प्रबंधित करें';

  @override
  String get faqQuestion10 => 'Doc View विज्ञापन क्यों दिखाता है?';

  @override
  String get faqAnswer10 =>
      'विज्ञापन Doc View को मुफ़्त बनाए रखते हैं। प्रीमियम इन्हें हटा देता है। विज्ञापन Google AdMob द्वारा दिखाए जाते हैं और कभी भी आपके दस्तावेज़ नहीं देखते।';
}
