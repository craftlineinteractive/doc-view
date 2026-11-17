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
