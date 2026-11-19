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

  /// Action button label to retry a failed operation
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

  /// Accessibility action hint to open document
  ///
  /// In en, this message translates to:
  /// **'Open document'**
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

  /// Snackbar shown when files are imported via system picker
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Imported 1 file} other{Imported {count} files}}'**
  String filesImportedSuccess(int count);

  /// Snackbar shown when file import fails
  ///
  /// In en, this message translates to:
  /// **'Failed to import files'**
  String get importFailedError;

  /// Tooltip for floating action button to import documents
  ///
  /// In en, this message translates to:
  /// **'Import documents'**
  String get tooltipImportDocuments;

  /// Document scan progress counter
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file found} other{{count} files found}}'**
  String homeScanProgressCount(int count);

  /// Active document scanning progress text
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanningStatus;

  /// Pluralized count of files in category or folder
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file} other{{count} files}}'**
  String fileCountPlural(int count);

  /// Category tile label for Folders browser
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get categoryFolders;

  /// Error message when recent files query fails
  ///
  /// In en, this message translates to:
  /// **'Error loading recent files'**
  String get errorLoadingRecent;

  /// Generic title for empty list tab or screen
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get emptyStateTitle;

  /// Placeholder explanation for recent files tab
  ///
  /// In en, this message translates to:
  /// **'Recently opened files will appear here'**
  String get emptyRecentDescription;

  /// Error message when bookmarked files query fails
  ///
  /// In en, this message translates to:
  /// **'Error loading bookmarked files'**
  String get errorLoadingBookmarks;

  /// Placeholder explanation for bookmarks tab
  ///
  /// In en, this message translates to:
  /// **'Bookmarked documents will appear here'**
  String get emptyBookmarksDescription;

  /// Dialog headline for batch file deletion confirmation
  ///
  /// In en, this message translates to:
  /// **'Delete selected files?'**
  String get dialogDeleteTitle;

  /// Dialog body explaining that batch deletion is permanent
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 file? This cannot be undone.} other{Delete {count} files? This cannot be undone.}}'**
  String dialogDeleteBody(int count);

  /// Snackbar message indicating successful batch file deletion
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Deleted 1 file} other{Deleted {count} files}}'**
  String filesDeletedSuccess(int count);

  /// Snackbar message when deleting files fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete files'**
  String get filesDeleteFailed;

  /// Action button text to confirm deletion
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// Section header for recent search queries
  ///
  /// In en, this message translates to:
  /// **'RECENT SEARCHES'**
  String get searchRecentSearchesHeader;

  /// Action button to clear recent search history
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// Headline in search idle empty state
  ///
  /// In en, this message translates to:
  /// **'Type to search documents'**
  String get searchPromptTitle;

  /// Message in search idle empty state
  ///
  /// In en, this message translates to:
  /// **'Search across all local folders by filename or extension'**
  String get searchPromptMessage;

  /// Error message when search query fails
  ///
  /// In en, this message translates to:
  /// **'Error searching documents'**
  String get searchError;

  /// Headline when search produces zero results
  ///
  /// In en, this message translates to:
  /// **'No matching documents found'**
  String get searchNoResultsTitle;

  /// Explanation when search produces zero results
  ///
  /// In en, this message translates to:
  /// **'Try searching with a different filename keyword or format filter'**
  String get searchNoResultsMessage;

  /// Tooltip for sort options button in category sub app bar
  ///
  /// In en, this message translates to:
  /// **'Sort options'**
  String get tooltipSortOptions;

  /// Title of the sort options modal bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortSheetTitle;

  /// Sort option label for ordering by modification date
  ///
  /// In en, this message translates to:
  /// **'Date modified'**
  String get sortOptionDate;

  /// Sort option label for ordering by document name
  ///
  /// In en, this message translates to:
  /// **'Document name'**
  String get sortOptionName;

  /// Sort option label for ordering by file size
  ///
  /// In en, this message translates to:
  /// **'File size'**
  String get sortOptionSize;

  /// Switch label for ascending sort direction
  ///
  /// In en, this message translates to:
  /// **'Ascending order'**
  String get sortAscendingOrder;

  /// Subtitle describing ascending sort order
  ///
  /// In en, this message translates to:
  /// **'Oldest first / A to Z / Smallest first'**
  String get sortAscendingSubtitle;

  /// Subtitle describing descending sort order
  ///
  /// In en, this message translates to:
  /// **'Newest first / Z to A / Largest first'**
  String get sortDescendingSubtitle;

  /// Title for the all files category screen
  ///
  /// In en, this message translates to:
  /// **'All files'**
  String get categoryAllFiles;

  /// Generic loading status indicator
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingStatus;

  /// Headline when image category has no files
  ///
  /// In en, this message translates to:
  /// **'No images found'**
  String get emptyCategoryImagesTitle;

  /// Message when image category has no files
  ///
  /// In en, this message translates to:
  /// **'Images found on this device will appear here'**
  String get emptyCategoryImagesMessage;

  /// Headline when a document category has no files
  ///
  /// In en, this message translates to:
  /// **'No documents found'**
  String get emptyCategoryDocsTitle;

  /// Message when a document category has no files
  ///
  /// In en, this message translates to:
  /// **'Documents of this format will appear here after scanning'**
  String get emptyCategoryDocsMessage;

  /// Action button label to open a document
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get actionOpen;

  /// Action button label to share a document
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// Action button label to rename a document
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get actionRename;

  /// Action button label to bookmark a document
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get actionBookmark;

  /// Action button label to remove bookmark from a document
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get actionRemoveBookmark;

  /// Action button label to open a document in an external application
  ///
  /// In en, this message translates to:
  /// **'Open in another app'**
  String get actionOpenInAnotherApp;

  /// Action button label to view document details
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get actionDetails;

  /// Primary button label to open the active file
  ///
  /// In en, this message translates to:
  /// **'Open file'**
  String get actionOpenFile;

  /// Action button label to share all generated files
  ///
  /// In en, this message translates to:
  /// **'Share All'**
  String get actionShareAll;

  /// Action button label to finish flow
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// Action link to see all items in a section
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get actionSeeAll;

  /// Button label to grant requested permission
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get actionAllow;

  /// Button label to dismiss or postpone permission request
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get actionNotNow;

  /// Tooltip for the more actions button on a file row
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get tooltipMoreActions;

  /// Tooltip for copy path button
  ///
  /// In en, this message translates to:
  /// **'Copy path'**
  String get tooltipCopyPath;

  /// Tooltip for rotating a page
  ///
  /// In en, this message translates to:
  /// **'Rotate page'**
  String get tooltipRotatePage;

  /// Tooltip for removing a page
  ///
  /// In en, this message translates to:
  /// **'Remove page'**
  String get tooltipRemovePage;

  /// Title of the file rename dialog
  ///
  /// In en, this message translates to:
  /// **'Rename file'**
  String get renameFileTitle;

  /// Input field label for new file name
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get renameFileNameLabel;

  /// Snackbar shown when a file is successfully renamed
  ///
  /// In en, this message translates to:
  /// **'Renamed to {fileName}'**
  String renamedSuccess(String fileName);

  /// Title of single file deletion confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete file?'**
  String get deleteFileTitle;

  /// Body message asking confirmation to delete a single file
  ///
  /// In en, this message translates to:
  /// **'Delete \"{fileName}\"? This can\'t be undone.'**
  String deleteFileConfirmation(String fileName);

  /// Snackbar message when a file is deleted
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{fileName}\"'**
  String deletedFileSuccess(String fileName);

  /// Header title of the document details sheet
  ///
  /// In en, this message translates to:
  /// **'Document Details'**
  String get fileDetailsTitle;

  /// Label for file name metadata row
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fileDetailsLabelName;

  /// Label for file type metadata row
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fileDetailsLabelType;

  /// Label for file size metadata row
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get fileDetailsLabelSize;

  /// Label for modified date metadata row
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get fileDetailsLabelModified;

  /// Label for bookmarked status metadata row
  ///
  /// In en, this message translates to:
  /// **'Bookmarked'**
  String get fileDetailsLabelBookmarked;

  /// Affirmative value in metadata details
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get fileDetailsValueYes;

  /// Negative value in metadata details
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get fileDetailsValueNo;

  /// Label for file location/path in details sheet
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get fileDetailsLabelLocation;

  /// Snackbar message when file path is copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Path copied to clipboard'**
  String get fileDetailsPathCopied;

  /// AppBar title for the directories browser screen
  ///
  /// In en, this message translates to:
  /// **'Directories'**
  String get directoriesTitle;

  /// Button label to navigate up one folder in empty/error directory state
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get directoriesGoBack;

  /// Button label to return to the root folder
  ///
  /// In en, this message translates to:
  /// **'Go to Root'**
  String get directoriesGoToRoot;

  /// Button label to retry loading directory
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get directoriesRetry;

  /// Snackbar message when tapping a file that was deleted on disk
  ///
  /// In en, this message translates to:
  /// **'File no longer exists'**
  String get directoriesFileNoLongerExists;

  /// Empty state title when a directory is deleted
  ///
  /// In en, this message translates to:
  /// **'This folder no longer exists.'**
  String get directoriesFolderNoLongerExists;

  /// Headline when a directory contains no supported documents
  ///
  /// In en, this message translates to:
  /// **'No documents in this folder'**
  String get directoriesNoDocsInFolder;

  /// Subtitle when a directory contains no supported documents
  ///
  /// In en, this message translates to:
  /// **'Files will appear here once added'**
  String get directoriesFilesAppearHere;

  /// Item count subtitle on folder list tiles
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String directoriesFolderSubtitle(int count);

  /// Default subtitle for folders when count is unknown
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get directoriesFolderSubtitleDefault;

  /// Title for directory browser permission required state
  ///
  /// In en, this message translates to:
  /// **'Access required to view directories'**
  String get directoriesPermissionPromptTitle;

  /// Body message explaining why directory browsing needs storage access
  ///
  /// In en, this message translates to:
  /// **'Doc View needs All files access to browse your folders.'**
  String get directoriesPermissionPromptBody;

  /// Button label to request All files access
  ///
  /// In en, this message translates to:
  /// **'Grant access'**
  String get directoriesGrantAccess;

  /// Button label to import individual files via system picker
  ///
  /// In en, this message translates to:
  /// **'Import files instead'**
  String get directoriesImportInstead;

  /// Snackbar message reporting number of imported files
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Imported 1 file} other{Imported {count} files}}'**
  String directoriesImportedCount(int count);

  /// Tooltip for navigation button that ascends one folder level
  ///
  /// In en, this message translates to:
  /// **'Up one level'**
  String get directoriesTooltipUp;

  /// Title of the storage access prompt dialog
  ///
  /// In en, this message translates to:
  /// **'Storage Access Required'**
  String get storageAccessRequiredTitle;

  /// Body text of the storage access prompt dialog
  ///
  /// In en, this message translates to:
  /// **'Doc View needs storage access to scan and display documents (PDF, Word, Excel, PPT, TXT, Images) stored on your device.\n\nYour files remain completely private and offline on your device.'**
  String get storageAccessRequiredBody;

  /// Snackbar shown when opening an external document fails
  ///
  /// In en, this message translates to:
  /// **'Could not open document: {error}'**
  String errorCouldNotOpenDocument(String error);

  /// Snackbar notification after filesystem scan finishes
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Scan complete: 1 file} other{Scan complete: {count} files}}'**
  String scanCompleteWithCount(int count);

  /// Title for clear search history confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Clear search history?'**
  String get dialogClearSearchTitle;

  /// Body message for clear search history confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'All recent searches will be permanently cleared.'**
  String get dialogClearSearchMessage;

  /// Snackbar message when user tries to add more than maximum allowed images
  ///
  /// In en, this message translates to:
  /// **'Maximum limit of {max} images reached.'**
  String imageListEditorMaxLimit(int max);

  /// Snackbar message when camera/scanner operation fails
  ///
  /// In en, this message translates to:
  /// **'Scanning failed: {error}'**
  String imageListEditorScanFailed(String error);

  /// Label for page size selector in image to PDF editor
  ///
  /// In en, this message translates to:
  /// **'Page Size:'**
  String get imageListEditorPageSize;

  /// A4 page mode button label
  ///
  /// In en, this message translates to:
  /// **'A4'**
  String get imageListEditorA4Mode;

  /// Fit to image page mode button label
  ///
  /// In en, this message translates to:
  /// **'Fit to image'**
  String get imageListEditorFitMode;

  /// Tooltip for button removing an image from the PDF editor list
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get imageListEditorRemoveImageTooltip;

  /// AppBar title for PDF merge screen
  ///
  /// In en, this message translates to:
  /// **'Arrange & merge'**
  String get mergeScreenTitle;

  /// Default base filename for merged PDF document
  ///
  /// In en, this message translates to:
  /// **'Merged_Document'**
  String get mergeScreenDefaultMergedName;

  /// Search field hint text in merge PDF picker
  ///
  /// In en, this message translates to:
  /// **'Search PDFs...'**
  String get mergePickerSearchHint;

  /// Next button label in merge PDF picker
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get mergePickerNext;

  /// Error message when loading PDFs in merge picker fails
  ///
  /// In en, this message translates to:
  /// **'Error loading PDFs: {error}'**
  String mergePickerErrorLoading(String error);

  /// AppBar title for PDF split screen
  ///
  /// In en, this message translates to:
  /// **'Split PDF'**
  String get splitScreenTitle;

  /// Hint text for page range input in split screen
  ///
  /// In en, this message translates to:
  /// **'e.g. 1-3, 5, 8-10'**
  String get splitScreenRangeHint;

  /// Tooltip for clearing page range text in split screen
  ///
  /// In en, this message translates to:
  /// **'Clear range'**
  String get splitScreenClearRange;

  /// Search field hint text in split PDF picker
  ///
  /// In en, this message translates to:
  /// **'Search PDFs...'**
  String get splitPickerSearchHint;

  /// Error message when loading PDFs in split picker fails
  ///
  /// In en, this message translates to:
  /// **'Error loading files: {error}'**
  String splitPickerErrorLoading(String error);

  /// Section header for documents created by user
  ///
  /// In en, this message translates to:
  /// **'Created by you'**
  String get createdSectionTitle;

  /// Title on empty state card for created documents section
  ///
  /// In en, this message translates to:
  /// **'PDFs you create appear here'**
  String get createdSectionEmptyTitle;

  /// Subtitle on empty state card for created documents section
  ///
  /// In en, this message translates to:
  /// **'Converted, scanned, or merged documents will be saved locally.'**
  String get createdSectionEmptySubtitle;

  /// Title when created documents listing is empty
  ///
  /// In en, this message translates to:
  /// **'No created documents yet'**
  String get emptyCreatedDocsTitle;

  /// Message when created documents listing is empty
  ///
  /// In en, this message translates to:
  /// **'Converted, scanned, or merged documents will appear here.'**
  String get emptyCreatedDocsMessage;

  /// Error message when loading created files fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load created files: {error}'**
  String errorLoadingCreatedFiles(String error);

  /// Success headline in tool result bottom sheet
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{PDF Created} other{{count} PDFs Created}}'**
  String toolResultPdfCreated(int count);

  /// Subtitle in tool result sheet confirming save location
  ///
  /// In en, this message translates to:
  /// **'Saved to your Created folder'**
  String get toolResultSavedSubtitle;

  /// Default headline in tool error bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create PDF'**
  String get toolErrorDefaultTitle;

  /// Subtitle explaining unexpected processing failure in tool error sheet
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during processing'**
  String get toolErrorSubtitle;

  /// Header title of the theme selection bottom sheet
  ///
  /// In en, this message translates to:
  /// **'App theme'**
  String get themeSheetTitle;

  /// Subtitle of the theme selection bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Select visual appearance for Doc View'**
  String get themeSheetSubtitle;

  /// Label for system theme mode option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// Subtitle for system theme mode option
  ///
  /// In en, this message translates to:
  /// **'default'**
  String get themeModeSystemSubtitle;

  /// Label for light theme mode option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// Subtitle for light theme mode option
  ///
  /// In en, this message translates to:
  /// **'Clean white'**
  String get themeModeLightSubtitle;

  /// Label for dark theme mode option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// Subtitle for dark theme mode option
  ///
  /// In en, this message translates to:
  /// **'Deep navy'**
  String get themeModeDarkSubtitle;

  /// Button label to confirm and apply selected theme mode
  ///
  /// In en, this message translates to:
  /// **'Apply theme'**
  String get themeActionApply;

  /// Header title of the scan settings sub-screen
  ///
  /// In en, this message translates to:
  /// **'Scan settings'**
  String get scanSettingsTitle;

  /// Section header for scan frequency options
  ///
  /// In en, this message translates to:
  /// **'Scan frequency'**
  String get scanSettingsFrequencyHeader;

  /// Title of automatic scan on open option
  ///
  /// In en, this message translates to:
  /// **'Scan on app open'**
  String get scanSettingsOnOpenTitle;

  /// Description of automatic scan on open option
  ///
  /// In en, this message translates to:
  /// **'Automatically find new files when you open Doc View.'**
  String get scanSettingsOnOpenSubtitle;

  /// Title of manual scan mode option
  ///
  /// In en, this message translates to:
  /// **'Manual only'**
  String get scanSettingsManualTitle;

  /// Description of manual scan mode option
  ///
  /// In en, this message translates to:
  /// **'Only scan when you pull to refresh or tap Rescan.'**
  String get scanSettingsManualSubtitle;

  /// Section header for media file filtering options
  ///
  /// In en, this message translates to:
  /// **'Media filters'**
  String get scanSettingsMediaFiltersHeader;

  /// Title of toggle for including images in file indexing
  ///
  /// In en, this message translates to:
  /// **'Include images in scan'**
  String get scanSettingsIncludeImagesTitle;

  /// Description of toggle for including images in file indexing
  ///
  /// In en, this message translates to:
  /// **'Index PNG, JPG, and WEBP image files in storage.'**
  String get scanSettingsIncludeImagesSubtitle;

  /// Section header for storage status and diagnostics
  ///
  /// In en, this message translates to:
  /// **'Storage & diagnostics'**
  String get scanSettingsDiagnosticsHeader;

  /// Label for permission status row in diagnostics
  ///
  /// In en, this message translates to:
  /// **'All files access'**
  String get scanSettingsPermissionStatus;

  /// Value indicating storage permission is granted
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get scanSettingsPermissionGranted;

  /// Value indicating storage permission is not granted
  ///
  /// In en, this message translates to:
  /// **'Not granted'**
  String get scanSettingsPermissionNotGranted;

  /// Label for count of indexed files in diagnostics
  ///
  /// In en, this message translates to:
  /// **'Indexed files'**
  String get scanSettingsTotalIndexed;

  /// Label for timestamp of last filesystem scan
  ///
  /// In en, this message translates to:
  /// **'Last scanned'**
  String get scanSettingsLastScan;

  /// Snackbar message confirming scan settings change
  ///
  /// In en, this message translates to:
  /// **'Scan settings updated'**
  String get scanSettingsUpdatedSnackbar;

  /// Header title of the FAQ screen
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqScreenTitle;

  /// Chip label displaying total number of topics in FAQ
  ///
  /// In en, this message translates to:
  /// **'{count} Topics'**
  String faqHeaderTopics(int count);

  /// Subtitle under FAQ screen header
  ///
  /// In en, this message translates to:
  /// **'Got questions? Find clear answers here.'**
  String get faqHeaderSubtitle;

  /// Button label to contact support or send feedback
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get faqSendFeedback;

  /// FAQ question 1 regarding storage permissions
  ///
  /// In en, this message translates to:
  /// **'Why does Doc View need All files access?'**
  String get faqQuestion1;

  /// FAQ answer 1 regarding storage permissions
  ///
  /// In en, this message translates to:
  /// **'Doc View requires All files access (MANAGE_EXTERNAL_STORAGE) on Android 11+ to discover and index supported documents (PDF, Word, Excel, PowerPoint, Text, and Images) stored in shared folders such as Downloads and Documents.\n\nWithout this permission, Android restricts file access to the app\'s private internal folder, preventing Doc View from browsing or opening files located across your device.'**
  String get faqAnswer1;

  /// FAQ question 2 regarding iOS sandboxing
  ///
  /// In en, this message translates to:
  /// **'Why doesn\'t it scan my whole iPhone?'**
  String get faqQuestion2;

  /// FAQ answer 2 regarding iOS sandboxing
  ///
  /// In en, this message translates to:
  /// **'iOS uses strict app sandboxing to safeguard device privacy. Apps can only access documents explicitly saved inside the Files app or shared via the system Share Sheet.\n\nTo view files on iOS, import them into the Doc View folder in the native Files app or use the Import files option in Settings.'**
  String get faqAnswer2;

  /// FAQ question 3 regarding generated file storage location
  ///
  /// In en, this message translates to:
  /// **'Where are the PDFs I create saved?'**
  String get faqQuestion3;

  /// FAQ answer 3 regarding generated file storage location
  ///
  /// In en, this message translates to:
  /// **'Files you import or generate (such as converted PDFs, merged documents, or split pages) are saved securely in your device storage under DocView/Created or private app storage. You can view them anytime in the Created by you section on the Tools tab.'**
  String get faqAnswer3;

  /// FAQ question 4 regarding offline office rendering
  ///
  /// In en, this message translates to:
  /// **'Why does my Word file look different?'**
  String get faqQuestion4;

  /// FAQ answer 4 regarding offline office rendering
  ///
  /// In en, this message translates to:
  /// **'Doc View renders files directly on your device using local offline parsers without sending private data to cloud converters. Complex formatting or custom shapes render with native offline approximations.'**
  String get faqAnswer4;

  /// FAQ question 5 regarding encrypted PDF support
  ///
  /// In en, this message translates to:
  /// **'Can I open password-protected files?'**
  String get faqQuestion5;

  /// FAQ answer 5 regarding encrypted PDF support
  ///
  /// In en, this message translates to:
  /// **'Yes, Doc View supports opening password-protected PDF documents. When opening an encrypted PDF, enter the password in the dialog to decrypt and view the document on your device.'**
  String get faqAnswer5;

  /// FAQ question 6 regarding privacy and data policy
  ///
  /// In en, this message translates to:
  /// **'Is my data uploaded anywhere?'**
  String get faqQuestion6;

  /// FAQ answer 6 regarding privacy and data policy
  ///
  /// In en, this message translates to:
  /// **'Your documents never leave your device. Doc View opens, converts and stores files locally. The app shows ads served by Google AdMob, which can use limited device data as described in our Privacy Policy.'**
  String get faqAnswer6;

  /// Title of the jump to page dialog in PDF viewer
  ///
  /// In en, this message translates to:
  /// **'Go to page'**
  String get pdfGotoPageTitle;

  /// Input hint for page jump dialog
  ///
  /// In en, this message translates to:
  /// **'Enter a page between 1 and {pageCount}'**
  String pdfGotoPageHint(int pageCount);

  /// Action button label to jump to specified page
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get pdfGotoPageAction;

  /// Validation error when jump page input is empty
  ///
  /// In en, this message translates to:
  /// **'Enter a page number'**
  String get pdfGotoPageErrorEmpty;

  /// Validation error when jump page input is out of range
  ///
  /// In en, this message translates to:
  /// **'Enter a page between 1 and {pageCount}'**
  String pdfGotoPageErrorOutOfRange(int pageCount);

  /// Title of the password-protected PDF unlock dialog
  ///
  /// In en, this message translates to:
  /// **'This PDF is password-protected'**
  String get pdfPasswordTitle;

  /// Subtitle of the password-protected PDF unlock dialog
  ///
  /// In en, this message translates to:
  /// **'Enter password to view and decrypt the contents.'**
  String get pdfPasswordSubtitle;

  /// Hint text for PDF password input field
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get pdfPasswordHint;

  /// Inline error banner when submitted PDF password is wrong
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Try again.'**
  String get pdfPasswordErrorIncorrect;

  /// Action button label to unlock password-protected PDF
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get pdfPasswordActionUnlock;

  /// Validation error when file name is blank
  ///
  /// In en, this message translates to:
  /// **'File name cannot be empty'**
  String get errorFileNameEmpty;

  /// Validation error when file name exceeds length limit
  ///
  /// In en, this message translates to:
  /// **'File name cannot exceed 120 characters'**
  String get errorFileNameTooLong;

  /// Validation error when file name is reserved dot or double-dot
  ///
  /// In en, this message translates to:
  /// **'File name cannot be \'.\' or \'..\''**
  String get errorFileNameReserved;

  /// Validation error when file name begins with a period
  ///
  /// In en, this message translates to:
  /// **'File name cannot start with a dot'**
  String get errorFileNameStartsWithDot;

  /// Validation error when file name has illegal characters
  ///
  /// In en, this message translates to:
  /// **'File name contains invalid characters'**
  String get errorFileNameInvalidChars;

  /// Error message when rename target file already exists
  ///
  /// In en, this message translates to:
  /// **'A file with this name already exists in this folder'**
  String get errorRenameAlreadyExists;

  /// Error message when renaming a file that was deleted on disk
  ///
  /// In en, this message translates to:
  /// **'Source file no longer exists on disk'**
  String get errorRenameSourceNotFound;

  /// Error message when file rename IO fails
  ///
  /// In en, this message translates to:
  /// **'Failed to rename file: {details}'**
  String errorRenameFailed(String details);

  /// Error message when file deletion succeeded on disk but database sync failed
  ///
  /// In en, this message translates to:
  /// **'Files deleted from disk but database update failed'**
  String get errorDeleteDatabaseFailed;

  /// Error message when deleting files fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete files: {details}'**
  String errorDeleteFailed(String details);

  /// Validation error when splitting an empty document
  ///
  /// In en, this message translates to:
  /// **'Document has no pages'**
  String get errorPageRangeDocNoPages;

  /// Validation error when page range input is blank
  ///
  /// In en, this message translates to:
  /// **'Page range cannot be empty'**
  String get errorPageRangeEmpty;

  /// Validation error when page range input has trailing or consecutive commas
  ///
  /// In en, this message translates to:
  /// **'Empty range segment found. Remove extra commas.'**
  String get errorPageRangeEmptySegment;

  /// Validation error when a range segment is formatted incorrectly
  ///
  /// In en, this message translates to:
  /// **'Invalid range format: \'{token}\''**
  String errorPageRangeInvalidFormat(String token);

  /// Validation error when a range segment is missing start or end
  ///
  /// In en, this message translates to:
  /// **'Incomplete range: \'{token}\''**
  String errorPageRangeIncomplete(String token);

  /// Validation error when a range segment has letters or symbols
  ///
  /// In en, this message translates to:
  /// **'Non-numeric values in range: \'{token}\''**
  String errorPageRangeNonNumeric(String token);

  /// Validation error when page number is zero or negative
  ///
  /// In en, this message translates to:
  /// **'Page numbers must be 1 or greater'**
  String get errorPageRangeBelowMinimum;

  /// Validation error when range start exceeds range end
  ///
  /// In en, this message translates to:
  /// **'Reversed range \'{start}-{end}\': start is greater than end'**
  String errorPageRangeReversed(int start, int end);

  /// Validation error when specified range exceeds total page count
  ///
  /// In en, this message translates to:
  /// **'Range \'{token}\' exceeds total pages ({totalPages})'**
  String errorPageRangeExceeds(String token, int totalPages);

  /// Validation error when single page number is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid page number: \'{token}\''**
  String errorPageRangeInvalidNumber(String token);

  /// Error message when creating PDF with no images
  ///
  /// In en, this message translates to:
  /// **'Please select at least one image'**
  String get errorImageToPdfNoImages;

  /// Error message when exceeding maximum image count in image-to-PDF
  ///
  /// In en, this message translates to:
  /// **'Maximum {max} images allowed at a time'**
  String errorImageToPdfMaxExceeded(int max);

  /// Error message when individual image processing fails
  ///
  /// In en, this message translates to:
  /// **'Failed to process image: {path}'**
  String errorImageToPdfProcessingFailed(String path);

  /// Error message when overall PDF creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create PDF from images: {details}'**
  String errorImageToPdfGenerationFailed(String details);

  /// Error message when fewer than two PDFs are selected for merge
  ///
  /// In en, this message translates to:
  /// **'Please select at least 2 PDF files to merge'**
  String get errorPdfMergeInsufficient;

  /// Error message when a PDF to merge cannot be read
  ///
  /// In en, this message translates to:
  /// **'{fileName} is password-protected or damaged'**
  String errorPdfMergeDamagedOrEncrypted(String fileName);

  /// Error message when PDFs selected for merge have no pages
  ///
  /// In en, this message translates to:
  /// **'Selected documents contain no pages'**
  String get errorPdfMergeNoPages;

  /// Error message when PDF merge operation fails
  ///
  /// In en, this message translates to:
  /// **'PDF merging failed: {details}'**
  String errorPdfMergeFailed(String details);

  /// Error message when splitting PDF without specifying ranges
  ///
  /// In en, this message translates to:
  /// **'Please specify at least one page range'**
  String get errorPdfSplitNoRanges;

  /// Error message when PDF to split cannot be read
  ///
  /// In en, this message translates to:
  /// **'{fileName} is password-protected or damaged'**
  String errorPdfSplitDamagedOrEncrypted(String fileName);

  /// Error message when split range is outside PDF page bounds
  ///
  /// In en, this message translates to:
  /// **'Range {start}-{end} is out of bounds for {fileName}'**
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName);

  /// Error message when PDF split operation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to split PDF: {details}'**
  String errorPdfSplitFailed(String details);

  /// Short page count badge overlay on document preview
  ///
  /// In en, this message translates to:
  /// **'PG {current}/{total}'**
  String fileDetailsPageChip(int current, int total);

  /// Exact byte count display in document details sheet
  ///
  /// In en, this message translates to:
  /// **'({bytes} bytes)'**
  String fileDetailsBytes(String bytes);

  /// Notice title when Android blocks system or private folder
  ///
  /// In en, this message translates to:
  /// **'This folder is protected by Android.'**
  String get directoriesProtectedTitle;

  /// Description explaining Android private folder restriction
  ///
  /// In en, this message translates to:
  /// **'Android restricts access to system and app private folders.'**
  String get directoriesProtectedDesc;

  /// Notice title when folder is missing or deleted
  ///
  /// In en, this message translates to:
  /// **'This folder no longer exists.'**
  String get directoriesNotFoundTitle;

  /// Notice message when a directory has no supported items
  ///
  /// In en, this message translates to:
  /// **'No supported files or folders here.'**
  String get directoriesEmpty;

  /// Title when an error occurs trying to list a folder
  ///
  /// In en, this message translates to:
  /// **'Error opening folder'**
  String get directoriesErrorOpening;

  /// Root breadcrumb segment label
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get directoriesRoot;

  /// Header for scan frequency settings section
  ///
  /// In en, this message translates to:
  /// **'Scan frequency'**
  String get scanSettingsSectionFrequency;

  /// Header for document filters settings section
  ///
  /// In en, this message translates to:
  /// **'Document filters'**
  String get scanSettingsSectionFilters;

  /// Toggle label to include image documents in library
  ///
  /// In en, this message translates to:
  /// **'Include images'**
  String get scanSettingsIncludeImages;

  /// Explanation of the include images toggle
  ///
  /// In en, this message translates to:
  /// **'Turn off to hide thousands of photos from your document list'**
  String get scanSettingsIncludeImagesDesc;

  /// Snackbar shown after toggling image document inclusion
  ///
  /// In en, this message translates to:
  /// **'Image list updated'**
  String get scanSettingsImageListUpdated;

  /// Button label to trigger an immediate document rescan
  ///
  /// In en, this message translates to:
  /// **'Rescan now'**
  String get scanSettingsActionRescanNow;

  /// Header for storage diagnostics section on Android
  ///
  /// In en, this message translates to:
  /// **'Storage diagnostics'**
  String get scanSettingsSectionDiagnostics;

  /// Card title when All files access is active
  ///
  /// In en, this message translates to:
  /// **'All files access granted'**
  String get scanSettingsAllFilesAccessGranted;

  /// Card title when All files access is missing
  ///
  /// In en, this message translates to:
  /// **'All files access needed'**
  String get scanSettingsAllFilesAccessNeeded;

  /// Explanation when storage permission is active
  ///
  /// In en, this message translates to:
  /// **'Doc View has permission to discover files in Downloads and SD cards.'**
  String get scanSettingsAllFilesAccessGrantedDesc;

  /// Explanation when storage permission is needed
  ///
  /// In en, this message translates to:
  /// **'Permission is required to scan downloads and external storage folders.'**
  String get scanSettingsAllFilesAccessNeededDesc;

  /// Button label to open system app settings
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get scanSettingsActionOpenSettings;

  /// Status text while document scan is in progress
  ///
  /// In en, this message translates to:
  /// **'Scanning... {count} files found'**
  String scanSettingsScanningFiles(int count);

  /// CTA button label at bottom of FAQ screen
  ///
  /// In en, this message translates to:
  /// **'Still need help? Send feedback'**
  String get faqStillNeedHelp;

  /// Input field label for target file name
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get toolsLabelFileName;

  /// Empty state title in Image to PDF editor
  ///
  /// In en, this message translates to:
  /// **'Add images to start'**
  String get toolsAddImagesToStart;

  /// Empty state description in Image to PDF editor
  ///
  /// In en, this message translates to:
  /// **'Select photos or scan paper documents to generate a PDF.'**
  String get toolsAddImagesDesc;

  /// Button label to pick photos from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose photos'**
  String get toolsChoosePhotos;

  /// Button label to launch camera document scanner
  ///
  /// In en, this message translates to:
  /// **'Scan paper'**
  String get toolsScanPaper;

  /// Page indicator label on editor page row
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String toolsPageNumber(int page);

  /// Tooltip for page rotation button
  ///
  /// In en, this message translates to:
  /// **'Rotate page'**
  String get toolsTooltipRotatePage;

  /// Tooltip for page removal button
  ///
  /// In en, this message translates to:
  /// **'Remove page'**
  String get toolsTooltipRemovePage;

  /// Label on dashed add card in scanner editor
  ///
  /// In en, this message translates to:
  /// **'Add more scans'**
  String get toolsAddMoreScans;

  /// Label on dashed add card in image editor
  ///
  /// In en, this message translates to:
  /// **'Add more images'**
  String get toolsAddMoreImages;

  /// Footer summary of image count and estimated output size
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 image · est. ~ {size}} other{{count} images · est. ~ {size}}}'**
  String toolsImageSummary(int count, String size);

  /// Count of selected files in tool picker footer
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String toolsSelectedCount(int count);

  /// Guidance hint in tool picker when minimum files requirement is not yet met
  ///
  /// In en, this message translates to:
  /// **'Select at least {min} files'**
  String toolsSelectAtLeast(int min);

  /// Total page count summary across selected documents
  ///
  /// In en, this message translates to:
  /// **'{count} pages total'**
  String toolsPagesTotal(int count);

  /// Label suffix while calculating total page count
  ///
  /// In en, this message translates to:
  /// **'pages total'**
  String get toolsPagesTotalLabel;

  /// Empty state title when no PDFs are found in tool picker
  ///
  /// In en, this message translates to:
  /// **'No PDF documents found'**
  String get toolsNoPdfsFound;

  /// Accessibility status text for bookmarked files
  ///
  /// In en, this message translates to:
  /// **'bookmarked'**
  String get semanticBookmarked;

  /// Accessibility status text for selected items
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get semanticSelected;

  /// Accessibility status text for unselected items
  ///
  /// In en, this message translates to:
  /// **'not selected'**
  String get semanticNotSelected;

  /// Accessibility action hint to deselect a file
  ///
  /// In en, this message translates to:
  /// **'Deselect file'**
  String get actionDeselectFile;

  /// Accessibility action hint to select a file
  ///
  /// In en, this message translates to:
  /// **'Select file'**
  String get actionSelectFile;

  /// Action button label to create PDF document
  ///
  /// In en, this message translates to:
  /// **'Create PDF'**
  String get actionCreatePdf;

  /// Accessibility long press hint on file tile
  ///
  /// In en, this message translates to:
  /// **'Select or view actions'**
  String get hintSelectOrViewActions;

  /// Button label to close a dialog or bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// Button label to reset inputs or filters
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get actionReset;

  /// Default progress status message while a tool operation runs
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get labelPleaseWait;

  /// Tooltip for button that exits inline search mode
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get tooltipCloseSearch;

  /// Accessibility label for ad disclosure badge
  ///
  /// In en, this message translates to:
  /// **'Advertisement'**
  String get semanticAdvertisement;

  /// Mini preview label for light theme in theme picker
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themePreviewLight;

  /// Mini preview label for dark navy theme in theme picker
  ///
  /// In en, this message translates to:
  /// **'Navy'**
  String get themePreviewNavy;

  /// Accessibility label for a document card in the Created by you carousel
  ///
  /// In en, this message translates to:
  /// **'{name}, {size}, created {date}'**
  String createdByYouItemSemantic(String name, String size, String date);

  /// Progress dialog title when creating PDF from camera scans
  ///
  /// In en, this message translates to:
  /// **'Creating PDF from Scans'**
  String get toolsCreatingPdfFromScans;

  /// Progress dialog title when creating PDF from images
  ///
  /// In en, this message translates to:
  /// **'Creating PDF'**
  String get toolsCreatingPdf;

  /// Progress message while converting images into a PDF
  ///
  /// In en, this message translates to:
  /// **'Processing image {done} of {total}...'**
  String toolsProcessingImageProgress(int done, int total);

  /// Error sheet title when image-to-PDF creation fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create PDF'**
  String get toolsErrorCreatePdfTitle;

  /// Badge label for password-protected or unreadable PDF files in tool pickers
  ///
  /// In en, this message translates to:
  /// **'Protected or damaged'**
  String get toolsBadgeProtectedOrDamaged;

  /// Pluralized page count label for PDF files
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page} other{{count} pages}}'**
  String toolsPageCountPlural(int count);

  /// Short abbreviated pages suffix shown alongside skeleton loader
  ///
  /// In en, this message translates to:
  /// **'pgs'**
  String get toolsPagesAbbrev;

  /// Picker screen title when adding more PDFs from the merge screen
  ///
  /// In en, this message translates to:
  /// **'Add More PDFs'**
  String get mergeAddMoreTitle;

  /// Progress dialog title while merging PDFs
  ///
  /// In en, this message translates to:
  /// **'Merging PDFs'**
  String get mergeProgressTitle;

  /// Progress message while merging PDFs
  ///
  /// In en, this message translates to:
  /// **'Merging document {done} of {total}...'**
  String mergeProgressMessage(int done, int total);

  /// Error sheet title when PDF merge fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t merge PDFs'**
  String get mergeErrorTitle;

  /// Instruction banner text in the Merge PDF arrangement screen
  ///
  /// In en, this message translates to:
  /// **'Drag handles to reorder'**
  String get mergeDragInstruction;

  /// Button label to add another PDF to the merge list
  ///
  /// In en, this message translates to:
  /// **'Add PDF'**
  String get mergeAddPdf;

  /// Section header label above the merged PDF file name input
  ///
  /// In en, this message translates to:
  /// **'OUTPUT FILE NAME'**
  String get mergeOutputFileNameLabel;

  /// Subtitle showing page count and formatted file size for a PDF item
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page · {size}} other{{count} pages · {size}}}'**
  String mergeItemPageCountAndSize(int count, String size);

  /// Subtitle shown while PDF page count is still loading
  ///
  /// In en, this message translates to:
  /// **'Loading pages... · {size}'**
  String mergeItemLoadingPagesAndSize(String size);

  /// Pre-flight warning title when one or more selected PDFs cannot be merged
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 invalid file detected} other{{count} invalid files detected}}'**
  String mergeInvalidFilesDetected(int count);

  /// Pre-flight status title when selected PDFs are valid for merging
  ///
  /// In en, this message translates to:
  /// **'Ready to merge'**
  String get mergeReadyTitle;

  /// Pre-flight warning description asking user to remove invalid PDFs
  ///
  /// In en, this message translates to:
  /// **'Please remove password-protected documents'**
  String get mergeRemoveProtectedHint;

  /// Pre-flight summary showing total files, pages, and estimated output size
  ///
  /// In en, this message translates to:
  /// **'{files} files · {pages} pages · ~ {size}'**
  String mergeSummary(int files, int pages, String size);

  /// Short status badge on pre-flight card when merge is ready
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get mergeReadyBadge;

  /// Disabled CTA label when merge is blocked by invalid files
  ///
  /// In en, this message translates to:
  /// **'Merge Blocked (Resolve Errors)'**
  String get mergeBlockedCta;

  /// Primary CTA button label to merge selected PDFs
  ///
  /// In en, this message translates to:
  /// **'Merge {files} PDFs ({pages} Pages)'**
  String mergeActionCta(int files, int pages);

  /// Default app bar title for the Merge PDF picker screen
  ///
  /// In en, this message translates to:
  /// **'Select PDFs'**
  String get mergePickerDefaultTitle;

  /// Filter pill showing all PDFs with total count
  ///
  /// In en, this message translates to:
  /// **'All PDFs ({count})'**
  String mergePickerTabAllPdfs(int count);

  /// Filter pill for recent PDF documents in merge picker
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get mergePickerTabRecent;

  /// Filter pill for Android Downloads folder in merge picker
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get mergePickerTabDownloads;

  /// Filter pill for iOS iCloud Drive in merge picker
  ///
  /// In en, this message translates to:
  /// **'iCloud Drive'**
  String get mergePickerTabICloud;

  /// Progress dialog title while splitting a PDF
  ///
  /// In en, this message translates to:
  /// **'Splitting PDF'**
  String get splitProgressTitle;

  /// Progress message while generating split PDF files
  ///
  /// In en, this message translates to:
  /// **'Generating file {done} of {total}...'**
  String splitProgressMessage(int done, int total);

  /// Error sheet title when PDF split fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t split PDF'**
  String get splitErrorTitle;

  /// Section header label above page range text input
  ///
  /// In en, this message translates to:
  /// **'PAGE RANGES'**
  String get splitPageRangesLabel;

  /// Example page range syntax shown next to the PAGE RANGES label
  ///
  /// In en, this message translates to:
  /// **'Syntax: 1-3, 5, 8-10'**
  String get splitPageRangesSyntax;

  /// Helper text under the page ranges input field
  ///
  /// In en, this message translates to:
  /// **'Each range becomes a separate PDF file.'**
  String get splitRangeHelpText;

  /// Header showing the count of output PDF files to be generated
  ///
  /// In en, this message translates to:
  /// **'GENERATED FILES ({count})'**
  String splitGeneratedFilesHeader(int count);

  /// Title shown in output preview box when page range syntax has an error
  ///
  /// In en, this message translates to:
  /// **'Live Chips Suspended'**
  String get splitChipsSuspendedTitle;

  /// Description shown in output preview box when page range syntax has an error
  ///
  /// In en, this message translates to:
  /// **'Resolve the syntax error above to reconstruct extraction pipeline.'**
  String get splitChipsSuspendedDesc;

  /// Placeholder text when no page ranges have been entered yet
  ///
  /// In en, this message translates to:
  /// **'Enter page ranges above to generate PDF slices'**
  String get splitEmptyRangesHint;

  /// Chip label for a single-page PDF slice
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String splitChipSinglePage(int page);

  /// Chip label for a multi-page PDF slice range
  ///
  /// In en, this message translates to:
  /// **'Pages {start}–{end}'**
  String splitChipPageRange(int start, int end);

  /// Abbreviated page count badge inside a split range chip
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pg} other{{count} pgs}}'**
  String splitChipPageCountShort(int count);

  /// Section header for quick-select split range macros
  ///
  /// In en, this message translates to:
  /// **'QUICK SELECT'**
  String get splitQuickSelectLabel;

  /// Quick select macro button to split every page into its own PDF
  ///
  /// In en, this message translates to:
  /// **'All pages'**
  String get splitMacroAllPages;

  /// Quick select macro button to split into 5-page batches
  ///
  /// In en, this message translates to:
  /// **'Every 5 pages'**
  String get splitMacroEvery5Pages;

  /// Helper notice explaining why a quick-select macro is disabled
  ///
  /// In en, this message translates to:
  /// **'Macros producing > 100 files are disabled to protect device memory'**
  String get splitMacroLimitHint;

  /// Summary of how many files and total pages will be extracted
  ///
  /// In en, this message translates to:
  /// **'Output: {files} files · {pages} pages extracted'**
  String splitOutputSummary(int files, int pages);

  /// Estimated total output file size label
  ///
  /// In en, this message translates to:
  /// **'EST ~ {size}'**
  String splitEstSize(String size);

  /// Primary CTA button label when valid split ranges are configured
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Split into 1 PDF} other{Split into {count} PDFs}}'**
  String splitActionCtaCount(int count);

  /// Disabled primary CTA button label when no split ranges are configured
  ///
  /// In en, this message translates to:
  /// **'Split into PDFs'**
  String get splitActionCtaEmpty;

  /// Subheader in split picker showing count of local PDF documents
  ///
  /// In en, this message translates to:
  /// **'ALL LOCAL DOCUMENTS ({count})'**
  String splitPickerAllLocalDocs(int count);

  /// Sort indicator label in split picker subheader
  ///
  /// In en, this message translates to:
  /// **'SORT BY DATE'**
  String get splitPickerSortByDate;

  /// Suffix shown next to skeleton page count in split picker
  ///
  /// In en, this message translates to:
  /// **'pgs · {size}'**
  String splitPickerLoadingPagesAndSize(String size);

  /// App bar title on the Split PDF picker screen
  ///
  /// In en, this message translates to:
  /// **'Select PDF to split'**
  String get splitPickerTitle;

  /// Short app bar title on the FAQ screen
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faqShortTitle;

  /// Selected PDF count in the split picker footer
  ///
  /// In en, this message translates to:
  /// **'{count} PDF selected'**
  String splitPickerSelectedCount(int count);

  /// Helper text in split picker footer when no document is selected
  ///
  /// In en, this message translates to:
  /// **'Select a document to continue'**
  String get splitPickerSelectDocumentHint;

  /// Active page count for the selected PDF in split picker footer
  ///
  /// In en, this message translates to:
  /// **'{count} pages active'**
  String splitPickerPagesActive(int count);

  /// Suffix label shown next to page count skeleton in split picker footer
  ///
  /// In en, this message translates to:
  /// **'pages active'**
  String get splitPickerPagesActiveLabel;

  /// Main app bar title on the Settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Section header for general application settings
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsSectionGeneral;

  /// Section header for legal, widget, and subscription settings
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get settingsSectionOthers;

  /// Settings row title to open the system file manager
  ///
  /// In en, this message translates to:
  /// **'File manager'**
  String get settingsFileManagerTitle;

  /// Settings row subtitle for File manager
  ///
  /// In en, this message translates to:
  /// **'Browse storage directories and folders'**
  String get settingsFileManagerSubtitle;

  /// Settings row title to open Frequently Asked Questions
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get settingsFaqTitle;

  /// Settings row subtitle for FAQ
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get settingsFaqSubtitle;

  /// Settings row title to share the app with others
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get settingsShareTitle;

  /// Settings row subtitle for Share
  ///
  /// In en, this message translates to:
  /// **'Recommend Doc View to friends'**
  String get settingsShareSubtitle;

  /// Text shared via the system share sheet when sharing the app
  ///
  /// In en, this message translates to:
  /// **'Check out Doc View - Fast, private, offline document reader: {url}'**
  String settingsShareMessage(String url);

  /// Settings row title to open Scan settings
  ///
  /// In en, this message translates to:
  /// **'Scan settings'**
  String get settingsScanSettingsTitle;

  /// Subtitle on Scan settings row when automatic scan on app open is enabled
  ///
  /// In en, this message translates to:
  /// **'Scan on open'**
  String get settingsScanModeOnOpen;

  /// Subtitle on Scan settings row when manual scan only is enabled
  ///
  /// In en, this message translates to:
  /// **'Manual only'**
  String get settingsScanModeManual;

  /// Settings row title to choose the app visual theme
  ///
  /// In en, this message translates to:
  /// **'App theme'**
  String get settingsAppThemeTitle;

  /// Label when app theme follows system appearance
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

  /// Label when light theme is selected
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Label when dark theme is selected
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// Settings row title to open the Language selection screen
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// Settings row title to open the Rate Doc View bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Rate us'**
  String get settingsRateUsTitle;

  /// Settings row subtitle for Rate us
  ///
  /// In en, this message translates to:
  /// **'Share your feedback with us'**
  String get settingsRateUsSubtitle;

  /// Settings row title to add a home screen widget (behind feature flag)
  ///
  /// In en, this message translates to:
  /// **'Add Widget'**
  String get settingsAddWidgetTitle;

  /// Settings row subtitle for Add Widget
  ///
  /// In en, this message translates to:
  /// **'Quick access from your home screen'**
  String get settingsAddWidgetSubtitle;

  /// Settings row title to open Terms of use in external browser
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get settingsTermsTitle;

  /// Settings row subtitle for Terms of use
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get settingsTermsSubtitle;

  /// Settings row title to open Privacy policy in external browser
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyTitle;

  /// Settings row subtitle for Privacy policy
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get settingsPrivacySubtitle;

  /// Settings row title to open store subscription management (behind feature flag)
  ///
  /// In en, this message translates to:
  /// **'Manage subscriptions'**
  String get settingsManageSubscriptionsTitle;

  /// Settings row subtitle for Manage subscriptions
  ///
  /// In en, this message translates to:
  /// **'Manage your store subscription'**
  String get settingsManageSubscriptionsSubtitle;

  /// Centered footer text showing semantic app version and build number
  ///
  /// In en, this message translates to:
  /// **'Version {version} ({build})'**
  String settingsVersionDisplay(String version, String build);

  /// Accessibility semantics label for the app version footer
  ///
  /// In en, this message translates to:
  /// **'Version {version} build {build}'**
  String settingsVersionSemantics(String version, String build);

  /// Footer link label to open Flutter third-party licenses page
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get settingsOpenSourceLicenses;

  /// Title of the Rate us bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Rate Doc View'**
  String get rateSheetTitle;

  /// Subtitle inside the Rate us bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve'**
  String get rateSheetSubtitle;

  /// Accessibility semantics label for each star button in StarRatingBar
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 star} other{{count} stars}}'**
  String rateStarSemantics(int count);

  /// Short message shown in Rate us sheet after selecting 4 or 5 stars
  ///
  /// In en, this message translates to:
  /// **'Glad you like it!'**
  String get rateResponseHigh;

  /// Short message shown in Rate us sheet after selecting 3 stars
  ///
  /// In en, this message translates to:
  /// **'Thanks! Tell us how we can do better.'**
  String get rateResponseMedium;

  /// Short message shown in Rate us sheet after selecting 1 or 2 stars
  ///
  /// In en, this message translates to:
  /// **'Sorry it fell short. Tell us what to fix.'**
  String get rateResponseLow;

  /// Action button in Rate us sheet to open the store listing
  ///
  /// In en, this message translates to:
  /// **'Rate on Google Play'**
  String get rateActionStore;

  /// Action button in Rate us sheet to open FAQ with rating highlight banner
  ///
  /// In en, this message translates to:
  /// **'Help & feedback'**
  String get rateActionHelpFeedback;

  /// Highlight banner text displayed at the top of FAQ when opened from the Rate us sheet
  ///
  /// In en, this message translates to:
  /// **'Sorry to hear that. Browse the answers below or contact us; we read every message.'**
  String get faqFromRatingBanner;

  /// Button label inside the FAQ highlight banner to open feedback email
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get faqActionContactUs;

  /// Pre-filled email subject when contacting support from FAQ
  ///
  /// In en, this message translates to:
  /// **'Doc View Feedback ({version}+{build})'**
  String faqFeedbackEmailSubject(String version, String build);

  /// Pre-filled email body containing app version and build number
  ///
  /// In en, this message translates to:
  /// **'\n\n---\nApp: Doc View {version} (Build {build})\n'**
  String faqFeedbackEmailBody(String version, String build);

  /// Snackbar shown when no email client can handle mailto URI
  ///
  /// In en, this message translates to:
  /// **'Could not open email client'**
  String get faqEmailClientUnavailable;

  /// App bar title on the Language selection screen
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageScreenTitle;

  /// Placeholder text inside the Language screen search input
  ///
  /// In en, this message translates to:
  /// **'Search languages...'**
  String get languageSearchHint;

  /// Row title for selecting the device system default language
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystemDefault;

  /// Row subtitle for selecting the device system default language
  ///
  /// In en, this message translates to:
  /// **'Follow device language'**
  String get languageSystemDefaultSubtitle;

  /// Debug-only suffix shown for planned languages not yet translated
  ///
  /// In en, this message translates to:
  /// **'(not translated)'**
  String get languageNotTranslatedBadge;

  /// Debug-only snackbar when tapping an unshipped language row
  ///
  /// In en, this message translates to:
  /// **'This language is not translated yet'**
  String get languageNotTranslatedSnack;

  /// Empty state text when no languages match the search query
  ///
  /// In en, this message translates to:
  /// **'No matching languages'**
  String get languageNoResults;

  /// Debug-only row title for the en_XA pseudo-locale
  ///
  /// In en, this message translates to:
  /// **'Pseudo-locale (en_XA)'**
  String get languagePseudoLocaleName;

  /// Debug-only row subtitle for the en_XA pseudo-locale
  ///
  /// In en, this message translates to:
  /// **'Debug expansion testing'**
  String get languagePseudoLocaleSubtitle;

  /// Section header for History inside Scan settings
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get scanSettingsSectionHistory;

  /// Row title inside Scan settings History section
  ///
  /// In en, this message translates to:
  /// **'Clear recent history'**
  String get scanSettingsClearHistoryTitle;

  /// Row subtitle inside Scan settings History section
  ///
  /// In en, this message translates to:
  /// **'Clear opened document history'**
  String get scanSettingsClearHistorySubtitle;

  /// Confirmation dialog title when clearing recent document history
  ///
  /// In en, this message translates to:
  /// **'Clear recent history?'**
  String get scanSettingsClearHistoryDialogTitle;

  /// Confirmation dialog body when clearing recent document history
  ///
  /// In en, this message translates to:
  /// **'Files will be removed from Recent. Your files and bookmarks are not affected.'**
  String get scanSettingsClearHistoryDialogBody;

  /// Snackbar shown after recent document history is cleared
  ///
  /// In en, this message translates to:
  /// **'Recent history cleared'**
  String get scanSettingsRecentHistoryCleared;

  /// Relative day label for last scan performed today
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get scanSettingsLastScanToday;

  /// Relative day label for last scan performed yesterday
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get scanSettingsLastScanYesterday;

  /// Status shown when no library scan has completed yet
  ///
  /// In en, this message translates to:
  /// **'Never scanned'**
  String get scanSettingsNeverScanned;

  /// Prefix before the formatted last scan timestamp
  ///
  /// In en, this message translates to:
  /// **'Last scan:'**
  String get scanSettingsLastScanPrefix;

  /// Reader bottom row action to switch scroll mode to vertical
  ///
  /// In en, this message translates to:
  /// **'Vertical'**
  String get readerActionVertical;

  /// Reader bottom row action to switch scroll mode to horizontal
  ///
  /// In en, this message translates to:
  /// **'Horizontal'**
  String get readerActionHorizontal;

  /// Reader bottom row action to toggle device orientation
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get readerActionRotate;

  /// Reader bottom row action to activate document search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get readerActionSearch;

  /// Reader bottom row action to toggle page color inversion
  ///
  /// In en, this message translates to:
  /// **'Invert'**
  String get readerActionInvert;

  /// Reader bottom row action to share document
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get readerActionShare;

  /// Reader action to open pages management screen
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get readerActionPages;

  /// Hint text for document text search input
  ///
  /// In en, this message translates to:
  /// **'Search in document...'**
  String get readerSearchHint;

  /// Counter displaying active search match position out of total matches
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String readerSearchMatchCounter(int current, int total);

  /// Counter display when search matches exceed 500
  ///
  /// In en, this message translates to:
  /// **'500+'**
  String get readerSearchMatchCap;

  /// Counter display when search yields no matches
  ///
  /// In en, this message translates to:
  /// **'0 of 0'**
  String get readerSearchNoMatches;

  /// Message shown when searching a scanned PDF with no extractable text layer
  ///
  /// In en, this message translates to:
  /// **'This PDF has no searchable text'**
  String get readerSearchNoTextLayer;

  /// Tooltip for jumping to previous search result
  ///
  /// In en, this message translates to:
  /// **'Previous match'**
  String get readerSearchPrevMatch;

  /// Tooltip for jumping to next search result
  ///
  /// In en, this message translates to:
  /// **'Next match'**
  String get readerSearchNextMatch;

  /// Reader top bar subtitle showing page count and file size
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Page • {size}} other{{count} Pages • {size}}}'**
  String readerTopPagesSubtitle(int count, String size);

  /// 3-dot menu item to jump to a specific page number
  ///
  /// In en, this message translates to:
  /// **'Go to page'**
  String get readerMenuGoToPage;

  /// 3-dot menu item to bookmark current document
  ///
  /// In en, this message translates to:
  /// **'Add bookmark'**
  String get readerMenuAddBookmark;

  /// 3-dot menu item to unbookmark current document
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get readerMenuRemoveBookmark;

  /// 3-dot menu item to show file details sheet
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get readerMenuDetails;

  /// 3-dot menu item to open file in external app
  ///
  /// In en, this message translates to:
  /// **'Open in another app'**
  String get readerMenuOpenInAnotherApp;

  /// Tooltip for Convert-to-Word top bar action button
  ///
  /// In en, this message translates to:
  /// **'Convert to Word'**
  String get readerTooltipConvertToWord;

  /// Title of the PDF Pages thumbnail management screen
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pagesScreenTitle;

  /// Pages screen top bar title showing total page count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Page} other{{count} Pages}}'**
  String pagesScreenPageCount(int count);

  /// Pages screen top bar action to select all pages
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get pagesActionSelectAll;

  /// Pages screen top bar action to deselect all pages
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get pagesActionClearSelection;

  /// Pages screen top bar action to commit page edits
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get pagesActionSave;

  /// Pages screen bottom action to insert pages into document
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get pagesActionInsert;

  /// Pages screen bottom action to rotate selected pages
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get pagesActionRotate;

  /// Pages screen bottom action to extract selected pages into new PDF
  ///
  /// In en, this message translates to:
  /// **'Extract'**
  String get pagesActionExtract;

  /// Pages screen bottom action to delete selected pages
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get pagesActionDelete;

  /// Pages screen top bar action to revert last change
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get pagesActionUndo;

  /// Header for insert pages options bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Insert pages'**
  String get pagesInsertSheetTitle;

  /// Option to select another PDF from device to insert pages
  ///
  /// In en, this message translates to:
  /// **'Pages from another PDF'**
  String get pagesInsertPagesFromPdf;

  /// Warning message when user tries to delete all pages in the document
  ///
  /// In en, this message translates to:
  /// **'Cannot delete all pages. A document must have at least one page.'**
  String get pagesDeleteAllBlocked;

  /// Title of dialog when saving edited PDF pages
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get pagesSaveDialogTitle;

  /// Radio option to save edited PDF as a new copy
  ///
  /// In en, this message translates to:
  /// **'Save as new file'**
  String get pagesSaveAsNew;

  /// Radio option to overwrite the original PDF file
  ///
  /// In en, this message translates to:
  /// **'Replace original'**
  String get pagesSaveReplace;

  /// Warning notice when choosing to replace original file
  ///
  /// In en, this message translates to:
  /// **'This overwrites the original file.'**
  String get pagesSaveReplaceWarning;

  /// Input field label for the saved PDF filename
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get pagesSaveFileNameLabel;

  /// Title of confirmation dialog when leaving with unsaved page edits
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get pagesDiscardDialogTitle;

  /// Body of confirmation dialog when leaving with unsaved page edits
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to discard them?'**
  String get pagesDiscardDialogBody;

  /// Destructive button to confirm discarding changes
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get pagesDiscardButton;

  /// Success message when pages are extracted into new PDF
  ///
  /// In en, this message translates to:
  /// **'Extracted {count, plural, =1{1 page} other{{count} pages}}'**
  String pagesExtractSuccess(int count);

  /// Error displayed when trying to open pages screen on encrypted or damaged PDF
  ///
  /// In en, this message translates to:
  /// **'This PDF cannot be edited because it is encrypted or unreadable.'**
  String get pagesErrorUnreadable;

  /// Headline shown when document is damaged or cannot be parsed
  ///
  /// In en, this message translates to:
  /// **'Can\'t open this document'**
  String get viewerErrorCorruptTitle;

  /// Explanation shown when document is damaged or cannot be parsed
  ///
  /// In en, this message translates to:
  /// **'This file appears to be damaged or not a valid document.'**
  String get viewerErrorCorruptMessage;

  /// Headline shown when file does not exist on disk
  ///
  /// In en, this message translates to:
  /// **'This file no longer exists'**
  String get viewerErrorMissingTitle;

  /// Explanation shown when file does not exist on disk
  ///
  /// In en, this message translates to:
  /// **'The file has been deleted or moved from device storage.'**
  String get viewerErrorMissingMessage;

  /// Button returning to file list after file is not found
  ///
  /// In en, this message translates to:
  /// **'Back to files'**
  String get viewerErrorBackToFiles;

  /// Snackbar shown when system has no application associated with file
  ///
  /// In en, this message translates to:
  /// **'No app found to open this file'**
  String get viewerErrorNoAppFound;

  /// Counter display showing total search matches when navigation index is not tracked
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 match} other{{count} matches}}'**
  String readerSearchTotalMatches(int count);

  /// Office reader top bar subtitle showing units/slides count and file extension
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unit • {ext}} other{{count} units • {ext}}}'**
  String viewerOfficeUnitsSubtitle(int count, String ext);

  /// Notice banner for legacy office formats (doc, ppt, xls, rtf)
  ///
  /// In en, this message translates to:
  /// **'Legacy format: text only'**
  String get viewerLegacyFormatBanner;

  /// Notice banner for truncated spreadsheets exceeding row limit
  ///
  /// In en, this message translates to:
  /// **'Large spreadsheet: showing the first 3000 rows'**
  String get viewerSpreadsheetTruncatedBanner;

  /// Fallback section title in document outline sheet
  ///
  /// In en, this message translates to:
  /// **'Section {number}'**
  String viewerSectionTitle(int number);

  /// Menu action to view document outline
  ///
  /// In en, this message translates to:
  /// **'Outline'**
  String get viewerMenuOutline;

  /// Title in document outline sheet
  ///
  /// In en, this message translates to:
  /// **'Document outline'**
  String get viewerOutlineTitle;

  /// Tooltip for closing document outline sheet
  ///
  /// In en, this message translates to:
  /// **'Close outline'**
  String get viewerCloseOutline;

  /// Empty state in document outline sheet
  ///
  /// In en, this message translates to:
  /// **'No sections found in this document'**
  String get viewerNoSections;

  /// Tooltip for document outline action
  ///
  /// In en, this message translates to:
  /// **'Table of contents'**
  String get viewerOutlineTooltip;

  /// Button to open document in an external application
  ///
  /// In en, this message translates to:
  /// **'Open in another app'**
  String get viewerActionOpenExternal;

  /// Headline shown when document cannot be rendered offline
  ///
  /// In en, this message translates to:
  /// **'Can\'t open this document'**
  String get viewerErrorCantOpenTitle;

  /// Explanation shown when document cannot be rendered offline
  ///
  /// In en, this message translates to:
  /// **'The document could not be rendered offline.'**
  String get viewerErrorCantOpenMessage;

  /// Text shown during document initialization skeleton
  ///
  /// In en, this message translates to:
  /// **'Opening document...'**
  String get viewerOpeningDocument;

  /// Headline shown when document is password-protected
  ///
  /// In en, this message translates to:
  /// **'This document is encrypted'**
  String get viewerErrorEncryptedTitle;

  /// Explanation shown when document is password-protected
  ///
  /// In en, this message translates to:
  /// **'Password-protected files cannot be viewed in the offline reader.'**
  String get viewerErrorEncryptedMessage;

  /// Headline shown when file exceeds reader limits
  ///
  /// In en, this message translates to:
  /// **'This file exceeds the view limit'**
  String get viewerErrorTooLargeTitle;

  /// Explanation shown when file exceeds reader limits
  ///
  /// In en, this message translates to:
  /// **'Large documents should be opened using an external Office viewer.'**
  String get viewerErrorTooLargeMessage;

  /// Headline shown when format cannot be parsed
  ///
  /// In en, this message translates to:
  /// **'This format isn\'t supported'**
  String get viewerErrorUnsupportedFormatTitle;

  /// Explanation shown when format cannot be parsed
  ///
  /// In en, this message translates to:
  /// **'Doc View cannot parse this file format directly.'**
  String get viewerErrorUnsupportedFormatMessage;

  /// Item count badge in document outline sheet
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String viewerOutlineItemsCount(int count);

  /// Title of typography sheet in text viewer
  ///
  /// In en, this message translates to:
  /// **'Typography'**
  String get txtViewerTypographyTitle;

  /// Label displaying current font size in points
  ///
  /// In en, this message translates to:
  /// **'{size} pt'**
  String txtViewerFontSizeLabel(int size);

  /// Label for monospace font switch in text viewer
  ///
  /// In en, this message translates to:
  /// **'Monospace font'**
  String get txtViewerMonospaceLabel;

  /// Notice banner when text file exceeds 1 MB cap
  ///
  /// In en, this message translates to:
  /// **'File is larger than 1 MB: showing first 1 MB'**
  String get txtViewerTruncationBanner;

  /// Text viewer top bar subtitle showing line count and file size
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 line • {size}} other{{count} lines • {size}}}'**
  String txtViewerLinesSubtitle(int count, String size);

  /// Tooltip for typography sheet button
  ///
  /// In en, this message translates to:
  /// **'Typography settings'**
  String get txtViewerTooltipTypography;

  /// Tooltip for decrease font size button
  ///
  /// In en, this message translates to:
  /// **'Decrease font size'**
  String get txtViewerTooltipDecreaseFont;

  /// Tooltip for increase font size button
  ///
  /// In en, this message translates to:
  /// **'Increase font size'**
  String get txtViewerTooltipIncreaseFont;

  /// Tooltip for monospace font toggle
  ///
  /// In en, this message translates to:
  /// **'Toggle monospace font'**
  String get txtViewerTooltipToggleMonospace;

  /// Explanation for monospace font option
  ///
  /// In en, this message translates to:
  /// **'Fixed-width characters for code and logs'**
  String get txtViewerMonospaceSubtitle;

  /// Label for typography preview section
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get txtViewerPreviewLabel;

  /// Sample text rendered in typography preview
  ///
  /// In en, this message translates to:
  /// **'The quick brown fox jumps over the lazy dog.'**
  String get txtViewerPreviewText;

  /// Headline shown when text file cannot be read
  ///
  /// In en, this message translates to:
  /// **'Can\'t read this text file'**
  String get txtViewerErrorTitle;

  /// Explanation shown when text file cannot be read
  ///
  /// In en, this message translates to:
  /// **'The file format or encoding could not be parsed.'**
  String get txtViewerErrorMessage;

  /// Button to retry reading text file
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get txtViewerActionRetry;

  /// Image viewer top bar subtitle showing image pixel dimensions and file size
  ///
  /// In en, this message translates to:
  /// **'{width} × {height} • {size}'**
  String imageViewerDimensionsSubtitle(int width, int height, String size);

  /// Floating zoom scale indicator in image viewer
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String imageViewerZoomPill(int percent);

  /// Tooltip for reset zoom button
  ///
  /// In en, this message translates to:
  /// **'Fit to screen'**
  String get imageViewerTooltipFitToScreen;

  /// Error message when image file cannot be decoded
  ///
  /// In en, this message translates to:
  /// **'Unable to load image'**
  String get imageViewerErrorCorrupt;

  /// Snackbar shown when opening a file that no longer exists on disk
  ///
  /// In en, this message translates to:
  /// **'File no longer exists'**
  String get viewerDispatcherFileMissing;
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
