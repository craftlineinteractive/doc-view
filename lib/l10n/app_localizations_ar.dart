// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Doc View';

  @override
  String get navHome => 'كل الملفات';

  @override
  String get navTools => 'الأدوات';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get noDocumentSelected => 'لم يتم تحديد مستند';

  @override
  String get tooltipCloseAd => 'إغلاق الإعلان';

  @override
  String get tooltipClose => 'إغلاق';

  @override
  String get tooltipRescan => 'إعادة فحص المستندات';

  @override
  String get tooltipSearch => 'البحث في المستندات';

  @override
  String get tooltipSelectFiles => 'تحديد ملفات';

  @override
  String get tooltipBack => 'رجوع';

  @override
  String get tooltipCancelSelection => 'إلغاء التحديد';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم تحديد $count',
      one: 'تم تحديد 1',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'تحديد الكل';

  @override
  String get actionDeselectAll => 'إلغاء تحديد الكل';

  @override
  String get tooltipDeleteSelected => 'حذف المحدد';

  @override
  String get tooltipClearSearch => 'مسح البحث';

  @override
  String get searchHint => 'ابحث في المستندات والمجلدات...';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return 'الصفحة $page من $total';
  }

  @override
  String get errorGenericTitle => 'حدث خطأ ما';

  @override
  String get actionRetry => 'إعادة المحاولة';

  @override
  String get permissionAllFilesTitle => 'مطلوب إذن الوصول إلى جميع الملفات';

  @override
  String get permissionAllFilesExplanation =>
      'يحتاج Doc View إلى إذن الوصول إلى جميع الملفات لتصفح المجلدات وتنظيم مستنداتك دون اتصال بالإنترنت بالكامل.';

  @override
  String get actionGrantAccess => 'منح الإذن';

  @override
  String get actionImportFilesInstead => 'استيراد الملفات بدلاً من ذلك';

  @override
  String get tooltipRemoveBookmark => 'إزالة الإشارة المرجعية';

  @override
  String get tooltipAddBookmark => 'إضافة إشارة مرجعية';

  @override
  String tooltipFileOptions(String title) {
    return 'خيارات الملف لـ $title';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return 'مجلد، $name$subtitle';
  }

  @override
  String get adAdvertisementBadge => 'إعلان';

  @override
  String get actionConfirm => 'تأكيد';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get tabRecent => 'الأخيرة';

  @override
  String get tabBookmarks => 'المفضلة';

  @override
  String get filterCategoryAll => 'الكل';

  @override
  String get actionBrowse => 'تصفح';

  @override
  String get actionCancelOperation => 'إلغاء العملية';

  @override
  String get operationComplete => 'اكتملت العملية';

  @override
  String get actionOpenDocument => 'فتح المستند';

  @override
  String get actionShareDocument => 'مشاركة المستند';

  @override
  String get splashTagline => 'كل مستنداتك في مكان واحد.';

  @override
  String appVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get actionSkip => 'تخطي';

  @override
  String get actionBack => 'السابق';

  @override
  String get actionNext => 'التالي';

  @override
  String get actionGetStarted => 'ابدأ الآن';

  @override
  String get onboardingPage1Title => 'كل مستنداتك،\nفي مكان واحد';

  @override
  String get onboardingPage1Desc =>
      'يعثر Doc View تلقائيًا على ملفات PDF وWord وExcel وPowerPoint والملفات النصية والصور على هاتفك وينظمها لك.';

  @override
  String get onboardingPage2Title => 'اقرأ أي شيء\nبأناقة وسلاسة';

  @override
  String get onboardingPage2Desc =>
      'افتح ملفات PDF وWord وExcel وPowerPoint بقارئ سريع وأنيق. ابحث، أضف إشارات مرجعية، وتابع من حيث توقفت.';

  @override
  String get onboardingPage3Title => 'أدوات PDF قوية دون إنترنت';

  @override
  String get onboardingPage3Desc =>
      'حوّل الصور إلى PDF، وامسح المستندات ضوئيًا، وادمج الملفات وقسّمها. كل شيء يبقى على جهازك.';

  @override
  String get onboardingOfflineGuarantee => 'ملفاتك تبقى على جهازك';

  @override
  String get toolImageToPdf => 'صورة إلى PDF';

  @override
  String get toolImageToPdfSub => 'تحويل JPG وPNG';

  @override
  String get toolScanToPdf => 'مسح ضوئي إلى PDF';

  @override
  String get toolScanToPdfSub => 'اكتشاف الحواف بالكاميرا';

  @override
  String get toolMergePdf => 'دمج PDF';

  @override
  String get toolMergePdfSub => 'جمع في ملف واحد';

  @override
  String get toolSplitPdf => 'تقسيم PDF';

  @override
  String get toolSplitPdfSub => 'استخراج أي نطاق';

  @override
  String get permissionTagStorage => 'الوصول إلى مساحة تخزين الجهاز';

  @override
  String get permissionStorageHeadline => 'دع Doc View يعثر على مستنداتك';

  @override
  String get permissionStorageBody =>
      'لعرض ملفات PDF وWord وExcel والملفات الأخرى المحفوظة بواسطة أي تطبيق، يحتاج Android إلى إذنك للوصول إلى جميع الملفات. ملفاتك لا تغادر هاتفك أبدًا.';

  @override
  String get permissionReassuranceOfflineTitle => 'لا يتم رفع الملفات أبدًا';

  @override
  String get permissionReassuranceOfflineDesc =>
      'تُعالج مستنداتك محليًا على جهازك.';

  @override
  String get permissionReassuranceNoUploadsTitle => 'دون رفع للخوادم';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      'لا توجد خوادم سحابية على الإطلاق. تبقى ملفاتك في ذاكرة الهاتف فقط.';

  @override
  String get permissionReassuranceChangeTitle => 'يمكنك تغيير هذا في أي وقت';

  @override
  String get permissionReassuranceChangeDesc =>
      'بدّل الإعداد بسهولة من إعدادات تطبيقات نظام Android.';

  @override
  String get permissionTagIOS => 'دليل التخزين على iOS';

  @override
  String get permissionIOSHeadline => 'أحضر مستنداتك إلى Doc View';

  @override
  String get permissionIOSBody =>
      'نظرًا لهيكلية الخصوصية في Apple، لا يسمح نظام iOS لأي تطبيق بفحص هاتفك بالكامل تلقائيًا. اختر الطريقة التي تفضلها لقراءة ملفاتك:';

  @override
  String get permissionIOSOptionImportTitle => 'استيراد الملفات';

  @override
  String get permissionIOSBadgeFastest => 'الأسرع';

  @override
  String get permissionIOSOptionImportDesc =>
      'اختر المستندات مباشرة من iCloud Drive أو التنزيلات أو أي مجلد في ثوانٍ.';

  @override
  String get permissionIOSOptionFolderTitle =>
      'فتح مجلد Doc View في تطبيق الملفات';

  @override
  String get permissionIOSOptionFolderDesc =>
      'احفظ المستندات أو أرسلها عبر AirDrop مباشرة إلى مجلد \"Doc View\" في تطبيق الملفات على iOS للمزامنة الفورية.';

  @override
  String get actionImportFiles => 'استيراد الملفات';

  @override
  String get actionContinueToApp => 'المتابعة إلى التطبيق';

  @override
  String get permissionTagConsent => 'الشفافية والموافقة';

  @override
  String get permissionBadgeFree => 'تطبيق مجاني 100%';

  @override
  String get permissionBadgeMinimalAds => 'إعلانات محدودة';

  @override
  String get permissionConsentHeadline => 'مجاني مع إعلانات';

  @override
  String get permissionConsentBody =>
      'تطبيق Doc View مجاني بفضل الإعلانات. سنطلب اختيارك بشأن الإعلانات المخصصة في الخطوة التالية.';

  @override
  String get permissionConsentAdsTitle => 'الإعلانات التي قد تراها';

  @override
  String get permissionConsentAdsDesc =>
      'إعلانات بانر صغيرة وبطاقات رعاية غير مزعجة. دون نوافذ منبثقة أو مقاطعات فيديو أثناء القراءة.';

  @override
  String get permissionConsentPrivateTitle => 'المستندات تبقى خاصة تمامًا';

  @override
  String get permissionConsentPrivateDesc =>
      'لا يمكن لشركاء الإعلانات أبدًا الوصول إلى أسماء مستنداتك أو محتواها النصي أو مواقع ملفاتك.';

  @override
  String get permissionConsentSettingsTitle =>
      'يمكنك تغيير اختيارك من الإعدادات';

  @override
  String get permissionConsentSettingsDesc =>
      'حدّث موافقتك على الإعلانات المخصصة أو تفضيلات الخصوصية في أي وقت من إعدادات Doc View.';

  @override
  String get actionContinue => 'متابعة';

  @override
  String get actionPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم استيراد $count ملفات',
      one: 'تم استيراد ملف واحد',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => 'فشل استيراد الملفات';

  @override
  String get tooltipImportDocuments => 'استيراد المستندات';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم العثور على $count ملفات',
      one: 'تم العثور على ملف واحد',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => 'جارٍ الفحص...';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ملفات',
      one: 'ملف واحد',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => 'المجلدات';

  @override
  String get errorLoadingRecent => 'خطأ في تحميل الملفات الأخيرة';

  @override
  String get emptyStateTitle => 'فارغ';

  @override
  String get emptyRecentDescription => 'ستظهر الملفات المفتوحة مؤخرًا هنا';

  @override
  String get errorLoadingBookmarks =>
      'خطأ في تحميل الملفات المحفوظة في المفضلة';

  @override
  String get emptyBookmarksDescription =>
      'ستظهر المستندات المحفوظة بإشارة مرجعية هنا';

  @override
  String get dialogDeleteTitle => 'حذف الملفات المحددة؟';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'هل تريد حذف $count ملفات؟ لا يمكن التراجع عن هذا الإجراء.',
      one: 'هل تريد حذف ملف واحد؟ لا يمكن التراجع عن هذا الإجراء.',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم حذف $count ملفات',
      one: 'تم حذف ملف واحد',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => 'فشل حذف الملفات';

  @override
  String get actionDelete => 'حذف';

  @override
  String get searchRecentSearchesHeader => 'عمليات البحث الأخيرة';

  @override
  String get actionClear => 'مسح';

  @override
  String get searchPromptTitle => 'اكتب للبحث في المستندات';

  @override
  String get searchPromptMessage =>
      'ابحث في جميع المجلدات المحلية باسم الملف أو امتداده';

  @override
  String get searchError => 'خطأ أثناء البحث في المستندات';

  @override
  String get searchNoResultsTitle => 'لم يتم العثور على مستندات مطابقة';

  @override
  String get searchNoResultsMessage =>
      'جرّب البحث بكلمة مفتاحية أخرى لاسم الملف أو تصفية حسب التنسيق';

  @override
  String get tooltipSortOptions => 'خيارات الفرز';

  @override
  String get sortSheetTitle => 'الفرز حسب';

  @override
  String get sortOptionDate => 'تاريخ التعديل';

  @override
  String get sortOptionName => 'اسم المستند';

  @override
  String get sortOptionSize => 'حجم الملف';

  @override
  String get sortAscendingOrder => 'ترتيب تصاعدي';

  @override
  String get sortAscendingSubtitle => 'الأقدم أولاً / أ إلى ي / الأصغر أولاً';

  @override
  String get sortDescendingSubtitle => 'الأحدث أولاً / ي إلى أ / الأكبر أولاً';

  @override
  String get categoryAllFiles => 'كل الملفات';

  @override
  String get loadingStatus => 'جارٍ التحميل...';

  @override
  String get emptyCategoryImagesTitle => 'لم يتم العثور على صور';

  @override
  String get emptyCategoryImagesMessage =>
      'ستظهر الصور الموجودة على هذا الجهاز هنا';

  @override
  String get emptyCategoryDocsTitle => 'لم يتم العثور على مستندات';

  @override
  String get emptyCategoryDocsMessage =>
      'ستظهر المستندات بهذا التنسيق هنا بعد الفحص';

  @override
  String get actionOpen => 'فتح';

  @override
  String get actionShare => 'مشاركة';

  @override
  String get actionRename => 'إعادة التسمية';

  @override
  String get actionBookmark => 'إضافة إشارة مرجعية';

  @override
  String get actionRemoveBookmark => 'إزالة الإشارة المرجعية';

  @override
  String get actionOpenInAnotherApp => 'فتح في تطبيق آخر';

  @override
  String get actionDetails => 'التفاصيل';

  @override
  String get actionOpenFile => 'فتح الملف';

  @override
  String get actionShareAll => 'مشاركة الكل';

  @override
  String get actionDone => 'تم';

  @override
  String get actionSeeAll => 'عرض الكل';

  @override
  String get actionAllow => 'سماح';

  @override
  String get actionNotNow => 'ليس الآن';

  @override
  String get tooltipMoreActions => 'المزيد من الإجراءات';

  @override
  String get tooltipCopyPath => 'نسخ المسار';

  @override
  String get tooltipRotatePage => 'تدوير الصفحة';

  @override
  String get tooltipRemovePage => 'إزالة الصفحة';

  @override
  String get renameFileTitle => 'إعادة تسمية الملف';

  @override
  String get renameFileNameLabel => 'اسم الملف';

  @override
  String renamedSuccess(String fileName) {
    return 'تمت إعادة التسمية إلى $fileName';
  }

  @override
  String get deleteFileTitle => 'حذف الملف؟';

  @override
  String deleteFileConfirmation(String fileName) {
    return 'هل تريد حذف \"$fileName\"؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return 'تم حذف \"$fileName\"';
  }

  @override
  String get fileDetailsTitle => 'تفاصيل المستند';

  @override
  String get fileDetailsLabelName => 'الاسم';

  @override
  String get fileDetailsLabelType => 'النوع';

  @override
  String get fileDetailsLabelSize => 'الحجم';

  @override
  String get fileDetailsLabelModified => 'تاريخ التعديل';

  @override
  String get fileDetailsLabelBookmarked => 'في المفضلة';

  @override
  String get fileDetailsValueYes => 'نعم';

  @override
  String get fileDetailsValueNo => 'لا';

  @override
  String get fileDetailsLabelLocation => 'الموقع';

  @override
  String get fileDetailsPathCopied => 'تم نسخ المسار إلى الحافظة';

  @override
  String get directoriesTitle => 'المجلدات';

  @override
  String get directoriesGoBack => 'العودة';

  @override
  String get directoriesGoToRoot => 'الانتقال إلى الجذر';

  @override
  String get directoriesRetry => 'إعادة المحاولة';

  @override
  String get directoriesFileNoLongerExists => 'لم يعد الملف موجودًا';

  @override
  String get directoriesFolderNoLongerExists => 'لم يعد هذا المجلد موجودًا.';

  @override
  String get directoriesNoDocsInFolder => 'لا توجد مستندات في هذا المجلد';

  @override
  String get directoriesFilesAppearHere => 'ستظهر الملفات هنا بمجرد إضافتها';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عناصر',
      one: 'عنصر واحد',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => 'مجلد';

  @override
  String get directoriesPermissionPromptTitle => 'يلزم الإذن لعرض المجلدات';

  @override
  String get directoriesPermissionPromptBody =>
      'يحتاج Doc View إلى إذن الوصول إلى جميع الملفات لتصفح مجلداتك.';

  @override
  String get directoriesGrantAccess => 'منح الإذن';

  @override
  String get directoriesImportInstead => 'استيراد الملفات بدلاً من ذلك';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم استيراد $count ملفات',
      one: 'تم استيراد ملف واحد',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => 'مستوى واحد للأعلى';

  @override
  String get storageAccessRequiredTitle => 'مطلوب إذن الوصول إلى التخزين';

  @override
  String get storageAccessRequiredBody =>
      'يحتاج Doc View إلى إذن الوصول إلى وحدة التخزين لفحص وعرض المستندات (PDF وWord وExcel وPPT وTXT والصور) المخزنة على جهازك.\n\nتبقى ملفاتك خاصة تمامًا ودون اتصال بالإنترنت على جهازك.';

  @override
  String errorCouldNotOpenDocument(String error) {
    return 'تعذر فتح المستند: $error';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'اكتمل الفحص: $count ملفات',
      one: 'اكتمل الفحص: ملف واحد',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => 'مسح سجل البحث؟';

  @override
  String get dialogClearSearchMessage =>
      'سيتم مسح جميع عمليات البحث الأخيرة نهائيًا.';

  @override
  String imageListEditorMaxLimit(int max) {
    return 'تم الوصول إلى الحد الأقصى وهو $max صور.';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return 'فشل المسح الضوئي: $error';
  }

  @override
  String get imageListEditorPageSize => 'حجم الصفحة:';

  @override
  String get imageListEditorA4Mode => 'A4';

  @override
  String get imageListEditorFitMode => 'ملاءمة للصورة';

  @override
  String get imageListEditorRemoveImageTooltip => 'إزالة الصورة';

  @override
  String get mergeScreenTitle => 'الترتيب والدمج';

  @override
  String get mergeScreenDefaultMergedName => 'مستند_مدمج';

  @override
  String get mergePickerSearchHint => 'البحث في ملفات PDF...';

  @override
  String get mergePickerNext => 'التالي';

  @override
  String mergePickerErrorLoading(String error) {
    return 'خطأ في تحميل ملفات PDF: $error';
  }

  @override
  String get splitScreenTitle => 'تقسيم PDF';

  @override
  String get splitScreenRangeHint => 'مثال: 1-3, 5, 8-10';

  @override
  String get splitScreenClearRange => 'مسح النطاق';

  @override
  String get splitPickerSearchHint => 'البحث في ملفات PDF...';

  @override
  String splitPickerErrorLoading(String error) {
    return 'خطأ في تحميل الملفات: $error';
  }

  @override
  String get createdSectionTitle => 'من إنشائك';

  @override
  String get createdSectionEmptyTitle => 'تظهر ملفات PDF التي تنشئها هنا';

  @override
  String get createdSectionEmptySubtitle =>
      'سيتم حفظ المستندات المحوّلة أو الممسوحة ضوئيًا أو المدمجة محليًا.';

  @override
  String get emptyCreatedDocsTitle => 'لا توجد مستندات منشأة بعد';

  @override
  String get emptyCreatedDocsMessage =>
      'ستظهر المستندات المحوّلة أو الممسوحة ضوئيًا أو المدمجة هنا.';

  @override
  String errorLoadingCreatedFiles(String error) {
    return 'فشل تحميل الملفات المنشأة: $error';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم إنشاء $count ملفات PDF',
      one: 'تم إنشاء ملف PDF',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle => 'تم الحفظ في مجلد المنشأة';

  @override
  String get toolErrorDefaultTitle => 'تعذر إنشاء ملف PDF';

  @override
  String get toolErrorSubtitle => 'حدث خطأ غير متوقع أثناء المعالجة';

  @override
  String get themeSheetTitle => 'مظهر التطبيق';

  @override
  String get themeSheetSubtitle => 'اختر المظهر المرئي لتطبيق Doc View';

  @override
  String get themeModeSystem => 'النظام';

  @override
  String get themeModeSystemSubtitle => 'الافتراضي';

  @override
  String get themeModeLight => 'فاتح';

  @override
  String get themeModeLightSubtitle => 'أبيض نقي';

  @override
  String get themeModeDark => 'داكن';

  @override
  String get themeModeDarkSubtitle => 'كحلي داكن';

  @override
  String get themeActionApply => 'تطبيق المظهر';

  @override
  String get scanSettingsTitle => 'إعدادات الفحص';

  @override
  String get scanSettingsFrequencyHeader => 'تكرار الفحص';

  @override
  String get scanSettingsOnOpenTitle => 'الفحص عند فتح التطبيق';

  @override
  String get scanSettingsOnOpenSubtitle =>
      'العثور على الملفات الجديدة تلقائيًا عند فتح Doc View.';

  @override
  String get scanSettingsManualTitle => 'يدوي فقط';

  @override
  String get scanSettingsManualSubtitle =>
      'الفحص فقط عند السحب للتحديث أو النقر على إعادة الفحص.';

  @override
  String get scanSettingsMediaFiltersHeader => 'فلاتر الوسائط';

  @override
  String get scanSettingsIncludeImagesTitle => 'تضمين الصور في الفحص';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      'فهرسة ملفات صور PNG وJPG وWEBP في وحدة التخزين.';

  @override
  String get scanSettingsDiagnosticsHeader => 'التخزين والتشخيص';

  @override
  String get scanSettingsPermissionStatus => 'الوصول إلى جميع الملفات';

  @override
  String get scanSettingsPermissionGranted => 'ممنوح';

  @override
  String get scanSettingsPermissionNotGranted => 'غير ممنوح';

  @override
  String get scanSettingsTotalIndexed => 'الملفات المفهرسة';

  @override
  String get scanSettingsLastScan => 'آخر فحص';

  @override
  String get scanSettingsUpdatedSnackbar => 'تم تحديث إعدادات الفحص';

  @override
  String get faqScreenTitle => 'الأسئلة الشائعة';

  @override
  String faqHeaderTopics(int count) {
    return '$count مواضيع';
  }

  @override
  String get faqHeaderSubtitle => 'هل لديك أسئلة؟ اعثر على إجابات واضحة هنا.';

  @override
  String get faqSendFeedback => 'إرسال ملاحظات';

  @override
  String get faqQuestion1 =>
      'لماذا يحتاج Doc View إلى إذن الوصول إلى جميع الملفات؟';

  @override
  String get faqAnswer1 =>
      'يتطلب Doc View إذن الوصول إلى جميع الملفات (MANAGE_EXTERNAL_STORAGE) على Android 11 والأحدث لاكتشاف وفهرسة المستندات المدعومة (PDF وWord وExcel وPowerPoint والنصوص والصور) المخزنة في المجلدات المشتركة مثل التنزيلات والمستندات.\n\nبدون هذا الإذن، يقيّد نظام Android الوصول إلى الملفات ضمن المجلد الداخلي الخاص بالتطبيق فقط، مما يمنع Doc View من تصفح أو فتح الملفات الموجودة في أنحاء جهازك.';

  @override
  String get faqQuestion2 => 'لماذا لا يفحص جهاز iPhone الخاص بي بالكامل؟';

  @override
  String get faqAnswer2 =>
      'يستخدم نظام iOS عزلاً صارمًا للتطبيقات (Sandboxing) لحماية خصوصية الجهاز. لا يمكن للتطبيقات الوصول إلا إلى المستندات المحفوظة صراحةً داخل تطبيق الملفات أو التي تتم مشاركتها عبر قائمة المشاركة في النظام.\n\nلعرض الملفات على iOS، استوردها إلى مجلد Doc View في تطبيق الملفات الأصلي أو استخدم خيار استيراد الملفات في الإعدادات.';

  @override
  String get faqQuestion3 => 'أين تُحفظ ملفات PDF التي أنشئها؟';

  @override
  String get faqAnswer3 =>
      'تُحفظ الملفات التي تستوردها أو تنشئها (مثل ملفات PDF المحوّلة أو المستندات المدمجة أو الصفحات المقسمة) بأمان في وحدة تخزين جهازك ضمن DocView/Created أو في وحدة التخزين الخاصة بالتطبيق. يمكنك عرضها في أي وقت ضمن قسم \"من إنشائك\" في علامة تبويب الأدوات.';

  @override
  String get faqQuestion4 => 'لماذا يبدو ملف Word الخاص بي مختلفًا؟';

  @override
  String get faqAnswer4 =>
      'يعرض Doc View الملفات مباشرة على جهازك باستخدام محللات محلية دون اتصال بالإنترنت دون إرسال بياناتك الخاصة إلى محولات سحابية. قد تُعرض التنسيقات المعقدة أو الأشكال المخصصة بتقريبات محلية دون اتصال.';

  @override
  String get faqQuestion5 => 'هل يمكنني فتح الملفات المحمية بكلمة مرور؟';

  @override
  String get faqAnswer5 =>
      'نعم، يدعم Doc View فتح مستندات PDF المحمية بكلمة مرور. عند فتح ملف PDF مشفر، أدخل كلمة المرور في مربع الحوار لفك تشفير المستند وعرضه على جهازك.';

  @override
  String get faqQuestion6 => 'هل يتم رفع بياناتي إلى أي مكان؟';

  @override
  String get faqAnswer6 =>
      'مستنداتك لا تغادر جهازك أبدًا. يقوم Doc View بفتح الملفات وتحويلها وتخزينها محليًا. يعرض التطبيق إعلانات مقدمة من Google AdMob، والتي قد تستخدم بيانات محدودة عن الجهاز كما هو موضح في سياسة الخصوصية الخاصة بنا.';

  @override
  String get faqQuestion7 => 'لماذا غيّر تحويل PDF إلى Word التنسيق؟';

  @override
  String get faqAnswer7 =>
      'يحوّل Doc View النص فقط على جهازك. ولا يتم الاحتفاظ بالجداول والصور والألوان والتنسيق. لا يمكن تحويل ملفات PDF الممسوحة ضوئيًا لعدم وجود نص يمكن قراءته.';

  @override
  String get toolPdfToWord => 'PDF إلى Word';

  @override
  String get toolPdfToWordSub => 'تحويل PDF إلى مستند Word قابل للتعديل';

  @override
  String get pdfToWordScreenTitle => 'PDF إلى Word';

  @override
  String get pdfToWordBannerText =>
      'يتم تحويل النص فقط. ولا يتم الاحتفاظ بالجداول والصور والألوان والتنسيق.';

  @override
  String get pdfToWordPageBreaks => 'إدراج فواصل صفحات بين صفحات PDF';

  @override
  String get pdfToWordPageBreaksSubtitle =>
      'يحافظ على بنية المستند عبر الصفحات';

  @override
  String get pdfToWordSelectPdf => 'تحديد PDF';

  @override
  String get pdfToWordChangeFile => 'تغيير الملف';

  @override
  String get pdfToWordConvertAction => 'تحويل إلى Word';

  @override
  String get pdfToWordConverting => 'جارٍ التحويل إلى Word...';

  @override
  String pdfToWordConvertingProgress(int current, int total) {
    return 'جارٍ تحويل الصفحة $current من $total...';
  }

  @override
  String get pdfToWordSuccess => 'تم التحويل إلى Word بنجاح';

  @override
  String get pdfToWordOpenInViewer => 'فتح في Doc View';

  @override
  String get pdfToWordOpenWith => 'فتح باستخدام...';

  @override
  String get pdfToWordShare => 'مشاركة';

  @override
  String get pdfToWordNoTextTitle => 'لم يتم العثور على نص';

  @override
  String get pdfToWordNoTextMessage =>
      'لم يتم العثور على نص في ملف PDF هذا. لا يمكن تحويل المستندات الممسوحة ضوئيًا.';

  @override
  String get pdfToWordLargeFileWarning =>
      'مستند كبير: قد يستغرق التحويل عدة دقائق.';

  @override
  String get pdfToWordInvalidFileName => 'اسم الملف غير صالح';

  @override
  String get pdfToWordActionCancel => 'إلغاء';

  @override
  String get pdfToWordEncryptedError =>
      'ملف PDF المحدد محمي بكلمة مرور. يرجى إلغاء قفله للتحويل.';

  @override
  String get pdfToWordPageLimitError => 'يتجاوز المستند حد 1,000 صفحة.';

  @override
  String get pdfToWordTextLimitError => 'يتجاوز المستند حد النص البالغ 20 MB.';

  @override
  String get pdfToWordGeneralError =>
      'فشل تحويل PDF إلى Word. يرجى تجربة ملف آخر.';

  @override
  String get pdfGotoPageTitle => 'الانتقال إلى صفحة';

  @override
  String pdfGotoPageHint(int pageCount) {
    return 'أدخل رقم صفحة بين 1 و$pageCount';
  }

  @override
  String get pdfGotoPageAction => 'انتقال';

  @override
  String get pdfGotoPageErrorEmpty => 'أدخل رقم صفحة';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return 'أدخل رقم صفحة بين 1 و$pageCount';
  }

  @override
  String get pdfPasswordTitle => 'ملف PDF هذا محمي بكلمة مرور';

  @override
  String get pdfPasswordSubtitle =>
      'أدخل كلمة المرور لعرض المحتويات وفك تشفيرها.';

  @override
  String get pdfPasswordHint => 'أدخل كلمة المرور';

  @override
  String get pdfPasswordErrorIncorrect =>
      'كلمة المرور غير صحيحة. حاول مرة أخرى.';

  @override
  String get pdfPasswordActionUnlock => 'إلغاء القفل';

  @override
  String get errorFileNameEmpty => 'لا يمكن أن يكون اسم الملف فارغًا';

  @override
  String get errorFileNameTooLong => 'لا يمكن أن يتجاوز اسم الملف 120 حرفًا';

  @override
  String get errorFileNameReserved =>
      'لا يمكن أن يكون اسم الملف \'.\' أو \'..\'';

  @override
  String get errorFileNameStartsWithDot => 'لا يمكن أن يبدأ اسم الملف بنقطة';

  @override
  String get errorFileNameInvalidChars => 'يحتوي اسم الملف على أحرف غير صالحة';

  @override
  String get errorRenameAlreadyExists =>
      'يوجد ملف بهذا الاسم بالفعل في هذا المجلد';

  @override
  String get errorRenameSourceNotFound =>
      'لم يعد الملف المصدر موجودًا على القرص';

  @override
  String errorRenameFailed(String details) {
    return 'فشل إعادة تسمية الملف: $details';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      'تم حذف الملفات من القرص ولكن فشل تحديث قاعدة البيانات';

  @override
  String errorDeleteFailed(String details) {
    return 'فشل حذف الملفات: $details';
  }

  @override
  String get errorPageRangeDocNoPages => 'لا يحتوي المستند على صفحات';

  @override
  String get errorPageRangeEmpty => 'لا يمكن أن يكون نطاق الصفحات فارغًا';

  @override
  String get errorPageRangeEmptySegment =>
      'تم العثور على جزء نطاق فارغ. أزل الفواصل الزائدة.';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return 'تنسيق نطاق غير صالح: \'$token\'';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return 'نطاق غير مكتمل: \'$token\'';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return 'قيم غير رقمية في النطاق: \'$token\'';
  }

  @override
  String get errorPageRangeBelowMinimum =>
      'يجب أن تكون أرقام الصفحات 1 أو أكبر';

  @override
  String errorPageRangeReversed(int start, int end) {
    return 'نطاق معكوس \'$start-$end\': البداية أكبر من النهاية';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return 'النطاق \'$token\' يتجاوز إجمالي الصفحات ($totalPages)';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return 'رقم صفحة غير صالح: \'$token\'';
  }

  @override
  String get errorImageToPdfNoImages => 'يرجى تحديد صورة واحدة على الأقل';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return 'الحد الأقصى المسموح به هو $max صورة في المرة الواحدة';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return 'فشلت معالجة الصورة: $path';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return 'فشل إنشاء ملف PDF من الصور: $details';
  }

  @override
  String get errorPdfMergeInsufficient => 'يرجى تحديد ملفي PDF على الأقل للدمج';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return 'الملف $fileName محمي بكلمة مرور أو تالف';
  }

  @override
  String get errorPdfMergeNoPages => 'المستندات المحددة لا تحتوي على صفحات';

  @override
  String errorPdfMergeFailed(String details) {
    return 'فشل دمج ملفات PDF: $details';
  }

  @override
  String get errorPdfSplitNoRanges => 'يرجى تحديد نطاق صفحات واحد على الأقل';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return 'الملف $fileName محمي بكلمة مرور أو تالف';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return 'النطاق $start-$end خارج الحدود لملف $fileName';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return 'فشل تقسيم ملف PDF: $details';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return 'صفحة $current/$total';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '($bytes بايت)';
  }

  @override
  String get directoriesProtectedTitle => 'هذا المجلد محمي بواسطة Android.';

  @override
  String get directoriesProtectedDesc =>
      'يقيّد Android الوصول إلى مجلدات النظام والمجلدات الخاصة بالتطبيقات.';

  @override
  String get directoriesNotFoundTitle => 'لم يعد هذا المجلد موجودًا.';

  @override
  String get directoriesEmpty => 'لا توجد ملفات أو مجلدات مدعومة هنا.';

  @override
  String get directoriesErrorOpening => 'خطأ في فتح المجلد';

  @override
  String get directoriesRoot => 'الجذر';

  @override
  String get scanSettingsSectionFrequency => 'تكرار الفحص';

  @override
  String get scanSettingsSectionFilters => 'فلاتر المستندات';

  @override
  String get scanSettingsIncludeImages => 'تضمين الصور';

  @override
  String get scanSettingsIncludeImagesDesc =>
      'أوقف التشغيل لإخفاء آلاف الصور من قائمة مستنداتك';

  @override
  String get scanSettingsImageListUpdated => 'تم تحديث قائمة الصور';

  @override
  String get scanSettingsActionRescanNow => 'إعادة الفحص الآن';

  @override
  String get scanSettingsSectionDiagnostics => 'تشخيص التخزين';

  @override
  String get scanSettingsAllFilesAccessGranted =>
      'تم منح إذن الوصول إلى جميع الملفات';

  @override
  String get scanSettingsAllFilesAccessNeeded =>
      'يلزم إذن الوصول إلى جميع الملفات';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      'يمتلك Doc View إذنًا لاكتشاف الملفات في التنزيلات وبطاقات SD.';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      'الإذن مطلوب لفحص مجلدات التنزيلات والتخزين الخارجي.';

  @override
  String get scanSettingsActionOpenSettings => 'فتح الإعدادات';

  @override
  String scanSettingsScanningFiles(int count) {
    return 'جارٍ الفحص... تم العثور على $count ملفات';
  }

  @override
  String get faqStillNeedHelp => 'هل ما زلت بحاجة إلى مساعدة؟ أرسل ملاحظات';

  @override
  String get toolsLabelFileName => 'اسم الملف';

  @override
  String get toolsAddImagesToStart => 'أضف صورًا للبدء';

  @override
  String get toolsAddImagesDesc =>
      'اختر صورًا أو امسح مستندات ورقية ضوئيًا لإنشاء ملف PDF.';

  @override
  String get toolsChoosePhotos => 'اختيار صور';

  @override
  String get toolsScanPaper => 'مسح ورقة ضوئيًا';

  @override
  String toolsPageNumber(int page) {
    return 'صفحة $page';
  }

  @override
  String get toolsTooltipRotatePage => 'تدوير الصفحة';

  @override
  String get toolsTooltipRemovePage => 'إزالة الصفحة';

  @override
  String get toolsAddMoreScans => 'إضافة المزيد من المسوحات';

  @override
  String get toolsAddMoreImages => 'إضافة المزيد من الصور';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صور · التقدير ~ $size',
      one: 'صورة واحدة · التقدير ~ $size',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return 'تم تحديد $count';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return 'حدد $min ملفات على الأقل';
  }

  @override
  String toolsPagesTotal(int count) {
    return 'إجمالي $count صفحات';
  }

  @override
  String get toolsPagesTotalLabel => 'إجمالي الصفحات';

  @override
  String get toolsNoPdfsFound => 'لم يتم العثور على مستندات PDF';

  @override
  String get semanticBookmarked => 'في المفضلة';

  @override
  String get semanticSelected => 'محدد';

  @override
  String get semanticNotSelected => 'غير محدد';

  @override
  String get actionDeselectFile => 'إلغاء تحديد الملف';

  @override
  String get actionSelectFile => 'تحديد الملف';

  @override
  String get actionCreatePdf => 'إنشاء PDF';

  @override
  String get hintSelectOrViewActions => 'تحديد أو عرض الإجراءات';

  @override
  String get actionClose => 'إغلاق';

  @override
  String get actionReset => 'إعادة تعيين';

  @override
  String get labelPleaseWait => 'يرجى الانتظار...';

  @override
  String get tooltipCloseSearch => 'إغلاق البحث';

  @override
  String get semanticAdvertisement => 'إعلان';

  @override
  String get themePreviewLight => 'فاتح';

  @override
  String get themePreviewNavy => 'كحلي';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '$name، $size، أُنشئ في $date';
  }

  @override
  String get toolsCreatingPdfFromScans => 'جارٍ إنشاء PDF من المسوحات';

  @override
  String get toolsCreatingPdf => 'جارٍ إنشاء PDF';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return 'جارٍ معالجة الصورة $done من $total...';
  }

  @override
  String get toolsErrorCreatePdfTitle => 'تعذر إنشاء ملف PDF';

  @override
  String get toolsBadgeProtectedOrDamaged => 'محمي أو تالف';

  @override
  String toolsPageCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفحات',
      one: 'صفحة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get toolsPagesAbbrev => 'صفحة';

  @override
  String get mergeAddMoreTitle => 'إضافة المزيد من ملفات PDF';

  @override
  String get mergeProgressTitle => 'جارٍ دمج ملفات PDF';

  @override
  String mergeProgressMessage(int done, int total) {
    return 'جارٍ دمج المستند $done من $total...';
  }

  @override
  String get mergeErrorTitle => 'تعذر دمج ملفات PDF';

  @override
  String get mergeDragInstruction => 'اسحب المقابض لإعادة الترتيب';

  @override
  String get mergeAddPdf => 'إضافة PDF';

  @override
  String get mergeOutputFileNameLabel => 'اسم ملف الإخراج';

  @override
  String mergeItemPageCountAndSize(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفحات · $size',
      one: 'صفحة واحدة · $size',
    );
    return '$_temp0';
  }

  @override
  String mergeItemLoadingPagesAndSize(String size) {
    return 'جارٍ تحميل الصفحات... · $size';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم اكتشاف $count ملفات غير صالحة',
      one: 'تم اكتشاف ملف غير صالح',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => 'جاهز للدمج';

  @override
  String get mergeRemoveProtectedHint =>
      'يرجى إزالة المستندات المحمية بكلمة مرور';

  @override
  String mergeSummary(int files, int pages, String size) {
    return '$files ملفات · $pages صفحات · ~ $size';
  }

  @override
  String get mergeReadyBadge => 'جاهز';

  @override
  String get mergeBlockedCta => 'الدمج متوقف (عالج الأخطاء)';

  @override
  String mergeActionCta(int files, int pages) {
    return 'دمج $files ملفات PDF ($pages صفحة)';
  }

  @override
  String get mergePickerDefaultTitle => 'تحديد ملفات PDF';

  @override
  String mergePickerTabAllPdfs(int count) {
    return 'كل ملفات PDF ($count)';
  }

  @override
  String get mergePickerTabRecent => 'الأخيرة';

  @override
  String get mergePickerTabDownloads => 'التنزيلات';

  @override
  String get mergePickerTabICloud => 'iCloud Drive';

  @override
  String get splitProgressTitle => 'جارٍ تقسيم PDF';

  @override
  String splitProgressMessage(int done, int total) {
    return 'جارٍ إنشاء الملف $done من $total...';
  }

  @override
  String get splitErrorTitle => 'تعذر تقسيم ملف PDF';

  @override
  String get splitPageRangesLabel => 'نطاقات الصفحات';

  @override
  String get splitPageRangesSyntax => 'الصيغة: 1-3, 5, 8-10';

  @override
  String get splitRangeHelpText => 'يصبح كل نطاق ملف PDF منفصلاً.';

  @override
  String splitGeneratedFilesHeader(int count) {
    return 'الملفات المُنشأة ($count)';
  }

  @override
  String get splitChipsSuspendedTitle => 'المعاينة المباشرة معلّقة';

  @override
  String get splitChipsSuspendedDesc =>
      'صحّح خطأ الصيغة أعلاه لإعادة بناء مسار الاستخراج.';

  @override
  String get splitEmptyRangesHint =>
      'أدخل نطاقات الصفحات أعلاه لتوليد أجزاء PDF';

  @override
  String splitChipSinglePage(int page) {
    return 'صفحة $page';
  }

  @override
  String splitChipPageRange(int start, int end) {
    return 'الصفحات $start–$end';
  }

  @override
  String splitChipPageCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفحات',
      one: 'صفحة 1',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => 'تحديد سريع';

  @override
  String get splitMacroAllPages => 'كل الصفحات';

  @override
  String get splitMacroEvery5Pages => 'كل 5 صفحات';

  @override
  String get splitMacroLimitHint =>
      'تُعطّل وحدات الماكرو التي تنتج أكثر من 100 ملف لحماية ذاكرة الجهاز';

  @override
  String splitOutputSummary(int files, int pages) {
    return 'الإخراج: $files ملفات · تم استخراج $pages صفحة';
  }

  @override
  String splitEstSize(String size) {
    return 'التقدير ~ $size';
  }

  @override
  String splitActionCtaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تقسيم إلى $count ملفات PDF',
      one: 'تقسيم إلى ملف PDF واحد',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => 'تقسيم إلى ملفات PDF';

  @override
  String splitPickerAllLocalDocs(int count) {
    return 'كل المستندات المحلية ($count)';
  }

  @override
  String get splitPickerSortByDate => 'الفرز حسب التاريخ';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return 'صفحة · $size';
  }

  @override
  String get splitPickerTitle => 'اختر ملف PDF للتقسيم';

  @override
  String get faqShortTitle => 'الأسئلة الشائعة';

  @override
  String splitPickerSelectedCount(int count) {
    return 'تم تحديد $count ملف PDF';
  }

  @override
  String get splitPickerSelectDocumentHint => 'حدد مستندًا للمتابعة';

  @override
  String splitPickerPagesActive(int count) {
    return '$count صفحة نشطة';
  }

  @override
  String get splitPickerPagesActiveLabel => 'صفحة نشطة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSectionGeneral => 'عام';

  @override
  String get settingsSectionOthers => 'أخرى';

  @override
  String get settingsFileManagerTitle => 'مدير الملفات';

  @override
  String get settingsFileManagerSubtitle => 'تصفح أدلة التخزين والمجلدات';

  @override
  String get settingsFaqTitle => 'الأسئلة الشائعة';

  @override
  String get settingsFaqSubtitle => 'الأسئلة المتكررة';

  @override
  String get settingsShareTitle => 'مشاركة';

  @override
  String get settingsShareSubtitle => 'أوصِ أصدقاءك بتطبيق Doc View';

  @override
  String settingsShareMessage(String url) {
    return 'جرّب Doc View - قارئ مستندات سريع وخاص ودون اتصال بالإنترنت: $url';
  }

  @override
  String get settingsScanSettingsTitle => 'إعدادات الفحص';

  @override
  String get settingsScanModeOnOpen => 'الفحص عند الفتح';

  @override
  String get settingsScanModeManual => 'يدوي فقط';

  @override
  String get settingsAppThemeTitle => 'مظهر التطبيق';

  @override
  String get settingsThemeSystem => 'افتراضي النظام';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsLanguageTitle => 'اللغة';

  @override
  String get settingsRateUsTitle => 'قيّمنا';

  @override
  String get settingsRateUsSubtitle => 'شاركنا رأيك وملاحظاتك';

  @override
  String get settingsAddWidgetTitle => 'إضافة أداة (Widget)';

  @override
  String get settingsAddWidgetSubtitle => 'وصول سريع من شاشتك الرئيسية';

  @override
  String get settingsTermsTitle => 'شروط الاستخدام';

  @override
  String get settingsTermsSubtitle => 'اقرأ شروط الخدمة الخاصة بنا';

  @override
  String get settingsPrivacyTitle => 'سياسة الخصوصية';

  @override
  String get settingsPrivacySubtitle => 'اقرأ سياسة الخصوصية الخاصة بنا';

  @override
  String get settingsManageSubscriptionsTitle => 'إدارة الاشتراكات';

  @override
  String get settingsManageSubscriptionsSubtitle => 'إدارة اشتراكك في المتجر';

  @override
  String settingsVersionDisplay(String version, String build) {
    return 'الإصدار $version ($build)';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return 'الإصدار $version البناء $build';
  }

  @override
  String get settingsOpenSourceLicenses => 'تراخيص المصادر المفتوحة';

  @override
  String get rateSheetTitle => 'تقييم Doc View';

  @override
  String get rateSheetSubtitle => 'ملاحظاتك تساعدنا على التحسين';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نجوم',
      one: 'نجمة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => 'سعداء أنه أعجبك!';

  @override
  String get rateResponseMedium => 'شكرًا لك! أخبرنا كيف يمكننا التحسن.';

  @override
  String get rateResponseLow =>
      'نأسف لعدم تلبية توقعاتك. أخبرنا بما يجب إصلاحه.';

  @override
  String get rateActionStore => 'التقييم على Google Play';

  @override
  String get rateActionHelpFeedback => 'المساعدة والملاحظات';

  @override
  String get faqFromRatingBanner =>
      'يؤسفنا سماع ذلك. تصفح الإجابات أدناه أو تواصل معنا؛ نحن نقرأ كل رسالة.';

  @override
  String get faqActionContactUs => 'تواصل معنا';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return 'ملاحظات Doc View ($version+$build)';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '\n\n---\nالتطبيق: Doc View $version (البناء $build)\n';
  }

  @override
  String get faqEmailClientUnavailable => 'تعذر فتح تطبيق البريد الإلكتروني';

  @override
  String get languageScreenTitle => 'اللغة';

  @override
  String get languageSearchHint => 'البحث عن اللغات...';

  @override
  String get languageSystemDefault => 'افتراضي النظام';

  @override
  String get languageSystemDefaultSubtitle => 'اتباع لغة الجهاز';

  @override
  String get languageNotTranslatedBadge => '(غير مترجمة)';

  @override
  String get languageNotTranslatedSnack => 'هذه اللغة غير مترجمة بعد';

  @override
  String get languageNoResults => 'لا توجد لغات مطابقة';

  @override
  String get languagePseudoLocaleName => 'لغة تجريبية (en_XA)';

  @override
  String get languagePseudoLocaleSubtitle => 'اختبار تمدد النصوص للتصحيح';

  @override
  String get scanSettingsSectionHistory => 'السجل';

  @override
  String get scanSettingsClearHistoryTitle => 'مسح السجل الأخير';

  @override
  String get scanSettingsClearHistorySubtitle => 'مسح سجل المستندات المفتوحة';

  @override
  String get scanSettingsClearHistoryDialogTitle => 'مسح السجل الأخير؟';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      'ستتم إزالة الملفات من قائمة الأخيرة. لن تتأثر ملفاتك وإشاراتك المرجعية.';

  @override
  String get scanSettingsRecentHistoryCleared => 'تم مسح السجل الأخير';

  @override
  String get scanSettingsLastScanToday => 'اليوم';

  @override
  String get scanSettingsLastScanYesterday => 'أمس';

  @override
  String get scanSettingsNeverScanned => 'لم يُفحص أبدًا';

  @override
  String get scanSettingsLastScanPrefix => 'آخر فحص:';

  @override
  String get readerActionVertical => 'عمودي';

  @override
  String get readerActionHorizontal => 'أفقي';

  @override
  String get readerActionRotate => 'تدوير';

  @override
  String get readerActionSearch => 'بحث';

  @override
  String get readerActionInvert => 'عكس الألوان';

  @override
  String get readerActionShare => 'مشاركة';

  @override
  String get readerActionPages => 'الصفحات';

  @override
  String get readerSearchHint => 'ابحث في المستند...';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '$current من $total';
  }

  @override
  String get readerSearchMatchCap => '+500';

  @override
  String get readerSearchNoMatches => '0 من 0';

  @override
  String get readerSearchNoTextLayer =>
      'ملف PDF هذا لا يحتوي على نص قابل للبحث';

  @override
  String get readerSearchPrevMatch => 'النتيجة السابقة';

  @override
  String get readerSearchNextMatch => 'النتيجة التالية';

  @override
  String readerTopPagesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفحات • $size',
      one: 'صفحة واحدة • $size',
    );
    return '$_temp0';
  }

  @override
  String get readerMenuGoToPage => 'الانتقال إلى صفحة';

  @override
  String get readerMenuAddBookmark => 'إضافة إشارة مرجعية';

  @override
  String get readerMenuRemoveBookmark => 'إزالة الإشارة المرجعية';

  @override
  String get readerMenuDetails => 'التفاصيل';

  @override
  String get readerMenuOpenInAnotherApp => 'فتح في تطبيق آخر';

  @override
  String get readerTooltipConvertToWord => 'تحويل إلى Word';

  @override
  String get pagesScreenTitle => 'الصفحات';

  @override
  String pagesScreenPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفحات',
      one: 'صفحة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get pagesActionSelectAll => 'تحديد الكل';

  @override
  String get pagesActionClearSelection => 'مسح';

  @override
  String get pagesActionSave => 'حفظ';

  @override
  String get pagesActionInsert => 'إدراج';

  @override
  String get pagesActionRotate => 'تدوير';

  @override
  String get pagesActionExtract => 'استخراج';

  @override
  String get pagesActionDelete => 'حذف';

  @override
  String get pagesActionUndo => 'تراجع';

  @override
  String get pagesInsertSheetTitle => 'إدراج صفحات';

  @override
  String get pagesInsertPagesFromPdf => 'صفحات من ملف PDF آخر';

  @override
  String get pagesDeleteAllBlocked =>
      'لا يمكن حذف جميع الصفحات. يجب أن يحتوي المستند على صفحة واحدة على الأقل.';

  @override
  String get pagesSaveDialogTitle => 'حفظ التغييرات';

  @override
  String get pagesSaveAsNew => 'حفظ كملف جديد';

  @override
  String get pagesSaveReplace => 'استبدال الأصل';

  @override
  String get pagesSaveReplaceWarning =>
      'سيؤدي هذا إلى الكتابة فوق الملف الأصلي.';

  @override
  String get pagesSaveFileNameLabel => 'اسم الملف';

  @override
  String get pagesDiscardDialogTitle => 'تجاهل التغييرات؟';

  @override
  String get pagesDiscardDialogBody =>
      'لديك تغييرات غير محفوظة. هل أنت متأكد أنك تريد تجاهلها؟';

  @override
  String get pagesDiscardButton => 'تجاهل';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفحات',
      one: 'صفحة واحدة',
    );
    return 'تم استخراج $_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      'لا يمكن تعديل ملف PDF هذا لأنه مشفر أو غير قابل للقراءة.';

  @override
  String get viewerErrorCorruptTitle => 'تعذر فتح هذا المستند';

  @override
  String get viewerErrorCorruptMessage =>
      'يبدو أن هذا الملف تالف أو ليس مستندًا صالحًا.';

  @override
  String get viewerErrorMissingTitle => 'لم يعد هذا الملف موجودًا';

  @override
  String get viewerErrorMissingMessage =>
      'تم حذف الملف أو نقله من وحدة تخزين الجهاز.';

  @override
  String get viewerErrorBackToFiles => 'العودة إلى الملفات';

  @override
  String get viewerErrorNoAppFound => 'لم يتم العثور على تطبيق لفتح هذا الملف';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتائج',
      one: 'نتيجة واحدة',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count وحدات • $ext',
      one: 'وحدة واحدة • $ext',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner => 'تنسيق قديم: نص فقط';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      'مصنف كبير: يتم عرض أول 20,000 صف و100 عمود';

  @override
  String viewerSectionTitle(int number) {
    return 'القسم $number';
  }

  @override
  String get viewerMenuOutline => 'المخطط التفصيلي';

  @override
  String get viewerOutlineTitle => 'المخطط التفصيلي للمستند';

  @override
  String get viewerCloseOutline => 'إغلاق المخطط التفصيلي';

  @override
  String get viewerNoSections => 'لم يتم العثور على أقسام في هذا المستند';

  @override
  String get viewerOutlineTooltip => 'جدول المحتويات';

  @override
  String get viewerActionOpenExternal => 'فتح في تطبيق آخر';

  @override
  String get viewerErrorCantOpenTitle => 'تعذر فتح هذا المستند';

  @override
  String get viewerErrorCantOpenMessage =>
      'تعذر عرض المستند دون اتصال بالإنترنت.';

  @override
  String get viewerOpeningDocument => 'جارٍ فتح المستند...';

  @override
  String get viewerErrorEncryptedTitle => 'هذا المستند مشفر';

  @override
  String get viewerErrorEncryptedMessage =>
      'لا يمكن عرض الملفات المحمية بكلمة مرور في القارئ دون اتصال.';

  @override
  String get viewerErrorTooLargeTitle => 'يتجاوز هذا الملف حد العرض';

  @override
  String get viewerErrorTooLargeMessage =>
      'ينبغي فتح المستندات الكبيرة باستخدام عارض Office خارجي.';

  @override
  String get viewerErrorUnsupportedFormatTitle => 'هذا التنسيق غير مدعوم';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      'لا يمكن لتطبيق Doc View تحليل تنسيق الملف هذا مباشرةً.';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عناصر',
      one: 'عنصر واحد',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => 'الخط والتنسيق';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '$size نقطة';
  }

  @override
  String get txtViewerMonospaceLabel => 'خط أحادي العرض';

  @override
  String get txtViewerTruncationBanner =>
      'حجم الملف أكبر من 1 MB: يتم عرض أول 1 MB';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سطور • $size',
      one: 'سطر واحد • $size',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => 'إعدادات الخط والتنسيق';

  @override
  String get txtViewerTooltipDecreaseFont => 'تصغير حجم الخط';

  @override
  String get txtViewerTooltipIncreaseFont => 'تكبير حجم الخط';

  @override
  String get txtViewerTooltipToggleMonospace => 'تبديل الخط أحادي العرض';

  @override
  String get txtViewerMonospaceSubtitle =>
      'أحرف ثابتة العرض للشيفرات البرمجية والسجلات';

  @override
  String get txtViewerPreviewLabel => 'معاينة';

  @override
  String get txtViewerPreviewText => 'أبجد هوز حطي كلمن سعفص قرشت ثخذ ضظغ.';

  @override
  String get txtViewerErrorTitle => 'تعذر قراءة هذا الملف النصي';

  @override
  String get txtViewerErrorMessage => 'تعذر تحليل تنسيق الملف أو ترميزه.';

  @override
  String get txtViewerActionRetry => 'إعادة المحاولة';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '$width × $height • $size';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get imageViewerTooltipFitToScreen => 'ملاءمة للشاشة';

  @override
  String get imageViewerErrorCorrupt => 'تعذر تحميل الصورة';

  @override
  String get imageViewerLoading => 'جارٍ تحميل الصورة…';

  @override
  String get viewerDispatcherFileMissing => 'لم يعد الملف موجودًا';

  @override
  String get viewerSpreadsheetFormulaBarEmpty => '-';

  @override
  String get viewerSpreadsheetAllCells => 'الكل';

  @override
  String viewerSpreadsheetColumnLabel(String col) {
    return 'العمود $col';
  }

  @override
  String viewerSpreadsheetRowLabel(int row) {
    return 'الصف $row';
  }

  @override
  String viewerSpreadsheetCellSemantics(String col, int row, String value) {
    return 'العمود $col، الصف $row، $value';
  }

  @override
  String get viewerSpreadsheetEmptyCell => 'فارغة';

  @override
  String get viewerSpreadsheetEmptySheet => 'هذه الورقة فارغة';

  @override
  String get viewerSpreadsheetCopiedSingle => 'تم نسخ الخلية';

  @override
  String viewerSpreadsheetCopiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم نسخ $count خلايا',
      one: 'تم نسخ خلية واحدة',
    );
    return '$_temp0';
  }

  @override
  String get viewerSpreadsheetCopyLimitReached =>
      'تم اقتصار التحديد على 5,000 خلية';

  @override
  String get viewerSpreadsheetCellContentTitle => 'محتوى الخلية';

  @override
  String get viewerSpreadsheetCopyAction => 'نسخ';

  @override
  String get viewerSpreadsheetCloseAction => 'إغلاق';

  @override
  String viewerSpreadsheetZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get viewerSpreadsheetResetZoomTooltip =>
      'إعادة تعيين التكبير إلى 100%';

  @override
  String get viewerSpreadsheetNoMatches => 'لا توجد نتائج مطابقة في هذه الورقة';

  @override
  String get viewerSpreadsheetSearchPlaceholder => 'البحث في الورقة…';

  @override
  String get viewerSpreadsheetPasswordTitle => 'ملف محمي بكلمة مرور';

  @override
  String get viewerSpreadsheetPasswordMessage =>
      'لا يمكن فتح الملفات المحمية بكلمة مرور هنا.';

  @override
  String get viewerSpreadsheetErrorTitle => 'تعذر قراءة جدول البيانات هذا';

  @override
  String get viewerSpreadsheetCorruptMessage =>
      'ملف جدول البيانات تالف أو تعذر فك ترميزه.';

  @override
  String get viewerSpreadsheetTimeoutMessage =>
      'انتهت مهلة فتح جدول البيانات بعد 20 ثانية.';

  @override
  String get viewerSpreadsheetTooLargeMessage =>
      'يتجاوز هذا الملف حد العرض البالغ 25 MB.';

  @override
  String get viewerSpreadsheetOpenBasicViewer => 'فتح في العارض الأساسي';

  @override
  String get viewerSpreadsheetOpenAnotherApp => 'فتح في تطبيق آخر';

  @override
  String get toolsWorkspaceOverline => 'مساحة العمل';

  @override
  String get toolsTitle => 'الأدوات';

  @override
  String get toolsSectionConvertCreate => 'التحويل والإنشاء';

  @override
  String get toolsSectionEditManage => 'التحرير والإدارة';

  @override
  String get toolsSectionOthers => 'أخرى';

  @override
  String get toolsCreatedByYou => 'من إنشائك';

  @override
  String get toolsCreatedByYouEmpty => 'تظهر ملفات PDF التي تنشئها هنا';

  @override
  String get toolsCreatedByYouSeeAll => 'عرض الكل';

  @override
  String get toolManagePages => 'إدارة الصفحات';

  @override
  String get toolManagePagesSub => 'إعادة الترتيب والتدوير والحذف';

  @override
  String get toolImportFiles => 'استيراد الملفات';

  @override
  String get toolImportFilesSub => 'إضافة من تطبيقات أخرى';

  @override
  String get toolPrintPdf => 'طباعة PDF';

  @override
  String get toolPrintPdfSub => 'الإرسال إلى أي طابعة';

  @override
  String get toolCreatePdf => 'إنشاء PDF';

  @override
  String get toolCreatePdfSub => 'مستند فارغ أو قالب';

  @override
  String get toolRecycleBin => 'سلة المحذوفات';

  @override
  String get toolRecycleBinSub => 'استعادة الملفات المحذوفة';

  @override
  String get toolAnnotate => 'التعليق والتظليل';

  @override
  String get toolAnnotateSub => 'تظليل ورسم وتعليم';

  @override
  String get toolAddText => 'إضافة نص';

  @override
  String get toolAddTextSub => 'إدراج نصوص وتواريخ';

  @override
  String get toolSign => 'توقيع';

  @override
  String get toolSignSub => 'تعبئة النماذج وتوقيعها';

  @override
  String get toolWordToPdf => 'Word إلى PDF';

  @override
  String get toolWordToPdfSub => 'تحويل DOCX إلى PDF';

  @override
  String get toolPptToPdf => 'PPT إلى PDF';

  @override
  String get toolPptToPdfSub => 'تحويل PPTX إلى PDF';

  @override
  String get printPdfErrorTooLarge => 'يتجاوز ملف PDF حد الطباعة البالغ 50 MB.';

  @override
  String get printPdfErrorUnreadable => 'تعذرت قراءة ملف PDF للطباعة.';

  @override
  String get printPdfErrorPassword =>
      'لا يمكن طباعة ملف PDF المحمي بكلمة مرور مباشرة.';

  @override
  String get printPdfErrorFailed => 'فشلت الطباعة.';

  @override
  String get printPdfSuccess => 'تم إرسال المستند إلى الطابعة.';

  @override
  String get toolPickerTitleSelectPdf => 'تحديد PDF';

  @override
  String get toolPickerTitleSelectPdfs => 'تحديد ملفات PDF';

  @override
  String get toolPickerBrowseFiles => 'تصفح الملفات';

  @override
  String get toolPickerTabAll => 'كل ملفات PDF';

  @override
  String get toolPickerTabRecent => 'الأخيرة';

  @override
  String get toolPickerTabDownloads => 'التنزيلات';

  @override
  String get toolPickerTabICloud => 'iCloud Drive';

  @override
  String get toolPickerActionPrint => 'طباعة';

  @override
  String get toolPickerActionManage => 'إدارة';

  @override
  String get toolPickerActionSelect => 'تحديد';

  @override
  String get toolsImportActionView => 'عرض';

  @override
  String get createPdfTemplateBlank => 'فارغ';

  @override
  String get createPdfTemplateLine1 => 'سطور 1';

  @override
  String get createPdfTemplateLine2 => 'سطور 2';

  @override
  String get createPdfTemplateNotebook => 'دفتر ملاحظات';

  @override
  String get createPdfTemplateCornell => 'كورنيل';

  @override
  String get createPdfTemplateGrid => 'شبكة';

  @override
  String get createPdfTemplateGraph => 'رسم بياني';

  @override
  String get createPdfSwatchWhite => 'أبيض';

  @override
  String get createPdfSwatchCream => 'كريمي';

  @override
  String get createPdfSwatchLightYellow => 'أصفر فاتح';

  @override
  String get createPdfSwatchLightPeach => 'خوخي فاتح';

  @override
  String get createPdfSwatchLightPink => 'وردي فاتح';

  @override
  String get createPdfSwatchLightLavender => 'أرجواني فاتح';

  @override
  String get createPdfSwatchLightBlue => 'أزرق فاتح';

  @override
  String get createPdfSwatchLightMint => 'نعناعي فاتح';

  @override
  String get createPdfSwatchLightGreen => 'أخضر فاتح';

  @override
  String get createPdfSwatchLightGray => 'رمادي فاتح';

  @override
  String get createPdfOrientationPortrait => 'عمودي';

  @override
  String get createPdfOrientationLandscape => 'أفقي';

  @override
  String get createPdfSectionTemplate => 'القالب';

  @override
  String get createPdfSectionPageSize => 'حجم الصفحة';

  @override
  String get createPdfSectionOrientation => 'الاتجاه';

  @override
  String get createPdfSectionPageColor => 'لون الصفحة';

  @override
  String get createPdfSectionPageCount => 'عدد الصفحات';

  @override
  String createPdfPagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفحات',
      one: 'صفحة واحدة',
    );
    return '$_temp0';
  }

  @override
  String createPdfSummary(String pages, String size, String orientation) {
    return '$pages • $size • $orientation';
  }

  @override
  String get createPdfCreating => 'جارٍ إنشاء PDF...';

  @override
  String createPdfProgress(int done, int total) {
    return 'جارٍ بناء الصفحة $done من $total...';
  }

  @override
  String get createPdfErrorTitle => 'تعذر إنشاء PDF';

  @override
  String get createPdfErrorPageCount => 'يجب أن يكون عدد الصفحات بين 1 و100.';

  @override
  String get createPdfErrorInvalidName => 'يرجى إدخال اسم ملف صالح.';

  @override
  String get createPdfErrorGeneration =>
      'فشل إنشاء مستند PDF. يرجى المحاولة مرة أخرى.';

  @override
  String get trashErrorTooLarge =>
      'الملف كبير جدًا على سلة المحذوفات (الحد الأقصى 200 MB)';

  @override
  String get trashErrorNotEnoughSpace =>
      'لا توجد مساحة تخزين كافية في سلة المحذوفات';

  @override
  String trashErrorGeneric(String details) {
    return 'فشلت عملية سلة المحذوفات: $details';
  }

  @override
  String get trashDialogMoveTitle => 'النقل إلى سلة المحذوفات؟';

  @override
  String trashDialogMoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'نقل $count ملفات إلى سلة المحذوفات؟ يمكنك استعادتها من الأدوات > سلة المحذوفات لمدة 30 يومًا.',
      one:
          'نقل ملف واحد إلى سلة المحذوفات؟ يمكنك استعادته من الأدوات > سلة المحذوفات لمدة 30 يومًا.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionMove => 'نقل إلى سلة المحذوفات';

  @override
  String trashMovedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم نقل $count ملفات إلى سلة المحذوفات',
      one: 'تم نقل ملف واحد إلى سلة المحذوفات',
    );
    return '$_temp0';
  }

  @override
  String get trashActionUndo => 'تراجع';

  @override
  String trashRestoredSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت استعادة $count ملفات',
      one: 'تمت استعادة ملف واحد',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogDeleteForeverTitle => 'الحذف نهائيًا؟';

  @override
  String trashDialogDeleteForeverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حذف $count ملفات نهائيًا؟ لا يمكن التراجع عن هذا الإجراء.',
      one: 'حذف ملف واحد نهائيًا؟ لا يمكن التراجع عن هذا الإجراء.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionDeleteForever => 'حذف نهائيًا';

  @override
  String trashDeletedForeverSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم حذف $count ملفات نهائيًا',
      one: 'تم حذف ملف واحد نهائيًا',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogEmptyTitle => 'إفراغ سلة المحذوفات؟';

  @override
  String trashDialogEmptyBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ملفات',
      one: 'ملف واحد',
    );
    return 'حذف كل $_temp0 نهائيًا؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get trashActionEmptyBin => 'إفراغ السلة';

  @override
  String get trashEmptyTitle => 'سلة المحذوفات فارغة';

  @override
  String get trashEmptySubtitle =>
      'ستبقى الملفات المنقولة إلى سلة المحذوفات هنا لمدة 30 يومًا قبل حذفها نهائيًا.';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'متبقي $count أيام',
      one: 'متبقي يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String trashSubtitle(String date, String size) {
    return 'حُذف في $date · $size';
  }

  @override
  String get trashDialogTooLargeTitle => 'كبير جدًا على سلة المحذوفات';

  @override
  String trashDialogTooLargeBody(String fileName) {
    return 'حجم \"$fileName\" أكبر من 200 MB ولا يمكن نقله إلى سلة المحذوفات. هل تريد حذفه نهائيًا؟';
  }

  @override
  String get trashActionDeletePermanently => 'حذف نهائيًا';

  @override
  String get trashInfoBanner =>
      'تُحذف العناصر الموجودة في سلة المحذوفات نهائيًا بعد 30 يومًا.';

  @override
  String get trashSheetRestore => 'استعادة';

  @override
  String get trashSheetDeleteForever => 'حذف نهائيًا';

  @override
  String get trashSheetDetails => 'التفاصيل';

  @override
  String get trashDetailsOriginalLocation => 'الموقع الأصلي';

  @override
  String get trashDetailsDateDeleted => 'تاريخ الحذف';

  @override
  String get trashDetailsExpiresIn => 'تنتهي صلاحيته خلال';

  @override
  String trashRestoredToFallbackSuccess(String location) {
    return 'تمت الاستعادة إلى $location (لم يتم العثور على المجلد الأصلي)';
  }

  @override
  String get trashDialogCopyFailedTitle => 'تعذر النقل إلى سلة المحذوفات';

  @override
  String trashDialogCopyFailedBody(String fileName) {
    return 'تعذر نقل \"$fileName\" إلى سلة المحذوفات. هل تريد حذفه نهائيًا؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get trashDialogEmptyProgress => 'جارٍ إفراغ سلة المحذوفات...';

  @override
  String get trashDialogMoveProgress => 'جارٍ نقل الملفات إلى سلة المحذوفات...';

  @override
  String get trashDialogNotEnoughSpaceTitle => 'لا توجد مساحة تخزين كافية';

  @override
  String get trashDialogNotEnoughSpaceBody =>
      'لا توجد مساحة تخزين كافية للنقل إلى سلة المحذوفات. أفرغ السلة لتوفير مساحة.';

  @override
  String get trashActionFreeUpSpace => 'تحرير مساحة';

  @override
  String get trashDialogDeleteForeverProgress => 'جارٍ حذف الملفات نهائيًا...';

  @override
  String get galleryDebugAgeTrash => 'تعتيق كل عناصر السلة بمقدار 29 يومًا';

  @override
  String get galleryDebugSlowCopy => 'نسخ بطيء للسلة (اختبار)';

  @override
  String get galleryDebugSlowCopySubtitle =>
      'يبطئ حلقة النسخ إلى ~20 MB/ث لاختبار الإيقاف القسري';

  @override
  String get galleryDebugSlowSave => 'حفظ بطيء للمحرر (اختبار)';

  @override
  String get galleryDebugSlowSaveSubtitle =>
      'يبطئ حلقة الحفظ إلى ~8 ثوانٍ لاختبار الإيقاف القسري';

  @override
  String get galleryDebugSaveAnnotate => 'حفظ عينة 100 صفحة (اختبار التعليق)';

  @override
  String get galleryDebugSaveSign => 'حفظ عينة 100 صفحة (اختبار التوقيع)';

  @override
  String get galleryDebugSaveText => 'حفظ عينة 100 صفحة (اختبار إضافة نص)';

  @override
  String get galleryDebugMove190Mb => 'نقل ملف اختبار 190 MB إلى السلة';

  @override
  String get galleryDebugRestoreLastTrash => 'استعادة آخر عنصر في السلة';

  @override
  String get galleryDebugEmptyTrash => 'إفراغ سلة المحذوفات';

  @override
  String galleryDebugAgeTrashSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عناصر',
      one: 'عنصر واحد',
    );
    return 'تم تعتيق $_temp0 بمقدار 29 يومًا';
  }

  @override
  String get annotateErrorPasswordProtected => 'ملف PDF هذا محمي بكلمة مرور.';

  @override
  String get annotateErrorCorrupt => 'ملف PDF هذا تالف أو لا يمكن قراءته.';

  @override
  String get annotateSignedReplaceBlocked =>
      'لا يُسمح باستبدال ملف PDF الموقع الأصلي. يرجى الحفظ كملف جديد.';

  @override
  String annotateErrorSaveFailed(String details) {
    return 'فشل حفظ التعليقات التوضيحية: $details';
  }

  @override
  String get annotateErrorScannedPdf =>
      'يبدو أن هذا المستند ممسوح ضوئيًا أو لا يحتوي على نص قابل للتحديد.';

  @override
  String get annotateSignedBanner =>
      'ملف PDF موقع رقميًا: سيؤدي الحفظ إلى إنشاء نسخة جديدة للحفاظ على التوقيع.';

  @override
  String get annotateActionSaveNew => 'حفظ كملف جديد';

  @override
  String get annotateActionReplace => 'استبدال الأصل';

  @override
  String get annotateDiscardDialogTitle => 'تجاهل التعليقات غير المحفوظة؟';

  @override
  String get annotateDiscardDialogBody =>
      'لديك تعديلات غير محفوظة. إذا خرجت الآن، فستفقد تغييراتك.';

  @override
  String get annotateDiscardDialogActionDiscard => 'تجاهل';

  @override
  String get annotateDiscardDialogActionKeep => 'متابعة التحرير';

  @override
  String get annotateSaveSuccess => 'تم حفظ التعليقات التوضيحية بنجاح';

  @override
  String get annotateToolbarHighlight => 'تظليل';

  @override
  String get annotateToolbarUnderline => 'تسطير';

  @override
  String get annotateToolbarStrikethrough => 'يتوسطه خط';

  @override
  String get annotateToolbarCopy => 'نسخ';

  @override
  String get annotateColorYellow => 'أصفر';

  @override
  String get annotateColorGreen => 'أخضر';

  @override
  String get annotateColorCyan => 'سماوي';

  @override
  String get annotateColorPink => 'وردي';

  @override
  String get annotateColorOrange => 'برتقالي';

  @override
  String get annotateSaveTitle => 'حفظ التعليقات التوضيحية';

  @override
  String get annotateSaveProgress => 'جارٍ حفظ التعليقات التوضيحية...';

  @override
  String get annotateNoChanges => 'لا توجد تعليقات توضيحية للحفظ';

  @override
  String get annotateTooltipUndo => 'تراجع';

  @override
  String get annotateTooltipRedo => 'إعادة';

  @override
  String get annotateTooltipSave => 'حفظ';

  @override
  String get annotateCopiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get annotateToolbarPen => 'قلم';

  @override
  String get annotatePenTipBanner =>
      'ارسم بإصبع واحد. حرّك الصفحة وكبّرها بإصبعين.';

  @override
  String get annotatePenSheetTitle => 'إعدادات القلم';

  @override
  String get annotatePenStrokeWidth => 'سُمك الخط';

  @override
  String get annotatePenEraserMode => 'ممحاة';

  @override
  String get annotateColorBlack => 'أسود';

  @override
  String get annotateColorRed => 'أحمر';

  @override
  String get annotateColorPurple => 'بنفسجي';

  @override
  String get annotateColorBlue => 'أزرق';

  @override
  String get toolSignPdf => 'توقيع PDF';

  @override
  String get toolSignPdfSubtitle => 'إضافة التوقيع والتاريخ إلى المستندات';

  @override
  String get signToolbarSign => 'توقيع';

  @override
  String get signToolbarDate => 'تاريخ';

  @override
  String get signToolbarClearAll => 'مسح الكل';

  @override
  String get signPadTitle => 'ارسم توقيعك';

  @override
  String get signPadClear => 'مسح';

  @override
  String get signPadSave => 'حفظ التوقيع';

  @override
  String get signSheetTitle => 'التوقيعات المحفوظة';

  @override
  String get signSheetCreateNew => 'إنشاء توقيع جديد';

  @override
  String get signMaxSignaturesReached =>
      'تم الوصول إلى الحد الأقصى وهو 5 توقيعات محفوظة';

  @override
  String get signMaxPlacedReached =>
      'تم الوصول إلى الحد الأقصى وهو 20 توقيعًا لكل مستند';

  @override
  String get signDeleteSignatureTitle => 'حذف التوقيع؟';

  @override
  String get signDeleteSignatureBody =>
      'ستتم إزالة هذا التوقيع من توقيعاتك المحفوظة.';

  @override
  String get signConfirmClearAllTitle => 'مسح جميع التوقيعات؟';

  @override
  String get signConfirmClearAllBody =>
      'ستتم إزالة جميع التوقيعات والتواريخ الموضوعة على هذا المستند.';

  @override
  String get signSaveSuccess => 'تم توقيع المستند بنجاح';

  @override
  String get signNoSignaturesToSave => 'لم يتم وضع أي توقيعات على المستند';

  @override
  String get signPlacedSignatureDelete => 'حذف';

  @override
  String get signPlacedSignatureApply => 'تطبيق';

  @override
  String get signTooltipUndo => 'تراجع';

  @override
  String get signTooltipRedo => 'إعادة';

  @override
  String get signTooltipSave => 'حفظ';

  @override
  String annotatePenStrokeWidthValue(String width) {
    return '$width نقطة';
  }

  @override
  String get annotateErrorTooManyStrokes =>
      'وصل المستند إلى الحد الأقصى البالغ 5,000 خط أو 300,000 نقطة.';

  @override
  String annotateChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تغييرات',
      one: 'تغيير واحد',
    );
    return '$_temp0';
  }

  @override
  String get annotatePenNotice =>
      'تصبح خطوط القلم جزءًا من الصفحة عند الحفظ ولا يمكن تعديلها لاحقًا.';

  @override
  String get annotatePenNoticeDismiss => 'حسنًا';

  @override
  String get signPadBaselineHint => 'وقّع هنا';

  @override
  String get signPadUndo => 'تراجع';

  @override
  String get signPadUseOnce => 'استخدام لمرة واحدة';

  @override
  String get signPadSaveAndUse => 'حفظ واستخدام';

  @override
  String get tool_add_text => 'إضافة نص';

  @override
  String get tool_add_text_desc => 'إدراج مربعات نص وملاحظات على الصفحات';

  @override
  String get addTextNoticePermanent =>
      'يصبح النص المضاف جزءًا من الصفحة ولا يمكن تعديله بعد الحفظ.';

  @override
  String get addTextNoticeRaster =>
      'يُضاف النص بهذه اللغة كصورة ولا يمكن تحديده.';

  @override
  String get addTextNoticeGotIt => 'حسنًا';

  @override
  String get addTextActionAdd => 'إضافة نص';

  @override
  String get addTextActionStyle => 'النمط';

  @override
  String get addTextActionDelete => 'حذف';

  @override
  String get addTextStyleSheetTitle => 'نمط النص';

  @override
  String get addTextFontSize => 'حجم الخط';

  @override
  String get addTextColor => 'اللون';

  @override
  String get addTextStyle => 'النمط';

  @override
  String get addTextAlign => 'المحاذاة';

  @override
  String get addTextBold => 'عريض';

  @override
  String get addTextItalic => 'مائل';

  @override
  String get addTextAlignStart => 'البداية';

  @override
  String get addTextAlignCenter => 'الوسط';

  @override
  String get addTextAlignEnd => 'النهاية';

  @override
  String get addTextErrorTooManyBoxes =>
      'تم الوصول إلى الحد الأقصى وهو 30 مربع نص';

  @override
  String get addTextErrorBoxTooLong => 'لا يمكن أن يتجاوز مربع النص 2,000 حرف';

  @override
  String get addTextPlaceholder => 'اكتب النص هنا';

  @override
  String get addTextSamplePreview => 'معاينة نموذجية';

  @override
  String addTextFontSizePt(int size) {
    return '$size نقطة';
  }

  @override
  String get premiumTitle => 'Doc View Premium';

  @override
  String get premiumSubtitle =>
      'افتح أدوات التعليق والتوقيع واستمتع بتجربة خالية تمامًا من الإعلانات.';

  @override
  String get premiumFeatureAllTools => 'أدوات التعليق وتوقيع PDF';

  @override
  String get premiumFeatureAllToolsSub =>
      'ارسم الملاحظات وظلّل المستندات ووقّع ملفات PDF بسهولة';

  @override
  String get premiumFeatureAdFree => 'تجربة خالية من الإعلانات 100%';

  @override
  String get premiumFeatureAdFreeSub =>
      'لا بانرات أو مقاطعات أو تشتيت في أي مكان';

  @override
  String get premiumFeatureUnlimitedConversions => 'تحويلات محلية غير محدودة';

  @override
  String get premiumFeatureUnlimitedConversionsSub =>
      'حوّل المستندات على جهازك دون أي حدود للملفات';

  @override
  String get premiumFeaturePrivacyFirst => 'خصوصية 100% وعلى جهازك';

  @override
  String get premiumFeaturePrivacyFirstSub =>
      'تُعالج الملفات محليًا ولا تُرفع أبدًا إلى أي خادم';

  @override
  String get premiumPlanYearly => 'اشتراك سنوي';

  @override
  String premiumPlanYearlyTrial(int days, String price) {
    return '$days أيام مجانًا، ثم $price/سنة';
  }

  @override
  String get premiumPlanMonthly => 'اشتراك شهري';

  @override
  String premiumPlanMonthlySub(String price) {
    return '$price/شهر';
  }

  @override
  String premiumPlanYearlySub(String price) {
    return '$price/سنة';
  }

  @override
  String premiumPlanMonthlyTrial(int days, String price) {
    return '$days أيام مجانًا، ثم $price/شهر';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'وفّر $percent%';
  }

  @override
  String get premiumSaveUnknown => 'وفّر -%';

  @override
  String premiumActionStartTrial(int days) {
    return 'ابدأ تجربة مجانية لمدة $days أيام';
  }

  @override
  String get premiumSubscriptionsAvailableSoon => 'ستتوفر الاشتراكات قريبًا.';

  @override
  String get premiumLoadPlansFailed => 'Could not load plans. Tap to retry';

  @override
  String errorCodeLabel(String code) {
    return 'Error code: $code';
  }

  @override
  String get pagesEditPagesAction => 'تعديل الصفحات';

  @override
  String get premiumCancelAnytime => 'يمكنك الإلغاء في أي وقت';

  @override
  String get premiumPendingStatus =>
      'تتم معالجة عملية الشراء بواسطة Google Play. سيتم تفعيل المزايا فور التأكيد.';

  @override
  String get premiumRenewalDisclosurePricingUnavailable =>
      'يتجدد تلقائيًا. سيتم تأكيد السعر بواسطة Google Play عند الدفع. يمكنك الإلغاء في أي وقت من اشتراكات Google Play.';

  @override
  String get premiumActionSubscribe => 'اشتراك';

  @override
  String get premiumActionRestore => 'استعادة المشتريات';

  @override
  String get premiumBillingDisclaimer =>
      'يتجدد تلقائيًا. يمكنك الإلغاء في أي وقت من اشتراكات Google Play.';

  @override
  String get premiumTerms => 'شروط الخدمة';

  @override
  String get premiumPrivacy => 'سياسة الخصوصية';

  @override
  String get premiumActiveStatus => 'أنت مشترك في باقة Premium';

  @override
  String get premiumGraceStatus => 'فترة السماح دون اتصال نشطة';

  @override
  String get premiumExpiredStatus => 'انتهت صلاحية الاشتراك';

  @override
  String get premiumRestoreSuccess => 'تمت استعادة المشتريات بنجاح.';

  @override
  String get premiumRestoreNone => 'لم يتم العثور على اشتراكات نشطة.';

  @override
  String get premiumErrorGeneral =>
      'تعذر إكمال عملية الشراء. يرجى المحاولة مرة أخرى.';

  @override
  String get premiumPagesGateTitle => 'Doc View Premium';

  @override
  String get premiumPagesGateBody =>
      'يتطلب إعادة ترتيب الصفحات وتدويرها وحذفها اشتراك Premium.';

  @override
  String get premiumPagesGateUpgrade => 'الترقية إلى Premium';

  @override
  String get premiumTooltip => 'Doc View Premium';

  @override
  String get premiumManageInPlay => 'إدارة';

  @override
  String get faqQuestion8 => 'ما الذي يتضمنه اشتراك Doc View Premium؟';

  @override
  String get faqAnswer8 =>
      'يفتح اشتراك Doc View Premium جميع أدوات تحرير المستندات المتقدمة، بما في ذلك إعادة ترتيب صفحات PDF وتدويرها وحذفها، وتحويل PDF إلى Word، والتعليقات التوضيحية، والتوقيعات، وإدراج النصوص المخصصة، مع إزالة جميع الإعلانات تمامًا في كافة أنحاء التطبيق. وتظل جميع عمليات معالجة المستندات على جهازك بنسبة 100%.';

  @override
  String get faqQuestion9 =>
      'هل يمكنني استخدام Doc View Premium دون اتصال بالإنترنت؟';

  @override
  String get faqAnswer9 =>
      'نعم. بمجرد التفعيل، يحفظ Doc View حالة اشتراكك بأمان على جهازك مع فترة سماح دون اتصال تصل إلى 7 أيام متتالية. يمكنك مواصلة استخدام جميع أدوات التحرير دون اتصال خلال هذه الفترة.';

  @override
  String get galleryDebugIapSectionTitle =>
      '15. محاكي الشراء داخل التطبيق وPremium (G7)';

  @override
  String get galleryDebugIapStateFree => 'تعيين: مجاني';

  @override
  String get galleryDebugIapStateYearly => 'تعيين: Premium سنوي';

  @override
  String get galleryDebugIapStateMonthly => 'تعيين: Premium شهري';

  @override
  String get galleryDebugIapStateGrace => 'تعيين: سماح دون اتصال (نشط)';

  @override
  String get galleryDebugIapStateGraceExpired =>
      'تعيين: سماح دون اتصال (منتهي)';

  @override
  String get galleryDebugOpenPremium => 'فتح شاشة /premium';

  @override
  String get galleryDebugIapProductSeenTrue => 'تعيين رؤية المنتج: صحيح';

  @override
  String get galleryDebugIapProductSeenFalse => 'تعيين رؤية المنتج: خطأ';

  @override
  String get addWidgetSheetTitle => 'الإضافة إلى الشاشة الرئيسية';

  @override
  String get addWidgetSheetSubtitle => 'اختر أداة لإضافتها إلى شاشتك الرئيسية';

  @override
  String get widgetRecentFilesTitle => 'الملفات الأخيرة';

  @override
  String get widgetRecentFilesBadge => '4 × 2';

  @override
  String get widgetRecentFilesDesc =>
      'اعرض ملفاتك المستخدمة مؤخرًا وافتحها مباشرة من شاشتك الرئيسية';

  @override
  String get widgetQuickToolsTitle => 'الأدوات السريعة';

  @override
  String get widgetQuickToolsBadge => '4 × 1';

  @override
  String get widgetQuickToolsDesc =>
      'انتقل مباشرة إلى المسح الضوئي أو صورة إلى PDF أو البحث أو الاستيراد';

  @override
  String get addWidgetButton => 'إضافة أداة';

  @override
  String get addWidgetManualTitle => 'إضافة الأداة يدويًا';

  @override
  String get addWidgetManualMessage =>
      'اضغط مطولاً على مساحة فارغة في شاشتك الرئيسية، وانقر على الأدوات (Widgets)، وابحث عن Doc View، ثم اسحبه إلى شاشتك.';

  @override
  String get settingsQuickAccessNotificationTitle => 'إشعار الوصول السريع';

  @override
  String get settingsQuickAccessNotificationSubtitle =>
      'إظهار الأدوات السريعة في شريط الإشعارات';

  @override
  String get notificationPermissionDialogTitle => 'السماح بالإشعارات';

  @override
  String get notificationPermissionDialogDesc =>
      'يحتاج Doc View إلى إذن الإشعارات لعرض شريط الوصول السريع في لوحة الإشعارات.';

  @override
  String get notificationTitle => 'أدوات Doc View السريعة';

  @override
  String get notificationBody => 'امسح ضوئيًا أو حوّل أو ابحث في المستندات';

  @override
  String get notificationActionScan => 'مسح ضوئي';

  @override
  String get notificationActionImageToPdf => 'صورة إلى PDF';

  @override
  String get notificationActionSearch => 'بحث';

  @override
  String get settingsAdChoicesTitle => 'خيارات الإعلانات';

  @override
  String get settingsAdChoicesSubtitle => 'إدارة تفضيلات الخصوصية والإعلانات';

  @override
  String get faqQuestion10 => 'لماذا يعرض Doc View إعلانات؟';

  @override
  String get faqAnswer10 =>
      'تُبقي الإعلانات تطبيق Doc View مجانيًا، بينما يزيلها اشتراك Premium. تُقدّم الإعلانات عبر Google AdMob ولا تطلع أبدًا على مستنداتك.';
}
