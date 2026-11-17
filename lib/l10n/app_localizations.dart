import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'XA'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Doc View'**
  String get appTitle;

  /// Bottom navigation bar label for the all files / home tab
  ///
  /// In en, this message translates to:
  /// **'All files'**
  String get navHome;

  /// Bottom navigation bar label for the tools tab
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get navTools;

  /// Bottom navigation bar label for the settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Error message when opening viewer without a selected document
  ///
  /// In en, this message translates to:
  /// **'No document selected'**
  String get noDocumentSelected;

  /// Tooltip for closing an ad dialog or banner
  ///
  /// In en, this message translates to:
  /// **'Close ad'**
  String get tooltipCloseAd;

  /// Tooltip for standard close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get tooltipClose;

  /// Tooltip for refreshing/rescanning documents
  ///
  /// In en, this message translates to:
  /// **'Rescan documents'**
  String get tooltipRescan;

  /// Tooltip for opening document search
  ///
  /// In en, this message translates to:
  /// **'Search documents'**
  String get tooltipSearch;

  /// Tooltip for entering multi-selection mode
  ///
  /// In en, this message translates to:
  /// **'Select files'**
  String get tooltipSelectFiles;

  /// Tooltip for navigating back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tooltipBack;

  /// Tooltip for cancelling multi-selection mode
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get tooltipCancelSelection;

  /// Number of files currently selected
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 selected} other{{count} selected}}'**
  String selectionCount(int count);

  /// Action to select all items
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get actionSelectAll;

  /// Action to deselect all items
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get actionDeselectAll;

  /// Tooltip for deleting selected items
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get tooltipDeleteSelected;

  /// Tooltip for clearing the search field text
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get tooltipClearSearch;

  /// Placeholder hint text in document search bars
  ///
  /// In en, this message translates to:
  /// **'Search documents, folders...'**
  String get searchHint;

  /// Accessibility announcement for the floating page indicator
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {total}'**
  String pageIndicatorSemantics(int page, int total);

  /// Headline for generic error state
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// Action button to retry a failed operation
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// Headline when all files access permission is needed
  ///
  /// In en, this message translates to:
  /// **'All Files Access Required'**
  String get permissionAllFilesTitle;

  /// Rationale text explaining why all files access is requested
  ///
  /// In en, this message translates to:
  /// **'Doc View needs All files access to browse folders and organize your documents completely offline.'**
  String get permissionAllFilesExplanation;

  /// Button to open system settings for granting storage permission
  ///
  /// In en, this message translates to:
  /// **'Grant Access'**
  String get actionGrantAccess;

  /// Button to import files via system picker without full storage permission
  ///
  /// In en, this message translates to:
  /// **'Import Files Instead'**
  String get actionImportFilesInstead;

  /// Tooltip to unbookmark a document
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get tooltipRemoveBookmark;

  /// Tooltip to bookmark a document
  ///
  /// In en, this message translates to:
  /// **'Add bookmark'**
  String get tooltipAddBookmark;

  /// Accessibility tooltip for document options button
  ///
  /// In en, this message translates to:
  /// **'File options for {title}'**
  String tooltipFileOptions(String title);

  /// Accessibility label for a folder item in directory browser
  ///
  /// In en, this message translates to:
  /// **'Folder, {name}{subtitle}'**
  String folderSemantics(String name, String subtitle);

  /// Full uppercase label for advertisement container
  ///
  /// In en, this message translates to:
  /// **'ADVERTISEMENT'**
  String get adAdvertisementBadge;

  /// Default confirmation button label in dialogs
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// Default cancellation button label in dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Recent documents tab label
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get tabRecent;

  /// Bookmarked documents tab label
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get tabBookmarks;

  /// Filter chip label to show all document categories
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterCategoryAll;

  /// Browse subtitle action in folder category tile
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get actionBrowse;

  /// Button to cancel an active processing operation
  ///
  /// In en, this message translates to:
  /// **'Cancel Operation'**
  String get actionCancelOperation;

  /// Headline for operation complete bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Operation Complete'**
  String get operationComplete;

  /// Button to open a newly generated document
  ///
  /// In en, this message translates to:
  /// **'Open Document'**
  String get actionOpenDocument;

  /// Button to share a generated document
  ///
  /// In en, this message translates to:
  /// **'Share Document'**
  String get actionShareDocument;

  /// Splash screen tagline
  ///
  /// In en, this message translates to:
  /// **'All your documents, one place.'**
  String get splashTagline;

  /// Application version label on splash screen
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// Onboarding step pill indicator
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStep(int current, int total);

  /// Skip onboarding action button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// Next step button label
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// Get started button label on final onboarding step
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get actionGetStarted;

  /// Headline for onboarding page 1
  ///
  /// In en, this message translates to:
  /// **'All your documents,\none place'**
  String get onboardingPage1Title;

  /// Body description for onboarding page 1
  ///
  /// In en, this message translates to:
  /// **'Doc View automatically finds PDFs, Word, Excel, PowerPoint, text files and images on your phone and organizes them for you.'**
  String get onboardingPage1Desc;

  /// Headline for onboarding page 2
  ///
  /// In en, this message translates to:
  /// **'Read anything,\nbeautifully'**
  String get onboardingPage2Title;

  /// Body description for onboarding page 2
  ///
  /// In en, this message translates to:
  /// **'Open PDFs, Word, Excel and PowerPoint files with a fast, clean reader. Search, bookmark and pick up where you left off.'**
  String get onboardingPage2Desc;

  /// Headline for onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'Powerful PDF tools, offline'**
  String get onboardingPage3Title;

  /// Body description for onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'Turn photos into PDFs, scan documents, merge and split files. Everything stays on your device.'**
  String get onboardingPage3Desc;

  /// Offline and privacy badge text on onboarding page 3
  ///
  /// In en, this message translates to:
  /// **'100% Offline • Private & Secure'**
  String get onboardingOfflineGuarantee;

  /// Tool title for converting images to PDF
  ///
  /// In en, this message translates to:
  /// **'Image to PDF'**
  String get toolImageToPdf;

  /// Tool subtitle for Image to PDF
  ///
  /// In en, this message translates to:
  /// **'Convert JPG & PNG'**
  String get toolImageToPdfSub;

  /// Tool title for scanning documents with camera
  ///
  /// In en, this message translates to:
  /// **'Scan to PDF'**
  String get toolScanToPdf;

  /// Tool subtitle for Scan to PDF
  ///
  /// In en, this message translates to:
  /// **'Camera edge detect'**
  String get toolScanToPdfSub;

  /// Tool title for merging multiple PDFs
  ///
  /// In en, this message translates to:
  /// **'Merge PDF'**
  String get toolMergePdf;

  /// Tool subtitle for Merge PDF
  ///
  /// In en, this message translates to:
  /// **'Combine into one'**
  String get toolMergePdfSub;

  /// Tool title for splitting PDF pages
  ///
  /// In en, this message translates to:
  /// **'Split PDF'**
  String get toolSplitPdf;

  /// Tool subtitle for Split PDF
  ///
  /// In en, this message translates to:
  /// **'Extract any range'**
  String get toolSplitPdfSub;

  /// Header tag for storage permission screen
  ///
  /// In en, this message translates to:
  /// **'Device Storage Access'**
  String get permissionTagStorage;

  /// Main headline on storage permission screen
  ///
  /// In en, this message translates to:
  /// **'Let Doc View find your documents'**
  String get permissionStorageHeadline;

  /// Explanation text on Android storage permission screen
  ///
  /// In en, this message translates to:
  /// **'To list PDFs, Word, Excel and other files saved by any app, Android needs your permission to access all files. Your files never leave your phone.'**
  String get permissionStorageBody;

  /// Title for offline reassurance point
  ///
  /// In en, this message translates to:
  /// **'Works offline'**
  String get permissionReassuranceOfflineTitle;

  /// Description for offline reassurance point
  ///
  /// In en, this message translates to:
  /// **'No internet connection required. Operates 100% locally.'**
  String get permissionReassuranceOfflineDesc;

  /// Title for no-uploads privacy reassurance point
  ///
  /// In en, this message translates to:
  /// **'No uploads'**
  String get permissionReassuranceNoUploadsTitle;

  /// Description for no-uploads privacy reassurance point
  ///
  /// In en, this message translates to:
  /// **'Zero cloud servers. Your files stay strictly in phone memory.'**
  String get permissionReassuranceNoUploadsDesc;

  /// Title for permission toggle reassurance point
  ///
  /// In en, this message translates to:
  /// **'You can change this any time'**
  String get permissionReassuranceChangeTitle;

  /// Description for permission toggle reassurance point
  ///
  /// In en, this message translates to:
  /// **'Easily toggle in your Android System App Settings.'**
  String get permissionReassuranceChangeDesc;

  /// Header tag for iOS storage guide screen
  ///
  /// In en, this message translates to:
  /// **'iOS Storage Guide'**
  String get permissionTagIOS;

  /// Main headline on iOS storage guide screen
  ///
  /// In en, this message translates to:
  /// **'Bring your documents to Doc View'**
  String get permissionIOSHeadline;

  /// Explanation body on iOS storage guide screen
  ///
  /// In en, this message translates to:
  /// **'Due to Apple\'s privacy architecture, iOS doesn\'t allow any app to scan your entire phone automatically. Choose how you\'d like to read your files:'**
  String get permissionIOSBody;

  /// Title for iOS import files option
  ///
  /// In en, this message translates to:
  /// **'Import files'**
  String get permissionIOSOptionImportTitle;

  /// Fastest badge label for iOS import option
  ///
  /// In en, this message translates to:
  /// **'FASTEST'**
  String get permissionIOSBadgeFastest;

  /// Description for iOS import files option
  ///
  /// In en, this message translates to:
  /// **'Pick documents directly from your iCloud Drive, Downloads, or any folder in seconds.'**
  String get permissionIOSOptionImportDesc;

  /// Title for iOS Files app folder option
  ///
  /// In en, this message translates to:
  /// **'Open Doc View folder in Files app'**
  String get permissionIOSOptionFolderTitle;

  /// Description for iOS Files app folder option
  ///
  /// In en, this message translates to:
  /// **'Save or AirDrop documents directly into the \"Doc View\" folder in the iOS Files app for instant sync.'**
  String get permissionIOSOptionFolderDesc;

  /// Primary action button to launch file import picker
  ///
  /// In en, this message translates to:
  /// **'Import files'**
  String get actionImportFiles;

  /// Action to skip iOS import and continue to app
  ///
  /// In en, this message translates to:
  /// **'Continue to app'**
  String get actionContinueToApp;

  /// Header tag on transparency and consent screen
  ///
  /// In en, this message translates to:
  /// **'Transparency & Consent'**
  String get permissionTagConsent;

  /// Free app badge label
  ///
  /// In en, this message translates to:
  /// **'100% Free App'**
  String get permissionBadgeFree;

  /// Minimal ads badge label
  ///
  /// In en, this message translates to:
  /// **'Minimal Ads'**
  String get permissionBadgeMinimalAds;

  /// Main headline on ad consent transparency screen
  ///
  /// In en, this message translates to:
  /// **'Free with ads'**
  String get permissionConsentHeadline;

  /// Body explanation on ad consent transparency screen
  ///
  /// In en, this message translates to:
  /// **'Doc View is free thanks to ads. We\'ll ask for your choice about personalised ads next.'**
  String get permissionConsentBody;

  /// Title explaining types of ads shown
  ///
  /// In en, this message translates to:
  /// **'What ads you may see'**
  String get permissionConsentAdsTitle;

  /// Description explaining types of ads shown
  ///
  /// In en, this message translates to:
  /// **'Small banner ads and non-intrusive sponsor cards. No popups or video interruptions while reading.'**
  String get permissionConsentAdsDesc;

  /// Title explaining document privacy guarantee with ads
  ///
  /// In en, this message translates to:
  /// **'Documents stay completely private'**
  String get permissionConsentPrivateTitle;

  /// Description explaining document privacy guarantee with ads
  ///
  /// In en, this message translates to:
  /// **'Ad partners never have access to your document names, text contents, or file locations.'**
  String get permissionConsentPrivateDesc;

  /// Title explaining ad preferences settings control
  ///
  /// In en, this message translates to:
  /// **'You can change your choice in Settings'**
  String get permissionConsentSettingsTitle;

  /// Description explaining ad preferences settings control
  ///
  /// In en, this message translates to:
  /// **'Update personalized ad consent or privacy preferences anytime in Doc View Settings.'**
  String get permissionConsentSettingsDesc;

  /// Primary continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// Button to open privacy policy webpage
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get actionPrivacyPolicy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'XA':
            return AppLocalizationsEnXa();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
