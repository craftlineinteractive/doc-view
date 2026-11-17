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
}
