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

  /// Action button label to grant permission
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get actionAllow;

  /// Action button label to dismiss or postpone permission prompt
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
