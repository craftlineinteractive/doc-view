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
  String get actionOpenDocument => 'Open document';

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

  @override
  String get actionOpen => 'Open';

  @override
  String get actionShare => 'Share';

  @override
  String get actionRename => 'Rename';

  @override
  String get actionBookmark => 'Bookmark';

  @override
  String get actionRemoveBookmark => 'Remove bookmark';

  @override
  String get actionOpenInAnotherApp => 'Open in another app';

  @override
  String get actionDetails => 'Details';

  @override
  String get actionOpenFile => 'Open file';

  @override
  String get actionShareAll => 'Share All';

  @override
  String get actionDone => 'Done';

  @override
  String get actionSeeAll => 'See All';

  @override
  String get actionAllow => 'Allow';

  @override
  String get actionNotNow => 'Not now';

  @override
  String get tooltipMoreActions => 'More actions';

  @override
  String get tooltipCopyPath => 'Copy path';

  @override
  String get tooltipRotatePage => 'Rotate page';

  @override
  String get tooltipRemovePage => 'Remove page';

  @override
  String get renameFileTitle => 'Rename file';

  @override
  String get renameFileNameLabel => 'File name';

  @override
  String renamedSuccess(String fileName) {
    return 'Renamed to $fileName';
  }

  @override
  String get deleteFileTitle => 'Delete file?';

  @override
  String deleteFileConfirmation(String fileName) {
    return 'Delete \"$fileName\"? This can\'t be undone.';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return 'Deleted \"$fileName\"';
  }

  @override
  String get fileDetailsTitle => 'Document Details';

  @override
  String get fileDetailsLabelName => 'Name';

  @override
  String get fileDetailsLabelType => 'Type';

  @override
  String get fileDetailsLabelSize => 'Size';

  @override
  String get fileDetailsLabelModified => 'Modified';

  @override
  String get fileDetailsLabelBookmarked => 'Bookmarked';

  @override
  String get fileDetailsValueYes => 'Yes';

  @override
  String get fileDetailsValueNo => 'No';

  @override
  String get fileDetailsLabelLocation => 'Location';

  @override
  String get fileDetailsPathCopied => 'Path copied to clipboard';

  @override
  String get directoriesTitle => 'Directories';

  @override
  String get directoriesGoBack => 'Go back';

  @override
  String get directoriesGoToRoot => 'Go to Root';

  @override
  String get directoriesRetry => 'Retry';

  @override
  String get directoriesFileNoLongerExists => 'File no longer exists';

  @override
  String get directoriesFolderNoLongerExists => 'This folder no longer exists.';

  @override
  String get directoriesNoDocsInFolder => 'No documents in this folder';

  @override
  String get directoriesFilesAppearHere => 'Files will appear here once added';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => 'Folder';

  @override
  String get directoriesPermissionPromptTitle =>
      'Access required to view directories';

  @override
  String get directoriesPermissionPromptBody =>
      'Doc View needs All files access to browse your folders.';

  @override
  String get directoriesGrantAccess => 'Grant access';

  @override
  String get directoriesImportInstead => 'Import files instead';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imported $count files',
      one: 'Imported 1 file',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => 'Up one level';

  @override
  String get storageAccessRequiredTitle => 'Storage Access Required';

  @override
  String get storageAccessRequiredBody =>
      'Doc View needs storage access to scan and display documents (PDF, Word, Excel, PPT, TXT, Images) stored on your device.\n\nYour files remain completely private and offline on your device.';

  @override
  String errorCouldNotOpenDocument(String error) {
    return 'Could not open document: $error';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Scan complete: $count files',
      one: 'Scan complete: 1 file',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => 'Clear search history?';

  @override
  String get dialogClearSearchMessage =>
      'All recent searches will be permanently cleared.';

  @override
  String imageListEditorMaxLimit(int max) {
    return 'Maximum limit of $max images reached.';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return 'Scanning failed: $error';
  }

  @override
  String get imageListEditorPageSize => 'Page Size:';

  @override
  String get imageListEditorA4Mode => 'A4';

  @override
  String get imageListEditorFitMode => 'Fit to image';

  @override
  String get imageListEditorRemoveImageTooltip => 'Remove image';

  @override
  String get mergeScreenTitle => 'Arrange & merge';

  @override
  String get mergeScreenDefaultMergedName => 'Merged_Document';

  @override
  String get mergePickerSearchHint => 'Search PDFs...';

  @override
  String get mergePickerNext => 'Next';

  @override
  String mergePickerErrorLoading(String error) {
    return 'Error loading PDFs: $error';
  }

  @override
  String get splitScreenTitle => 'Split PDF';

  @override
  String get splitScreenRangeHint => 'e.g. 1-3, 5, 8-10';

  @override
  String get splitScreenClearRange => 'Clear range';

  @override
  String get splitPickerSearchHint => 'Search PDFs...';

  @override
  String splitPickerErrorLoading(String error) {
    return 'Error loading files: $error';
  }

  @override
  String get createdSectionTitle => 'Created by you';

  @override
  String get createdSectionEmptyTitle => 'PDFs you create appear here';

  @override
  String get createdSectionEmptySubtitle =>
      'Converted, scanned, or merged documents will be saved locally.';

  @override
  String get emptyCreatedDocsTitle => 'No created documents yet';

  @override
  String get emptyCreatedDocsMessage =>
      'Converted, scanned, or merged documents will appear here.';

  @override
  String errorLoadingCreatedFiles(String error) {
    return 'Failed to load created files: $error';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDFs Created',
      one: 'PDF Created',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle => 'Saved to your Created folder';

  @override
  String get toolErrorDefaultTitle => 'Couldn\'t create PDF';

  @override
  String get toolErrorSubtitle =>
      'An unexpected error occurred during processing';

  @override
  String get themeSheetTitle => 'App theme';

  @override
  String get themeSheetSubtitle => 'Select visual appearance for Doc View';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeSystemSubtitle => 'default';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeLightSubtitle => 'Clean white';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get themeModeDarkSubtitle => 'Deep navy';

  @override
  String get themeActionApply => 'Apply theme';

  @override
  String get scanSettingsTitle => 'Scan settings';

  @override
  String get scanSettingsFrequencyHeader => 'Scan frequency';

  @override
  String get scanSettingsOnOpenTitle => 'Scan on app open';

  @override
  String get scanSettingsOnOpenSubtitle =>
      'Automatically find new files when you open Doc View.';

  @override
  String get scanSettingsManualTitle => 'Manual only';

  @override
  String get scanSettingsManualSubtitle =>
      'Only scan when you pull to refresh or tap Rescan.';

  @override
  String get scanSettingsMediaFiltersHeader => 'Media filters';

  @override
  String get scanSettingsIncludeImagesTitle => 'Include images in scan';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      'Index PNG, JPG, and WEBP image files in storage.';

  @override
  String get scanSettingsDiagnosticsHeader => 'Storage & diagnostics';

  @override
  String get scanSettingsPermissionStatus => 'All files access';

  @override
  String get scanSettingsPermissionGranted => 'Granted';

  @override
  String get scanSettingsPermissionNotGranted => 'Not granted';

  @override
  String get scanSettingsTotalIndexed => 'Indexed files';

  @override
  String get scanSettingsLastScan => 'Last scanned';

  @override
  String get scanSettingsUpdatedSnackbar => 'Scan settings updated';

  @override
  String get faqScreenTitle => 'Frequently Asked Questions';

  @override
  String faqHeaderTopics(int count) {
    return '$count Topics';
  }

  @override
  String get faqHeaderSubtitle => 'Got questions? Find clear answers here.';

  @override
  String get faqSendFeedback => 'Send feedback';

  @override
  String get faqQuestion1 => 'Why does Doc View need All files access?';

  @override
  String get faqAnswer1 =>
      'Doc View requires All files access (MANAGE_EXTERNAL_STORAGE) on Android 11+ to discover and index supported documents (PDF, Word, Excel, PowerPoint, Text, and Images) stored in shared folders such as Downloads and Documents.\n\nWithout this permission, Android restricts file access to the app\'s private internal folder, preventing Doc View from browsing or opening files located across your device.';

  @override
  String get faqQuestion2 => 'Why doesn\'t it scan my whole iPhone?';

  @override
  String get faqAnswer2 =>
      'iOS uses strict app sandboxing to safeguard device privacy. Apps can only access documents explicitly saved inside the Files app or shared via the system Share Sheet.\n\nTo view files on iOS, import them into the Doc View folder in the native Files app or use the Import files option in Settings.';

  @override
  String get faqQuestion3 => 'Where are the PDFs I create saved?';

  @override
  String get faqAnswer3 =>
      'Files you import or generate (such as converted PDFs, merged documents, or split pages) are saved securely in your device storage under DocView/Created or private app storage. You can view them anytime in the Created by you section on the Tools tab.';

  @override
  String get faqQuestion4 => 'Why does my Word file look different?';

  @override
  String get faqAnswer4 =>
      'Doc View renders files directly on your device using local offline parsers without sending private data to cloud converters. Complex formatting or custom shapes render with native offline approximations.';

  @override
  String get faqQuestion5 => 'Can I open password-protected files?';

  @override
  String get faqAnswer5 =>
      'Yes, Doc View supports opening password-protected PDF documents. When opening an encrypted PDF, enter the password in the dialog to decrypt and view the document on your device.';

  @override
  String get faqQuestion6 => 'Is my data uploaded anywhere?';

  @override
  String get faqAnswer6 =>
      'Your documents never leave your device. Doc View opens, converts and stores files locally. The app shows ads served by Google AdMob, which can use limited device data as described in our Privacy Policy.';

  @override
  String get pdfGotoPageTitle => 'Go to page';

  @override
  String pdfGotoPageHint(int pageCount) {
    return 'Enter a page between 1 and $pageCount';
  }

  @override
  String get pdfGotoPageAction => 'Go';

  @override
  String get pdfGotoPageErrorEmpty => 'Enter a page number';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return 'Enter a page between 1 and $pageCount';
  }

  @override
  String get pdfPasswordTitle => 'This PDF is password-protected';

  @override
  String get pdfPasswordSubtitle =>
      'Enter password to view and decrypt the contents.';

  @override
  String get pdfPasswordHint => 'Enter password';

  @override
  String get pdfPasswordErrorIncorrect => 'Incorrect password. Try again.';

  @override
  String get pdfPasswordActionUnlock => 'Unlock';

  @override
  String get errorFileNameEmpty => 'File name cannot be empty';

  @override
  String get errorFileNameTooLong => 'File name cannot exceed 120 characters';

  @override
  String get errorFileNameReserved => 'File name cannot be \'.\' or \'..\'';

  @override
  String get errorFileNameStartsWithDot => 'File name cannot start with a dot';

  @override
  String get errorFileNameInvalidChars =>
      'File name contains invalid characters';

  @override
  String get errorRenameAlreadyExists =>
      'A file with this name already exists in this folder';

  @override
  String get errorRenameSourceNotFound =>
      'Source file no longer exists on disk';

  @override
  String errorRenameFailed(String details) {
    return 'Failed to rename file: $details';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      'Files deleted from disk but database update failed';

  @override
  String errorDeleteFailed(String details) {
    return 'Failed to delete files: $details';
  }

  @override
  String get errorPageRangeDocNoPages => 'Document has no pages';

  @override
  String get errorPageRangeEmpty => 'Page range cannot be empty';

  @override
  String get errorPageRangeEmptySegment =>
      'Empty range segment found. Remove extra commas.';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return 'Invalid range format: \'$token\'';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return 'Incomplete range: \'$token\'';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return 'Non-numeric values in range: \'$token\'';
  }

  @override
  String get errorPageRangeBelowMinimum => 'Page numbers must be 1 or greater';

  @override
  String errorPageRangeReversed(int start, int end) {
    return 'Reversed range \'$start-$end\': start is greater than end';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return 'Range \'$token\' exceeds total pages ($totalPages)';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return 'Invalid page number: \'$token\'';
  }

  @override
  String get errorImageToPdfNoImages => 'Please select at least one image';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return 'Maximum $max images allowed at a time';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return 'Failed to process image: $path';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return 'Failed to create PDF from images: $details';
  }

  @override
  String get errorPdfMergeInsufficient =>
      'Please select at least 2 PDF files to merge';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return '$fileName is password-protected or damaged';
  }

  @override
  String get errorPdfMergeNoPages => 'Selected documents contain no pages';

  @override
  String errorPdfMergeFailed(String details) {
    return 'PDF merging failed: $details';
  }

  @override
  String get errorPdfSplitNoRanges => 'Please specify at least one page range';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return '$fileName is password-protected or damaged';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return 'Range $start-$end is out of bounds for $fileName';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return 'Failed to split PDF: $details';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return 'PG $current/$total';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '($bytes bytes)';
  }

  @override
  String get directoriesProtectedTitle =>
      'This folder is protected by Android.';

  @override
  String get directoriesProtectedDesc =>
      'Android restricts access to system and app private folders.';

  @override
  String get directoriesNotFoundTitle => 'This folder no longer exists.';

  @override
  String get directoriesEmpty => 'No supported files or folders here.';

  @override
  String get directoriesErrorOpening => 'Error opening folder';

  @override
  String get directoriesRoot => 'Root';

  @override
  String get scanSettingsSectionFrequency => 'Scan frequency';

  @override
  String get scanSettingsSectionFilters => 'Document filters';

  @override
  String get scanSettingsIncludeImages => 'Include images';

  @override
  String get scanSettingsIncludeImagesDesc =>
      'Turn off to hide thousands of photos from your document list';

  @override
  String get scanSettingsImageListUpdated => 'Image list updated';

  @override
  String get scanSettingsActionRescanNow => 'Rescan now';

  @override
  String get scanSettingsSectionDiagnostics => 'Storage diagnostics';

  @override
  String get scanSettingsAllFilesAccessGranted => 'All files access granted';

  @override
  String get scanSettingsAllFilesAccessNeeded => 'All files access needed';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      'Doc View has permission to discover files in Downloads and SD cards.';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      'Permission is required to scan downloads and external storage folders.';

  @override
  String get scanSettingsActionOpenSettings => 'Open settings';

  @override
  String scanSettingsScanningFiles(int count) {
    return 'Scanning... $count files found';
  }

  @override
  String get faqStillNeedHelp => 'Still need help? Send feedback';

  @override
  String get toolsLabelFileName => 'File Name';

  @override
  String get toolsAddImagesToStart => 'Add images to start';

  @override
  String get toolsAddImagesDesc =>
      'Select photos or scan paper documents to generate a PDF.';

  @override
  String get toolsChoosePhotos => 'Choose photos';

  @override
  String get toolsScanPaper => 'Scan paper';

  @override
  String toolsPageNumber(int page) {
    return 'Page $page';
  }

  @override
  String get toolsTooltipRotatePage => 'Rotate page';

  @override
  String get toolsTooltipRemovePage => 'Remove page';

  @override
  String get toolsAddMoreScans => 'Add more scans';

  @override
  String get toolsAddMoreImages => 'Add more images';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images · est. ~ $size',
      one: '1 image · est. ~ $size',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return 'Select at least $min files';
  }

  @override
  String toolsPagesTotal(int count) {
    return '$count pages total';
  }

  @override
  String get toolsPagesTotalLabel => 'pages total';

  @override
  String get toolsNoPdfsFound => 'No PDF documents found';

  @override
  String get semanticBookmarked => 'bookmarked';

  @override
  String get semanticSelected => 'selected';

  @override
  String get semanticNotSelected => 'not selected';

  @override
  String get actionDeselectFile => 'Deselect file';

  @override
  String get actionSelectFile => 'Select file';

  @override
  String get actionCreatePdf => 'Create PDF';

  @override
  String get hintSelectOrViewActions => 'Select or view actions';

  @override
  String get actionClose => 'Close';

  @override
  String get actionReset => 'Reset';

  @override
  String get labelPleaseWait => 'Please wait...';

  @override
  String get tooltipCloseSearch => 'Close search';

  @override
  String get semanticAdvertisement => 'Advertisement';

  @override
  String get themePreviewLight => 'Light';

  @override
  String get themePreviewNavy => 'Navy';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '$name, $size, created $date';
  }

  @override
  String get toolsCreatingPdfFromScans => 'Creating PDF from Scans';

  @override
  String get toolsCreatingPdf => 'Creating PDF';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return 'Processing image $done of $total...';
  }

  @override
  String get toolsErrorCreatePdfTitle => 'Couldn\'t create PDF';

  @override
  String get toolsBadgeProtectedOrDamaged => 'Protected or damaged';

  @override
  String toolsPageCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String get toolsPagesAbbrev => 'pgs';

  @override
  String get mergeAddMoreTitle => 'Add More PDFs';

  @override
  String get mergeProgressTitle => 'Merging PDFs';

  @override
  String mergeProgressMessage(int done, int total) {
    return 'Merging document $done of $total...';
  }

  @override
  String get mergeErrorTitle => 'Couldn\'t merge PDFs';

  @override
  String get mergeDragInstruction => 'Drag handles to reorder';

  @override
  String get mergeAddPdf => 'Add PDF';

  @override
  String get mergeOutputFileNameLabel => 'OUTPUT FILE NAME';

  @override
  String mergeItemPageCountAndSize(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages · $size',
      one: '1 page · $size',
    );
    return '$_temp0';
  }

  @override
  String mergeItemLoadingPagesAndSize(String size) {
    return 'Loading pages... · $size';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invalid files detected',
      one: '1 invalid file detected',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => 'Ready to merge';

  @override
  String get mergeRemoveProtectedHint =>
      'Please remove password-protected documents';

  @override
  String mergeSummary(int files, int pages, String size) {
    return '$files files · $pages pages · ~ $size';
  }

  @override
  String get mergeReadyBadge => 'Ready';

  @override
  String get mergeBlockedCta => 'Merge Blocked (Resolve Errors)';

  @override
  String mergeActionCta(int files, int pages) {
    return 'Merge $files PDFs ($pages Pages)';
  }

  @override
  String get mergePickerDefaultTitle => 'Select PDFs';

  @override
  String mergePickerTabAllPdfs(int count) {
    return 'All PDFs ($count)';
  }

  @override
  String get mergePickerTabRecent => 'Recent';

  @override
  String get mergePickerTabDownloads => 'Downloads';

  @override
  String get mergePickerTabICloud => 'iCloud Drive';

  @override
  String get splitProgressTitle => 'Splitting PDF';

  @override
  String splitProgressMessage(int done, int total) {
    return 'Generating file $done of $total...';
  }

  @override
  String get splitErrorTitle => 'Couldn\'t split PDF';

  @override
  String get splitPageRangesLabel => 'PAGE RANGES';

  @override
  String get splitPageRangesSyntax => 'Syntax: 1-3, 5, 8-10';

  @override
  String get splitRangeHelpText => 'Each range becomes a separate PDF file.';

  @override
  String splitGeneratedFilesHeader(int count) {
    return 'GENERATED FILES ($count)';
  }

  @override
  String get splitChipsSuspendedTitle => 'Live Chips Suspended';

  @override
  String get splitChipsSuspendedDesc =>
      'Resolve the syntax error above to reconstruct extraction pipeline.';

  @override
  String get splitEmptyRangesHint =>
      'Enter page ranges above to generate PDF slices';

  @override
  String splitChipSinglePage(int page) {
    return 'Page $page';
  }

  @override
  String splitChipPageRange(int start, int end) {
    return 'Pages $start–$end';
  }

  @override
  String splitChipPageCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pgs',
      one: '1 pg',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => 'QUICK SELECT';

  @override
  String get splitMacroAllPages => 'All pages';

  @override
  String get splitMacroEvery5Pages => 'Every 5 pages';

  @override
  String get splitMacroLimitHint =>
      'Macros producing > 100 files are disabled to protect device memory';

  @override
  String splitOutputSummary(int files, int pages) {
    return 'Output: $files files · $pages pages extracted';
  }

  @override
  String splitEstSize(String size) {
    return 'EST ~ $size';
  }

  @override
  String splitActionCtaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Split into $count PDFs',
      one: 'Split into 1 PDF',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => 'Split into PDFs';

  @override
  String splitPickerAllLocalDocs(int count) {
    return 'ALL LOCAL DOCUMENTS ($count)';
  }

  @override
  String get splitPickerSortByDate => 'SORT BY DATE';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return 'pgs · $size';
  }

  @override
  String get splitPickerTitle => 'Select PDF to split';

  @override
  String get faqShortTitle => 'FAQ';

  @override
  String splitPickerSelectedCount(int count) {
    return '$count PDF selected';
  }

  @override
  String get splitPickerSelectDocumentHint => 'Select a document to continue';

  @override
  String splitPickerPagesActive(int count) {
    return '$count pages active';
  }

  @override
  String get splitPickerPagesActiveLabel => 'pages active';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionOthers => 'Others';

  @override
  String get settingsFileManagerTitle => 'File manager';

  @override
  String get settingsFileManagerSubtitle =>
      'Browse storage directories and folders';

  @override
  String get settingsFaqTitle => 'FAQ';

  @override
  String get settingsFaqSubtitle => 'Frequently asked questions';

  @override
  String get settingsShareTitle => 'Share';

  @override
  String get settingsShareSubtitle => 'Recommend Doc View to friends';

  @override
  String settingsShareMessage(String url) {
    return 'Check out Doc View - Fast, private, offline document reader: $url';
  }

  @override
  String get settingsScanSettingsTitle => 'Scan settings';

  @override
  String get settingsScanModeOnOpen => 'Scan on open';

  @override
  String get settingsScanModeManual => 'Manual only';

  @override
  String get settingsAppThemeTitle => 'App theme';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsRateUsTitle => 'Rate us';

  @override
  String get settingsRateUsSubtitle => 'Share your feedback with us';

  @override
  String get settingsAddWidgetTitle => 'Add Widget';

  @override
  String get settingsAddWidgetSubtitle => 'Quick access from your home screen';

  @override
  String get settingsTermsTitle => 'Terms of use';

  @override
  String get settingsTermsSubtitle => 'Read our terms of service';

  @override
  String get settingsPrivacyTitle => 'Privacy policy';

  @override
  String get settingsPrivacySubtitle => 'Read our privacy policy';

  @override
  String get settingsManageSubscriptionsTitle => 'Manage subscriptions';

  @override
  String get settingsManageSubscriptionsSubtitle =>
      'Manage your store subscription';

  @override
  String settingsVersionDisplay(String version, String build) {
    return 'Version $version ($build)';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return 'Version $version build $build';
  }

  @override
  String get settingsOpenSourceLicenses => 'Open-source licenses';

  @override
  String get rateSheetTitle => 'Rate Doc View';

  @override
  String get rateSheetSubtitle => 'Your feedback helps us improve';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: '1 star',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => 'Glad you like it!';

  @override
  String get rateResponseMedium => 'Thanks! Tell us how we can do better.';

  @override
  String get rateResponseLow => 'Sorry it fell short. Tell us what to fix.';

  @override
  String get rateActionStore => 'Rate on Google Play';

  @override
  String get rateActionHelpFeedback => 'Help & feedback';

  @override
  String get faqFromRatingBanner =>
      'Sorry to hear that. Browse the answers below or contact us; we read every message.';

  @override
  String get faqActionContactUs => 'Contact us';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return 'Doc View Feedback ($version+$build)';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '\n\n---\nApp: Doc View $version (Build $build)\n';
  }

  @override
  String get faqEmailClientUnavailable => 'Could not open email client';

  @override
  String get languageScreenTitle => 'Language';

  @override
  String get languageSearchHint => 'Search languages...';

  @override
  String get languageSystemDefault => 'System default';

  @override
  String get languageSystemDefaultSubtitle => 'Follow device language';

  @override
  String get languageNotTranslatedBadge => '(not translated)';

  @override
  String get languageNotTranslatedSnack =>
      'This language is not translated yet';

  @override
  String get languageNoResults => 'No matching languages';

  @override
  String get languagePseudoLocaleName => 'Pseudo-locale (en_XA)';

  @override
  String get languagePseudoLocaleSubtitle => 'Debug expansion testing';

  @override
  String get scanSettingsSectionHistory => 'History';

  @override
  String get scanSettingsClearHistoryTitle => 'Clear recent history';

  @override
  String get scanSettingsClearHistorySubtitle =>
      'Clear opened document history';

  @override
  String get scanSettingsClearHistoryDialogTitle => 'Clear recent history?';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      'Files will be removed from Recent. Your files and bookmarks are not affected.';

  @override
  String get scanSettingsRecentHistoryCleared => 'Recent history cleared';

  @override
  String get scanSettingsLastScanToday => 'today';

  @override
  String get scanSettingsLastScanYesterday => 'yesterday';

  @override
  String get scanSettingsNeverScanned => 'Never scanned';

  @override
  String get scanSettingsLastScanPrefix => 'Last scan:';

  @override
  String get readerActionVertical => 'Vertical';

  @override
  String get readerActionHorizontal => 'Horizontal';

  @override
  String get readerActionRotate => 'Rotate';

  @override
  String get readerActionSearch => 'Search';

  @override
  String get readerActionInvert => 'Invert';

  @override
  String get readerActionShare => 'Share';

  @override
  String get readerActionPages => 'Pages';

  @override
  String get readerSearchHint => 'Search in document...';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '$current of $total';
  }

  @override
  String get readerSearchMatchCap => '500+';

  @override
  String get readerSearchNoMatches => '0 of 0';

  @override
  String get readerSearchNoTextLayer => 'This PDF has no searchable text';

  @override
  String get readerSearchPrevMatch => 'Previous match';

  @override
  String get readerSearchNextMatch => 'Next match';

  @override
  String readerTopPagesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pages • $size',
      one: '1 Page • $size',
    );
    return '$_temp0';
  }

  @override
  String get readerMenuGoToPage => 'Go to page';

  @override
  String get readerMenuAddBookmark => 'Add bookmark';

  @override
  String get readerMenuRemoveBookmark => 'Remove bookmark';

  @override
  String get readerMenuDetails => 'Details';

  @override
  String get readerMenuOpenInAnotherApp => 'Open in another app';

  @override
  String get readerTooltipConvertToWord => 'Convert to Word';

  @override
  String get pagesScreenTitle => 'Pages';

  @override
  String pagesScreenPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pages',
      one: '1 Page',
    );
    return '$_temp0';
  }

  @override
  String get pagesActionSelectAll => 'Select all';

  @override
  String get pagesActionClearSelection => 'Clear';

  @override
  String get pagesActionSave => 'Save';

  @override
  String get pagesActionInsert => 'Insert';

  @override
  String get pagesActionRotate => 'Rotate';

  @override
  String get pagesActionExtract => 'Extract';

  @override
  String get pagesActionDelete => 'Delete';

  @override
  String get pagesActionUndo => 'Undo';

  @override
  String get pagesInsertSheetTitle => 'Insert pages';

  @override
  String get pagesInsertPagesFromPdf => 'Pages from another PDF';

  @override
  String get pagesDeleteAllBlocked =>
      'Cannot delete all pages. A document must have at least one page.';

  @override
  String get pagesSaveDialogTitle => 'Save changes';

  @override
  String get pagesSaveAsNew => 'Save as new file';

  @override
  String get pagesSaveReplace => 'Replace original';

  @override
  String get pagesSaveReplaceWarning => 'This overwrites the original file.';

  @override
  String get pagesSaveFileNameLabel => 'File name';

  @override
  String get pagesDiscardDialogTitle => 'Discard changes?';

  @override
  String get pagesDiscardDialogBody =>
      'You have unsaved changes. Are you sure you want to discard them?';

  @override
  String get pagesDiscardButton => 'Discard';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return 'Extracted $_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      'This PDF cannot be edited because it is encrypted or unreadable.';

  @override
  String get viewerErrorCorruptTitle => 'Can\'t open this document';

  @override
  String get viewerErrorCorruptMessage =>
      'This file appears to be damaged or not a valid document.';

  @override
  String get viewerErrorMissingTitle => 'This file no longer exists';

  @override
  String get viewerErrorMissingMessage =>
      'The file has been deleted or moved from device storage.';

  @override
  String get viewerErrorBackToFiles => 'Back to files';

  @override
  String get viewerErrorNoAppFound => 'No app found to open this file';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count matches',
      one: '1 match',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count units • $ext',
      one: '1 unit • $ext',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner => 'Legacy format: text only';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      'Large spreadsheet: showing the first 3000 rows';

  @override
  String viewerSectionTitle(int number) {
    return 'Section $number';
  }

  @override
  String get viewerMenuOutline => 'Outline';

  @override
  String get viewerOutlineTitle => 'Document outline';

  @override
  String get viewerCloseOutline => 'Close outline';

  @override
  String get viewerNoSections => 'No sections found in this document';

  @override
  String get viewerOutlineTooltip => 'Table of contents';

  @override
  String get viewerActionOpenExternal => 'Open in another app';

  @override
  String get viewerErrorCantOpenTitle => 'Can\'t open this document';

  @override
  String get viewerErrorCantOpenMessage =>
      'The document could not be rendered offline.';

  @override
  String get viewerOpeningDocument => 'Opening document...';

  @override
  String get viewerErrorEncryptedTitle => 'This document is encrypted';

  @override
  String get viewerErrorEncryptedMessage =>
      'Password-protected files cannot be viewed in the offline reader.';

  @override
  String get viewerErrorTooLargeTitle => 'This file exceeds the view limit';

  @override
  String get viewerErrorTooLargeMessage =>
      'Large documents should be opened using an external Office viewer.';

  @override
  String get viewerErrorUnsupportedFormatTitle =>
      'This format isn\'t supported';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      'Doc View cannot parse this file format directly.';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => 'Typography';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get txtViewerMonospaceLabel => 'Monospace font';

  @override
  String get txtViewerTruncationBanner =>
      'File is larger than 1 MB: showing first 1 MB';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lines • $size',
      one: '1 line • $size',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => 'Typography settings';

  @override
  String get txtViewerTooltipDecreaseFont => 'Decrease font size';

  @override
  String get txtViewerTooltipIncreaseFont => 'Increase font size';

  @override
  String get txtViewerTooltipToggleMonospace => 'Toggle monospace font';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '$width × $height • $size';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get imageViewerTooltipFitToScreen => 'Fit to screen';

  @override
  String get imageViewerErrorCorrupt => 'Unable to load image';

  @override
  String get viewerDispatcherFileMissing => 'File no longer exists';
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
  String get actionOpenDocument => '[Öþéñ đôçûɱéñţ ẋẋẋẋẋẋ]';

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

  @override
  String get actionOpen => '[Öþéñ ẋẋ]';

  @override
  String get actionShare => '[Šĥàřé ẋẋ]';

  @override
  String get actionRename => '[Řéñàɱé ẋẋẋ]';

  @override
  String get actionBookmark => '[Ɓôôƙɱàřƙ ẋẋẋẋ]';

  @override
  String get actionRemoveBookmark => '[Řéɱôṽé ƀôôƙɱàřƙ ẋẋẋẋẋẋ]';

  @override
  String get actionOpenInAnotherApp => '[Öþéñ îñ àñôţĥéř àþþ ẋẋẋẋẋẋẋẋ]';

  @override
  String get actionDetails => '[Ðéţàîłš ẋẋẋ]';

  @override
  String get actionOpenFile => '[Öþéñ ƒîłé ẋẋẋẋ]';

  @override
  String get actionShareAll => '[Šĥàřé Åłł ẋẋẋẋ]';

  @override
  String get actionDone => '[Ðôñé ẋẋ]';

  @override
  String get actionSeeAll => '[Šéé Åłł ẋẋẋ]';

  @override
  String get actionAllow => '[Åłłôŵ ẋẋ]';

  @override
  String get actionNotNow => '[Ñôţ ñôŵ ẋẋẋ]';

  @override
  String get tooltipMoreActions => '[Ṁôřé àçţîôñš ẋẋẋẋẋ]';

  @override
  String get tooltipCopyPath => '[Çôþý þàţĥ ẋẋẋẋ]';

  @override
  String get tooltipRotatePage => '[Řôţàţé þàĝé ẋẋẋẋẋ]';

  @override
  String get tooltipRemovePage => '[Řéɱôṽé þàĝé ẋẋẋẋẋ]';

  @override
  String get renameFileTitle => '[Řéñàɱé ƒîłé ẋẋẋẋẋ]';

  @override
  String get renameFileNameLabel => '[Ƒîłé ñàɱé ẋẋẋẋ]';

  @override
  String renamedSuccess(String fileName) {
    return '[Řéñàɱéđ ţô $fileName ẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get deleteFileTitle => '[Ðéłéţé ƒîłé? ẋẋẋẋẋ]';

  @override
  String deleteFileConfirmation(String fileName) {
    return '[Ðéłéţé \"$fileName\"? Ťĥîš çàñ\'ţ ƀé ûñđôñé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return '[Ðéłéţéđ \"$fileName\" ẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get fileDetailsTitle => '[Ðôçûɱéñţ Ðéţàîłš ẋẋẋẋẋẋẋ]';

  @override
  String get fileDetailsLabelName => '[Ñàɱé ẋẋ]';

  @override
  String get fileDetailsLabelType => '[Ťýþé ẋẋ]';

  @override
  String get fileDetailsLabelSize => '[Šîžé ẋẋ]';

  @override
  String get fileDetailsLabelModified => '[Ṁôđîƒîéđ ẋẋẋẋ]';

  @override
  String get fileDetailsLabelBookmarked => '[Ɓôôƙɱàřƙéđ ẋẋẋẋ]';

  @override
  String get fileDetailsValueYes => '[Ýéš ẋẋ]';

  @override
  String get fileDetailsValueNo => '[Ñô ẋẋ]';

  @override
  String get fileDetailsLabelLocation => '[Łôçàţîôñ ẋẋẋẋ]';

  @override
  String get fileDetailsPathCopied => '[Þàţĥ çôþîéđ ţô çłîþƀôàřđ ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get directoriesTitle => '[Ðîřéçţôřîéš ẋẋẋẋẋ]';

  @override
  String get directoriesGoBack => '[Ĝô ƀàçƙ ẋẋẋ]';

  @override
  String get directoriesGoToRoot => '[Ĝô ţô Řôôţ ẋẋẋẋ]';

  @override
  String get directoriesRetry => '[Řéţřý ẋẋ]';

  @override
  String get directoriesFileNoLongerExists =>
      '[Ƒîłé ñô łôñĝéř éẋîšţš ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get directoriesFolderNoLongerExists =>
      '[Ťĥîš ƒôłđéř ñô łôñĝéř éẋîšţš. ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get directoriesNoDocsInFolder =>
      '[Ñô đôçûɱéñţš îñ ţĥîš ƒôłđéř ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get directoriesFilesAppearHere =>
      '[Ƒîłéš ŵîłł àþþéàř ĥéřé ôñçé àđđéđ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count îţéɱš ẋẋẋẋẋẋ]',
      one: '[1 îţéɱ ẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => '[Ƒôłđéř ẋẋẋ]';

  @override
  String get directoriesPermissionPromptTitle =>
      '[Åççéšš řéʠûîřéđ ţô ṽîéŵ đîřéçţôřîéš ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get directoriesPermissionPromptBody =>
      '[Ðôç Ṽîéŵ ñééđš Åłł ƒîłéš àççéšš ţô ƀřôŵšé ýôûř ƒôłđéřš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get directoriesGrantAccess => '[Ĝřàñţ àççéšš ẋẋẋẋẋ]';

  @override
  String get directoriesImportInstead => '[Îɱþôřţ ƒîłéš îñšţéàđ ẋẋẋẋẋẋẋẋ]';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[Îɱþôřţéđ $count ƒîłéš ẋẋẋẋẋẋẋẋẋ]',
      one: '[Îɱþôřţéđ 1 ƒîłé ẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => '[Ûþ ôñé łéṽéł ẋẋẋẋẋ]';

  @override
  String get storageAccessRequiredTitle =>
      '[Šţôřàĝé Åççéšš Řéʠûîřéđ ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get storageAccessRequiredBody =>
      '[Ðôç Ṽîéŵ ñééđš šţôřàĝé àççéšš ţô šçàñ àñđ đîšþłàý đôçûɱéñţš (ÞÐƑ, Ŵôřđ, Éẋçéł, ÞÞŤ, ŤẊŤ, Îɱàĝéš) šţôřéđ ôñ ýôûř đéṽîçé.\n\nÝôûř ƒîłéš řéɱàîñ çôɱþłéţéłý þřîṽàţé àñđ ôƒƒłîñé ôñ ýôûř đéṽîçé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String errorCouldNotOpenDocument(String error) {
    return '[Çôûłđ ñôţ ôþéñ đôçûɱéñţ: $error ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[Šçàñ çôɱþłéţé: $count ƒîłéš ẋẋẋẋẋẋẋẋẋẋẋẋ]',
      one: '[Šçàñ çôɱþłéţé: 1 ƒîłé ẋẋẋẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => '[Çłéàř šéàřçĥ ĥîšţôřý? ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get dialogClearSearchMessage =>
      '[Åłł řéçéñţ šéàřçĥéš ŵîłł ƀé þéřɱàñéñţłý çłéàřéđ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String imageListEditorMaxLimit(int max) {
    return '[Ṁàẋîɱûɱ łîɱîţ ôƒ $max îɱàĝéš řéàçĥéđ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return '[Šçàññîñĝ ƒàîłéđ: $error ẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get imageListEditorPageSize => '[Þàĝé Šîžé: ẋẋẋẋ]';

  @override
  String get imageListEditorA4Mode => '[Å4 ẋẋ]';

  @override
  String get imageListEditorFitMode => '[Ƒîţ ţô îɱàĝé ẋẋẋẋẋ]';

  @override
  String get imageListEditorRemoveImageTooltip => '[Řéɱôṽé îɱàĝé ẋẋẋẋẋ]';

  @override
  String get mergeScreenTitle => '[Åřřàñĝé & ɱéřĝé ẋẋẋẋẋẋ]';

  @override
  String get mergeScreenDefaultMergedName => '[Ṁéřĝéđ_Ðôçûɱéñţ ẋẋẋẋẋẋ]';

  @override
  String get mergePickerSearchHint => '[Šéàřçĥ ÞÐƑš... ẋẋẋẋẋẋ]';

  @override
  String get mergePickerNext => '[Ñéẋţ ẋẋ]';

  @override
  String mergePickerErrorLoading(String error) {
    return '[Éřřôř łôàđîñĝ ÞÐƑš: $error ẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get splitScreenTitle => '[Šþłîţ ÞÐƑ ẋẋẋẋ]';

  @override
  String get splitScreenRangeHint => '[é.ĝ. 1-3, 5, 8-10 ẋẋẋẋẋẋẋ]';

  @override
  String get splitScreenClearRange => '[Çłéàř řàñĝé ẋẋẋẋẋ]';

  @override
  String get splitPickerSearchHint => '[Šéàřçĥ ÞÐƑš... ẋẋẋẋẋẋ]';

  @override
  String splitPickerErrorLoading(String error) {
    return '[Éřřôř łôàđîñĝ ƒîłéš: $error ẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get createdSectionTitle => '[Çřéàţéđ ƀý ýôû ẋẋẋẋẋẋ]';

  @override
  String get createdSectionEmptyTitle =>
      '[ÞÐƑš ýôû çřéàţé àþþéàř ĥéřé ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get createdSectionEmptySubtitle =>
      '[Çôñṽéřţéđ, šçàññéđ, ôř ɱéřĝéđ đôçûɱéñţš ŵîłł ƀé šàṽéđ łôçàłłý. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get emptyCreatedDocsTitle => '[Ñô çřéàţéđ đôçûɱéñţš ýéţ ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get emptyCreatedDocsMessage =>
      '[Çôñṽéřţéđ, šçàññéđ, ôř ɱéřĝéđ đôçûɱéñţš ŵîłł àþþéàř ĥéřé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String errorLoadingCreatedFiles(String error) {
    return '[Ƒàîłéđ ţô łôàđ çřéàţéđ ƒîłéš: $error ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count ÞÐƑš Çřéàţéđ ẋẋẋẋẋẋẋẋ]',
      one: '[ÞÐƑ Çřéàţéđ ẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle =>
      '[Šàṽéđ ţô ýôûř Çřéàţéđ ƒôłđéř ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get toolErrorDefaultTitle => '[Çôûłđñ\'ţ çřéàţé ÞÐƑ ẋẋẋẋẋẋẋẋ]';

  @override
  String get toolErrorSubtitle =>
      '[Åñ ûñéẋþéçţéđ éřřôř ôççûřřéđ đûřîñĝ þřôçéššîñĝ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get themeSheetTitle => '[Åþþ ţĥéɱé ẋẋẋẋ]';

  @override
  String get themeSheetSubtitle =>
      '[Šéłéçţ ṽîšûàł àþþéàřàñçé ƒôř Ðôç Ṽîéŵ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get themeModeSystem => '[Šýšţéɱ ẋẋẋ]';

  @override
  String get themeModeSystemSubtitle => '[đéƒàûłţ ẋẋẋ]';

  @override
  String get themeModeLight => '[Łîĝĥţ ẋẋ]';

  @override
  String get themeModeLightSubtitle => '[Çłéàñ ŵĥîţé ẋẋẋẋẋ]';

  @override
  String get themeModeDark => '[Ðàřƙ ẋẋ]';

  @override
  String get themeModeDarkSubtitle => '[Ðééþ ñàṽý ẋẋẋẋ]';

  @override
  String get themeActionApply => '[Åþþłý ţĥéɱé ẋẋẋẋẋ]';

  @override
  String get scanSettingsTitle => '[Šçàñ šéţţîñĝš ẋẋẋẋẋẋ]';

  @override
  String get scanSettingsFrequencyHeader => '[Šçàñ ƒřéʠûéñçý ẋẋẋẋẋẋ]';

  @override
  String get scanSettingsOnOpenTitle => '[Šçàñ ôñ àþþ ôþéñ ẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsOnOpenSubtitle =>
      '[Åûţôɱàţîçàłłý ƒîñđ ñéŵ ƒîłéš ŵĥéñ ýôû ôþéñ Ðôç Ṽîéŵ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsManualTitle => '[Ṁàñûàł ôñłý ẋẋẋẋẋ]';

  @override
  String get scanSettingsManualSubtitle =>
      '[Öñłý šçàñ ŵĥéñ ýôû þûłł ţô řéƒřéšĥ ôř ţàþ Řéšçàñ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsMediaFiltersHeader => '[Ṁéđîà ƒîłţéřš ẋẋẋẋẋẋ]';

  @override
  String get scanSettingsIncludeImagesTitle =>
      '[Îñçłûđé îɱàĝéš îñ šçàñ ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      '[Îñđéẋ ÞÑĜ, ĴÞĜ, àñđ ŴÉƁÞ îɱàĝé ƒîłéš îñ šţôřàĝé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsDiagnosticsHeader =>
      '[Šţôřàĝé & đîàĝñôšţîçš ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsPermissionStatus => '[Åłł ƒîłéš àççéšš ẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsPermissionGranted => '[Ĝřàñţéđ ẋẋẋ]';

  @override
  String get scanSettingsPermissionNotGranted => '[Ñôţ ĝřàñţéđ ẋẋẋẋẋ]';

  @override
  String get scanSettingsTotalIndexed => '[Îñđéẋéđ ƒîłéš ẋẋẋẋẋẋ]';

  @override
  String get scanSettingsLastScan => '[Łàšţ šçàññéđ ẋẋẋẋẋ]';

  @override
  String get scanSettingsUpdatedSnackbar => '[Šçàñ šéţţîñĝš ûþđàţéđ ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqScreenTitle => '[Ƒřéʠûéñţłý Åšƙéđ Ǫûéšţîôñš ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String faqHeaderTopics(int count) {
    return '[$count Ťôþîçš ẋẋẋẋẋẋ]';
  }

  @override
  String get faqHeaderSubtitle =>
      '[Ĝôţ ʠûéšţîôñš? Ƒîñđ çłéàř àñšŵéřš ĥéřé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqSendFeedback => '[Šéñđ ƒééđƀàçƙ ẋẋẋẋẋẋ]';

  @override
  String get faqQuestion1 =>
      '[Ŵĥý đôéš Ðôç Ṽîéŵ ñééđ Åłł ƒîłéš àççéšš? ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqAnswer1 =>
      '[Ðôç Ṽîéŵ řéʠûîřéš Åłł ƒîłéš àççéšš (ṀÅÑÅĜÉ_ÉẊŤÉŘÑÅŁ_ŠŤÖŘÅĜÉ) ôñ Åñđřôîđ 11+ ţô đîšçôṽéř àñđ îñđéẋ šûþþôřţéđ đôçûɱéñţš (ÞÐƑ, Ŵôřđ, Éẋçéł, ÞôŵéřÞôîñţ, Ťéẋţ, àñđ Îɱàĝéš) šţôřéđ îñ šĥàřéđ ƒôłđéřš šûçĥ àš Ðôŵñłôàđš àñđ Ðôçûɱéñţš.\n\nŴîţĥôûţ ţĥîš þéřɱîššîôñ, Åñđřôîđ řéšţřîçţš ƒîłé àççéšš ţô ţĥé àþþ\'š þřîṽàţé îñţéřñàł ƒôłđéř, þřéṽéñţîñĝ Ðôç Ṽîéŵ ƒřôɱ ƀřôŵšîñĝ ôř ôþéñîñĝ ƒîłéš łôçàţéđ àçřôšš ýôûř đéṽîçé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqQuestion2 =>
      '[Ŵĥý đôéšñ\'ţ îţ šçàñ ɱý ŵĥôłé îÞĥôñé? ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqAnswer2 =>
      '[îÖŠ ûšéš šţřîçţ àþþ šàñđƀôẋîñĝ ţô šàƒéĝûàřđ đéṽîçé þřîṽàçý. Åþþš çàñ ôñłý àççéšš đôçûɱéñţš éẋþłîçîţłý šàṽéđ îñšîđé ţĥé Ƒîłéš àþþ ôř šĥàřéđ ṽîà ţĥé šýšţéɱ Šĥàřé Šĥééţ.\n\nŤô ṽîéŵ ƒîłéš ôñ îÖŠ, îɱþôřţ ţĥéɱ îñţô ţĥé Ðôç Ṽîéŵ ƒôłđéř îñ ţĥé ñàţîṽé Ƒîłéš àþþ ôř ûšé ţĥé Îɱþôřţ ƒîłéš ôþţîôñ îñ Šéţţîñĝš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqQuestion3 =>
      '[Ŵĥéřé àřé ţĥé ÞÐƑš Î çřéàţé šàṽéđ? ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqAnswer3 =>
      '[Ƒîłéš ýôû îɱþôřţ ôř ĝéñéřàţé (šûçĥ àš çôñṽéřţéđ ÞÐƑš, ɱéřĝéđ đôçûɱéñţš, ôř šþłîţ þàĝéš) àřé šàṽéđ šéçûřéłý îñ ýôûř đéṽîçé šţôřàĝé ûñđéř ÐôçṼîéŵ/Çřéàţéđ ôř þřîṽàţé àþþ šţôřàĝé. Ýôû çàñ ṽîéŵ ţĥéɱ àñýţîɱé îñ ţĥé Çřéàţéđ ƀý ýôû šéçţîôñ ôñ ţĥé Ťôôłš ţàƀ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqQuestion4 =>
      '[Ŵĥý đôéš ɱý Ŵôřđ ƒîłé łôôƙ đîƒƒéřéñţ? ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqAnswer4 =>
      '[Ðôç Ṽîéŵ řéñđéřš ƒîłéš đîřéçţłý ôñ ýôûř đéṽîçé ûšîñĝ łôçàł ôƒƒłîñé þàřšéřš ŵîţĥôûţ šéñđîñĝ þřîṽàţé đàţà ţô çłôûđ çôñṽéřţéřš. Çôɱþłéẋ ƒôřɱàţţîñĝ ôř çûšţôɱ šĥàþéš řéñđéř ŵîţĥ ñàţîṽé ôƒƒłîñé àþþřôẋîɱàţîôñš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqQuestion5 =>
      '[Çàñ Î ôþéñ þàššŵôřđ-þřôţéçţéđ ƒîłéš? ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqAnswer5 =>
      '[Ýéš, Ðôç Ṽîéŵ šûþþôřţš ôþéñîñĝ þàššŵôřđ-þřôţéçţéđ ÞÐƑ đôçûɱéñţš. Ŵĥéñ ôþéñîñĝ àñ éñçřýþţéđ ÞÐƑ, éñţéř ţĥé þàššŵôřđ îñ ţĥé đîàłôĝ ţô đéçřýþţ àñđ ṽîéŵ ţĥé đôçûɱéñţ ôñ ýôûř đéṽîçé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqQuestion6 => '[Îš ɱý đàţà ûþłôàđéđ àñýŵĥéřé? ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqAnswer6 =>
      '[Ýôûř đôçûɱéñţš ñéṽéř łéàṽé ýôûř đéṽîçé. Ðôç Ṽîéŵ ôþéñš, çôñṽéřţš àñđ šţôřéš ƒîłéš łôçàłłý. Ťĥé àþþ šĥôŵš àđš šéřṽéđ ƀý Ĝôôĝłé ÅđṀôƀ, ŵĥîçĥ çàñ ûšé łîɱîţéđ đéṽîçé đàţà àš đéšçřîƀéđ îñ ôûř Þřîṽàçý Þôłîçý. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get pdfGotoPageTitle => '[Ĝô ţô þàĝé ẋẋẋẋ]';

  @override
  String pdfGotoPageHint(int pageCount) {
    return '[Éñţéř à þàĝé ƀéţŵééñ 1 àñđ $pageCount ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get pdfGotoPageAction => '[Ĝô ẋẋ]';

  @override
  String get pdfGotoPageErrorEmpty => '[Éñţéř à þàĝé ñûɱƀéř ẋẋẋẋẋẋẋẋ]';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return '[Éñţéř à þàĝé ƀéţŵééñ 1 àñđ $pageCount ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get pdfPasswordTitle =>
      '[Ťĥîš ÞÐƑ îš þàššŵôřđ-þřôţéçţéđ ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get pdfPasswordSubtitle =>
      '[Éñţéř þàššŵôřđ ţô ṽîéŵ àñđ đéçřýþţ ţĥé çôñţéñţš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get pdfPasswordHint => '[Éñţéř þàššŵôřđ ẋẋẋẋẋẋ]';

  @override
  String get pdfPasswordErrorIncorrect =>
      '[Îñçôřřéçţ þàššŵôřđ. Ťřý àĝàîñ. ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get pdfPasswordActionUnlock => '[Ûñłôçƙ ẋẋẋ]';

  @override
  String get errorFileNameEmpty => '[Ƒîłé ñàɱé çàññôţ ƀé éɱþţý ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get errorFileNameTooLong =>
      '[Ƒîłé ñàɱé çàññôţ éẋçééđ 120 çĥàřàçţéřš ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get errorFileNameReserved =>
      '[Ƒîłé ñàɱé çàññôţ ƀé \'.\' ôř \'..\' ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get errorFileNameStartsWithDot =>
      '[Ƒîłé ñàɱé çàññôţ šţàřţ ŵîţĥ à đôţ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get errorFileNameInvalidChars =>
      '[Ƒîłé ñàɱé çôñţàîñš îñṽàłîđ çĥàřàçţéřš ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get errorRenameAlreadyExists =>
      '[Å ƒîłé ŵîţĥ ţĥîš ñàɱé àłřéàđý éẋîšţš îñ ţĥîš ƒôłđéř ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get errorRenameSourceNotFound =>
      '[Šôûřçé ƒîłé ñô łôñĝéř éẋîšţš ôñ đîšƙ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String errorRenameFailed(String details) {
    return '[Ƒàîłéđ ţô řéñàɱé ƒîłé: $details ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      '[Ƒîłéš đéłéţéđ ƒřôɱ đîšƙ ƀûţ đàţàƀàšé ûþđàţé ƒàîłéđ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String errorDeleteFailed(String details) {
    return '[Ƒàîłéđ ţô đéłéţé ƒîłéš: $details ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get errorPageRangeDocNoPages => '[Ðôçûɱéñţ ĥàš ñô þàĝéš ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get errorPageRangeEmpty => '[Þàĝé řàñĝé çàññôţ ƀé éɱþţý ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get errorPageRangeEmptySegment =>
      '[Éɱþţý řàñĝé šéĝɱéñţ ƒôûñđ. Řéɱôṽé éẋţřà çôɱɱàš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return '[Îñṽàłîđ řàñĝé ƒôřɱàţ: \'$token\' ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return '[Îñçôɱþłéţé řàñĝé: \'$token\' ẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return '[Ñôñ-ñûɱéřîç ṽàłûéš îñ řàñĝé: \'$token\' ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get errorPageRangeBelowMinimum =>
      '[Þàĝé ñûɱƀéřš ɱûšţ ƀé 1 ôř ĝřéàţéř ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String errorPageRangeReversed(int start, int end) {
    return '[Řéṽéřšéđ řàñĝé \'$start-$end\': šţàřţ îš ĝřéàţéř ţĥàñ éñđ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return '[Řàñĝé \'$token\' éẋçééđš ţôţàł þàĝéš ($totalPages) ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return '[Îñṽàłîđ þàĝé ñûɱƀéř: \'$token\' ẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get errorImageToPdfNoImages =>
      '[Þłéàšé šéłéçţ àţ łéàšţ ôñé îɱàĝé ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return '[Ṁàẋîɱûɱ $max îɱàĝéš àłłôŵéđ àţ à ţîɱé ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return '[Ƒàîłéđ ţô þřôçéšš îɱàĝé: $path ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return '[Ƒàîłéđ ţô çřéàţé ÞÐƑ ƒřôɱ îɱàĝéš: $details ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get errorPdfMergeInsufficient =>
      '[Þłéàšé šéłéçţ àţ łéàšţ 2 ÞÐƑ ƒîłéš ţô ɱéřĝé ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return '[$fileName îš þàššŵôřđ-þřôţéçţéđ ôř đàɱàĝéđ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get errorPdfMergeNoPages =>
      '[Šéłéçţéđ đôçûɱéñţš çôñţàîñ ñô þàĝéš ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String errorPdfMergeFailed(String details) {
    return '[ÞÐƑ ɱéřĝîñĝ ƒàîłéđ: $details ẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get errorPdfSplitNoRanges =>
      '[Þłéàšé šþéçîƒý àţ łéàšţ ôñé þàĝé řàñĝé ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return '[$fileName îš þàššŵôřđ-þřôţéçţéđ ôř đàɱàĝéđ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return '[Řàñĝé $start-$end îš ôûţ ôƒ ƀôûñđš ƒôř $fileName ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return '[Ƒàîłéđ ţô šþłîţ ÞÐƑ: $details ẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return '[ÞĜ $current/$total ẋẋẋẋẋẋẋẋ]';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '[($bytes ƀýţéš) ẋẋẋẋẋẋ]';
  }

  @override
  String get directoriesProtectedTitle =>
      '[Ťĥîš ƒôłđéř îš þřôţéçţéđ ƀý Åñđřôîđ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get directoriesProtectedDesc =>
      '[Åñđřôîđ řéšţřîçţš àççéšš ţô šýšţéɱ àñđ àþþ þřîṽàţé ƒôłđéřš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get directoriesNotFoundTitle =>
      '[Ťĥîš ƒôłđéř ñô łôñĝéř éẋîšţš. ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get directoriesEmpty =>
      '[Ñô šûþþôřţéđ ƒîłéš ôř ƒôłđéřš ĥéřé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get directoriesErrorOpening => '[Éřřôř ôþéñîñĝ ƒôłđéř ẋẋẋẋẋẋẋẋ]';

  @override
  String get directoriesRoot => '[Řôôţ ẋẋ]';

  @override
  String get scanSettingsSectionFrequency => '[Šçàñ ƒřéʠûéñçý ẋẋẋẋẋẋ]';

  @override
  String get scanSettingsSectionFilters => '[Ðôçûɱéñţ ƒîłţéřš ẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsIncludeImages => '[Îñçłûđé îɱàĝéš ẋẋẋẋẋẋ]';

  @override
  String get scanSettingsIncludeImagesDesc =>
      '[Ťûřñ ôƒƒ ţô ĥîđé ţĥôûšàñđš ôƒ þĥôţôš ƒřôɱ ýôûř đôçûɱéñţ łîšţ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsImageListUpdated => '[Îɱàĝé łîšţ ûþđàţéđ ẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsActionRescanNow => '[Řéšçàñ ñôŵ ẋẋẋẋ]';

  @override
  String get scanSettingsSectionDiagnostics => '[Šţôřàĝé đîàĝñôšţîçš ẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsAllFilesAccessGranted =>
      '[Åłł ƒîłéš àççéšš ĝřàñţéđ ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsAllFilesAccessNeeded =>
      '[Åłł ƒîłéš àççéšš ñééđéđ ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      '[Ðôç Ṽîéŵ ĥàš þéřɱîššîôñ ţô đîšçôṽéř ƒîłéš îñ Ðôŵñłôàđš àñđ ŠÐ çàřđš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      '[Þéřɱîššîôñ îš řéʠûîřéđ ţô šçàñ đôŵñłôàđš àñđ éẋţéřñàł šţôřàĝé ƒôłđéřš. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsActionOpenSettings => '[Öþéñ šéţţîñĝš ẋẋẋẋẋẋ]';

  @override
  String scanSettingsScanningFiles(int count) {
    return '[Šçàññîñĝ... $count ƒîłéš ƒôûñđ ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get faqStillNeedHelp =>
      '[Šţîłł ñééđ ĥéłþ? Šéñđ ƒééđƀàçƙ ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get toolsLabelFileName => '[Ƒîłé Ñàɱé ẋẋẋẋ]';

  @override
  String get toolsAddImagesToStart => '[Åđđ îɱàĝéš ţô šţàřţ ẋẋẋẋẋẋẋẋ]';

  @override
  String get toolsAddImagesDesc =>
      '[Šéłéçţ þĥôţôš ôř šçàñ þàþéř đôçûɱéñţš ţô ĝéñéřàţé à ÞÐƑ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get toolsChoosePhotos => '[Çĥôôšé þĥôţôš ẋẋẋẋẋẋ]';

  @override
  String get toolsScanPaper => '[Šçàñ þàþéř ẋẋẋẋ]';

  @override
  String toolsPageNumber(int page) {
    return '[Þàĝé $page ẋẋẋẋẋ]';
  }

  @override
  String get toolsTooltipRotatePage => '[Řôţàţé þàĝé ẋẋẋẋẋ]';

  @override
  String get toolsTooltipRemovePage => '[Řéɱôṽé þàĝé ẋẋẋẋẋ]';

  @override
  String get toolsAddMoreScans => '[Åđđ ɱôřé šçàñš ẋẋẋẋẋẋ]';

  @override
  String get toolsAddMoreImages => '[Åđđ ɱôřé îɱàĝéš ẋẋẋẋẋẋ]';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count îɱàĝéš · éšţ. ~ $size ẋẋẋẋẋẋẋẋẋẋẋẋ]',
      one: '[1 îɱàĝé · éšţ. ~ $size ẋẋẋẋẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return '[$count šéłéçţéđ ẋẋẋẋẋẋẋ]';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return '[Šéłéçţ àţ łéàšţ $min ƒîłéš ẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String toolsPagesTotal(int count) {
    return '[$count þàĝéš ţôţàł ẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get toolsPagesTotalLabel => '[þàĝéš ţôţàł ẋẋẋẋẋ]';

  @override
  String get toolsNoPdfsFound => '[Ñô ÞÐƑ đôçûɱéñţš ƒôûñđ ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get semanticBookmarked => '[ƀôôƙɱàřƙéđ ẋẋẋẋ]';

  @override
  String get semanticSelected => '[šéłéçţéđ ẋẋẋẋ]';

  @override
  String get semanticNotSelected => '[ñôţ šéłéçţéđ ẋẋẋẋẋ]';

  @override
  String get actionDeselectFile => '[Ðéšéłéçţ ƒîłé ẋẋẋẋẋẋ]';

  @override
  String get actionSelectFile => '[Šéłéçţ ƒîłé ẋẋẋẋẋ]';

  @override
  String get actionCreatePdf => '[Çřéàţé ÞÐƑ ẋẋẋẋ]';

  @override
  String get hintSelectOrViewActions => '[Šéłéçţ ôř ṽîéŵ àçţîôñš ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get actionClose => '[Çłôšé ẋẋ]';

  @override
  String get actionReset => '[Řéšéţ ẋẋ]';

  @override
  String get labelPleaseWait => '[Þłéàšé ŵàîţ... ẋẋẋẋẋẋ]';

  @override
  String get tooltipCloseSearch => '[Çłôšé šéàřçĥ ẋẋẋẋẋ]';

  @override
  String get semanticAdvertisement => '[Åđṽéřţîšéɱéñţ ẋẋẋẋẋẋ]';

  @override
  String get themePreviewLight => '[Łîĝĥţ ẋẋ]';

  @override
  String get themePreviewNavy => '[Ñàṽý ẋẋ]';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '[$name, $size, çřéàţéđ $date ẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get toolsCreatingPdfFromScans =>
      '[Çřéàţîñĝ ÞÐƑ ƒřôɱ Šçàñš ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get toolsCreatingPdf => '[Çřéàţîñĝ ÞÐƑ ẋẋẋẋẋ]';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return '[Þřôçéššîñĝ îɱàĝé $done ôƒ $total... ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get toolsErrorCreatePdfTitle => '[Çôûłđñ\'ţ çřéàţé ÞÐƑ ẋẋẋẋẋẋẋẋ]';

  @override
  String get toolsBadgeProtectedOrDamaged => '[Þřôţéçţéđ ôř đàɱàĝéđ ẋẋẋẋẋẋẋẋ]';

  @override
  String toolsPageCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count þàĝéš ẋẋẋẋẋẋ]',
      one: '[1 þàĝé ẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get toolsPagesAbbrev => '[þĝš ẋẋ]';

  @override
  String get mergeAddMoreTitle => '[Åđđ Ṁôřé ÞÐƑš ẋẋẋẋẋẋ]';

  @override
  String get mergeProgressTitle => '[Ṁéřĝîñĝ ÞÐƑš ẋẋẋẋẋ]';

  @override
  String mergeProgressMessage(int done, int total) {
    return '[Ṁéřĝîñĝ đôçûɱéñţ $done ôƒ $total... ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get mergeErrorTitle => '[Çôûłđñ\'ţ ɱéřĝé ÞÐƑš ẋẋẋẋẋẋẋẋ]';

  @override
  String get mergeDragInstruction => '[Ðřàĝ ĥàñđłéš ţô řéôřđéř ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get mergeAddPdf => '[Åđđ ÞÐƑ ẋẋẋ]';

  @override
  String get mergeOutputFileNameLabel => '[ÖÛŤÞÛŤ ƑÎŁÉ ÑÅṀÉ ẋẋẋẋẋẋẋ]';

  @override
  String mergeItemPageCountAndSize(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count þàĝéš · $size ẋẋẋẋẋẋẋẋẋ]',
      one: '[1 þàĝé · $size ẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String mergeItemLoadingPagesAndSize(String size) {
    return '[Łôàđîñĝ þàĝéš... · $size ẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count îñṽàłîđ ƒîłéš đéţéçţéđ ẋẋẋẋẋẋẋẋẋẋẋẋ]',
      one: '[1 îñṽàłîđ ƒîłé đéţéçţéđ ẋẋẋẋẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => '[Řéàđý ţô ɱéřĝé ẋẋẋẋẋẋ]';

  @override
  String get mergeRemoveProtectedHint =>
      '[Þłéàšé řéɱôṽé þàššŵôřđ-þřôţéçţéđ đôçûɱéñţš ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String mergeSummary(int files, int pages, String size) {
    return '[$files ƒîłéš · $pages þàĝéš · ~ $size ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get mergeReadyBadge => '[Řéàđý ẋẋ]';

  @override
  String get mergeBlockedCta => '[Ṁéřĝé Ɓłôçƙéđ (Řéšôłṽé Éřřôřš) ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String mergeActionCta(int files, int pages) {
    return '[Ṁéřĝé $files ÞÐƑš ($pages Þàĝéš) ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get mergePickerDefaultTitle => '[Šéłéçţ ÞÐƑš ẋẋẋẋẋ]';

  @override
  String mergePickerTabAllPdfs(int count) {
    return '[Åłł ÞÐƑš ($count) ẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get mergePickerTabRecent => '[Řéçéñţ ẋẋẋ]';

  @override
  String get mergePickerTabDownloads => '[Ðôŵñłôàđš ẋẋẋẋ]';

  @override
  String get mergePickerTabICloud => '[îÇłôûđ Ðřîṽé ẋẋẋẋẋ]';

  @override
  String get splitProgressTitle => '[Šþłîţţîñĝ ÞÐƑ ẋẋẋẋẋẋ]';

  @override
  String splitProgressMessage(int done, int total) {
    return '[Ĝéñéřàţîñĝ ƒîłé $done ôƒ $total... ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get splitErrorTitle => '[Çôûłđñ\'ţ šþłîţ ÞÐƑ ẋẋẋẋẋẋẋẋ]';

  @override
  String get splitPageRangesLabel => '[ÞÅĜÉ ŘÅÑĜÉŠ ẋẋẋẋẋ]';

  @override
  String get splitPageRangesSyntax => '[Šýñţàẋ: 1-3, 5, 8-10 ẋẋẋẋẋẋẋẋ]';

  @override
  String get splitRangeHelpText =>
      '[Éàçĥ řàñĝé ƀéçôɱéš à šéþàřàţé ÞÐƑ ƒîłé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String splitGeneratedFilesHeader(int count) {
    return '[ĜÉÑÉŘÅŤÉÐ ƑÎŁÉŠ ($count) ẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get splitChipsSuspendedTitle => '[Łîṽé Çĥîþš Šûšþéñđéđ ẋẋẋẋẋẋẋẋ]';

  @override
  String get splitChipsSuspendedDesc =>
      '[Řéšôłṽé ţĥé šýñţàẋ éřřôř àƀôṽé ţô řéçôñšţřûçţ éẋţřàçţîôñ þîþéłîñé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get splitEmptyRangesHint =>
      '[Éñţéř þàĝé řàñĝéš àƀôṽé ţô ĝéñéřàţé ÞÐƑ šłîçéš ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String splitChipSinglePage(int page) {
    return '[Þàĝé $page ẋẋẋẋẋ]';
  }

  @override
  String splitChipPageRange(int start, int end) {
    return '[Þàĝéš $start–$end ẋẋẋẋẋẋẋẋ]';
  }

  @override
  String splitChipPageCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count þĝš ẋẋẋẋẋ]',
      one: '[1 þĝ ẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => '[ǪÛÎÇĶ ŠÉŁÉÇŤ ẋẋẋẋẋ]';

  @override
  String get splitMacroAllPages => '[Åłł þàĝéš ẋẋẋẋ]';

  @override
  String get splitMacroEvery5Pages => '[Éṽéřý 5 þàĝéš ẋẋẋẋẋẋ]';

  @override
  String get splitMacroLimitHint =>
      '[Ṁàçřôš þřôđûçîñĝ > 100 ƒîłéš àřé đîšàƀłéđ ţô þřôţéçţ đéṽîçé ɱéɱôřý ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String splitOutputSummary(int files, int pages) {
    return '[Öûţþûţ: $files ƒîłéš · $pages þàĝéš éẋţřàçţéđ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String splitEstSize(String size) {
    return '[ÉŠŤ ~ $size ẋẋẋẋẋ]';
  }

  @override
  String splitActionCtaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[Šþłîţ îñţô $count ÞÐƑš ẋẋẋẋẋẋẋẋẋẋ]',
      one: '[Šþłîţ îñţô 1 ÞÐƑ ẋẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => '[Šþłîţ îñţô ÞÐƑš ẋẋẋẋẋẋ]';

  @override
  String splitPickerAllLocalDocs(int count) {
    return '[ÅŁŁ ŁÖÇÅŁ ÐÖÇÛṀÉÑŤŠ ($count) ẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get splitPickerSortByDate => '[ŠÖŘŤ ƁÝ ÐÅŤÉ ẋẋẋẋẋ]';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return '[þĝš · $size ẋẋẋẋẋ]';
  }

  @override
  String get splitPickerTitle => '[Šéłéçţ ÞÐƑ ţô šþłîţ ẋẋẋẋẋẋẋẋ]';

  @override
  String get faqShortTitle => '[ƑÅǪ ẋẋ]';

  @override
  String splitPickerSelectedCount(int count) {
    return '[$count ÞÐƑ šéłéçţéđ ẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get splitPickerSelectDocumentHint =>
      '[Šéłéçţ à đôçûɱéñţ ţô çôñţîñûé ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String splitPickerPagesActive(int count) {
    return '[$count þàĝéš àçţîṽé ẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get splitPickerPagesActiveLabel => '[þàĝéš àçţîṽé ẋẋẋẋẋ]';

  @override
  String get settingsTitle => '[Šéţţîñĝš ẋẋẋẋ]';

  @override
  String get settingsSectionGeneral => '[Ĝéñéřàł ẋẋẋ]';

  @override
  String get settingsSectionOthers => '[Öţĥéřš ẋẋẋ]';

  @override
  String get settingsFileManagerTitle => '[Ƒîłé ɱàñàĝéř ẋẋẋẋẋ]';

  @override
  String get settingsFileManagerSubtitle =>
      '[Ɓřôŵšé šţôřàĝé đîřéçţôřîéš àñđ ƒôłđéřš ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get settingsFaqTitle => '[ƑÅǪ ẋẋ]';

  @override
  String get settingsFaqSubtitle => '[Ƒřéʠûéñţłý àšƙéđ ʠûéšţîôñš ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get settingsShareTitle => '[Šĥàřé ẋẋ]';

  @override
  String get settingsShareSubtitle =>
      '[Řéçôɱɱéñđ Ðôç Ṽîéŵ ţô ƒřîéñđš ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String settingsShareMessage(String url) {
    return '[Çĥéçƙ ôûţ Ðôç Ṽîéŵ - Ƒàšţ, þřîṽàţé, ôƒƒłîñé đôçûɱéñţ řéàđéř: $url ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get settingsScanSettingsTitle => '[Šçàñ šéţţîñĝš ẋẋẋẋẋẋ]';

  @override
  String get settingsScanModeOnOpen => '[Šçàñ ôñ ôþéñ ẋẋẋẋẋ]';

  @override
  String get settingsScanModeManual => '[Ṁàñûàł ôñłý ẋẋẋẋẋ]';

  @override
  String get settingsAppThemeTitle => '[Åþþ ţĥéɱé ẋẋẋẋ]';

  @override
  String get settingsThemeSystem => '[Šýšţéɱ đéƒàûłţ ẋẋẋẋẋẋ]';

  @override
  String get settingsThemeLight => '[Łîĝĥţ ẋẋ]';

  @override
  String get settingsThemeDark => '[Ðàřƙ ẋẋ]';

  @override
  String get settingsLanguageTitle => '[Łàñĝûàĝé ẋẋẋẋ]';

  @override
  String get settingsRateUsTitle => '[Řàţé ûš ẋẋẋ]';

  @override
  String get settingsRateUsSubtitle =>
      '[Šĥàřé ýôûř ƒééđƀàçƙ ŵîţĥ ûš ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get settingsAddWidgetTitle => '[Åđđ Ŵîđĝéţ ẋẋẋẋ]';

  @override
  String get settingsAddWidgetSubtitle =>
      '[Ǫûîçƙ àççéšš ƒřôɱ ýôûř ĥôɱé šçřééñ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get settingsTermsTitle => '[Ťéřɱš ôƒ ûšé ẋẋẋẋẋ]';

  @override
  String get settingsTermsSubtitle => '[Řéàđ ôûř ţéřɱš ôƒ šéřṽîçé ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get settingsPrivacyTitle => '[Þřîṽàçý þôłîçý ẋẋẋẋẋẋ]';

  @override
  String get settingsPrivacySubtitle => '[Řéàđ ôûř þřîṽàçý þôłîçý ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get settingsManageSubscriptionsTitle =>
      '[Ṁàñàĝé šûƀšçřîþţîôñš ẋẋẋẋẋẋẋẋ]';

  @override
  String get settingsManageSubscriptionsSubtitle =>
      '[Ṁàñàĝé ýôûř šţôřé šûƀšçřîþţîôñ ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String settingsVersionDisplay(String version, String build) {
    return '[Ṽéřšîôñ $version ($build) ẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return '[Ṽéřšîôñ $version ƀûîłđ $build ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get settingsOpenSourceLicenses => '[Öþéñ-šôûřçé łîçéñšéš ẋẋẋẋẋẋẋẋ]';

  @override
  String get rateSheetTitle => '[Řàţé Ðôç Ṽîéŵ ẋẋẋẋẋẋ]';

  @override
  String get rateSheetSubtitle =>
      '[Ýôûř ƒééđƀàçƙ ĥéłþš ûš îɱþřôṽé ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count šţàřš ẋẋẋẋẋẋ]',
      one: '[1 šţàř ẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => '[Ĝłàđ ýôû łîƙé îţ! ẋẋẋẋẋẋẋ]';

  @override
  String get rateResponseMedium =>
      '[Ťĥàñƙš! Ťéłł ûš ĥôŵ ŵé çàñ đô ƀéţţéř. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get rateResponseLow =>
      '[Šôřřý îţ ƒéłł šĥôřţ. Ťéłł ûš ŵĥàţ ţô ƒîẋ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get rateActionStore => '[Řàţé ôñ Ĝôôĝłé Þłàý ẋẋẋẋẋẋẋẋ]';

  @override
  String get rateActionHelpFeedback => '[Ħéłþ & ƒééđƀàçƙ ẋẋẋẋẋẋ]';

  @override
  String get faqFromRatingBanner =>
      '[Šôřřý ţô ĥéàř ţĥàţ. Ɓřôŵšé ţĥé àñšŵéřš ƀéłôŵ ôř çôñţàçţ ûš; ŵé řéàđ éṽéřý ɱéššàĝé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get faqActionContactUs => '[Çôñţàçţ ûš ẋẋẋẋ]';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return '[Ðôç Ṽîéŵ Ƒééđƀàçƙ ($version+$build) ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '[\n\n---\nÅþþ: Ðôç Ṽîéŵ $version (Ɓûîłđ $build)\n ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get faqEmailClientUnavailable =>
      '[Çôûłđ ñôţ ôþéñ éɱàîł çłîéñţ ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get languageScreenTitle => '[Łàñĝûàĝé ẋẋẋẋ]';

  @override
  String get languageSearchHint => '[Šéàřçĥ łàñĝûàĝéš... ẋẋẋẋẋẋẋẋ]';

  @override
  String get languageSystemDefault => '[Šýšţéɱ đéƒàûłţ ẋẋẋẋẋẋ]';

  @override
  String get languageSystemDefaultSubtitle =>
      '[Ƒôłłôŵ đéṽîçé łàñĝûàĝé ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get languageNotTranslatedBadge => '[(ñôţ ţřàñšłàţéđ) ẋẋẋẋẋẋẋ]';

  @override
  String get languageNotTranslatedSnack =>
      '[Ťĥîš łàñĝûàĝé îš ñôţ ţřàñšłàţéđ ýéţ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get languageNoResults => '[Ñô ɱàţçĥîñĝ łàñĝûàĝéš ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get languagePseudoLocaleName => '[Þšéûđô-łôçàłé (éñ_ẊÅ) ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get languagePseudoLocaleSubtitle =>
      '[Ðéƀûĝ éẋþàñšîôñ ţéšţîñĝ ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsSectionHistory => '[Ħîšţôřý ẋẋẋ]';

  @override
  String get scanSettingsClearHistoryTitle => '[Çłéàř řéçéñţ ĥîšţôřý ẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsClearHistorySubtitle =>
      '[Çłéàř ôþéñéđ đôçûɱéñţ ĥîšţôřý ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsClearHistoryDialogTitle =>
      '[Çłéàř řéçéñţ ĥîšţôřý? ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      '[Ƒîłéš ŵîłł ƀé řéɱôṽéđ ƒřôɱ Řéçéñţ. Ýôûř ƒîłéš àñđ ƀôôƙɱàřƙš àřé ñôţ àƒƒéçţéđ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsRecentHistoryCleared =>
      '[Řéçéñţ ĥîšţôřý çłéàřéđ ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get scanSettingsLastScanToday => '[ţôđàý ẋẋ]';

  @override
  String get scanSettingsLastScanYesterday => '[ýéšţéřđàý ẋẋẋẋ]';

  @override
  String get scanSettingsNeverScanned => '[Ñéṽéř šçàññéđ ẋẋẋẋẋẋ]';

  @override
  String get scanSettingsLastScanPrefix => '[Łàšţ šçàñ: ẋẋẋẋ]';

  @override
  String get readerActionVertical => '[Ṽéřţîçàł ẋẋẋẋ]';

  @override
  String get readerActionHorizontal => '[Ħôřîžôñţàł ẋẋẋẋ]';

  @override
  String get readerActionRotate => '[Řôţàţé ẋẋẋ]';

  @override
  String get readerActionSearch => '[Šéàřçĥ ẋẋẋ]';

  @override
  String get readerActionInvert => '[Îñṽéřţ ẋẋẋ]';

  @override
  String get readerActionShare => '[Šĥàřé ẋẋ]';

  @override
  String get readerActionPages => '[Þàĝéš ẋẋ]';

  @override
  String get readerSearchHint => '[Šéàřçĥ îñ đôçûɱéñţ... ẋẋẋẋẋẋẋẋẋ]';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '[$current ôƒ $total ẋẋẋẋẋẋẋẋ]';
  }

  @override
  String get readerSearchMatchCap => '[500+ ẋẋ]';

  @override
  String get readerSearchNoMatches => '[0 ôƒ 0 ẋẋẋ]';

  @override
  String get readerSearchNoTextLayer =>
      '[Ťĥîš ÞÐƑ ĥàš ñô šéàřçĥàƀłé ţéẋţ ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get readerSearchPrevMatch => '[Þřéṽîôûš ɱàţçĥ ẋẋẋẋẋẋ]';

  @override
  String get readerSearchNextMatch => '[Ñéẋţ ɱàţçĥ ẋẋẋẋ]';

  @override
  String readerTopPagesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count Þàĝéš • $size ẋẋẋẋẋẋẋẋẋ]',
      one: '[1 Þàĝé • $size ẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get readerMenuGoToPage => '[Ĝô ţô þàĝé ẋẋẋẋ]';

  @override
  String get readerMenuAddBookmark => '[Åđđ ƀôôƙɱàřƙ ẋẋẋẋẋ]';

  @override
  String get readerMenuRemoveBookmark => '[Řéɱôṽé ƀôôƙɱàřƙ ẋẋẋẋẋẋ]';

  @override
  String get readerMenuDetails => '[Ðéţàîłš ẋẋẋ]';

  @override
  String get readerMenuOpenInAnotherApp => '[Öþéñ îñ àñôţĥéř àþþ ẋẋẋẋẋẋẋẋ]';

  @override
  String get readerTooltipConvertToWord => '[Çôñṽéřţ ţô Ŵôřđ ẋẋẋẋẋẋ]';

  @override
  String get pagesScreenTitle => '[Þàĝéš ẋẋ]';

  @override
  String pagesScreenPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count Þàĝéš ẋẋẋẋẋẋ]',
      one: '[1 Þàĝé ẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get pagesActionSelectAll => '[Šéłéçţ àłł ẋẋẋẋ]';

  @override
  String get pagesActionClearSelection => '[Çłéàř ẋẋ]';

  @override
  String get pagesActionSave => '[Šàṽé ẋẋ]';

  @override
  String get pagesActionInsert => '[Îñšéřţ ẋẋẋ]';

  @override
  String get pagesActionRotate => '[Řôţàţé ẋẋẋ]';

  @override
  String get pagesActionExtract => '[Éẋţřàçţ ẋẋẋ]';

  @override
  String get pagesActionDelete => '[Ðéłéţé ẋẋẋ]';

  @override
  String get pagesActionUndo => '[Ûñđô ẋẋ]';

  @override
  String get pagesInsertSheetTitle => '[Îñšéřţ þàĝéš ẋẋẋẋẋ]';

  @override
  String get pagesInsertPagesFromPdf => '[Þàĝéš ƒřôɱ àñôţĥéř ÞÐƑ ẋẋẋẋẋẋẋẋẋ]';

  @override
  String get pagesDeleteAllBlocked =>
      '[Çàññôţ đéłéţé àłł þàĝéš. Å đôçûɱéñţ ɱûšţ ĥàṽé àţ łéàšţ ôñé þàĝé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get pagesSaveDialogTitle => '[Šàṽé çĥàñĝéš ẋẋẋẋẋ]';

  @override
  String get pagesSaveAsNew => '[Šàṽé àš ñéŵ ƒîłé ẋẋẋẋẋẋẋ]';

  @override
  String get pagesSaveReplace => '[Řéþłàçé ôřîĝîñàł ẋẋẋẋẋẋẋ]';

  @override
  String get pagesSaveReplaceWarning =>
      '[Ťĥîš ôṽéřŵřîţéš ţĥé ôřîĝîñàł ƒîłé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get pagesSaveFileNameLabel => '[Ƒîłé ñàɱé ẋẋẋẋ]';

  @override
  String get pagesDiscardDialogTitle => '[Ðîšçàřđ çĥàñĝéš? ẋẋẋẋẋẋẋ]';

  @override
  String get pagesDiscardDialogBody =>
      '[Ýôû ĥàṽé ûñšàṽéđ çĥàñĝéš. Åřé ýôû šûřé ýôû ŵàñţ ţô đîšçàřđ ţĥéɱ? ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get pagesDiscardButton => '[Ðîšçàřđ ẋẋẋ]';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count þàĝéš ẋẋẋẋẋẋ]',
      one: '[1 þàĝé ẋẋẋ]',
    );
    return '[Éẋţřàçţéđ  ẋẋẋẋ]$_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      '[Ťĥîš ÞÐƑ çàññôţ ƀé éđîţéđ ƀéçàûšé îţ îš éñçřýþţéđ ôř ûñřéàđàƀłé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorCorruptTitle =>
      '[Çàñ\'ţ ôþéñ ţĥîš đôçûɱéñţ ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorCorruptMessage =>
      '[Ťĥîš ƒîłé àþþéàřš ţô ƀé đàɱàĝéđ ôř ñôţ à ṽàłîđ đôçûɱéñţ. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorMissingTitle =>
      '[Ťĥîš ƒîłé ñô łôñĝéř éẋîšţš ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorMissingMessage =>
      '[Ťĥé ƒîłé ĥàš ƀééñ đéłéţéđ ôř ɱôṽéđ ƒřôɱ đéṽîçé šţôřàĝé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorBackToFiles => '[Ɓàçƙ ţô ƒîłéš ẋẋẋẋẋẋ]';

  @override
  String get viewerErrorNoAppFound =>
      '[Ñô àþþ ƒôûñđ ţô ôþéñ ţĥîš ƒîłé ẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count ɱàţçĥéš ẋẋẋẋẋẋ]',
      one: '[1 ɱàţçĥ ẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count ûñîţš • $ext ẋẋẋẋẋẋẋẋẋ]',
      one: '[1 ûñîţ • $ext ẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner =>
      '[Łéĝàçý ƒôřɱàţ: ţéẋţ ôñłý ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      '[Łàřĝé šþřéàđšĥééţ: šĥôŵîñĝ ţĥé ƒîřšţ 3000 řôŵš ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String viewerSectionTitle(int number) {
    return '[Šéçţîôñ $number ẋẋẋẋẋẋẋ]';
  }

  @override
  String get viewerMenuOutline => '[Öûţłîñé ẋẋẋ]';

  @override
  String get viewerOutlineTitle => '[Ðôçûɱéñţ ôûţłîñé ẋẋẋẋẋẋẋ]';

  @override
  String get viewerCloseOutline => '[Çłôšé ôûţłîñé ẋẋẋẋẋẋ]';

  @override
  String get viewerNoSections =>
      '[Ñô šéçţîôñš ƒôûñđ îñ ţĥîš đôçûɱéñţ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerOutlineTooltip => '[Ťàƀłé ôƒ çôñţéñţš ẋẋẋẋẋẋẋ]';

  @override
  String get viewerActionOpenExternal => '[Öþéñ îñ àñôţĥéř àþþ ẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorCantOpenTitle =>
      '[Çàñ\'ţ ôþéñ ţĥîš đôçûɱéñţ ẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorCantOpenMessage =>
      '[Ťĥé đôçûɱéñţ çôûłđ ñôţ ƀé řéñđéřéđ ôƒƒłîñé. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerOpeningDocument => '[Öþéñîñĝ đôçûɱéñţ... ẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorEncryptedTitle =>
      '[Ťĥîš đôçûɱéñţ îš éñçřýþţéđ ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorEncryptedMessage =>
      '[Þàššŵôřđ-þřôţéçţéđ ƒîłéš çàññôţ ƀé ṽîéŵéđ îñ ţĥé ôƒƒłîñé řéàđéř. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorTooLargeTitle =>
      '[Ťĥîš ƒîłé éẋçééđš ţĥé ṽîéŵ łîɱîţ ẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorTooLargeMessage =>
      '[Łàřĝé đôçûɱéñţš šĥôûłđ ƀé ôþéñéđ ûšîñĝ àñ éẋţéřñàł Öƒƒîçé ṽîéŵéř. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorUnsupportedFormatTitle =>
      '[Ťĥîš ƒôřɱàţ îšñ\'ţ šûþþôřţéđ ẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      '[Ðôç Ṽîéŵ çàññôţ þàřšé ţĥîš ƒîłé ƒôřɱàţ đîřéçţłý. ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count îţéɱš ẋẋẋẋẋẋ]',
      one: '[1 îţéɱ ẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => '[Ťýþôĝřàþĥý ẋẋẋẋ]';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '[$size þţ ẋẋẋẋ]';
  }

  @override
  String get txtViewerMonospaceLabel => '[Ṁôñôšþàçé ƒôñţ ẋẋẋẋẋẋ]';

  @override
  String get txtViewerTruncationBanner =>
      '[Ƒîłé îš łàřĝéř ţĥàñ 1 ṀƁ: šĥôŵîñĝ ƒîřšţ 1 ṀƁ ẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋẋ]';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '[$count łîñéš • $size ẋẋẋẋẋẋẋẋẋ]',
      one: '[1 łîñé • $size ẋẋẋẋẋẋ]',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => '[Ťýþôĝřàþĥý šéţţîñĝš ẋẋẋẋẋẋẋẋ]';

  @override
  String get txtViewerTooltipDecreaseFont => '[Ðéçřéàšé ƒôñţ šîžé ẋẋẋẋẋẋẋẋ]';

  @override
  String get txtViewerTooltipIncreaseFont => '[Îñçřéàšé ƒôñţ šîžé ẋẋẋẋẋẋẋẋ]';

  @override
  String get txtViewerTooltipToggleMonospace =>
      '[Ťôĝĝłé ɱôñôšþàçé ƒôñţ ẋẋẋẋẋẋẋẋẋ]';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '[$width × $height • $size ẋẋẋẋẋẋẋẋẋẋẋ]';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '[$percent% ẋẋẋẋ]';
  }

  @override
  String get imageViewerTooltipFitToScreen => '[Ƒîţ ţô šçřééñ ẋẋẋẋẋẋ]';

  @override
  String get imageViewerErrorCorrupt => '[Ûñàƀłé ţô łôàđ îɱàĝé ẋẋẋẋẋẋẋẋ]';

  @override
  String get viewerDispatcherFileMissing => '[Ƒîłé ñô łôñĝéř éẋîšţš ẋẋẋẋẋẋẋẋẋ]';
}
