// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Doc View';

  @override
  String get navHome => 'Todos los archivos';

  @override
  String get navTools => 'Herramientas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get noDocumentSelected => 'Ningún documento seleccionado';

  @override
  String get tooltipCloseAd => 'Cerrar anuncio';

  @override
  String get tooltipClose => 'Cerrar';

  @override
  String get tooltipRescan => 'Volver a escanear documentos';

  @override
  String get tooltipSearch => 'Buscar documentos';

  @override
  String get tooltipSelectFiles => 'Seleccionar archivos';

  @override
  String get tooltipBack => 'Atrás';

  @override
  String get tooltipCancelSelection => 'Cancelar selección';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seleccionados',
      one: '1 seleccionado',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'Seleccionar todo';

  @override
  String get actionDeselectAll => 'Deseleccionar todo';

  @override
  String get tooltipDeleteSelected => 'Eliminar seleccionados';

  @override
  String get tooltipClearSearch => 'Borrar búsqueda';

  @override
  String get searchHint => 'Buscar documentos, carpetas...';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return 'Página $page de $total';
  }

  @override
  String get errorGenericTitle => 'Algo salió mal';

  @override
  String get actionRetry => 'Reintentar';

  @override
  String get permissionAllFilesTitle =>
      'Se requiere acceso a todos los archivos';

  @override
  String get permissionAllFilesExplanation =>
      'Doc View necesita acceso a todos los archivos para explorar carpetas y organizar tus documentos completamente sin conexión.';

  @override
  String get actionGrantAccess => 'Conceder acceso';

  @override
  String get actionImportFilesInstead => 'Importar archivos en su lugar';

  @override
  String get tooltipRemoveBookmark => 'Quitar marcador';

  @override
  String get tooltipAddBookmark => 'Añadir marcador';

  @override
  String tooltipFileOptions(String title) {
    return 'Opciones de archivo para $title';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return 'Carpeta, $name$subtitle';
  }

  @override
  String get adAdvertisementBadge => 'ANUNCIO';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get tabRecent => 'Recientes';

  @override
  String get tabBookmarks => 'Marcadores';

  @override
  String get filterCategoryAll => 'Todos';

  @override
  String get actionBrowse => 'Explorar';

  @override
  String get actionCancelOperation => 'Cancelar operación';

  @override
  String get operationComplete => 'Operación completada';

  @override
  String get actionOpenDocument => 'Abrir documento';

  @override
  String get actionShareDocument => 'Compartir documento';

  @override
  String get splashTagline => 'Todos tus documentos, en un solo lugar.';

  @override
  String appVersion(String version) {
    return 'Versión $version';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get actionSkip => 'Omitir';

  @override
  String get actionBack => 'Atrás';

  @override
  String get actionNext => 'Siguiente';

  @override
  String get actionGetStarted => 'Comenzar';

  @override
  String get onboardingPage1Title => 'Todos tus documentos,\nen un solo lugar';

  @override
  String get onboardingPage1Desc =>
      'Doc View encuentra automáticamente archivos PDF, Word, Excel, PowerPoint, texto e imágenes en tu teléfono y los organiza por ti.';

  @override
  String get onboardingPage2Title =>
      'Lee cualquier archivo,\ncon total comodidad';

  @override
  String get onboardingPage2Desc =>
      'Abre archivos PDF, Word, Excel y PowerPoint con un lector rápido y limpio. Busca, añade marcadores y continúa donde lo dejaste.';

  @override
  String get onboardingPage3Title => 'Potentes herramientas PDF, sin conexión';

  @override
  String get onboardingPage3Desc =>
      'Convierte fotos en PDF, escanea documentos, combina y divide archivos. Todo permanece en tu dispositivo.';

  @override
  String get onboardingOfflineGuarantee =>
      'Tus archivos permanecen en tu dispositivo';

  @override
  String get toolImageToPdf => 'Imagen a PDF';

  @override
  String get toolImageToPdfSub => 'Convertir JPG y PNG';

  @override
  String get toolScanToPdf => 'Escanear a PDF';

  @override
  String get toolScanToPdfSub => 'Detección de bordes con cámara';

  @override
  String get toolMergePdf => 'Combinar PDF';

  @override
  String get toolMergePdfSub => 'Unir en un solo archivo';

  @override
  String get toolSplitPdf => 'Dividir PDF';

  @override
  String get toolSplitPdfSub => 'Extraer cualquier intervalo';

  @override
  String get permissionTagStorage => 'Acceso al almacenamiento del dispositivo';

  @override
  String get permissionStorageHeadline =>
      'Deja que Doc View encuentre tus documentos';

  @override
  String get permissionStorageBody =>
      'Para mostrar archivos PDF, Word, Excel y otros archivos guardados por cualquier aplicación, Android necesita tu permiso para acceder a todos los archivos. Tus archivos nunca salen de tu teléfono.';

  @override
  String get permissionReassuranceOfflineTitle => 'Los archivos nunca se suben';

  @override
  String get permissionReassuranceOfflineDesc =>
      'Tus documentos se procesan de forma local en tu dispositivo.';

  @override
  String get permissionReassuranceNoUploadsTitle => 'Sin subidas a la nube';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      'Cero servidores en la nube. Tus archivos permanecen estrictamente en la memoria del teléfono.';

  @override
  String get permissionReassuranceChangeTitle =>
      'Puedes cambiar esto en cualquier momento';

  @override
  String get permissionReassuranceChangeDesc =>
      'Actívalo o desactívalo fácilmente en los ajustes del sistema de Android.';

  @override
  String get permissionTagIOS => 'Guía de almacenamiento en iOS';

  @override
  String get permissionIOSHeadline => 'Lleva tus documentos a Doc View';

  @override
  String get permissionIOSBody =>
      'Debido a la arquitectura de privacidad de Apple, iOS no permite que ninguna aplicación escanee todo tu teléfono automáticamente. Elige cómo quieres leer tus archivos:';

  @override
  String get permissionIOSOptionImportTitle => 'Importar archivos';

  @override
  String get permissionIOSBadgeFastest => 'MÁS RÁPIDO';

  @override
  String get permissionIOSOptionImportDesc =>
      'Elige documentos directamente desde iCloud Drive, Descargas o cualquier carpeta en segundos.';

  @override
  String get permissionIOSOptionFolderTitle =>
      'Abrir la carpeta de Doc View en la app Archivos';

  @override
  String get permissionIOSOptionFolderDesc =>
      'Guarda o envía documentos por AirDrop directamente a la carpeta \"Doc View\" en la app Archivos de iOS para una sincronización instantánea.';

  @override
  String get actionImportFiles => 'Importar archivos';

  @override
  String get actionContinueToApp => 'Continuar a la aplicación';

  @override
  String get permissionTagConsent => 'Transparencia y consentimiento';

  @override
  String get permissionBadgeFree => 'App 100 % gratuita';

  @override
  String get permissionBadgeMinimalAds => 'Anuncios mínimos';

  @override
  String get permissionConsentHeadline => 'Gratis con anuncios';

  @override
  String get permissionConsentBody =>
      'Doc View es gratis gracias a los anuncios. A continuación te preguntaremos tu preferencia sobre los anuncios personalizados.';

  @override
  String get permissionConsentAdsTitle => 'Qué anuncios podrías ver';

  @override
  String get permissionConsentAdsDesc =>
      'Pequeños banners y tarjetas patrocinadas no intrusivas. Sin ventanas emergentes ni interrupciones de vídeo mientras lees.';

  @override
  String get permissionConsentPrivateTitle =>
      'Los documentos siguen siendo totalmente privados';

  @override
  String get permissionConsentPrivateDesc =>
      'Los socios publicitarios nunca tienen acceso a los nombres de tus documentos, su contenido ni su ubicación.';

  @override
  String get permissionConsentSettingsTitle =>
      'Puedes cambiar tu elección en Ajustes';

  @override
  String get permissionConsentSettingsDesc =>
      'Actualiza el consentimiento de anuncios personalizados o tus preferencias de privacidad en cualquier momento en los Ajustes de Doc View.';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionPrivacyPolicy => 'Política de privacidad';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se importaron $count archivos',
      one: 'Se importó 1 archivo',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => 'Error al importar archivos';

  @override
  String get tooltipImportDocuments => 'Importar documentos';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos encontrados',
      one: '1 archivo encontrado',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => 'Escaneando...';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos',
      one: '1 archivo',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => 'Carpetas';

  @override
  String get errorLoadingRecent => 'Error al cargar los archivos recientes';

  @override
  String get emptyStateTitle => 'Vacío';

  @override
  String get emptyRecentDescription =>
      'Los archivos abiertos recientemente aparecerán aquí';

  @override
  String get errorLoadingBookmarks =>
      'Error al cargar los archivos con marcador';

  @override
  String get emptyBookmarksDescription =>
      'Los documentos con marcador aparecerán aquí';

  @override
  String get dialogDeleteTitle => '¿Eliminar los archivos seleccionados?';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Eliminar $count archivos? Esta acción no se puede deshacer.',
      one: '¿Eliminar 1 archivo? Esta acción no se puede deshacer.',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se eliminaron $count archivos',
      one: 'Se eliminó 1 archivo',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => 'Error al eliminar archivos';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get searchRecentSearchesHeader => 'BÚSQUEDAS RECIENTES';

  @override
  String get actionClear => 'Borrar';

  @override
  String get searchPromptTitle => 'Escribe para buscar documentos';

  @override
  String get searchPromptMessage =>
      'Busca en todas las carpetas locales por nombre de archivo o extensión';

  @override
  String get searchError => 'Error al buscar documentos';

  @override
  String get searchNoResultsTitle =>
      'No se encontraron documentos coincidentes';

  @override
  String get searchNoResultsMessage =>
      'Prueba a buscar con otra palabra clave del nombre o filtro de formato';

  @override
  String get tooltipSortOptions => 'Opciones de ordenación';

  @override
  String get sortSheetTitle => 'Ordenar por';

  @override
  String get sortOptionDate => 'Fecha de modificación';

  @override
  String get sortOptionName => 'Nombre del documento';

  @override
  String get sortOptionSize => 'Tamaño del archivo';

  @override
  String get sortAscendingOrder => 'Orden ascendente';

  @override
  String get sortAscendingSubtitle =>
      'Más antiguos primero / A a Z / Más pequeños primero';

  @override
  String get sortDescendingSubtitle =>
      'Más recientes primero / Z a A / Más grandes primero';

  @override
  String get categoryAllFiles => 'Todos los archivos';

  @override
  String get loadingStatus => 'Cargando...';

  @override
  String get emptyCategoryImagesTitle => 'No se encontraron imágenes';

  @override
  String get emptyCategoryImagesMessage =>
      'Las imágenes encontradas en este dispositivo aparecerán aquí';

  @override
  String get emptyCategoryDocsTitle => 'No se encontraron documentos';

  @override
  String get emptyCategoryDocsMessage =>
      'Los documentos de este formato aparecerán aquí después de escanear';

  @override
  String get actionOpen => 'Abrir';

  @override
  String get actionShare => 'Compartir';

  @override
  String get actionRename => 'Cambiar nombre';

  @override
  String get actionBookmark => 'Añadir marcador';

  @override
  String get actionRemoveBookmark => 'Quitar marcador';

  @override
  String get actionOpenInAnotherApp => 'Abrir en otra aplicación';

  @override
  String get actionDetails => 'Detalles';

  @override
  String get actionOpenFile => 'Abrir archivo';

  @override
  String get actionShareAll => 'Compartir todo';

  @override
  String get actionDone => 'Listo';

  @override
  String get actionSeeAll => 'Ver todo';

  @override
  String get actionAllow => 'Permitir';

  @override
  String get actionNotNow => 'Ahora no';

  @override
  String get tooltipMoreActions => 'Más acciones';

  @override
  String get tooltipCopyPath => 'Copiar ruta';

  @override
  String get tooltipRotatePage => 'Rotar página';

  @override
  String get tooltipRemovePage => 'Quitar página';

  @override
  String get renameFileTitle => 'Cambiar nombre del archivo';

  @override
  String get renameFileNameLabel => 'Nombre de archivo';

  @override
  String renamedSuccess(String fileName) {
    return 'Nombre cambiado a $fileName';
  }

  @override
  String get deleteFileTitle => '¿Eliminar archivo?';

  @override
  String deleteFileConfirmation(String fileName) {
    return '¿Eliminar \"$fileName\"? Esta acción no se puede deshacer.';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return 'Se eliminó \"$fileName\"';
  }

  @override
  String get fileDetailsTitle => 'Detalles del documento';

  @override
  String get fileDetailsLabelName => 'Nombre';

  @override
  String get fileDetailsLabelType => 'Tipo';

  @override
  String get fileDetailsLabelSize => 'Tamaño';

  @override
  String get fileDetailsLabelModified => 'Modificado';

  @override
  String get fileDetailsLabelBookmarked => 'En marcadores';

  @override
  String get fileDetailsValueYes => 'Sí';

  @override
  String get fileDetailsValueNo => 'No';

  @override
  String get fileDetailsLabelLocation => 'Ubicación';

  @override
  String get fileDetailsPathCopied => 'Ruta copiada al portapapeles';

  @override
  String get directoriesTitle => 'Directorios';

  @override
  String get directoriesGoBack => 'Volver';

  @override
  String get directoriesGoToRoot => 'Ir a la raíz';

  @override
  String get directoriesRetry => 'Reintentar';

  @override
  String get directoriesFileNoLongerExists => 'El archivo ya no existe';

  @override
  String get directoriesFolderNoLongerExists => 'Esta carpeta ya no existe.';

  @override
  String get directoriesNoDocsInFolder => 'No hay documentos en esta carpeta';

  @override
  String get directoriesFilesAppearHere =>
      'Los archivos aparecerán aquí en cuanto se añadan';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => 'Carpeta';

  @override
  String get directoriesPermissionPromptTitle =>
      'Se requiere acceso para ver los directorios';

  @override
  String get directoriesPermissionPromptBody =>
      'Doc View necesita acceso a todos los archivos para explorar tus carpetas.';

  @override
  String get directoriesGrantAccess => 'Conceder acceso';

  @override
  String get directoriesImportInstead => 'Importar archivos en su lugar';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se importaron $count archivos',
      one: 'Se importó 1 archivo',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => 'Subir un nivel';

  @override
  String get storageAccessRequiredTitle =>
      'Se requiere acceso al almacenamiento';

  @override
  String get storageAccessRequiredBody =>
      'Doc View necesita acceso al almacenamiento para escanear y mostrar los documentos (PDF, Word, Excel, PPT, TXT, imágenes) guardados en tu dispositivo.\n\nTus archivos permanecen completamente privados y sin conexión en tu dispositivo.';

  @override
  String errorCouldNotOpenDocument(String error) {
    return 'No se pudo abrir el documento: $error';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Escaneo completado: $count archivos',
      one: 'Escaneo completado: 1 archivo',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => '¿Borrar el historial de búsqueda?';

  @override
  String get dialogClearSearchMessage =>
      'Todas las búsquedas recientes se borrarán permanentemente.';

  @override
  String imageListEditorMaxLimit(int max) {
    return 'Se alcanzó el límite máximo de $max imágenes.';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return 'Error al escanear: $error';
  }

  @override
  String get imageListEditorPageSize => 'Tamaño de página:';

  @override
  String get imageListEditorA4Mode => 'A4';

  @override
  String get imageListEditorFitMode => 'Ajustar a la imagen';

  @override
  String get imageListEditorRemoveImageTooltip => 'Quitar imagen';

  @override
  String get mergeScreenTitle => 'Organizar y combinar';

  @override
  String get mergeScreenDefaultMergedName => 'Documento_combinado';

  @override
  String get mergePickerSearchHint => 'Buscar archivos PDF...';

  @override
  String get mergePickerNext => 'Siguiente';

  @override
  String mergePickerErrorLoading(String error) {
    return 'Error al cargar los archivos PDF: $error';
  }

  @override
  String get splitScreenTitle => 'Dividir PDF';

  @override
  String get splitScreenRangeHint => 'p. ej., 1-3, 5, 8-10';

  @override
  String get splitScreenClearRange => 'Borrar intervalo';

  @override
  String get splitPickerSearchHint => 'Buscar archivos PDF...';

  @override
  String splitPickerErrorLoading(String error) {
    return 'Error al cargar los archivos: $error';
  }

  @override
  String get createdSectionTitle => 'Creados por ti';

  @override
  String get createdSectionEmptyTitle => 'Los PDF que crees aparecerán aquí';

  @override
  String get createdSectionEmptySubtitle =>
      'Los documentos convertidos, escaneados o combinados se guardarán localmente.';

  @override
  String get emptyCreatedDocsTitle => 'Aún no hay documentos creados';

  @override
  String get emptyCreatedDocsMessage =>
      'Los documentos convertidos, escaneados o combinados aparecerán aquí.';

  @override
  String errorLoadingCreatedFiles(String error) {
    return 'Error al cargar los archivos creados: $error';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDF creados',
      one: 'PDF creado',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle => 'Guardado en tu carpeta Creados';

  @override
  String get toolErrorDefaultTitle => 'No se pudo crear el PDF';

  @override
  String get toolErrorSubtitle =>
      'Ocurrió un error inesperado durante el procesamiento';

  @override
  String get themeSheetTitle => 'Tema de la aplicación';

  @override
  String get themeSheetSubtitle =>
      'Selecciona la apariencia visual de Doc View';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeSystemSubtitle => 'predeterminado';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeLightSubtitle => 'Blanco limpio';

  @override
  String get themeModeDark => 'Oscuro';

  @override
  String get themeModeDarkSubtitle => 'Azul marino profundo';

  @override
  String get themeActionApply => 'Aplicar tema';

  @override
  String get scanSettingsTitle => 'Ajustes de escaneo';

  @override
  String get scanSettingsFrequencyHeader => 'Frecuencia de escaneo';

  @override
  String get scanSettingsOnOpenTitle => 'Escanear al abrir la aplicación';

  @override
  String get scanSettingsOnOpenSubtitle =>
      'Encuentra archivos nuevos automáticamente cuando abras Doc View.';

  @override
  String get scanSettingsManualTitle => 'Solo manual';

  @override
  String get scanSettingsManualSubtitle =>
      'Escanea únicamente al deslizar para actualizar o tocar Volver a escanear.';

  @override
  String get scanSettingsMediaFiltersHeader => 'Filtros multimedia';

  @override
  String get scanSettingsIncludeImagesTitle => 'Incluir imágenes en el escaneo';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      'Indexa archivos de imagen PNG, JPG y WEBP del almacenamiento.';

  @override
  String get scanSettingsDiagnosticsHeader => 'Almacenamiento y diagnósticos';

  @override
  String get scanSettingsPermissionStatus => 'Acceso a todos los archivos';

  @override
  String get scanSettingsPermissionGranted => 'Concedido';

  @override
  String get scanSettingsPermissionNotGranted => 'No concedido';

  @override
  String get scanSettingsTotalIndexed => 'Archivos indexados';

  @override
  String get scanSettingsLastScan => 'Último escaneo';

  @override
  String get scanSettingsUpdatedSnackbar => 'Ajustes de escaneo actualizados';

  @override
  String get faqScreenTitle => 'Preguntas frecuentes';

  @override
  String faqHeaderTopics(int count) {
    return '$count temas';
  }

  @override
  String get faqHeaderSubtitle =>
      '¿Tienes dudas? Encuentra respuestas claras aquí.';

  @override
  String get faqSendFeedback => 'Enviar comentarios';

  @override
  String get faqQuestion1 =>
      '¿Por qué Doc View necesita acceso a todos los archivos?';

  @override
  String get faqAnswer1 =>
      'Doc View requiere acceso a todos los archivos (MANAGE_EXTERNAL_STORAGE) en Android 11 o superior para detectar e indexar documentos compatibles (PDF, Word, Excel, PowerPoint, texto e imágenes) almacenados en carpetas compartidas como Descargas y Documentos.\n\nSin este permiso, Android restringe el acceso a la carpeta interna privada de la aplicación, lo que impide que Doc View explore o abra archivos ubicados en tu dispositivo.';

  @override
  String get faqQuestion2 => '¿Por qué no escanea todo mi iPhone?';

  @override
  String get faqAnswer2 =>
      'iOS utiliza un aislamiento estricto de aplicaciones (sandbox) para proteger la privacidad del dispositivo. Las aplicaciones solo pueden acceder a los documentos guardados explícitamente dentro de la app Archivos o compartidos mediante el menú Compartir del sistema.\n\nPara ver archivos en iOS, impórtalos a la carpeta Doc View en la app nativa Archivos o usa la opción Importar archivos en Ajustes.';

  @override
  String get faqQuestion3 => '¿Dónde se guardan los PDF que creo?';

  @override
  String get faqAnswer3 =>
      'Los archivos que importas o generas (como PDF convertidos, documentos combinados o páginas divididas) se guardan de forma segura en el almacenamiento de tu dispositivo, en DocView/Created o en el almacenamiento privado de la aplicación. Puedes verlos en cualquier momento en la sección Creados por ti de la pestaña Herramientas.';

  @override
  String get faqQuestion4 => '¿Por qué mi archivo de Word se ve diferente?';

  @override
  String get faqAnswer4 =>
      'Doc View renderiza los archivos directamente en tu dispositivo usando analizadores locales sin conexión, sin enviar datos privados a convertidores en la nube. El formato complejo o las formas personalizadas se muestran mediante aproximaciones nativas sin conexión.';

  @override
  String get faqQuestion5 => '¿Puedo abrir archivos protegidos con contraseña?';

  @override
  String get faqAnswer5 =>
      'Sí, Doc View permite abrir documentos PDF protegidos con contraseña. Al abrir un PDF cifrado, introduce la contraseña en el cuadro de diálogo para descifrar y ver el documento en tu dispositivo.';

  @override
  String get faqQuestion6 => '¿Se suben mis datos a algún sitio?';

  @override
  String get faqAnswer6 =>
      'Tus documentos nunca salen de tu dispositivo. Doc View abre, convierte y almacena los archivos localmente. La aplicación muestra anuncios ofrecidos por Google AdMob, que puede usar datos limitados del dispositivo según se describe en nuestra Política de privacidad.';

  @override
  String get faqQuestion7 => '¿Por qué PDF a Word cambió mi diseño?';

  @override
  String get faqAnswer7 =>
      'Doc View convierte únicamente el texto en tu dispositivo. No se conservan tablas, imágenes, colores ni el diseño. Los PDF escaneados no se pueden convertir porque no contienen texto legible.';

  @override
  String get toolPdfToWord => 'PDF a Word';

  @override
  String get toolPdfToWordSub => 'Convertir PDF en documento de Word editable';

  @override
  String get pdfToWordScreenTitle => 'PDF a Word';

  @override
  String get pdfToWordBannerText =>
      'Solo se convierte el texto. No se conservan tablas, imágenes, colores ni diseño.';

  @override
  String get pdfToWordPageBreaks =>
      'Insertar saltos de página entre páginas del PDF';

  @override
  String get pdfToWordPageBreaksSubtitle =>
      'Conserva la estructura del documento entre páginas';

  @override
  String get pdfToWordSelectPdf => 'Seleccionar PDF';

  @override
  String get pdfToWordChangeFile => 'Cambiar archivo';

  @override
  String get pdfToWordConvertAction => 'Convertir a Word';

  @override
  String get pdfToWordConverting => 'Convirtiendo a Word...';

  @override
  String pdfToWordConvertingProgress(int current, int total) {
    return 'Convirtiendo página $current de $total...';
  }

  @override
  String get pdfToWordSuccess => 'Convertido a Word correctamente';

  @override
  String get pdfToWordOpenInViewer => 'Abrir en Doc View';

  @override
  String get pdfToWordOpenWith => 'Abrir con...';

  @override
  String get pdfToWordShare => 'Compartir';

  @override
  String get pdfToWordNoTextTitle => 'No se encontró texto';

  @override
  String get pdfToWordNoTextMessage =>
      'No se encontró texto en este PDF. Los documentos escaneados no se pueden convertir.';

  @override
  String get pdfToWordLargeFileWarning =>
      'Documento grande: la conversión puede tardar varios minutos.';

  @override
  String get pdfToWordInvalidFileName => 'Nombre de archivo no válido';

  @override
  String get pdfToWordActionCancel => 'Cancelar';

  @override
  String get pdfToWordEncryptedError =>
      'El PDF seleccionado está protegido con contraseña. Desbloquéalo para convertirlo.';

  @override
  String get pdfToWordPageLimitError =>
      'El documento supera el límite de 1.000 páginas.';

  @override
  String get pdfToWordTextLimitError =>
      'El documento supera el límite de 20 MB de texto.';

  @override
  String get pdfToWordGeneralError =>
      'No se pudo convertir el PDF a Word. Prueba con otro archivo.';

  @override
  String get pdfGotoPageTitle => 'Ir a la página';

  @override
  String pdfGotoPageHint(int pageCount) {
    return 'Introduce una página entre 1 y $pageCount';
  }

  @override
  String get pdfGotoPageAction => 'Ir';

  @override
  String get pdfGotoPageErrorEmpty => 'Introduce un número de página';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return 'Introduce una página entre 1 y $pageCount';
  }

  @override
  String get pdfPasswordTitle => 'Este PDF está protegido con contraseña';

  @override
  String get pdfPasswordSubtitle =>
      'Introduce la contraseña para ver y descifrar el contenido.';

  @override
  String get pdfPasswordHint => 'Introducir contraseña';

  @override
  String get pdfPasswordErrorIncorrect =>
      'Contraseña incorrecta. Inténtalo de nuevo.';

  @override
  String get pdfPasswordActionUnlock => 'Desbloquear';

  @override
  String get errorFileNameEmpty => 'El nombre de archivo no puede estar vacío';

  @override
  String get errorFileNameTooLong =>
      'El nombre de archivo no puede superar los 120 caracteres';

  @override
  String get errorFileNameReserved =>
      'El nombre de archivo no puede ser \'.\' ni \'..\'';

  @override
  String get errorFileNameStartsWithDot =>
      'El nombre de archivo no puede empezar por un punto';

  @override
  String get errorFileNameInvalidChars =>
      'El nombre de archivo contiene caracteres no válidos';

  @override
  String get errorRenameAlreadyExists =>
      'Ya existe un archivo con este nombre en esta carpeta';

  @override
  String get errorRenameSourceNotFound =>
      'El archivo de origen ya no existe en el disco';

  @override
  String errorRenameFailed(String details) {
    return 'Error al cambiar el nombre del archivo: $details';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      'Los archivos se eliminaron del disco, pero falló la actualización de la base de datos';

  @override
  String errorDeleteFailed(String details) {
    return 'Error al eliminar archivos: $details';
  }

  @override
  String get errorPageRangeDocNoPages => 'El documento no tiene páginas';

  @override
  String get errorPageRangeEmpty =>
      'El intervalo de páginas no puede estar vacío';

  @override
  String get errorPageRangeEmptySegment =>
      'Se encontró un segmento de intervalo vacío. Quita las comas sobrantes.';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return 'Formato de intervalo no válido: \'$token\'';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return 'Intervalo incompleto: \'$token\'';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return 'Valores no numéricos en el intervalo: \'$token\'';
  }

  @override
  String get errorPageRangeBelowMinimum =>
      'Los números de página deben ser 1 o mayores';

  @override
  String errorPageRangeReversed(int start, int end) {
    return 'Intervalo invertido \'$start-$end\': el inicio es mayor que el final';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return 'El intervalo \'$token\' supera el total de páginas ($totalPages)';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return 'Número de página no válido: \'$token\'';
  }

  @override
  String get errorImageToPdfNoImages => 'Selecciona al menos una imagen';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return 'Se permite un máximo de $max imágenes a la vez';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return 'Error al procesar la imagen: $path';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return 'Error al crear el PDF a partir de las imágenes: $details';
  }

  @override
  String get errorPdfMergeInsufficient =>
      'Selecciona al menos 2 archivos PDF para combinar';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return '$fileName está protegido con contraseña o dañado';
  }

  @override
  String get errorPdfMergeNoPages =>
      'Los documentos seleccionados no contienen páginas';

  @override
  String errorPdfMergeFailed(String details) {
    return 'Error al combinar los PDF: $details';
  }

  @override
  String get errorPdfSplitNoRanges =>
      'Especifica al menos un intervalo de páginas';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return '$fileName está protegido con contraseña o dañado';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return 'El intervalo $start-$end está fuera de los límites para $fileName';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return 'Error al dividir el PDF: $details';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return 'PÁG. $current/$total';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '($bytes bytes)';
  }

  @override
  String get directoriesProtectedTitle =>
      'Esta carpeta está protegida por Android.';

  @override
  String get directoriesProtectedDesc =>
      'Android restringe el acceso a las carpetas del sistema y privadas de aplicaciones.';

  @override
  String get directoriesNotFoundTitle => 'Esta carpeta ya no existe.';

  @override
  String get directoriesEmpty =>
      'No hay archivos ni carpetas compatibles aquí.';

  @override
  String get directoriesErrorOpening => 'Error al abrir la carpeta';

  @override
  String get directoriesRoot => 'Raíz';

  @override
  String get scanSettingsSectionFrequency => 'Frecuencia de escaneo';

  @override
  String get scanSettingsSectionFilters => 'Filtros de documentos';

  @override
  String get scanSettingsIncludeImages => 'Incluir imágenes';

  @override
  String get scanSettingsIncludeImagesDesc =>
      'Desactívalo para ocultar miles de fotos de tu lista de documentos';

  @override
  String get scanSettingsImageListUpdated => 'Lista de imágenes actualizada';

  @override
  String get scanSettingsActionRescanNow => 'Volver a escanear ahora';

  @override
  String get scanSettingsSectionDiagnostics => 'Diagnósticos de almacenamiento';

  @override
  String get scanSettingsAllFilesAccessGranted =>
      'Acceso a todos los archivos concedido';

  @override
  String get scanSettingsAllFilesAccessNeeded =>
      'Se necesita acceso a todos los archivos';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      'Doc View tiene permiso para detectar archivos en Descargas y tarjetas SD.';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      'Se requiere permiso para escanear las carpetas de descargas y almacenamiento externo.';

  @override
  String get scanSettingsActionOpenSettings => 'Abrir ajustes';

  @override
  String scanSettingsScanningFiles(int count) {
    return 'Escaneando... $count archivos encontrados';
  }

  @override
  String get faqStillNeedHelp => '¿Aún necesitas ayuda? Envía tus comentarios';

  @override
  String get toolsLabelFileName => 'Nombre de archivo';

  @override
  String get toolsAddImagesToStart => 'Añade imágenes para empezar';

  @override
  String get toolsAddImagesDesc =>
      'Selecciona fotos o escanea documentos en papel para generar un PDF.';

  @override
  String get toolsChoosePhotos => 'Elegir fotos';

  @override
  String get toolsScanPaper => 'Escanear papel';

  @override
  String toolsPageNumber(int page) {
    return 'Página $page';
  }

  @override
  String get toolsTooltipRotatePage => 'Rotar página';

  @override
  String get toolsTooltipRemovePage => 'Quitar página';

  @override
  String get toolsAddMoreScans => 'Añadir más escaneos';

  @override
  String get toolsAddMoreImages => 'Añadir más imágenes';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imágenes · aprox. ~ $size',
      one: '1 imagen · aprox. ~ $size',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return '$count seleccionados';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return 'Selecciona al menos $min archivos';
  }

  @override
  String toolsPagesTotal(int count) {
    return '$count páginas en total';
  }

  @override
  String get toolsPagesTotalLabel => 'páginas en total';

  @override
  String get toolsNoPdfsFound => 'No se encontraron documentos PDF';

  @override
  String get semanticBookmarked => 'en marcadores';

  @override
  String get semanticSelected => 'seleccionado';

  @override
  String get semanticNotSelected => 'no seleccionado';

  @override
  String get actionDeselectFile => 'Deseleccionar archivo';

  @override
  String get actionSelectFile => 'Seleccionar archivo';

  @override
  String get actionCreatePdf => 'Crear PDF';

  @override
  String get hintSelectOrViewActions => 'Seleccionar o ver acciones';

  @override
  String get actionClose => 'Cerrar';

  @override
  String get actionReset => 'Restablecer';

  @override
  String get labelPleaseWait => 'Por favor, espera...';

  @override
  String get tooltipCloseSearch => 'Cerrar búsqueda';

  @override
  String get semanticAdvertisement => 'Anuncio';

  @override
  String get themePreviewLight => 'Claro';

  @override
  String get themePreviewNavy => 'Marino';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '$name, $size, creado el $date';
  }

  @override
  String get toolsCreatingPdfFromScans => 'Creando PDF a partir de escaneos';

  @override
  String get toolsCreatingPdf => 'Creando PDF';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return 'Procesando imagen $done de $total...';
  }

  @override
  String get toolsErrorCreatePdfTitle => 'No se pudo crear el PDF';

  @override
  String get toolsBadgeProtectedOrDamaged => 'Protegido o dañado';

  @override
  String toolsPageCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas',
      one: '1 página',
    );
    return '$_temp0';
  }

  @override
  String get toolsPagesAbbrev => 'págs.';

  @override
  String get mergeAddMoreTitle => 'Añadir más PDF';

  @override
  String get mergeProgressTitle => 'Combinando PDF';

  @override
  String mergeProgressMessage(int done, int total) {
    return 'Combinando documento $done de $total...';
  }

  @override
  String get mergeErrorTitle => 'No se pudieron combinar los PDF';

  @override
  String get mergeDragInstruction => 'Arrastra los tiradores para reordenar';

  @override
  String get mergeAddPdf => 'Añadir PDF';

  @override
  String get mergeOutputFileNameLabel => 'NOMBRE DEL ARCHIVO DE SALIDA';

  @override
  String mergeItemPageCountAndSize(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas · $size',
      one: '1 página · $size',
    );
    return '$_temp0';
  }

  @override
  String mergeItemLoadingPagesAndSize(String size) {
    return 'Cargando páginas... · $size';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se detectaron $count archivos no válidos',
      one: 'Se detectó 1 archivo no válido',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => 'Listo para combinar';

  @override
  String get mergeRemoveProtectedHint =>
      'Quita los documentos protegidos con contraseña';

  @override
  String mergeSummary(int files, int pages, String size) {
    return '$files archivos · $pages páginas · ~ $size';
  }

  @override
  String get mergeReadyBadge => 'Listo';

  @override
  String get mergeBlockedCta => 'Combinación bloqueada (resuelve los errores)';

  @override
  String mergeActionCta(int files, int pages) {
    return 'Combinar $files PDF ($pages páginas)';
  }

  @override
  String get mergePickerDefaultTitle => 'Seleccionar PDF';

  @override
  String mergePickerTabAllPdfs(int count) {
    return 'Todos los PDF ($count)';
  }

  @override
  String get mergePickerTabRecent => 'Recientes';

  @override
  String get mergePickerTabDownloads => 'Descargas';

  @override
  String get mergePickerTabICloud => 'iCloud Drive';

  @override
  String get splitProgressTitle => 'Dividiendo PDF';

  @override
  String splitProgressMessage(int done, int total) {
    return 'Generando archivo $done de $total...';
  }

  @override
  String get splitErrorTitle => 'No se pudo dividir el PDF';

  @override
  String get splitPageRangesLabel => 'INTERVALOS DE PÁGINAS';

  @override
  String get splitPageRangesSyntax => 'Sintaxis: 1-3, 5, 8-10';

  @override
  String get splitRangeHelpText =>
      'Cada intervalo se convierte en un archivo PDF independiente.';

  @override
  String splitGeneratedFilesHeader(int count) {
    return 'ARCHIVOS GENERADOS ($count)';
  }

  @override
  String get splitChipsSuspendedTitle => 'Etiquetas interactivas suspendidas';

  @override
  String get splitChipsSuspendedDesc =>
      'Corrige el error de sintaxis anterior para reconstruir el proceso de extracción.';

  @override
  String get splitEmptyRangesHint =>
      'Introduce intervalos de páginas arriba para generar fragmentos PDF';

  @override
  String splitChipSinglePage(int page) {
    return 'Página $page';
  }

  @override
  String splitChipPageRange(int start, int end) {
    return 'Páginas $start–$end';
  }

  @override
  String splitChipPageCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count págs.',
      one: '1 pág.',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => 'SELECCIÓN RÁPIDA';

  @override
  String get splitMacroAllPages => 'Todas las páginas';

  @override
  String get splitMacroEvery5Pages => 'Cada 5 páginas';

  @override
  String get splitMacroLimitHint =>
      'Las macros que producen > 100 archivos están desactivadas para proteger la memoria del dispositivo';

  @override
  String splitOutputSummary(int files, int pages) {
    return 'Salida: $files archivos · $pages páginas extraídas';
  }

  @override
  String splitEstSize(String size) {
    return 'APROX. ~ $size';
  }

  @override
  String splitActionCtaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dividir en $count PDF',
      one: 'Dividir en 1 PDF',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => 'Dividir en PDF';

  @override
  String splitPickerAllLocalDocs(int count) {
    return 'TODOS LOS DOCUMENTOS LOCALES ($count)';
  }

  @override
  String get splitPickerSortByDate => 'ORDENAR POR FECHA';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return 'págs. · $size';
  }

  @override
  String get splitPickerTitle => 'Seleccionar PDF para dividir';

  @override
  String get faqShortTitle => 'Preguntas frecuentes';

  @override
  String splitPickerSelectedCount(int count) {
    return '$count PDF seleccionado';
  }

  @override
  String get splitPickerSelectDocumentHint =>
      'Selecciona un documento para continuar';

  @override
  String splitPickerPagesActive(int count) {
    return '$count páginas activas';
  }

  @override
  String get splitPickerPagesActiveLabel => 'páginas activas';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionOthers => 'Otros';

  @override
  String get settingsFileManagerTitle => 'Gestor de archivos';

  @override
  String get settingsFileManagerSubtitle =>
      'Explorar directorios y carpetas del almacenamiento';

  @override
  String get settingsFaqTitle => 'Preguntas frecuentes';

  @override
  String get settingsFaqSubtitle => 'Preguntas frecuentes';

  @override
  String get settingsShareTitle => 'Compartir';

  @override
  String get settingsShareSubtitle => 'Recomienda Doc View a tus amigos';

  @override
  String settingsShareMessage(String url) {
    return 'Prueba Doc View: un lector de documentos rápido, privado y sin conexión: $url';
  }

  @override
  String get settingsScanSettingsTitle => 'Ajustes de escaneo';

  @override
  String get settingsScanModeOnOpen => 'Escanear al abrir';

  @override
  String get settingsScanModeManual => 'Solo manual';

  @override
  String get settingsAppThemeTitle => 'Tema de la aplicación';

  @override
  String get settingsThemeSystem => 'Predeterminado del sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsRateUsTitle => 'Califícanos';

  @override
  String get settingsRateUsSubtitle => 'Comparte tus comentarios con nosotros';

  @override
  String get settingsAddWidgetTitle => 'Añadir widget';

  @override
  String get settingsAddWidgetSubtitle =>
      'Acceso rápido desde tu pantalla de inicio';

  @override
  String get settingsTermsTitle => 'Términos de uso';

  @override
  String get settingsTermsSubtitle => 'Lee nuestros términos de servicio';

  @override
  String get settingsPrivacyTitle => 'Política de privacidad';

  @override
  String get settingsPrivacySubtitle => 'Lee nuestra política de privacidad';

  @override
  String get settingsManageSubscriptionsTitle => 'Gestionar suscripciones';

  @override
  String get settingsManageSubscriptionsSubtitle =>
      'Gestiona tu suscripción de la tienda';

  @override
  String settingsVersionDisplay(String version, String build) {
    return 'Versión $version ($build)';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return 'Versión $version compilación $build';
  }

  @override
  String get settingsOpenSourceLicenses => 'Licencias de código abierto';

  @override
  String get rateSheetTitle => 'Califica Doc View';

  @override
  String get rateSheetSubtitle => 'Tus comentarios nos ayudan a mejorar';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estrellas',
      one: '1 estrella',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => '¡Nos alegra que te guste!';

  @override
  String get rateResponseMedium => '¡Gracias! Cuéntanos cómo podemos mejorar.';

  @override
  String get rateResponseLow =>
      'Sentimos que no cumpliera tus expectativas. Dinos qué debemos corregir.';

  @override
  String get rateActionStore => 'Calificar en Google Play';

  @override
  String get rateActionHelpFeedback => 'Ayuda y comentarios';

  @override
  String get faqFromRatingBanner =>
      'Sentimos oír eso. Consulta las respuestas a continuación o contáctanos; leemos todos los mensajes.';

  @override
  String get faqActionContactUs => 'Contáctanos';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return 'Comentarios sobre Doc View ($version+$build)';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '\n\n---\nAplicación: Doc View $version (Compilación $build)\n';
  }

  @override
  String get faqEmailClientUnavailable =>
      'No se pudo abrir el cliente de correo electrónico';

  @override
  String get languageScreenTitle => 'Idioma';

  @override
  String get languageSearchHint => 'Buscar idiomas...';

  @override
  String get languageSystemDefault => 'Predeterminado del sistema';

  @override
  String get languageSystemDefaultSubtitle =>
      'Seguir el idioma del dispositivo';

  @override
  String get languageNotTranslatedBadge => '(sin traducir)';

  @override
  String get languageNotTranslatedSnack => 'Este idioma aún no está traducido';

  @override
  String get languageNoResults => 'No hay idiomas que coincidan';

  @override
  String get languagePseudoLocaleName => 'Pseudoconfiguración regional (en_XA)';

  @override
  String get languagePseudoLocaleSubtitle =>
      'Pruebas de depuración de expansión';

  @override
  String get scanSettingsSectionHistory => 'Historial';

  @override
  String get scanSettingsClearHistoryTitle => 'Borrar historial reciente';

  @override
  String get scanSettingsClearHistorySubtitle =>
      'Borrar el historial de documentos abiertos';

  @override
  String get scanSettingsClearHistoryDialogTitle =>
      '¿Borrar el historial reciente?';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      'Los archivos se quitarán de Recientes. Tus archivos y marcadores no se verán afectados.';

  @override
  String get scanSettingsRecentHistoryCleared => 'Historial reciente borrado';

  @override
  String get scanSettingsLastScanToday => 'hoy';

  @override
  String get scanSettingsLastScanYesterday => 'ayer';

  @override
  String get scanSettingsNeverScanned => 'Nunca escaneado';

  @override
  String get scanSettingsLastScanPrefix => 'Último escaneo:';

  @override
  String get readerActionVertical => 'Vertical';

  @override
  String get readerActionHorizontal => 'Horizontal';

  @override
  String get readerActionRotate => 'Rotar';

  @override
  String get readerActionSearch => 'Buscar';

  @override
  String get readerActionInvert => 'Invertir';

  @override
  String get readerActionShare => 'Compartir';

  @override
  String get readerActionPages => 'Páginas';

  @override
  String get readerSearchHint => 'Buscar en el documento...';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '$current de $total';
  }

  @override
  String get readerSearchMatchCap => '500+';

  @override
  String get readerSearchNoMatches => '0 de 0';

  @override
  String get readerSearchNoTextLayer =>
      'Este PDF no tiene texto seleccionable para buscar';

  @override
  String get readerSearchPrevMatch => 'Coincidencia anterior';

  @override
  String get readerSearchNextMatch => 'Siguiente coincidencia';

  @override
  String readerTopPagesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas • $size',
      one: '1 página • $size',
    );
    return '$_temp0';
  }

  @override
  String get readerMenuGoToPage => 'Ir a la página';

  @override
  String get readerMenuAddBookmark => 'Añadir marcador';

  @override
  String get readerMenuRemoveBookmark => 'Quitar marcador';

  @override
  String get readerMenuDetails => 'Detalles';

  @override
  String get readerMenuOpenInAnotherApp => 'Abrir en otra aplicación';

  @override
  String get readerTooltipConvertToWord => 'Convertir a Word';

  @override
  String get pagesScreenTitle => 'Páginas';

  @override
  String pagesScreenPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas',
      one: '1 página',
    );
    return '$_temp0';
  }

  @override
  String get pagesActionSelectAll => 'Seleccionar todo';

  @override
  String get pagesActionClearSelection => 'Borrar';

  @override
  String get pagesActionSave => 'Guardar';

  @override
  String get pagesActionInsert => 'Insertar';

  @override
  String get pagesActionRotate => 'Rotar';

  @override
  String get pagesActionExtract => 'Extraer';

  @override
  String get pagesActionDelete => 'Eliminar';

  @override
  String get pagesActionUndo => 'Deshacer';

  @override
  String get pagesInsertSheetTitle => 'Insertar páginas';

  @override
  String get pagesInsertPagesFromPdf => 'Páginas de otro PDF';

  @override
  String get pagesDeleteAllBlocked =>
      'No se pueden eliminar todas las páginas. Un documento debe tener al menos una página.';

  @override
  String get pagesSaveDialogTitle => 'Guardar cambios';

  @override
  String get pagesSaveAsNew => 'Guardar como archivo nuevo';

  @override
  String get pagesSaveReplace => 'Reemplazar el original';

  @override
  String get pagesSaveReplaceWarning => 'Esto sobrescribe el archivo original.';

  @override
  String get pagesSaveFileNameLabel => 'Nombre de archivo';

  @override
  String get pagesDiscardDialogTitle => '¿Descartar cambios?';

  @override
  String get pagesDiscardDialogBody =>
      'Tienes cambios sin guardar. ¿Seguro que quieres descartarlos?';

  @override
  String get pagesDiscardButton => 'Descartar';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se extrajeron $count páginas',
      one: 'Se extrajo 1 página',
    );
    return '$_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      'Este PDF no se puede editar porque está cifrado o ilegible.';

  @override
  String get viewerErrorCorruptTitle => 'No se puede abrir este documento';

  @override
  String get viewerErrorCorruptMessage =>
      'Este archivo parece estar dañado o no es un documento válido.';

  @override
  String get viewerErrorMissingTitle => 'Este archivo ya no existe';

  @override
  String get viewerErrorMissingMessage =>
      'El archivo se ha eliminado o movido del almacenamiento del dispositivo.';

  @override
  String get viewerErrorBackToFiles => 'Volver a archivos';

  @override
  String get viewerErrorNoAppFound =>
      'No se encontró ninguna aplicación para abrir este archivo';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count coincidencias',
      one: '1 coincidencia',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unidades • $ext',
      one: '1 unidad • $ext',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner => 'Formato heredado: solo texto';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      'Libro grande: se muestran las primeras 20.000 filas y 100 columnas';

  @override
  String viewerSectionTitle(int number) {
    return 'Sección $number';
  }

  @override
  String get viewerMenuOutline => 'Esquema';

  @override
  String get viewerOutlineTitle => 'Esquema del documento';

  @override
  String get viewerCloseOutline => 'Cerrar esquema';

  @override
  String get viewerNoSections =>
      'No se encontraron secciones en este documento';

  @override
  String get viewerOutlineTooltip => 'Índice';

  @override
  String get viewerActionOpenExternal => 'Abrir en otra aplicación';

  @override
  String get viewerErrorCantOpenTitle => 'No se puede abrir este documento';

  @override
  String get viewerErrorCantOpenMessage =>
      'No se pudo renderizar el documento sin conexión.';

  @override
  String get viewerOpeningDocument => 'Abriendo documento...';

  @override
  String get viewerErrorEncryptedTitle => 'Este documento está cifrado';

  @override
  String get viewerErrorEncryptedMessage =>
      'Los archivos protegidos con contraseña no se pueden ver en el lector sin conexión.';

  @override
  String get viewerErrorTooLargeTitle =>
      'Este archivo supera el límite de visualización';

  @override
  String get viewerErrorTooLargeMessage =>
      'Los documentos grandes deben abrirse con un visor de Office externo.';

  @override
  String get viewerErrorUnsupportedFormatTitle =>
      'Este formato no es compatible';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      'Doc View no puede analizar este formato de archivo directamente.';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => 'Tipografía';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get txtViewerMonospaceLabel => 'Fuente monoespaciada';

  @override
  String get txtViewerTruncationBanner =>
      'El archivo supera 1 MB: se muestra el primer 1 MB';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count líneas • $size',
      one: '1 línea • $size',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => 'Ajustes de tipografía';

  @override
  String get txtViewerTooltipDecreaseFont => 'Reducir tamaño de fuente';

  @override
  String get txtViewerTooltipIncreaseFont => 'Aumentar tamaño de fuente';

  @override
  String get txtViewerTooltipToggleMonospace => 'Alternar fuente monoespaciada';

  @override
  String get txtViewerMonospaceSubtitle =>
      'Caracteres de ancho fijo para código y registros';

  @override
  String get txtViewerPreviewLabel => 'Vista previa';

  @override
  String get txtViewerPreviewText =>
      'El veloz murciélago hindú comía feliz cardillo y kiwi.';

  @override
  String get txtViewerErrorTitle => 'No se puede leer este archivo de texto';

  @override
  String get txtViewerErrorMessage =>
      'No se pudo analizar el formato o la codificación del archivo.';

  @override
  String get txtViewerActionRetry => 'Reintentar';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '$width × $height • $size';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get imageViewerTooltipFitToScreen => 'Ajustar a la pantalla';

  @override
  String get imageViewerErrorCorrupt => 'No se pudo cargar la imagen';

  @override
  String get imageViewerLoading => 'Cargando imagen…';

  @override
  String get viewerDispatcherFileMissing => 'El archivo ya no existe';

  @override
  String get viewerSpreadsheetFormulaBarEmpty => '-';

  @override
  String get viewerSpreadsheetAllCells => 'Todas';

  @override
  String viewerSpreadsheetColumnLabel(String col) {
    return 'Columna $col';
  }

  @override
  String viewerSpreadsheetRowLabel(int row) {
    return 'Fila $row';
  }

  @override
  String viewerSpreadsheetCellSemantics(String col, int row, String value) {
    return 'Columna $col, fila $row, $value';
  }

  @override
  String get viewerSpreadsheetEmptyCell => 'vacía';

  @override
  String get viewerSpreadsheetEmptySheet => 'Esta hoja está vacía';

  @override
  String get viewerSpreadsheetCopiedSingle => 'Celda copiada';

  @override
  String viewerSpreadsheetCopiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count celdas copiadas',
      one: '1 celda copiada',
    );
    return '$_temp0';
  }

  @override
  String get viewerSpreadsheetCopyLimitReached =>
      'Selección truncada a 5.000 celdas';

  @override
  String get viewerSpreadsheetCellContentTitle => 'Contenido de la celda';

  @override
  String get viewerSpreadsheetCopyAction => 'Copiar';

  @override
  String get viewerSpreadsheetCloseAction => 'Cerrar';

  @override
  String viewerSpreadsheetZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get viewerSpreadsheetResetZoomTooltip => 'Restablecer zoom al 100 %';

  @override
  String get viewerSpreadsheetNoMatches => 'No hay coincidencias en esta hoja';

  @override
  String get viewerSpreadsheetSearchPlaceholder => 'Buscar en la hoja…';

  @override
  String get viewerSpreadsheetPasswordTitle =>
      'Archivo protegido con contraseña';

  @override
  String get viewerSpreadsheetPasswordMessage =>
      'Los archivos protegidos con contraseña no se pueden abrir aquí.';

  @override
  String get viewerSpreadsheetErrorTitle =>
      'No se puede leer esta hoja de cálculo';

  @override
  String get viewerSpreadsheetCorruptMessage =>
      'El archivo de hoja de cálculo está dañado o no se pudo decodificar.';

  @override
  String get viewerSpreadsheetTimeoutMessage =>
      'Se agotó el tiempo de espera al abrir la hoja de cálculo tras 20 segundos.';

  @override
  String get viewerSpreadsheetTooLargeMessage =>
      'Este archivo supera el límite de visualización de 25 MB.';

  @override
  String get viewerSpreadsheetOpenBasicViewer => 'Abrir en el visor básico';

  @override
  String get viewerSpreadsheetOpenAnotherApp => 'Abrir en otra aplicación';

  @override
  String get toolsWorkspaceOverline => 'ESPACIO DE TRABAJO';

  @override
  String get toolsTitle => 'Herramientas';

  @override
  String get toolsSectionConvertCreate => 'CONVERTIR Y CREAR';

  @override
  String get toolsSectionEditManage => 'EDITAR Y GESTIONAR';

  @override
  String get toolsSectionOthers => 'OTROS';

  @override
  String get toolsCreatedByYou => 'Creados por ti';

  @override
  String get toolsCreatedByYouEmpty => 'Los PDF que crees aparecerán aquí';

  @override
  String get toolsCreatedByYouSeeAll => 'Ver todo';

  @override
  String get toolManagePages => 'Gestionar páginas';

  @override
  String get toolManagePagesSub => 'Reordenar, rotar y eliminar';

  @override
  String get toolImportFiles => 'Importar archivos';

  @override
  String get toolImportFilesSub => 'Añadir desde otras apps';

  @override
  String get toolPrintPdf => 'Imprimir PDF';

  @override
  String get toolPrintPdfSub => 'Enviar a cualquier impresora';

  @override
  String get toolCreatePdf => 'Crear PDF';

  @override
  String get toolCreatePdfSub => 'Documento en blanco o plantilla';

  @override
  String get toolRecycleBin => 'Papelera de reciclaje';

  @override
  String get toolRecycleBinSub => 'Restaurar archivos eliminados';

  @override
  String get toolAnnotate => 'Anotar';

  @override
  String get toolAnnotateSub => 'Resaltar, dibujar y marcar';

  @override
  String get toolAddText => 'Añadir texto';

  @override
  String get toolAddTextSub => 'Insertar texto y fechas';

  @override
  String get toolSign => 'Firmar';

  @override
  String get toolSignSub => 'Rellenar y firmar formularios';

  @override
  String get toolWordToPdf => 'Word a PDF';

  @override
  String get toolWordToPdfSub => 'Convertir DOCX a PDF';

  @override
  String get toolPptToPdf => 'PPT a PDF';

  @override
  String get toolPptToPdfSub => 'Convertir PPTX a PDF';

  @override
  String get printPdfErrorTooLarge =>
      'El archivo PDF supera el límite de impresión de 50 MB.';

  @override
  String get printPdfErrorUnreadable =>
      'No se puede leer el PDF para imprimir.';

  @override
  String get printPdfErrorPassword =>
      'No se puede imprimir directamente un PDF protegido con contraseña.';

  @override
  String get printPdfErrorFailed => 'Error al imprimir.';

  @override
  String get printPdfSuccess => 'Documento enviado a la impresora.';

  @override
  String get toolPickerTitleSelectPdf => 'Seleccionar PDF';

  @override
  String get toolPickerTitleSelectPdfs => 'Seleccionar PDF';

  @override
  String get toolPickerBrowseFiles => 'Explorar archivos';

  @override
  String get toolPickerTabAll => 'Todos los PDF';

  @override
  String get toolPickerTabRecent => 'Recientes';

  @override
  String get toolPickerTabDownloads => 'Descargas';

  @override
  String get toolPickerTabICloud => 'iCloud Drive';

  @override
  String get toolPickerActionPrint => 'Imprimir';

  @override
  String get toolPickerActionManage => 'Gestionar';

  @override
  String get toolPickerActionSelect => 'Seleccionar';

  @override
  String get toolsImportActionView => 'Ver';

  @override
  String get createPdfTemplateBlank => 'En blanco';

  @override
  String get createPdfTemplateLine1 => 'Línea 1';

  @override
  String get createPdfTemplateLine2 => 'Línea 2';

  @override
  String get createPdfTemplateNotebook => 'Cuaderno';

  @override
  String get createPdfTemplateCornell => 'Cornell';

  @override
  String get createPdfTemplateGrid => 'Cuadrícula';

  @override
  String get createPdfTemplateGraph => 'Milimetrado';

  @override
  String get createPdfSwatchWhite => 'Blanco';

  @override
  String get createPdfSwatchCream => 'Crema';

  @override
  String get createPdfSwatchLightYellow => 'Amarillo claro';

  @override
  String get createPdfSwatchLightPeach => 'Melocotón claro';

  @override
  String get createPdfSwatchLightPink => 'Rosa claro';

  @override
  String get createPdfSwatchLightLavender => 'Lavanda claro';

  @override
  String get createPdfSwatchLightBlue => 'Azul claro';

  @override
  String get createPdfSwatchLightMint => 'Menta claro';

  @override
  String get createPdfSwatchLightGreen => 'Verde claro';

  @override
  String get createPdfSwatchLightGray => 'Gris claro';

  @override
  String get createPdfOrientationPortrait => 'Vertical';

  @override
  String get createPdfOrientationLandscape => 'Horizontal';

  @override
  String get createPdfSectionTemplate => 'PLANTILLA';

  @override
  String get createPdfSectionPageSize => 'TAMAÑO DE PÁGINA';

  @override
  String get createPdfSectionOrientation => 'ORIENTACIÓN';

  @override
  String get createPdfSectionPageColor => 'COLOR DE PÁGINA';

  @override
  String get createPdfSectionPageCount => 'NÚMERO DE PÁGINAS';

  @override
  String createPdfPagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas',
      one: '1 página',
    );
    return '$_temp0';
  }

  @override
  String createPdfSummary(String pages, String size, String orientation) {
    return '$pages • $size • $orientation';
  }

  @override
  String get createPdfCreating => 'Generando PDF...';

  @override
  String createPdfProgress(int done, int total) {
    return 'Creando página $done de $total...';
  }

  @override
  String get createPdfErrorTitle => 'No se puede crear el PDF';

  @override
  String get createPdfErrorPageCount =>
      'El número de páginas debe estar entre 1 y 100.';

  @override
  String get createPdfErrorInvalidName =>
      'Introduce un nombre de archivo válido.';

  @override
  String get createPdfErrorGeneration =>
      'Error al generar el documento PDF. Inténtalo de nuevo.';

  @override
  String get trashErrorTooLarge =>
      'El archivo es demasiado grande para la Papelera de reciclaje (límite de 200 MB)';

  @override
  String get trashErrorNotEnoughSpace =>
      'No hay suficiente espacio de almacenamiento en la Papelera de reciclaje';

  @override
  String trashErrorGeneric(String details) {
    return 'Error en la operación de la Papelera de reciclaje: $details';
  }

  @override
  String get trashDialogMoveTitle => '¿Mover a la Papelera de reciclaje?';

  @override
  String trashDialogMoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '¿Mover $count archivos a la Papelera de reciclaje? Podrás restaurarlos desde Herramientas > Papelera de reciclaje durante 30 días.',
      one:
          '¿Mover 1 archivo a la Papelera de reciclaje? Podrás restaurarlo desde Herramientas > Papelera de reciclaje durante 30 días.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionMove => 'Mover a la Papelera';

  @override
  String trashMovedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se movieron $count archivos a la Papelera de reciclaje',
      one: 'Se movió 1 archivo a la Papelera de reciclaje',
    );
    return '$_temp0';
  }

  @override
  String get trashActionUndo => 'Deshacer';

  @override
  String trashRestoredSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se restauraron $count archivos',
      one: 'Se restauró 1 archivo',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogDeleteForeverTitle => '¿Eliminar para siempre?';

  @override
  String trashDialogDeleteForeverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '¿Eliminar $count archivos para siempre? Esta acción no se puede deshacer.',
      one:
          '¿Eliminar 1 archivo para siempre? Esta acción no se puede deshacer.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionDeleteForever => 'Eliminar para siempre';

  @override
  String trashDeletedForeverSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se eliminaron $count archivos para siempre',
      one: 'Se eliminó 1 archivo para siempre',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogEmptyTitle => '¿Vaciar la Papelera de reciclaje?';

  @override
  String trashDialogEmptyBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'los $count archivos',
      one: '1 archivo',
    );
    return '¿Eliminar $_temp0 para siempre? Esta acción no se puede deshacer.';
  }

  @override
  String get trashActionEmptyBin => 'Vaciar papelera';

  @override
  String get trashEmptyTitle => 'La Papelera de reciclaje está vacía';

  @override
  String get trashEmptySubtitle =>
      'Los archivos movidos a la Papelera de reciclaje permanecerán aquí 30 días antes de eliminarse permanentemente.';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Quedan $count días',
      one: 'Queda 1 día',
    );
    return '$_temp0';
  }

  @override
  String trashSubtitle(String date, String size) {
    return 'Eliminado el $date · $size';
  }

  @override
  String get trashDialogTooLargeTitle => 'Demasiado grande para la Papelera';

  @override
  String trashDialogTooLargeBody(String fileName) {
    return '\"$fileName\" supera los 200 MB y no se puede mover a la Papelera de reciclaje. ¿Quieres eliminarlo permanentemente?';
  }

  @override
  String get trashActionDeletePermanently => 'Eliminar permanentemente';

  @override
  String get trashInfoBanner =>
      'Los elementos de la Papelera de reciclaje se eliminan permanentemente después de 30 días.';

  @override
  String get trashSheetRestore => 'Restaurar';

  @override
  String get trashSheetDeleteForever => 'Eliminar para siempre';

  @override
  String get trashSheetDetails => 'Detalles';

  @override
  String get trashDetailsOriginalLocation => 'Ubicación original';

  @override
  String get trashDetailsDateDeleted => 'Fecha de eliminación';

  @override
  String get trashDetailsExpiresIn => 'Caduca en';

  @override
  String trashRestoredToFallbackSuccess(String location) {
    return 'Restaurado en $location (no se encontró la carpeta original)';
  }

  @override
  String get trashDialogCopyFailedTitle =>
      'No se pudo mover a la Papelera de reciclaje';

  @override
  String trashDialogCopyFailedBody(String fileName) {
    return 'No se pudo mover \"$fileName\" a la Papelera de reciclaje. ¿Quieres eliminarlo permanentemente? Esta acción no se puede deshacer.';
  }

  @override
  String get trashDialogEmptyProgress => 'Vaciando la Papelera de reciclaje...';

  @override
  String get trashDialogMoveProgress =>
      'Moviendo archivos a la Papelera de reciclaje...';

  @override
  String get trashDialogNotEnoughSpaceTitle =>
      'No hay suficiente espacio de almacenamiento';

  @override
  String get trashDialogNotEnoughSpaceBody =>
      'No hay suficiente espacio de almacenamiento para moverlo a la Papelera de reciclaje. Libera espacio vaciando la papelera.';

  @override
  String get trashActionFreeUpSpace => 'Liberar espacio';

  @override
  String get trashDialogDeleteForeverProgress =>
      'Eliminando archivos para siempre...';

  @override
  String get galleryDebugAgeTrash =>
      'Envejecer todos los elementos de la papelera 29 días';

  @override
  String get galleryDebugSlowCopy => 'Copia lenta a papelera (pruebas)';

  @override
  String get galleryDebugSlowCopySubtitle =>
      'Limita el bucle de copia a ~20 MB/s para pruebas de cierre';

  @override
  String get galleryDebugSlowSave => 'Guardado lento del editor (pruebas)';

  @override
  String get galleryDebugSlowSaveSubtitle =>
      'Limita el bucle de guardado a ~8 s para pruebas de cierre';

  @override
  String get galleryDebugSaveAnnotate =>
      'Guardar muestra de 100 págs. (prueba Anotar)';

  @override
  String get galleryDebugSaveSign =>
      'Guardar muestra de 100 págs. (prueba Firmar)';

  @override
  String get galleryDebugSaveText =>
      'Guardar muestra de 100 págs. (prueba Añadir texto)';

  @override
  String get galleryDebugMove190Mb =>
      'Mover archivo de prueba de 190 MB a la papelera';

  @override
  String get galleryDebugRestoreLastTrash =>
      'Restaurar el último elemento de la papelera';

  @override
  String get galleryDebugEmptyTrash => 'Vaciar Papelera de reciclaje';

  @override
  String galleryDebugAgeTrashSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se envejecieron $count elementos',
      one: 'Se envejeció 1 elemento',
    );
    return '$_temp0 29 días';
  }

  @override
  String get annotateErrorPasswordProtected =>
      'Este PDF está protegido con contraseña.';

  @override
  String get annotateErrorCorrupt => 'Este PDF está dañado o no se puede leer.';

  @override
  String get annotateSignedReplaceBlocked =>
      'No se permite reemplazar el PDF original firmado. Guárdalo como un archivo nuevo.';

  @override
  String annotateErrorSaveFailed(String details) {
    return 'Error al guardar las anotaciones: $details';
  }

  @override
  String get annotateErrorScannedPdf =>
      'Este documento parece estar escaneado o no contiene texto seleccionable.';

  @override
  String get annotateSignedBanner =>
      'PDF firmado digitalmente: Al guardar se creará una nueva copia para conservar la firma.';

  @override
  String get annotateActionSaveNew => 'Guardar como archivo nuevo';

  @override
  String get annotateActionReplace => 'Reemplazar el original';

  @override
  String get annotateDiscardDialogTitle =>
      '¿Descartar las anotaciones sin guardar?';

  @override
  String get annotateDiscardDialogBody =>
      'Tienes marcas sin guardar. Si sales ahora, se perderán tus cambios.';

  @override
  String get annotateDiscardDialogActionDiscard => 'Descartar';

  @override
  String get annotateDiscardDialogActionKeep => 'Seguir editando';

  @override
  String get annotateSaveSuccess => 'Anotaciones guardadas correctamente';

  @override
  String get annotateToolbarHighlight => 'Resaltar';

  @override
  String get annotateToolbarUnderline => 'Subrayar';

  @override
  String get annotateToolbarStrikethrough => 'Tachar';

  @override
  String get annotateToolbarCopy => 'Copiar';

  @override
  String get annotateColorYellow => 'Amarillo';

  @override
  String get annotateColorGreen => 'Verde';

  @override
  String get annotateColorCyan => 'Cian';

  @override
  String get annotateColorPink => 'Rosa';

  @override
  String get annotateColorOrange => 'Naranja';

  @override
  String get annotateSaveTitle => 'Guardar anotaciones';

  @override
  String get annotateSaveProgress => 'Guardando anotaciones...';

  @override
  String get annotateNoChanges => 'No hay anotaciones para guardar';

  @override
  String get annotateTooltipUndo => 'Deshacer';

  @override
  String get annotateTooltipRedo => 'Rehacer';

  @override
  String get annotateTooltipSave => 'Guardar';

  @override
  String get annotateCopiedToClipboard => 'Copiado al portapapeles';

  @override
  String get annotateToolbarPen => 'Bolígrafo';

  @override
  String get annotatePenTipBanner =>
      'Dibuja con un dedo. Desplaza y haz zoom con dos dedos.';

  @override
  String get annotatePenSheetTitle => 'Ajustes del bolígrafo';

  @override
  String get annotatePenStrokeWidth => 'Grosor del trazo';

  @override
  String get annotatePenEraserMode => 'Borrador';

  @override
  String get annotateColorBlack => 'Negro';

  @override
  String get annotateColorRed => 'Rojo';

  @override
  String get annotateColorPurple => 'Morado';

  @override
  String get annotateColorBlue => 'Azul';

  @override
  String get toolSignPdf => 'Firmar PDF';

  @override
  String get toolSignPdfSubtitle => 'Añade firma y fecha a los documentos';

  @override
  String get signToolbarSign => 'Firmar';

  @override
  String get signToolbarDate => 'Fecha';

  @override
  String get signToolbarClearAll => 'Borrar todo';

  @override
  String get signPadTitle => 'Dibuja tu firma';

  @override
  String get signPadClear => 'Borrar';

  @override
  String get signPadSave => 'Guardar firma';

  @override
  String get signSheetTitle => 'Firmas guardadas';

  @override
  String get signSheetCreateNew => 'Crear nueva firma';

  @override
  String get signMaxSignaturesReached =>
      'Se alcanzó el máximo de 5 firmas guardadas';

  @override
  String get signMaxPlacedReached =>
      'Se alcanzó el máximo de 20 firmas por documento';

  @override
  String get signDeleteSignatureTitle => '¿Eliminar firma?';

  @override
  String get signDeleteSignatureBody =>
      'Esta firma se eliminará de tus firmas guardadas.';

  @override
  String get signConfirmClearAllTitle => '¿Borrar todas las firmas?';

  @override
  String get signConfirmClearAllBody =>
      'Se eliminarán todas las firmas y fechas colocadas en este documento.';

  @override
  String get signSaveSuccess => 'Documento firmado correctamente';

  @override
  String get signNoSignaturesToSave =>
      'No hay firmas colocadas en el documento';

  @override
  String get signPlacedSignatureDelete => 'Eliminar';

  @override
  String get signPlacedSignatureApply => 'Aplicar';

  @override
  String get signTooltipUndo => 'Deshacer';

  @override
  String get signTooltipRedo => 'Rehacer';

  @override
  String get signTooltipSave => 'Guardar';

  @override
  String annotatePenStrokeWidthValue(String width) {
    return '$width pt';
  }

  @override
  String get annotateErrorTooManyStrokes =>
      'El documento ha alcanzado el máximo de 5.000 trazos o 300.000 puntos.';

  @override
  String annotateChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cambios',
      one: '1 cambio',
    );
    return '$_temp0';
  }

  @override
  String get annotatePenNotice =>
      'Los trazos de bolígrafo pasan a formar parte de la página al guardar y no se pueden editar después.';

  @override
  String get annotatePenNoticeDismiss => 'Entendido';

  @override
  String get signPadBaselineHint => 'Firma aquí';

  @override
  String get signPadUndo => 'Deshacer';

  @override
  String get signPadUseOnce => 'Usar una vez';

  @override
  String get signPadSaveAndUse => 'Guardar y usar';

  @override
  String get tool_add_text => 'Añadir texto';

  @override
  String get tool_add_text_desc =>
      'Inserta cuadros de texto y notas en las páginas';

  @override
  String get addTextNoticePermanent =>
      'El texto añadido pasa a formar parte de la página y no se puede editar después de guardar.';

  @override
  String get addTextNoticeRaster =>
      'El texto en este idioma se añade como imagen y no se puede seleccionar.';

  @override
  String get addTextNoticeGotIt => 'Entendido';

  @override
  String get addTextActionAdd => 'Añadir texto';

  @override
  String get addTextActionStyle => 'Estilo';

  @override
  String get addTextActionDelete => 'Eliminar';

  @override
  String get addTextStyleSheetTitle => 'Estilo del texto';

  @override
  String get addTextFontSize => 'Tamaño de fuente';

  @override
  String get addTextColor => 'Color';

  @override
  String get addTextStyle => 'Estilo';

  @override
  String get addTextAlign => 'Alineación';

  @override
  String get addTextBold => 'Negrita';

  @override
  String get addTextItalic => 'Cursiva';

  @override
  String get addTextAlignStart => 'Inicio';

  @override
  String get addTextAlignCenter => 'Centro';

  @override
  String get addTextAlignEnd => 'Fin';

  @override
  String get addTextErrorTooManyBoxes =>
      'Se alcanzó el máximo de 30 cuadros de texto';

  @override
  String get addTextErrorBoxTooLong =>
      'El cuadro de texto no puede superar los 2.000 caracteres';

  @override
  String get addTextPlaceholder => 'Escribe el texto aquí';

  @override
  String get addTextSamplePreview => 'Vista previa de ejemplo';

  @override
  String addTextFontSizePt(int size) {
    return '$size pt';
  }

  @override
  String get premiumTitle => 'Doc View Premium';

  @override
  String get premiumSubtitle =>
      'Desbloquea las herramientas Anotar y Firmar y disfruta de una experiencia totalmente sin anuncios.';

  @override
  String get premiumFeatureAllTools => 'Herramientas PDF de anotación y firma';

  @override
  String get premiumFeatureAllToolsSub =>
      'Dibuja marcas, resalta documentos y firma PDF sin esfuerzo';

  @override
  String get premiumFeatureAdFree => 'Experiencia 100 % sin anuncios';

  @override
  String get premiumFeatureAdFreeSub =>
      'Sin banners, interrupciones ni distracciones en ningún lugar';

  @override
  String get premiumFeatureUnlimitedConversions =>
      'Conversiones locales ilimitadas';

  @override
  String get premiumFeatureUnlimitedConversionsSub =>
      'Convierte documentos en tu dispositivo sin límite de archivos';

  @override
  String get premiumFeaturePrivacyFirst => '100 % privado y en tu dispositivo';

  @override
  String get premiumFeaturePrivacyFirstSub =>
      'Los archivos se procesan localmente y nunca se suben a ningún servidor';

  @override
  String get premiumPlanYearly => 'Suscripción anual';

  @override
  String premiumPlanYearlyTrial(int days, String price) {
    return '$days días gratis, luego $price/año';
  }

  @override
  String get premiumPlanMonthly => 'Suscripción mensual';

  @override
  String premiumPlanMonthlySub(String price) {
    return '$price/mes';
  }

  @override
  String premiumPlanYearlySub(String price) {
    return '$price/año';
  }

  @override
  String premiumPlanMonthlyTrial(int days, String price) {
    return '$days días gratis, luego $price/mes';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Ahorra un $percent%';
  }

  @override
  String get premiumSaveUnknown => 'Ahorra un -%';

  @override
  String premiumActionStartTrial(int days) {
    return 'Iniciar prueba gratis de $days días';
  }

  @override
  String get premiumSubscriptionsAvailableSoon =>
      'Las suscripciones estarán disponibles pronto.';

  @override
  String get pagesEditPagesAction => 'Editar páginas';

  @override
  String get premiumCancelAnytime => 'Cancela en cualquier momento';

  @override
  String get premiumPendingStatus =>
      'Google Play está procesando tu compra. Las ventajas se activarán una vez confirmada.';

  @override
  String get premiumRenewalDisclosurePricingUnavailable =>
      'Se renueva automáticamente. Google Play confirmará el precio al finalizar la compra. Cancela en cualquier momento en Suscripciones de Google Play.';

  @override
  String get premiumActionSubscribe => 'Suscribirse';

  @override
  String get premiumActionRestore => 'Restaurar compras';

  @override
  String get premiumBillingDisclaimer =>
      'Se renueva automáticamente. Cancela en cualquier momento en Suscripciones de Google Play.';

  @override
  String get premiumTerms => 'Términos de servicio';

  @override
  String get premiumPrivacy => 'Política de privacidad';

  @override
  String get premiumActiveStatus => 'Eres suscriptor Premium';

  @override
  String get premiumGraceStatus => 'Periodo de gracia sin conexión activo';

  @override
  String get premiumExpiredStatus => 'Suscripción caducada';

  @override
  String get premiumRestoreSuccess => 'Compras restauradas correctamente.';

  @override
  String get premiumRestoreNone => 'No se encontraron suscripciones activas.';

  @override
  String get premiumErrorGeneral =>
      'No se pudo completar la compra. Inténtalo de nuevo.';

  @override
  String get premiumPagesGateTitle => 'Doc View Premium';

  @override
  String get premiumPagesGateBody =>
      'Reordenar, rotar y eliminar páginas requiere una suscripción Premium.';

  @override
  String get premiumPagesGateUpgrade => 'Mejorar a Premium';

  @override
  String get premiumTooltip => 'Doc View Premium';

  @override
  String get premiumManageInPlay => 'Gestionar';

  @override
  String get faqQuestion8 => '¿Qué incluye Doc View Premium?';

  @override
  String get faqAnswer8 =>
      'Doc View Premium desbloquea todas las herramientas avanzadas de edición de documentos, incluidas la reordenación, rotación y eliminación de páginas PDF, la conversión de PDF a Word, las anotaciones, las firmas y la inserción de texto personalizado, además de eliminar por completo todos los anuncios de la aplicación. Todo el procesamiento de documentos sigue realizándose 100 % en tu dispositivo.';

  @override
  String get faqQuestion9 =>
      '¿Puedo usar Doc View Premium sin conexión a Internet?';

  @override
  String get faqAnswer9 =>
      'Sí. Una vez activada, Doc View almacena de forma segura en caché el estado de tu suscripción en tu dispositivo con un periodo de gracia sin conexión de hasta 7 días consecutivos. Puedes seguir usando todas las herramientas de edición sin conexión durante este periodo.';

  @override
  String get galleryDebugIapSectionTitle =>
      '15. Simulador de IAP y Premium (G7)';

  @override
  String get galleryDebugIapStateFree => 'Establecer Gratis';

  @override
  String get galleryDebugIapStateYearly => 'Establecer Premium anual';

  @override
  String get galleryDebugIapStateMonthly => 'Establecer Premium mensual';

  @override
  String get galleryDebugIapStateGrace =>
      'Establecer gracia sin conexión (activa)';

  @override
  String get galleryDebugIapStateGraceExpired =>
      'Establecer gracia sin conexión (caducada)';

  @override
  String get galleryDebugOpenPremium => 'Abrir pantalla /premium';

  @override
  String get galleryDebugIapProductSeenTrue =>
      'Establecer producto visto: Verdadero';

  @override
  String get galleryDebugIapProductSeenFalse =>
      'Establecer producto visto: Falso';

  @override
  String get addWidgetSheetTitle => 'Añadir a la pantalla de inicio';

  @override
  String get addWidgetSheetSubtitle =>
      'Elige un widget para añadirlo a tu pantalla de inicio';

  @override
  String get widgetRecentFilesTitle => 'Archivos recientes';

  @override
  String get widgetRecentFilesBadge => '4 × 2';

  @override
  String get widgetRecentFilesDesc =>
      'Consulta y abre tus archivos usados recientemente directamente desde tu pantalla de inicio';

  @override
  String get widgetQuickToolsTitle => 'Herramientas rápidas';

  @override
  String get widgetQuickToolsBadge => '4 × 1';

  @override
  String get widgetQuickToolsDesc =>
      'Ve directamente a Escanear, Imagen a PDF, Buscar o Importar';

  @override
  String get addWidgetButton => 'Añadir widget';

  @override
  String get addWidgetManualTitle => 'Añadir widget manualmente';

  @override
  String get addWidgetManualMessage =>
      'Mantén pulsado un espacio vacío en tu pantalla de inicio, toca Widgets, busca Doc View y arrástralo a tu pantalla.';

  @override
  String get settingsQuickAccessNotificationTitle =>
      'Notificación de acceso rápido';

  @override
  String get settingsQuickAccessNotificationSubtitle =>
      'Mostrar herramientas rápidas en la barra de notificaciones';

  @override
  String get notificationPermissionDialogTitle => 'Permitir notificaciones';

  @override
  String get notificationPermissionDialogDesc =>
      'Doc View necesita permiso de notificaciones para mostrar la barra de acceso rápido en tu bandeja de notificaciones.';

  @override
  String get notificationTitle => 'Herramientas rápidas de Doc View';

  @override
  String get notificationBody => 'Escanea, convierte o busca documentos';

  @override
  String get notificationActionScan => 'Escanear';

  @override
  String get notificationActionImageToPdf => 'Imagen a PDF';

  @override
  String get notificationActionSearch => 'Buscar';

  @override
  String get settingsAdChoicesTitle => 'Opciones de anuncios';

  @override
  String get settingsAdChoicesSubtitle =>
      'Gestionar preferencias de privacidad y publicidad';

  @override
  String get faqQuestion10 => '¿Por qué Doc View muestra anuncios?';

  @override
  String get faqAnswer10 =>
      'Los anuncios permiten que Doc View sea gratis. Premium los elimina. Los anuncios los ofrece Google AdMob y nunca ven tus documentos.';
}
