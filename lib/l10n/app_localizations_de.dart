// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Doc View';

  @override
  String get navHome => 'Alle Dateien';

  @override
  String get navTools => 'Tools';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get noDocumentSelected => 'Kein Dokument ausgewählt';

  @override
  String get tooltipCloseAd => 'Anzeige schließen';

  @override
  String get tooltipClose => 'Schließen';

  @override
  String get tooltipRescan => 'Dokumente neu scannen';

  @override
  String get tooltipSearch => 'Dokumente suchen';

  @override
  String get tooltipSelectFiles => 'Dateien auswählen';

  @override
  String get tooltipBack => 'Zurück';

  @override
  String get tooltipCancelSelection => 'Auswahl aufheben';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ausgewählt',
      one: '1 ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'Alle auswählen';

  @override
  String get actionDeselectAll => 'Auswahl aufheben';

  @override
  String get tooltipDeleteSelected => 'Ausgewählte löschen';

  @override
  String get tooltipClearSearch => 'Suche leeren';

  @override
  String get searchHint => 'Dokumente, Ordner suchen...';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return 'Seite $page von $total';
  }

  @override
  String get errorGenericTitle => 'Etwas ist schiefgelaufen';

  @override
  String get actionRetry => 'Erneut versuchen';

  @override
  String get permissionAllFilesTitle => 'Zugriff auf alle Dateien erforderlich';

  @override
  String get permissionAllFilesExplanation =>
      'Doc View benötigt Zugriff auf alle Dateien, um Ordner zu durchsuchen und deine Dokumente vollständig offline zu organisieren.';

  @override
  String get actionGrantAccess => 'Zugriff gewähren';

  @override
  String get actionImportFilesInstead => 'Stattdessen Dateien importieren';

  @override
  String get tooltipRemoveBookmark => 'Lesezeichen entfernen';

  @override
  String get tooltipAddBookmark => 'Lesezeichen hinzufügen';

  @override
  String tooltipFileOptions(String title) {
    return 'Dateioptionen für $title';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return 'Ordner, $name$subtitle';
  }

  @override
  String get adAdvertisementBadge => 'WERBUNG';

  @override
  String get actionConfirm => 'Bestätigen';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get tabRecent => 'Zuletzt';

  @override
  String get tabBookmarks => 'Lesezeichen';

  @override
  String get filterCategoryAll => 'Alle';

  @override
  String get actionBrowse => 'Durchsuchen';

  @override
  String get actionCancelOperation => 'Vorgang abbrechen';

  @override
  String get operationComplete => 'Vorgang abgeschlossen';

  @override
  String get actionOpenDocument => 'Dokument öffnen';

  @override
  String get actionShareDocument => 'Dokument teilen';

  @override
  String get splashTagline => 'Alle deine Dokumente an einem Ort.';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'Schritt $current von $total';
  }

  @override
  String get actionSkip => 'Überspringen';

  @override
  String get actionBack => 'Zurück';

  @override
  String get actionNext => 'Weiter';

  @override
  String get actionGetStarted => 'Los geht\'s';

  @override
  String get onboardingPage1Title => 'Alle deine Dokumente,\nan einem Ort';

  @override
  String get onboardingPage1Desc =>
      'Doc View findet automatisch PDFs, Word-, Excel-, PowerPoint- und Textdateien sowie Bilder auf deinem Smartphone und ordnet sie für dich.';

  @override
  String get onboardingPage2Title => 'Alles lesen,\nganz entspannt';

  @override
  String get onboardingPage2Desc =>
      'Öffne PDFs sowie Word-, Excel- und PowerPoint-Dateien in einem schnellen, übersichtlichen Reader. Suche, setze Lesezeichen und lies genau dort weiter, wo du aufgehört hast.';

  @override
  String get onboardingPage3Title => 'Starke PDF-Tools, offline';

  @override
  String get onboardingPage3Desc =>
      'Wandle Fotos in PDFs um, scanne Dokumente, füge Dateien zusammen und teile sie auf. Alles bleibt auf deinem Gerät.';

  @override
  String get onboardingOfflineGuarantee =>
      'Deine Dateien bleiben auf deinem Gerät';

  @override
  String get toolImageToPdf => 'Bild in PDF';

  @override
  String get toolImageToPdfSub => 'JPG & PNG umwandeln';

  @override
  String get toolScanToPdf => 'Scan in PDF';

  @override
  String get toolScanToPdfSub => 'Kamera-Kantenerkennung';

  @override
  String get toolMergePdf => 'PDF zusammenführen';

  @override
  String get toolMergePdfSub => 'Zu einer Datei verbinden';

  @override
  String get toolSplitPdf => 'PDF teilen';

  @override
  String get toolSplitPdfSub => 'Beliebigen Bereich extrahieren';

  @override
  String get permissionTagStorage => 'Zugriff auf Gerätespeicher';

  @override
  String get permissionStorageHeadline =>
      'Lass Doc View deine Dokumente finden';

  @override
  String get permissionStorageBody =>
      'Um PDFs, Word-, Excel- und andere von Apps gespeicherte Dateien aufzulisten, benötigt Android deine Erlaubnis für den Zugriff auf alle Dateien. Deine Dateien verlassen dein Smartphone nie.';

  @override
  String get permissionReassuranceOfflineTitle =>
      'Dateien werden niemals hochgeladen';

  @override
  String get permissionReassuranceOfflineDesc =>
      'Deine Dokumente werden lokal auf deinem Gerät verarbeitet.';

  @override
  String get permissionReassuranceNoUploadsTitle => 'Keine Uploads';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      'Keine Cloud-Server. Deine Dateien bleiben ausschließlich im Speicher deines Smartphones.';

  @override
  String get permissionReassuranceChangeTitle => 'Jederzeit änderbar';

  @override
  String get permissionReassuranceChangeDesc =>
      'Einfach in den Android-App-Einstellungen umschalten.';

  @override
  String get permissionTagIOS => 'iOS-Speicheranleitung';

  @override
  String get permissionIOSHeadline => 'Bringe deine Dokumente zu Doc View';

  @override
  String get permissionIOSBody =>
      'Aufgrund der Datenschutzarchitektur von Apple erlaubt iOS keiner App, das gesamte Gerät automatisch zu scannen. Wähle aus, wie du deine Dateien lesen möchtest:';

  @override
  String get permissionIOSOptionImportTitle => 'Dateien importieren';

  @override
  String get permissionIOSBadgeFastest => 'AM SCHNELLSTEN';

  @override
  String get permissionIOSOptionImportDesc =>
      'Wähle Dokumente direkt aus iCloud Drive, Downloads oder einem beliebigen Ordner in Sekundenschnelle aus.';

  @override
  String get permissionIOSOptionFolderTitle =>
      'Ordner „Doc View“ in der Dateien-App öffnen';

  @override
  String get permissionIOSOptionFolderDesc =>
      'Speichere Dokumente oder sende sie per AirDrop direkt in den Ordner „Doc View“ in der iOS-Dateien-App für sofortige Synchronisierung.';

  @override
  String get actionImportFiles => 'Dateien importieren';

  @override
  String get actionContinueToApp => 'Weiter zur App';

  @override
  String get permissionTagConsent => 'Transparenz & Einwilligung';

  @override
  String get permissionBadgeFree => '100 % kostenlose App';

  @override
  String get permissionBadgeMinimalAds => 'Minimale Werbung';

  @override
  String get permissionConsentHeadline => 'Kostenlos mit Werbung';

  @override
  String get permissionConsentBody =>
      'Doc View ist dank Werbung kostenlos. Als Nächstes fragen wir dich nach deiner Auswahl für personalisierte Werbung.';

  @override
  String get permissionConsentAdsTitle => 'Welche Werbung du sehen kannst';

  @override
  String get permissionConsentAdsDesc =>
      'Kleine Banneranzeigen und unaufdringliche Sponsorenkarten. Keine Pop-ups oder Video-Unterbrechungen beim Lesen.';

  @override
  String get permissionConsentPrivateTitle =>
      'Dokumente bleiben vollständig privat';

  @override
  String get permissionConsentPrivateDesc =>
      'Werbepartner erhalten niemals Zugriff auf deine Dokumentnamen, Textinhalte oder Speicherorte.';

  @override
  String get permissionConsentSettingsTitle =>
      'Du kannst deine Auswahl in den Einstellungen ändern';

  @override
  String get permissionConsentSettingsDesc =>
      'Aktualisiere deine Einwilligung zu personalisierter Werbung oder Datenschutzeinstellungen jederzeit in den Doc View-Einstellungen.';

  @override
  String get actionContinue => 'Weiter';

  @override
  String get actionPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien importiert',
      one: '1 Datei importiert',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => 'Importieren der Dateien fehlgeschlagen';

  @override
  String get tooltipImportDocuments => 'Dokumente importieren';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien gefunden',
      one: '1 Datei gefunden',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => 'Wird gescannt...';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien',
      one: '1 Datei',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => 'Ordner';

  @override
  String get errorLoadingRecent =>
      'Fehler beim Laden zuletzt geöffneter Dateien';

  @override
  String get emptyStateTitle => 'Leer';

  @override
  String get emptyRecentDescription =>
      'Zuletzt geöffnete Dateien erscheinen hier';

  @override
  String get errorLoadingBookmarks => 'Fehler beim Laden der Lesezeichen';

  @override
  String get emptyBookmarksDescription =>
      'Mit Lesezeichen versehene Dokumente erscheinen hier';

  @override
  String get dialogDeleteTitle => 'Ausgewählte Dateien löschen?';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Dateien löschen? Dies kann nicht rückgängig gemacht werden.',
      one: '1 Datei löschen? Dies kann nicht rückgängig gemacht werden.',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien gelöscht',
      one: '1 Datei gelöscht',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => 'Löschen der Dateien fehlgeschlagen';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get searchRecentSearchesHeader => 'LETZTE SUCHEN';

  @override
  String get actionClear => 'Leeren';

  @override
  String get searchPromptTitle => 'Tippen, um Dokumente zu suchen';

  @override
  String get searchPromptMessage =>
      'Durchsuche alle lokalen Ordner nach Dateiname oder -endung';

  @override
  String get searchError => 'Fehler bei der Dokumentensuche';

  @override
  String get searchNoResultsTitle => 'Keine passenden Dokumente gefunden';

  @override
  String get searchNoResultsMessage =>
      'Versuche es mit einem anderen Suchbegriff oder Formatfilter';

  @override
  String get tooltipSortOptions => 'Sortieroptionen';

  @override
  String get sortSheetTitle => 'Sortieren nach';

  @override
  String get sortOptionDate => 'Änderungsdatum';

  @override
  String get sortOptionName => 'Dokumentname';

  @override
  String get sortOptionSize => 'Dateigröße';

  @override
  String get sortAscendingOrder => 'Aufsteigende Reihenfolge';

  @override
  String get sortAscendingSubtitle =>
      'Älteste zuerst / A bis Z / Kleinste zuerst';

  @override
  String get sortDescendingSubtitle =>
      'Neueste zuerst / Z bis A / Größte zuerst';

  @override
  String get categoryAllFiles => 'Alle Dateien';

  @override
  String get loadingStatus => 'Wird geladen...';

  @override
  String get emptyCategoryImagesTitle => 'Keine Bilder gefunden';

  @override
  String get emptyCategoryImagesMessage =>
      'Auf diesem Gerät gefundene Bilder erscheinen hier';

  @override
  String get emptyCategoryDocsTitle => 'Keine Dokumente gefunden';

  @override
  String get emptyCategoryDocsMessage =>
      'Dokumente dieses Formats erscheinen hier nach dem Scan';

  @override
  String get actionOpen => 'Öffnen';

  @override
  String get actionShare => 'Teilen';

  @override
  String get actionRename => 'Umbenennen';

  @override
  String get actionBookmark => 'Lesezeichen';

  @override
  String get actionRemoveBookmark => 'Lesezeichen entfernen';

  @override
  String get actionOpenInAnotherApp => 'In anderer App öffnen';

  @override
  String get actionDetails => 'Details';

  @override
  String get actionOpenFile => 'Datei öffnen';

  @override
  String get actionShareAll => 'Alle teilen';

  @override
  String get actionDone => 'Fertig';

  @override
  String get actionSeeAll => 'Alle ansehen';

  @override
  String get actionAllow => 'Erlauben';

  @override
  String get actionNotNow => 'Jetzt nicht';

  @override
  String get tooltipMoreActions => 'Weitere Aktionen';

  @override
  String get tooltipCopyPath => 'Pfad kopieren';

  @override
  String get tooltipRotatePage => 'Seite drehen';

  @override
  String get tooltipRemovePage => 'Seite entfernen';

  @override
  String get renameFileTitle => 'Datei umbenennen';

  @override
  String get renameFileNameLabel => 'Dateiname';

  @override
  String renamedSuccess(String fileName) {
    return 'Umbenannt in $fileName';
  }

  @override
  String get deleteFileTitle => 'Datei löschen?';

  @override
  String deleteFileConfirmation(String fileName) {
    return '„$fileName“ löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return '„$fileName“ gelöscht';
  }

  @override
  String get fileDetailsTitle => 'Dokumentdetails';

  @override
  String get fileDetailsLabelName => 'Name';

  @override
  String get fileDetailsLabelType => 'Typ';

  @override
  String get fileDetailsLabelSize => 'Größe';

  @override
  String get fileDetailsLabelModified => 'Geändert';

  @override
  String get fileDetailsLabelBookmarked => 'Lesezeichen';

  @override
  String get fileDetailsValueYes => 'Ja';

  @override
  String get fileDetailsValueNo => 'Nein';

  @override
  String get fileDetailsLabelLocation => 'Speicherort';

  @override
  String get fileDetailsPathCopied => 'Pfad in Zwischenablage kopiert';

  @override
  String get directoriesTitle => 'Verzeichnisse';

  @override
  String get directoriesGoBack => 'Zurück';

  @override
  String get directoriesGoToRoot => 'Zum Stammverzeichnis';

  @override
  String get directoriesRetry => 'Erneut versuchen';

  @override
  String get directoriesFileNoLongerExists => 'Datei existiert nicht mehr';

  @override
  String get directoriesFolderNoLongerExists =>
      'Dieser Ordner existiert nicht mehr.';

  @override
  String get directoriesNoDocsInFolder => 'Keine Dokumente in diesem Ordner';

  @override
  String get directoriesFilesAppearHere =>
      'Dateien erscheinen hier, sobald sie hinzugefügt wurden';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Elemente',
      one: '1 Element',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => 'Ordner';

  @override
  String get directoriesPermissionPromptTitle =>
      'Zugriff zum Anzeigen von Verzeichnissen erforderlich';

  @override
  String get directoriesPermissionPromptBody =>
      'Doc View benötigt Zugriff auf alle Dateien, um deine Ordner zu durchsuchen.';

  @override
  String get directoriesGrantAccess => 'Zugriff gewähren';

  @override
  String get directoriesImportInstead => 'Stattdessen Dateien importieren';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien importiert',
      one: '1 Datei importiert',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => 'Eine Ebene höher';

  @override
  String get storageAccessRequiredTitle => 'Speicherzugriff erforderlich';

  @override
  String get storageAccessRequiredBody =>
      'Doc View benötigt Speicherzugriff, um auf deinem Gerät gespeicherte Dokumente (PDF, Word, Excel, PPT, TXT, Bilder) zu scannen und anzuzeigen.\n\nDeine Dateien bleiben vollständig privat und offline auf deinem Gerät.';

  @override
  String errorCouldNotOpenDocument(String error) {
    return 'Dokument konnte nicht geöffnet werden: $error';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Scan abgeschlossen: $count Dateien',
      one: 'Scan abgeschlossen: 1 Datei',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => 'Suchverlauf löschen?';

  @override
  String get dialogClearSearchMessage =>
      'Alle letzten Suchanfragen werden dauerhaft gelöscht.';

  @override
  String imageListEditorMaxLimit(int max) {
    return 'Maximales Limit von $max Bildern erreicht.';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return 'Scannen fehlgeschlagen: $error';
  }

  @override
  String get imageListEditorPageSize => 'Seitengröße:';

  @override
  String get imageListEditorA4Mode => 'A4';

  @override
  String get imageListEditorFitMode => 'An Bild anpassen';

  @override
  String get imageListEditorRemoveImageTooltip => 'Bild entfernen';

  @override
  String get mergeScreenTitle => 'Anordnen & zusammenführen';

  @override
  String get mergeScreenDefaultMergedName => 'Zusammengeführtes_Dokument';

  @override
  String get mergePickerSearchHint => 'PDFs suchen...';

  @override
  String get mergePickerNext => 'Weiter';

  @override
  String mergePickerErrorLoading(String error) {
    return 'Fehler beim Laden der PDFs: $error';
  }

  @override
  String get splitScreenTitle => 'PDF teilen';

  @override
  String get splitScreenRangeHint => 'z. B. 1-3, 5, 8-10';

  @override
  String get splitScreenClearRange => 'Bereich leeren';

  @override
  String get splitPickerSearchHint => 'PDFs suchen...';

  @override
  String splitPickerErrorLoading(String error) {
    return 'Fehler beim Laden der Dateien: $error';
  }

  @override
  String get createdSectionTitle => 'Von dir erstellt';

  @override
  String get createdSectionEmptyTitle => 'Erstellte PDFs erscheinen hier';

  @override
  String get createdSectionEmptySubtitle =>
      'Konvertierte, gescannte oder zusammengeführte Dokumente werden lokal gespeichert.';

  @override
  String get emptyCreatedDocsTitle => 'Noch keine erstellten Dokumente';

  @override
  String get emptyCreatedDocsMessage =>
      'Konvertierte, gescannte oder zusammengeführte Dokumente erscheinen hier.';

  @override
  String errorLoadingCreatedFiles(String error) {
    return 'Laden der erstellten Dateien fehlgeschlagen: $error';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDFs erstellt',
      one: 'PDF erstellt',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle => 'Im Ordner „Erstellt“ gespeichert';

  @override
  String get toolErrorDefaultTitle => 'PDF konnte nicht erstellt werden';

  @override
  String get toolErrorSubtitle =>
      'Bei der Verarbeitung ist ein unerwarteter Fehler aufgetreten';

  @override
  String get themeSheetTitle => 'App-Design';

  @override
  String get themeSheetSubtitle => 'Erscheinungsbild für Doc View wählen';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeSystemSubtitle => 'Standard';

  @override
  String get themeModeLight => 'Hell';

  @override
  String get themeModeLightSubtitle => 'Schlichtes Weiß';

  @override
  String get themeModeDark => 'Dunkel';

  @override
  String get themeModeDarkSubtitle => 'Tiefes Marineblau';

  @override
  String get themeActionApply => 'Design anwenden';

  @override
  String get scanSettingsTitle => 'Scan-Einstellungen';

  @override
  String get scanSettingsFrequencyHeader => 'Scan-Häufigkeit';

  @override
  String get scanSettingsOnOpenTitle => 'Beim App-Start scannen';

  @override
  String get scanSettingsOnOpenSubtitle =>
      'Automatisch nach neuen Dateien suchen, wenn du Doc View öffnest.';

  @override
  String get scanSettingsManualTitle => 'Nur manuell';

  @override
  String get scanSettingsManualSubtitle =>
      'Nur scannen, wenn du zum Aktualisieren ziehst oder auf „Neu scannen“ tippst.';

  @override
  String get scanSettingsMediaFiltersHeader => 'Medienfilter';

  @override
  String get scanSettingsIncludeImagesTitle => 'Bilder in Scan einbeziehen';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      'PNG-, JPG- und WEBP-Bilddateien im Speicher indizieren.';

  @override
  String get scanSettingsDiagnosticsHeader => 'Speicher & Diagnose';

  @override
  String get scanSettingsPermissionStatus => 'Zugriff auf alle Dateien';

  @override
  String get scanSettingsPermissionGranted => 'Gewährt';

  @override
  String get scanSettingsPermissionNotGranted => 'Nicht gewährt';

  @override
  String get scanSettingsTotalIndexed => 'Indizierte Dateien';

  @override
  String get scanSettingsLastScan => 'Zuletzt gescannt';

  @override
  String get scanSettingsUpdatedSnackbar => 'Scan-Einstellungen aktualisiert';

  @override
  String get faqScreenTitle => 'Häufig gestellte Fragen';

  @override
  String faqHeaderTopics(int count) {
    return '$count Themen';
  }

  @override
  String get faqHeaderSubtitle =>
      'Hast du Fragen? Hier findest du klare Antworten.';

  @override
  String get faqSendFeedback => 'Feedback senden';

  @override
  String get faqQuestion1 =>
      'Warum benötigt Doc View Zugriff auf alle Dateien?';

  @override
  String get faqAnswer1 =>
      'Doc View benötigt unter Android 11+ den Zugriff auf alle Dateien (MANAGE_EXTERNAL_STORAGE), um unterstützte Dokumente (PDF, Word, Excel, PowerPoint, Text und Bilder) in freigegebenen Ordnern wie Downloads und Dokumente zu finden und zu indizieren.\n\nOhne diese Berechtigung beschränkt Android den Dateizugriff auf den privaten internen Ordner der App, sodass Doc View keine Dateien auf deinem Gerät durchsuchen oder öffnen kann.';

  @override
  String get faqQuestion2 => 'Warum wird nicht mein ganzes iPhone gescannt?';

  @override
  String get faqAnswer2 =>
      'iOS nutzt eine strenge App-Sandbox zum Schutz der Gerätedaten. Apps können nur auf Dokumente zugreifen, die ausdrücklich in der Dateien-App gespeichert oder über das System-Teilen-Menü freigegeben wurden.\n\nUm Dateien unter iOS anzuzeigen, importiere sie in den Ordner „Doc View“ in der Dateien-App oder nutze die Option „Dateien importieren“ in den Einstellungen.';

  @override
  String get faqQuestion3 =>
      'Wo werden die von mir erstellten PDFs gespeichert?';

  @override
  String get faqAnswer3 =>
      'Dateien, die du importierst oder erstellst (z. B. konvertierte PDFs, zusammengeführte Dokumente oder geteilte Seiten), werden sicher im Gerätespeicher unter DocView/Created oder im privaten App-Speicher abgelegt. Du kannst sie jederzeit im Bereich „Von dir erstellt“ auf dem Tab „Tools“ ansehen.';

  @override
  String get faqQuestion4 => 'Warum sieht meine Word-Datei anders aus?';

  @override
  String get faqAnswer4 =>
      'Doc View rendert Dateien direkt auf deinem Gerät mithilfe lokaler Offline-Parser, ohne private Daten an Cloud-Konverter zu senden. Komplexe Formatierungen oder benutzerdefinierte Formen werden mit nativen Offline-Näherungen dargestellt.';

  @override
  String get faqQuestion5 => 'Kann ich passwortgeschützte Dateien öffnen?';

  @override
  String get faqAnswer5 =>
      'Ja, Doc View unterstützt das Öffnen passwortgeschützter PDF-Dokumente. Gib beim Öffnen eines verschlüsselten PDFs das Passwort in das Dialogfeld ein, um das Dokument auf deinem Gerät zu entschlüsseln und anzuzeigen.';

  @override
  String get faqQuestion6 => 'Werden meine Daten irgendwo hochgeladen?';

  @override
  String get faqAnswer6 =>
      'Deine Dokumente verlassen dein Gerät niemals. Doc View öffnet, konvertiert und speichert Dateien lokal. Die App zeigt Werbung über Google AdMob an, wofür gemäß unserer Datenschutzerklärung begrenzte Gerätedaten verwendet werden können.';

  @override
  String get faqQuestion7 => 'Warum hat „PDF in Word“ mein Layout verändert?';

  @override
  String get faqAnswer7 =>
      'Doc View konvertiert auf deinem Gerät ausschließlich den Text. Tabellen, Bilder, Farben und das Layout bleiben nicht erhalten. Gescannte PDFs können nicht konvertiert werden, da kein lesbarer Text vorhanden ist.';

  @override
  String get toolPdfToWord => 'PDF in Word';

  @override
  String get toolPdfToWordSub => 'PDF in bearbeitbares Word-Dokument umwandeln';

  @override
  String get pdfToWordScreenTitle => 'PDF in Word';

  @override
  String get pdfToWordBannerText =>
      'Es wird nur Text konvertiert. Tabellen, Bilder, Farben und Layout bleiben nicht erhalten.';

  @override
  String get pdfToWordPageBreaks =>
      'Seitenumbrüche zwischen PDF-Seiten einfügen';

  @override
  String get pdfToWordPageBreaksSubtitle =>
      'Erhält die Dokumentstruktur über Seiten hinweg';

  @override
  String get pdfToWordSelectPdf => 'PDF auswählen';

  @override
  String get pdfToWordChangeFile => 'Datei ändern';

  @override
  String get pdfToWordConvertAction => 'In Word umwandeln';

  @override
  String get pdfToWordConverting => 'Wird in Word umgewandelt...';

  @override
  String pdfToWordConvertingProgress(int current, int total) {
    return 'Seite $current von $total wird umgewandelt...';
  }

  @override
  String get pdfToWordSuccess => 'Erfolgreich in Word umgewandelt';

  @override
  String get pdfToWordOpenInViewer => 'In Doc View öffnen';

  @override
  String get pdfToWordOpenWith => 'Öffnen mit...';

  @override
  String get pdfToWordShare => 'Teilen';

  @override
  String get pdfToWordNoTextTitle => 'Kein Text gefunden';

  @override
  String get pdfToWordNoTextMessage =>
      'In diesem PDF wurde kein Text gefunden. Gescannte Dokumente können nicht konvertiert werden.';

  @override
  String get pdfToWordLargeFileWarning =>
      'Großes Dokument: Die Umwandlung kann mehrere Minuten dauern.';

  @override
  String get pdfToWordInvalidFileName => 'Ungültiger Dateiname';

  @override
  String get pdfToWordActionCancel => 'Abbrechen';

  @override
  String get pdfToWordEncryptedError =>
      'Das ausgewählte PDF ist passwortgeschützt. Bitte entsperre es zum Umwandeln.';

  @override
  String get pdfToWordPageLimitError =>
      'Das Dokument überschreitet das Limit von 1.000 Seiten.';

  @override
  String get pdfToWordTextLimitError =>
      'Das Dokument überschreitet das Textlimit von 20 MB.';

  @override
  String get pdfToWordGeneralError =>
      'Umwandlung von PDF in Word fehlgeschlagen. Bitte versuche eine andere Datei.';

  @override
  String get pdfGotoPageTitle => 'Gehe zu Seite';

  @override
  String pdfGotoPageHint(int pageCount) {
    return 'Seite zwischen 1 und $pageCount eingeben';
  }

  @override
  String get pdfGotoPageAction => 'Öffnen';

  @override
  String get pdfGotoPageErrorEmpty => 'Seitenzahl eingeben';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return 'Seite zwischen 1 und $pageCount eingeben';
  }

  @override
  String get pdfPasswordTitle => 'Dieses PDF ist passwortgeschützt';

  @override
  String get pdfPasswordSubtitle =>
      'Passwort eingeben, um den Inhalt zu entschlüsseln und anzuzeigen.';

  @override
  String get pdfPasswordHint => 'Passwort eingeben';

  @override
  String get pdfPasswordErrorIncorrect =>
      'Falsches Passwort. Erneut versuchen.';

  @override
  String get pdfPasswordActionUnlock => 'Entsperren';

  @override
  String get errorFileNameEmpty => 'Dateiname darf nicht leer sein';

  @override
  String get errorFileNameTooLong =>
      'Dateiname darf höchstens 120 Zeichen lang sein';

  @override
  String get errorFileNameReserved => 'Dateiname darf nicht „.“ oder „..“ sein';

  @override
  String get errorFileNameStartsWithDot =>
      'Dateiname darf nicht mit einem Punkt beginnen';

  @override
  String get errorFileNameInvalidChars => 'Dateiname enthält ungültige Zeichen';

  @override
  String get errorRenameAlreadyExists =>
      'In diesem Ordner existiert bereits eine Datei mit diesem Namen';

  @override
  String get errorRenameSourceNotFound =>
      'Quelldatei existiert nicht mehr auf dem Speicher';

  @override
  String errorRenameFailed(String details) {
    return 'Umbenennen fehlgeschlagen: $details';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      'Dateien vom Speicher gelöscht, aber Datenbankaktualisierung fehlgeschlagen';

  @override
  String errorDeleteFailed(String details) {
    return 'Löschen der Dateien fehlgeschlagen: $details';
  }

  @override
  String get errorPageRangeDocNoPages => 'Dokument enthält keine Seiten';

  @override
  String get errorPageRangeEmpty => 'Seitenbereich darf nicht leer sein';

  @override
  String get errorPageRangeEmptySegment =>
      'Leeres Bereichssegment gefunden. Entferne überflüssige Kommas.';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return 'Ungültiges Bereichsformat: „$token“';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return 'Unvollständiger Bereich: „$token“';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return 'Nicht-numerische Werte im Bereich: „$token“';
  }

  @override
  String get errorPageRangeBelowMinimum =>
      'Seitenzahlen müssen mindestens 1 sein';

  @override
  String errorPageRangeReversed(int start, int end) {
    return 'Umgekehrter Bereich „$start-$end“: Start ist größer als Ende';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return 'Bereich „$token“ überschreitet die Gesamtseitenzahl ($totalPages)';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return 'Ungültige Seitenzahl: „$token“';
  }

  @override
  String get errorImageToPdfNoImages => 'Bitte wähle mindestens ein Bild aus';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return 'Maximal $max Bilder gleichzeitig erlaubt';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return 'Verarbeitung des Bildes fehlgeschlagen: $path';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return 'PDF-Erstellung aus Bildern fehlgeschlagen: $details';
  }

  @override
  String get errorPdfMergeInsufficient =>
      'Bitte wähle mindestens 2 PDF-Dateien zum Zusammenführen aus';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return '$fileName ist passwortgeschützt oder beschädigt';
  }

  @override
  String get errorPdfMergeNoPages =>
      'Ausgewählte Dokumente enthalten keine Seiten';

  @override
  String errorPdfMergeFailed(String details) {
    return 'PDF-Zusammenführung fehlgeschlagen: $details';
  }

  @override
  String get errorPdfSplitNoRanges =>
      'Bitte gib mindestens einen Seitenbereich an';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return '$fileName ist passwortgeschützt oder beschädigt';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return 'Bereich $start-$end liegt außerhalb der Seitenzahl von $fileName';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return 'PDF-Teilung fehlgeschlagen: $details';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return 'S. $current/$total';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '($bytes Bytes)';
  }

  @override
  String get directoriesProtectedTitle =>
      'Dieser Ordner ist von Android geschützt.';

  @override
  String get directoriesProtectedDesc =>
      'Android schränkt den Zugriff auf System- und private App-Ordner ein.';

  @override
  String get directoriesNotFoundTitle => 'Dieser Ordner existiert nicht mehr.';

  @override
  String get directoriesEmpty =>
      'Hier gibt es keine unterstützten Dateien oder Ordner.';

  @override
  String get directoriesErrorOpening => 'Fehler beim Öffnen des Ordners';

  @override
  String get directoriesRoot => 'Stammverzeichnis';

  @override
  String get scanSettingsSectionFrequency => 'Scan-Häufigkeit';

  @override
  String get scanSettingsSectionFilters => 'Dokumentfilter';

  @override
  String get scanSettingsIncludeImages => 'Bilder einbeziehen';

  @override
  String get scanSettingsIncludeImagesDesc =>
      'Deaktivieren, um Tausende Fotos aus deiner Dokumentenliste auszublenden';

  @override
  String get scanSettingsImageListUpdated => 'Bilderliste aktualisiert';

  @override
  String get scanSettingsActionRescanNow => 'Jetzt neu scannen';

  @override
  String get scanSettingsSectionDiagnostics => 'Speicherdiagnose';

  @override
  String get scanSettingsAllFilesAccessGranted =>
      'Zugriff auf alle Dateien gewährt';

  @override
  String get scanSettingsAllFilesAccessNeeded =>
      'Zugriff auf alle Dateien erforderlich';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      'Doc View hat die Berechtigung, Dateien in Downloads und auf SD-Karten zu finden.';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      'Berechtigung erforderlich, um Downloads und externe Speicherordner zu scannen.';

  @override
  String get scanSettingsActionOpenSettings => 'Einstellungen öffnen';

  @override
  String scanSettingsScanningFiles(int count) {
    return 'Wird gescannt... $count Dateien gefunden';
  }

  @override
  String get faqStillNeedHelp => 'Noch Hilfe nötig? Feedback senden';

  @override
  String get toolsLabelFileName => 'Dateiname';

  @override
  String get toolsAddImagesToStart => 'Zum Starten Bilder hinzufügen';

  @override
  String get toolsAddImagesDesc =>
      'Wähle Fotos aus oder scanne Papierdokumente, um ein PDF zu erstellen.';

  @override
  String get toolsChoosePhotos => 'Fotos auswählen';

  @override
  String get toolsScanPaper => 'Dokument scannen';

  @override
  String toolsPageNumber(int page) {
    return 'Seite $page';
  }

  @override
  String get toolsTooltipRotatePage => 'Seite drehen';

  @override
  String get toolsTooltipRemovePage => 'Seite entfernen';

  @override
  String get toolsAddMoreScans => 'Weitere Scans hinzufügen';

  @override
  String get toolsAddMoreImages => 'Weitere Bilder hinzufügen';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bilder · gesch. ~ $size',
      one: '1 Bild · gesch. ~ $size',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return 'Mindestens $min Dateien auswählen';
  }

  @override
  String toolsPagesTotal(int count) {
    return '$count Seiten insgesamt';
  }

  @override
  String get toolsPagesTotalLabel => 'Seiten insgesamt';

  @override
  String get toolsNoPdfsFound => 'Keine PDF-Dokumente gefunden';

  @override
  String get semanticBookmarked => 'mit Lesezeichen';

  @override
  String get semanticSelected => 'ausgewählt';

  @override
  String get semanticNotSelected => 'nicht ausgewählt';

  @override
  String get actionDeselectFile => 'Dateiauswahl aufheben';

  @override
  String get actionSelectFile => 'Datei auswählen';

  @override
  String get actionCreatePdf => 'PDF erstellen';

  @override
  String get hintSelectOrViewActions => 'Auswählen oder Aktionen anzeigen';

  @override
  String get actionClose => 'Schließen';

  @override
  String get actionReset => 'Zurücksetzen';

  @override
  String get labelPleaseWait => 'Bitte warten...';

  @override
  String get tooltipCloseSearch => 'Suche schließen';

  @override
  String get semanticAdvertisement => 'Werbung';

  @override
  String get themePreviewLight => 'Hell';

  @override
  String get themePreviewNavy => 'Marine';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '$name, $size, erstellt am $date';
  }

  @override
  String get toolsCreatingPdfFromScans => 'PDF wird aus Scans erstellt';

  @override
  String get toolsCreatingPdf => 'PDF wird erstellt';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return 'Bild $done von $total wird verarbeitet...';
  }

  @override
  String get toolsErrorCreatePdfTitle => 'PDF konnte nicht erstellt werden';

  @override
  String get toolsBadgeProtectedOrDamaged => 'Geschützt oder beschädigt';

  @override
  String toolsPageCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten',
      one: '1 Seite',
    );
    return '$_temp0';
  }

  @override
  String get toolsPagesAbbrev => 'S.';

  @override
  String get mergeAddMoreTitle => 'Weitere PDFs hinzufügen';

  @override
  String get mergeProgressTitle => 'PDFs werden zusammengeführt';

  @override
  String mergeProgressMessage(int done, int total) {
    return 'Dokument $done von $total wird zusammengeführt...';
  }

  @override
  String get mergeErrorTitle => 'PDFs konnten nicht zusammengeführt werden';

  @override
  String get mergeDragInstruction => 'Zum Neuordnen Griffe ziehen';

  @override
  String get mergeAddPdf => 'PDF hinzufügen';

  @override
  String get mergeOutputFileNameLabel => 'NAME DER AUSGABEDATEI';

  @override
  String mergeItemPageCountAndSize(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten · $size',
      one: '1 Seite · $size',
    );
    return '$_temp0';
  }

  @override
  String mergeItemLoadingPagesAndSize(String size) {
    return 'Seiten werden geladen... · $size';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ungültige Dateien erkannt',
      one: '1 ungültige Datei erkannt',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => 'Bereit zum Zusammenführen';

  @override
  String get mergeRemoveProtectedHint =>
      'Bitte entferne passwortgeschützte Dokumente';

  @override
  String mergeSummary(int files, int pages, String size) {
    return '$files Dateien · $pages Seiten · ~ $size';
  }

  @override
  String get mergeReadyBadge => 'Bereit';

  @override
  String get mergeBlockedCta => 'Zusammenführen blockiert (Fehler beheben)';

  @override
  String mergeActionCta(int files, int pages) {
    return '$files PDFs zusammenführen ($pages Seiten)';
  }

  @override
  String get mergePickerDefaultTitle => 'PDFs auswählen';

  @override
  String mergePickerTabAllPdfs(int count) {
    return 'Alle PDFs ($count)';
  }

  @override
  String get mergePickerTabRecent => 'Zuletzt';

  @override
  String get mergePickerTabDownloads => 'Downloads';

  @override
  String get mergePickerTabICloud => 'iCloud Drive';

  @override
  String get splitProgressTitle => 'PDF wird geteilt';

  @override
  String splitProgressMessage(int done, int total) {
    return 'Datei $done von $total wird erstellt...';
  }

  @override
  String get splitErrorTitle => 'PDF konnte nicht geteilt werden';

  @override
  String get splitPageRangesLabel => 'SEITENBEREICHE';

  @override
  String get splitPageRangesSyntax => 'Syntax: 1-3, 5, 8-10';

  @override
  String get splitRangeHelpText =>
      'Jeder Bereich wird zu einer eigenen PDF-Datei.';

  @override
  String splitGeneratedFilesHeader(int count) {
    return 'ERZEUGTE DATEIEN ($count)';
  }

  @override
  String get splitChipsSuspendedTitle => 'Live-Vorschau pausiert';

  @override
  String get splitChipsSuspendedDesc =>
      'Behebe den Syntaxfehler oben, um die Extraktion wiederherzustellen.';

  @override
  String get splitEmptyRangesHint =>
      'Gib oben Seitenbereiche ein, um PDF-Teile zu erzeugen';

  @override
  String splitChipSinglePage(int page) {
    return 'Seite $page';
  }

  @override
  String splitChipPageRange(int start, int end) {
    return 'Seiten $start–$end';
  }

  @override
  String splitChipPageCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count S.',
      one: '1 S.',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => 'SCHNELLAUSWAHL';

  @override
  String get splitMacroAllPages => 'Alle Seiten';

  @override
  String get splitMacroEvery5Pages => 'Alle 5 Seiten';

  @override
  String get splitMacroLimitHint =>
      'Makros mit > 100 Dateien sind zum Schutz des Gerätespeichers deaktiviert';

  @override
  String splitOutputSummary(int files, int pages) {
    return 'Ausgabe: $files Dateien · $pages Seiten extrahiert';
  }

  @override
  String splitEstSize(String size) {
    return 'GESCH. ~ $size';
  }

  @override
  String splitActionCtaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count PDFs teilen',
      one: 'In 1 PDF teilen',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => 'In PDFs teilen';

  @override
  String splitPickerAllLocalDocs(int count) {
    return 'ALLE LOKALEN DOKUMENTE ($count)';
  }

  @override
  String get splitPickerSortByDate => 'NACH DATUM SORTIEREN';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return 'S. · $size';
  }

  @override
  String get splitPickerTitle => 'PDF zum Teilen auswählen';

  @override
  String get faqShortTitle => 'FAQ';

  @override
  String splitPickerSelectedCount(int count) {
    return '$count PDF ausgewählt';
  }

  @override
  String get splitPickerSelectDocumentHint =>
      'Dokument auswählen, um fortzufahren';

  @override
  String splitPickerPagesActive(int count) {
    return '$count Seiten aktiv';
  }

  @override
  String get splitPickerPagesActiveLabel => 'Seiten aktiv';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionGeneral => 'Allgemein';

  @override
  String get settingsSectionOthers => 'Sonstiges';

  @override
  String get settingsFileManagerTitle => 'Dateimanager';

  @override
  String get settingsFileManagerSubtitle =>
      'Speicherverzeichnisse und Ordner durchsuchen';

  @override
  String get settingsFaqTitle => 'FAQ';

  @override
  String get settingsFaqSubtitle => 'Häufig gestellte Fragen';

  @override
  String get settingsShareTitle => 'Teilen';

  @override
  String get settingsShareSubtitle => 'Doc View Freunden empfehlen';

  @override
  String settingsShareMessage(String url) {
    return 'Sieh dir Doc View an – der schnelle, private Offline-Dokumentenreader: $url';
  }

  @override
  String get settingsScanSettingsTitle => 'Scan-Einstellungen';

  @override
  String get settingsScanModeOnOpen => 'Beim Öffnen scannen';

  @override
  String get settingsScanModeManual => 'Nur manuell';

  @override
  String get settingsAppThemeTitle => 'App-Design';

  @override
  String get settingsThemeSystem => 'Systemstandard';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsLanguageTitle => 'Sprache';

  @override
  String get settingsRateUsTitle => 'Bewerte uns';

  @override
  String get settingsRateUsSubtitle => 'Teile uns dein Feedback mit';

  @override
  String get settingsAddWidgetTitle => 'Widget hinzufügen';

  @override
  String get settingsAddWidgetSubtitle => 'Schnellzugriff vom Startbildschirm';

  @override
  String get settingsTermsTitle => 'Nutzungsbedingungen';

  @override
  String get settingsTermsSubtitle => 'Unsere Nutzungsbedingungen lesen';

  @override
  String get settingsPrivacyTitle => 'Datenschutzerklärung';

  @override
  String get settingsPrivacySubtitle => 'Unsere Datenschutzerklärung lesen';

  @override
  String get settingsManageSubscriptionsTitle => 'Abos verwalten';

  @override
  String get settingsManageSubscriptionsSubtitle =>
      'Dein Store-Abonnement verwalten';

  @override
  String settingsVersionDisplay(String version, String build) {
    return 'Version $version ($build)';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return 'Version $version Build $build';
  }

  @override
  String get settingsOpenSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get rateSheetTitle => 'Doc View bewerten';

  @override
  String get rateSheetSubtitle => 'Dein Feedback hilft uns, besser zu werden';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sterne',
      one: '1 Stern',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => 'Schön, dass es dir gefällt!';

  @override
  String get rateResponseMedium => 'Danke! Sag uns, was wir verbessern können.';

  @override
  String get rateResponseLow =>
      'Schade, dass es nicht überzeugt hat. Sag uns, was wir beheben sollen.';

  @override
  String get rateActionStore => 'Auf Google Play bewerten';

  @override
  String get rateActionHelpFeedback => 'Hilfe & Feedback';

  @override
  String get faqFromRatingBanner =>
      'Schade zu hören. Sieh dir die Antworten unten an oder kontaktiere uns – wir lesen jede Nachricht.';

  @override
  String get faqActionContactUs => 'Kontakt aufnehmen';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return 'Doc View Feedback ($version+$build)';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '\n\n---\nApp: Doc View $version (Build $build)\n';
  }

  @override
  String get faqEmailClientUnavailable =>
      'E-Mail-Client konnte nicht geöffnet werden';

  @override
  String get languageScreenTitle => 'Sprache';

  @override
  String get languageSearchHint => 'Sprachen suchen...';

  @override
  String get languageSystemDefault => 'Systemstandard';

  @override
  String get languageSystemDefaultSubtitle => 'Gerätesprache verwenden';

  @override
  String get languageNotTranslatedBadge => '(nicht übersetzt)';

  @override
  String get languageNotTranslatedSnack =>
      'Diese Sprache ist noch nicht übersetzt';

  @override
  String get languageNoResults => 'Keine passenden Sprachen';

  @override
  String get languagePseudoLocaleName => 'Pseudo-Locale (en_XA)';

  @override
  String get languagePseudoLocaleSubtitle => 'Debug-Textlängentest';

  @override
  String get scanSettingsSectionHistory => 'Verlauf';

  @override
  String get scanSettingsClearHistoryTitle => 'Verlauf löschen';

  @override
  String get scanSettingsClearHistorySubtitle =>
      'Verlauf geöffneter Dokumente löschen';

  @override
  String get scanSettingsClearHistoryDialogTitle => 'Verlauf löschen?';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      'Dateien werden aus „Zuletzt“ entfernt. Deine Dateien und Lesezeichen bleiben unberührt.';

  @override
  String get scanSettingsRecentHistoryCleared => 'Verlauf gelöscht';

  @override
  String get scanSettingsLastScanToday => 'heute';

  @override
  String get scanSettingsLastScanYesterday => 'gestern';

  @override
  String get scanSettingsNeverScanned => 'Nie gescannt';

  @override
  String get scanSettingsLastScanPrefix => 'Letzter Scan:';

  @override
  String get readerActionVertical => 'Vertikal';

  @override
  String get readerActionHorizontal => 'Horizontal';

  @override
  String get readerActionRotate => 'Drehen';

  @override
  String get readerActionSearch => 'Suchen';

  @override
  String get readerActionInvert => 'Invertieren';

  @override
  String get readerActionShare => 'Teilen';

  @override
  String get readerActionPages => 'Seiten';

  @override
  String get readerSearchHint => 'Im Dokument suchen...';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '$current von $total';
  }

  @override
  String get readerSearchMatchCap => '500+';

  @override
  String get readerSearchNoMatches => '0 von 0';

  @override
  String get readerSearchNoTextLayer =>
      'Dieses PDF enthält keinen durchsuchbaren Text';

  @override
  String get readerSearchPrevMatch => 'Vorheriger Treffer';

  @override
  String get readerSearchNextMatch => 'Nächster Treffer';

  @override
  String readerTopPagesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten • $size',
      one: '1 Seite • $size',
    );
    return '$_temp0';
  }

  @override
  String get readerMenuGoToPage => 'Gehe zu Seite';

  @override
  String get readerMenuAddBookmark => 'Lesezeichen hinzufügen';

  @override
  String get readerMenuRemoveBookmark => 'Lesezeichen entfernen';

  @override
  String get readerMenuDetails => 'Details';

  @override
  String get readerMenuOpenInAnotherApp => 'In anderer App öffnen';

  @override
  String get readerTooltipConvertToWord => 'In Word umwandeln';

  @override
  String get pagesScreenTitle => 'Seiten';

  @override
  String pagesScreenPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten',
      one: '1 Seite',
    );
    return '$_temp0';
  }

  @override
  String get pagesActionSelectAll => 'Alle auswählen';

  @override
  String get pagesActionClearSelection => 'Aufheben';

  @override
  String get pagesActionSave => 'Speichern';

  @override
  String get pagesActionInsert => 'Einfügen';

  @override
  String get pagesActionRotate => 'Drehen';

  @override
  String get pagesActionExtract => 'Extrahieren';

  @override
  String get pagesActionDelete => 'Löschen';

  @override
  String get pagesActionUndo => 'Rückgängig';

  @override
  String get pagesInsertSheetTitle => 'Seiten einfügen';

  @override
  String get pagesInsertPagesFromPdf => 'Seiten aus anderem PDF';

  @override
  String get pagesDeleteAllBlocked =>
      'Es können nicht alle Seiten gelöscht werden. Ein Dokument muss mindestens eine Seite haben.';

  @override
  String get pagesSaveDialogTitle => 'Änderungen speichern';

  @override
  String get pagesSaveAsNew => 'Als neue Datei speichern';

  @override
  String get pagesSaveReplace => 'Original ersetzen';

  @override
  String get pagesSaveReplaceWarning =>
      'Dadurch wird die Originaldatei überschrieben.';

  @override
  String get pagesSaveFileNameLabel => 'Dateiname';

  @override
  String get pagesDiscardDialogTitle => 'Änderungen verwerfen?';

  @override
  String get pagesDiscardDialogBody =>
      'Du hast ungespeicherte Änderungen. Möchtest du sie wirklich verwerfen?';

  @override
  String get pagesDiscardButton => 'Verwerfen';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten extrahiert',
      one: '1 Seite extrahiert',
    );
    return '$_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      'Dieses PDF kann nicht bearbeitet werden, da es verschlüsselt oder nicht lesbar ist.';

  @override
  String get viewerErrorCorruptTitle => 'Dokument kann nicht geöffnet werden';

  @override
  String get viewerErrorCorruptMessage =>
      'Diese Datei scheint beschädigt zu sein oder ist kein gültiges Dokument.';

  @override
  String get viewerErrorMissingTitle => 'Diese Datei existiert nicht mehr';

  @override
  String get viewerErrorMissingMessage =>
      'Die Datei wurde gelöscht oder vom Gerätespeicher verschoben.';

  @override
  String get viewerErrorBackToFiles => 'Zurück zu den Dateien';

  @override
  String get viewerErrorNoAppFound =>
      'Keine App zum Öffnen dieser Datei gefunden';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Treffer',
      one: '1 Treffer',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einheiten • $ext',
      one: '1 Einheit • $ext',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner => 'Altes Format: nur Text';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      'Große Arbeitsmappe: Es werden die ersten 20.000 Zeilen und 100 Spalten angezeigt';

  @override
  String viewerSectionTitle(int number) {
    return 'Abschnitt $number';
  }

  @override
  String get viewerMenuOutline => 'Gliederung';

  @override
  String get viewerOutlineTitle => 'Dokumentgliederung';

  @override
  String get viewerCloseOutline => 'Gliederung schließen';

  @override
  String get viewerNoSections => 'Keine Abschnitte in diesem Dokument gefunden';

  @override
  String get viewerOutlineTooltip => 'Inhaltsverzeichnis';

  @override
  String get viewerActionOpenExternal => 'In anderer App öffnen';

  @override
  String get viewerErrorCantOpenTitle => 'Dokument kann nicht geöffnet werden';

  @override
  String get viewerErrorCantOpenMessage =>
      'Das Dokument konnte offline nicht dargestellt werden.';

  @override
  String get viewerOpeningDocument => 'Dokument wird geöffnet...';

  @override
  String get viewerErrorEncryptedTitle => 'Dieses Dokument ist verschlüsselt';

  @override
  String get viewerErrorEncryptedMessage =>
      'Passwortgeschützte Dateien können im Offline-Reader nicht angezeigt werden.';

  @override
  String get viewerErrorTooLargeTitle =>
      'Diese Datei überschreitet das Anzeigelimit';

  @override
  String get viewerErrorTooLargeMessage =>
      'Große Dokumente sollten mit einem externen Office-Viewer geöffnet werden.';

  @override
  String get viewerErrorUnsupportedFormatTitle =>
      'Dieses Format wird nicht unterstützt';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      'Doc View kann dieses Dateiformat nicht direkt verarbeiten.';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => 'Typografie';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get txtViewerMonospaceLabel => 'Schriftart mit fester Breite';

  @override
  String get txtViewerTruncationBanner =>
      'Datei ist größer als 1 MB: Es wird das erste 1 MB angezeigt';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zeilen • $size',
      one: '1 Zeile • $size',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => 'Typografie-Einstellungen';

  @override
  String get txtViewerTooltipDecreaseFont => 'Schriftgröße verkleinern';

  @override
  String get txtViewerTooltipIncreaseFont => 'Schriftgröße vergrößern';

  @override
  String get txtViewerTooltipToggleMonospace =>
      'Feste Schriftbreite umschalten';

  @override
  String get txtViewerMonospaceSubtitle =>
      'Zeichen mit fester Breite für Code und Protokolle';

  @override
  String get txtViewerPreviewLabel => 'Vorschau';

  @override
  String get txtViewerPreviewText =>
      'Franz jagt im komplett verwahrlosten Taxi quer durch Bayern.';

  @override
  String get txtViewerErrorTitle => 'Textdatei kann nicht gelesen werden';

  @override
  String get txtViewerErrorMessage =>
      'Das Dateiformat oder die Zeichenkodierung konnte nicht gelesen werden.';

  @override
  String get txtViewerActionRetry => 'Erneut versuchen';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '$width × $height • $size';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get imageViewerTooltipFitToScreen => 'An Bildschirm anpassen';

  @override
  String get imageViewerErrorCorrupt => 'Bild kann nicht geladen werden';

  @override
  String get imageViewerLoading => 'Bild wird geladen…';

  @override
  String get viewerDispatcherFileMissing => 'Datei existiert nicht mehr';

  @override
  String get viewerSpreadsheetFormulaBarEmpty => '-';

  @override
  String get viewerSpreadsheetAllCells => 'Alle';

  @override
  String viewerSpreadsheetColumnLabel(String col) {
    return 'Spalte $col';
  }

  @override
  String viewerSpreadsheetRowLabel(int row) {
    return 'Zeile $row';
  }

  @override
  String viewerSpreadsheetCellSemantics(String col, int row, String value) {
    return 'Spalte $col, Zeile $row, $value';
  }

  @override
  String get viewerSpreadsheetEmptyCell => 'leer';

  @override
  String get viewerSpreadsheetEmptySheet => 'Dieses Tabellenblatt ist leer';

  @override
  String get viewerSpreadsheetCopiedSingle => 'Zelle kopiert';

  @override
  String viewerSpreadsheetCopiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zellen kopiert',
      one: '1 Zelle kopiert',
    );
    return '$_temp0';
  }

  @override
  String get viewerSpreadsheetCopyLimitReached =>
      'Auswahl auf 5.000 Zellen gekürzt';

  @override
  String get viewerSpreadsheetCellContentTitle => 'Zelleninhalt';

  @override
  String get viewerSpreadsheetCopyAction => 'Kopieren';

  @override
  String get viewerSpreadsheetCloseAction => 'Schließen';

  @override
  String viewerSpreadsheetZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get viewerSpreadsheetResetZoomTooltip => 'Zoom auf 100 % zurücksetzen';

  @override
  String get viewerSpreadsheetNoMatches =>
      'Keine Treffer in diesem Tabellenblatt';

  @override
  String get viewerSpreadsheetSearchPlaceholder => 'Im Tabellenblatt suchen…';

  @override
  String get viewerSpreadsheetPasswordTitle => 'Passwortgeschützte Datei';

  @override
  String get viewerSpreadsheetPasswordMessage =>
      'Passwortgeschützte Dateien können hier nicht geöffnet werden.';

  @override
  String get viewerSpreadsheetErrorTitle => 'Tabelle kann nicht gelesen werden';

  @override
  String get viewerSpreadsheetCorruptMessage =>
      'Die Tabellendatei ist beschädigt oder konnte nicht dekodiert werden.';

  @override
  String get viewerSpreadsheetTimeoutMessage =>
      'Zeitüberschreitung beim Öffnen der Tabelle nach 20 Sekunden.';

  @override
  String get viewerSpreadsheetTooLargeMessage =>
      'Diese Datei überschreitet das Anzeigelimit von 25 MB.';

  @override
  String get viewerSpreadsheetOpenBasicViewer => 'Im Basis-Viewer öffnen';

  @override
  String get viewerSpreadsheetOpenAnotherApp => 'In anderer App öffnen';

  @override
  String get toolsWorkspaceOverline => 'ARBEITSBEREICH';

  @override
  String get toolsTitle => 'Tools';

  @override
  String get toolsSectionConvertCreate => 'UMWANDELN & ERSTELLEN';

  @override
  String get toolsSectionEditManage => 'BEARBEITEN & VERWALTEN';

  @override
  String get toolsSectionOthers => 'SONSTIGES';

  @override
  String get toolsCreatedByYou => 'Von dir erstellt';

  @override
  String get toolsCreatedByYouEmpty => 'Erstellte PDFs erscheinen hier';

  @override
  String get toolsCreatedByYouSeeAll => 'Alle ansehen';

  @override
  String get toolManagePages => 'Seiten verwalten';

  @override
  String get toolManagePagesSub => 'Neu anordnen, drehen & löschen';

  @override
  String get toolImportFiles => 'Dateien importieren';

  @override
  String get toolImportFilesSub => 'Aus anderen Apps hinzufügen';

  @override
  String get toolPrintPdf => 'PDF drucken';

  @override
  String get toolPrintPdfSub => 'An beliebigen Drucker senden';

  @override
  String get toolCreatePdf => 'PDF erstellen';

  @override
  String get toolCreatePdfSub => 'Leeres Dokument oder Vorlage';

  @override
  String get toolRecycleBin => 'Papierkorb';

  @override
  String get toolRecycleBinSub => 'Gelöschte Dateien wiederherstellen';

  @override
  String get toolAnnotate => 'Anmerken';

  @override
  String get toolAnnotateSub => 'Hervorheben, zeichnen & markieren';

  @override
  String get toolAddText => 'Text hinzufügen';

  @override
  String get toolAddTextSub => 'Text & Datum einfügen';

  @override
  String get toolSign => 'Signieren';

  @override
  String get toolSignSub => 'Formulare ausfüllen & signieren';

  @override
  String get toolWordToPdf => 'Word in PDF';

  @override
  String get toolWordToPdfSub => 'DOCX in PDF umwandeln';

  @override
  String get toolPptToPdf => 'PPT in PDF';

  @override
  String get toolPptToPdfSub => 'PPTX in PDF umwandeln';

  @override
  String get printPdfErrorTooLarge =>
      'Die PDF-Datei überschreitet das Drucklimit von 50 MB.';

  @override
  String get printPdfErrorUnreadable =>
      'PDF kann zum Drucken nicht gelesen werden.';

  @override
  String get printPdfErrorPassword =>
      'Passwortgeschützte PDFs können nicht direkt gedruckt werden.';

  @override
  String get printPdfErrorFailed => 'Drucken fehlgeschlagen.';

  @override
  String get printPdfSuccess => 'Dokument an Drucker gesendet.';

  @override
  String get toolPickerTitleSelectPdf => 'PDF auswählen';

  @override
  String get toolPickerTitleSelectPdfs => 'PDFs auswählen';

  @override
  String get toolPickerBrowseFiles => 'Dateien durchsuchen';

  @override
  String get toolPickerTabAll => 'Alle PDFs';

  @override
  String get toolPickerTabRecent => 'Zuletzt';

  @override
  String get toolPickerTabDownloads => 'Downloads';

  @override
  String get toolPickerTabICloud => 'iCloud Drive';

  @override
  String get toolPickerActionPrint => 'Drucken';

  @override
  String get toolPickerActionManage => 'Verwalten';

  @override
  String get toolPickerActionSelect => 'Auswählen';

  @override
  String get toolsImportActionView => 'Anzeigen';

  @override
  String get createPdfTemplateBlank => 'Leer';

  @override
  String get createPdfTemplateLine1 => 'Liniert 1';

  @override
  String get createPdfTemplateLine2 => 'Liniert 2';

  @override
  String get createPdfTemplateNotebook => 'Notizbuch';

  @override
  String get createPdfTemplateCornell => 'Cornell';

  @override
  String get createPdfTemplateGrid => 'Kariert';

  @override
  String get createPdfTemplateGraph => 'Millimeterpapier';

  @override
  String get createPdfSwatchWhite => 'Weiß';

  @override
  String get createPdfSwatchCream => 'Creme';

  @override
  String get createPdfSwatchLightYellow => 'Hellgelb';

  @override
  String get createPdfSwatchLightPeach => 'Hellpfirsich';

  @override
  String get createPdfSwatchLightPink => 'Hellrosa';

  @override
  String get createPdfSwatchLightLavender => 'Helllavendel';

  @override
  String get createPdfSwatchLightBlue => 'Hellblau';

  @override
  String get createPdfSwatchLightMint => 'Hellmint';

  @override
  String get createPdfSwatchLightGreen => 'Hellgrün';

  @override
  String get createPdfSwatchLightGray => 'Hellgrau';

  @override
  String get createPdfOrientationPortrait => 'Hochformat';

  @override
  String get createPdfOrientationLandscape => 'Querformat';

  @override
  String get createPdfSectionTemplate => 'VORLAGE';

  @override
  String get createPdfSectionPageSize => 'SEITENGRÖSSE';

  @override
  String get createPdfSectionOrientation => 'AUSRICHTUNG';

  @override
  String get createPdfSectionPageColor => 'SEITENFARBE';

  @override
  String get createPdfSectionPageCount => 'SEITENANZAHL';

  @override
  String createPdfPagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten',
      one: '1 Seite',
    );
    return '$_temp0';
  }

  @override
  String createPdfSummary(String pages, String size, String orientation) {
    return '$pages • $size • $orientation';
  }

  @override
  String get createPdfCreating => 'PDF wird erstellt...';

  @override
  String createPdfProgress(int done, int total) {
    return 'Seite $done von $total wird erstellt...';
  }

  @override
  String get createPdfErrorTitle => 'PDF konnte nicht erstellt werden';

  @override
  String get createPdfErrorPageCount =>
      'Die Seitenanzahl muss zwischen 1 und 100 liegen.';

  @override
  String get createPdfErrorInvalidName =>
      'Bitte gib einen gültigen Dateinamen ein.';

  @override
  String get createPdfErrorGeneration =>
      'PDF-Dokument konnte nicht erstellt werden. Bitte versuche es erneut.';

  @override
  String get trashErrorTooLarge =>
      'Datei ist zu groß für den Papierkorb (200 MB Limit)';

  @override
  String get trashErrorNotEnoughSpace =>
      'Nicht genügend Speicherplatz im Papierkorb';

  @override
  String trashErrorGeneric(String details) {
    return 'Papierkorb-Vorgang fehlgeschlagen: $details';
  }

  @override
  String get trashDialogMoveTitle => 'In den Papierkorb verschieben?';

  @override
  String trashDialogMoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Dateien in den Papierkorb verschieben? Du kannst sie 30 Tage lang unter Tools > Papierkorb wiederherstellen.',
      one:
          '1 Datei in den Papierkorb verschieben? Du kannst sie 30 Tage lang unter Tools > Papierkorb wiederherstellen.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionMove => 'In Papierkorb verschieben';

  @override
  String trashMovedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien in den Papierkorb verschoben',
      one: '1 Datei in den Papierkorb verschoben',
    );
    return '$_temp0';
  }

  @override
  String get trashActionUndo => 'Rückgängig';

  @override
  String trashRestoredSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien wiederhergestellt',
      one: '1 Datei wiederhergestellt',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogDeleteForeverTitle => 'Endgültig löschen?';

  @override
  String trashDialogDeleteForeverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Dateien endgültig löschen? Dies kann nicht rückgängig gemacht werden.',
      one:
          '1 Datei endgültig löschen? Dies kann nicht rückgängig gemacht werden.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionDeleteForever => 'Endgültig löschen';

  @override
  String trashDeletedForeverSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien endgültig gelöscht',
      one: '1 Datei endgültig gelöscht',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogEmptyTitle => 'Papierkorb leeren?';

  @override
  String trashDialogEmptyBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien',
      one: '1 Datei',
    );
    return 'Alle $_temp0 endgültig löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get trashActionEmptyBin => 'Papierkorb leeren';

  @override
  String get trashEmptyTitle => 'Der Papierkorb ist leer';

  @override
  String get trashEmptySubtitle =>
      'In den Papierkorb verschobene Dateien bleiben hier 30 Tage lang, bevor sie endgültig gelöscht werden.';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Tage',
      one: 'Noch 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String trashSubtitle(String date, String size) {
    return 'Gelöscht am $date · $size';
  }

  @override
  String get trashDialogTooLargeTitle => 'Zu groß für den Papierkorb';

  @override
  String trashDialogTooLargeBody(String fileName) {
    return '„$fileName“ ist größer als 200 MB und kann nicht in den Papierkorb verschoben werden. Möchtest du die Datei endgültig löschen?';
  }

  @override
  String get trashActionDeletePermanently => 'Endgültig löschen';

  @override
  String get trashInfoBanner =>
      'Elemente im Papierkorb werden nach 30 Tagen endgültig gelöscht.';

  @override
  String get trashSheetRestore => 'Wiederherstellen';

  @override
  String get trashSheetDeleteForever => 'Endgültig löschen';

  @override
  String get trashSheetDetails => 'Details';

  @override
  String get trashDetailsOriginalLocation => 'Ursprünglicher Speicherort';

  @override
  String get trashDetailsDateDeleted => 'Löschdatum';

  @override
  String get trashDetailsExpiresIn => 'Läuft ab in';

  @override
  String trashRestoredToFallbackSuccess(String location) {
    return 'Wiederhergestellt in $location (Originalordner nicht gefunden)';
  }

  @override
  String get trashDialogCopyFailedTitle =>
      'Verschieben in Papierkorb fehlgeschlagen';

  @override
  String trashDialogCopyFailedBody(String fileName) {
    return '„$fileName“ konnte nicht in den Papierkorb verschoben werden. Endgültig löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get trashDialogEmptyProgress => 'Papierkorb wird geleert...';

  @override
  String get trashDialogMoveProgress =>
      'Dateien werden in den Papierkorb verschoben...';

  @override
  String get trashDialogNotEnoughSpaceTitle => 'Nicht genügend Speicherplatz';

  @override
  String get trashDialogNotEnoughSpaceBody =>
      'Es ist nicht genügend Speicherplatz vorhanden, um in den Papierkorb zu verschieben. Gib Speicherplatz frei, indem du den Papierkorb leerst.';

  @override
  String get trashActionFreeUpSpace => 'Speicherplatz freigeben';

  @override
  String get trashDialogDeleteForeverProgress =>
      'Dateien werden endgültig gelöscht...';

  @override
  String get galleryDebugAgeTrash =>
      'Alle Papierkorb-Elemente um 29 Tage altern lassen';

  @override
  String get galleryDebugSlowCopy => 'Langsames Papierkorb-Kopieren (Test)';

  @override
  String get galleryDebugSlowCopySubtitle =>
      'Drosselt Kopierschleife auf ~20 MB/s für Kill-Tests';

  @override
  String get galleryDebugSlowSave => 'Langsames Editor-Speichern (Test)';

  @override
  String get galleryDebugSlowSaveSubtitle =>
      'Drosselt Speicherschleife auf ~8 s für Kill-Tests';

  @override
  String get galleryDebugSaveAnnotate =>
      'Beispiel 100 S. speichern (Anmerken-Test)';

  @override
  String get galleryDebugSaveSign =>
      'Beispiel 100 S. speichern (Signieren-Test)';

  @override
  String get galleryDebugSaveText => 'Beispiel 100 S. speichern (Text-Test)';

  @override
  String get galleryDebugMove190Mb =>
      '190-MB-Testdatei in Papierkorb verschieben';

  @override
  String get galleryDebugRestoreLastTrash =>
      'Letztes Papierkorb-Element wiederherstellen';

  @override
  String get galleryDebugEmptyTrash => 'Papierkorb leeren';

  @override
  String galleryDebugAgeTrashSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Elemente',
      one: '1 Element',
    );
    return '$_temp0 um 29 Tage gealtert';
  }

  @override
  String get annotateErrorPasswordProtected =>
      'Dieses PDF ist passwortgeschützt.';

  @override
  String get annotateErrorCorrupt =>
      'Dieses PDF ist beschädigt oder kann nicht gelesen werden.';

  @override
  String get annotateSignedReplaceBlocked =>
      'Das Ersetzen des signierten Originals ist nicht zulässig. Bitte als neue Datei speichern.';

  @override
  String annotateErrorSaveFailed(String details) {
    return 'Speichern der Anmerkungen fehlgeschlagen: $details';
  }

  @override
  String get annotateErrorScannedPdf =>
      'Dieses Dokument scheint gescannt zu sein oder enthält keinen auswählbaren Text.';

  @override
  String get annotateSignedBanner =>
      'Digital signiertes PDF: Beim Speichern wird eine neue Kopie erstellt, um die Signatur zu erhalten.';

  @override
  String get annotateActionSaveNew => 'Als neue Datei speichern';

  @override
  String get annotateActionReplace => 'Original ersetzen';

  @override
  String get annotateDiscardDialogTitle =>
      'Ungespeicherte Anmerkungen verwerfen?';

  @override
  String get annotateDiscardDialogBody =>
      'Du hast ungespeicherte Markierungen. Wenn du jetzt beendest, gehen deine Änderungen verloren.';

  @override
  String get annotateDiscardDialogActionDiscard => 'Verwerfen';

  @override
  String get annotateDiscardDialogActionKeep => 'Weiter bearbeiten';

  @override
  String get annotateSaveSuccess => 'Anmerkungen erfolgreich gespeichert';

  @override
  String get annotateToolbarHighlight => 'Hervorheben';

  @override
  String get annotateToolbarUnderline => 'Unterstreichen';

  @override
  String get annotateToolbarStrikethrough => 'Durchstreichen';

  @override
  String get annotateToolbarCopy => 'Kopieren';

  @override
  String get annotateColorYellow => 'Gelb';

  @override
  String get annotateColorGreen => 'Grün';

  @override
  String get annotateColorCyan => 'Cyan';

  @override
  String get annotateColorPink => 'Pink';

  @override
  String get annotateColorOrange => 'Orange';

  @override
  String get annotateSaveTitle => 'Anmerkungen speichern';

  @override
  String get annotateSaveProgress => 'Anmerkungen werden gespeichert...';

  @override
  String get annotateNoChanges => 'Keine Anmerkungen zum Speichern';

  @override
  String get annotateTooltipUndo => 'Rückgängig';

  @override
  String get annotateTooltipRedo => 'Wiederholen';

  @override
  String get annotateTooltipSave => 'Speichern';

  @override
  String get annotateCopiedToClipboard => 'In Zwischenablage kopiert';

  @override
  String get annotateToolbarPen => 'Stift';

  @override
  String get annotatePenTipBanner =>
      'Mit einem Finger zeichnen. Mit zwei Fingern verschieben und zoomen.';

  @override
  String get annotatePenSheetTitle => 'Stifteinstellungen';

  @override
  String get annotatePenStrokeWidth => 'Strichstärke';

  @override
  String get annotatePenEraserMode => 'Radierer';

  @override
  String get annotateColorBlack => 'Schwarz';

  @override
  String get annotateColorRed => 'Rot';

  @override
  String get annotateColorPurple => 'Violett';

  @override
  String get annotateColorBlue => 'Blau';

  @override
  String get toolSignPdf => 'PDF signieren';

  @override
  String get toolSignPdfSubtitle =>
      'Unterschrift und Datum zu Dokumenten hinzufügen';

  @override
  String get signToolbarSign => 'Unterschrift';

  @override
  String get signToolbarDate => 'Datum';

  @override
  String get signToolbarClearAll => 'Alle entfernen';

  @override
  String get signPadTitle => 'Unterschrift zeichnen';

  @override
  String get signPadClear => 'Löschen';

  @override
  String get signPadSave => 'Unterschrift speichern';

  @override
  String get signSheetTitle => 'Gespeicherte Unterschriften';

  @override
  String get signSheetCreateNew => 'Neue Unterschrift erstellen';

  @override
  String get signMaxSignaturesReached =>
      'Maximal 5 gespeicherte Unterschriften erreicht';

  @override
  String get signMaxPlacedReached =>
      'Maximal 20 Unterschriften pro Dokument erreicht';

  @override
  String get signDeleteSignatureTitle => 'Unterschrift löschen?';

  @override
  String get signDeleteSignatureBody =>
      'Diese Unterschrift wird aus deinen gespeicherten Unterschriften entfernt.';

  @override
  String get signConfirmClearAllTitle => 'Alle Unterschriften entfernen?';

  @override
  String get signConfirmClearAllBody =>
      'Alle platzierten Unterschriften und Daten in diesem Dokument werden entfernt.';

  @override
  String get signSaveSuccess => 'Dokument erfolgreich signiert';

  @override
  String get signNoSignaturesToSave =>
      'Keine Unterschriften im Dokument platziert';

  @override
  String get signPlacedSignatureDelete => 'Löschen';

  @override
  String get signPlacedSignatureApply => 'Anwenden';

  @override
  String get signTooltipUndo => 'Rückgängig';

  @override
  String get signTooltipRedo => 'Wiederholen';

  @override
  String get signTooltipSave => 'Speichern';

  @override
  String annotatePenStrokeWidthValue(String width) {
    return '$width pt';
  }

  @override
  String get annotateErrorTooManyStrokes =>
      'Das Dokument hat das Maximum von 5.000 Strichen oder 300.000 Punkten erreicht.';

  @override
  String annotateChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Änderungen',
      one: '1 Änderung',
    );
    return '$_temp0';
  }

  @override
  String get annotatePenNotice =>
      'Stiftstriche werden beim Speichern Teil der Seite und können später nicht mehr bearbeitet werden.';

  @override
  String get annotatePenNoticeDismiss => 'Verstanden';

  @override
  String get signPadBaselineHint => 'Hier unterschreiben';

  @override
  String get signPadUndo => 'Rückgängig';

  @override
  String get signPadUseOnce => 'Einmalig verwenden';

  @override
  String get signPadSaveAndUse => 'Speichern und verwenden';

  @override
  String get tool_add_text => 'Text hinzufügen';

  @override
  String get tool_add_text_desc => 'Textfelder und Notizen auf Seiten einfügen';

  @override
  String get addTextNoticePermanent =>
      'Hinzugefügter Text wird Teil der Seite und kann nach dem Speichern nicht mehr bearbeitet werden.';

  @override
  String get addTextNoticeRaster =>
      'Text in dieser Sprache wird als Bild hinzugefügt und kann nicht ausgewählt werden.';

  @override
  String get addTextNoticeGotIt => 'Verstanden';

  @override
  String get addTextActionAdd => 'Text hinzufügen';

  @override
  String get addTextActionStyle => 'Stil';

  @override
  String get addTextActionDelete => 'Löschen';

  @override
  String get addTextStyleSheetTitle => 'Textstil';

  @override
  String get addTextFontSize => 'Schriftgröße';

  @override
  String get addTextColor => 'Farbe';

  @override
  String get addTextStyle => 'Stil';

  @override
  String get addTextAlign => 'Ausrichtung';

  @override
  String get addTextBold => 'Fett';

  @override
  String get addTextItalic => 'Kursiv';

  @override
  String get addTextAlignStart => 'Links';

  @override
  String get addTextAlignCenter => 'Zentriert';

  @override
  String get addTextAlignEnd => 'Rechts';

  @override
  String get addTextErrorTooManyBoxes => 'Maximal 30 Textfelder erreicht';

  @override
  String get addTextErrorBoxTooLong =>
      'Ein Textfeld darf höchstens 2.000 Zeichen enthalten';

  @override
  String get addTextPlaceholder => 'Text hier eingeben';

  @override
  String get addTextSamplePreview => 'Beispielvorschau';

  @override
  String addTextFontSizePt(int size) {
    return '$size pt';
  }

  @override
  String get premiumTitle => 'Doc View Premium';

  @override
  String get premiumSubtitle =>
      'Schalte Anmerken- & Signier-Tools frei und nutze die App völlig werbefrei.';

  @override
  String get premiumFeatureAllTools => 'PDF-Tools zum Anmerken & Signieren';

  @override
  String get premiumFeatureAllToolsSub =>
      'Markierungen zeichnen, Dokumente hervorheben und PDFs mühelos signieren';

  @override
  String get premiumFeatureAdFree => '100 % werbefreies Erlebnis';

  @override
  String get premiumFeatureAdFreeSub =>
      'Keine Banner, Unterbrechungen oder Ablenkungen';

  @override
  String get premiumFeatureUnlimitedConversions =>
      'Unbegrenzte lokale Umwandlungen';

  @override
  String get premiumFeatureUnlimitedConversionsSub =>
      'Dokumente direkt auf dem Gerät ohne Dateilimits umwandeln';

  @override
  String get premiumFeaturePrivacyFirst => '100 % privat & lokal auf dem Gerät';

  @override
  String get premiumFeaturePrivacyFirstSub =>
      'Dateien werden lokal verarbeitet und niemals auf einen Server hochgeladen';

  @override
  String get premiumPlanYearly => 'Jahresabonnement';

  @override
  String premiumPlanYearlyTrial(int days, String price) {
    return '$days Tage kostenlos, danach $price/Jahr';
  }

  @override
  String get premiumPlanMonthly => 'Monatsabonnement';

  @override
  String premiumPlanMonthlySub(String price) {
    return '$price/Monat';
  }

  @override
  String premiumPlanYearlySub(String price) {
    return '$price/Jahr';
  }

  @override
  String premiumPlanMonthlyTrial(int days, String price) {
    return '$days Tage kostenlos, danach $price/Monat';
  }

  @override
  String premiumSavePercent(int percent) {
    return '$percent % sparen';
  }

  @override
  String get premiumSaveUnknown => '- % sparen';

  @override
  String premiumActionStartTrial(int days) {
    return '$days-tägige Gratis-Testversion starten';
  }

  @override
  String get premiumSubscriptionsAvailableSoon =>
      'Abonnements sind in Kürze verfügbar.';

  @override
  String get premiumLoadPlansFailed => 'Could not load plans. Tap to retry';

  @override
  String errorCodeLabel(String code) {
    return 'Error code: $code';
  }

  @override
  String get pagesEditPagesAction => 'Seiten bearbeiten';

  @override
  String get premiumCancelAnytime => 'Jederzeit kündbar';

  @override
  String get premiumPendingStatus =>
      'Dein Kauf wird von Google Play verarbeitet. Die Vorteile werden nach Bestätigung aktiviert.';

  @override
  String get premiumRenewalDisclosurePricingUnavailable =>
      'Verlängert sich automatisch. Der Preis wird beim Bezahlen durch Google Play bestätigt. Jederzeit in den Google Play-Abos kündbar.';

  @override
  String get premiumActionSubscribe => 'Abonnieren';

  @override
  String get premiumActionRestore => 'Käufe wiederherstellen';

  @override
  String get premiumBillingDisclaimer =>
      'Verlängert sich automatisch. Jederzeit in den Google Play-Abos kündbar.';

  @override
  String get premiumTerms => 'Nutzungsbedingungen';

  @override
  String get premiumPrivacy => 'Datenschutzerklärung';

  @override
  String get premiumActiveStatus => 'Du bist Premium-Abonnent';

  @override
  String get premiumGraceStatus => 'Offline-Kulanzzeitraum aktiv';

  @override
  String get premiumExpiredStatus => 'Abonnement abgelaufen';

  @override
  String get premiumRestoreSuccess => 'Käufe erfolgreich wiederhergestellt.';

  @override
  String get premiumRestoreNone => 'Keine aktiven Abonnements gefunden.';

  @override
  String get premiumErrorGeneral =>
      'Kauf konnte nicht abgeschlossen werden. Bitte versuche es erneut.';

  @override
  String get premiumPagesGateTitle => 'Doc View Premium';

  @override
  String get premiumPagesGateBody =>
      'Für das Neuordnen, Drehen und Löschen von Seiten ist ein Premium-Abonnement erforderlich.';

  @override
  String get premiumPagesGateUpgrade => 'Auf Premium upgraden';

  @override
  String get premiumTooltip => 'Doc View Premium';

  @override
  String get premiumManageInPlay => 'Verwalten';

  @override
  String get faqQuestion8 => 'Was ist in Doc View Premium enthalten?';

  @override
  String get faqAnswer8 =>
      'Doc View Premium schaltet alle erweiterten Bearbeitungstools frei – darunter das Neuordnen, Drehen und Löschen von PDF-Seiten, die Umwandlung von PDF in Word, Anmerkungen, Unterschriften und benutzerdefiniertes Text-Einfügen – und entfernt sämtliche Werbung in der gesamten App. Die gesamte Dokumentverarbeitung erfolgt weiterhin zu 100 % auf deinem Gerät.';

  @override
  String get faqQuestion9 =>
      'Kann ich Doc View Premium ohne Internetverbindung nutzen?';

  @override
  String get faqAnswer9 =>
      'Ja. Nach der Aktivierung speichert Doc View deinen Abo-Status sicher auf deinem Gerät mit einem Offline-Kulanzzeitraum von bis zu 7 aufeinanderfolgenden Tagen. Während dieser Zeit kannst du alle Bearbeitungstools weiterhin offline nutzen.';

  @override
  String get galleryDebugIapSectionTitle => '15. IAP- & Premium-Simulator (G7)';

  @override
  String get galleryDebugIapStateFree => 'Auf Kostenlos setzen';

  @override
  String get galleryDebugIapStateYearly => 'Auf Jahres-Premium setzen';

  @override
  String get galleryDebugIapStateMonthly => 'Auf Monats-Premium setzen';

  @override
  String get galleryDebugIapStateGrace => 'Offline-Kulanz setzen (Aktiv)';

  @override
  String get galleryDebugIapStateGraceExpired =>
      'Offline-Kulanz setzen (Abgelaufen)';

  @override
  String get galleryDebugOpenPremium => '/premium-Bildschirm öffnen';

  @override
  String get galleryDebugIapProductSeenTrue => 'Produkt gesehen setzen: Wahr';

  @override
  String get galleryDebugIapProductSeenFalse =>
      'Produkt gesehen setzen: Falsch';

  @override
  String get addWidgetSheetTitle => 'Zum Startbildschirm hinzufügen';

  @override
  String get addWidgetSheetSubtitle =>
      'Wähle ein Widget für deinen Startbildschirm aus';

  @override
  String get widgetRecentFilesTitle => 'Zuletzt geöffnete Dateien';

  @override
  String get widgetRecentFilesBadge => '4 × 2';

  @override
  String get widgetRecentFilesDesc =>
      'Zuletzt verwendete Dateien direkt vom Startbildschirm aus ansehen und öffnen';

  @override
  String get widgetQuickToolsTitle => 'Schnell-Tools';

  @override
  String get widgetQuickToolsBadge => '4 × 1';

  @override
  String get widgetQuickToolsDesc =>
      'Direkt zu Scannen, Bild in PDF, Suche oder Import springen';

  @override
  String get addWidgetButton => 'Widget hinzufügen';

  @override
  String get addWidgetManualTitle => 'Widget manuell hinzufügen';

  @override
  String get addWidgetManualMessage =>
      'Tippe und halte eine freie Stelle auf deinem Startbildschirm, tippe auf „Widgets“, suche nach Doc View und ziehe es auf den Bildschirm.';

  @override
  String get settingsQuickAccessNotificationTitle =>
      'Schnellzugriff-Benachrichtigung';

  @override
  String get settingsQuickAccessNotificationSubtitle =>
      'Schnell-Tools in der Benachrichtigungsleiste anzeigen';

  @override
  String get notificationPermissionDialogTitle => 'Benachrichtigungen erlauben';

  @override
  String get notificationPermissionDialogDesc =>
      'Doc View benötigt die Berechtigung für Benachrichtigungen, um die Schnellzugriffsleiste in deiner Benachrichtigungsleiste anzuzeigen.';

  @override
  String get notificationTitle => 'Doc View Schnell-Tools';

  @override
  String get notificationBody => 'Dokumente scannen, umwandeln oder suchen';

  @override
  String get notificationActionScan => 'Scannen';

  @override
  String get notificationActionImageToPdf => 'Bild in PDF';

  @override
  String get notificationActionSearch => 'Suchen';

  @override
  String get settingsAdChoicesTitle => 'Werbeeinstellungen';

  @override
  String get settingsAdChoicesSubtitle =>
      'Datenschutz- und Werbeeinstellungen verwalten';

  @override
  String get faqQuestion10 => 'Warum zeigt Doc View Werbung an?';

  @override
  String get faqAnswer10 =>
      'Durch Werbung bleibt Doc View kostenlos. Mit Premium wird sie entfernt. Anzeigen werden über Google AdMob bereitgestellt und erhalten niemals Zugriff auf deine Dokumente.';
}
