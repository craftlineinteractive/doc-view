// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Doc View';

  @override
  String get navHome => 'Tous les fichiers';

  @override
  String get navTools => 'Outils';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get noDocumentSelected => 'Aucun document sélectionné';

  @override
  String get tooltipCloseAd => 'Fermer l\'annonce';

  @override
  String get tooltipClose => 'Fermer';

  @override
  String get tooltipRescan => 'Analyser à nouveau les documents';

  @override
  String get tooltipSearch => 'Rechercher des documents';

  @override
  String get tooltipSelectFiles => 'Sélectionner des fichiers';

  @override
  String get tooltipBack => 'Retour';

  @override
  String get tooltipCancelSelection => 'Annuler la sélection';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélectionnés',
      one: '1 sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'Tout sélectionner';

  @override
  String get actionDeselectAll => 'Tout désélectionner';

  @override
  String get tooltipDeleteSelected => 'Supprimer la sélection';

  @override
  String get tooltipClearSearch => 'Effacer la recherche';

  @override
  String get searchHint => 'Rechercher des documents, dossiers...';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return 'Page $page sur $total';
  }

  @override
  String get errorGenericTitle => 'Une erreur est survenue';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get permissionAllFilesTitle => 'Accès à tous les fichiers requis';

  @override
  String get permissionAllFilesExplanation =>
      'Doc View a besoin de l\'accès à tous les fichiers pour parcourir les dossiers et organiser vos documents entièrement hors ligne.';

  @override
  String get actionGrantAccess => 'Autoriser l\'accès';

  @override
  String get actionImportFilesInstead => 'Importer des fichiers à la place';

  @override
  String get tooltipRemoveBookmark => 'Retirer des favoris';

  @override
  String get tooltipAddBookmark => 'Ajouter aux favoris';

  @override
  String tooltipFileOptions(String title) {
    return 'Options du fichier pour $title';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return 'Dossier, $name$subtitle';
  }

  @override
  String get adAdvertisementBadge => 'PUBLICITÉ';

  @override
  String get actionConfirm => 'Confirmer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get tabRecent => 'Récents';

  @override
  String get tabBookmarks => 'Favoris';

  @override
  String get filterCategoryAll => 'Tous';

  @override
  String get actionBrowse => 'Parcourir';

  @override
  String get actionCancelOperation => 'Annuler l\'opération';

  @override
  String get operationComplete => 'Opération terminée';

  @override
  String get actionOpenDocument => 'Ouvrir le document';

  @override
  String get actionShareDocument => 'Partager le document';

  @override
  String get splashTagline => 'Tous vos documents, au même endroit.';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get actionSkip => 'Ignorer';

  @override
  String get actionBack => 'Retour';

  @override
  String get actionNext => 'Suivant';

  @override
  String get actionGetStarted => 'Commencer';

  @override
  String get onboardingPage1Title => 'Tous vos documents,\nau même endroit';

  @override
  String get onboardingPage1Desc =>
      'Doc View détecte automatiquement les PDF, fichiers Word, Excel, PowerPoint, fichiers texte et images sur votre téléphone et les organise pour vous.';

  @override
  String get onboardingPage2Title => 'Lisez tout,\nen toute simplicité';

  @override
  String get onboardingPage2Desc =>
      'Ouvrez vos fichiers PDF, Word, Excel et PowerPoint avec un lecteur rapide et épuré. Recherchez, ajoutez aux favoris et reprenez là où vous vous êtes arrêté.';

  @override
  String get onboardingPage3Title => 'Outils PDF puissants, hors ligne';

  @override
  String get onboardingPage3Desc =>
      'Transformez des photos en PDF, numérisez des documents, fusionnez et divisez des fichiers. Tout reste sur votre appareil.';

  @override
  String get onboardingOfflineGuarantee =>
      'Vos fichiers restent sur votre appareil';

  @override
  String get toolImageToPdf => 'Image en PDF';

  @override
  String get toolImageToPdfSub => 'Convertir JPG et PNG';

  @override
  String get toolScanToPdf => 'Numériser en PDF';

  @override
  String get toolScanToPdfSub => 'Détection des bords par caméra';

  @override
  String get toolMergePdf => 'Fusionner des PDF';

  @override
  String get toolMergePdfSub => 'Combiner en un seul';

  @override
  String get toolSplitPdf => 'Diviser un PDF';

  @override
  String get toolSplitPdfSub => 'Extraire n\'importe quelle plage';

  @override
  String get permissionTagStorage => 'Accès au stockage de l\'appareil';

  @override
  String get permissionStorageHeadline =>
      'Laissez Doc View trouver vos documents';

  @override
  String get permissionStorageBody =>
      'Pour lister les PDF, fichiers Word, Excel et autres fichiers enregistrés par n\'importe quelle application, Android a besoin de votre autorisation pour accéder à tous les fichiers. Vos fichiers ne quittent jamais votre téléphone.';

  @override
  String get permissionReassuranceOfflineTitle =>
      'Les fichiers ne sont jamais envoyés';

  @override
  String get permissionReassuranceOfflineDesc =>
      'Vos documents sont traités localement sur votre appareil.';

  @override
  String get permissionReassuranceNoUploadsTitle => 'Aucun envoi en ligne';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      'Aucun serveur cloud. Vos fichiers restent strictement dans la mémoire du téléphone.';

  @override
  String get permissionReassuranceChangeTitle =>
      'Vous pouvez modifier ce choix à tout moment';

  @override
  String get permissionReassuranceChangeDesc =>
      'Modifiez facilement l\'autorisation dans les paramètres système de l\'application Android.';

  @override
  String get permissionTagIOS => 'Guide de stockage iOS';

  @override
  String get permissionIOSHeadline => 'Importez vos documents dans Doc View';

  @override
  String get permissionIOSBody =>
      'En raison de l\'architecture de confidentialité d\'Apple, iOS ne permet à aucune application d\'analyser automatiquement l\'ensemble de votre téléphone. Choisissez comment lire vos fichiers :';

  @override
  String get permissionIOSOptionImportTitle => 'Importer des fichiers';

  @override
  String get permissionIOSBadgeFastest => 'LE PLUS RAPIDE';

  @override
  String get permissionIOSOptionImportDesc =>
      'Sélectionnez des documents directement depuis iCloud Drive, Téléchargements ou n\'importe quel dossier en quelques secondes.';

  @override
  String get permissionIOSOptionFolderTitle =>
      'Ouvrir le dossier Doc View dans l\'app Fichiers';

  @override
  String get permissionIOSOptionFolderDesc =>
      'Enregistrez ou envoyez par AirDrop vos documents directement dans le dossier « Doc View » de l\'app Fichiers d\'iOS pour une synchronisation instantanée.';

  @override
  String get actionImportFiles => 'Importer des fichiers';

  @override
  String get actionContinueToApp => 'Continuer vers l\'application';

  @override
  String get permissionTagConsent => 'Transparence et consentement';

  @override
  String get permissionBadgeFree => 'Application 100 % gratuite';

  @override
  String get permissionBadgeMinimalAds => 'Publicités minimales';

  @override
  String get permissionConsentHeadline => 'Gratuit avec publicités';

  @override
  String get permissionConsentBody =>
      'Doc View est gratuit grâce à la publicité. Nous allons ensuite vous demander votre choix concernant les annonces personnalisées.';

  @override
  String get permissionConsentAdsTitle => 'Quelles annonces pouvez-vous voir';

  @override
  String get permissionConsentAdsDesc =>
      'De petites bannières et des cartes sponsorisées discrètes. Aucune fenêtre contextuelle ni coupure vidéo pendant la lecture.';

  @override
  String get permissionConsentPrivateTitle =>
      'Vos documents restent totalement privés';

  @override
  String get permissionConsentPrivateDesc =>
      'Les partenaires publicitaires n\'ont jamais accès aux noms de vos documents, à leur contenu ou à leur emplacement.';

  @override
  String get permissionConsentSettingsTitle =>
      'Modifiez votre choix dans les Paramètres';

  @override
  String get permissionConsentSettingsDesc =>
      'Mettez à jour votre consentement aux annonces personnalisées ou vos préférences de confidentialité à tout moment dans les Paramètres de Doc View.';

  @override
  String get actionContinue => 'Continuer';

  @override
  String get actionPrivacyPolicy => 'Politique de confidentialité';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers importés',
      one: '1 fichier importé',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => 'Échec de l\'importation des fichiers';

  @override
  String get tooltipImportDocuments => 'Importer des documents';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers trouvés',
      one: '1 fichier trouvé',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => 'Analyse en cours...';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers',
      one: '1 fichier',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => 'Dossiers';

  @override
  String get errorLoadingRecent =>
      'Erreur lors du chargement des fichiers récents';

  @override
  String get emptyStateTitle => 'Vide';

  @override
  String get emptyRecentDescription =>
      'Les fichiers récemment ouverts apparaîtront ici';

  @override
  String get errorLoadingBookmarks => 'Erreur lors du chargement des favoris';

  @override
  String get emptyBookmarksDescription =>
      'Les documents ajoutés aux favoris apparaîtront ici';

  @override
  String get dialogDeleteTitle => 'Supprimer les fichiers sélectionnés ?';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Supprimer $count fichiers ? Cette action est irréversible.',
      one: 'Supprimer 1 fichier ? Cette action est irréversible.',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers supprimés',
      one: '1 fichier supprimé',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => 'Échec de la suppression des fichiers';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get searchRecentSearchesHeader => 'RECHERCHES RÉCENTES';

  @override
  String get actionClear => 'Effacer';

  @override
  String get searchPromptTitle => 'Saisissez du texte pour rechercher';

  @override
  String get searchPromptMessage =>
      'Recherchez dans tous les dossiers locaux par nom de fichier ou extension';

  @override
  String get searchError => 'Erreur lors de la recherche de documents';

  @override
  String get searchNoResultsTitle => 'Aucun document correspondant trouvé';

  @override
  String get searchNoResultsMessage =>
      'Essayez un autre mot-clé de nom de fichier ou un autre filtre de format';

  @override
  String get tooltipSortOptions => 'Options de tri';

  @override
  String get sortSheetTitle => 'Trier par';

  @override
  String get sortOptionDate => 'Date de modification';

  @override
  String get sortOptionName => 'Nom du document';

  @override
  String get sortOptionSize => 'Taille du fichier';

  @override
  String get sortAscendingOrder => 'Ordre croissant';

  @override
  String get sortAscendingSubtitle => 'Plus ancien / A à Z / Plus petit';

  @override
  String get sortDescendingSubtitle => 'Plus récent / Z à A / Plus grand';

  @override
  String get categoryAllFiles => 'Tous les fichiers';

  @override
  String get loadingStatus => 'Chargement...';

  @override
  String get emptyCategoryImagesTitle => 'Aucune image trouvée';

  @override
  String get emptyCategoryImagesMessage =>
      'Les images trouvées sur cet appareil apparaîtront ici';

  @override
  String get emptyCategoryDocsTitle => 'Aucun document trouvé';

  @override
  String get emptyCategoryDocsMessage =>
      'Les documents de ce format apparaîtront ici après l\'analyse';

  @override
  String get actionOpen => 'Ouvrir';

  @override
  String get actionShare => 'Partager';

  @override
  String get actionRename => 'Renommer';

  @override
  String get actionBookmark => 'Ajouter aux favoris';

  @override
  String get actionRemoveBookmark => 'Retirer des favoris';

  @override
  String get actionOpenInAnotherApp => 'Ouvrir dans une autre application';

  @override
  String get actionDetails => 'Détails';

  @override
  String get actionOpenFile => 'Ouvrir le fichier';

  @override
  String get actionShareAll => 'Tout partager';

  @override
  String get actionDone => 'Terminé';

  @override
  String get actionSeeAll => 'Tout voir';

  @override
  String get actionAllow => 'Autoriser';

  @override
  String get actionNotNow => 'Pas maintenant';

  @override
  String get tooltipMoreActions => 'Plus d\'actions';

  @override
  String get tooltipCopyPath => 'Copier le chemin';

  @override
  String get tooltipRotatePage => 'Pivoter la page';

  @override
  String get tooltipRemovePage => 'Supprimer la page';

  @override
  String get renameFileTitle => 'Renommer le fichier';

  @override
  String get renameFileNameLabel => 'Nom du fichier';

  @override
  String renamedSuccess(String fileName) {
    return 'Renommé en $fileName';
  }

  @override
  String get deleteFileTitle => 'Supprimer le fichier ?';

  @override
  String deleteFileConfirmation(String fileName) {
    return 'Supprimer « $fileName » ? Cette action est irréversible.';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return '« $fileName » supprimé';
  }

  @override
  String get fileDetailsTitle => 'Détails du document';

  @override
  String get fileDetailsLabelName => 'Nom';

  @override
  String get fileDetailsLabelType => 'Type';

  @override
  String get fileDetailsLabelSize => 'Taille';

  @override
  String get fileDetailsLabelModified => 'Modifié le';

  @override
  String get fileDetailsLabelBookmarked => 'En favori';

  @override
  String get fileDetailsValueYes => 'Oui';

  @override
  String get fileDetailsValueNo => 'Non';

  @override
  String get fileDetailsLabelLocation => 'Emplacement';

  @override
  String get fileDetailsPathCopied => 'Chemin copié dans le presse-papiers';

  @override
  String get directoriesTitle => 'Répertoires';

  @override
  String get directoriesGoBack => 'Revenir en arrière';

  @override
  String get directoriesGoToRoot => 'Aller à la racine';

  @override
  String get directoriesRetry => 'Réessayer';

  @override
  String get directoriesFileNoLongerExists => 'Le fichier n\'existe plus';

  @override
  String get directoriesFolderNoLongerExists => 'Ce dossier n\'existe plus.';

  @override
  String get directoriesNoDocsInFolder => 'Aucun document dans ce dossier';

  @override
  String get directoriesFilesAppearHere =>
      'Les fichiers apparaîtront ici une fois ajoutés';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '1 élément',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => 'Dossier';

  @override
  String get directoriesPermissionPromptTitle =>
      'Accès requis pour afficher les répertoires';

  @override
  String get directoriesPermissionPromptBody =>
      'Doc View a besoin de l\'accès à tous les fichiers pour parcourir vos dossiers.';

  @override
  String get directoriesGrantAccess => 'Autoriser l\'accès';

  @override
  String get directoriesImportInstead => 'Importer des fichiers à la place';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers importés',
      one: '1 fichier importé',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => 'Dossier parent';

  @override
  String get storageAccessRequiredTitle => 'Accès au stockage requis';

  @override
  String get storageAccessRequiredBody =>
      'Doc View a besoin d\'accéder au stockage pour analyser et afficher les documents (PDF, Word, Excel, PPT, TXT, Images) enregistrés sur votre appareil.\n\nVos fichiers restent entièrement privés et hors ligne sur votre appareil.';

  @override
  String errorCouldNotOpenDocument(String error) {
    return 'Impossible d\'ouvrir le document : $error';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Analyse terminée : $count fichiers',
      one: 'Analyse terminée : 1 fichier',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => 'Effacer l\'historique de recherche ?';

  @override
  String get dialogClearSearchMessage =>
      'Toutes les recherches récentes seront définitivement effacées.';

  @override
  String imageListEditorMaxLimit(int max) {
    return 'Limite maximale de $max images atteinte.';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return 'Échec de la numérisation : $error';
  }

  @override
  String get imageListEditorPageSize => 'Format de page :';

  @override
  String get imageListEditorA4Mode => 'A4';

  @override
  String get imageListEditorFitMode => 'Ajuster à l\'image';

  @override
  String get imageListEditorRemoveImageTooltip => 'Retirer l\'image';

  @override
  String get mergeScreenTitle => 'Organiser et fusionner';

  @override
  String get mergeScreenDefaultMergedName => 'Document_fusionné';

  @override
  String get mergePickerSearchHint => 'Rechercher des PDF...';

  @override
  String get mergePickerNext => 'Suivant';

  @override
  String mergePickerErrorLoading(String error) {
    return 'Erreur lors du chargement des PDF : $error';
  }

  @override
  String get splitScreenTitle => 'Diviser un PDF';

  @override
  String get splitScreenRangeHint => 'ex. 1-3, 5, 8-10';

  @override
  String get splitScreenClearRange => 'Effacer la plage';

  @override
  String get splitPickerSearchHint => 'Rechercher des PDF...';

  @override
  String splitPickerErrorLoading(String error) {
    return 'Erreur lors du chargement des fichiers : $error';
  }

  @override
  String get createdSectionTitle => 'Créés par vous';

  @override
  String get createdSectionEmptyTitle =>
      'Les PDF que vous créez apparaissent ici';

  @override
  String get createdSectionEmptySubtitle =>
      'Les documents convertis, numérisés ou fusionnés sont enregistrés localement.';

  @override
  String get emptyCreatedDocsTitle => 'Aucun document créé pour le moment';

  @override
  String get emptyCreatedDocsMessage =>
      'Les documents convertis, numérisés ou fusionnés apparaîtront ici.';

  @override
  String errorLoadingCreatedFiles(String error) {
    return 'Échec du chargement des fichiers créés : $error';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDF créés',
      one: 'PDF créé',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle => 'Enregistré dans votre dossier Créés';

  @override
  String get toolErrorDefaultTitle => 'Impossible de créer le PDF';

  @override
  String get toolErrorSubtitle =>
      'Une erreur inattendue s\'est produite pendant le traitement';

  @override
  String get themeSheetTitle => 'Thème de l\'application';

  @override
  String get themeSheetSubtitle =>
      'Sélectionnez l\'apparence visuelle de Doc View';

  @override
  String get themeModeSystem => 'Système';

  @override
  String get themeModeSystemSubtitle => 'par défaut';

  @override
  String get themeModeLight => 'Clair';

  @override
  String get themeModeLightSubtitle => 'Blanc épuré';

  @override
  String get themeModeDark => 'Sombre';

  @override
  String get themeModeDarkSubtitle => 'Bleu nuit profond';

  @override
  String get themeActionApply => 'Appliquer le thème';

  @override
  String get scanSettingsTitle => 'Paramètres d\'analyse';

  @override
  String get scanSettingsFrequencyHeader => 'Fréquence d\'analyse';

  @override
  String get scanSettingsOnOpenTitle => 'Analyser à l\'ouverture';

  @override
  String get scanSettingsOnOpenSubtitle =>
      'Rechercher automatiquement les nouveaux fichiers lorsque vous ouvrez Doc View.';

  @override
  String get scanSettingsManualTitle => 'Manuel uniquement';

  @override
  String get scanSettingsManualSubtitle =>
      'Analyser uniquement lorsque vous tirez pour actualiser ou appuyez sur Réanalyser.';

  @override
  String get scanSettingsMediaFiltersHeader => 'Filtres multimédias';

  @override
  String get scanSettingsIncludeImagesTitle =>
      'Inclure les images dans l\'analyse';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      'Indexer les fichiers image PNG, JPG et WEBP du stockage.';

  @override
  String get scanSettingsDiagnosticsHeader => 'Stockage et diagnostics';

  @override
  String get scanSettingsPermissionStatus => 'Accès à tous les fichiers';

  @override
  String get scanSettingsPermissionGranted => 'Accordé';

  @override
  String get scanSettingsPermissionNotGranted => 'Non accordé';

  @override
  String get scanSettingsTotalIndexed => 'Fichiers indexés';

  @override
  String get scanSettingsLastScan => 'Dernière analyse';

  @override
  String get scanSettingsUpdatedSnackbar => 'Paramètres d\'analyse mis à jour';

  @override
  String get faqScreenTitle => 'Foire aux questions';

  @override
  String faqHeaderTopics(int count) {
    return '$count sujets';
  }

  @override
  String get faqHeaderSubtitle =>
      'Des questions ? Trouvez des réponses claires ici.';

  @override
  String get faqSendFeedback => 'Envoyer un commentaire';

  @override
  String get faqQuestion1 =>
      'Pourquoi Doc View a-t-il besoin de l\'accès à tous les fichiers ?';

  @override
  String get faqAnswer1 =>
      'Doc View nécessite l\'accès à tous les fichiers (MANAGE_EXTERNAL_STORAGE) sous Android 11+ pour détecter et indexer les documents pris en charge (PDF, Word, Excel, PowerPoint, texte et images) stockés dans des dossiers partagés tels que Téléchargements et Documents.\n\nSans cette autorisation, Android limite l\'accès aux fichiers au dossier interne privé de l\'application, ce qui empêche Doc View de parcourir ou d\'ouvrir les fichiers présents sur votre appareil.';

  @override
  String get faqQuestion2 =>
      'Pourquoi l\'application n\'analyse-t-elle pas tout mon iPhone ?';

  @override
  String get faqAnswer2 =>
      'iOS utilise un cloisonnement strict des applications pour protéger votre vie privée. Les applications ne peuvent accéder qu\'aux documents explicitement enregistrés dans l\'app Fichiers ou partagés via la feuille de partage du système.\n\nPour afficher des fichiers sur iOS, importez-les dans le dossier Doc View de l\'app Fichiers native ou utilisez l\'option Importer des fichiers dans les Paramètres.';

  @override
  String get faqQuestion3 => 'Où sont enregistrés les PDF que je crée ?';

  @override
  String get faqAnswer3 =>
      'Les fichiers que vous importez ou générez (tels que les PDF convertis, les documents fusionnés ou les pages extraites) sont enregistrés en toute sécurité dans le stockage de votre appareil sous DocView/Created ou dans le stockage privé de l\'application. Vous pouvez les consulter à tout moment dans la section Créés par vous de l\'onglet Outils.';

  @override
  String get faqQuestion4 =>
      'Pourquoi mon fichier Word s\'affiche-t-il différemment ?';

  @override
  String get faqAnswer4 =>
      'Doc View affiche les fichiers directement sur votre appareil à l\'aide d\'analyseurs locaux hors ligne sans envoyer vos données privées vers des convertisseurs cloud. Les mises en forme complexes ou les formes personnalisées utilisent des approximations natives hors ligne.';

  @override
  String get faqQuestion5 =>
      'Puis-je ouvrir des fichiers protégés par mot de passe ?';

  @override
  String get faqAnswer5 =>
      'Oui, Doc View prend en charge l\'ouverture des documents PDF protégés par mot de passe. Lors de l\'ouverture d\'un PDF chiffré, saisissez le mot de passe dans la boîte de dialogue pour le déchiffrer et l\'afficher sur votre appareil.';

  @override
  String get faqQuestion6 => 'Mes données sont-elles envoyées quelque part ?';

  @override
  String get faqAnswer6 =>
      'Vos documents ne quittent jamais votre appareil. Doc View ouvre, convertit et stocke les fichiers localement. L\'application affiche des annonces diffusées par Google AdMob, qui peut utiliser des données limitées sur l\'appareil comme décrit dans notre Politique de confidentialité.';

  @override
  String get faqQuestion7 =>
      'Pourquoi la conversion PDF vers Word a-t-elle modifié ma mise en page ?';

  @override
  String get faqAnswer7 =>
      'Doc View convertit uniquement le texte, directement sur votre appareil. Les tableaux, images, couleurs et la mise en page ne sont pas conservés. Les PDF numérisés ne peuvent pas être convertis car ils ne contiennent pas de texte exploitable.';

  @override
  String get toolPdfToWord => 'PDF vers Word';

  @override
  String get toolPdfToWordSub => 'Convertir un PDF en document Word modifiable';

  @override
  String get pdfToWordScreenTitle => 'PDF vers Word';

  @override
  String get pdfToWordBannerText =>
      'Seul le texte est converti. Les tableaux, images, couleurs et la mise en page ne sont pas conservés.';

  @override
  String get pdfToWordPageBreaks =>
      'Insérer des sauts de page entre les pages PDF';

  @override
  String get pdfToWordPageBreaksSubtitle =>
      'Préserve la structure du document entre les pages';

  @override
  String get pdfToWordSelectPdf => 'Sélectionner un PDF';

  @override
  String get pdfToWordChangeFile => 'Changer de fichier';

  @override
  String get pdfToWordConvertAction => 'Convertir en Word';

  @override
  String get pdfToWordConverting => 'Conversion en Word...';

  @override
  String pdfToWordConvertingProgress(int current, int total) {
    return 'Conversion de la page $current sur $total...';
  }

  @override
  String get pdfToWordSuccess => 'Conversion en Word réussie';

  @override
  String get pdfToWordOpenInViewer => 'Ouvrir dans Doc View';

  @override
  String get pdfToWordOpenWith => 'Ouvrir avec...';

  @override
  String get pdfToWordShare => 'Partager';

  @override
  String get pdfToWordNoTextTitle => 'Aucun texte trouvé';

  @override
  String get pdfToWordNoTextMessage =>
      'Aucun texte trouvé dans ce PDF. Les documents numérisés ne peuvent pas être convertis.';

  @override
  String get pdfToWordLargeFileWarning =>
      'Document volumineux : la conversion peut prendre plusieurs minutes.';

  @override
  String get pdfToWordInvalidFileName => 'Nom de fichier invalide';

  @override
  String get pdfToWordActionCancel => 'Annuler';

  @override
  String get pdfToWordEncryptedError =>
      'Le PDF sélectionné est protégé par mot de passe. Veuillez le déverrouiller pour le convertir.';

  @override
  String get pdfToWordPageLimitError =>
      'Le document dépasse la limite de 1 000 pages.';

  @override
  String get pdfToWordTextLimitError =>
      'Le document dépasse la limite de 20 MB de texte.';

  @override
  String get pdfToWordGeneralError =>
      'Échec de la conversion du PDF en Word. Veuillez essayer un autre fichier.';

  @override
  String get pdfGotoPageTitle => 'Aller à la page';

  @override
  String pdfGotoPageHint(int pageCount) {
    return 'Saisissez une page entre 1 et $pageCount';
  }

  @override
  String get pdfGotoPageAction => 'Aller';

  @override
  String get pdfGotoPageErrorEmpty => 'Saisissez un numéro de page';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return 'Saisissez une page entre 1 et $pageCount';
  }

  @override
  String get pdfPasswordTitle => 'Ce PDF est protégé par mot de passe';

  @override
  String get pdfPasswordSubtitle =>
      'Saisissez le mot de passe pour déchiffrer et afficher le contenu.';

  @override
  String get pdfPasswordHint => 'Saisir le mot de passe';

  @override
  String get pdfPasswordErrorIncorrect => 'Mot de passe incorrect. Réessayez.';

  @override
  String get pdfPasswordActionUnlock => 'Déverrouiller';

  @override
  String get errorFileNameEmpty => 'Le nom du fichier ne peut pas être vide';

  @override
  String get errorFileNameTooLong =>
      'Le nom du fichier ne peut pas dépasser 120 caractères';

  @override
  String get errorFileNameReserved =>
      'Le nom du fichier ne peut pas être « . » ou « .. »';

  @override
  String get errorFileNameStartsWithDot =>
      'Le nom du fichier ne peut pas commencer par un point';

  @override
  String get errorFileNameInvalidChars =>
      'Le nom du fichier contient des caractères non valides';

  @override
  String get errorRenameAlreadyExists =>
      'Un fichier portant ce nom existe déjà dans ce dossier';

  @override
  String get errorRenameSourceNotFound =>
      'Le fichier source n\'existe plus sur le disque';

  @override
  String errorRenameFailed(String details) {
    return 'Échec du renommage du fichier : $details';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      'Fichiers supprimés du disque, mais la mise à jour de la base de données a échoué';

  @override
  String errorDeleteFailed(String details) {
    return 'Échec de la suppression des fichiers : $details';
  }

  @override
  String get errorPageRangeDocNoPages => 'Le document ne contient aucune page';

  @override
  String get errorPageRangeEmpty => 'La plage de pages ne peut pas être vide';

  @override
  String get errorPageRangeEmptySegment =>
      'Segment de plage vide détecté. Supprimez les virgules en trop.';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return 'Format de plage invalide : « $token »';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return 'Plage incomplète : « $token »';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return 'Valeurs non numériques dans la plage : « $token »';
  }

  @override
  String get errorPageRangeBelowMinimum =>
      'Les numéros de page doivent être supérieurs ou égaux à 1';

  @override
  String errorPageRangeReversed(int start, int end) {
    return 'Plage inversée « $start-$end » : le début est supérieur à la fin';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return 'La plage « $token » dépasse le nombre total de pages ($totalPages)';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return 'Numéro de page invalide : « $token »';
  }

  @override
  String get errorImageToPdfNoImages =>
      'Veuillez sélectionner au moins une image';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return 'Maximum $max images autorisées à la fois';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return 'Échec du traitement de l\'image : $path';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return 'Échec de la création du PDF à partir des images : $details';
  }

  @override
  String get errorPdfMergeInsufficient =>
      'Veuillez sélectionner au moins 2 fichiers PDF à fusionner';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return '$fileName est protégé par mot de passe ou endommagé';
  }

  @override
  String get errorPdfMergeNoPages =>
      'Les documents sélectionnés ne contiennent aucune page';

  @override
  String errorPdfMergeFailed(String details) {
    return 'Échec de la fusion des PDF : $details';
  }

  @override
  String get errorPdfSplitNoRanges =>
      'Veuillez spécifier au moins une plage de pages';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return '$fileName est protégé par mot de passe ou endommagé';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return 'La plage $start-$end est hors limites pour $fileName';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return 'Échec de la division du PDF : $details';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return 'P. $current/$total';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '($bytes octets)';
  }

  @override
  String get directoriesProtectedTitle => 'Ce dossier est protégé par Android.';

  @override
  String get directoriesProtectedDesc =>
      'Android restreint l\'accès aux dossiers système et aux dossiers privés des applications.';

  @override
  String get directoriesNotFoundTitle => 'Ce dossier n\'existe plus.';

  @override
  String get directoriesEmpty => 'Aucun fichier ou dossier pris en charge ici.';

  @override
  String get directoriesErrorOpening =>
      'Erreur lors de l\'ouverture du dossier';

  @override
  String get directoriesRoot => 'Racine';

  @override
  String get scanSettingsSectionFrequency => 'Fréquence d\'analyse';

  @override
  String get scanSettingsSectionFilters => 'Filtres de documents';

  @override
  String get scanSettingsIncludeImages => 'Inclure les images';

  @override
  String get scanSettingsIncludeImagesDesc =>
      'Désactivez pour masquer des milliers de photos de votre liste de documents';

  @override
  String get scanSettingsImageListUpdated => 'Liste d\'images mise à jour';

  @override
  String get scanSettingsActionRescanNow => 'Réanalyser maintenant';

  @override
  String get scanSettingsSectionDiagnostics => 'Diagnostics du stockage';

  @override
  String get scanSettingsAllFilesAccessGranted =>
      'Accès à tous les fichiers accordé';

  @override
  String get scanSettingsAllFilesAccessNeeded =>
      'Accès à tous les fichiers requis';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      'Doc View est autorisé à détecter les fichiers dans Téléchargements et sur les cartes SD.';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      'L\'autorisation est requise pour analyser les téléchargements et le stockage externe.';

  @override
  String get scanSettingsActionOpenSettings => 'Ouvrir les paramètres';

  @override
  String scanSettingsScanningFiles(int count) {
    return 'Analyse... $count fichiers trouvés';
  }

  @override
  String get faqStillNeedHelp =>
      'Besoin d\'aide supplémentaire ? Envoyez un commentaire';

  @override
  String get toolsLabelFileName => 'Nom du fichier';

  @override
  String get toolsAddImagesToStart => 'Ajoutez des images pour commencer';

  @override
  String get toolsAddImagesDesc =>
      'Sélectionnez des photos ou numérisez des documents papier pour générer un PDF.';

  @override
  String get toolsChoosePhotos => 'Choisir des photos';

  @override
  String get toolsScanPaper => 'Numériser un document';

  @override
  String toolsPageNumber(int page) {
    return 'Page $page';
  }

  @override
  String get toolsTooltipRotatePage => 'Pivoter la page';

  @override
  String get toolsTooltipRemovePage => 'Supprimer la page';

  @override
  String get toolsAddMoreScans => 'Ajouter d\'autres numérisations';

  @override
  String get toolsAddMoreImages => 'Ajouter d\'autres images';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images · env. ~ $size',
      one: '1 image · env. ~ $size',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return 'Sélectionnez au moins $min fichiers';
  }

  @override
  String toolsPagesTotal(int count) {
    return '$count pages au total';
  }

  @override
  String get toolsPagesTotalLabel => 'pages au total';

  @override
  String get toolsNoPdfsFound => 'Aucun document PDF trouvé';

  @override
  String get semanticBookmarked => 'en favori';

  @override
  String get semanticSelected => 'sélectionné';

  @override
  String get semanticNotSelected => 'non sélectionné';

  @override
  String get actionDeselectFile => 'Désélectionner le fichier';

  @override
  String get actionSelectFile => 'Sélectionner le fichier';

  @override
  String get actionCreatePdf => 'Créer un PDF';

  @override
  String get hintSelectOrViewActions => 'Sélectionner ou afficher les actions';

  @override
  String get actionClose => 'Fermer';

  @override
  String get actionReset => 'Réinitialiser';

  @override
  String get labelPleaseWait => 'Veuillez patienter...';

  @override
  String get tooltipCloseSearch => 'Fermer la recherche';

  @override
  String get semanticAdvertisement => 'Publicité';

  @override
  String get themePreviewLight => 'Clair';

  @override
  String get themePreviewNavy => 'Bleu nuit';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '$name, $size, créé le $date';
  }

  @override
  String get toolsCreatingPdfFromScans =>
      'Création du PDF à partir des numérisations';

  @override
  String get toolsCreatingPdf => 'Création du PDF';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return 'Traitement de l\'image $done sur $total...';
  }

  @override
  String get toolsErrorCreatePdfTitle => 'Impossible de créer le PDF';

  @override
  String get toolsBadgeProtectedOrDamaged => 'Protégé ou endommagé';

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
  String get toolsPagesAbbrev => 'p.';

  @override
  String get mergeAddMoreTitle => 'Ajouter d\'autres PDF';

  @override
  String get mergeProgressTitle => 'Fusion des PDF';

  @override
  String mergeProgressMessage(int done, int total) {
    return 'Fusion du document $done sur $total...';
  }

  @override
  String get mergeErrorTitle => 'Impossible de fusionner les PDF';

  @override
  String get mergeDragInstruction =>
      'Faites glisser les poignées pour réorganiser';

  @override
  String get mergeAddPdf => 'Ajouter un PDF';

  @override
  String get mergeOutputFileNameLabel => 'NOM DU FICHIER DE SORTIE';

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
    return 'Chargement des pages... · $size';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers invalides détectés',
      one: '1 fichier invalide détecté',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => 'Prêt à fusionner';

  @override
  String get mergeRemoveProtectedHint =>
      'Veuillez retirer les documents protégés par mot de passe';

  @override
  String mergeSummary(int files, int pages, String size) {
    return '$files fichiers · $pages pages · ~ $size';
  }

  @override
  String get mergeReadyBadge => 'Prêt';

  @override
  String get mergeBlockedCta => 'Fusion bloquée (corrigez les erreurs)';

  @override
  String mergeActionCta(int files, int pages) {
    return 'Fusionner $files PDF ($pages pages)';
  }

  @override
  String get mergePickerDefaultTitle => 'Sélectionner des PDF';

  @override
  String mergePickerTabAllPdfs(int count) {
    return 'Tous les PDF ($count)';
  }

  @override
  String get mergePickerTabRecent => 'Récents';

  @override
  String get mergePickerTabDownloads => 'Téléchargements';

  @override
  String get mergePickerTabICloud => 'iCloud Drive';

  @override
  String get splitProgressTitle => 'Division du PDF';

  @override
  String splitProgressMessage(int done, int total) {
    return 'Génération du fichier $done sur $total...';
  }

  @override
  String get splitErrorTitle => 'Impossible de diviser le PDF';

  @override
  String get splitPageRangesLabel => 'PLAGES DE PAGES';

  @override
  String get splitPageRangesSyntax => 'Syntaxe : 1-3, 5, 8-10';

  @override
  String get splitRangeHelpText =>
      'Chaque plage devient un fichier PDF distinct.';

  @override
  String splitGeneratedFilesHeader(int count) {
    return 'FICHIERS GÉNÉRÉS ($count)';
  }

  @override
  String get splitChipsSuspendedTitle => 'Aperçu des plages suspendu';

  @override
  String get splitChipsSuspendedDesc =>
      'Corrigez l\'erreur de syntaxe ci-dessus pour reconstruire l\'extraction.';

  @override
  String get splitEmptyRangesHint =>
      'Saisissez des plages de pages ci-dessus pour générer des extraits PDF';

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
      other: '$count p.',
      one: '1 p.',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => 'SÉLECTION RAPIDE';

  @override
  String get splitMacroAllPages => 'Toutes les pages';

  @override
  String get splitMacroEvery5Pages => 'Toutes les 5 pages';

  @override
  String get splitMacroLimitHint =>
      'Les raccourcis générant > 100 fichiers sont désactivés pour préserver la mémoire';

  @override
  String splitOutputSummary(int files, int pages) {
    return 'Sortie : $files fichiers · $pages pages extraites';
  }

  @override
  String splitEstSize(String size) {
    return 'EST. ~ $size';
  }

  @override
  String splitActionCtaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Diviser en $count PDF',
      one: 'Diviser en 1 PDF',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => 'Diviser en PDF';

  @override
  String splitPickerAllLocalDocs(int count) {
    return 'TOUS LES DOCUMENTS LOCAUX ($count)';
  }

  @override
  String get splitPickerSortByDate => 'TRIER PAR DATE';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return 'p. · $size';
  }

  @override
  String get splitPickerTitle => 'Sélectionner un PDF à diviser';

  @override
  String get faqShortTitle => 'FAQ';

  @override
  String splitPickerSelectedCount(int count) {
    return '$count PDF sélectionné';
  }

  @override
  String get splitPickerSelectDocumentHint =>
      'Sélectionnez un document pour continuer';

  @override
  String splitPickerPagesActive(int count) {
    return '$count pages actives';
  }

  @override
  String get splitPickerPagesActiveLabel => 'pages actives';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionGeneral => 'Général';

  @override
  String get settingsSectionOthers => 'Autres';

  @override
  String get settingsFileManagerTitle => 'Gestionnaire de fichiers';

  @override
  String get settingsFileManagerSubtitle =>
      'Parcourir les répertoires et dossiers de stockage';

  @override
  String get settingsFaqTitle => 'FAQ';

  @override
  String get settingsFaqSubtitle => 'Foire aux questions';

  @override
  String get settingsShareTitle => 'Partager';

  @override
  String get settingsShareSubtitle => 'Recommander Doc View à vos amis';

  @override
  String settingsShareMessage(String url) {
    return 'Découvrez Doc View - Lecteur de documents rapide, privé et hors ligne : $url';
  }

  @override
  String get settingsScanSettingsTitle => 'Paramètres d\'analyse';

  @override
  String get settingsScanModeOnOpen => 'À l\'ouverture';

  @override
  String get settingsScanModeManual => 'Manuel uniquement';

  @override
  String get settingsAppThemeTitle => 'Thème de l\'application';

  @override
  String get settingsThemeSystem => 'Par défaut (système)';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsRateUsTitle => 'Évaluez-nous';

  @override
  String get settingsRateUsSubtitle => 'Partagez votre avis avec nous';

  @override
  String get settingsAddWidgetTitle => 'Ajouter un widget';

  @override
  String get settingsAddWidgetSubtitle =>
      'Accès rapide depuis l\'écran d\'accueil';

  @override
  String get settingsTermsTitle => 'Conditions d\'utilisation';

  @override
  String get settingsTermsSubtitle => 'Lire nos conditions d\'utilisation';

  @override
  String get settingsPrivacyTitle => 'Politique de confidentialité';

  @override
  String get settingsPrivacySubtitle =>
      'Lire notre politique de confidentialité';

  @override
  String get settingsManageSubscriptionsTitle => 'Gérer les abonnements';

  @override
  String get settingsManageSubscriptionsSubtitle =>
      'Gérer votre abonnement sur la boutique';

  @override
  String settingsVersionDisplay(String version, String build) {
    return 'Version $version ($build)';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return 'Version $version build $build';
  }

  @override
  String get settingsOpenSourceLicenses => 'Licences open source';

  @override
  String get rateSheetTitle => 'Évaluer Doc View';

  @override
  String get rateSheetSubtitle => 'Votre avis nous aide à nous améliorer';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count étoiles',
      one: '1 étoile',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => 'Ravi qu\'elle vous plaise !';

  @override
  String get rateResponseMedium => 'Merci ! Dites-nous comment nous améliorer.';

  @override
  String get rateResponseLow =>
      'Désolé que cela ne vous convienne pas. Dites-nous ce qu\'il faut corriger.';

  @override
  String get rateActionStore => 'Évaluer sur Google Play';

  @override
  String get rateActionHelpFeedback => 'Aide et commentaires';

  @override
  String get faqFromRatingBanner =>
      'Désolé de l\'apprendre. Consultez les réponses ci-dessous ou contactez-nous ; nous lisons chaque message.';

  @override
  String get faqActionContactUs => 'Nous contacter';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return 'Commentaires Doc View ($version+$build)';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '\n\n---\nApp : Doc View $version (Build $build)\n';
  }

  @override
  String get faqEmailClientUnavailable =>
      'Impossible d\'ouvrir l\'application de messagerie';

  @override
  String get languageScreenTitle => 'Langue';

  @override
  String get languageSearchHint => 'Rechercher une langue...';

  @override
  String get languageSystemDefault => 'Langue du système';

  @override
  String get languageSystemDefaultSubtitle => 'Suivre la langue de l\'appareil';

  @override
  String get languageNotTranslatedBadge => '(non traduite)';

  @override
  String get languageNotTranslatedSnack =>
      'Cette langue n\'est pas encore traduite';

  @override
  String get languageNoResults => 'Aucune langue correspondante';

  @override
  String get languagePseudoLocaleName => 'Pseudo-locale (en_XA)';

  @override
  String get languagePseudoLocaleSubtitle => 'Test d\'expansion de débogage';

  @override
  String get scanSettingsSectionHistory => 'Historique';

  @override
  String get scanSettingsClearHistoryTitle => 'Effacer l\'historique récent';

  @override
  String get scanSettingsClearHistorySubtitle =>
      'Effacer l\'historique des documents ouverts';

  @override
  String get scanSettingsClearHistoryDialogTitle =>
      'Effacer l\'historique récent ?';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      'Les fichiers seront retirés de Récents. Vos fichiers et vos favoris ne sont pas affectés.';

  @override
  String get scanSettingsRecentHistoryCleared => 'Historique récent effacé';

  @override
  String get scanSettingsLastScanToday => 'aujourd\'hui';

  @override
  String get scanSettingsLastScanYesterday => 'hier';

  @override
  String get scanSettingsNeverScanned => 'Jamais analysé';

  @override
  String get scanSettingsLastScanPrefix => 'Dernière analyse :';

  @override
  String get readerActionVertical => 'Vertical';

  @override
  String get readerActionHorizontal => 'Horizontal';

  @override
  String get readerActionRotate => 'Pivoter';

  @override
  String get readerActionSearch => 'Rechercher';

  @override
  String get readerActionInvert => 'Inverser';

  @override
  String get readerActionShare => 'Partager';

  @override
  String get readerActionPages => 'Pages';

  @override
  String get readerSearchHint => 'Rechercher dans le document...';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '$current sur $total';
  }

  @override
  String get readerSearchMatchCap => '500+';

  @override
  String get readerSearchNoMatches => '0 sur 0';

  @override
  String get readerSearchNoTextLayer =>
      'Ce PDF ne contient pas de texte consultable';

  @override
  String get readerSearchPrevMatch => 'Occurrence précédente';

  @override
  String get readerSearchNextMatch => 'Occurrence suivante';

  @override
  String readerTopPagesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages • $size',
      one: '1 page • $size',
    );
    return '$_temp0';
  }

  @override
  String get readerMenuGoToPage => 'Aller à la page';

  @override
  String get readerMenuAddBookmark => 'Ajouter aux favoris';

  @override
  String get readerMenuRemoveBookmark => 'Retirer des favoris';

  @override
  String get readerMenuDetails => 'Détails';

  @override
  String get readerMenuOpenInAnotherApp => 'Ouvrir dans une autre application';

  @override
  String get readerTooltipConvertToWord => 'Convertir en Word';

  @override
  String get pagesScreenTitle => 'Pages';

  @override
  String pagesScreenPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String get pagesActionSelectAll => 'Tout sélectionner';

  @override
  String get pagesActionClearSelection => 'Effacer';

  @override
  String get pagesActionSave => 'Enregistrer';

  @override
  String get pagesActionInsert => 'Insérer';

  @override
  String get pagesActionRotate => 'Pivoter';

  @override
  String get pagesActionExtract => 'Extraire';

  @override
  String get pagesActionDelete => 'Supprimer';

  @override
  String get pagesActionUndo => 'Annuler';

  @override
  String get pagesInsertSheetTitle => 'Insérer des pages';

  @override
  String get pagesInsertPagesFromPdf => 'Pages d\'un autre PDF';

  @override
  String get pagesDeleteAllBlocked =>
      'Impossible de supprimer toutes les pages. Un document doit contenir au moins une page.';

  @override
  String get pagesSaveDialogTitle => 'Enregistrer les modifications';

  @override
  String get pagesSaveAsNew => 'Enregistrer comme nouveau fichier';

  @override
  String get pagesSaveReplace => 'Remplacer l\'original';

  @override
  String get pagesSaveReplaceWarning => 'Cela écrasera le fichier d\'origine.';

  @override
  String get pagesSaveFileNameLabel => 'Nom du fichier';

  @override
  String get pagesDiscardDialogTitle => 'Ignorer les modifications ?';

  @override
  String get pagesDiscardDialogBody =>
      'Vous avez des modifications non enregistrées. Voulez-vous vraiment les ignorer ?';

  @override
  String get pagesDiscardButton => 'Ignorer';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages extraites',
      one: '1 page extraite',
    );
    return '$_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      'Ce PDF ne peut pas être modifié car il est chiffré ou illisible.';

  @override
  String get viewerErrorCorruptTitle => 'Impossible d\'ouvrir ce document';

  @override
  String get viewerErrorCorruptMessage =>
      'Ce fichier semble endommagé ou n\'est pas un document valide.';

  @override
  String get viewerErrorMissingTitle => 'Ce fichier n\'existe plus';

  @override
  String get viewerErrorMissingMessage =>
      'Le fichier a été supprimé ou déplacé du stockage de l\'appareil.';

  @override
  String get viewerErrorBackToFiles => 'Retour aux fichiers';

  @override
  String get viewerErrorNoAppFound =>
      'Aucune application trouvée pour ouvrir ce fichier';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count occurrences',
      one: '1 occurrence',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments • $ext',
      one: '1 élément • $ext',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner => 'Ancien format : texte uniquement';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      'Classeur volumineux : affichage des 20 000 premières lignes et 100 premières colonnes';

  @override
  String viewerSectionTitle(int number) {
    return 'Section $number';
  }

  @override
  String get viewerMenuOutline => 'Plan';

  @override
  String get viewerOutlineTitle => 'Plan du document';

  @override
  String get viewerCloseOutline => 'Fermer le plan';

  @override
  String get viewerNoSections => 'Aucune section trouvée dans ce document';

  @override
  String get viewerOutlineTooltip => 'Table des matières';

  @override
  String get viewerActionOpenExternal => 'Ouvrir dans une autre application';

  @override
  String get viewerErrorCantOpenTitle => 'Impossible d\'ouvrir ce document';

  @override
  String get viewerErrorCantOpenMessage =>
      'Le document n\'a pas pu être affiché hors ligne.';

  @override
  String get viewerOpeningDocument => 'Ouverture du document...';

  @override
  String get viewerErrorEncryptedTitle => 'Ce document est chiffré';

  @override
  String get viewerErrorEncryptedMessage =>
      'Les fichiers protégés par mot de passe ne peuvent pas être consultés dans le lecteur hors ligne.';

  @override
  String get viewerErrorTooLargeTitle =>
      'Ce fichier dépasse la limite d\'affichage';

  @override
  String get viewerErrorTooLargeMessage =>
      'Les documents volumineux doivent être ouverts avec une visionneuse Office externe.';

  @override
  String get viewerErrorUnsupportedFormatTitle =>
      'Ce format n\'est pas pris en charge';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      'Doc View ne peut pas analyser ce format de fichier directement.';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '1 élément',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => 'Typographie';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get txtViewerMonospaceLabel => 'Police à chasse fixe';

  @override
  String get txtViewerTruncationBanner =>
      'Le fichier dépasse 1 MB : affichage du premier 1 MB';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes • $size',
      one: '1 ligne • $size',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => 'Paramètres typographiques';

  @override
  String get txtViewerTooltipDecreaseFont => 'Réduire la taille de police';

  @override
  String get txtViewerTooltipIncreaseFont => 'Augmenter la taille de police';

  @override
  String get txtViewerTooltipToggleMonospace =>
      'Activer/désactiver la police à chasse fixe';

  @override
  String get txtViewerMonospaceSubtitle =>
      'Caractères de largeur fixe pour le code et les journaux';

  @override
  String get txtViewerPreviewLabel => 'Aperçu';

  @override
  String get txtViewerPreviewText =>
      'Voix ambiguë d\'un cœur qui, au zéphyr, préfère les jattes de kiwis.';

  @override
  String get txtViewerErrorTitle => 'Impossible de lire ce fichier texte';

  @override
  String get txtViewerErrorMessage =>
      'Le format ou l\'encodage du fichier n\'a pas pu être analysé.';

  @override
  String get txtViewerActionRetry => 'Réessayer';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '$width × $height • $size';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '$percent %';
  }

  @override
  String get imageViewerTooltipFitToScreen => 'Ajuster à l\'écran';

  @override
  String get imageViewerErrorCorrupt => 'Impossible de charger l\'image';

  @override
  String get imageViewerLoading => 'Chargement de l\'image…';

  @override
  String get viewerDispatcherFileMissing => 'Le fichier n\'existe plus';

  @override
  String get viewerSpreadsheetFormulaBarEmpty => '-';

  @override
  String get viewerSpreadsheetAllCells => 'Tout';

  @override
  String viewerSpreadsheetColumnLabel(String col) {
    return 'Colonne $col';
  }

  @override
  String viewerSpreadsheetRowLabel(int row) {
    return 'Ligne $row';
  }

  @override
  String viewerSpreadsheetCellSemantics(String col, int row, String value) {
    return 'Colonne $col, ligne $row, $value';
  }

  @override
  String get viewerSpreadsheetEmptyCell => 'vide';

  @override
  String get viewerSpreadsheetEmptySheet => 'Cette feuille est vide';

  @override
  String get viewerSpreadsheetCopiedSingle => 'Cellule copiée';

  @override
  String viewerSpreadsheetCopiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cellules copiées',
      one: '1 cellule copiée',
    );
    return '$_temp0';
  }

  @override
  String get viewerSpreadsheetCopyLimitReached =>
      'Sélection tronquée à 5 000 cellules';

  @override
  String get viewerSpreadsheetCellContentTitle => 'Contenu de la cellule';

  @override
  String get viewerSpreadsheetCopyAction => 'Copier';

  @override
  String get viewerSpreadsheetCloseAction => 'Fermer';

  @override
  String viewerSpreadsheetZoomPill(int percent) {
    return '$percent %';
  }

  @override
  String get viewerSpreadsheetResetZoomTooltip =>
      'Réinitialiser le zoom à 100 %';

  @override
  String get viewerSpreadsheetNoMatches => 'Aucun résultat dans cette feuille';

  @override
  String get viewerSpreadsheetSearchPlaceholder =>
      'Rechercher dans la feuille…';

  @override
  String get viewerSpreadsheetPasswordTitle =>
      'Fichier protégé par mot de passe';

  @override
  String get viewerSpreadsheetPasswordMessage =>
      'Les fichiers protégés par mot de passe ne peuvent pas être ouverts ici.';

  @override
  String get viewerSpreadsheetErrorTitle =>
      'Impossible de lire cette feuille de calcul';

  @override
  String get viewerSpreadsheetCorruptMessage =>
      'Le fichier de feuille de calcul est corrompu ou n\'a pas pu être décodé.';

  @override
  String get viewerSpreadsheetTimeoutMessage =>
      'L\'ouverture de la feuille de calcul a expiré après 20 secondes.';

  @override
  String get viewerSpreadsheetTooLargeMessage =>
      'Ce fichier dépasse la limite d\'affichage de 25 MB.';

  @override
  String get viewerSpreadsheetOpenBasicViewer =>
      'Ouvrir dans la visionneuse simple';

  @override
  String get viewerSpreadsheetOpenAnotherApp =>
      'Ouvrir dans une autre application';

  @override
  String get toolsWorkspaceOverline => 'ESPACE DE TRAVAIL';

  @override
  String get toolsTitle => 'Outils';

  @override
  String get toolsSectionConvertCreate => 'CONVERTIR ET CRÉER';

  @override
  String get toolsSectionEditManage => 'MODIFIER ET GÉRER';

  @override
  String get toolsSectionOthers => 'AUTRES';

  @override
  String get toolsCreatedByYou => 'Créés par vous';

  @override
  String get toolsCreatedByYouEmpty =>
      'Les PDF que vous créez apparaissent ici';

  @override
  String get toolsCreatedByYouSeeAll => 'Tout voir';

  @override
  String get toolManagePages => 'Gérer les pages';

  @override
  String get toolManagePagesSub => 'Réorganiser, pivoter et supprimer';

  @override
  String get toolImportFiles => 'Importer des fichiers';

  @override
  String get toolImportFilesSub => 'Ajouter depuis d\'autres apps';

  @override
  String get toolPrintPdf => 'Imprimer le PDF';

  @override
  String get toolPrintPdfSub => 'Envoyer vers une imprimante';

  @override
  String get toolCreatePdf => 'Créer un PDF';

  @override
  String get toolCreatePdfSub => 'Document vierge ou modèle';

  @override
  String get toolRecycleBin => 'Corbeille';

  @override
  String get toolRecycleBinSub => 'Restaurer les fichiers supprimés';

  @override
  String get toolAnnotate => 'Annoter';

  @override
  String get toolAnnotateSub => 'Surligner, dessiner et marquer';

  @override
  String get toolAddText => 'Ajouter du texte';

  @override
  String get toolAddTextSub => 'Insérer du texte et des dates';

  @override
  String get toolSign => 'Signer';

  @override
  String get toolSignSub => 'Remplir et signer des formulaires';

  @override
  String get toolWordToPdf => 'Word vers PDF';

  @override
  String get toolWordToPdfSub => 'Convertir DOCX en PDF';

  @override
  String get toolPptToPdf => 'PPT vers PDF';

  @override
  String get toolPptToPdfSub => 'Convertir PPTX en PDF';

  @override
  String get printPdfErrorTooLarge =>
      'Le fichier PDF dépasse la limite d\'impression de 50 MB.';

  @override
  String get printPdfErrorUnreadable =>
      'Impossible de lire le PDF pour l\'impression.';

  @override
  String get printPdfErrorPassword =>
      'Impossible d\'imprimer directement un PDF protégé par mot de passe.';

  @override
  String get printPdfErrorFailed => 'Échec de l\'impression.';

  @override
  String get printPdfSuccess => 'Document envoyé à l\'imprimante.';

  @override
  String get toolPickerTitleSelectPdf => 'Sélectionner un PDF';

  @override
  String get toolPickerTitleSelectPdfs => 'Sélectionner des PDF';

  @override
  String get toolPickerBrowseFiles => 'Parcourir les fichiers';

  @override
  String get toolPickerTabAll => 'Tous les PDF';

  @override
  String get toolPickerTabRecent => 'Récents';

  @override
  String get toolPickerTabDownloads => 'Téléchargements';

  @override
  String get toolPickerTabICloud => 'iCloud Drive';

  @override
  String get toolPickerActionPrint => 'Imprimer';

  @override
  String get toolPickerActionManage => 'Gérer';

  @override
  String get toolPickerActionSelect => 'Sélectionner';

  @override
  String get toolsImportActionView => 'Afficher';

  @override
  String get createPdfTemplateBlank => 'Vierge';

  @override
  String get createPdfTemplateLine1 => 'Ligné 1';

  @override
  String get createPdfTemplateLine2 => 'Ligné 2';

  @override
  String get createPdfTemplateNotebook => 'Cahier';

  @override
  String get createPdfTemplateCornell => 'Cornell';

  @override
  String get createPdfTemplateGrid => 'Quadrillé';

  @override
  String get createPdfTemplateGraph => 'Millimétré';

  @override
  String get createPdfSwatchWhite => 'Blanc';

  @override
  String get createPdfSwatchCream => 'Crème';

  @override
  String get createPdfSwatchLightYellow => 'Jaune clair';

  @override
  String get createPdfSwatchLightPeach => 'Pêche clair';

  @override
  String get createPdfSwatchLightPink => 'Rose clair';

  @override
  String get createPdfSwatchLightLavender => 'Lavande clair';

  @override
  String get createPdfSwatchLightBlue => 'Bleu clair';

  @override
  String get createPdfSwatchLightMint => 'Menthe clair';

  @override
  String get createPdfSwatchLightGreen => 'Vert clair';

  @override
  String get createPdfSwatchLightGray => 'Gris clair';

  @override
  String get createPdfOrientationPortrait => 'Portrait';

  @override
  String get createPdfOrientationLandscape => 'Paysage';

  @override
  String get createPdfSectionTemplate => 'MODÈLE';

  @override
  String get createPdfSectionPageSize => 'FORMAT DE PAGE';

  @override
  String get createPdfSectionOrientation => 'ORIENTATION';

  @override
  String get createPdfSectionPageColor => 'COULEUR DE PAGE';

  @override
  String get createPdfSectionPageCount => 'NOMBRE DE PAGES';

  @override
  String createPdfPagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String createPdfSummary(String pages, String size, String orientation) {
    return '$pages • $size • $orientation';
  }

  @override
  String get createPdfCreating => 'Génération du PDF...';

  @override
  String createPdfProgress(int done, int total) {
    return 'Création de la page $done sur $total...';
  }

  @override
  String get createPdfErrorTitle => 'Impossible de créer le PDF';

  @override
  String get createPdfErrorPageCount =>
      'Le nombre de pages doit être compris entre 1 et 100.';

  @override
  String get createPdfErrorInvalidName =>
      'Veuillez saisir un nom de fichier valide.';

  @override
  String get createPdfErrorGeneration =>
      'Échec de la génération du document PDF. Veuillez réessayer.';

  @override
  String get trashErrorTooLarge =>
      'Le fichier est trop volumineux pour la Corbeille (limite de 200 MB)';

  @override
  String get trashErrorNotEnoughSpace =>
      'Espace de stockage insuffisant dans la Corbeille';

  @override
  String trashErrorGeneric(String details) {
    return 'Échec de l\'opération dans la Corbeille : $details';
  }

  @override
  String get trashDialogMoveTitle => 'Déplacer vers la Corbeille ?';

  @override
  String trashDialogMoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Déplacer $count fichiers vers la Corbeille ? Vous pourrez les restaurer depuis Outils > Corbeille pendant 30 jours.',
      one:
          'Déplacer 1 fichier vers la Corbeille ? Vous pourrez le restaurer depuis Outils > Corbeille pendant 30 jours.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionMove => 'Déplacer vers la Corbeille';

  @override
  String trashMovedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers déplacés vers la Corbeille',
      one: '1 fichier déplacé vers la Corbeille',
    );
    return '$_temp0';
  }

  @override
  String get trashActionUndo => 'Annuler';

  @override
  String trashRestoredSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers restaurés',
      one: '1 fichier restauré',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogDeleteForeverTitle => 'Supprimer définitivement ?';

  @override
  String trashDialogDeleteForeverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Supprimer définitivement $count fichiers ? Cette action est irréversible.',
      one:
          'Supprimer définitivement 1 fichier ? Cette action est irréversible.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionDeleteForever => 'Supprimer définitivement';

  @override
  String trashDeletedForeverSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers supprimés définitivement',
      one: '1 fichier supprimé définitivement',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogEmptyTitle => 'Vider la Corbeille ?';

  @override
  String trashDialogEmptyBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tous les $count fichiers',
      one: '1 fichier',
    );
    return 'Supprimer définitivement $_temp0 ? Cette action est irréversible.';
  }

  @override
  String get trashActionEmptyBin => 'Vider la corbeille';

  @override
  String get trashEmptyTitle => 'La Corbeille est vide';

  @override
  String get trashEmptySubtitle =>
      'Les fichiers déplacés dans la Corbeille y restent 30 jours avant d\'être supprimés définitivement.';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours restants',
      one: '1 jour restant',
    );
    return '$_temp0';
  }

  @override
  String trashSubtitle(String date, String size) {
    return 'Supprimé le $date · $size';
  }

  @override
  String get trashDialogTooLargeTitle => 'Trop volumineux pour la Corbeille';

  @override
  String trashDialogTooLargeBody(String fileName) {
    return '« $fileName » dépasse 200 MB et ne peut pas être déplacé vers la Corbeille. Voulez-vous le supprimer définitivement ?';
  }

  @override
  String get trashActionDeletePermanently => 'Supprimer définitivement';

  @override
  String get trashInfoBanner =>
      'Les éléments de la Corbeille sont supprimés définitivement après 30 jours.';

  @override
  String get trashSheetRestore => 'Restaurer';

  @override
  String get trashSheetDeleteForever => 'Supprimer définitivement';

  @override
  String get trashSheetDetails => 'Détails';

  @override
  String get trashDetailsOriginalLocation => 'Emplacement d\'origine';

  @override
  String get trashDetailsDateDeleted => 'Date de suppression';

  @override
  String get trashDetailsExpiresIn => 'Expire dans';

  @override
  String trashRestoredToFallbackSuccess(String location) {
    return 'Restauré dans $location (dossier d\'origine introuvable)';
  }

  @override
  String get trashDialogCopyFailedTitle =>
      'Impossible de déplacer vers la Corbeille';

  @override
  String trashDialogCopyFailedBody(String fileName) {
    return 'Impossible de déplacer « $fileName » vers la Corbeille. Voulez-vous le supprimer définitivement ? Cette action est irréversible.';
  }

  @override
  String get trashDialogEmptyProgress => 'Vidage de la Corbeille...';

  @override
  String get trashDialogMoveProgress =>
      'Déplacement des fichiers vers la Corbeille...';

  @override
  String get trashDialogNotEnoughSpaceTitle => 'Espace de stockage insuffisant';

  @override
  String get trashDialogNotEnoughSpaceBody =>
      'L\'espace de stockage est insuffisant pour déplacer vers la Corbeille. Libérez de l\'espace en vidant la corbeille.';

  @override
  String get trashActionFreeUpSpace => 'Libérer de l\'espace';

  @override
  String get trashDialogDeleteForeverProgress =>
      'Suppression définitive des fichiers...';

  @override
  String get galleryDebugAgeTrash =>
      'Vieillir tous les éléments de la corbeille de 29 jours';

  @override
  String get galleryDebugSlowCopy => 'Copie lente vers la corbeille (test)';

  @override
  String get galleryDebugSlowCopySubtitle =>
      'Limite la boucle de copie à ~20 MB/s pour tester l\'arrêt forcé';

  @override
  String get galleryDebugSlowSave => 'Enregistrement lent de l\'éditeur (test)';

  @override
  String get galleryDebugSlowSaveSubtitle =>
      'Limite la boucle d\'enregistrement à ~8 s pour tester l\'arrêt forcé';

  @override
  String get galleryDebugSaveAnnotate =>
      'Enregistrer un exemple 100 p. (test Annoter)';

  @override
  String get galleryDebugSaveSign =>
      'Enregistrer un exemple 100 p. (test Signer)';

  @override
  String get galleryDebugSaveText =>
      'Enregistrer un exemple 100 p. (test Ajouter texte)';

  @override
  String get galleryDebugMove190Mb =>
      'Déplacer un fichier test de 190 MB vers la corbeille';

  @override
  String get galleryDebugRestoreLastTrash =>
      'Restaurer le dernier élément de la corbeille';

  @override
  String get galleryDebugEmptyTrash => 'Vider la Corbeille';

  @override
  String galleryDebugAgeTrashSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments vieillis',
      one: '1 élément vieilli',
    );
    return '$_temp0 de 29 jours';
  }

  @override
  String get annotateErrorPasswordProtected =>
      'Ce PDF est protégé par mot de passe.';

  @override
  String get annotateErrorCorrupt => 'Ce PDF est corrompu ou illisible.';

  @override
  String get annotateSignedReplaceBlocked =>
      'Le remplacement du PDF signé d\'origine n\'est pas autorisé. Veuillez l\'enregistrer comme nouveau fichier.';

  @override
  String annotateErrorSaveFailed(String details) {
    return 'Échec de l\'enregistrement des annotations : $details';
  }

  @override
  String get annotateErrorScannedPdf =>
      'Ce document semble être numérisé ou ne contient aucun texte sélectionnable.';

  @override
  String get annotateSignedBanner =>
      'PDF signé numériquement : l\'enregistrement créera une nouvelle copie pour préserver la signature.';

  @override
  String get annotateActionSaveNew => 'Enregistrer comme nouveau fichier';

  @override
  String get annotateActionReplace => 'Remplacer l\'original';

  @override
  String get annotateDiscardDialogTitle =>
      'Ignorer les annotations non enregistrées ?';

  @override
  String get annotateDiscardDialogBody =>
      'Vous avez des annotations non enregistrées. Si vous quittez maintenant, vos modifications seront perdues.';

  @override
  String get annotateDiscardDialogActionDiscard => 'Ignorer';

  @override
  String get annotateDiscardDialogActionKeep => 'Continuer l\'édition';

  @override
  String get annotateSaveSuccess => 'Annotations enregistrées avec succès';

  @override
  String get annotateToolbarHighlight => 'Surligner';

  @override
  String get annotateToolbarUnderline => 'Souligner';

  @override
  String get annotateToolbarStrikethrough => 'Barrer';

  @override
  String get annotateToolbarCopy => 'Copier';

  @override
  String get annotateColorYellow => 'Jaune';

  @override
  String get annotateColorGreen => 'Vert';

  @override
  String get annotateColorCyan => 'Cyan';

  @override
  String get annotateColorPink => 'Rose';

  @override
  String get annotateColorOrange => 'Orange';

  @override
  String get annotateSaveTitle => 'Enregistrer les annotations';

  @override
  String get annotateSaveProgress => 'Enregistrement des annotations...';

  @override
  String get annotateNoChanges => 'Aucune annotation à enregistrer';

  @override
  String get annotateTooltipUndo => 'Annuler';

  @override
  String get annotateTooltipRedo => 'Rétablir';

  @override
  String get annotateTooltipSave => 'Enregistrer';

  @override
  String get annotateCopiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get annotateToolbarPen => 'Stylo';

  @override
  String get annotatePenTipBanner =>
      'Dessinez avec un doigt. Déplacez et zoomez avec deux doigts.';

  @override
  String get annotatePenSheetTitle => 'Paramètres du stylo';

  @override
  String get annotatePenStrokeWidth => 'Épaisseur du trait';

  @override
  String get annotatePenEraserMode => 'Gomme';

  @override
  String get annotateColorBlack => 'Noir';

  @override
  String get annotateColorRed => 'Rouge';

  @override
  String get annotateColorPurple => 'Violet';

  @override
  String get annotateColorBlue => 'Bleu';

  @override
  String get toolSignPdf => 'Signer un PDF';

  @override
  String get toolSignPdfSubtitle =>
      'Ajouter une signature et une date aux documents';

  @override
  String get signToolbarSign => 'Signer';

  @override
  String get signToolbarDate => 'Date';

  @override
  String get signToolbarClearAll => 'Tout effacer';

  @override
  String get signPadTitle => 'Dessinez votre signature';

  @override
  String get signPadClear => 'Effacer';

  @override
  String get signPadSave => 'Enregistrer la signature';

  @override
  String get signSheetTitle => 'Signatures enregistrées';

  @override
  String get signSheetCreateNew => 'Créer une nouvelle signature';

  @override
  String get signMaxSignaturesReached =>
      'Maximum de 5 signatures enregistrées atteint';

  @override
  String get signMaxPlacedReached =>
      'Maximum de 20 signatures par document atteint';

  @override
  String get signDeleteSignatureTitle => 'Supprimer la signature ?';

  @override
  String get signDeleteSignatureBody =>
      'Cette signature sera retirée de vos signatures enregistrées.';

  @override
  String get signConfirmClearAllTitle => 'Effacer toutes les signatures ?';

  @override
  String get signConfirmClearAllBody =>
      'Toutes les signatures et dates placées sur ce document seront supprimées.';

  @override
  String get signSaveSuccess => 'Document signé avec succès';

  @override
  String get signNoSignaturesToSave =>
      'Aucune signature placée sur le document';

  @override
  String get signPlacedSignatureDelete => 'Supprimer';

  @override
  String get signPlacedSignatureApply => 'Appliquer';

  @override
  String get signTooltipUndo => 'Annuler';

  @override
  String get signTooltipRedo => 'Rétablir';

  @override
  String get signTooltipSave => 'Enregistrer';

  @override
  String annotatePenStrokeWidthValue(String width) {
    return '$width pt';
  }

  @override
  String get annotateErrorTooManyStrokes =>
      'Le document a atteint le maximum de 5 000 traits ou 300 000 points.';

  @override
  String annotateChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count modifications',
      one: '1 modification',
    );
    return '$_temp0';
  }

  @override
  String get annotatePenNotice =>
      'Les traits de stylo sont intégrés à la page lors de l\'enregistrement et ne peuvent plus être modifiés ensuite.';

  @override
  String get annotatePenNoticeDismiss => 'Compris';

  @override
  String get signPadBaselineHint => 'Signez ici';

  @override
  String get signPadUndo => 'Annuler';

  @override
  String get signPadUseOnce => 'Utiliser une fois';

  @override
  String get signPadSaveAndUse => 'Enregistrer et utiliser';

  @override
  String get tool_add_text => 'Ajouter du texte';

  @override
  String get tool_add_text_desc =>
      'Insérer des zones de texte et des notes sur les pages';

  @override
  String get addTextNoticePermanent =>
      'Le texte ajouté est intégré à la page et ne peut plus être modifié après l\'enregistrement.';

  @override
  String get addTextNoticeRaster =>
      'Le texte dans cette langue est ajouté en tant qu\'image et ne peut pas être sélectionné.';

  @override
  String get addTextNoticeGotIt => 'Compris';

  @override
  String get addTextActionAdd => 'Ajouter du texte';

  @override
  String get addTextActionStyle => 'Style';

  @override
  String get addTextActionDelete => 'Supprimer';

  @override
  String get addTextStyleSheetTitle => 'Style du texte';

  @override
  String get addTextFontSize => 'Taille de police';

  @override
  String get addTextColor => 'Couleur';

  @override
  String get addTextStyle => 'Style';

  @override
  String get addTextAlign => 'Alignement';

  @override
  String get addTextBold => 'Gras';

  @override
  String get addTextItalic => 'Italique';

  @override
  String get addTextAlignStart => 'Début';

  @override
  String get addTextAlignCenter => 'Centré';

  @override
  String get addTextAlignEnd => 'Fin';

  @override
  String get addTextErrorTooManyBoxes => 'Maximum de 30 zones de texte atteint';

  @override
  String get addTextErrorBoxTooLong =>
      'La zone de texte ne peut pas dépasser 2 000 caractères';

  @override
  String get addTextPlaceholder => 'Saisissez le texte ici';

  @override
  String get addTextSamplePreview => 'Aperçu';

  @override
  String addTextFontSizePt(int size) {
    return '$size pt';
  }

  @override
  String get premiumTitle => 'Doc View Premium';

  @override
  String get premiumSubtitle =>
      'Débloquez les outils d\'annotation et de signature et profitez d\'une expérience 100 % sans publicité.';

  @override
  String get premiumFeatureAllTools =>
      'Outils d\'annotation et de signature PDF';

  @override
  String get premiumFeatureAllToolsSub =>
      'Dessinez, surlignez des documents et signez des PDF facilement';

  @override
  String get premiumFeatureAdFree => 'Expérience 100 % sans publicité';

  @override
  String get premiumFeatureAdFreeSub =>
      'Aucune bannière, coupure ni distraction où que ce soit';

  @override
  String get premiumFeatureUnlimitedConversions =>
      'Conversions locales illimitées';

  @override
  String get premiumFeatureUnlimitedConversionsSub =>
      'Convertissez des documents sur votre appareil sans aucune limite de fichiers';

  @override
  String get premiumFeaturePrivacyFirst => '100 % privé et sur l\'appareil';

  @override
  String get premiumFeaturePrivacyFirstSub =>
      'Les fichiers sont traités localement et ne sont jamais envoyés vers un serveur';

  @override
  String get premiumPlanYearly => 'Abonnement annuel';

  @override
  String premiumPlanYearlyTrial(int days, String price) {
    return '$days jours gratuits, puis $price/an';
  }

  @override
  String get premiumPlanMonthly => 'Abonnement mensuel';

  @override
  String premiumPlanMonthlySub(String price) {
    return '$price/mois';
  }

  @override
  String premiumPlanYearlySub(String price) {
    return '$price/an';
  }

  @override
  String premiumPlanMonthlyTrial(int days, String price) {
    return '$days jours gratuits, puis $price/mois';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Économisez $percent %';
  }

  @override
  String get premiumSaveUnknown => 'Économisez - %';

  @override
  String premiumActionStartTrial(int days) {
    return 'Démarrer l\'essai gratuit de $days jours';
  }

  @override
  String get premiumSubscriptionsAvailableSoon =>
      'Les abonnements seront bientôt disponibles.';

  @override
  String get pagesEditPagesAction => 'Modifier les pages';

  @override
  String get premiumCancelAnytime => 'Annulez à tout moment';

  @override
  String get premiumPendingStatus =>
      'Votre achat est en cours de traitement par Google Play. Les avantages seront activés dès confirmation.';

  @override
  String get premiumRenewalDisclosurePricingUnavailable =>
      'Renouvellement automatique. Le tarif sera confirmé par Google Play lors du paiement. Annulez à tout moment dans les abonnements Google Play.';

  @override
  String get premiumActionSubscribe => 'S\'abonner';

  @override
  String get premiumActionRestore => 'Restaurer les achats';

  @override
  String get premiumBillingDisclaimer =>
      'Renouvellement automatique. Annulez à tout moment dans les abonnements Google Play.';

  @override
  String get premiumTerms => 'Conditions d\'utilisation';

  @override
  String get premiumPrivacy => 'Politique de confidentialité';

  @override
  String get premiumActiveStatus => 'Vous êtes abonné à Premium';

  @override
  String get premiumGraceStatus => 'Période de grâce hors ligne active';

  @override
  String get premiumExpiredStatus => 'Abonnement expiré';

  @override
  String get premiumRestoreSuccess => 'Achats restaurés avec succès.';

  @override
  String get premiumRestoreNone => 'Aucun abonnement actif trouvé.';

  @override
  String get premiumErrorGeneral =>
      'Impossible de finaliser l\'achat. Veuillez réessayer.';

  @override
  String get premiumPagesGateTitle => 'Doc View Premium';

  @override
  String get premiumPagesGateBody =>
      'La réorganisation, la rotation et la suppression de pages nécessitent un abonnement Premium.';

  @override
  String get premiumPagesGateUpgrade => 'Passer à Premium';

  @override
  String get premiumTooltip => 'Doc View Premium';

  @override
  String get premiumManageInPlay => 'Gérer';

  @override
  String get faqQuestion8 =>
      'Qu\'est-ce qui est inclus dans Doc View Premium ?';

  @override
  String get faqAnswer8 =>
      'Doc View Premium débloque tous les outils avancés d\'édition de documents, notamment la réorganisation, la rotation et la suppression de pages PDF, la conversion PDF vers Word, les annotations, les signatures et l\'insertion de texte personnalisé, tout en supprimant complètement toutes les publicités de l\'application. Tout le traitement des documents reste 100 % sur l\'appareil.';

  @override
  String get faqQuestion9 =>
      'Puis-je utiliser Doc View Premium sans connexion Internet ?';

  @override
  String get faqAnswer9 =>
      'Oui. Une fois activé, Doc View met en cache de manière sécurisée l\'état de votre abonnement sur votre appareil avec une période de grâce hors ligne pouvant aller jusqu\'à 7 jours consécutifs. Vous pouvez continuer à utiliser tous les outils d\'édition hors ligne pendant cette période.';

  @override
  String get galleryDebugIapSectionTitle =>
      '15. Simulateur IAP et Premium (G7)';

  @override
  String get galleryDebugIapStateFree => 'Définir Gratuit';

  @override
  String get galleryDebugIapStateYearly => 'Définir Premium annuel';

  @override
  String get galleryDebugIapStateMonthly => 'Définir Premium mensuel';

  @override
  String get galleryDebugIapStateGrace => 'Définir grâce hors ligne (Active)';

  @override
  String get galleryDebugIapStateGraceExpired =>
      'Définir grâce hors ligne (Expirée)';

  @override
  String get galleryDebugOpenPremium => 'Ouvrir l\'écran /premium';

  @override
  String get galleryDebugIapProductSeenTrue => 'Définir Produit vu : Vrai';

  @override
  String get galleryDebugIapProductSeenFalse => 'Définir Produit vu : Faux';

  @override
  String get addWidgetSheetTitle => 'Ajouter à l\'écran d\'accueil';

  @override
  String get addWidgetSheetSubtitle =>
      'Choisissez un widget à ajouter à votre écran d\'accueil';

  @override
  String get widgetRecentFilesTitle => 'Fichiers récents';

  @override
  String get widgetRecentFilesBadge => '4 × 2';

  @override
  String get widgetRecentFilesDesc =>
      'Affichez et ouvrez vos fichiers récemment utilisés directement depuis votre écran d\'accueil';

  @override
  String get widgetQuickToolsTitle => 'Outils rapides';

  @override
  String get widgetQuickToolsBadge => '4 × 1';

  @override
  String get widgetQuickToolsDesc =>
      'Accédez directement à Numériser, Image en PDF, Rechercher ou Importer';

  @override
  String get addWidgetButton => 'Ajouter le widget';

  @override
  String get addWidgetManualTitle => 'Ajouter le widget manuellement';

  @override
  String get addWidgetManualMessage =>
      'Appuyez de manière prolongée sur un espace vide de votre écran d\'accueil, touchez Widgets, recherchez Doc View et faites-le glisser sur votre écran.';

  @override
  String get settingsQuickAccessNotificationTitle =>
      'Notification d\'accès rapide';

  @override
  String get settingsQuickAccessNotificationSubtitle =>
      'Afficher les outils rapides dans la barre de notifications';

  @override
  String get notificationPermissionDialogTitle => 'Autoriser les notifications';

  @override
  String get notificationPermissionDialogDesc =>
      'Doc View a besoin de l\'autorisation de notification pour afficher la barre d\'accès rapide dans votre panneau de notifications.';

  @override
  String get notificationTitle => 'Outils rapides Doc View';

  @override
  String get notificationBody =>
      'Numériser, convertir ou rechercher des documents';

  @override
  String get notificationActionScan => 'Numériser';

  @override
  String get notificationActionImageToPdf => 'Image en PDF';

  @override
  String get notificationActionSearch => 'Rechercher';

  @override
  String get settingsAdChoicesTitle => 'Préférences publicitaires';

  @override
  String get settingsAdChoicesSubtitle =>
      'Gérer la confidentialité et les choix publicitaires';

  @override
  String get faqQuestion10 => 'Pourquoi Doc View affiche-t-il des publicités ?';

  @override
  String get faqAnswer10 =>
      'Les publicités permettent de garder Doc View gratuit. Premium les supprime. Les annonces sont diffusées par Google AdMob et n\'ont jamais accès à vos documents.';
}
