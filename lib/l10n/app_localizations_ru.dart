// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Doc View';

  @override
  String get navHome => 'Все файлы';

  @override
  String get navTools => 'Инструменты';

  @override
  String get navSettings => 'Настройки';

  @override
  String get noDocumentSelected => 'Документ не выбран';

  @override
  String get tooltipCloseAd => 'Закрыть рекламу';

  @override
  String get tooltipClose => 'Закрыть';

  @override
  String get tooltipRescan => 'Повторить сканирование';

  @override
  String get tooltipSearch => 'Поиск документов';

  @override
  String get tooltipSelectFiles => 'Выбрать файлы';

  @override
  String get tooltipBack => 'Назад';

  @override
  String get tooltipCancelSelection => 'Отменить выбор';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано: $count',
      one: 'Выбрано: 1',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'Выбрать все';

  @override
  String get actionDeselectAll => 'Снять выделение';

  @override
  String get tooltipDeleteSelected => 'Удалить выбранное';

  @override
  String get tooltipClearSearch => 'Очистить поиск';

  @override
  String get searchHint => 'Поиск документов, папок...';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return 'Страница $page из $total';
  }

  @override
  String get errorGenericTitle => 'Что-то пошло не так';

  @override
  String get actionRetry => 'Повторить';

  @override
  String get permissionAllFilesTitle => 'Требуется доступ ко всем файлам';

  @override
  String get permissionAllFilesExplanation =>
      'Приложению Doc View нужен доступ ко всем файлам, чтобы просматривать папки и систематизировать ваши документы полностью офлайн.';

  @override
  String get actionGrantAccess => 'Предоставить доступ';

  @override
  String get actionImportFilesInstead => 'Импортировать файлы';

  @override
  String get tooltipRemoveBookmark => 'Удалить из закладок';

  @override
  String get tooltipAddBookmark => 'Добавить в закладки';

  @override
  String tooltipFileOptions(String title) {
    return 'Действия для файла $title';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return 'Папка, $name$subtitle';
  }

  @override
  String get adAdvertisementBadge => 'РЕКЛАМА';

  @override
  String get actionConfirm => 'Подтвердить';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get tabRecent => 'Недавние';

  @override
  String get tabBookmarks => 'Закладки';

  @override
  String get filterCategoryAll => 'Все';

  @override
  String get actionBrowse => 'Обзор';

  @override
  String get actionCancelOperation => 'Отменить операцию';

  @override
  String get operationComplete => 'Операция завершена';

  @override
  String get actionOpenDocument => 'Открыть документ';

  @override
  String get actionShareDocument => 'Поделиться документом';

  @override
  String get splashTagline => 'Все ваши документы в одном месте.';

  @override
  String appVersion(String version) {
    return 'Версия $version';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'Шаг $current из $total';
  }

  @override
  String get actionSkip => 'Пропустить';

  @override
  String get actionBack => 'Назад';

  @override
  String get actionNext => 'Далее';

  @override
  String get actionGetStarted => 'Начать';

  @override
  String get onboardingPage1Title => 'Все ваши документы\nв одном месте';

  @override
  String get onboardingPage1Desc =>
      'Doc View автоматически находит PDF, Word, Excel, PowerPoint, текстовые файлы и изображения на вашем телефоне и удобно их организует.';

  @override
  String get onboardingPage2Title => 'Удобное чтение\nлюбых файлов';

  @override
  String get onboardingPage2Desc =>
      'Открывайте PDF, Word, Excel и PowerPoint в быстром и лаконичном просмотрщике. Ищите текст, добавляйте закладки и продолжайте с того места, где остановились.';

  @override
  String get onboardingPage3Title => 'Мощные инструменты PDF офлайн';

  @override
  String get onboardingPage3Desc =>
      'Превращайте фото в PDF, сканируйте документы, объединяйте и разделяйте файлы. Всё остаётся на вашем устройстве.';

  @override
  String get onboardingOfflineGuarantee =>
      'Ваши файлы остаются на вашем устройстве';

  @override
  String get toolImageToPdf => 'Фото в PDF';

  @override
  String get toolImageToPdfSub => 'Конвертация JPG и PNG';

  @override
  String get toolScanToPdf => 'Скан в PDF';

  @override
  String get toolScanToPdfSub => 'Автопоиск краёв камерой';

  @override
  String get toolMergePdf => 'Объединить PDF';

  @override
  String get toolMergePdfSub => 'Склеить в один файл';

  @override
  String get toolSplitPdf => 'Разделить PDF';

  @override
  String get toolSplitPdfSub => 'Извлечь нужные страницы';

  @override
  String get permissionTagStorage => 'Доступ к хранилищу';

  @override
  String get permissionStorageHeadline =>
      'Разрешите Doc View найти ваши документы';

  @override
  String get permissionStorageBody =>
      'Чтобы отображать PDF, Word, Excel и другие файлы, сохранённые другими приложениями, Android требуется разрешение на доступ ко всем файлам. Ваши файлы никогда не покидают телефон.';

  @override
  String get permissionReassuranceOfflineTitle => 'Файлы никуда не загружаются';

  @override
  String get permissionReassuranceOfflineDesc =>
      'Ваши документы обрабатываются локально на устройстве.';

  @override
  String get permissionReassuranceNoUploadsTitle => 'Без передачи в сеть';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      'Никаких облачных серверов. Файлы остаются строго в памяти телефона.';

  @override
  String get permissionReassuranceChangeTitle =>
      'Настройку можно изменить в любой момент';

  @override
  String get permissionReassuranceChangeDesc =>
      'Легко переключайте доступ в системных настройках приложений Android.';

  @override
  String get permissionTagIOS => 'Хранилище на iOS';

  @override
  String get permissionIOSHeadline => 'Добавьте документы в Doc View';

  @override
  String get permissionIOSBody =>
      'Из-за политики конфиденциальности Apple iOS не позволяет приложениям автоматически сканировать весь телефон. Выберите способ добавления файлов:';

  @override
  String get permissionIOSOptionImportTitle => 'Импорт файлов';

  @override
  String get permissionIOSBadgeFastest => 'БЫСТРЕЕ ВСЕГО';

  @override
  String get permissionIOSOptionImportDesc =>
      'Выбирайте документы напрямую из iCloud Drive, «Загрузок» или любой другой папки за считанные секунды.';

  @override
  String get permissionIOSOptionFolderTitle =>
      'Открыть папку Doc View в приложении «Файлы»';

  @override
  String get permissionIOSOptionFolderDesc =>
      'Сохраняйте или отправляйте через AirDrop документы прямо в папку «Doc View» в приложении «Файлы» на iOS для мгновенного доступа.';

  @override
  String get actionImportFiles => 'Импортировать файлы';

  @override
  String get actionContinueToApp => 'Перейти в приложение';

  @override
  String get permissionTagConsent => 'Прозрачность и согласие';

  @override
  String get permissionBadgeFree => '100% бесплатно';

  @override
  String get permissionBadgeMinimalAds => 'Минимум рекламы';

  @override
  String get permissionConsentHeadline => 'Бесплатно благодаря рекламе';

  @override
  String get permissionConsentBody =>
      'Приложение Doc View остаётся бесплатным за счёт рекламы. Далее мы попросим выбрать настройки персонализации рекламы.';

  @override
  String get permissionConsentAdsTitle => 'Какую рекламу вы можете увидеть';

  @override
  String get permissionConsentAdsDesc =>
      'Небольшие баннеры и ненавязчивые карточки спонсоров. Никаких всплывающих окон и видеороликов во время чтения.';

  @override
  String get permissionConsentPrivateTitle =>
      'Документы полностью конфиденциальны';

  @override
  String get permissionConsentPrivateDesc =>
      'Рекламные партнёры никогда не получают доступ к названиям, содержимому или расположению ваших файлов.';

  @override
  String get permissionConsentSettingsTitle =>
      'Выбор можно изменить в Настройках';

  @override
  String get permissionConsentSettingsDesc =>
      'Обновляйте согласие на персонализацию рекламы и настройки приватности в любое время в настройках Doc View.';

  @override
  String get actionContinue => 'Продолжить';

  @override
  String get actionPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Импортировано файлов: $count',
      one: 'Импортирован 1 файл',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => 'Не удалось импортировать файлы';

  @override
  String get tooltipImportDocuments => 'Импортировать документы';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено файлов: $count',
      one: 'Найден 1 файл',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => 'Сканирование...';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Файлов: $count',
      one: '1 файл',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => 'Папки';

  @override
  String get errorLoadingRecent => 'Ошибка загрузки недавних файлов';

  @override
  String get emptyStateTitle => 'Пусто';

  @override
  String get emptyRecentDescription => 'Здесь появятся недавно открытые файлы';

  @override
  String get errorLoadingBookmarks => 'Ошибка загрузки закладок';

  @override
  String get emptyBookmarksDescription =>
      'Здесь появятся документы, добавленные в закладки';

  @override
  String get dialogDeleteTitle => 'Удалить выбранные файлы?';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалить выбранные файлы ($count)? Это действие нельзя отменить.',
      one: 'Удалить 1 файл? Это действие нельзя отменить.',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалено файлов: $count',
      one: 'Удалён 1 файл',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => 'Не удалось удалить файлы';

  @override
  String get actionDelete => 'Удалить';

  @override
  String get searchRecentSearchesHeader => 'НЕДАВНИЕ ЗАПРОСЫ';

  @override
  String get actionClear => 'Очистить';

  @override
  String get searchPromptTitle => 'Введите запрос для поиска';

  @override
  String get searchPromptMessage =>
      'Поиск по всем локальным папкам по имени файла или расширению';

  @override
  String get searchError => 'Ошибка поиска документов';

  @override
  String get searchNoResultsTitle => 'Подходящие документы не найдены';

  @override
  String get searchNoResultsMessage =>
      'Попробуйте другое ключевое слово или фильтр по формату';

  @override
  String get tooltipSortOptions => 'Сортировка';

  @override
  String get sortSheetTitle => 'Сортировать';

  @override
  String get sortOptionDate => 'По дате изменения';

  @override
  String get sortOptionName => 'По названию';

  @override
  String get sortOptionSize => 'По размеру файла';

  @override
  String get sortAscendingOrder => 'По возрастанию';

  @override
  String get sortAscendingSubtitle =>
      'Сначала старые / от А до Я / сначала маленькие';

  @override
  String get sortDescendingSubtitle =>
      'Сначала новые / от Я до А / сначала большие';

  @override
  String get categoryAllFiles => 'Все файлы';

  @override
  String get loadingStatus => 'Загрузка...';

  @override
  String get emptyCategoryImagesTitle => 'Изображения не найдены';

  @override
  String get emptyCategoryImagesMessage =>
      'Здесь появятся изображения, найденные на устройстве';

  @override
  String get emptyCategoryDocsTitle => 'Документы не найдены';

  @override
  String get emptyCategoryDocsMessage =>
      'Документы этого формата появятся здесь после сканирования';

  @override
  String get actionOpen => 'Открыть';

  @override
  String get actionShare => 'Поделиться';

  @override
  String get actionRename => 'Переименовать';

  @override
  String get actionBookmark => 'В закладки';

  @override
  String get actionRemoveBookmark => 'Убрать из закладок';

  @override
  String get actionOpenInAnotherApp => 'Открыть в другом приложении';

  @override
  String get actionDetails => 'Свойства';

  @override
  String get actionOpenFile => 'Открыть файл';

  @override
  String get actionShareAll => 'Поделиться всеми';

  @override
  String get actionDone => 'Готово';

  @override
  String get actionSeeAll => 'Смотреть все';

  @override
  String get actionAllow => 'Разрешить';

  @override
  String get actionNotNow => 'Не сейчас';

  @override
  String get tooltipMoreActions => 'Ещё действия';

  @override
  String get tooltipCopyPath => 'Копировать путь';

  @override
  String get tooltipRotatePage => 'Повернуть страницу';

  @override
  String get tooltipRemovePage => 'Удалить страницу';

  @override
  String get renameFileTitle => 'Переименовать файл';

  @override
  String get renameFileNameLabel => 'Имя файла';

  @override
  String renamedSuccess(String fileName) {
    return 'Переименовано в $fileName';
  }

  @override
  String get deleteFileTitle => 'Удалить файл?';

  @override
  String deleteFileConfirmation(String fileName) {
    return 'Удалить «$fileName»? Это действие нельзя отменить.';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return 'Файл «$fileName» удалён';
  }

  @override
  String get fileDetailsTitle => 'Сведения о документе';

  @override
  String get fileDetailsLabelName => 'Имя';

  @override
  String get fileDetailsLabelType => 'Тип';

  @override
  String get fileDetailsLabelSize => 'Размер';

  @override
  String get fileDetailsLabelModified => 'Изменён';

  @override
  String get fileDetailsLabelBookmarked => 'В закладках';

  @override
  String get fileDetailsValueYes => 'Да';

  @override
  String get fileDetailsValueNo => 'Нет';

  @override
  String get fileDetailsLabelLocation => 'Расположение';

  @override
  String get fileDetailsPathCopied => 'Путь скопирован в буфер обмена';

  @override
  String get directoriesTitle => 'Каталоги';

  @override
  String get directoriesGoBack => 'Назад';

  @override
  String get directoriesGoToRoot => 'В корень';

  @override
  String get directoriesRetry => 'Повторить';

  @override
  String get directoriesFileNoLongerExists => 'Файл больше не существует';

  @override
  String get directoriesFolderNoLongerExists =>
      'Эта папка больше не существует.';

  @override
  String get directoriesNoDocsInFolder => 'В этой папке нет документов';

  @override
  String get directoriesFilesAppearHere =>
      'Файлы появятся здесь после добавления';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Объектов: $count',
      one: '1 объект',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => 'Папка';

  @override
  String get directoriesPermissionPromptTitle =>
      'Нужен доступ для просмотра папок';

  @override
  String get directoriesPermissionPromptBody =>
      'Приложению Doc View требуется доступ ко всем файлам для просмотра ваших папок.';

  @override
  String get directoriesGrantAccess => 'Предоставить доступ';

  @override
  String get directoriesImportInstead => 'Импортировать файлы';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Импортировано файлов: $count',
      one: 'Импортирован 1 файл',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => 'На уровень вверх';

  @override
  String get storageAccessRequiredTitle => 'Требуется доступ к хранилищу';

  @override
  String get storageAccessRequiredBody =>
      'Приложению Doc View нужен доступ к хранилищу для поиска и отображения документов (PDF, Word, Excel, PPT, TXT, изображения), сохранённых на устройстве.\n\nВаши файлы остаются полностью конфиденциальными и не покидают устройство.';

  @override
  String errorCouldNotOpenDocument(String error) {
    return 'Не удалось открыть документ: $error';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сканирование завершено (файлов: $count)',
      one: 'Сканирование завершено: 1 файл',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => 'Очистить историю поиска?';

  @override
  String get dialogClearSearchMessage =>
      'Все недавние поисковые запросы будут удалены безвозвратно.';

  @override
  String imageListEditorMaxLimit(int max) {
    return 'Достигнут лимит: максимум $max изображений.';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return 'Ошибка сканирования: $error';
  }

  @override
  String get imageListEditorPageSize => 'Размер страницы:';

  @override
  String get imageListEditorA4Mode => 'A4';

  @override
  String get imageListEditorFitMode => 'По размеру фото';

  @override
  String get imageListEditorRemoveImageTooltip => 'Удалить изображение';

  @override
  String get mergeScreenTitle => 'Порядок и склейка';

  @override
  String get mergeScreenDefaultMergedName => 'Объединённый_документ';

  @override
  String get mergePickerSearchHint => 'Поиск PDF...';

  @override
  String get mergePickerNext => 'Далее';

  @override
  String mergePickerErrorLoading(String error) {
    return 'Ошибка загрузки PDF: $error';
  }

  @override
  String get splitScreenTitle => 'Разделить PDF';

  @override
  String get splitScreenRangeHint => 'напр. 1-3, 5, 8-10';

  @override
  String get splitScreenClearRange => 'Очистить диапазон';

  @override
  String get splitPickerSearchHint => 'Поиск PDF...';

  @override
  String splitPickerErrorLoading(String error) {
    return 'Ошибка загрузки файлов: $error';
  }

  @override
  String get createdSectionTitle => 'Созданные вами';

  @override
  String get createdSectionEmptyTitle => 'Здесь появятся созданные PDF';

  @override
  String get createdSectionEmptySubtitle =>
      'Конвертированные, отсканированные и объединённые документы сохраняются локально.';

  @override
  String get emptyCreatedDocsTitle => 'Пока нет созданных документов';

  @override
  String get emptyCreatedDocsMessage =>
      'Конвертированные, отсканированные или объединённые документы появятся здесь.';

  @override
  String errorLoadingCreatedFiles(String error) {
    return 'Не удалось загрузить созданные файлы: $error';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Создано PDF: $count',
      one: 'PDF создан',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle => 'Сохранено в папку «Созданные»';

  @override
  String get toolErrorDefaultTitle => 'Не удалось создать PDF';

  @override
  String get toolErrorSubtitle =>
      'Произошла непредвиденная ошибка при обработке';

  @override
  String get themeSheetTitle => 'Тема оформления';

  @override
  String get themeSheetSubtitle => 'Выберите внешний вид для Doc View';

  @override
  String get themeModeSystem => 'Системная';

  @override
  String get themeModeSystemSubtitle => 'по умолчанию';

  @override
  String get themeModeLight => 'Светлая';

  @override
  String get themeModeLightSubtitle => 'Чистый белый';

  @override
  String get themeModeDark => 'Тёмная';

  @override
  String get themeModeDarkSubtitle => 'Глубокий тёмно-синий';

  @override
  String get themeActionApply => 'Применить тему';

  @override
  String get scanSettingsTitle => 'Настройки сканирования';

  @override
  String get scanSettingsFrequencyHeader => 'Частота сканирования';

  @override
  String get scanSettingsOnOpenTitle => 'При открытии приложения';

  @override
  String get scanSettingsOnOpenSubtitle =>
      'Автоматически искать новые файлы при запуске Doc View.';

  @override
  String get scanSettingsManualTitle => 'Только вручную';

  @override
  String get scanSettingsManualSubtitle =>
      'Сканировать только при потягивании списка вниз или нажатии «Обновить».';

  @override
  String get scanSettingsMediaFiltersHeader => 'Фильтры медиа';

  @override
  String get scanSettingsIncludeImagesTitle => 'Включать изображения';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      'Индексировать изображения PNG, JPG и WEBP в хранилище.';

  @override
  String get scanSettingsDiagnosticsHeader => 'Хранилище и диагностика';

  @override
  String get scanSettingsPermissionStatus => 'Доступ ко всем файлам';

  @override
  String get scanSettingsPermissionGranted => 'Предоставлен';

  @override
  String get scanSettingsPermissionNotGranted => 'Не предоставлен';

  @override
  String get scanSettingsTotalIndexed => 'Проиндексировано файлов';

  @override
  String get scanSettingsLastScan => 'Последнее сканирование';

  @override
  String get scanSettingsUpdatedSnackbar => 'Настройки сканирования обновлены';

  @override
  String get faqScreenTitle => 'Частые вопросы';

  @override
  String faqHeaderTopics(int count) {
    return 'Тем: $count';
  }

  @override
  String get faqHeaderSubtitle =>
      'Есть вопросы? Здесь собраны понятные ответы.';

  @override
  String get faqSendFeedback => 'Отправить отзыв';

  @override
  String get faqQuestion1 => 'Зачем Doc View нужен доступ ко всем файлам?';

  @override
  String get faqAnswer1 =>
      'Приложению Doc View на Android 11+ требуется доступ ко всем файлам (MANAGE_EXTERNAL_STORAGE), чтобы находить и индексировать поддерживаемые документы (PDF, Word, Excel, PowerPoint, текстовые файлы и изображения) в общих папках, таких как «Загрузки» и «Документы».\n\nБез этого разрешения Android ограничивает доступ только внутренней папкой приложения, из-за чего Doc View не сможет просматривать и открывать файлы на устройстве.';

  @override
  String get faqQuestion2 => 'Почему приложение не сканирует весь iPhone?';

  @override
  String get faqAnswer2 =>
      'В iOS используется строгая песочница приложений для защиты конфиденциальности. Приложения могут открывать только те документы, которые явно сохранены в приложении «Файлы» или отправлены через системное меню «Поделиться».\n\nЧтобы просматривать файлы на iOS, добавьте их в папку Doc View в приложении «Файлы» или воспользуйтесь функцией «Импортировать файлы» в настройках.';

  @override
  String get faqQuestion3 => 'Куда сохраняются созданные мной PDF?';

  @override
  String get faqAnswer3 =>
      'Импортированные и созданные вами файлы (конвертированные PDF, объединённые документы или разделённые страницы) надёжно сохраняются в памяти устройства в папке DocView/Created или во внутреннем хранилище приложения. Их всегда можно найти в разделе «Созданные вами» на вкладке «Инструменты».';

  @override
  String get faqQuestion4 => 'Почему мой файл Word выглядит иначе?';

  @override
  String get faqAnswer4 =>
      'Doc View отображает файлы прямо на устройстве с помощью локальных офлайн-модулей, не отправляя личные данные в облачные конвертеры. Сложное форматирование или нестандартные фигуры отображаются с учётом ограничений офлайн-отрисовки.';

  @override
  String get faqQuestion5 => 'Можно ли открывать файлы с паролем?';

  @override
  String get faqAnswer5 =>
      'Да, Doc View поддерживает открытие защищённых паролем PDF-документов. При открытии зашифрованного PDF введите пароль в диалоговом окне, чтобы расшифровать и просмотреть документ на устройстве.';

  @override
  String get faqQuestion6 => 'Загружаются ли мои данные куда-либо?';

  @override
  String get faqAnswer6 =>
      'Ваши документы никогда не покидают устройство. Doc View открывает, конвертирует и хранит файлы локально. В приложении показывается реклама Google AdMob, которая может использовать ограниченные данные об устройстве согласно нашей Политике конфиденциальности.';

  @override
  String get faqQuestion7 =>
      'Почему при конвертации PDF в Word изменилась вёрстка?';

  @override
  String get faqAnswer7 =>
      'Doc View конвертирует только текст локально на устройстве. Таблицы, изображения, цвета и макет не сохраняются. Отсканированные PDF нельзя конвертировать, так как в них нет текстового слоя.';

  @override
  String get toolPdfToWord => 'PDF в Word';

  @override
  String get toolPdfToWordSub => 'Конвертировать PDF в редактируемый Word';

  @override
  String get pdfToWordScreenTitle => 'PDF в Word';

  @override
  String get pdfToWordBannerText =>
      'Конвертируется только текст. Таблицы, изображения, цвета и оформление не сохраняются.';

  @override
  String get pdfToWordPageBreaks =>
      'Вставлять разрывы страниц между страницами PDF';

  @override
  String get pdfToWordPageBreaksSubtitle =>
      'Сохраняет разбивку документа по страницам';

  @override
  String get pdfToWordSelectPdf => 'Выбрать PDF';

  @override
  String get pdfToWordChangeFile => 'Другой файл';

  @override
  String get pdfToWordConvertAction => 'Конвертировать в Word';

  @override
  String get pdfToWordConverting => 'Конвертация в Word...';

  @override
  String pdfToWordConvertingProgress(int current, int total) {
    return 'Конвертация страницы $current из $total...';
  }

  @override
  String get pdfToWordSuccess => 'Успешно конвертировано в Word';

  @override
  String get pdfToWordOpenInViewer => 'Открыть в Doc View';

  @override
  String get pdfToWordOpenWith => 'Открыть с помощью...';

  @override
  String get pdfToWordShare => 'Поделиться';

  @override
  String get pdfToWordNoTextTitle => 'Текст не найден';

  @override
  String get pdfToWordNoTextMessage =>
      'В этом PDF нет текста. Отсканированные документы нельзя конвертировать.';

  @override
  String get pdfToWordLargeFileWarning =>
      'Большой документ: конвертация может занять несколько минут.';

  @override
  String get pdfToWordInvalidFileName => 'Недопустимое имя файла';

  @override
  String get pdfToWordActionCancel => 'Отмена';

  @override
  String get pdfToWordEncryptedError =>
      'Выбранный PDF защищён паролем. Разблокируйте его перед конвертацией.';

  @override
  String get pdfToWordPageLimitError =>
      'Документ превышает ограничение в 1 000 страниц.';

  @override
  String get pdfToWordTextLimitError =>
      'Объём текста в документе превышает лимит в 20 MB.';

  @override
  String get pdfToWordGeneralError =>
      'Не удалось конвертировать PDF в Word. Попробуйте другой файл.';

  @override
  String get pdfGotoPageTitle => 'Перейти к странице';

  @override
  String pdfGotoPageHint(int pageCount) {
    return 'Введите номер от 1 до $pageCount';
  }

  @override
  String get pdfGotoPageAction => 'Перейти';

  @override
  String get pdfGotoPageErrorEmpty => 'Введите номер страницы';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return 'Введите номер от 1 до $pageCount';
  }

  @override
  String get pdfPasswordTitle => 'Этот PDF защищён паролем';

  @override
  String get pdfPasswordSubtitle =>
      'Введите пароль для расшифровки и просмотра содержимого.';

  @override
  String get pdfPasswordHint => 'Введите пароль';

  @override
  String get pdfPasswordErrorIncorrect =>
      'Неверный пароль. Попробуйте ещё раз.';

  @override
  String get pdfPasswordActionUnlock => 'Разблокировать';

  @override
  String get errorFileNameEmpty => 'Имя файла не может быть пустым';

  @override
  String get errorFileNameTooLong =>
      'Имя файла не должно превышать 120 символов';

  @override
  String get errorFileNameReserved => 'Имя файла не может быть «.» или «..»';

  @override
  String get errorFileNameStartsWithDot =>
      'Имя файла не может начинаться с точки';

  @override
  String get errorFileNameInvalidChars =>
      'Имя файла содержит недопустимые символы';

  @override
  String get errorRenameAlreadyExists =>
      'Файл с таким именем уже существует в этой папке';

  @override
  String get errorRenameSourceNotFound =>
      'Исходный файл больше не существует на диске';

  @override
  String errorRenameFailed(String details) {
    return 'Не удалось переименовать файл: $details';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      'Файлы удалены с диска, но не удалось обновить базу данных';

  @override
  String errorDeleteFailed(String details) {
    return 'Не удалось удалить файлы: $details';
  }

  @override
  String get errorPageRangeDocNoPages => 'В документе нет страниц';

  @override
  String get errorPageRangeEmpty => 'Диапазон страниц не может быть пустым';

  @override
  String get errorPageRangeEmptySegment =>
      'Обнаружен пустой сегмент диапазона. Удалите лишние запятые.';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return 'Неверный формат диапазона: «$token»';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return 'Неполный диапазон: «$token»';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return 'Нечисловые значения в диапазоне: «$token»';
  }

  @override
  String get errorPageRangeBelowMinimum =>
      'Номера страниц должны быть не меньше 1';

  @override
  String errorPageRangeReversed(int start, int end) {
    return 'Обратный диапазон «$start-$end»: начало больше конца';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return 'Диапазон «$token» превышает общее число страниц ($totalPages)';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return 'Неверный номер страницы: «$token»';
  }

  @override
  String get errorImageToPdfNoImages => 'Выберите хотя бы одно изображение';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return 'Допускается максимум $max изображений за раз';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return 'Не удалось обработать изображение: $path';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return 'Не удалось создать PDF из изображений: $details';
  }

  @override
  String get errorPdfMergeInsufficient =>
      'Выберите минимум 2 PDF-файла для объединения';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return 'Файл $fileName защищён паролем или повреждён';
  }

  @override
  String get errorPdfMergeNoPages => 'Выбранные документы не содержат страниц';

  @override
  String errorPdfMergeFailed(String details) {
    return 'Ошибка объединения PDF: $details';
  }

  @override
  String get errorPdfSplitNoRanges => 'Укажите хотя бы один диапазон страниц';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return 'Файл $fileName защищён паролем или повреждён';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return 'Диапазон $start-$end выходит за пределы файла $fileName';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return 'Не удалось разделить PDF: $details';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return 'СТР. $current/$total';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '($bytes байт)';
  }

  @override
  String get directoriesProtectedTitle =>
      'Эта папка защищена системой Android.';

  @override
  String get directoriesProtectedDesc =>
      'Android ограничивает доступ к системным и закрытым папкам приложений.';

  @override
  String get directoriesNotFoundTitle => 'Эта папка больше не существует.';

  @override
  String get directoriesEmpty => 'Здесь нет поддерживаемых файлов или папок.';

  @override
  String get directoriesErrorOpening => 'Ошибка открытия папки';

  @override
  String get directoriesRoot => 'Корень';

  @override
  String get scanSettingsSectionFrequency => 'Частота сканирования';

  @override
  String get scanSettingsSectionFilters => 'Фильтры документов';

  @override
  String get scanSettingsIncludeImages => 'Включать изображения';

  @override
  String get scanSettingsIncludeImagesDesc =>
      'Выключите, чтобы скрыть тысячи фотографий из списка документов';

  @override
  String get scanSettingsImageListUpdated => 'Список изображений обновлён';

  @override
  String get scanSettingsActionRescanNow => 'Сканировать сейчас';

  @override
  String get scanSettingsSectionDiagnostics => 'Диагностика хранилища';

  @override
  String get scanSettingsAllFilesAccessGranted =>
      'Доступ ко всем файлам предоставлен';

  @override
  String get scanSettingsAllFilesAccessNeeded => 'Нужен доступ ко всем файлам';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      'У Doc View есть разрешение на поиск файлов в Загрузках и на SD-картах.';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      'Требуется разрешение для сканирования загрузок и папок внешнего хранилища.';

  @override
  String get scanSettingsActionOpenSettings => 'Открыть настройки';

  @override
  String scanSettingsScanningFiles(int count) {
    return 'Сканирование... Найдено файлов: $count';
  }

  @override
  String get faqStillNeedHelp => 'Остались вопросы? Напишите нам';

  @override
  String get toolsLabelFileName => 'Имя файла';

  @override
  String get toolsAddImagesToStart => 'Добавьте изображения для начала';

  @override
  String get toolsAddImagesDesc =>
      'Выберите фотографии или отсканируйте бумажные документы для создания PDF.';

  @override
  String get toolsChoosePhotos => 'Выбрать фото';

  @override
  String get toolsScanPaper => 'Сканировать документ';

  @override
  String toolsPageNumber(int page) {
    return 'Страница $page';
  }

  @override
  String get toolsTooltipRotatePage => 'Повернуть страницу';

  @override
  String get toolsTooltipRemovePage => 'Удалить страницу';

  @override
  String get toolsAddMoreScans => 'Добавить сканы';

  @override
  String get toolsAddMoreImages => 'Добавить изображения';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изобр.: $count · прибл. ~ $size',
      one: '1 изобр. · прибл. ~ $size',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return 'Выбрано: $count';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return 'Выберите не менее $min файлов';
  }

  @override
  String toolsPagesTotal(int count) {
    return 'Всего страниц: $count';
  }

  @override
  String get toolsPagesTotalLabel => 'всего страниц';

  @override
  String get toolsNoPdfsFound => 'PDF-документы не найдены';

  @override
  String get semanticBookmarked => 'в закладках';

  @override
  String get semanticSelected => 'выбрано';

  @override
  String get semanticNotSelected => 'не выбрано';

  @override
  String get actionDeselectFile => 'Снять выбор с файла';

  @override
  String get actionSelectFile => 'Выбрать файл';

  @override
  String get actionCreatePdf => 'Создать PDF';

  @override
  String get hintSelectOrViewActions =>
      'Выберите файл или просмотрите действия';

  @override
  String get actionClose => 'Закрыть';

  @override
  String get actionReset => 'Сбросить';

  @override
  String get labelPleaseWait => 'Пожалуйста, подождите...';

  @override
  String get tooltipCloseSearch => 'Закрыть поиск';

  @override
  String get semanticAdvertisement => 'Реклама';

  @override
  String get themePreviewLight => 'Светлая';

  @override
  String get themePreviewNavy => 'Тёмно-синяя';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '$name, $size, создан $date';
  }

  @override
  String get toolsCreatingPdfFromScans => 'Создание PDF из сканов';

  @override
  String get toolsCreatingPdf => 'Создание PDF';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return 'Обработка изображения $done из $total...';
  }

  @override
  String get toolsErrorCreatePdfTitle => 'Не удалось создать PDF';

  @override
  String get toolsBadgeProtectedOrDamaged => 'Защищён или повреждён';

  @override
  String toolsPageCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count стр.',
      one: '1 страница',
    );
    return '$_temp0';
  }

  @override
  String get toolsPagesAbbrev => 'стр.';

  @override
  String get mergeAddMoreTitle => 'Добавить ещё PDF';

  @override
  String get mergeProgressTitle => 'Объединение PDF';

  @override
  String mergeProgressMessage(int done, int total) {
    return 'Объединение документа $done из $total...';
  }

  @override
  String get mergeErrorTitle => 'Не удалось объединить PDF';

  @override
  String get mergeDragInstruction =>
      'Потяните за маркеры, чтобы изменить порядок';

  @override
  String get mergeAddPdf => 'Добавить PDF';

  @override
  String get mergeOutputFileNameLabel => 'ИМЯ ИТОГОВОГО ФАЙЛА';

  @override
  String mergeItemPageCountAndSize(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count стр. · $size',
      one: '1 стр. · $size',
    );
    return '$_temp0';
  }

  @override
  String mergeItemLoadingPagesAndSize(String size) {
    return 'Загрузка страниц... · $size';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Обнаружено некорректных файлов: $count',
      one: 'Обнаружен 1 некорректный файл',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => 'Готово к объединению';

  @override
  String get mergeRemoveProtectedHint =>
      'Удалите документы, защищённые паролем';

  @override
  String mergeSummary(int files, int pages, String size) {
    return 'Файлов: $files · стр.: $pages · ~ $size';
  }

  @override
  String get mergeReadyBadge => 'Готово';

  @override
  String get mergeBlockedCta => 'Объединение заблокировано (исправьте ошибки)';

  @override
  String mergeActionCta(int files, int pages) {
    return 'Объединить $files PDF (стр.: $pages)';
  }

  @override
  String get mergePickerDefaultTitle => 'Выберите PDF';

  @override
  String mergePickerTabAllPdfs(int count) {
    return 'Все PDF ($count)';
  }

  @override
  String get mergePickerTabRecent => 'Недавние';

  @override
  String get mergePickerTabDownloads => 'Загрузки';

  @override
  String get mergePickerTabICloud => 'iCloud Drive';

  @override
  String get splitProgressTitle => 'Разделение PDF';

  @override
  String splitProgressMessage(int done, int total) {
    return 'Создание файла $done из $total...';
  }

  @override
  String get splitErrorTitle => 'Не удалось разделить PDF';

  @override
  String get splitPageRangesLabel => 'ДИАПАЗОНЫ СТРАНИЦ';

  @override
  String get splitPageRangesSyntax => 'Формат: 1-3, 5, 8-10';

  @override
  String get splitRangeHelpText =>
      'Каждый диапазон станет отдельным PDF-файлом.';

  @override
  String splitGeneratedFilesHeader(int count) {
    return 'СОЗДАВАЕМЫЕ ФАЙЛЫ ($count)';
  }

  @override
  String get splitChipsSuspendedTitle => 'Предпросмотр приостановлен';

  @override
  String get splitChipsSuspendedDesc =>
      'Исправьте синтаксическую ошибку выше, чтобы продолжить разбиение.';

  @override
  String get splitEmptyRangesHint =>
      'Введите диапазоны страниц выше для создания частей PDF';

  @override
  String splitChipSinglePage(int page) {
    return 'Стр. $page';
  }

  @override
  String splitChipPageRange(int start, int end) {
    return 'Стр. $start–$end';
  }

  @override
  String splitChipPageCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count стр.',
      one: '1 стр.',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => 'БЫСТРЫЙ ВЫБОР';

  @override
  String get splitMacroAllPages => 'Все страницы';

  @override
  String get splitMacroEvery5Pages => 'По 5 страниц';

  @override
  String get splitMacroLimitHint =>
      'Шаблоны, создающие более 100 файлов, отключены для защиты памяти устройства';

  @override
  String splitOutputSummary(int files, int pages) {
    return 'Итог: файлов — $files · извлечено стр.: $pages';
  }

  @override
  String splitEstSize(String size) {
    return 'ПРИБЛ. ~ $size';
  }

  @override
  String splitActionCtaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Разделить на $count PDF',
      one: 'Разделить на 1 PDF',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => 'Разделить на PDF';

  @override
  String splitPickerAllLocalDocs(int count) {
    return 'ВСЕ ЛОКАЛЬНЫЕ ДОКУМЕНТЫ ($count)';
  }

  @override
  String get splitPickerSortByDate => 'ПО ДАТЕ';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return 'стр. · $size';
  }

  @override
  String get splitPickerTitle => 'Выберите PDF для разделения';

  @override
  String get faqShortTitle => 'FAQ';

  @override
  String splitPickerSelectedCount(int count) {
    return 'Выбрано PDF: $count';
  }

  @override
  String get splitPickerSelectDocumentHint =>
      'Выберите документ, чтобы продолжить';

  @override
  String splitPickerPagesActive(int count) {
    return 'Активных страниц: $count';
  }

  @override
  String get splitPickerPagesActiveLabel => 'активных страниц';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionGeneral => 'Основные';

  @override
  String get settingsSectionOthers => 'Прочее';

  @override
  String get settingsFileManagerTitle => 'Диспетчер файлов';

  @override
  String get settingsFileManagerSubtitle =>
      'Просмотр каталогов и папок хранилища';

  @override
  String get settingsFaqTitle => 'Частые вопросы';

  @override
  String get settingsFaqSubtitle => 'Ответы на популярные вопросы';

  @override
  String get settingsShareTitle => 'Поделиться';

  @override
  String get settingsShareSubtitle => 'Порекомендовать Doc View друзьям';

  @override
  String settingsShareMessage(String url) {
    return 'Попробуйте Doc View — быстрый, конфиденциальный офлайн-просмотрщик документов: $url';
  }

  @override
  String get settingsScanSettingsTitle => 'Настройки сканирования';

  @override
  String get settingsScanModeOnOpen => 'При открытии';

  @override
  String get settingsScanModeManual => 'Только вручную';

  @override
  String get settingsAppThemeTitle => 'Тема приложения';

  @override
  String get settingsThemeSystem => 'Как в системе';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsLanguageTitle => 'Язык';

  @override
  String get settingsRateUsTitle => 'Оценить приложение';

  @override
  String get settingsRateUsSubtitle => 'Поделитесь своим отзывом';

  @override
  String get settingsAddWidgetTitle => 'Добавить виджет';

  @override
  String get settingsAddWidgetSubtitle => 'Быстрый доступ с главного экрана';

  @override
  String get settingsTermsTitle => 'Условия использования';

  @override
  String get settingsTermsSubtitle => 'Ознакомиться с условиями обслуживания';

  @override
  String get settingsPrivacyTitle => 'Политика конфиденциальности';

  @override
  String get settingsPrivacySubtitle =>
      'Ознакомиться с политикой конфиденциальности';

  @override
  String get settingsManageSubscriptionsTitle => 'Управление подписками';

  @override
  String get settingsManageSubscriptionsSubtitle =>
      'Управление подпиской в магазине приложений';

  @override
  String settingsVersionDisplay(String version, String build) {
    return 'Версия $version ($build)';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return 'Версия $version, сборка $build';
  }

  @override
  String get settingsOpenSourceLicenses => 'Лицензии открытого ПО';

  @override
  String get rateSheetTitle => 'Оцените Doc View';

  @override
  String get rateSheetSubtitle => 'Ваш отзыв помогает нам становиться лучше';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Звёзд: $count',
      one: '1 звезда',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => 'Рады, что вам нравится!';

  @override
  String get rateResponseMedium => 'Спасибо! Расскажите, что можно улучшить.';

  @override
  String get rateResponseLow =>
      'Жаль, что приложение не оправдало ожиданий. Подскажите, что исправить.';

  @override
  String get rateActionStore => 'Оценить в Google Play';

  @override
  String get rateActionHelpFeedback => 'Помощь и отзыв';

  @override
  String get faqFromRatingBanner =>
      'Нам жаль это слышать. Посмотрите ответы ниже или напишите нам — мы читаем каждое обращение.';

  @override
  String get faqActionContactUs => 'Связаться с нами';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return 'Отзыв о Doc View ($version+$build)';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '\n\n---\nПриложение: Doc View $version (Сборка $build)\n';
  }

  @override
  String get faqEmailClientUnavailable => 'Не удалось открыть почтовый клиент';

  @override
  String get languageScreenTitle => 'Язык';

  @override
  String get languageSearchHint => 'Поиск языков...';

  @override
  String get languageSystemDefault => 'Как в системе';

  @override
  String get languageSystemDefaultSubtitle => 'Язык устройства';

  @override
  String get languageNotTranslatedBadge => '(не переведено)';

  @override
  String get languageNotTranslatedSnack => 'Этот язык ещё не переведён';

  @override
  String get languageNoResults => 'Подходящие языки не найдены';

  @override
  String get languagePseudoLocaleName => 'Псевдолокаль (en_XA)';

  @override
  String get languagePseudoLocaleSubtitle => 'Отладка расширения текста';

  @override
  String get scanSettingsSectionHistory => 'История';

  @override
  String get scanSettingsClearHistoryTitle => 'Очистить историю недавних';

  @override
  String get scanSettingsClearHistorySubtitle =>
      'Удалить список недавно открытых документов';

  @override
  String get scanSettingsClearHistoryDialogTitle =>
      'Очистить историю недавних?';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      'Файлы будут убраны из раздела «Недавние». Сами файлы и закладки не пострадают.';

  @override
  String get scanSettingsRecentHistoryCleared => 'История недавних очищена';

  @override
  String get scanSettingsLastScanToday => 'сегодня';

  @override
  String get scanSettingsLastScanYesterday => 'вчера';

  @override
  String get scanSettingsNeverScanned => 'Ещё не выполнялось';

  @override
  String get scanSettingsLastScanPrefix => 'Последнее сканирование:';

  @override
  String get readerActionVertical => 'Вертикально';

  @override
  String get readerActionHorizontal => 'Горизонтально';

  @override
  String get readerActionRotate => 'Повернуть';

  @override
  String get readerActionSearch => 'Поиск';

  @override
  String get readerActionInvert => 'Инверсия';

  @override
  String get readerActionShare => 'Поделиться';

  @override
  String get readerActionPages => 'Страницы';

  @override
  String get readerSearchHint => 'Поиск в документе...';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '$current из $total';
  }

  @override
  String get readerSearchMatchCap => '500+';

  @override
  String get readerSearchNoMatches => '0 из 0';

  @override
  String get readerSearchNoTextLayer =>
      'В этом PDF нет текстового слоя для поиска';

  @override
  String get readerSearchPrevMatch => 'Предыдущее совпадение';

  @override
  String get readerSearchNextMatch => 'Следующее совпадение';

  @override
  String readerTopPagesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count стр. • $size',
      one: '1 стр. • $size',
    );
    return '$_temp0';
  }

  @override
  String get readerMenuGoToPage => 'Перейти к странице';

  @override
  String get readerMenuAddBookmark => 'Добавить в закладки';

  @override
  String get readerMenuRemoveBookmark => 'Удалить из закладок';

  @override
  String get readerMenuDetails => 'Свойства';

  @override
  String get readerMenuOpenInAnotherApp => 'Открыть в другом приложении';

  @override
  String get readerTooltipConvertToWord => 'Конвертировать в Word';

  @override
  String get pagesScreenTitle => 'Страницы';

  @override
  String pagesScreenPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Страниц: $count',
      one: '1 стр.',
    );
    return '$_temp0';
  }

  @override
  String get pagesActionSelectAll => 'Выбрать все';

  @override
  String get pagesActionClearSelection => 'Снять';

  @override
  String get pagesActionSave => 'Сохранить';

  @override
  String get pagesActionInsert => 'Вставить';

  @override
  String get pagesActionRotate => 'Повернуть';

  @override
  String get pagesActionExtract => 'Извлечь';

  @override
  String get pagesActionDelete => 'Удалить';

  @override
  String get pagesActionUndo => 'Отменить';

  @override
  String get pagesInsertSheetTitle => 'Вставить страницы';

  @override
  String get pagesInsertPagesFromPdf => 'Страницы из другого PDF';

  @override
  String get pagesDeleteAllBlocked =>
      'Нельзя удалить все страницы. В документе должна оставаться хотя бы одна страница.';

  @override
  String get pagesSaveDialogTitle => 'Сохранить изменения';

  @override
  String get pagesSaveAsNew => 'Сохранить как новый файл';

  @override
  String get pagesSaveReplace => 'Заменить оригинал';

  @override
  String get pagesSaveReplaceWarning => 'Исходный файл будет перезаписан.';

  @override
  String get pagesSaveFileNameLabel => 'Имя файла';

  @override
  String get pagesDiscardDialogTitle => 'Отменить изменения?';

  @override
  String get pagesDiscardDialogBody =>
      'У вас есть несохранённые изменения. Вы уверены, что хотите отменить их?';

  @override
  String get pagesDiscardButton => 'Отменить';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count стр.',
      one: '1 стр.',
    );
    return 'Извлечено: $_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      'Этот PDF нельзя редактировать, так как он зашифрован или не читается.';

  @override
  String get viewerErrorCorruptTitle => 'Не удаётся открыть документ';

  @override
  String get viewerErrorCorruptMessage =>
      'Файл повреждён или не является корректным документом.';

  @override
  String get viewerErrorMissingTitle => 'Файл больше не существует';

  @override
  String get viewerErrorMissingMessage =>
      'Файл был удалён или перемещён из памяти устройства.';

  @override
  String get viewerErrorBackToFiles => 'К файлам';

  @override
  String get viewerErrorNoAppFound =>
      'Не найдено приложение для открытия этого файла';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Совпадений: $count',
      one: '1 совпадение',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Разделов: $count • $ext',
      one: '1 раздел • $ext',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner => 'Устаревший формат: только текст';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      'Большая таблица: показаны первые 20 000 строк и 100 столбцов';

  @override
  String viewerSectionTitle(int number) {
    return 'Раздел $number';
  }

  @override
  String get viewerMenuOutline => 'Содержание';

  @override
  String get viewerOutlineTitle => 'Содержание документа';

  @override
  String get viewerCloseOutline => 'Закрыть содержание';

  @override
  String get viewerNoSections => 'В этом документе не найдены разделы';

  @override
  String get viewerOutlineTooltip => 'Оглавление';

  @override
  String get viewerActionOpenExternal => 'Открыть в другом приложении';

  @override
  String get viewerErrorCantOpenTitle => 'Не удаётся открыть документ';

  @override
  String get viewerErrorCantOpenMessage =>
      'Не удалось отобразить документ в офлайн-режиме.';

  @override
  String get viewerOpeningDocument => 'Открытие документа...';

  @override
  String get viewerErrorEncryptedTitle => 'Этот документ зашифрован';

  @override
  String get viewerErrorEncryptedMessage =>
      'Файлы, защищённые паролем, нельзя просмотреть во встроенном офлайн-ридере.';

  @override
  String get viewerErrorTooLargeTitle => 'Файл превышает лимит просмотра';

  @override
  String get viewerErrorTooLargeMessage =>
      'Большие документы следует открывать во внешнем офисном приложении.';

  @override
  String get viewerErrorUnsupportedFormatTitle =>
      'Этот формат не поддерживается';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      'Doc View не может напрямую открыть файл этого формата.';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Пунктов: $count',
      one: '1 пункт',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => 'Оформление текста';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '$size пт';
  }

  @override
  String get txtViewerMonospaceLabel => 'Моноширинный шрифт';

  @override
  String get txtViewerTruncationBanner =>
      'Файл больше 1 MB: показан первый 1 MB';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Строк: $count • $size',
      one: '1 строка • $size',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => 'Настройки текста';

  @override
  String get txtViewerTooltipDecreaseFont => 'Уменьшить размер шрифта';

  @override
  String get txtViewerTooltipIncreaseFont => 'Увеличить размер шрифта';

  @override
  String get txtViewerTooltipToggleMonospace =>
      'Переключить моноширинный шрифт';

  @override
  String get txtViewerMonospaceSubtitle =>
      'Символы фиксированной ширины для кода и логов';

  @override
  String get txtViewerPreviewLabel => 'Предпросмотр';

  @override
  String get txtViewerPreviewText =>
      'Съешь же ещё этих мягких французских булок да выпей чаю.';

  @override
  String get txtViewerErrorTitle => 'Не удаётся прочитать текстовый файл';

  @override
  String get txtViewerErrorMessage =>
      'Не удалось распознать формат или кодировку файла.';

  @override
  String get txtViewerActionRetry => 'Повторить';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '$width × $height • $size';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get imageViewerTooltipFitToScreen => 'По размеру экрана';

  @override
  String get imageViewerErrorCorrupt => 'Не удалось загрузить изображение';

  @override
  String get imageViewerLoading => 'Загрузка изображения…';

  @override
  String get viewerDispatcherFileMissing => 'Файл больше не существует';

  @override
  String get viewerSpreadsheetFormulaBarEmpty => '-';

  @override
  String get viewerSpreadsheetAllCells => 'Все';

  @override
  String viewerSpreadsheetColumnLabel(String col) {
    return 'Столбец $col';
  }

  @override
  String viewerSpreadsheetRowLabel(int row) {
    return 'Строка $row';
  }

  @override
  String viewerSpreadsheetCellSemantics(String col, int row, String value) {
    return 'Столбец $col, строка $row, $value';
  }

  @override
  String get viewerSpreadsheetEmptyCell => 'пусто';

  @override
  String get viewerSpreadsheetEmptySheet => 'Этот лист пуст';

  @override
  String get viewerSpreadsheetCopiedSingle => 'Ячейка скопирована';

  @override
  String viewerSpreadsheetCopiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Скопировано ячеек: $count',
      one: 'Скопирована 1 ячейка',
    );
    return '$_temp0';
  }

  @override
  String get viewerSpreadsheetCopyLimitReached =>
      'Выделение ограничено 5 000 ячеек';

  @override
  String get viewerSpreadsheetCellContentTitle => 'Содержимое ячейки';

  @override
  String get viewerSpreadsheetCopyAction => 'Копировать';

  @override
  String get viewerSpreadsheetCloseAction => 'Закрыть';

  @override
  String viewerSpreadsheetZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get viewerSpreadsheetResetZoomTooltip => 'Сбросить масштаб до 100%';

  @override
  String get viewerSpreadsheetNoMatches => 'На этом листе совпадений нет';

  @override
  String get viewerSpreadsheetSearchPlaceholder => 'Найти на листе…';

  @override
  String get viewerSpreadsheetPasswordTitle => 'Файл защищён паролем';

  @override
  String get viewerSpreadsheetPasswordMessage =>
      'Файлы, защищённые паролем, нельзя открыть здесь.';

  @override
  String get viewerSpreadsheetErrorTitle => 'Не удаётся прочитать таблицу';

  @override
  String get viewerSpreadsheetCorruptMessage =>
      'Файл таблицы повреждён или не может быть декодирован.';

  @override
  String get viewerSpreadsheetTimeoutMessage =>
      'Истекло время ожидания открытия таблицы (20 секунд).';

  @override
  String get viewerSpreadsheetTooLargeMessage =>
      'Этот файл превышает ограничение просмотра в 25 MB.';

  @override
  String get viewerSpreadsheetOpenBasicViewer => 'Открыть в базовом просмотре';

  @override
  String get viewerSpreadsheetOpenAnotherApp => 'Открыть в другом приложении';

  @override
  String get toolsWorkspaceOverline => 'РАБОЧАЯ ОБЛАСТЬ';

  @override
  String get toolsTitle => 'Инструменты';

  @override
  String get toolsSectionConvertCreate => 'КОНВЕРТАЦИЯ И СОЗДАНИЕ';

  @override
  String get toolsSectionEditManage => 'ПРАВКА И УПРАВЛЕНИЕ';

  @override
  String get toolsSectionOthers => 'ПРОЧЕЕ';

  @override
  String get toolsCreatedByYou => 'Созданные вами';

  @override
  String get toolsCreatedByYouEmpty => 'Здесь появятся созданные PDF';

  @override
  String get toolsCreatedByYouSeeAll => 'Смотреть все';

  @override
  String get toolManagePages => 'Страницы PDF';

  @override
  String get toolManagePagesSub => 'Порядок, поворот и удаление';

  @override
  String get toolImportFiles => 'Импорт файлов';

  @override
  String get toolImportFilesSub => 'Добавить из других приложений';

  @override
  String get toolPrintPdf => 'Печать PDF';

  @override
  String get toolPrintPdfSub => 'Отправить на любой принтер';

  @override
  String get toolCreatePdf => 'Создать PDF';

  @override
  String get toolCreatePdfSub => 'Пустой документ или шаблон';

  @override
  String get toolRecycleBin => 'Корзина';

  @override
  String get toolRecycleBinSub => 'Восстановление удалённых файлов';

  @override
  String get toolAnnotate => 'Аннотации';

  @override
  String get toolAnnotateSub => 'Выделение, рисование и пометки';

  @override
  String get toolAddText => 'Добавить текст';

  @override
  String get toolAddTextSub => 'Вставка текста и дат';

  @override
  String get toolSign => 'Подпись';

  @override
  String get toolSignSub => 'Заполнение и подпись форм';

  @override
  String get toolWordToPdf => 'Word в PDF';

  @override
  String get toolWordToPdfSub => 'Конвертировать DOCX в PDF';

  @override
  String get toolPptToPdf => 'PPT в PDF';

  @override
  String get toolPptToPdfSub => 'Конвертировать PPTX в PDF';

  @override
  String get printPdfErrorTooLarge =>
      'PDF-файл превышает ограничение печати в 50 MB.';

  @override
  String get printPdfErrorUnreadable => 'Не удалось прочитать PDF для печати.';

  @override
  String get printPdfErrorPassword =>
      'Невозможно напрямую распечатать PDF, защищённый паролем.';

  @override
  String get printPdfErrorFailed => 'Ошибка печати.';

  @override
  String get printPdfSuccess => 'Документ отправлен на печать.';

  @override
  String get toolPickerTitleSelectPdf => 'Выберите PDF';

  @override
  String get toolPickerTitleSelectPdfs => 'Выберите PDF';

  @override
  String get toolPickerBrowseFiles => 'Обзор файлов';

  @override
  String get toolPickerTabAll => 'Все PDF';

  @override
  String get toolPickerTabRecent => 'Недавние';

  @override
  String get toolPickerTabDownloads => 'Загрузки';

  @override
  String get toolPickerTabICloud => 'iCloud Drive';

  @override
  String get toolPickerActionPrint => 'Печать';

  @override
  String get toolPickerActionManage => 'Управление';

  @override
  String get toolPickerActionSelect => 'Выбрать';

  @override
  String get toolsImportActionView => 'Открыть';

  @override
  String get createPdfTemplateBlank => 'Пустой';

  @override
  String get createPdfTemplateLine1 => 'Линейка 1';

  @override
  String get createPdfTemplateLine2 => 'Линейка 2';

  @override
  String get createPdfTemplateNotebook => 'Тетрадь';

  @override
  String get createPdfTemplateCornell => 'Корнелл';

  @override
  String get createPdfTemplateGrid => 'Клетка';

  @override
  String get createPdfTemplateGraph => 'Миллиметровка';

  @override
  String get createPdfSwatchWhite => 'Белый';

  @override
  String get createPdfSwatchCream => 'Кремовый';

  @override
  String get createPdfSwatchLightYellow => 'Светло-жёлтый';

  @override
  String get createPdfSwatchLightPeach => 'Светло-персиковый';

  @override
  String get createPdfSwatchLightPink => 'Светло-розовый';

  @override
  String get createPdfSwatchLightLavender => 'Светло-лавандовый';

  @override
  String get createPdfSwatchLightBlue => 'Светло-голубой';

  @override
  String get createPdfSwatchLightMint => 'Светло-мятный';

  @override
  String get createPdfSwatchLightGreen => 'Светло-зелёный';

  @override
  String get createPdfSwatchLightGray => 'Светло-серый';

  @override
  String get createPdfOrientationPortrait => 'Книжная';

  @override
  String get createPdfOrientationLandscape => 'Альбомная';

  @override
  String get createPdfSectionTemplate => 'ШАБЛОН';

  @override
  String get createPdfSectionPageSize => 'РАЗМЕР СТРАНИЦЫ';

  @override
  String get createPdfSectionOrientation => 'ОРИЕНТАЦИЯ';

  @override
  String get createPdfSectionPageColor => 'ЦВЕТ СТРАНИЦЫ';

  @override
  String get createPdfSectionPageCount => 'КОЛИЧЕСТВО СТРАНИЦ';

  @override
  String createPdfPagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count стр.',
      one: '1 стр.',
    );
    return '$_temp0';
  }

  @override
  String createPdfSummary(String pages, String size, String orientation) {
    return '$pages • $size • $orientation';
  }

  @override
  String get createPdfCreating => 'Создание PDF...';

  @override
  String createPdfProgress(int done, int total) {
    return 'Формирование страницы $done из $total...';
  }

  @override
  String get createPdfErrorTitle => 'Не удалось создать PDF';

  @override
  String get createPdfErrorPageCount =>
      'Количество страниц должно быть от 1 до 100.';

  @override
  String get createPdfErrorInvalidName => 'Введите корректное имя файла.';

  @override
  String get createPdfErrorGeneration =>
      'Не удалось создать PDF-документ. Попробуйте ещё раз.';

  @override
  String get trashErrorTooLarge =>
      'Файл слишком велик для корзины (лимит 200 MB)';

  @override
  String get trashErrorNotEnoughSpace => 'Недостаточно места в корзине';

  @override
  String trashErrorGeneric(String details) {
    return 'Сбой операции с корзиной: $details';
  }

  @override
  String get trashDialogMoveTitle => 'Переместить в корзину?';

  @override
  String trashDialogMoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Переместить выбранные файлы ($count) в корзину? Их можно восстановить в разделе «Инструменты > Корзина» в течение 30 дней.',
      one:
          'Переместить 1 файл в корзину? Его можно восстановить в разделе «Инструменты > Корзина» в течение 30 дней.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionMove => 'Переместить в корзину';

  @override
  String trashMovedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Перемещено в корзину: $count',
      one: '1 файл перемещён в корзину',
    );
    return '$_temp0';
  }

  @override
  String get trashActionUndo => 'Отменить';

  @override
  String trashRestoredSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Восстановлено файлов: $count',
      one: 'Восстановлен 1 файл',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogDeleteForeverTitle => 'Удалить навсегда?';

  @override
  String trashDialogDeleteForeverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Удалить выбранные файлы ($count) навсегда? Это действие нельзя отменить.',
      one: 'Удалить 1 файл навсегда? Это действие нельзя отменить.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionDeleteForever => 'Удалить навсегда';

  @override
  String trashDeletedForeverSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалено навсегда: $count',
      one: '1 файл удалён навсегда',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogEmptyTitle => 'Очистить корзину?';

  @override
  String trashDialogEmptyBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'файлов: $count',
      one: '1 файл',
    );
    return 'Удалить безвозвратно ($_temp0)? Это действие нельзя отменить.';
  }

  @override
  String get trashActionEmptyBin => 'Очистить корзину';

  @override
  String get trashEmptyTitle => 'Корзина пуста';

  @override
  String get trashEmptySubtitle =>
      'Перемещённые в корзину файлы хранятся здесь 30 дней, после чего удаляются навсегда.';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Осталось дней: $count',
      one: 'Остался 1 день',
    );
    return '$_temp0';
  }

  @override
  String trashSubtitle(String date, String size) {
    return 'Удалён $date · $size';
  }

  @override
  String get trashDialogTooLargeTitle => 'Слишком большой файл для корзины';

  @override
  String trashDialogTooLargeBody(String fileName) {
    return 'Файл «$fileName» больше 200 MB и не может быть перемещён в корзину. Удалить его навсегда?';
  }

  @override
  String get trashActionDeletePermanently => 'Удалить навсегда';

  @override
  String get trashInfoBanner =>
      'Файлы в корзине удаляются навсегда через 30 дней.';

  @override
  String get trashSheetRestore => 'Восстановить';

  @override
  String get trashSheetDeleteForever => 'Удалить навсегда';

  @override
  String get trashSheetDetails => 'Свойства';

  @override
  String get trashDetailsOriginalLocation => 'Исходная папка';

  @override
  String get trashDetailsDateDeleted => 'Дата удаления';

  @override
  String get trashDetailsExpiresIn => 'Истекает через';

  @override
  String trashRestoredToFallbackSuccess(String location) {
    return 'Восстановлено в $location (исходная папка не найдена)';
  }

  @override
  String get trashDialogCopyFailedTitle => 'Не удалось переместить в корзину';

  @override
  String trashDialogCopyFailedBody(String fileName) {
    return 'Не удалось переместить «$fileName» в корзину. Удалить его навсегда? Это действие нельзя отменить.';
  }

  @override
  String get trashDialogEmptyProgress => 'Очистка корзины...';

  @override
  String get trashDialogMoveProgress => 'Перемещение файлов в корзину...';

  @override
  String get trashDialogNotEnoughSpaceTitle => 'Недостаточно свободного места';

  @override
  String get trashDialogNotEnoughSpaceBody =>
      'Недостаточно свободного места для перемещения в корзину. Освободите место, очистив корзину.';

  @override
  String get trashActionFreeUpSpace => 'Освободить место';

  @override
  String get trashDialogDeleteForeverProgress =>
      'Безвозвратное удаление файлов...';

  @override
  String get galleryDebugAgeTrash =>
      'Состарить все элементы корзины на 29 дней';

  @override
  String get galleryDebugSlowCopy => 'Медленное копирование в корзину (тест)';

  @override
  String get galleryDebugSlowCopySubtitle =>
      'Ограничивает цикл копирования до ~20 MB/s для теста прерывания';

  @override
  String get galleryDebugSlowSave => 'Медленное сохранение в редакторе (тест)';

  @override
  String get galleryDebugSlowSaveSubtitle =>
      'Замедляет сохранение до ~8 с для теста прерывания';

  @override
  String get galleryDebugSaveAnnotate =>
      'Сохранить образец 100 стр. (тест аннотаций)';

  @override
  String get galleryDebugSaveSign =>
      'Сохранить образец 100 стр. (тест подписи)';

  @override
  String get galleryDebugSaveText => 'Сохранить образец 100 стр. (тест текста)';

  @override
  String get galleryDebugMove190Mb =>
      'Переместить тестовый файл 190 MB в корзину';

  @override
  String get galleryDebugRestoreLastTrash =>
      'Восстановить последний файл из корзины';

  @override
  String get galleryDebugEmptyTrash => 'Очистить корзину';

  @override
  String galleryDebugAgeTrashSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'объектов — $count',
      one: '1 объект',
    );
    return 'Состарено на 29 дней: $_temp0';
  }

  @override
  String get annotateErrorPasswordProtected => 'Этот PDF защищён паролем.';

  @override
  String get annotateErrorCorrupt => 'Этот PDF повреждён или не читается.';

  @override
  String get annotateSignedReplaceBlocked =>
      'Замена оригинального подписанного PDF запрещена. Сохраните документ как новый файл.';

  @override
  String annotateErrorSaveFailed(String details) {
    return 'Не удалось сохранить аннотации: $details';
  }

  @override
  String get annotateErrorScannedPdf =>
      'Похоже, этот документ отсканирован или не содержит выделяемого текста.';

  @override
  String get annotateSignedBanner =>
      'PDF с цифровой подписью: при сохранении будет создана копия, чтобы не нарушить подпись.';

  @override
  String get annotateActionSaveNew => 'Сохранить как новый файл';

  @override
  String get annotateActionReplace => 'Заменить оригинал';

  @override
  String get annotateDiscardDialogTitle => 'Отменить несохранённые пометки?';

  @override
  String get annotateDiscardDialogBody =>
      'У вас есть несохранённые аннотации. Если выйти сейчас, изменения будут потеряны.';

  @override
  String get annotateDiscardDialogActionDiscard => 'Не сохранять';

  @override
  String get annotateDiscardDialogActionKeep => 'Продолжить правку';

  @override
  String get annotateSaveSuccess => 'Аннотации успешно сохранены';

  @override
  String get annotateToolbarHighlight => 'Маркер';

  @override
  String get annotateToolbarUnderline => 'Подчеркнуть';

  @override
  String get annotateToolbarStrikethrough => 'Зачеркнуть';

  @override
  String get annotateToolbarCopy => 'Копировать';

  @override
  String get annotateColorYellow => 'Жёлтый';

  @override
  String get annotateColorGreen => 'Зелёный';

  @override
  String get annotateColorCyan => 'Голубой';

  @override
  String get annotateColorPink => 'Розовый';

  @override
  String get annotateColorOrange => 'Оранжевый';

  @override
  String get annotateSaveTitle => 'Сохранение аннотаций';

  @override
  String get annotateSaveProgress => 'Сохранение аннотаций...';

  @override
  String get annotateNoChanges => 'Нет аннотаций для сохранения';

  @override
  String get annotateTooltipUndo => 'Отменить';

  @override
  String get annotateTooltipRedo => 'Повторить';

  @override
  String get annotateTooltipSave => 'Сохранить';

  @override
  String get annotateCopiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get annotateToolbarPen => 'Перо';

  @override
  String get annotatePenTipBanner =>
      'Рисуйте одним пальцем. Перемещайте и масштабируйте двумя.';

  @override
  String get annotatePenSheetTitle => 'Настройки пера';

  @override
  String get annotatePenStrokeWidth => 'Толщина линии';

  @override
  String get annotatePenEraserMode => 'Ластик';

  @override
  String get annotateColorBlack => 'Чёрный';

  @override
  String get annotateColorRed => 'Красный';

  @override
  String get annotateColorPurple => 'Фиолетовый';

  @override
  String get annotateColorBlue => 'Синий';

  @override
  String get toolSignPdf => 'Подписать PDF';

  @override
  String get toolSignPdfSubtitle => 'Добавьте подпись и дату в документы';

  @override
  String get signToolbarSign => 'Подпись';

  @override
  String get signToolbarDate => 'Дата';

  @override
  String get signToolbarClearAll => 'Очистить всё';

  @override
  String get signPadTitle => 'Нарисуйте подпись';

  @override
  String get signPadClear => 'Очистить';

  @override
  String get signPadSave => 'Сохранить подпись';

  @override
  String get signSheetTitle => 'Сохранённые подписи';

  @override
  String get signSheetCreateNew => 'Создать новую подпись';

  @override
  String get signMaxSignaturesReached =>
      'Достигнут лимит: максимум 5 сохранённых подписей';

  @override
  String get signMaxPlacedReached =>
      'Достигнут лимит: максимум 20 подписей на документ';

  @override
  String get signDeleteSignatureTitle => 'Удалить подпись?';

  @override
  String get signDeleteSignatureBody =>
      'Эта подпись будет удалена из списка сохранённых.';

  @override
  String get signConfirmClearAllTitle => 'Удалить все подписи?';

  @override
  String get signConfirmClearAllBody =>
      'Все добавленные подписи и даты будут удалены из этого документа.';

  @override
  String get signSaveSuccess => 'Документ успешно подписан';

  @override
  String get signNoSignaturesToSave => 'В документе нет добавленных подписей';

  @override
  String get signPlacedSignatureDelete => 'Удалить';

  @override
  String get signPlacedSignatureApply => 'Применить';

  @override
  String get signTooltipUndo => 'Отменить';

  @override
  String get signTooltipRedo => 'Повторить';

  @override
  String get signTooltipSave => 'Сохранить';

  @override
  String annotatePenStrokeWidthValue(String width) {
    return '$width пт';
  }

  @override
  String get annotateErrorTooManyStrokes =>
      'Достигнут предел документа: 5 000 штрихов или 300 000 точек.';

  @override
  String annotateChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изменений: $count',
      one: '1 изменение',
    );
    return '$_temp0';
  }

  @override
  String get annotatePenNotice =>
      'После сохранения штрихи пера становятся частью страницы и их нельзя будет изменить.';

  @override
  String get annotatePenNoticeDismiss => 'Понятно';

  @override
  String get signPadBaselineHint => 'Распишитесь здесь';

  @override
  String get signPadUndo => 'Отменить';

  @override
  String get signPadUseOnce => 'Использовать один раз';

  @override
  String get signPadSaveAndUse => 'Сохранить и вставить';

  @override
  String get tool_add_text => 'Добавить текст';

  @override
  String get tool_add_text_desc =>
      'Вставляйте текстовые поля и заметки на страницы';

  @override
  String get addTextNoticePermanent =>
      'Добавленный текст становится частью страницы и не редактируется после сохранения.';

  @override
  String get addTextNoticeRaster =>
      'Текст на этом языке добавляется как изображение и не выделяется.';

  @override
  String get addTextNoticeGotIt => 'Понятно';

  @override
  String get addTextActionAdd => 'Добавить текст';

  @override
  String get addTextActionStyle => 'Стиль';

  @override
  String get addTextActionDelete => 'Удалить';

  @override
  String get addTextStyleSheetTitle => 'Стиль текста';

  @override
  String get addTextFontSize => 'Размер шрифта';

  @override
  String get addTextColor => 'Цвет';

  @override
  String get addTextStyle => 'Начертание';

  @override
  String get addTextAlign => 'Выравнивание';

  @override
  String get addTextBold => 'Полужирный';

  @override
  String get addTextItalic => 'Курсив';

  @override
  String get addTextAlignStart => 'По началу';

  @override
  String get addTextAlignCenter => 'По центру';

  @override
  String get addTextAlignEnd => 'По концу';

  @override
  String get addTextErrorTooManyBoxes =>
      'Достигнут лимит: максимум 30 текстовых полей';

  @override
  String get addTextErrorBoxTooLong =>
      'Текстовое поле не может превышать 2 000 символов';

  @override
  String get addTextPlaceholder => 'Введите текст';

  @override
  String get addTextSamplePreview => 'Пример текста';

  @override
  String addTextFontSizePt(int size) {
    return '$size пт';
  }

  @override
  String get premiumTitle => 'Doc View Premium';

  @override
  String get premiumSubtitle =>
      'Откройте инструменты аннотирования и подписи и пользуйтесь приложением без рекламы.';

  @override
  String get premiumFeatureAllTools => 'Аннотации и подпись PDF';

  @override
  String get premiumFeatureAllToolsSub =>
      'Рисуйте пометки, выделяйте текст и легко подписывайте PDF';

  @override
  String get premiumFeatureAdFree => '100% без рекламы';

  @override
  String get premiumFeatureAdFreeSub =>
      'Никаких баннеров, пауз и отвлекающих элементов';

  @override
  String get premiumFeatureUnlimitedConversions =>
      'Безлимитная локальная конвертация';

  @override
  String get premiumFeatureUnlimitedConversionsSub =>
      'Конвертируйте документы на устройстве без ограничений по файлам';

  @override
  String get premiumFeaturePrivacyFirst => '100% приватно и локально';

  @override
  String get premiumFeaturePrivacyFirstSub =>
      'Файлы обрабатываются на устройстве и никогда не отправляются на сервер';

  @override
  String get premiumPlanYearly => 'Годовая подписка';

  @override
  String premiumPlanYearlyTrial(int days, String price) {
    return '$days дн. бесплатно, затем $price/год';
  }

  @override
  String get premiumPlanMonthly => 'Месячная подписка';

  @override
  String premiumPlanMonthlySub(String price) {
    return '$price/мес.';
  }

  @override
  String premiumPlanYearlySub(String price) {
    return '$price/год';
  }

  @override
  String premiumPlanMonthlyTrial(int days, String price) {
    return '$days дн. бесплатно, затем $price/мес.';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Выгода $percent%';
  }

  @override
  String get premiumSaveUnknown => 'Выгода -%';

  @override
  String premiumActionStartTrial(int days) {
    return 'Попробовать $days дн. бесплатно';
  }

  @override
  String get premiumSubscriptionsAvailableSoon =>
      'Подписки скоро станут доступны.';

  @override
  String get premiumLoadPlansFailed => 'Could not load plans. Tap to retry';

  @override
  String errorCodeLabel(String code) {
    return 'Error code: $code';
  }

  @override
  String get pagesEditPagesAction => 'Изменить страницы';

  @override
  String get premiumCancelAnytime => 'Отмена в любой момент';

  @override
  String get premiumPendingStatus =>
      'Покупка обрабатывается в Google Play. Доступ активируется сразу после подтверждения.';

  @override
  String get premiumRenewalDisclosurePricingUnavailable =>
      'Автопродление. Цена будет подтверждена в Google Play при оформлении. Отмена в любое время в разделе подписок Google Play.';

  @override
  String get premiumActionSubscribe => 'Оформить подписку';

  @override
  String get premiumActionRestore => 'Восстановить покупки';

  @override
  String get premiumBillingDisclaimer =>
      'Подписка продлевается автоматически. Отмена в любое время в Google Play.';

  @override
  String get premiumTerms => 'Условия использования';

  @override
  String get premiumPrivacy => 'Политика конфиденциальности';

  @override
  String get premiumActiveStatus => 'У вас активна подписка Premium';

  @override
  String get premiumGraceStatus => 'Активен офлайн-период';

  @override
  String get premiumExpiredStatus => 'Срок подписки истёк';

  @override
  String get premiumRestoreSuccess => 'Покупки успешно восстановлены.';

  @override
  String get premiumRestoreNone => 'Активные подписки не найдены.';

  @override
  String get premiumErrorGeneral =>
      'Не удалось завершить покупку. Попробуйте ещё раз.';

  @override
  String get premiumPagesGateTitle => 'Doc View Premium';

  @override
  String get premiumPagesGateBody =>
      'Изменение порядка, поворот и удаление страниц требуют подписки Premium.';

  @override
  String get premiumPagesGateUpgrade => 'Перейти на Premium';

  @override
  String get premiumTooltip => 'Doc View Premium';

  @override
  String get premiumManageInPlay => 'Управлять';

  @override
  String get faqQuestion8 => 'Что входит в Doc View Premium?';

  @override
  String get faqAnswer8 =>
      'Doc View Premium открывает все расширенные инструменты редактирования: изменение порядка, поворот и удаление страниц PDF, конвертацию PDF в Word, аннотации, подписи и вставку текста, а также полностью отключает всю рекламу в приложении. Обработка документов по-прежнему происходит на 100% локально.';

  @override
  String get faqQuestion9 =>
      'Можно ли пользоваться Doc View Premium без интернета?';

  @override
  String get faqAnswer9 =>
      'Да. После активации Doc View надёжно кэширует статус подписки на устройстве с офлайн-доступом до 7 дней подряд. Всё это время можно свободно пользоваться инструментами редактирования без сети.';

  @override
  String get galleryDebugIapSectionTitle => '15. Симулятор IAP и Premium (G7)';

  @override
  String get galleryDebugIapStateFree => 'Установить Free';

  @override
  String get galleryDebugIapStateYearly => 'Установить годовой Premium';

  @override
  String get galleryDebugIapStateMonthly => 'Установить месячный Premium';

  @override
  String get galleryDebugIapStateGrace => 'Установить офлайн-доступ (активен)';

  @override
  String get galleryDebugIapStateGraceExpired =>
      'Установить офлайн-доступ (истёк)';

  @override
  String get galleryDebugOpenPremium => 'Открыть экран /premium';

  @override
  String get galleryDebugIapProductSeenTrue => 'Продукт просмотрен: True';

  @override
  String get galleryDebugIapProductSeenFalse => 'Продукт просмотрен: False';

  @override
  String get addWidgetSheetTitle => 'Добавить на главный экран';

  @override
  String get addWidgetSheetSubtitle => 'Выберите виджет для главного экрана';

  @override
  String get widgetRecentFilesTitle => 'Недавние файлы';

  @override
  String get widgetRecentFilesBadge => '4 × 2';

  @override
  String get widgetRecentFilesDesc =>
      'Просматривайте и открывайте недавние файлы прямо с главного экрана';

  @override
  String get widgetQuickToolsTitle => 'Быстрые инструменты';

  @override
  String get widgetQuickToolsBadge => '4 × 1';

  @override
  String get widgetQuickToolsDesc =>
      'Мгновенный запуск сканера, фото в PDF, поиска или импорта';

  @override
  String get addWidgetButton => 'Добавить виджет';

  @override
  String get addWidgetManualTitle => 'Добавить виджет вручную';

  @override
  String get addWidgetManualMessage =>
      'Нажмите и удерживайте пустое место на главном экране, выберите «Виджеты», найдите Doc View и перетащите на экран.';

  @override
  String get settingsQuickAccessNotificationTitle => 'Панель быстрого доступа';

  @override
  String get settingsQuickAccessNotificationSubtitle =>
      'Показывать быстрые инструменты в шторке уведомлений';

  @override
  String get notificationPermissionDialogTitle => 'Разрешите уведомления';

  @override
  String get notificationPermissionDialogDesc =>
      'Приложению Doc View нужно разрешение на уведомления, чтобы показывать панель быстрого доступа в шторке.';

  @override
  String get notificationTitle => 'Быстрые инструменты Doc View';

  @override
  String get notificationBody => 'Сканируйте, конвертируйте и ищите документы';

  @override
  String get notificationActionScan => 'Сканировать';

  @override
  String get notificationActionImageToPdf => 'Фото в PDF';

  @override
  String get notificationActionSearch => 'Поиск';

  @override
  String get settingsAdChoicesTitle => 'Настройки рекламы';

  @override
  String get settingsAdChoicesSubtitle =>
      'Управление конфиденциальностью и параметрами рекламы';

  @override
  String get faqQuestion10 => 'Почему в Doc View показывается реклама?';

  @override
  String get faqAnswer10 =>
      'Реклама позволяет сохранять Doc View бесплатным. Подписка Premium отключает её. Объявления предоставляются Google AdMob и не имеют доступа к вашим документам.';
}
