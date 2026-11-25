// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Doc View';

  @override
  String get navHome => 'Todos os arquivos';

  @override
  String get navTools => 'Ferramentas';

  @override
  String get navSettings => 'Configurações';

  @override
  String get noDocumentSelected => 'Nenhum documento selecionado';

  @override
  String get tooltipCloseAd => 'Fechar anúncio';

  @override
  String get tooltipClose => 'Fechar';

  @override
  String get tooltipRescan => 'Verificar documentos novamente';

  @override
  String get tooltipSearch => 'Pesquisar documentos';

  @override
  String get tooltipSelectFiles => 'Selecionar arquivos';

  @override
  String get tooltipBack => 'Voltar';

  @override
  String get tooltipCancelSelection => 'Cancelar seleção';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selecionados',
      one: '1 selecionado',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'Selecionar tudo';

  @override
  String get actionDeselectAll => 'Desmarcar tudo';

  @override
  String get tooltipDeleteSelected => 'Excluir selecionados';

  @override
  String get tooltipClearSearch => 'Limpar pesquisa';

  @override
  String get searchHint => 'Pesquisar documentos, pastas...';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return 'Página $page de $total';
  }

  @override
  String get errorGenericTitle => 'Algo deu errado';

  @override
  String get actionRetry => 'Tentar novamente';

  @override
  String get permissionAllFilesTitle => 'Acesso a todos os arquivos necessário';

  @override
  String get permissionAllFilesExplanation =>
      'O Doc View precisa de acesso a todos os arquivos para navegar pelas pastas e organizar seus documentos totalmente offline.';

  @override
  String get actionGrantAccess => 'Conceder acesso';

  @override
  String get actionImportFilesInstead => 'Importar arquivos';

  @override
  String get tooltipRemoveBookmark => 'Remover dos favoritos';

  @override
  String get tooltipAddBookmark => 'Adicionar aos favoritos';

  @override
  String tooltipFileOptions(String title) {
    return 'Opções do arquivo $title';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return 'Pasta, $name$subtitle';
  }

  @override
  String get adAdvertisementBadge => 'PUBLICIDADE';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get tabRecent => 'Recentes';

  @override
  String get tabBookmarks => 'Favoritos';

  @override
  String get filterCategoryAll => 'Todos';

  @override
  String get actionBrowse => 'Procurar';

  @override
  String get actionCancelOperation => 'Cancelar operação';

  @override
  String get operationComplete => 'Operação concluída';

  @override
  String get actionOpenDocument => 'Abrir documento';

  @override
  String get actionShareDocument => 'Compartilhar documento';

  @override
  String get splashTagline => 'Todos os seus documentos em um só lugar.';

  @override
  String appVersion(String version) {
    return 'Versão $version';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'Etapa $current de $total';
  }

  @override
  String get actionSkip => 'Pular';

  @override
  String get actionBack => 'Voltar';

  @override
  String get actionNext => 'Avançar';

  @override
  String get actionGetStarted => 'Começar';

  @override
  String get onboardingPage1Title => 'Todos os seus documentos\nem um só lugar';

  @override
  String get onboardingPage1Desc =>
      'O Doc View encontra automaticamente arquivos PDF, Word, Excel, PowerPoint, texto e imagens no seu celular e os organiza para você.';

  @override
  String get onboardingPage2Title => 'Leia qualquer arquivo\ncom conforto';

  @override
  String get onboardingPage2Desc =>
      'Abra arquivos PDF, Word, Excel e PowerPoint em um leitor rápido e limpo. Pesquise, favorite e continue de onde parou.';

  @override
  String get onboardingPage3Title => 'Ferramentas de PDF poderosas e offline';

  @override
  String get onboardingPage3Desc =>
      'Transforme fotos em PDF, digitalize documentos, mescle e divida arquivos. Tudo permanece no seu dispositivo.';

  @override
  String get onboardingOfflineGuarantee =>
      'Seus arquivos ficam no seu dispositivo';

  @override
  String get toolImageToPdf => 'Imagem para PDF';

  @override
  String get toolImageToPdfSub => 'Converter JPG e PNG';

  @override
  String get toolScanToPdf => 'Digitalizar para PDF';

  @override
  String get toolScanToPdfSub => 'Detecção de bordas pela câmera';

  @override
  String get toolMergePdf => 'Mesclar PDF';

  @override
  String get toolMergePdfSub => 'Combinar em um único arquivo';

  @override
  String get toolSplitPdf => 'Dividir PDF';

  @override
  String get toolSplitPdfSub => 'Extrair qualquer intervalo';

  @override
  String get permissionTagStorage => 'Acesso ao armazenamento do dispositivo';

  @override
  String get permissionStorageHeadline =>
      'Deixe o Doc View encontrar seus documentos';

  @override
  String get permissionStorageBody =>
      'Para listar arquivos PDF, Word, Excel e outros formatos salvos por qualquer aplicativo, o Android precisa da sua permissão para acessar todos os arquivos. Seus arquivos nunca saem do celular.';

  @override
  String get permissionReassuranceOfflineTitle =>
      'Os arquivos nunca são enviados';

  @override
  String get permissionReassuranceOfflineDesc =>
      'Seus documentos são processados localmente no seu dispositivo.';

  @override
  String get permissionReassuranceNoUploadsTitle => 'Sem uploads';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      'Zero servidores na nuvem. Seus arquivos permanecem estritamente na memória do celular.';

  @override
  String get permissionReassuranceChangeTitle =>
      'Você pode alterar isso a qualquer momento';

  @override
  String get permissionReassuranceChangeDesc =>
      'Ative ou desative facilmente nas configurações de aplicativos do sistema Android.';

  @override
  String get permissionTagIOS => 'Guia de armazenamento no iOS';

  @override
  String get permissionIOSHeadline => 'Traga seus documentos para o Doc View';

  @override
  String get permissionIOSBody =>
      'Devido à arquitetura de privacidade da Apple, o iOS não permite que nenhum app verifique todo o iPhone automaticamente. Escolha como deseja ler seus arquivos:';

  @override
  String get permissionIOSOptionImportTitle => 'Importar arquivos';

  @override
  String get permissionIOSBadgeFastest => 'MAIS RÁPIDO';

  @override
  String get permissionIOSOptionImportDesc =>
      'Escolha documentos diretamente do iCloud Drive, Downloads ou qualquer pasta em segundos.';

  @override
  String get permissionIOSOptionFolderTitle =>
      'Abrir a pasta do Doc View no app Arquivos';

  @override
  String get permissionIOSOptionFolderDesc =>
      'Salve ou envie documentos via AirDrop diretamente para a pasta \"Doc View\" no app Arquivos do iOS para sincronização instantânea.';

  @override
  String get actionImportFiles => 'Importar arquivos';

  @override
  String get actionContinueToApp => 'Continuar para o app';

  @override
  String get permissionTagConsent => 'Transparência e consentimento';

  @override
  String get permissionBadgeFree => 'App 100% gratuito';

  @override
  String get permissionBadgeMinimalAds => 'Poucos anúncios';

  @override
  String get permissionConsentHeadline => 'Gratuito com anúncios';

  @override
  String get permissionConsentBody =>
      'O Doc View é gratuito graças aos anúncios. A seguir, pediremos sua escolha sobre anúncios personalizados.';

  @override
  String get permissionConsentAdsTitle => 'Quais anúncios você pode ver';

  @override
  String get permissionConsentAdsDesc =>
      'Pequenos banners e cartões patrocinados discretos. Sem pop-ups ou interrupções de vídeo durante a leitura.';

  @override
  String get permissionConsentPrivateTitle =>
      'Seus documentos continuam totalmente privados';

  @override
  String get permissionConsentPrivateDesc =>
      'Parceiros de anúncios nunca têm acesso aos nomes, ao conteúdo de texto ou à localização dos seus documentos.';

  @override
  String get permissionConsentSettingsTitle =>
      'Você pode mudar sua escolha nas Configurações';

  @override
  String get permissionConsentSettingsDesc =>
      'Atualize o consentimento de anúncios personalizados ou preferências de privacidade a qualquer momento nas Configurações do Doc View.';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionPrivacyPolicy => 'Política de privacidade';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos importados',
      one: '1 arquivo importado',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => 'Falha ao importar arquivos';

  @override
  String get tooltipImportDocuments => 'Importar documentos';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos encontrados',
      one: '1 arquivo encontrado',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => 'Verificando...';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos',
      one: '1 arquivo',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => 'Pastas';

  @override
  String get errorLoadingRecent => 'Erro ao carregar arquivos recentes';

  @override
  String get emptyStateTitle => 'Vazio';

  @override
  String get emptyRecentDescription =>
      'Os arquivos abertos recentemente aparecerão aqui';

  @override
  String get errorLoadingBookmarks => 'Erro ao carregar favoritos';

  @override
  String get emptyBookmarksDescription =>
      'Os documentos favoritados aparecerão aqui';

  @override
  String get dialogDeleteTitle => 'Excluir arquivos selecionados?';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Excluir $count arquivos? Essa ação não pode ser desfeita.',
      one: 'Excluir 1 arquivo? Essa ação não pode ser desfeita.',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos excluídos',
      one: '1 arquivo excluído',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => 'Falha ao excluir arquivos';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get searchRecentSearchesHeader => 'PESQUISAS RECENTES';

  @override
  String get actionClear => 'Limpar';

  @override
  String get searchPromptTitle => 'Digite para pesquisar documentos';

  @override
  String get searchPromptMessage =>
      'Pesquise em todas as pastas locais pelo nome ou extensão do arquivo';

  @override
  String get searchError => 'Erro ao pesquisar documentos';

  @override
  String get searchNoResultsTitle =>
      'Nenhum documento correspondente encontrado';

  @override
  String get searchNoResultsMessage =>
      'Tente pesquisar com outra palavra-chave no nome do arquivo ou filtro de formato';

  @override
  String get tooltipSortOptions => 'Opções de ordenação';

  @override
  String get sortSheetTitle => 'Ordenar por';

  @override
  String get sortOptionDate => 'Data de modificação';

  @override
  String get sortOptionName => 'Nome do documento';

  @override
  String get sortOptionSize => 'Tamanho do arquivo';

  @override
  String get sortAscendingOrder => 'Ordem crescente';

  @override
  String get sortAscendingSubtitle => 'Mais antigos / A a Z / Menores primeiro';

  @override
  String get sortDescendingSubtitle =>
      'Mais recentes / Z a A / Maiores primeiro';

  @override
  String get categoryAllFiles => 'Todos os arquivos';

  @override
  String get loadingStatus => 'Carregando...';

  @override
  String get emptyCategoryImagesTitle => 'Nenhuma imagem encontrada';

  @override
  String get emptyCategoryImagesMessage =>
      'As imagens encontradas neste dispositivo aparecerão aqui';

  @override
  String get emptyCategoryDocsTitle => 'Nenhum documento encontrado';

  @override
  String get emptyCategoryDocsMessage =>
      'Documentos deste formato aparecerão aqui após a verificação';

  @override
  String get actionOpen => 'Abrir';

  @override
  String get actionShare => 'Compartilhar';

  @override
  String get actionRename => 'Renomear';

  @override
  String get actionBookmark => 'Favoritar';

  @override
  String get actionRemoveBookmark => 'Remover dos favoritos';

  @override
  String get actionOpenInAnotherApp => 'Abrir em outro app';

  @override
  String get actionDetails => 'Detalhes';

  @override
  String get actionOpenFile => 'Abrir arquivo';

  @override
  String get actionShareAll => 'Compartilhar tudo';

  @override
  String get actionDone => 'Concluído';

  @override
  String get actionSeeAll => 'Ver tudo';

  @override
  String get actionAllow => 'Permitir';

  @override
  String get actionNotNow => 'Agora não';

  @override
  String get tooltipMoreActions => 'Mais ações';

  @override
  String get tooltipCopyPath => 'Copiar caminho';

  @override
  String get tooltipRotatePage => 'Girar página';

  @override
  String get tooltipRemovePage => 'Remover página';

  @override
  String get renameFileTitle => 'Renomear arquivo';

  @override
  String get renameFileNameLabel => 'Nome do arquivo';

  @override
  String renamedSuccess(String fileName) {
    return 'Renomeado para $fileName';
  }

  @override
  String get deleteFileTitle => 'Excluir arquivo?';

  @override
  String deleteFileConfirmation(String fileName) {
    return 'Excluir \"$fileName\"? Isso não pode ser desfeito.';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return '\"$fileName\" excluído';
  }

  @override
  String get fileDetailsTitle => 'Detalhes do documento';

  @override
  String get fileDetailsLabelName => 'Nome';

  @override
  String get fileDetailsLabelType => 'Tipo';

  @override
  String get fileDetailsLabelSize => 'Tamanho';

  @override
  String get fileDetailsLabelModified => 'Modificado';

  @override
  String get fileDetailsLabelBookmarked => 'Favoritado';

  @override
  String get fileDetailsValueYes => 'Sim';

  @override
  String get fileDetailsValueNo => 'Não';

  @override
  String get fileDetailsLabelLocation => 'Localização';

  @override
  String get fileDetailsPathCopied =>
      'Caminho copiado para a área de transferência';

  @override
  String get directoriesTitle => 'Diretórios';

  @override
  String get directoriesGoBack => 'Voltar';

  @override
  String get directoriesGoToRoot => 'Ir para a raiz';

  @override
  String get directoriesRetry => 'Tentar novamente';

  @override
  String get directoriesFileNoLongerExists => 'O arquivo não existe mais';

  @override
  String get directoriesFolderNoLongerExists => 'Esta pasta não existe mais.';

  @override
  String get directoriesNoDocsInFolder => 'Nenhum documento nesta pasta';

  @override
  String get directoriesFilesAppearHere =>
      'Os arquivos aparecerão aqui quando adicionados';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => 'Pasta';

  @override
  String get directoriesPermissionPromptTitle =>
      'Acesso necessário para ver diretórios';

  @override
  String get directoriesPermissionPromptBody =>
      'O Doc View precisa de acesso a todos os arquivos para navegar pelas suas pastas.';

  @override
  String get directoriesGrantAccess => 'Conceder acesso';

  @override
  String get directoriesImportInstead => 'Importar arquivos';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos importados',
      one: '1 arquivo importado',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => 'Subir um nível';

  @override
  String get storageAccessRequiredTitle => 'Acesso ao armazenamento necessário';

  @override
  String get storageAccessRequiredBody =>
      'O Doc View precisa de acesso ao armazenamento para verificar e exibir documentos (PDF, Word, Excel, PPT, TXT, imagens) salvos no seu dispositivo.\n\nSeus arquivos permanecem totalmente privados e offline no seu dispositivo.';

  @override
  String errorCouldNotOpenDocument(String error) {
    return 'Não foi possível abrir o documento: $error';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Verificação concluída: $count arquivos',
      one: 'Verificação concluída: 1 arquivo',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => 'Limpar histórico de pesquisa?';

  @override
  String get dialogClearSearchMessage =>
      'Todas as pesquisas recentes serão apagadas permanentemente.';

  @override
  String imageListEditorMaxLimit(int max) {
    return 'Limite máximo de $max imagens atingido.';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return 'Falha na digitalização: $error';
  }

  @override
  String get imageListEditorPageSize => 'Tamanho da página:';

  @override
  String get imageListEditorA4Mode => 'A4';

  @override
  String get imageListEditorFitMode => 'Ajustar à imagem';

  @override
  String get imageListEditorRemoveImageTooltip => 'Remover imagem';

  @override
  String get mergeScreenTitle => 'Organizar e mesclar';

  @override
  String get mergeScreenDefaultMergedName => 'Documento_Mesclado';

  @override
  String get mergePickerSearchHint => 'Pesquisar PDFs...';

  @override
  String get mergePickerNext => 'Avançar';

  @override
  String mergePickerErrorLoading(String error) {
    return 'Erro ao carregar PDFs: $error';
  }

  @override
  String get splitScreenTitle => 'Dividir PDF';

  @override
  String get splitScreenRangeHint => 'ex.: 1-3, 5, 8-10';

  @override
  String get splitScreenClearRange => 'Limpar intervalo';

  @override
  String get splitPickerSearchHint => 'Pesquisar PDFs...';

  @override
  String splitPickerErrorLoading(String error) {
    return 'Erro ao carregar arquivos: $error';
  }

  @override
  String get createdSectionTitle => 'Criados por você';

  @override
  String get createdSectionEmptyTitle =>
      'Os PDFs que você criar aparecerão aqui';

  @override
  String get createdSectionEmptySubtitle =>
      'Documentos convertidos, digitalizados ou mesclados serão salvos localmente.';

  @override
  String get emptyCreatedDocsTitle => 'Nenhum documento criado ainda';

  @override
  String get emptyCreatedDocsMessage =>
      'Documentos convertidos, digitalizados ou mesclados aparecerão aqui.';

  @override
  String errorLoadingCreatedFiles(String error) {
    return 'Falha ao carregar arquivos criados: $error';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDFs criados',
      one: 'PDF criado',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle => 'Salvo na sua pasta de criados';

  @override
  String get toolErrorDefaultTitle => 'Não foi possível criar o PDF';

  @override
  String get toolErrorSubtitle =>
      'Ocorreu um erro inesperado durante o processamento';

  @override
  String get themeSheetTitle => 'Tema do app';

  @override
  String get themeSheetSubtitle => 'Selecione a aparência visual do Doc View';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeSystemSubtitle => 'padrão';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeLightSubtitle => 'Branco limpo';

  @override
  String get themeModeDark => 'Escuro';

  @override
  String get themeModeDarkSubtitle => 'Azul-marinho profundo';

  @override
  String get themeActionApply => 'Aplicar tema';

  @override
  String get scanSettingsTitle => 'Configurações de verificação';

  @override
  String get scanSettingsFrequencyHeader => 'Frequência de verificação';

  @override
  String get scanSettingsOnOpenTitle => 'Verificar ao abrir o app';

  @override
  String get scanSettingsOnOpenSubtitle =>
      'Encontrar novos arquivos automaticamente ao abrir o Doc View.';

  @override
  String get scanSettingsManualTitle => 'Apenas manual';

  @override
  String get scanSettingsManualSubtitle =>
      'Verificar apenas ao puxar para atualizar ou tocar em Verificar novamente.';

  @override
  String get scanSettingsMediaFiltersHeader => 'Filtros de mídia';

  @override
  String get scanSettingsIncludeImagesTitle => 'Incluir imagens na verificação';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      'Indexar arquivos de imagem PNG, JPG e WEBP no armazenamento.';

  @override
  String get scanSettingsDiagnosticsHeader => 'Armazenamento e diagnósticos';

  @override
  String get scanSettingsPermissionStatus => 'Acesso a todos os arquivos';

  @override
  String get scanSettingsPermissionGranted => 'Concedido';

  @override
  String get scanSettingsPermissionNotGranted => 'Não concedido';

  @override
  String get scanSettingsTotalIndexed => 'Arquivos indexados';

  @override
  String get scanSettingsLastScan => 'Última verificação';

  @override
  String get scanSettingsUpdatedSnackbar =>
      'Configurações de verificação atualizadas';

  @override
  String get faqScreenTitle => 'Perguntas frequentes';

  @override
  String faqHeaderTopics(int count) {
    return '$count tópicos';
  }

  @override
  String get faqHeaderSubtitle =>
      'Tem dúvidas? Encontre respostas claras aqui.';

  @override
  String get faqSendFeedback => 'Enviar feedback';

  @override
  String get faqQuestion1 =>
      'Por que o Doc View precisa de acesso a todos os arquivos?';

  @override
  String get faqAnswer1 =>
      'O Doc View requer acesso a todos os arquivos (MANAGE_EXTERNAL_STORAGE) no Android 11+ para localizar e indexar documentos compatíveis (PDF, Word, Excel, PowerPoint, texto e imagens) armazenados em pastas compartilhadas como Downloads e Documentos.\n\nSem essa permissão, o Android restringe o acesso apenas à pasta interna privada do aplicativo, impedindo o Doc View de navegar ou abrir arquivos salvos no seu dispositivo.';

  @override
  String get faqQuestion2 => 'Por que ele não verifica todo o meu iPhone?';

  @override
  String get faqAnswer2 =>
      'O iOS usa isolamento rigoroso de aplicativos (sandbox) para proteger a privacidade do dispositivo. Os apps só podem acessar documentos salvos explicitamente no app Arquivos ou compartilhados pelo menu Compartilhar do sistema.\n\nPara visualizar arquivos no iOS, importe-os para a pasta Doc View no app nativo Arquivos ou use a opção Importar arquivos nas Configurações.';

  @override
  String get faqQuestion3 => 'Onde ficam salvos os PDFs que eu crio?';

  @override
  String get faqAnswer3 =>
      'Os arquivos importados ou gerados (como PDFs convertidos, documentos mesclados ou páginas divididas) são salvos com segurança no armazenamento do dispositivo em DocView/Created ou no armazenamento privado do app. Você pode vê-los a qualquer momento na seção Criados por você na aba Ferramentas.';

  @override
  String get faqQuestion4 => 'Por que meu arquivo do Word parece diferente?';

  @override
  String get faqAnswer4 =>
      'O Doc View renderiza arquivos diretamente no seu dispositivo usando leitores offline locais, sem enviar dados privados para conversores na nuvem. Formatações complexas ou formas personalizadas são exibidas com aproximações nativas offline.';

  @override
  String get faqQuestion5 => 'Posso abrir arquivos protegidos por senha?';

  @override
  String get faqAnswer5 =>
      'Sim, o Doc View oferece suporte à abertura de documentos PDF protegidos por senha. Ao abrir um PDF criptografado, digite a senha na caixa de diálogo para descriptografar e visualizar o documento no seu dispositivo.';

  @override
  String get faqQuestion6 => 'Meus dados são enviados para algum lugar?';

  @override
  String get faqAnswer6 =>
      'Seus documentos nunca saem do seu dispositivo. O Doc View abre, converte e armazena arquivos localmente. O aplicativo exibe anúncios fornecidos pelo Google AdMob, que pode usar dados limitados do dispositivo conforme descrito em nossa Política de Privacidade.';

  @override
  String get faqQuestion7 =>
      'Por que a conversão de PDF para Word mudou meu layout?';

  @override
  String get faqAnswer7 =>
      'O Doc View converte apenas o texto, diretamente no seu dispositivo. Tabelas, imagens, cores e layout não são mantidos. PDFs digitalizados não podem ser convertidos porque não há texto para ler.';

  @override
  String get toolPdfToWord => 'PDF para Word';

  @override
  String get toolPdfToWordSub => 'Converter PDF em documento editável do Word';

  @override
  String get pdfToWordScreenTitle => 'PDF para Word';

  @override
  String get pdfToWordBannerText =>
      'Apenas o texto é convertido. Tabelas, imagens, cores e layout não são mantidos.';

  @override
  String get pdfToWordPageBreaks =>
      'Inserir quebras de página entre páginas do PDF';

  @override
  String get pdfToWordPageBreaksSubtitle =>
      'Preserva a estrutura do documento entre as páginas';

  @override
  String get pdfToWordSelectPdf => 'Selecionar PDF';

  @override
  String get pdfToWordChangeFile => 'Trocar arquivo';

  @override
  String get pdfToWordConvertAction => 'Converter para Word';

  @override
  String get pdfToWordConverting => 'Convertendo para Word...';

  @override
  String pdfToWordConvertingProgress(int current, int total) {
    return 'Convertendo página $current de $total...';
  }

  @override
  String get pdfToWordSuccess => 'Convertido para Word com sucesso';

  @override
  String get pdfToWordOpenInViewer => 'Abrir no Doc View';

  @override
  String get pdfToWordOpenWith => 'Abrir com...';

  @override
  String get pdfToWordShare => 'Compartilhar';

  @override
  String get pdfToWordNoTextTitle => 'Nenhum texto encontrado';

  @override
  String get pdfToWordNoTextMessage =>
      'Nenhum texto foi encontrado neste PDF. Documentos digitalizados não podem ser convertidos.';

  @override
  String get pdfToWordLargeFileWarning =>
      'Documento grande: a conversão pode levar vários minutos.';

  @override
  String get pdfToWordInvalidFileName => 'Nome de arquivo inválido';

  @override
  String get pdfToWordActionCancel => 'Cancelar';

  @override
  String get pdfToWordEncryptedError =>
      'O PDF selecionado está protegido por senha. Desbloqueie-o para converter.';

  @override
  String get pdfToWordPageLimitError =>
      'O documento excede o limite de 1.000 páginas.';

  @override
  String get pdfToWordTextLimitError =>
      'O documento excede o limite de 20 MB de texto.';

  @override
  String get pdfToWordGeneralError =>
      'Falha ao converter PDF para Word. Tente outro arquivo.';

  @override
  String get pdfGotoPageTitle => 'Ir para a página';

  @override
  String pdfGotoPageHint(int pageCount) {
    return 'Digite uma página entre 1 e $pageCount';
  }

  @override
  String get pdfGotoPageAction => 'Ir';

  @override
  String get pdfGotoPageErrorEmpty => 'Digite um número de página';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return 'Digite uma página entre 1 e $pageCount';
  }

  @override
  String get pdfPasswordTitle => 'Este PDF está protegido por senha';

  @override
  String get pdfPasswordSubtitle =>
      'Digite a senha para descriptografar e visualizar o conteúdo.';

  @override
  String get pdfPasswordHint => 'Digite a senha';

  @override
  String get pdfPasswordErrorIncorrect => 'Senha incorreta. Tente novamente.';

  @override
  String get pdfPasswordActionUnlock => 'Desbloquear';

  @override
  String get errorFileNameEmpty => 'O nome do arquivo não pode ficar vazio';

  @override
  String get errorFileNameTooLong =>
      'O nome do arquivo não pode exceder 120 caracteres';

  @override
  String get errorFileNameReserved =>
      'O nome do arquivo não pode ser \'.\' ou \'..\'';

  @override
  String get errorFileNameStartsWithDot =>
      'O nome do arquivo não pode começar com um ponto';

  @override
  String get errorFileNameInvalidChars =>
      'O nome do arquivo contém caracteres inválidos';

  @override
  String get errorRenameAlreadyExists =>
      'Já existe um arquivo com este nome nesta pasta';

  @override
  String get errorRenameSourceNotFound =>
      'O arquivo de origem não existe mais no armazenamento';

  @override
  String errorRenameFailed(String details) {
    return 'Falha ao renomear arquivo: $details';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      'Arquivos excluídos do disco, mas falhou ao atualizar o banco de dados';

  @override
  String errorDeleteFailed(String details) {
    return 'Falha ao excluir arquivos: $details';
  }

  @override
  String get errorPageRangeDocNoPages => 'O documento não tem páginas';

  @override
  String get errorPageRangeEmpty =>
      'O intervalo de páginas não pode ficar vazio';

  @override
  String get errorPageRangeEmptySegment =>
      'Segmento de intervalo vazio encontrado. Remova vírgulas extras.';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return 'Formato de intervalo inválido: \'$token\'';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return 'Intervalo incompleto: \'$token\'';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return 'Valores não numéricos no intervalo: \'$token\'';
  }

  @override
  String get errorPageRangeBelowMinimum =>
      'Os números de página devem ser 1 ou maiores';

  @override
  String errorPageRangeReversed(int start, int end) {
    return 'Intervalo invertido \'$start-$end\': o início é maior que o fim';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return 'O intervalo \'$token\' excede o total de páginas ($totalPages)';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return 'Número de página inválido: \'$token\'';
  }

  @override
  String get errorImageToPdfNoImages => 'Selecione pelo menos uma imagem';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return 'Máximo de $max imagens permitidas por vez';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return 'Falha ao processar imagem: $path';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return 'Falha ao criar PDF a partir das imagens: $details';
  }

  @override
  String get errorPdfMergeInsufficient =>
      'Selecione pelo menos 2 arquivos PDF para mesclar';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return '$fileName está protegido por senha ou danificado';
  }

  @override
  String get errorPdfMergeNoPages =>
      'Os documentos selecionados não contêm páginas';

  @override
  String errorPdfMergeFailed(String details) {
    return 'Falha ao mesclar PDFs: $details';
  }

  @override
  String get errorPdfSplitNoRanges =>
      'Especifique pelo menos um intervalo de páginas';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return '$fileName está protegido por senha ou danificado';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return 'O intervalo $start-$end está fora dos limites de $fileName';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return 'Falha ao dividir PDF: $details';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return 'PÁG $current/$total';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '($bytes bytes)';
  }

  @override
  String get directoriesProtectedTitle =>
      'Esta pasta é protegida pelo Android.';

  @override
  String get directoriesProtectedDesc =>
      'O Android restringe o acesso a pastas do sistema e pastas privadas de aplicativos.';

  @override
  String get directoriesNotFoundTitle => 'Esta pasta não existe mais.';

  @override
  String get directoriesEmpty => 'Nenhum arquivo ou pasta compatível aqui.';

  @override
  String get directoriesErrorOpening => 'Erro ao abrir a pasta';

  @override
  String get directoriesRoot => 'Raiz';

  @override
  String get scanSettingsSectionFrequency => 'Frequência de verificação';

  @override
  String get scanSettingsSectionFilters => 'Filtros de documentos';

  @override
  String get scanSettingsIncludeImages => 'Incluir imagens';

  @override
  String get scanSettingsIncludeImagesDesc =>
      'Desative para ocultar milhares de fotos da sua lista de documentos';

  @override
  String get scanSettingsImageListUpdated => 'Lista de imagens atualizada';

  @override
  String get scanSettingsActionRescanNow => 'Verificar agora';

  @override
  String get scanSettingsSectionDiagnostics => 'Diagnóstico de armazenamento';

  @override
  String get scanSettingsAllFilesAccessGranted =>
      'Acesso a todos os arquivos concedido';

  @override
  String get scanSettingsAllFilesAccessNeeded =>
      'Acesso a todos os arquivos necessário';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      'O Doc View tem permissão para encontrar arquivos em Downloads e cartões SD.';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      'É necessária permissão para verificar pastas de downloads e armazenamento externo.';

  @override
  String get scanSettingsActionOpenSettings => 'Abrir configurações';

  @override
  String scanSettingsScanningFiles(int count) {
    return 'Verificando... $count arquivos encontrados';
  }

  @override
  String get faqStillNeedHelp => 'Ainda precisa de ajuda? Envie feedback';

  @override
  String get toolsLabelFileName => 'Nome do arquivo';

  @override
  String get toolsAddImagesToStart => 'Adicione imagens para começar';

  @override
  String get toolsAddImagesDesc =>
      'Selecione fotos ou digitalize documentos em papel para gerar um PDF.';

  @override
  String get toolsChoosePhotos => 'Escolher fotos';

  @override
  String get toolsScanPaper => 'Digitalizar papel';

  @override
  String toolsPageNumber(int page) {
    return 'Página $page';
  }

  @override
  String get toolsTooltipRotatePage => 'Girar página';

  @override
  String get toolsTooltipRemovePage => 'Remover página';

  @override
  String get toolsAddMoreScans => 'Adicionar mais digitalizações';

  @override
  String get toolsAddMoreImages => 'Adicionar mais imagens';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imagens · est. ~ $size',
      one: '1 imagem · est. ~ $size',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return '$count selecionado(s)';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return 'Selecione pelo menos $min arquivos';
  }

  @override
  String toolsPagesTotal(int count) {
    return '$count páginas no total';
  }

  @override
  String get toolsPagesTotalLabel => 'páginas no total';

  @override
  String get toolsNoPdfsFound => 'Nenhum documento PDF encontrado';

  @override
  String get semanticBookmarked => 'favoritado';

  @override
  String get semanticSelected => 'selecionado';

  @override
  String get semanticNotSelected => 'não selecionado';

  @override
  String get actionDeselectFile => 'Desmarcar arquivo';

  @override
  String get actionSelectFile => 'Selecionar arquivo';

  @override
  String get actionCreatePdf => 'Criar PDF';

  @override
  String get hintSelectOrViewActions => 'Selecionar ou ver ações';

  @override
  String get actionClose => 'Fechar';

  @override
  String get actionReset => 'Redefinir';

  @override
  String get labelPleaseWait => 'Aguarde...';

  @override
  String get tooltipCloseSearch => 'Fechar pesquisa';

  @override
  String get semanticAdvertisement => 'Publicidade';

  @override
  String get themePreviewLight => 'Claro';

  @override
  String get themePreviewNavy => 'Marinho';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '$name, $size, criado em $date';
  }

  @override
  String get toolsCreatingPdfFromScans => 'Criando PDF das digitalizações';

  @override
  String get toolsCreatingPdf => 'Criando PDF';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return 'Processando imagem $done de $total...';
  }

  @override
  String get toolsErrorCreatePdfTitle => 'Não foi possível criar o PDF';

  @override
  String get toolsBadgeProtectedOrDamaged => 'Protegido ou danificado';

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
  String get toolsPagesAbbrev => 'págs';

  @override
  String get mergeAddMoreTitle => 'Adicionar mais PDFs';

  @override
  String get mergeProgressTitle => 'Mesclando PDFs';

  @override
  String mergeProgressMessage(int done, int total) {
    return 'Mesclando documento $done de $total...';
  }

  @override
  String get mergeErrorTitle => 'Não foi possível mesclar os PDFs';

  @override
  String get mergeDragInstruction => 'Arraste as alças para reordenar';

  @override
  String get mergeAddPdf => 'Adicionar PDF';

  @override
  String get mergeOutputFileNameLabel => 'NOME DO ARQUIVO DE SAÍDA';

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
    return 'Carregando páginas... · $size';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos inválidos detectados',
      one: '1 arquivo inválido detectado',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => 'Pronto para mesclar';

  @override
  String get mergeRemoveProtectedHint =>
      'Remova os documentos protegidos por senha';

  @override
  String mergeSummary(int files, int pages, String size) {
    return '$files arquivos · $pages páginas · ~ $size';
  }

  @override
  String get mergeReadyBadge => 'Pronto';

  @override
  String get mergeBlockedCta => 'Mesclagem bloqueada (resolva os erros)';

  @override
  String mergeActionCta(int files, int pages) {
    return 'Mesclar $files PDFs ($pages páginas)';
  }

  @override
  String get mergePickerDefaultTitle => 'Selecionar PDFs';

  @override
  String mergePickerTabAllPdfs(int count) {
    return 'Todos os PDFs ($count)';
  }

  @override
  String get mergePickerTabRecent => 'Recentes';

  @override
  String get mergePickerTabDownloads => 'Downloads';

  @override
  String get mergePickerTabICloud => 'iCloud Drive';

  @override
  String get splitProgressTitle => 'Dividindo PDF';

  @override
  String splitProgressMessage(int done, int total) {
    return 'Gerando arquivo $done de $total...';
  }

  @override
  String get splitErrorTitle => 'Não foi possível dividir o PDF';

  @override
  String get splitPageRangesLabel => 'INTERVALOS DE PÁGINAS';

  @override
  String get splitPageRangesSyntax => 'Sintaxe: 1-3, 5, 8-10';

  @override
  String get splitRangeHelpText =>
      'Cada intervalo vira um arquivo PDF separado.';

  @override
  String splitGeneratedFilesHeader(int count) {
    return 'ARQUIVOS GERADOS ($count)';
  }

  @override
  String get splitChipsSuspendedTitle => 'Prévia dos intervalos suspensa';

  @override
  String get splitChipsSuspendedDesc =>
      'Corrija o erro de sintaxe acima para reconstruir a lista de extração.';

  @override
  String get splitEmptyRangesHint =>
      'Digite intervalos de páginas acima para gerar divisões do PDF';

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
      other: '$count págs',
      one: '1 pág',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => 'SELEÇÃO RÁPIDA';

  @override
  String get splitMacroAllPages => 'Todas as páginas';

  @override
  String get splitMacroEvery5Pages => 'A cada 5 páginas';

  @override
  String get splitMacroLimitHint =>
      'Macros que geram > 100 arquivos ficam desativadas para proteger a memória do dispositivo';

  @override
  String splitOutputSummary(int files, int pages) {
    return 'Saída: $files arquivos · $pages páginas extraídas';
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
      other: 'Dividir em $count PDFs',
      one: 'Dividir em 1 PDF',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => 'Dividir em PDFs';

  @override
  String splitPickerAllLocalDocs(int count) {
    return 'TODOS OS DOCUMENTOS LOCAIS ($count)';
  }

  @override
  String get splitPickerSortByDate => 'ORDENAR POR DATA';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return 'págs · $size';
  }

  @override
  String get splitPickerTitle => 'Selecionar PDF para dividir';

  @override
  String get faqShortTitle => 'FAQ';

  @override
  String splitPickerSelectedCount(int count) {
    return '$count PDF selecionado';
  }

  @override
  String get splitPickerSelectDocumentHint =>
      'Selecione um documento para continuar';

  @override
  String splitPickerPagesActive(int count) {
    return '$count páginas ativas';
  }

  @override
  String get splitPickerPagesActiveLabel => 'páginas ativas';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSectionGeneral => 'Geral';

  @override
  String get settingsSectionOthers => 'Outros';

  @override
  String get settingsFileManagerTitle => 'Gerenciador de arquivos';

  @override
  String get settingsFileManagerSubtitle =>
      'Navegar por diretórios e pastas do armazenamento';

  @override
  String get settingsFaqTitle => 'FAQ';

  @override
  String get settingsFaqSubtitle => 'Perguntas frequentes';

  @override
  String get settingsShareTitle => 'Compartilhar';

  @override
  String get settingsShareSubtitle => 'Recomende o Doc View para amigos';

  @override
  String settingsShareMessage(String url) {
    return 'Conheça o Doc View — leitor de documentos rápido, privado e offline: $url';
  }

  @override
  String get settingsScanSettingsTitle => 'Configurações de verificação';

  @override
  String get settingsScanModeOnOpen => 'Verificar ao abrir';

  @override
  String get settingsScanModeManual => 'Apenas manual';

  @override
  String get settingsAppThemeTitle => 'Tema do app';

  @override
  String get settingsThemeSystem => 'Padrão do sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Escuro';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsRateUsTitle => 'Avalie-nos';

  @override
  String get settingsRateUsSubtitle => 'Compartilhe sua opinião conosco';

  @override
  String get settingsAddWidgetTitle => 'Adicionar widget';

  @override
  String get settingsAddWidgetSubtitle => 'Acesso rápido pela tela inicial';

  @override
  String get settingsTermsTitle => 'Termos de uso';

  @override
  String get settingsTermsSubtitle => 'Leia nossos termos de serviço';

  @override
  String get settingsPrivacyTitle => 'Política de privacidade';

  @override
  String get settingsPrivacySubtitle => 'Leia nossa política de privacidade';

  @override
  String get settingsManageSubscriptionsTitle => 'Gerenciar assinaturas';

  @override
  String get settingsManageSubscriptionsSubtitle =>
      'Gerencie sua assinatura na loja';

  @override
  String settingsVersionDisplay(String version, String build) {
    return 'Versão $version ($build)';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return 'Versão $version compilação $build';
  }

  @override
  String get settingsOpenSourceLicenses => 'Licenças de código aberto';

  @override
  String get rateSheetTitle => 'Avaliar o Doc View';

  @override
  String get rateSheetSubtitle => 'Seu feedback nos ajuda a melhorar';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estrelas',
      one: '1 estrela',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => 'Que bom que você gostou!';

  @override
  String get rateResponseMedium => 'Obrigado! Conte como podemos melhorar.';

  @override
  String get rateResponseLow =>
      'Sentimos muito por não atender às expectativas. Conte o que corrigir.';

  @override
  String get rateActionStore => 'Avaliar no Google Play';

  @override
  String get rateActionHelpFeedback => 'Ajuda e feedback';

  @override
  String get faqFromRatingBanner =>
      'Sentimos muito por isso. Confira as respostas abaixo ou entre em contato; lemos todas as mensagens.';

  @override
  String get faqActionContactUs => 'Fale conosco';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return 'Feedback do Doc View ($version+$build)';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '\n\n---\nApp: Doc View $version (Build $build)\n';
  }

  @override
  String get faqEmailClientUnavailable =>
      'Não foi possível abrir o cliente de e-mail';

  @override
  String get languageScreenTitle => 'Idioma';

  @override
  String get languageSearchHint => 'Pesquisar idiomas...';

  @override
  String get languageSystemDefault => 'Padrão do sistema';

  @override
  String get languageSystemDefaultSubtitle => 'Seguir o idioma do dispositivo';

  @override
  String get languageNotTranslatedBadge => '(não traduzido)';

  @override
  String get languageNotTranslatedSnack =>
      'Este idioma ainda não está traduzido';

  @override
  String get languageNoResults => 'Nenhum idioma encontrado';

  @override
  String get languagePseudoLocaleName => 'Pseudoidioma (en_XA)';

  @override
  String get languagePseudoLocaleSubtitle => 'Teste de expansão para depuração';

  @override
  String get scanSettingsSectionHistory => 'Histórico';

  @override
  String get scanSettingsClearHistoryTitle => 'Limpar histórico recente';

  @override
  String get scanSettingsClearHistorySubtitle =>
      'Limpar histórico de documentos abertos';

  @override
  String get scanSettingsClearHistoryDialogTitle => 'Limpar histórico recente?';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      'Os arquivos serão removidos de Recentes. Seus arquivos e favoritos não serão afetados.';

  @override
  String get scanSettingsRecentHistoryCleared => 'Histórico recente limpo';

  @override
  String get scanSettingsLastScanToday => 'hoje';

  @override
  String get scanSettingsLastScanYesterday => 'ontem';

  @override
  String get scanSettingsNeverScanned => 'Nunca verificado';

  @override
  String get scanSettingsLastScanPrefix => 'Última verificação:';

  @override
  String get readerActionVertical => 'Vertical';

  @override
  String get readerActionHorizontal => 'Horizontal';

  @override
  String get readerActionRotate => 'Girar';

  @override
  String get readerActionSearch => 'Pesquisar';

  @override
  String get readerActionInvert => 'Inverter';

  @override
  String get readerActionShare => 'Compartilhar';

  @override
  String get readerActionPages => 'Páginas';

  @override
  String get readerSearchHint => 'Pesquisar no documento...';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '$current de $total';
  }

  @override
  String get readerSearchMatchCap => '500+';

  @override
  String get readerSearchNoMatches => '0 de 0';

  @override
  String get readerSearchNoTextLayer => 'Este PDF não possui texto pesquisável';

  @override
  String get readerSearchPrevMatch => 'Ocorrência anterior';

  @override
  String get readerSearchNextMatch => 'Próxima ocorrência';

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
  String get readerMenuGoToPage => 'Ir para a página';

  @override
  String get readerMenuAddBookmark => 'Adicionar aos favoritos';

  @override
  String get readerMenuRemoveBookmark => 'Remover dos favoritos';

  @override
  String get readerMenuDetails => 'Detalhes';

  @override
  String get readerMenuOpenInAnotherApp => 'Abrir em outro app';

  @override
  String get readerTooltipConvertToWord => 'Converter para Word';

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
  String get pagesActionSelectAll => 'Selecionar tudo';

  @override
  String get pagesActionClearSelection => 'Limpar';

  @override
  String get pagesActionSave => 'Salvar';

  @override
  String get pagesActionInsert => 'Inserir';

  @override
  String get pagesActionRotate => 'Girar';

  @override
  String get pagesActionExtract => 'Extrair';

  @override
  String get pagesActionDelete => 'Excluir';

  @override
  String get pagesActionUndo => 'Desfazer';

  @override
  String get pagesInsertSheetTitle => 'Inserir páginas';

  @override
  String get pagesInsertPagesFromPdf => 'Páginas de outro PDF';

  @override
  String get pagesDeleteAllBlocked =>
      'Não é possível excluir todas as páginas. O documento precisa ter pelo menos uma página.';

  @override
  String get pagesSaveDialogTitle => 'Salvar alterações';

  @override
  String get pagesSaveAsNew => 'Salvar como novo arquivo';

  @override
  String get pagesSaveReplace => 'Substituir original';

  @override
  String get pagesSaveReplaceWarning => 'Isso sobrescreve o arquivo original.';

  @override
  String get pagesSaveFileNameLabel => 'Nome do arquivo';

  @override
  String get pagesDiscardDialogTitle => 'Descartar alterações?';

  @override
  String get pagesDiscardDialogBody =>
      'Você tem alterações não salvas. Tem certeza de que deseja descartá-las?';

  @override
  String get pagesDiscardButton => 'Descartar';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas extraídas',
      one: '1 página extraída',
    );
    return '$_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      'Este PDF não pode ser editado porque está criptografado ou ilegível.';

  @override
  String get viewerErrorCorruptTitle => 'Não é possível abrir este documento';

  @override
  String get viewerErrorCorruptMessage =>
      'Este arquivo parece estar danificado ou não é um documento válido.';

  @override
  String get viewerErrorMissingTitle => 'Este arquivo não existe mais';

  @override
  String get viewerErrorMissingMessage =>
      'O arquivo foi excluído ou movido do armazenamento do dispositivo.';

  @override
  String get viewerErrorBackToFiles => 'Voltar aos arquivos';

  @override
  String get viewerErrorNoAppFound =>
      'Nenhum app encontrado para abrir este arquivo';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ocorrências',
      one: '1 ocorrência',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unidades • $ext',
      one: '1 unidade • $ext',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner => 'Formato legado: apenas texto';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      'Planilha grande: exibindo as primeiras 20.000 linhas e 100 colunas';

  @override
  String viewerSectionTitle(int number) {
    return 'Seção $number';
  }

  @override
  String get viewerMenuOutline => 'Sumário';

  @override
  String get viewerOutlineTitle => 'Estrutura do documento';

  @override
  String get viewerCloseOutline => 'Fechar sumário';

  @override
  String get viewerNoSections => 'Nenhuma seção encontrada neste documento';

  @override
  String get viewerOutlineTooltip => 'Índice';

  @override
  String get viewerActionOpenExternal => 'Abrir em outro app';

  @override
  String get viewerErrorCantOpenTitle => 'Não é possível abrir este documento';

  @override
  String get viewerErrorCantOpenMessage =>
      'Não foi possível renderizar o documento offline.';

  @override
  String get viewerOpeningDocument => 'Abrindo documento...';

  @override
  String get viewerErrorEncryptedTitle => 'Este documento está criptografado';

  @override
  String get viewerErrorEncryptedMessage =>
      'Arquivos protegidos por senha não podem ser visualizados no leitor offline.';

  @override
  String get viewerErrorTooLargeTitle =>
      'Este arquivo excede o limite de visualização';

  @override
  String get viewerErrorTooLargeMessage =>
      'Documentos grandes devem ser abertos usando um visualizador Office externo.';

  @override
  String get viewerErrorUnsupportedFormatTitle =>
      'Este formato não é compatível';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      'O Doc View não consegue processar este formato de arquivo diretamente.';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => 'Tipografia';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get txtViewerMonospaceLabel => 'Fonte monoespaçada';

  @override
  String get txtViewerTruncationBanner =>
      'O arquivo é maior que 1 MB: exibindo o primeiro 1 MB';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linhas • $size',
      one: '1 linha • $size',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => 'Configurações de tipografia';

  @override
  String get txtViewerTooltipDecreaseFont => 'Diminuir tamanho da fonte';

  @override
  String get txtViewerTooltipIncreaseFont => 'Aumentar tamanho da fonte';

  @override
  String get txtViewerTooltipToggleMonospace => 'Alternar fonte monoespaçada';

  @override
  String get txtViewerMonospaceSubtitle =>
      'Caracteres de largura fixa para código e logs';

  @override
  String get txtViewerPreviewLabel => 'Pré-visualização';

  @override
  String get txtViewerPreviewText =>
      'Um pequeno jabuti xereta viu dez cegonhas felizes.';

  @override
  String get txtViewerErrorTitle => 'Não é possível ler este arquivo de texto';

  @override
  String get txtViewerErrorMessage =>
      'O formato ou a codificação do arquivo não pôde ser processado.';

  @override
  String get txtViewerActionRetry => 'Tentar novamente';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '$width × $height • $size';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get imageViewerTooltipFitToScreen => 'Ajustar à tela';

  @override
  String get imageViewerErrorCorrupt => 'Não foi possível carregar a imagem';

  @override
  String get imageViewerLoading => 'Carregando imagem…';

  @override
  String get viewerDispatcherFileMissing => 'O arquivo não existe mais';

  @override
  String get viewerSpreadsheetFormulaBarEmpty => '-';

  @override
  String get viewerSpreadsheetAllCells => 'Todas';

  @override
  String viewerSpreadsheetColumnLabel(String col) {
    return 'Coluna $col';
  }

  @override
  String viewerSpreadsheetRowLabel(int row) {
    return 'Linha $row';
  }

  @override
  String viewerSpreadsheetCellSemantics(String col, int row, String value) {
    return 'Coluna $col, linha $row, $value';
  }

  @override
  String get viewerSpreadsheetEmptyCell => 'vazio';

  @override
  String get viewerSpreadsheetEmptySheet => 'Esta planilha está vazia';

  @override
  String get viewerSpreadsheetCopiedSingle => 'Célula copiada';

  @override
  String viewerSpreadsheetCopiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count células copiadas',
      one: '1 célula copiada',
    );
    return '$_temp0';
  }

  @override
  String get viewerSpreadsheetCopyLimitReached =>
      'Seleção limitada a 5.000 células';

  @override
  String get viewerSpreadsheetCellContentTitle => 'Conteúdo da célula';

  @override
  String get viewerSpreadsheetCopyAction => 'Copiar';

  @override
  String get viewerSpreadsheetCloseAction => 'Fechar';

  @override
  String viewerSpreadsheetZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get viewerSpreadsheetResetZoomTooltip => 'Redefinir zoom para 100%';

  @override
  String get viewerSpreadsheetNoMatches => 'Nenhuma ocorrência nesta planilha';

  @override
  String get viewerSpreadsheetSearchPlaceholder => 'Localizar na planilha…';

  @override
  String get viewerSpreadsheetPasswordTitle => 'Arquivo protegido por senha';

  @override
  String get viewerSpreadsheetPasswordMessage =>
      'Arquivos protegidos por senha não podem ser abertos aqui.';

  @override
  String get viewerSpreadsheetErrorTitle => 'Não é possível ler esta planilha';

  @override
  String get viewerSpreadsheetCorruptMessage =>
      'O arquivo da planilha está corrompido ou não pôde ser decodificado.';

  @override
  String get viewerSpreadsheetTimeoutMessage =>
      'A abertura da planilha atingiu o tempo limite após 20 segundos.';

  @override
  String get viewerSpreadsheetTooLargeMessage =>
      'Este arquivo excede o limite de visualização de 25 MB.';

  @override
  String get viewerSpreadsheetOpenBasicViewer => 'Abrir no leitor básico';

  @override
  String get viewerSpreadsheetOpenAnotherApp => 'Abrir em outro app';

  @override
  String get toolsWorkspaceOverline => 'ESPAÇO DE TRABALHO';

  @override
  String get toolsTitle => 'Ferramentas';

  @override
  String get toolsSectionConvertCreate => 'CONVERTER E CRIAR';

  @override
  String get toolsSectionEditManage => 'EDITAR E GERENCIAR';

  @override
  String get toolsSectionOthers => 'OUTROS';

  @override
  String get toolsCreatedByYou => 'Criados por você';

  @override
  String get toolsCreatedByYouEmpty => 'Os PDFs que você criar aparecerão aqui';

  @override
  String get toolsCreatedByYouSeeAll => 'Ver tudo';

  @override
  String get toolManagePages => 'Gerenciar páginas';

  @override
  String get toolManagePagesSub => 'Reordenar, girar e excluir';

  @override
  String get toolImportFiles => 'Importar arquivos';

  @override
  String get toolImportFilesSub => 'Adicionar de outros apps';

  @override
  String get toolPrintPdf => 'Imprimir PDF';

  @override
  String get toolPrintPdfSub => 'Enviar para qualquer impressora';

  @override
  String get toolCreatePdf => 'Criar PDF';

  @override
  String get toolCreatePdfSub => 'Documento em branco ou modelo';

  @override
  String get toolRecycleBin => 'Lixeira';

  @override
  String get toolRecycleBinSub => 'Restaurar arquivos excluídos';

  @override
  String get toolAnnotate => 'Anotar';

  @override
  String get toolAnnotateSub => 'Destacar, desenhar e marcar';

  @override
  String get toolAddText => 'Adicionar texto';

  @override
  String get toolAddTextSub => 'Inserir texto e datas';

  @override
  String get toolSign => 'Assinar';

  @override
  String get toolSignSub => 'Preencher e assinar formulários';

  @override
  String get toolWordToPdf => 'Word para PDF';

  @override
  String get toolWordToPdfSub => 'Converter DOCX para PDF';

  @override
  String get toolPptToPdf => 'PPT para PDF';

  @override
  String get toolPptToPdfSub => 'Converter PPTX para PDF';

  @override
  String get printPdfErrorTooLarge =>
      'O arquivo PDF excede o limite de impressão de 50 MB.';

  @override
  String get printPdfErrorUnreadable =>
      'Não foi possível ler o PDF para impressão.';

  @override
  String get printPdfErrorPassword =>
      'Não é possível imprimir um PDF protegido por senha diretamente.';

  @override
  String get printPdfErrorFailed => 'Falha na impressão.';

  @override
  String get printPdfSuccess => 'Documento enviado para a impressora.';

  @override
  String get toolPickerTitleSelectPdf => 'Selecionar PDF';

  @override
  String get toolPickerTitleSelectPdfs => 'Selecionar PDFs';

  @override
  String get toolPickerBrowseFiles => 'Procurar arquivos';

  @override
  String get toolPickerTabAll => 'Todos os PDFs';

  @override
  String get toolPickerTabRecent => 'Recentes';

  @override
  String get toolPickerTabDownloads => 'Downloads';

  @override
  String get toolPickerTabICloud => 'iCloud Drive';

  @override
  String get toolPickerActionPrint => 'Imprimir';

  @override
  String get toolPickerActionManage => 'Gerenciar';

  @override
  String get toolPickerActionSelect => 'Selecionar';

  @override
  String get toolsImportActionView => 'Visualizar';

  @override
  String get createPdfTemplateBlank => 'Em branco';

  @override
  String get createPdfTemplateLine1 => 'Pautado 1';

  @override
  String get createPdfTemplateLine2 => 'Pautado 2';

  @override
  String get createPdfTemplateNotebook => 'Caderno';

  @override
  String get createPdfTemplateCornell => 'Cornell';

  @override
  String get createPdfTemplateGrid => 'Quadriculado';

  @override
  String get createPdfTemplateGraph => 'Milimetrado';

  @override
  String get createPdfSwatchWhite => 'Branco';

  @override
  String get createPdfSwatchCream => 'Creme';

  @override
  String get createPdfSwatchLightYellow => 'Amarelo-claro';

  @override
  String get createPdfSwatchLightPeach => 'Pêssego-claro';

  @override
  String get createPdfSwatchLightPink => 'Rosa-claro';

  @override
  String get createPdfSwatchLightLavender => 'Lavanda-claro';

  @override
  String get createPdfSwatchLightBlue => 'Azul-claro';

  @override
  String get createPdfSwatchLightMint => 'Menta-claro';

  @override
  String get createPdfSwatchLightGreen => 'Verde-claro';

  @override
  String get createPdfSwatchLightGray => 'Cinza-claro';

  @override
  String get createPdfOrientationPortrait => 'Retrato';

  @override
  String get createPdfOrientationLandscape => 'Paisagem';

  @override
  String get createPdfSectionTemplate => 'MODELO';

  @override
  String get createPdfSectionPageSize => 'TAMANHO DA PÁGINA';

  @override
  String get createPdfSectionOrientation => 'ORIENTAÇÃO';

  @override
  String get createPdfSectionPageColor => 'COR DA PÁGINA';

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
  String get createPdfCreating => 'Gerando PDF...';

  @override
  String createPdfProgress(int done, int total) {
    return 'Montando página $done de $total...';
  }

  @override
  String get createPdfErrorTitle => 'Não foi possível criar o PDF';

  @override
  String get createPdfErrorPageCount =>
      'O número de páginas deve ser entre 1 e 100.';

  @override
  String get createPdfErrorInvalidName => 'Digite um nome de arquivo válido.';

  @override
  String get createPdfErrorGeneration =>
      'Falha ao gerar o documento PDF. Tente novamente.';

  @override
  String get trashErrorTooLarge =>
      'O arquivo é grande demais para a Lixeira (limite de 200 MB)';

  @override
  String get trashErrorNotEnoughSpace =>
      'Espaço de armazenamento insuficiente na Lixeira';

  @override
  String trashErrorGeneric(String details) {
    return 'Falha na operação da Lixeira: $details';
  }

  @override
  String get trashDialogMoveTitle => 'Mover para a Lixeira?';

  @override
  String trashDialogMoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Mover $count arquivos para a Lixeira? Você pode restaurá-los em Ferramentas > Lixeira por 30 dias.',
      one:
          'Mover 1 arquivo para a Lixeira? Você pode restaurá-lo em Ferramentas > Lixeira por 30 dias.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionMove => 'Mover para a Lixeira';

  @override
  String trashMovedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos movidos para a Lixeira',
      one: '1 arquivo movido para a Lixeira',
    );
    return '$_temp0';
  }

  @override
  String get trashActionUndo => 'Desfazer';

  @override
  String trashRestoredSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos restaurados',
      one: '1 arquivo restaurado',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogDeleteForeverTitle => 'Excluir permanentemente?';

  @override
  String trashDialogDeleteForeverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Excluir $count arquivos permanentemente? Essa ação não pode ser desfeita.',
      one:
          'Excluir 1 arquivo permanentemente? Essa ação não pode ser desfeita.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionDeleteForever => 'Excluir para sempre';

  @override
  String trashDeletedForeverSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos excluídos para sempre',
      one: '1 arquivo excluído para sempre',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogEmptyTitle => 'Esvaziar Lixeira?';

  @override
  String trashDialogEmptyBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'todos os $count arquivos',
      one: '1 arquivo',
    );
    return 'Excluir permanentemente $_temp0? Essa ação não pode ser desfeita.';
  }

  @override
  String get trashActionEmptyBin => 'Esvaziar lixeira';

  @override
  String get trashEmptyTitle => 'A Lixeira está vazia';

  @override
  String get trashEmptySubtitle =>
      'Os arquivos movidos para a Lixeira ficam aqui por 30 dias antes de serem excluídos permanentemente.';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count dias',
      one: 'Falta 1 dia',
    );
    return '$_temp0';
  }

  @override
  String trashSubtitle(String date, String size) {
    return 'Excluído em $date · $size';
  }

  @override
  String get trashDialogTooLargeTitle => 'Grande demais para a Lixeira';

  @override
  String trashDialogTooLargeBody(String fileName) {
    return '\"$fileName\" tem mais de 200 MB e não pode ser movido para a Lixeira. Deseja excluí-lo permanentemente?';
  }

  @override
  String get trashActionDeletePermanently => 'Excluir permanentemente';

  @override
  String get trashInfoBanner =>
      'Os itens na Lixeira são excluídos permanentemente após 30 dias.';

  @override
  String get trashSheetRestore => 'Restaurar';

  @override
  String get trashSheetDeleteForever => 'Excluir para sempre';

  @override
  String get trashSheetDetails => 'Detalhes';

  @override
  String get trashDetailsOriginalLocation => 'Local original';

  @override
  String get trashDetailsDateDeleted => 'Data de exclusão';

  @override
  String get trashDetailsExpiresIn => 'Expira em';

  @override
  String trashRestoredToFallbackSuccess(String location) {
    return 'Restaurado em $location (pasta original não encontrada)';
  }

  @override
  String get trashDialogCopyFailedTitle =>
      'Não foi possível mover para a Lixeira';

  @override
  String trashDialogCopyFailedBody(String fileName) {
    return 'Não foi possível mover \"$fileName\" para a Lixeira. Deseja excluí-lo permanentemente? Essa ação não pode ser desfeita.';
  }

  @override
  String get trashDialogEmptyProgress => 'Esvaziando Lixeira...';

  @override
  String get trashDialogMoveProgress => 'Movendo arquivos para a Lixeira...';

  @override
  String get trashDialogNotEnoughSpaceTitle =>
      'Espaço de armazenamento insuficiente';

  @override
  String get trashDialogNotEnoughSpaceBody =>
      'Não há espaço suficiente para mover para a Lixeira. Libere espaço esvaziando a lixeira.';

  @override
  String get trashActionFreeUpSpace => 'Liberar espaço';

  @override
  String get trashDialogDeleteForeverProgress =>
      'Excluindo arquivos permanentemente...';

  @override
  String get galleryDebugAgeTrash =>
      'Envelhecer todos os itens da lixeira em 29 dias';

  @override
  String get galleryDebugSlowCopy => 'Cópia lenta para lixeira (teste)';

  @override
  String get galleryDebugSlowCopySubtitle =>
      'Limita o loop de cópia a ~20 MB/s para testes de interrupção';

  @override
  String get galleryDebugSlowSave => 'Salvamento lento no editor (teste)';

  @override
  String get galleryDebugSlowSaveSubtitle =>
      'Limita o loop de salvamento a ~8 s para testes de interrupção';

  @override
  String get galleryDebugSaveAnnotate => 'Salvar amostra 100p (teste Anotar)';

  @override
  String get galleryDebugSaveSign => 'Salvar amostra 100p (teste Assinar)';

  @override
  String get galleryDebugSaveText =>
      'Salvar amostra 100p (teste Adicionar texto)';

  @override
  String get galleryDebugMove190Mb =>
      'Mover arquivo de teste de 190 MB para a lixeira';

  @override
  String get galleryDebugRestoreLastTrash => 'Restaurar último item da lixeira';

  @override
  String get galleryDebugEmptyTrash => 'Esvaziar Lixeira';

  @override
  String galleryDebugAgeTrashSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens envelhecidos',
      one: '1 item envelhecido',
    );
    return '$_temp0 em 29 dias';
  }

  @override
  String get annotateErrorPasswordProtected =>
      'Este PDF está protegido por senha.';

  @override
  String get annotateErrorCorrupt =>
      'Este PDF está corrompido ou não pode ser lido.';

  @override
  String get annotateSignedReplaceBlocked =>
      'Não é permitido substituir o PDF assinado original. Salve como um novo arquivo.';

  @override
  String annotateErrorSaveFailed(String details) {
    return 'Falha ao salvar anotações: $details';
  }

  @override
  String get annotateErrorScannedPdf =>
      'Este documento parece ser digitalizado ou não contém texto selecionável.';

  @override
  String get annotateSignedBanner =>
      'PDF assinado digitalmente: ao salvar, será criada uma nova cópia para preservar a assinatura.';

  @override
  String get annotateActionSaveNew => 'Salvar como novo arquivo';

  @override
  String get annotateActionReplace => 'Substituir original';

  @override
  String get annotateDiscardDialogTitle => 'Descartar anotações não salvas?';

  @override
  String get annotateDiscardDialogBody =>
      'Você tem marcações não salvas. Se sair agora, suas alterações serão perdidas.';

  @override
  String get annotateDiscardDialogActionDiscard => 'Descartar';

  @override
  String get annotateDiscardDialogActionKeep => 'Continuar editando';

  @override
  String get annotateSaveSuccess => 'Anotações salvas com sucesso';

  @override
  String get annotateToolbarHighlight => 'Destacar';

  @override
  String get annotateToolbarUnderline => 'Sublinhar';

  @override
  String get annotateToolbarStrikethrough => 'Tachado';

  @override
  String get annotateToolbarCopy => 'Copiar';

  @override
  String get annotateColorYellow => 'Amarelo';

  @override
  String get annotateColorGreen => 'Verde';

  @override
  String get annotateColorCyan => 'Ciano';

  @override
  String get annotateColorPink => 'Rosa';

  @override
  String get annotateColorOrange => 'Laranja';

  @override
  String get annotateSaveTitle => 'Salvar anotações';

  @override
  String get annotateSaveProgress => 'Salvando anotações...';

  @override
  String get annotateNoChanges => 'Nenhuma anotação para salvar';

  @override
  String get annotateTooltipUndo => 'Desfazer';

  @override
  String get annotateTooltipRedo => 'Refazer';

  @override
  String get annotateTooltipSave => 'Salvar';

  @override
  String get annotateCopiedToClipboard =>
      'Copiado para a área de transferência';

  @override
  String get annotateToolbarPen => 'Caneta';

  @override
  String get annotatePenTipBanner =>
      'Desenhe com um dedo. Mova e dê zoom com dois dedos.';

  @override
  String get annotatePenSheetTitle => 'Configurações da caneta';

  @override
  String get annotatePenStrokeWidth => 'Espessura do traço';

  @override
  String get annotatePenEraserMode => 'Borracha';

  @override
  String get annotateColorBlack => 'Preto';

  @override
  String get annotateColorRed => 'Vermelho';

  @override
  String get annotateColorPurple => 'Roxo';

  @override
  String get annotateColorBlue => 'Azul';

  @override
  String get toolSignPdf => 'Assinar PDF';

  @override
  String get toolSignPdfSubtitle => 'Adicionar assinatura e data a documentos';

  @override
  String get signToolbarSign => 'Assinar';

  @override
  String get signToolbarDate => 'Data';

  @override
  String get signToolbarClearAll => 'Limpar tudo';

  @override
  String get signPadTitle => 'Desenhe sua assinatura';

  @override
  String get signPadClear => 'Limpar';

  @override
  String get signPadSave => 'Salvar assinatura';

  @override
  String get signSheetTitle => 'Assinaturas salvas';

  @override
  String get signSheetCreateNew => 'Criar nova assinatura';

  @override
  String get signMaxSignaturesReached =>
      'Máximo de 5 assinaturas salvas atingido';

  @override
  String get signMaxPlacedReached =>
      'Máximo de 20 assinaturas por documento atingido';

  @override
  String get signDeleteSignatureTitle => 'Excluir assinatura?';

  @override
  String get signDeleteSignatureBody =>
      'Esta assinatura será removida das suas assinaturas salvas.';

  @override
  String get signConfirmClearAllTitle => 'Limpar todas as assinaturas?';

  @override
  String get signConfirmClearAllBody =>
      'Todas as assinaturas e datas inseridas neste documento serão removidas.';

  @override
  String get signSaveSuccess => 'Documento assinado com sucesso';

  @override
  String get signNoSignaturesToSave =>
      'Nenhuma assinatura inserida no documento';

  @override
  String get signPlacedSignatureDelete => 'Excluir';

  @override
  String get signPlacedSignatureApply => 'Aplicar';

  @override
  String get signTooltipUndo => 'Desfazer';

  @override
  String get signTooltipRedo => 'Refazer';

  @override
  String get signTooltipSave => 'Salvar';

  @override
  String annotatePenStrokeWidthValue(String width) {
    return '$width pt';
  }

  @override
  String get annotateErrorTooManyStrokes =>
      'O documento atingiu o máximo de 5.000 traços ou 300.000 pontos.';

  @override
  String annotateChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alterações',
      one: '1 alteração',
    );
    return '$_temp0';
  }

  @override
  String get annotatePenNotice =>
      'Os traços de caneta passam a fazer parte da página ao salvar e não podem ser editados depois.';

  @override
  String get annotatePenNoticeDismiss => 'Entendi';

  @override
  String get signPadBaselineHint => 'Assine aqui';

  @override
  String get signPadUndo => 'Desfazer';

  @override
  String get signPadUseOnce => 'Usar uma vez';

  @override
  String get signPadSaveAndUse => 'Salvar e usar';

  @override
  String get tool_add_text => 'Adicionar texto';

  @override
  String get tool_add_text_desc =>
      'Inserir caixas de texto e notas nas páginas';

  @override
  String get addTextNoticePermanent =>
      'O texto adicionado passa a fazer parte da página e não pode ser editado após salvar.';

  @override
  String get addTextNoticeRaster =>
      'O texto neste idioma é adicionado como imagem e não pode ser selecionado.';

  @override
  String get addTextNoticeGotIt => 'Entendi';

  @override
  String get addTextActionAdd => 'Adicionar texto';

  @override
  String get addTextActionStyle => 'Estilo';

  @override
  String get addTextActionDelete => 'Excluir';

  @override
  String get addTextStyleSheetTitle => 'Estilo do texto';

  @override
  String get addTextFontSize => 'Tamanho da fonte';

  @override
  String get addTextColor => 'Cor';

  @override
  String get addTextStyle => 'Estilo';

  @override
  String get addTextAlign => 'Alinhamento';

  @override
  String get addTextBold => 'Negrito';

  @override
  String get addTextItalic => 'Itálico';

  @override
  String get addTextAlignStart => 'Início';

  @override
  String get addTextAlignCenter => 'Centro';

  @override
  String get addTextAlignEnd => 'Fim';

  @override
  String get addTextErrorTooManyBoxes =>
      'Máximo de 30 caixas de texto atingido';

  @override
  String get addTextErrorBoxTooLong =>
      'A caixa de texto não pode exceder 2.000 caracteres';

  @override
  String get addTextPlaceholder => 'Digite o texto aqui';

  @override
  String get addTextSamplePreview => 'Prévia de exemplo';

  @override
  String addTextFontSizePt(int size) {
    return '$size pt';
  }

  @override
  String get premiumTitle => 'Doc View Premium';

  @override
  String get premiumSubtitle =>
      'Desbloqueie as ferramentas Anotar e Assinar e aproveite uma experiência totalmente sem anúncios.';

  @override
  String get premiumFeatureAllTools => 'Ferramentas Anotar e Assinar PDF';

  @override
  String get premiumFeatureAllToolsSub =>
      'Faça marcações, destaque documentos e assine PDFs sem esforço';

  @override
  String get premiumFeatureAdFree => 'Experiência 100% sem anúncios';

  @override
  String get premiumFeatureAdFreeSub =>
      'Sem banners, interrupções ou distrações em lugar nenhum';

  @override
  String get premiumFeatureUnlimitedConversions =>
      'Conversões locais ilimitadas';

  @override
  String get premiumFeatureUnlimitedConversionsSub =>
      'Converta documentos no dispositivo sem limite de arquivos';

  @override
  String get premiumFeaturePrivacyFirst => '100% privado e no dispositivo';

  @override
  String get premiumFeaturePrivacyFirstSub =>
      'Os arquivos são processados localmente e nunca enviados a nenhum servidor';

  @override
  String get premiumPlanYearly => 'Assinatura anual';

  @override
  String premiumPlanYearlyTrial(int days, String price) {
    return '$days dias grátis, depois $price/ano';
  }

  @override
  String get premiumPlanMonthly => 'Assinatura mensal';

  @override
  String premiumPlanMonthlySub(String price) {
    return '$price/mês';
  }

  @override
  String premiumPlanYearlySub(String price) {
    return '$price/ano';
  }

  @override
  String premiumPlanMonthlyTrial(int days, String price) {
    return '$days dias grátis, depois $price/mês';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Economize $percent%';
  }

  @override
  String get premiumSaveUnknown => 'Economize -%';

  @override
  String premiumActionStartTrial(int days) {
    return 'Iniciar teste grátis de $days dias';
  }

  @override
  String get premiumSubscriptionsAvailableSoon =>
      'As assinaturas estarão disponíveis em breve.';

  @override
  String get pagesEditPagesAction => 'Editar páginas';

  @override
  String get premiumCancelAnytime => 'Cancele quando quiser';

  @override
  String get premiumPendingStatus =>
      'Sua compra está sendo processada pelo Google Play. Os benefícios serão ativados após a confirmação.';

  @override
  String get premiumRenewalDisclosurePricingUnavailable =>
      'Renovação automática. O preço será confirmado pelo Google Play na finalização da compra. Cancele quando quiser nas Assinaturas do Google Play.';

  @override
  String get premiumActionSubscribe => 'Assinar';

  @override
  String get premiumActionRestore => 'Restaurar compras';

  @override
  String get premiumBillingDisclaimer =>
      'Renovação automática. Cancele quando quiser nas Assinaturas do Google Play.';

  @override
  String get premiumTerms => 'Termos de Serviço';

  @override
  String get premiumPrivacy => 'Política de Privacidade';

  @override
  String get premiumActiveStatus => 'Você é assinante Premium';

  @override
  String get premiumGraceStatus => 'Período de carência offline ativo';

  @override
  String get premiumExpiredStatus => 'Assinatura expirada';

  @override
  String get premiumRestoreSuccess => 'Compras restauradas com sucesso.';

  @override
  String get premiumRestoreNone => 'Nenhuma assinatura ativa encontrada.';

  @override
  String get premiumErrorGeneral =>
      'Não foi possível concluir a compra. Tente novamente.';

  @override
  String get premiumPagesGateTitle => 'Doc View Premium';

  @override
  String get premiumPagesGateBody =>
      'Reordenar, girar e excluir páginas requer uma assinatura Premium.';

  @override
  String get premiumPagesGateUpgrade => 'Assinar o Premium';

  @override
  String get premiumTooltip => 'Doc View Premium';

  @override
  String get premiumManageInPlay => 'Gerenciar';

  @override
  String get faqQuestion8 => 'O que está incluído no Doc View Premium?';

  @override
  String get faqAnswer8 =>
      'O Doc View Premium desbloqueia todas as ferramentas avançadas de edição de documentos, incluindo reordenação, rotação e exclusão de páginas PDF, conversão de PDF para Word, anotações, assinaturas e inserção de texto personalizado, além de eliminar completamente todos os anúncios no app. Todo o processamento de documentos continua 100% no dispositivo.';

  @override
  String get faqQuestion9 =>
      'Posso usar o Doc View Premium sem conexão com a internet?';

  @override
  String get faqAnswer9 =>
      'Sim. Após a ativação, o Doc View armazena com segurança o status da sua assinatura no dispositivo com um período de carência offline de até 7 dias consecutivos. Você pode continuar usando todas as ferramentas de edição offline durante esse período.';

  @override
  String get galleryDebugIapSectionTitle =>
      '15. Simulador de IAP e Premium (G7)';

  @override
  String get galleryDebugIapStateFree => 'Definir Gratuito';

  @override
  String get galleryDebugIapStateYearly => 'Definir Premium Anual';

  @override
  String get galleryDebugIapStateMonthly => 'Definir Premium Mensal';

  @override
  String get galleryDebugIapStateGrace => 'Definir Carência Offline (Ativa)';

  @override
  String get galleryDebugIapStateGraceExpired =>
      'Definir Carência Offline (Expirada)';

  @override
  String get galleryDebugOpenPremium => 'Abrir tela /premium';

  @override
  String get galleryDebugIapProductSeenTrue => 'Definir Produto Visto: Sim';

  @override
  String get galleryDebugIapProductSeenFalse => 'Definir Produto Visto: Não';

  @override
  String get addWidgetSheetTitle => 'Adicionar à tela inicial';

  @override
  String get addWidgetSheetSubtitle =>
      'Escolha um widget para adicionar à sua tela inicial';

  @override
  String get widgetRecentFilesTitle => 'Arquivos recentes';

  @override
  String get widgetRecentFilesBadge => '4 × 2';

  @override
  String get widgetRecentFilesDesc =>
      'Veja e abra os arquivos usados recentemente direto da tela inicial';

  @override
  String get widgetQuickToolsTitle => 'Ferramentas rápidas';

  @override
  String get widgetQuickToolsBadge => '4 × 1';

  @override
  String get widgetQuickToolsDesc =>
      'Acesse direto Digitalizar, Imagem para PDF, Pesquisar ou Importar';

  @override
  String get addWidgetButton => 'Adicionar widget';

  @override
  String get addWidgetManualTitle => 'Adicionar widget manualmente';

  @override
  String get addWidgetManualMessage =>
      'Toque e segure um espaço vazio na tela inicial, toque em Widgets, encontre o Doc View e arraste-o para a tela.';

  @override
  String get settingsQuickAccessNotificationTitle =>
      'Notificação de acesso rápido';

  @override
  String get settingsQuickAccessNotificationSubtitle =>
      'Mostrar ferramentas rápidas na barra de notificações';

  @override
  String get notificationPermissionDialogTitle => 'Permitir notificações';

  @override
  String get notificationPermissionDialogDesc =>
      'O Doc View precisa da permissão de notificações para exibir a barra de acesso rápido na sua central de notificações.';

  @override
  String get notificationTitle => 'Ferramentas rápidas do Doc View';

  @override
  String get notificationBody => 'Digitalize, converta ou pesquise documentos';

  @override
  String get notificationActionScan => 'Digitalizar';

  @override
  String get notificationActionImageToPdf => 'Imagem para PDF';

  @override
  String get notificationActionSearch => 'Pesquisar';

  @override
  String get settingsAdChoicesTitle => 'Preferências de anúncios';

  @override
  String get settingsAdChoicesSubtitle =>
      'Gerenciar escolhas de privacidade e publicidade';

  @override
  String get faqQuestion10 => 'Por que o Doc View exibe anúncios?';

  @override
  String get faqAnswer10 =>
      'Os anúncios mantêm o Doc View gratuito. O Premium os remove. Os anúncios são fornecidos pelo Google AdMob e nunca têm acesso aos seus documentos.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Doc View';

  @override
  String get navHome => 'Todos os arquivos';

  @override
  String get navTools => 'Ferramentas';

  @override
  String get navSettings => 'Configurações';

  @override
  String get noDocumentSelected => 'Nenhum documento selecionado';

  @override
  String get tooltipCloseAd => 'Fechar anúncio';

  @override
  String get tooltipClose => 'Fechar';

  @override
  String get tooltipRescan => 'Verificar documentos novamente';

  @override
  String get tooltipSearch => 'Pesquisar documentos';

  @override
  String get tooltipSelectFiles => 'Selecionar arquivos';

  @override
  String get tooltipBack => 'Voltar';

  @override
  String get tooltipCancelSelection => 'Cancelar seleção';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selecionados',
      one: '1 selecionado',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'Selecionar tudo';

  @override
  String get actionDeselectAll => 'Desmarcar tudo';

  @override
  String get tooltipDeleteSelected => 'Excluir selecionados';

  @override
  String get tooltipClearSearch => 'Limpar pesquisa';

  @override
  String get searchHint => 'Pesquisar documentos, pastas...';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return 'Página $page de $total';
  }

  @override
  String get errorGenericTitle => 'Algo deu errado';

  @override
  String get actionRetry => 'Tentar novamente';

  @override
  String get permissionAllFilesTitle => 'Acesso a todos os arquivos necessário';

  @override
  String get permissionAllFilesExplanation =>
      'O Doc View precisa de acesso a todos os arquivos para navegar pelas pastas e organizar seus documentos totalmente offline.';

  @override
  String get actionGrantAccess => 'Conceder acesso';

  @override
  String get actionImportFilesInstead => 'Importar arquivos';

  @override
  String get tooltipRemoveBookmark => 'Remover dos favoritos';

  @override
  String get tooltipAddBookmark => 'Adicionar aos favoritos';

  @override
  String tooltipFileOptions(String title) {
    return 'Opções do arquivo $title';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return 'Pasta, $name$subtitle';
  }

  @override
  String get adAdvertisementBadge => 'PUBLICIDADE';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get tabRecent => 'Recentes';

  @override
  String get tabBookmarks => 'Favoritos';

  @override
  String get filterCategoryAll => 'Todos';

  @override
  String get actionBrowse => 'Procurar';

  @override
  String get actionCancelOperation => 'Cancelar operação';

  @override
  String get operationComplete => 'Operação concluída';

  @override
  String get actionOpenDocument => 'Abrir documento';

  @override
  String get actionShareDocument => 'Compartilhar documento';

  @override
  String get splashTagline => 'Todos os seus documentos em um só lugar.';

  @override
  String appVersion(String version) {
    return 'Versão $version';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'Etapa $current de $total';
  }

  @override
  String get actionSkip => 'Pular';

  @override
  String get actionBack => 'Voltar';

  @override
  String get actionNext => 'Avançar';

  @override
  String get actionGetStarted => 'Começar';

  @override
  String get onboardingPage1Title => 'Todos os seus documentos\nem um só lugar';

  @override
  String get onboardingPage1Desc =>
      'O Doc View encontra automaticamente arquivos PDF, Word, Excel, PowerPoint, texto e imagens no seu celular e os organiza para você.';

  @override
  String get onboardingPage2Title => 'Leia qualquer arquivo\ncom conforto';

  @override
  String get onboardingPage2Desc =>
      'Abra arquivos PDF, Word, Excel e PowerPoint em um leitor rápido e limpo. Pesquise, favorite e continue de onde parou.';

  @override
  String get onboardingPage3Title => 'Ferramentas de PDF poderosas e offline';

  @override
  String get onboardingPage3Desc =>
      'Transforme fotos em PDF, digitalize documentos, mescle e divida arquivos. Tudo permanece no seu dispositivo.';

  @override
  String get onboardingOfflineGuarantee =>
      'Seus arquivos ficam no seu dispositivo';

  @override
  String get toolImageToPdf => 'Imagem para PDF';

  @override
  String get toolImageToPdfSub => 'Converter JPG e PNG';

  @override
  String get toolScanToPdf => 'Digitalizar para PDF';

  @override
  String get toolScanToPdfSub => 'Detecção de bordas pela câmera';

  @override
  String get toolMergePdf => 'Mesclar PDF';

  @override
  String get toolMergePdfSub => 'Combinar em um único arquivo';

  @override
  String get toolSplitPdf => 'Dividir PDF';

  @override
  String get toolSplitPdfSub => 'Extrair qualquer intervalo';

  @override
  String get permissionTagStorage => 'Acesso ao armazenamento do dispositivo';

  @override
  String get permissionStorageHeadline =>
      'Deixe o Doc View encontrar seus documentos';

  @override
  String get permissionStorageBody =>
      'Para listar arquivos PDF, Word, Excel e outros formatos salvos por qualquer aplicativo, o Android precisa da sua permissão para acessar todos os arquivos. Seus arquivos nunca saem do celular.';

  @override
  String get permissionReassuranceOfflineTitle =>
      'Os arquivos nunca são enviados';

  @override
  String get permissionReassuranceOfflineDesc =>
      'Seus documentos são processados localmente no seu dispositivo.';

  @override
  String get permissionReassuranceNoUploadsTitle => 'Sem uploads';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      'Zero servidores na nuvem. Seus arquivos permanecem estritamente na memória do celular.';

  @override
  String get permissionReassuranceChangeTitle =>
      'Você pode alterar isso a qualquer momento';

  @override
  String get permissionReassuranceChangeDesc =>
      'Ative ou desative facilmente nas configurações de aplicativos do sistema Android.';

  @override
  String get permissionTagIOS => 'Guia de armazenamento no iOS';

  @override
  String get permissionIOSHeadline => 'Traga seus documentos para o Doc View';

  @override
  String get permissionIOSBody =>
      'Devido à arquitetura de privacidade da Apple, o iOS não permite que nenhum app verifique todo o iPhone automaticamente. Escolha como deseja ler seus arquivos:';

  @override
  String get permissionIOSOptionImportTitle => 'Importar arquivos';

  @override
  String get permissionIOSBadgeFastest => 'MAIS RÁPIDO';

  @override
  String get permissionIOSOptionImportDesc =>
      'Escolha documentos diretamente do iCloud Drive, Downloads ou qualquer pasta em segundos.';

  @override
  String get permissionIOSOptionFolderTitle =>
      'Abrir a pasta do Doc View no app Arquivos';

  @override
  String get permissionIOSOptionFolderDesc =>
      'Salve ou envie documentos via AirDrop diretamente para a pasta \"Doc View\" no app Arquivos do iOS para sincronização instantânea.';

  @override
  String get actionImportFiles => 'Importar arquivos';

  @override
  String get actionContinueToApp => 'Continuar para o app';

  @override
  String get permissionTagConsent => 'Transparência e consentimento';

  @override
  String get permissionBadgeFree => 'App 100% gratuito';

  @override
  String get permissionBadgeMinimalAds => 'Poucos anúncios';

  @override
  String get permissionConsentHeadline => 'Gratuito com anúncios';

  @override
  String get permissionConsentBody =>
      'O Doc View é gratuito graças aos anúncios. A seguir, pediremos sua escolha sobre anúncios personalizados.';

  @override
  String get permissionConsentAdsTitle => 'Quais anúncios você pode ver';

  @override
  String get permissionConsentAdsDesc =>
      'Pequenos banners e cartões patrocinados discretos. Sem pop-ups ou interrupções de vídeo durante a leitura.';

  @override
  String get permissionConsentPrivateTitle =>
      'Seus documentos continuam totalmente privados';

  @override
  String get permissionConsentPrivateDesc =>
      'Parceiros de anúncios nunca têm acesso aos nomes, ao conteúdo de texto ou à localização dos seus documentos.';

  @override
  String get permissionConsentSettingsTitle =>
      'Você pode mudar sua escolha nas Configurações';

  @override
  String get permissionConsentSettingsDesc =>
      'Atualize o consentimento de anúncios personalizados ou preferências de privacidade a qualquer momento nas Configurações do Doc View.';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionPrivacyPolicy => 'Política de privacidade';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos importados',
      one: '1 arquivo importado',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => 'Falha ao importar arquivos';

  @override
  String get tooltipImportDocuments => 'Importar documentos';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos encontrados',
      one: '1 arquivo encontrado',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => 'Verificando...';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos',
      one: '1 arquivo',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => 'Pastas';

  @override
  String get errorLoadingRecent => 'Erro ao carregar arquivos recentes';

  @override
  String get emptyStateTitle => 'Vazio';

  @override
  String get emptyRecentDescription =>
      'Os arquivos abertos recentemente aparecerão aqui';

  @override
  String get errorLoadingBookmarks => 'Erro ao carregar favoritos';

  @override
  String get emptyBookmarksDescription =>
      'Os documentos favoritados aparecerão aqui';

  @override
  String get dialogDeleteTitle => 'Excluir arquivos selecionados?';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Excluir $count arquivos? Essa ação não pode ser desfeita.',
      one: 'Excluir 1 arquivo? Essa ação não pode ser desfeita.',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos excluídos',
      one: '1 arquivo excluído',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => 'Falha ao excluir arquivos';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get searchRecentSearchesHeader => 'PESQUISAS RECENTES';

  @override
  String get actionClear => 'Limpar';

  @override
  String get searchPromptTitle => 'Digite para pesquisar documentos';

  @override
  String get searchPromptMessage =>
      'Pesquise em todas as pastas locais pelo nome ou extensão do arquivo';

  @override
  String get searchError => 'Erro ao pesquisar documentos';

  @override
  String get searchNoResultsTitle =>
      'Nenhum documento correspondente encontrado';

  @override
  String get searchNoResultsMessage =>
      'Tente pesquisar com outra palavra-chave no nome do arquivo ou filtro de formato';

  @override
  String get tooltipSortOptions => 'Opções de ordenação';

  @override
  String get sortSheetTitle => 'Ordenar por';

  @override
  String get sortOptionDate => 'Data de modificação';

  @override
  String get sortOptionName => 'Nome do documento';

  @override
  String get sortOptionSize => 'Tamanho do arquivo';

  @override
  String get sortAscendingOrder => 'Ordem crescente';

  @override
  String get sortAscendingSubtitle => 'Mais antigos / A a Z / Menores primeiro';

  @override
  String get sortDescendingSubtitle =>
      'Mais recentes / Z a A / Maiores primeiro';

  @override
  String get categoryAllFiles => 'Todos os arquivos';

  @override
  String get loadingStatus => 'Carregando...';

  @override
  String get emptyCategoryImagesTitle => 'Nenhuma imagem encontrada';

  @override
  String get emptyCategoryImagesMessage =>
      'As imagens encontradas neste dispositivo aparecerão aqui';

  @override
  String get emptyCategoryDocsTitle => 'Nenhum documento encontrado';

  @override
  String get emptyCategoryDocsMessage =>
      'Documentos deste formato aparecerão aqui após a verificação';

  @override
  String get actionOpen => 'Abrir';

  @override
  String get actionShare => 'Compartilhar';

  @override
  String get actionRename => 'Renomear';

  @override
  String get actionBookmark => 'Favoritar';

  @override
  String get actionRemoveBookmark => 'Remover dos favoritos';

  @override
  String get actionOpenInAnotherApp => 'Abrir em outro app';

  @override
  String get actionDetails => 'Detalhes';

  @override
  String get actionOpenFile => 'Abrir arquivo';

  @override
  String get actionShareAll => 'Compartilhar tudo';

  @override
  String get actionDone => 'Concluído';

  @override
  String get actionSeeAll => 'Ver tudo';

  @override
  String get actionAllow => 'Permitir';

  @override
  String get actionNotNow => 'Agora não';

  @override
  String get tooltipMoreActions => 'Mais ações';

  @override
  String get tooltipCopyPath => 'Copiar caminho';

  @override
  String get tooltipRotatePage => 'Girar página';

  @override
  String get tooltipRemovePage => 'Remover página';

  @override
  String get renameFileTitle => 'Renomear arquivo';

  @override
  String get renameFileNameLabel => 'Nome do arquivo';

  @override
  String renamedSuccess(String fileName) {
    return 'Renomeado para $fileName';
  }

  @override
  String get deleteFileTitle => 'Excluir arquivo?';

  @override
  String deleteFileConfirmation(String fileName) {
    return 'Excluir \"$fileName\"? Isso não pode ser desfeito.';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return '\"$fileName\" excluído';
  }

  @override
  String get fileDetailsTitle => 'Detalhes do documento';

  @override
  String get fileDetailsLabelName => 'Nome';

  @override
  String get fileDetailsLabelType => 'Tipo';

  @override
  String get fileDetailsLabelSize => 'Tamanho';

  @override
  String get fileDetailsLabelModified => 'Modificado';

  @override
  String get fileDetailsLabelBookmarked => 'Favoritado';

  @override
  String get fileDetailsValueYes => 'Sim';

  @override
  String get fileDetailsValueNo => 'Não';

  @override
  String get fileDetailsLabelLocation => 'Localização';

  @override
  String get fileDetailsPathCopied =>
      'Caminho copiado para a área de transferência';

  @override
  String get directoriesTitle => 'Diretórios';

  @override
  String get directoriesGoBack => 'Voltar';

  @override
  String get directoriesGoToRoot => 'Ir para a raiz';

  @override
  String get directoriesRetry => 'Tentar novamente';

  @override
  String get directoriesFileNoLongerExists => 'O arquivo não existe mais';

  @override
  String get directoriesFolderNoLongerExists => 'Esta pasta não existe mais.';

  @override
  String get directoriesNoDocsInFolder => 'Nenhum documento nesta pasta';

  @override
  String get directoriesFilesAppearHere =>
      'Os arquivos aparecerão aqui quando adicionados';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => 'Pasta';

  @override
  String get directoriesPermissionPromptTitle =>
      'Acesso necessário para ver diretórios';

  @override
  String get directoriesPermissionPromptBody =>
      'O Doc View precisa de acesso a todos os arquivos para navegar pelas suas pastas.';

  @override
  String get directoriesGrantAccess => 'Conceder acesso';

  @override
  String get directoriesImportInstead => 'Importar arquivos';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos importados',
      one: '1 arquivo importado',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => 'Subir um nível';

  @override
  String get storageAccessRequiredTitle => 'Acesso ao armazenamento necessário';

  @override
  String get storageAccessRequiredBody =>
      'O Doc View precisa de acesso ao armazenamento para verificar e exibir documentos (PDF, Word, Excel, PPT, TXT, imagens) salvos no seu dispositivo.\n\nSeus arquivos permanecem totalmente privados e offline no seu dispositivo.';

  @override
  String errorCouldNotOpenDocument(String error) {
    return 'Não foi possível abrir o documento: $error';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Verificação concluída: $count arquivos',
      one: 'Verificação concluída: 1 arquivo',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => 'Limpar histórico de pesquisa?';

  @override
  String get dialogClearSearchMessage =>
      'Todas as pesquisas recentes serão apagadas permanentemente.';

  @override
  String imageListEditorMaxLimit(int max) {
    return 'Limite máximo de $max imagens atingido.';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return 'Falha na digitalização: $error';
  }

  @override
  String get imageListEditorPageSize => 'Tamanho da página:';

  @override
  String get imageListEditorA4Mode => 'A4';

  @override
  String get imageListEditorFitMode => 'Ajustar à imagem';

  @override
  String get imageListEditorRemoveImageTooltip => 'Remover imagem';

  @override
  String get mergeScreenTitle => 'Organizar e mesclar';

  @override
  String get mergeScreenDefaultMergedName => 'Documento_Mesclado';

  @override
  String get mergePickerSearchHint => 'Pesquisar PDFs...';

  @override
  String get mergePickerNext => 'Avançar';

  @override
  String mergePickerErrorLoading(String error) {
    return 'Erro ao carregar PDFs: $error';
  }

  @override
  String get splitScreenTitle => 'Dividir PDF';

  @override
  String get splitScreenRangeHint => 'ex.: 1-3, 5, 8-10';

  @override
  String get splitScreenClearRange => 'Limpar intervalo';

  @override
  String get splitPickerSearchHint => 'Pesquisar PDFs...';

  @override
  String splitPickerErrorLoading(String error) {
    return 'Erro ao carregar arquivos: $error';
  }

  @override
  String get createdSectionTitle => 'Criados por você';

  @override
  String get createdSectionEmptyTitle =>
      'Os PDFs que você criar aparecerão aqui';

  @override
  String get createdSectionEmptySubtitle =>
      'Documentos convertidos, digitalizados ou mesclados serão salvos localmente.';

  @override
  String get emptyCreatedDocsTitle => 'Nenhum documento criado ainda';

  @override
  String get emptyCreatedDocsMessage =>
      'Documentos convertidos, digitalizados ou mesclados aparecerão aqui.';

  @override
  String errorLoadingCreatedFiles(String error) {
    return 'Falha ao carregar arquivos criados: $error';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDFs criados',
      one: 'PDF criado',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle => 'Salvo na sua pasta de criados';

  @override
  String get toolErrorDefaultTitle => 'Não foi possível criar o PDF';

  @override
  String get toolErrorSubtitle =>
      'Ocorreu um erro inesperado durante o processamento';

  @override
  String get themeSheetTitle => 'Tema do app';

  @override
  String get themeSheetSubtitle => 'Selecione a aparência visual do Doc View';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeSystemSubtitle => 'padrão';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeLightSubtitle => 'Branco limpo';

  @override
  String get themeModeDark => 'Escuro';

  @override
  String get themeModeDarkSubtitle => 'Azul-marinho profundo';

  @override
  String get themeActionApply => 'Aplicar tema';

  @override
  String get scanSettingsTitle => 'Configurações de verificação';

  @override
  String get scanSettingsFrequencyHeader => 'Frequência de verificação';

  @override
  String get scanSettingsOnOpenTitle => 'Verificar ao abrir o app';

  @override
  String get scanSettingsOnOpenSubtitle =>
      'Encontrar novos arquivos automaticamente ao abrir o Doc View.';

  @override
  String get scanSettingsManualTitle => 'Apenas manual';

  @override
  String get scanSettingsManualSubtitle =>
      'Verificar apenas ao puxar para atualizar ou tocar em Verificar novamente.';

  @override
  String get scanSettingsMediaFiltersHeader => 'Filtros de mídia';

  @override
  String get scanSettingsIncludeImagesTitle => 'Incluir imagens na verificação';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      'Indexar arquivos de imagem PNG, JPG e WEBP no armazenamento.';

  @override
  String get scanSettingsDiagnosticsHeader => 'Armazenamento e diagnósticos';

  @override
  String get scanSettingsPermissionStatus => 'Acesso a todos os arquivos';

  @override
  String get scanSettingsPermissionGranted => 'Concedido';

  @override
  String get scanSettingsPermissionNotGranted => 'Não concedido';

  @override
  String get scanSettingsTotalIndexed => 'Arquivos indexados';

  @override
  String get scanSettingsLastScan => 'Última verificação';

  @override
  String get scanSettingsUpdatedSnackbar =>
      'Configurações de verificação atualizadas';

  @override
  String get faqScreenTitle => 'Perguntas frequentes';

  @override
  String faqHeaderTopics(int count) {
    return '$count tópicos';
  }

  @override
  String get faqHeaderSubtitle =>
      'Tem dúvidas? Encontre respostas claras aqui.';

  @override
  String get faqSendFeedback => 'Enviar feedback';

  @override
  String get faqQuestion1 =>
      'Por que o Doc View precisa de acesso a todos os arquivos?';

  @override
  String get faqAnswer1 =>
      'O Doc View requer acesso a todos os arquivos (MANAGE_EXTERNAL_STORAGE) no Android 11+ para localizar e indexar documentos compatíveis (PDF, Word, Excel, PowerPoint, texto e imagens) armazenados em pastas compartilhadas como Downloads e Documentos.\n\nSem essa permissão, o Android restringe o acesso apenas à pasta interna privada do aplicativo, impedindo o Doc View de navegar ou abrir arquivos salvos no seu dispositivo.';

  @override
  String get faqQuestion2 => 'Por que ele não verifica todo o meu iPhone?';

  @override
  String get faqAnswer2 =>
      'O iOS usa isolamento rigoroso de aplicativos (sandbox) para proteger a privacidade do dispositivo. Os apps só podem acessar documentos salvos explicitamente no app Arquivos ou compartilhados pelo menu Compartilhar do sistema.\n\nPara visualizar arquivos no iOS, importe-os para a pasta Doc View no app nativo Arquivos ou use a opção Importar arquivos nas Configurações.';

  @override
  String get faqQuestion3 => 'Onde ficam salvos os PDFs que eu crio?';

  @override
  String get faqAnswer3 =>
      'Os arquivos importados ou gerados (como PDFs convertidos, documentos mesclados ou páginas divididas) são salvos com segurança no armazenamento do dispositivo em DocView/Created ou no armazenamento privado do app. Você pode vê-los a qualquer momento na seção Criados por você na aba Ferramentas.';

  @override
  String get faqQuestion4 => 'Por que meu arquivo do Word parece diferente?';

  @override
  String get faqAnswer4 =>
      'O Doc View renderiza arquivos diretamente no seu dispositivo usando leitores offline locais, sem enviar dados privados para conversores na nuvem. Formatações complexas ou formas personalizadas são exibidas com aproximações nativas offline.';

  @override
  String get faqQuestion5 => 'Posso abrir arquivos protegidos por senha?';

  @override
  String get faqAnswer5 =>
      'Sim, o Doc View oferece suporte à abertura de documentos PDF protegidos por senha. Ao abrir um PDF criptografado, digite a senha na caixa de diálogo para descriptografar e visualizar o documento no seu dispositivo.';

  @override
  String get faqQuestion6 => 'Meus dados são enviados para algum lugar?';

  @override
  String get faqAnswer6 =>
      'Seus documentos nunca saem do seu dispositivo. O Doc View abre, converte e armazena arquivos localmente. O aplicativo exibe anúncios fornecidos pelo Google AdMob, que pode usar dados limitados do dispositivo conforme descrito em nossa Política de Privacidade.';

  @override
  String get faqQuestion7 =>
      'Por que a conversão de PDF para Word mudou meu layout?';

  @override
  String get faqAnswer7 =>
      'O Doc View converte apenas o texto, diretamente no seu dispositivo. Tabelas, imagens, cores e layout não são mantidos. PDFs digitalizados não podem ser convertidos porque não há texto para ler.';

  @override
  String get toolPdfToWord => 'PDF para Word';

  @override
  String get toolPdfToWordSub => 'Converter PDF em documento editável do Word';

  @override
  String get pdfToWordScreenTitle => 'PDF para Word';

  @override
  String get pdfToWordBannerText =>
      'Apenas o texto é convertido. Tabelas, imagens, cores e layout não são mantidos.';

  @override
  String get pdfToWordPageBreaks =>
      'Inserir quebras de página entre páginas do PDF';

  @override
  String get pdfToWordPageBreaksSubtitle =>
      'Preserva a estrutura do documento entre as páginas';

  @override
  String get pdfToWordSelectPdf => 'Selecionar PDF';

  @override
  String get pdfToWordChangeFile => 'Trocar arquivo';

  @override
  String get pdfToWordConvertAction => 'Converter para Word';

  @override
  String get pdfToWordConverting => 'Convertendo para Word...';

  @override
  String pdfToWordConvertingProgress(int current, int total) {
    return 'Convertendo página $current de $total...';
  }

  @override
  String get pdfToWordSuccess => 'Convertido para Word com sucesso';

  @override
  String get pdfToWordOpenInViewer => 'Abrir no Doc View';

  @override
  String get pdfToWordOpenWith => 'Abrir com...';

  @override
  String get pdfToWordShare => 'Compartilhar';

  @override
  String get pdfToWordNoTextTitle => 'Nenhum texto encontrado';

  @override
  String get pdfToWordNoTextMessage =>
      'Nenhum texto foi encontrado neste PDF. Documentos digitalizados não podem ser convertidos.';

  @override
  String get pdfToWordLargeFileWarning =>
      'Documento grande: a conversão pode levar vários minutos.';

  @override
  String get pdfToWordInvalidFileName => 'Nome de arquivo inválido';

  @override
  String get pdfToWordActionCancel => 'Cancelar';

  @override
  String get pdfToWordEncryptedError =>
      'O PDF selecionado está protegido por senha. Desbloqueie-o para converter.';

  @override
  String get pdfToWordPageLimitError =>
      'O documento excede o limite de 1.000 páginas.';

  @override
  String get pdfToWordTextLimitError =>
      'O documento excede o limite de 20 MB de texto.';

  @override
  String get pdfToWordGeneralError =>
      'Falha ao converter PDF para Word. Tente outro arquivo.';

  @override
  String get pdfGotoPageTitle => 'Ir para a página';

  @override
  String pdfGotoPageHint(int pageCount) {
    return 'Digite uma página entre 1 e $pageCount';
  }

  @override
  String get pdfGotoPageAction => 'Ir';

  @override
  String get pdfGotoPageErrorEmpty => 'Digite um número de página';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return 'Digite uma página entre 1 e $pageCount';
  }

  @override
  String get pdfPasswordTitle => 'Este PDF está protegido por senha';

  @override
  String get pdfPasswordSubtitle =>
      'Digite a senha para descriptografar e visualizar o conteúdo.';

  @override
  String get pdfPasswordHint => 'Digite a senha';

  @override
  String get pdfPasswordErrorIncorrect => 'Senha incorreta. Tente novamente.';

  @override
  String get pdfPasswordActionUnlock => 'Desbloquear';

  @override
  String get errorFileNameEmpty => 'O nome do arquivo não pode ficar vazio';

  @override
  String get errorFileNameTooLong =>
      'O nome do arquivo não pode exceder 120 caracteres';

  @override
  String get errorFileNameReserved =>
      'O nome do arquivo não pode ser \'.\' ou \'..\'';

  @override
  String get errorFileNameStartsWithDot =>
      'O nome do arquivo não pode começar com um ponto';

  @override
  String get errorFileNameInvalidChars =>
      'O nome do arquivo contém caracteres inválidos';

  @override
  String get errorRenameAlreadyExists =>
      'Já existe um arquivo com este nome nesta pasta';

  @override
  String get errorRenameSourceNotFound =>
      'O arquivo de origem não existe mais no armazenamento';

  @override
  String errorRenameFailed(String details) {
    return 'Falha ao renomear arquivo: $details';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      'Arquivos excluídos do disco, mas falhou ao atualizar o banco de dados';

  @override
  String errorDeleteFailed(String details) {
    return 'Falha ao excluir arquivos: $details';
  }

  @override
  String get errorPageRangeDocNoPages => 'O documento não tem páginas';

  @override
  String get errorPageRangeEmpty =>
      'O intervalo de páginas não pode ficar vazio';

  @override
  String get errorPageRangeEmptySegment =>
      'Segmento de intervalo vazio encontrado. Remova vírgulas extras.';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return 'Formato de intervalo inválido: \'$token\'';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return 'Intervalo incompleto: \'$token\'';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return 'Valores não numéricos no intervalo: \'$token\'';
  }

  @override
  String get errorPageRangeBelowMinimum =>
      'Os números de página devem ser 1 ou maiores';

  @override
  String errorPageRangeReversed(int start, int end) {
    return 'Intervalo invertido \'$start-$end\': o início é maior que o fim';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return 'O intervalo \'$token\' excede o total de páginas ($totalPages)';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return 'Número de página inválido: \'$token\'';
  }

  @override
  String get errorImageToPdfNoImages => 'Selecione pelo menos uma imagem';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return 'Máximo de $max imagens permitidas por vez';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return 'Falha ao processar imagem: $path';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return 'Falha ao criar PDF a partir das imagens: $details';
  }

  @override
  String get errorPdfMergeInsufficient =>
      'Selecione pelo menos 2 arquivos PDF para mesclar';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return '$fileName está protegido por senha ou danificado';
  }

  @override
  String get errorPdfMergeNoPages =>
      'Os documentos selecionados não contêm páginas';

  @override
  String errorPdfMergeFailed(String details) {
    return 'Falha ao mesclar PDFs: $details';
  }

  @override
  String get errorPdfSplitNoRanges =>
      'Especifique pelo menos um intervalo de páginas';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return '$fileName está protegido por senha ou danificado';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return 'O intervalo $start-$end está fora dos limites de $fileName';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return 'Falha ao dividir PDF: $details';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return 'PÁG $current/$total';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '($bytes bytes)';
  }

  @override
  String get directoriesProtectedTitle =>
      'Esta pasta é protegida pelo Android.';

  @override
  String get directoriesProtectedDesc =>
      'O Android restringe o acesso a pastas do sistema e pastas privadas de aplicativos.';

  @override
  String get directoriesNotFoundTitle => 'Esta pasta não existe mais.';

  @override
  String get directoriesEmpty => 'Nenhum arquivo ou pasta compatível aqui.';

  @override
  String get directoriesErrorOpening => 'Erro ao abrir a pasta';

  @override
  String get directoriesRoot => 'Raiz';

  @override
  String get scanSettingsSectionFrequency => 'Frequência de verificação';

  @override
  String get scanSettingsSectionFilters => 'Filtros de documentos';

  @override
  String get scanSettingsIncludeImages => 'Incluir imagens';

  @override
  String get scanSettingsIncludeImagesDesc =>
      'Desative para ocultar milhares de fotos da sua lista de documentos';

  @override
  String get scanSettingsImageListUpdated => 'Lista de imagens atualizada';

  @override
  String get scanSettingsActionRescanNow => 'Verificar agora';

  @override
  String get scanSettingsSectionDiagnostics => 'Diagnóstico de armazenamento';

  @override
  String get scanSettingsAllFilesAccessGranted =>
      'Acesso a todos os arquivos concedido';

  @override
  String get scanSettingsAllFilesAccessNeeded =>
      'Acesso a todos os arquivos necessário';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      'O Doc View tem permissão para encontrar arquivos em Downloads e cartões SD.';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      'É necessária permissão para verificar pastas de downloads e armazenamento externo.';

  @override
  String get scanSettingsActionOpenSettings => 'Abrir configurações';

  @override
  String scanSettingsScanningFiles(int count) {
    return 'Verificando... $count arquivos encontrados';
  }

  @override
  String get faqStillNeedHelp => 'Ainda precisa de ajuda? Envie feedback';

  @override
  String get toolsLabelFileName => 'Nome do arquivo';

  @override
  String get toolsAddImagesToStart => 'Adicione imagens para começar';

  @override
  String get toolsAddImagesDesc =>
      'Selecione fotos ou digitalize documentos em papel para gerar um PDF.';

  @override
  String get toolsChoosePhotos => 'Escolher fotos';

  @override
  String get toolsScanPaper => 'Digitalizar papel';

  @override
  String toolsPageNumber(int page) {
    return 'Página $page';
  }

  @override
  String get toolsTooltipRotatePage => 'Girar página';

  @override
  String get toolsTooltipRemovePage => 'Remover página';

  @override
  String get toolsAddMoreScans => 'Adicionar mais digitalizações';

  @override
  String get toolsAddMoreImages => 'Adicionar mais imagens';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imagens · est. ~ $size',
      one: '1 imagem · est. ~ $size',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return '$count selecionado(s)';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return 'Selecione pelo menos $min arquivos';
  }

  @override
  String toolsPagesTotal(int count) {
    return '$count páginas no total';
  }

  @override
  String get toolsPagesTotalLabel => 'páginas no total';

  @override
  String get toolsNoPdfsFound => 'Nenhum documento PDF encontrado';

  @override
  String get semanticBookmarked => 'favoritado';

  @override
  String get semanticSelected => 'selecionado';

  @override
  String get semanticNotSelected => 'não selecionado';

  @override
  String get actionDeselectFile => 'Desmarcar arquivo';

  @override
  String get actionSelectFile => 'Selecionar arquivo';

  @override
  String get actionCreatePdf => 'Criar PDF';

  @override
  String get hintSelectOrViewActions => 'Selecionar ou ver ações';

  @override
  String get actionClose => 'Fechar';

  @override
  String get actionReset => 'Redefinir';

  @override
  String get labelPleaseWait => 'Aguarde...';

  @override
  String get tooltipCloseSearch => 'Fechar pesquisa';

  @override
  String get semanticAdvertisement => 'Publicidade';

  @override
  String get themePreviewLight => 'Claro';

  @override
  String get themePreviewNavy => 'Marinho';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '$name, $size, criado em $date';
  }

  @override
  String get toolsCreatingPdfFromScans => 'Criando PDF das digitalizações';

  @override
  String get toolsCreatingPdf => 'Criando PDF';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return 'Processando imagem $done de $total...';
  }

  @override
  String get toolsErrorCreatePdfTitle => 'Não foi possível criar o PDF';

  @override
  String get toolsBadgeProtectedOrDamaged => 'Protegido ou danificado';

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
  String get toolsPagesAbbrev => 'págs';

  @override
  String get mergeAddMoreTitle => 'Adicionar mais PDFs';

  @override
  String get mergeProgressTitle => 'Mesclando PDFs';

  @override
  String mergeProgressMessage(int done, int total) {
    return 'Mesclando documento $done de $total...';
  }

  @override
  String get mergeErrorTitle => 'Não foi possível mesclar os PDFs';

  @override
  String get mergeDragInstruction => 'Arraste as alças para reordenar';

  @override
  String get mergeAddPdf => 'Adicionar PDF';

  @override
  String get mergeOutputFileNameLabel => 'NOME DO ARQUIVO DE SAÍDA';

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
    return 'Carregando páginas... · $size';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos inválidos detectados',
      one: '1 arquivo inválido detectado',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => 'Pronto para mesclar';

  @override
  String get mergeRemoveProtectedHint =>
      'Remova os documentos protegidos por senha';

  @override
  String mergeSummary(int files, int pages, String size) {
    return '$files arquivos · $pages páginas · ~ $size';
  }

  @override
  String get mergeReadyBadge => 'Pronto';

  @override
  String get mergeBlockedCta => 'Mesclagem bloqueada (resolva os erros)';

  @override
  String mergeActionCta(int files, int pages) {
    return 'Mesclar $files PDFs ($pages páginas)';
  }

  @override
  String get mergePickerDefaultTitle => 'Selecionar PDFs';

  @override
  String mergePickerTabAllPdfs(int count) {
    return 'Todos os PDFs ($count)';
  }

  @override
  String get mergePickerTabRecent => 'Recentes';

  @override
  String get mergePickerTabDownloads => 'Downloads';

  @override
  String get mergePickerTabICloud => 'iCloud Drive';

  @override
  String get splitProgressTitle => 'Dividindo PDF';

  @override
  String splitProgressMessage(int done, int total) {
    return 'Gerando arquivo $done de $total...';
  }

  @override
  String get splitErrorTitle => 'Não foi possível dividir o PDF';

  @override
  String get splitPageRangesLabel => 'INTERVALOS DE PÁGINAS';

  @override
  String get splitPageRangesSyntax => 'Sintaxe: 1-3, 5, 8-10';

  @override
  String get splitRangeHelpText =>
      'Cada intervalo vira um arquivo PDF separado.';

  @override
  String splitGeneratedFilesHeader(int count) {
    return 'ARQUIVOS GERADOS ($count)';
  }

  @override
  String get splitChipsSuspendedTitle => 'Prévia dos intervalos suspensa';

  @override
  String get splitChipsSuspendedDesc =>
      'Corrija o erro de sintaxe acima para reconstruir a lista de extração.';

  @override
  String get splitEmptyRangesHint =>
      'Digite intervalos de páginas acima para gerar divisões do PDF';

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
      other: '$count págs',
      one: '1 pág',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => 'SELEÇÃO RÁPIDA';

  @override
  String get splitMacroAllPages => 'Todas as páginas';

  @override
  String get splitMacroEvery5Pages => 'A cada 5 páginas';

  @override
  String get splitMacroLimitHint =>
      'Macros que geram > 100 arquivos ficam desativadas para proteger a memória do dispositivo';

  @override
  String splitOutputSummary(int files, int pages) {
    return 'Saída: $files arquivos · $pages páginas extraídas';
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
      other: 'Dividir em $count PDFs',
      one: 'Dividir em 1 PDF',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => 'Dividir em PDFs';

  @override
  String splitPickerAllLocalDocs(int count) {
    return 'TODOS OS DOCUMENTOS LOCAIS ($count)';
  }

  @override
  String get splitPickerSortByDate => 'ORDENAR POR DATA';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return 'págs · $size';
  }

  @override
  String get splitPickerTitle => 'Selecionar PDF para dividir';

  @override
  String get faqShortTitle => 'FAQ';

  @override
  String splitPickerSelectedCount(int count) {
    return '$count PDF selecionado';
  }

  @override
  String get splitPickerSelectDocumentHint =>
      'Selecione um documento para continuar';

  @override
  String splitPickerPagesActive(int count) {
    return '$count páginas ativas';
  }

  @override
  String get splitPickerPagesActiveLabel => 'páginas ativas';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSectionGeneral => 'Geral';

  @override
  String get settingsSectionOthers => 'Outros';

  @override
  String get settingsFileManagerTitle => 'Gerenciador de arquivos';

  @override
  String get settingsFileManagerSubtitle =>
      'Navegar por diretórios e pastas do armazenamento';

  @override
  String get settingsFaqTitle => 'FAQ';

  @override
  String get settingsFaqSubtitle => 'Perguntas frequentes';

  @override
  String get settingsShareTitle => 'Compartilhar';

  @override
  String get settingsShareSubtitle => 'Recomende o Doc View para amigos';

  @override
  String settingsShareMessage(String url) {
    return 'Conheça o Doc View — leitor de documentos rápido, privado e offline: $url';
  }

  @override
  String get settingsScanSettingsTitle => 'Configurações de verificação';

  @override
  String get settingsScanModeOnOpen => 'Verificar ao abrir';

  @override
  String get settingsScanModeManual => 'Apenas manual';

  @override
  String get settingsAppThemeTitle => 'Tema do app';

  @override
  String get settingsThemeSystem => 'Padrão do sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Escuro';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsRateUsTitle => 'Avalie-nos';

  @override
  String get settingsRateUsSubtitle => 'Compartilhe sua opinião conosco';

  @override
  String get settingsAddWidgetTitle => 'Adicionar widget';

  @override
  String get settingsAddWidgetSubtitle => 'Acesso rápido pela tela inicial';

  @override
  String get settingsTermsTitle => 'Termos de uso';

  @override
  String get settingsTermsSubtitle => 'Leia nossos termos de serviço';

  @override
  String get settingsPrivacyTitle => 'Política de privacidade';

  @override
  String get settingsPrivacySubtitle => 'Leia nossa política de privacidade';

  @override
  String get settingsManageSubscriptionsTitle => 'Gerenciar assinaturas';

  @override
  String get settingsManageSubscriptionsSubtitle =>
      'Gerencie sua assinatura na loja';

  @override
  String settingsVersionDisplay(String version, String build) {
    return 'Versão $version ($build)';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return 'Versão $version compilação $build';
  }

  @override
  String get settingsOpenSourceLicenses => 'Licenças de código aberto';

  @override
  String get rateSheetTitle => 'Avaliar o Doc View';

  @override
  String get rateSheetSubtitle => 'Seu feedback nos ajuda a melhorar';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estrelas',
      one: '1 estrela',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => 'Que bom que você gostou!';

  @override
  String get rateResponseMedium => 'Obrigado! Conte como podemos melhorar.';

  @override
  String get rateResponseLow =>
      'Sentimos muito por não atender às expectativas. Conte o que corrigir.';

  @override
  String get rateActionStore => 'Avaliar no Google Play';

  @override
  String get rateActionHelpFeedback => 'Ajuda e feedback';

  @override
  String get faqFromRatingBanner =>
      'Sentimos muito por isso. Confira as respostas abaixo ou entre em contato; lemos todas as mensagens.';

  @override
  String get faqActionContactUs => 'Fale conosco';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return 'Feedback do Doc View ($version+$build)';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '\n\n---\nApp: Doc View $version (Build $build)\n';
  }

  @override
  String get faqEmailClientUnavailable =>
      'Não foi possível abrir o cliente de e-mail';

  @override
  String get languageScreenTitle => 'Idioma';

  @override
  String get languageSearchHint => 'Pesquisar idiomas...';

  @override
  String get languageSystemDefault => 'Padrão do sistema';

  @override
  String get languageSystemDefaultSubtitle => 'Seguir o idioma do dispositivo';

  @override
  String get languageNotTranslatedBadge => '(não traduzido)';

  @override
  String get languageNotTranslatedSnack =>
      'Este idioma ainda não está traduzido';

  @override
  String get languageNoResults => 'Nenhum idioma encontrado';

  @override
  String get languagePseudoLocaleName => 'Pseudoidioma (en_XA)';

  @override
  String get languagePseudoLocaleSubtitle => 'Teste de expansão para depuração';

  @override
  String get scanSettingsSectionHistory => 'Histórico';

  @override
  String get scanSettingsClearHistoryTitle => 'Limpar histórico recente';

  @override
  String get scanSettingsClearHistorySubtitle =>
      'Limpar histórico de documentos abertos';

  @override
  String get scanSettingsClearHistoryDialogTitle => 'Limpar histórico recente?';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      'Os arquivos serão removidos de Recentes. Seus arquivos e favoritos não serão afetados.';

  @override
  String get scanSettingsRecentHistoryCleared => 'Histórico recente limpo';

  @override
  String get scanSettingsLastScanToday => 'hoje';

  @override
  String get scanSettingsLastScanYesterday => 'ontem';

  @override
  String get scanSettingsNeverScanned => 'Nunca verificado';

  @override
  String get scanSettingsLastScanPrefix => 'Última verificação:';

  @override
  String get readerActionVertical => 'Vertical';

  @override
  String get readerActionHorizontal => 'Horizontal';

  @override
  String get readerActionRotate => 'Girar';

  @override
  String get readerActionSearch => 'Pesquisar';

  @override
  String get readerActionInvert => 'Inverter';

  @override
  String get readerActionShare => 'Compartilhar';

  @override
  String get readerActionPages => 'Páginas';

  @override
  String get readerSearchHint => 'Pesquisar no documento...';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '$current de $total';
  }

  @override
  String get readerSearchMatchCap => '500+';

  @override
  String get readerSearchNoMatches => '0 de 0';

  @override
  String get readerSearchNoTextLayer => 'Este PDF não possui texto pesquisável';

  @override
  String get readerSearchPrevMatch => 'Ocorrência anterior';

  @override
  String get readerSearchNextMatch => 'Próxima ocorrência';

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
  String get readerMenuGoToPage => 'Ir para a página';

  @override
  String get readerMenuAddBookmark => 'Adicionar aos favoritos';

  @override
  String get readerMenuRemoveBookmark => 'Remover dos favoritos';

  @override
  String get readerMenuDetails => 'Detalhes';

  @override
  String get readerMenuOpenInAnotherApp => 'Abrir em outro app';

  @override
  String get readerTooltipConvertToWord => 'Converter para Word';

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
  String get pagesActionSelectAll => 'Selecionar tudo';

  @override
  String get pagesActionClearSelection => 'Limpar';

  @override
  String get pagesActionSave => 'Salvar';

  @override
  String get pagesActionInsert => 'Inserir';

  @override
  String get pagesActionRotate => 'Girar';

  @override
  String get pagesActionExtract => 'Extrair';

  @override
  String get pagesActionDelete => 'Excluir';

  @override
  String get pagesActionUndo => 'Desfazer';

  @override
  String get pagesInsertSheetTitle => 'Inserir páginas';

  @override
  String get pagesInsertPagesFromPdf => 'Páginas de outro PDF';

  @override
  String get pagesDeleteAllBlocked =>
      'Não é possível excluir todas as páginas. O documento precisa ter pelo menos uma página.';

  @override
  String get pagesSaveDialogTitle => 'Salvar alterações';

  @override
  String get pagesSaveAsNew => 'Salvar como novo arquivo';

  @override
  String get pagesSaveReplace => 'Substituir original';

  @override
  String get pagesSaveReplaceWarning => 'Isso sobrescreve o arquivo original.';

  @override
  String get pagesSaveFileNameLabel => 'Nome do arquivo';

  @override
  String get pagesDiscardDialogTitle => 'Descartar alterações?';

  @override
  String get pagesDiscardDialogBody =>
      'Você tem alterações não salvas. Tem certeza de que deseja descartá-las?';

  @override
  String get pagesDiscardButton => 'Descartar';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas extraídas',
      one: '1 página extraída',
    );
    return '$_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      'Este PDF não pode ser editado porque está criptografado ou ilegível.';

  @override
  String get viewerErrorCorruptTitle => 'Não é possível abrir este documento';

  @override
  String get viewerErrorCorruptMessage =>
      'Este arquivo parece estar danificado ou não é um documento válido.';

  @override
  String get viewerErrorMissingTitle => 'Este arquivo não existe mais';

  @override
  String get viewerErrorMissingMessage =>
      'O arquivo foi excluído ou movido do armazenamento do dispositivo.';

  @override
  String get viewerErrorBackToFiles => 'Voltar aos arquivos';

  @override
  String get viewerErrorNoAppFound =>
      'Nenhum app encontrado para abrir este arquivo';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ocorrências',
      one: '1 ocorrência',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unidades • $ext',
      one: '1 unidade • $ext',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner => 'Formato legado: apenas texto';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      'Planilha grande: exibindo as primeiras 20.000 linhas e 100 colunas';

  @override
  String viewerSectionTitle(int number) {
    return 'Seção $number';
  }

  @override
  String get viewerMenuOutline => 'Sumário';

  @override
  String get viewerOutlineTitle => 'Estrutura do documento';

  @override
  String get viewerCloseOutline => 'Fechar sumário';

  @override
  String get viewerNoSections => 'Nenhuma seção encontrada neste documento';

  @override
  String get viewerOutlineTooltip => 'Índice';

  @override
  String get viewerActionOpenExternal => 'Abrir em outro app';

  @override
  String get viewerErrorCantOpenTitle => 'Não é possível abrir este documento';

  @override
  String get viewerErrorCantOpenMessage =>
      'Não foi possível renderizar o documento offline.';

  @override
  String get viewerOpeningDocument => 'Abrindo documento...';

  @override
  String get viewerErrorEncryptedTitle => 'Este documento está criptografado';

  @override
  String get viewerErrorEncryptedMessage =>
      'Arquivos protegidos por senha não podem ser visualizados no leitor offline.';

  @override
  String get viewerErrorTooLargeTitle =>
      'Este arquivo excede o limite de visualização';

  @override
  String get viewerErrorTooLargeMessage =>
      'Documentos grandes devem ser abertos usando um visualizador Office externo.';

  @override
  String get viewerErrorUnsupportedFormatTitle =>
      'Este formato não é compatível';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      'O Doc View não consegue processar este formato de arquivo diretamente.';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => 'Tipografia';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get txtViewerMonospaceLabel => 'Fonte monoespaçada';

  @override
  String get txtViewerTruncationBanner =>
      'O arquivo é maior que 1 MB: exibindo o primeiro 1 MB';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linhas • $size',
      one: '1 linha • $size',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => 'Configurações de tipografia';

  @override
  String get txtViewerTooltipDecreaseFont => 'Diminuir tamanho da fonte';

  @override
  String get txtViewerTooltipIncreaseFont => 'Aumentar tamanho da fonte';

  @override
  String get txtViewerTooltipToggleMonospace => 'Alternar fonte monoespaçada';

  @override
  String get txtViewerMonospaceSubtitle =>
      'Caracteres de largura fixa para código e logs';

  @override
  String get txtViewerPreviewLabel => 'Pré-visualização';

  @override
  String get txtViewerPreviewText =>
      'Um pequeno jabuti xereta viu dez cegonhas felizes.';

  @override
  String get txtViewerErrorTitle => 'Não é possível ler este arquivo de texto';

  @override
  String get txtViewerErrorMessage =>
      'O formato ou a codificação do arquivo não pôde ser processado.';

  @override
  String get txtViewerActionRetry => 'Tentar novamente';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '$width × $height • $size';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get imageViewerTooltipFitToScreen => 'Ajustar à tela';

  @override
  String get imageViewerErrorCorrupt => 'Não foi possível carregar a imagem';

  @override
  String get imageViewerLoading => 'Carregando imagem…';

  @override
  String get viewerDispatcherFileMissing => 'O arquivo não existe mais';

  @override
  String get viewerSpreadsheetFormulaBarEmpty => '-';

  @override
  String get viewerSpreadsheetAllCells => 'Todas';

  @override
  String viewerSpreadsheetColumnLabel(String col) {
    return 'Coluna $col';
  }

  @override
  String viewerSpreadsheetRowLabel(int row) {
    return 'Linha $row';
  }

  @override
  String viewerSpreadsheetCellSemantics(String col, int row, String value) {
    return 'Coluna $col, linha $row, $value';
  }

  @override
  String get viewerSpreadsheetEmptyCell => 'vazio';

  @override
  String get viewerSpreadsheetEmptySheet => 'Esta planilha está vazia';

  @override
  String get viewerSpreadsheetCopiedSingle => 'Célula copiada';

  @override
  String viewerSpreadsheetCopiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count células copiadas',
      one: '1 célula copiada',
    );
    return '$_temp0';
  }

  @override
  String get viewerSpreadsheetCopyLimitReached =>
      'Seleção limitada a 5.000 células';

  @override
  String get viewerSpreadsheetCellContentTitle => 'Conteúdo da célula';

  @override
  String get viewerSpreadsheetCopyAction => 'Copiar';

  @override
  String get viewerSpreadsheetCloseAction => 'Fechar';

  @override
  String viewerSpreadsheetZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get viewerSpreadsheetResetZoomTooltip => 'Redefinir zoom para 100%';

  @override
  String get viewerSpreadsheetNoMatches => 'Nenhuma ocorrência nesta planilha';

  @override
  String get viewerSpreadsheetSearchPlaceholder => 'Localizar na planilha…';

  @override
  String get viewerSpreadsheetPasswordTitle => 'Arquivo protegido por senha';

  @override
  String get viewerSpreadsheetPasswordMessage =>
      'Arquivos protegidos por senha não podem ser abertos aqui.';

  @override
  String get viewerSpreadsheetErrorTitle => 'Não é possível ler esta planilha';

  @override
  String get viewerSpreadsheetCorruptMessage =>
      'O arquivo da planilha está corrompido ou não pôde ser decodificado.';

  @override
  String get viewerSpreadsheetTimeoutMessage =>
      'A abertura da planilha atingiu o tempo limite após 20 segundos.';

  @override
  String get viewerSpreadsheetTooLargeMessage =>
      'Este arquivo excede o limite de visualização de 25 MB.';

  @override
  String get viewerSpreadsheetOpenBasicViewer => 'Abrir no leitor básico';

  @override
  String get viewerSpreadsheetOpenAnotherApp => 'Abrir em outro app';

  @override
  String get toolsWorkspaceOverline => 'ESPAÇO DE TRABALHO';

  @override
  String get toolsTitle => 'Ferramentas';

  @override
  String get toolsSectionConvertCreate => 'CONVERTER E CRIAR';

  @override
  String get toolsSectionEditManage => 'EDITAR E GERENCIAR';

  @override
  String get toolsSectionOthers => 'OUTROS';

  @override
  String get toolsCreatedByYou => 'Criados por você';

  @override
  String get toolsCreatedByYouEmpty => 'Os PDFs que você criar aparecerão aqui';

  @override
  String get toolsCreatedByYouSeeAll => 'Ver tudo';

  @override
  String get toolManagePages => 'Gerenciar páginas';

  @override
  String get toolManagePagesSub => 'Reordenar, girar e excluir';

  @override
  String get toolImportFiles => 'Importar arquivos';

  @override
  String get toolImportFilesSub => 'Adicionar de outros apps';

  @override
  String get toolPrintPdf => 'Imprimir PDF';

  @override
  String get toolPrintPdfSub => 'Enviar para qualquer impressora';

  @override
  String get toolCreatePdf => 'Criar PDF';

  @override
  String get toolCreatePdfSub => 'Documento em branco ou modelo';

  @override
  String get toolRecycleBin => 'Lixeira';

  @override
  String get toolRecycleBinSub => 'Restaurar arquivos excluídos';

  @override
  String get toolAnnotate => 'Anotar';

  @override
  String get toolAnnotateSub => 'Destacar, desenhar e marcar';

  @override
  String get toolAddText => 'Adicionar texto';

  @override
  String get toolAddTextSub => 'Inserir texto e datas';

  @override
  String get toolSign => 'Assinar';

  @override
  String get toolSignSub => 'Preencher e assinar formulários';

  @override
  String get toolWordToPdf => 'Word para PDF';

  @override
  String get toolWordToPdfSub => 'Converter DOCX para PDF';

  @override
  String get toolPptToPdf => 'PPT para PDF';

  @override
  String get toolPptToPdfSub => 'Converter PPTX para PDF';

  @override
  String get printPdfErrorTooLarge =>
      'O arquivo PDF excede o limite de impressão de 50 MB.';

  @override
  String get printPdfErrorUnreadable =>
      'Não foi possível ler o PDF para impressão.';

  @override
  String get printPdfErrorPassword =>
      'Não é possível imprimir um PDF protegido por senha diretamente.';

  @override
  String get printPdfErrorFailed => 'Falha na impressão.';

  @override
  String get printPdfSuccess => 'Documento enviado para a impressora.';

  @override
  String get toolPickerTitleSelectPdf => 'Selecionar PDF';

  @override
  String get toolPickerTitleSelectPdfs => 'Selecionar PDFs';

  @override
  String get toolPickerBrowseFiles => 'Procurar arquivos';

  @override
  String get toolPickerTabAll => 'Todos os PDFs';

  @override
  String get toolPickerTabRecent => 'Recentes';

  @override
  String get toolPickerTabDownloads => 'Downloads';

  @override
  String get toolPickerTabICloud => 'iCloud Drive';

  @override
  String get toolPickerActionPrint => 'Imprimir';

  @override
  String get toolPickerActionManage => 'Gerenciar';

  @override
  String get toolPickerActionSelect => 'Selecionar';

  @override
  String get toolsImportActionView => 'Visualizar';

  @override
  String get createPdfTemplateBlank => 'Em branco';

  @override
  String get createPdfTemplateLine1 => 'Pautado 1';

  @override
  String get createPdfTemplateLine2 => 'Pautado 2';

  @override
  String get createPdfTemplateNotebook => 'Caderno';

  @override
  String get createPdfTemplateCornell => 'Cornell';

  @override
  String get createPdfTemplateGrid => 'Quadriculado';

  @override
  String get createPdfTemplateGraph => 'Milimetrado';

  @override
  String get createPdfSwatchWhite => 'Branco';

  @override
  String get createPdfSwatchCream => 'Creme';

  @override
  String get createPdfSwatchLightYellow => 'Amarelo-claro';

  @override
  String get createPdfSwatchLightPeach => 'Pêssego-claro';

  @override
  String get createPdfSwatchLightPink => 'Rosa-claro';

  @override
  String get createPdfSwatchLightLavender => 'Lavanda-claro';

  @override
  String get createPdfSwatchLightBlue => 'Azul-claro';

  @override
  String get createPdfSwatchLightMint => 'Menta-claro';

  @override
  String get createPdfSwatchLightGreen => 'Verde-claro';

  @override
  String get createPdfSwatchLightGray => 'Cinza-claro';

  @override
  String get createPdfOrientationPortrait => 'Retrato';

  @override
  String get createPdfOrientationLandscape => 'Paisagem';

  @override
  String get createPdfSectionTemplate => 'MODELO';

  @override
  String get createPdfSectionPageSize => 'TAMANHO DA PÁGINA';

  @override
  String get createPdfSectionOrientation => 'ORIENTAÇÃO';

  @override
  String get createPdfSectionPageColor => 'COR DA PÁGINA';

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
  String get createPdfCreating => 'Gerando PDF...';

  @override
  String createPdfProgress(int done, int total) {
    return 'Montando página $done de $total...';
  }

  @override
  String get createPdfErrorTitle => 'Não foi possível criar o PDF';

  @override
  String get createPdfErrorPageCount =>
      'O número de páginas deve ser entre 1 e 100.';

  @override
  String get createPdfErrorInvalidName => 'Digite um nome de arquivo válido.';

  @override
  String get createPdfErrorGeneration =>
      'Falha ao gerar o documento PDF. Tente novamente.';

  @override
  String get trashErrorTooLarge =>
      'O arquivo é grande demais para a Lixeira (limite de 200 MB)';

  @override
  String get trashErrorNotEnoughSpace =>
      'Espaço de armazenamento insuficiente na Lixeira';

  @override
  String trashErrorGeneric(String details) {
    return 'Falha na operação da Lixeira: $details';
  }

  @override
  String get trashDialogMoveTitle => 'Mover para a Lixeira?';

  @override
  String trashDialogMoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Mover $count arquivos para a Lixeira? Você pode restaurá-los em Ferramentas > Lixeira por 30 dias.',
      one:
          'Mover 1 arquivo para a Lixeira? Você pode restaurá-lo em Ferramentas > Lixeira por 30 dias.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionMove => 'Mover para a Lixeira';

  @override
  String trashMovedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos movidos para a Lixeira',
      one: '1 arquivo movido para a Lixeira',
    );
    return '$_temp0';
  }

  @override
  String get trashActionUndo => 'Desfazer';

  @override
  String trashRestoredSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos restaurados',
      one: '1 arquivo restaurado',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogDeleteForeverTitle => 'Excluir permanentemente?';

  @override
  String trashDialogDeleteForeverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Excluir $count arquivos permanentemente? Essa ação não pode ser desfeita.',
      one:
          'Excluir 1 arquivo permanentemente? Essa ação não pode ser desfeita.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionDeleteForever => 'Excluir para sempre';

  @override
  String trashDeletedForeverSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos excluídos para sempre',
      one: '1 arquivo excluído para sempre',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogEmptyTitle => 'Esvaziar Lixeira?';

  @override
  String trashDialogEmptyBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'todos os $count arquivos',
      one: '1 arquivo',
    );
    return 'Excluir permanentemente $_temp0? Essa ação não pode ser desfeita.';
  }

  @override
  String get trashActionEmptyBin => 'Esvaziar lixeira';

  @override
  String get trashEmptyTitle => 'A Lixeira está vazia';

  @override
  String get trashEmptySubtitle =>
      'Os arquivos movidos para a Lixeira ficam aqui por 30 dias antes de serem excluídos permanentemente.';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count dias',
      one: 'Falta 1 dia',
    );
    return '$_temp0';
  }

  @override
  String trashSubtitle(String date, String size) {
    return 'Excluído em $date · $size';
  }

  @override
  String get trashDialogTooLargeTitle => 'Grande demais para a Lixeira';

  @override
  String trashDialogTooLargeBody(String fileName) {
    return '\"$fileName\" tem mais de 200 MB e não pode ser movido para a Lixeira. Deseja excluí-lo permanentemente?';
  }

  @override
  String get trashActionDeletePermanently => 'Excluir permanentemente';

  @override
  String get trashInfoBanner =>
      'Os itens na Lixeira são excluídos permanentemente após 30 dias.';

  @override
  String get trashSheetRestore => 'Restaurar';

  @override
  String get trashSheetDeleteForever => 'Excluir para sempre';

  @override
  String get trashSheetDetails => 'Detalhes';

  @override
  String get trashDetailsOriginalLocation => 'Local original';

  @override
  String get trashDetailsDateDeleted => 'Data de exclusão';

  @override
  String get trashDetailsExpiresIn => 'Expira em';

  @override
  String trashRestoredToFallbackSuccess(String location) {
    return 'Restaurado em $location (pasta original não encontrada)';
  }

  @override
  String get trashDialogCopyFailedTitle =>
      'Não foi possível mover para a Lixeira';

  @override
  String trashDialogCopyFailedBody(String fileName) {
    return 'Não foi possível mover \"$fileName\" para a Lixeira. Deseja excluí-lo permanentemente? Essa ação não pode ser desfeita.';
  }

  @override
  String get trashDialogEmptyProgress => 'Esvaziando Lixeira...';

  @override
  String get trashDialogMoveProgress => 'Movendo arquivos para a Lixeira...';

  @override
  String get trashDialogNotEnoughSpaceTitle =>
      'Espaço de armazenamento insuficiente';

  @override
  String get trashDialogNotEnoughSpaceBody =>
      'Não há espaço suficiente para mover para a Lixeira. Libere espaço esvaziando a lixeira.';

  @override
  String get trashActionFreeUpSpace => 'Liberar espaço';

  @override
  String get trashDialogDeleteForeverProgress =>
      'Excluindo arquivos permanentemente...';

  @override
  String get galleryDebugAgeTrash =>
      'Envelhecer todos os itens da lixeira em 29 dias';

  @override
  String get galleryDebugSlowCopy => 'Cópia lenta para lixeira (teste)';

  @override
  String get galleryDebugSlowCopySubtitle =>
      'Limita o loop de cópia a ~20 MB/s para testes de interrupção';

  @override
  String get galleryDebugSlowSave => 'Salvamento lento no editor (teste)';

  @override
  String get galleryDebugSlowSaveSubtitle =>
      'Limita o loop de salvamento a ~8 s para testes de interrupção';

  @override
  String get galleryDebugSaveAnnotate => 'Salvar amostra 100p (teste Anotar)';

  @override
  String get galleryDebugSaveSign => 'Salvar amostra 100p (teste Assinar)';

  @override
  String get galleryDebugSaveText =>
      'Salvar amostra 100p (teste Adicionar texto)';

  @override
  String get galleryDebugMove190Mb =>
      'Mover arquivo de teste de 190 MB para a lixeira';

  @override
  String get galleryDebugRestoreLastTrash => 'Restaurar último item da lixeira';

  @override
  String get galleryDebugEmptyTrash => 'Esvaziar Lixeira';

  @override
  String galleryDebugAgeTrashSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens envelhecidos',
      one: '1 item envelhecido',
    );
    return '$_temp0 em 29 dias';
  }

  @override
  String get annotateErrorPasswordProtected =>
      'Este PDF está protegido por senha.';

  @override
  String get annotateErrorCorrupt =>
      'Este PDF está corrompido ou não pode ser lido.';

  @override
  String get annotateSignedReplaceBlocked =>
      'Não é permitido substituir o PDF assinado original. Salve como um novo arquivo.';

  @override
  String annotateErrorSaveFailed(String details) {
    return 'Falha ao salvar anotações: $details';
  }

  @override
  String get annotateErrorScannedPdf =>
      'Este documento parece ser digitalizado ou não contém texto selecionável.';

  @override
  String get annotateSignedBanner =>
      'PDF assinado digitalmente: ao salvar, será criada uma nova cópia para preservar a assinatura.';

  @override
  String get annotateActionSaveNew => 'Salvar como novo arquivo';

  @override
  String get annotateActionReplace => 'Substituir original';

  @override
  String get annotateDiscardDialogTitle => 'Descartar anotações não salvas?';

  @override
  String get annotateDiscardDialogBody =>
      'Você tem marcações não salvas. Se sair agora, suas alterações serão perdidas.';

  @override
  String get annotateDiscardDialogActionDiscard => 'Descartar';

  @override
  String get annotateDiscardDialogActionKeep => 'Continuar editando';

  @override
  String get annotateSaveSuccess => 'Anotações salvas com sucesso';

  @override
  String get annotateToolbarHighlight => 'Destacar';

  @override
  String get annotateToolbarUnderline => 'Sublinhar';

  @override
  String get annotateToolbarStrikethrough => 'Tachado';

  @override
  String get annotateToolbarCopy => 'Copiar';

  @override
  String get annotateColorYellow => 'Amarelo';

  @override
  String get annotateColorGreen => 'Verde';

  @override
  String get annotateColorCyan => 'Ciano';

  @override
  String get annotateColorPink => 'Rosa';

  @override
  String get annotateColorOrange => 'Laranja';

  @override
  String get annotateSaveTitle => 'Salvar anotações';

  @override
  String get annotateSaveProgress => 'Salvando anotações...';

  @override
  String get annotateNoChanges => 'Nenhuma anotação para salvar';

  @override
  String get annotateTooltipUndo => 'Desfazer';

  @override
  String get annotateTooltipRedo => 'Refazer';

  @override
  String get annotateTooltipSave => 'Salvar';

  @override
  String get annotateCopiedToClipboard =>
      'Copiado para a área de transferência';

  @override
  String get annotateToolbarPen => 'Caneta';

  @override
  String get annotatePenTipBanner =>
      'Desenhe com um dedo. Mova e dê zoom com dois dedos.';

  @override
  String get annotatePenSheetTitle => 'Configurações da caneta';

  @override
  String get annotatePenStrokeWidth => 'Espessura do traço';

  @override
  String get annotatePenEraserMode => 'Borracha';

  @override
  String get annotateColorBlack => 'Preto';

  @override
  String get annotateColorRed => 'Vermelho';

  @override
  String get annotateColorPurple => 'Roxo';

  @override
  String get annotateColorBlue => 'Azul';

  @override
  String get toolSignPdf => 'Assinar PDF';

  @override
  String get toolSignPdfSubtitle => 'Adicionar assinatura e data a documentos';

  @override
  String get signToolbarSign => 'Assinar';

  @override
  String get signToolbarDate => 'Data';

  @override
  String get signToolbarClearAll => 'Limpar tudo';

  @override
  String get signPadTitle => 'Desenhe sua assinatura';

  @override
  String get signPadClear => 'Limpar';

  @override
  String get signPadSave => 'Salvar assinatura';

  @override
  String get signSheetTitle => 'Assinaturas salvas';

  @override
  String get signSheetCreateNew => 'Criar nova assinatura';

  @override
  String get signMaxSignaturesReached =>
      'Máximo de 5 assinaturas salvas atingido';

  @override
  String get signMaxPlacedReached =>
      'Máximo de 20 assinaturas por documento atingido';

  @override
  String get signDeleteSignatureTitle => 'Excluir assinatura?';

  @override
  String get signDeleteSignatureBody =>
      'Esta assinatura será removida das suas assinaturas salvas.';

  @override
  String get signConfirmClearAllTitle => 'Limpar todas as assinaturas?';

  @override
  String get signConfirmClearAllBody =>
      'Todas as assinaturas e datas inseridas neste documento serão removidas.';

  @override
  String get signSaveSuccess => 'Documento assinado com sucesso';

  @override
  String get signNoSignaturesToSave =>
      'Nenhuma assinatura inserida no documento';

  @override
  String get signPlacedSignatureDelete => 'Excluir';

  @override
  String get signPlacedSignatureApply => 'Aplicar';

  @override
  String get signTooltipUndo => 'Desfazer';

  @override
  String get signTooltipRedo => 'Refazer';

  @override
  String get signTooltipSave => 'Salvar';

  @override
  String annotatePenStrokeWidthValue(String width) {
    return '$width pt';
  }

  @override
  String get annotateErrorTooManyStrokes =>
      'O documento atingiu o máximo de 5.000 traços ou 300.000 pontos.';

  @override
  String annotateChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alterações',
      one: '1 alteração',
    );
    return '$_temp0';
  }

  @override
  String get annotatePenNotice =>
      'Os traços de caneta passam a fazer parte da página ao salvar e não podem ser editados depois.';

  @override
  String get annotatePenNoticeDismiss => 'Entendi';

  @override
  String get signPadBaselineHint => 'Assine aqui';

  @override
  String get signPadUndo => 'Desfazer';

  @override
  String get signPadUseOnce => 'Usar uma vez';

  @override
  String get signPadSaveAndUse => 'Salvar e usar';

  @override
  String get tool_add_text => 'Adicionar texto';

  @override
  String get tool_add_text_desc =>
      'Inserir caixas de texto e notas nas páginas';

  @override
  String get addTextNoticePermanent =>
      'O texto adicionado passa a fazer parte da página e não pode ser editado após salvar.';

  @override
  String get addTextNoticeRaster =>
      'O texto neste idioma é adicionado como imagem e não pode ser selecionado.';

  @override
  String get addTextNoticeGotIt => 'Entendi';

  @override
  String get addTextActionAdd => 'Adicionar texto';

  @override
  String get addTextActionStyle => 'Estilo';

  @override
  String get addTextActionDelete => 'Excluir';

  @override
  String get addTextStyleSheetTitle => 'Estilo do texto';

  @override
  String get addTextFontSize => 'Tamanho da fonte';

  @override
  String get addTextColor => 'Cor';

  @override
  String get addTextStyle => 'Estilo';

  @override
  String get addTextAlign => 'Alinhamento';

  @override
  String get addTextBold => 'Negrito';

  @override
  String get addTextItalic => 'Itálico';

  @override
  String get addTextAlignStart => 'Início';

  @override
  String get addTextAlignCenter => 'Centro';

  @override
  String get addTextAlignEnd => 'Fim';

  @override
  String get addTextErrorTooManyBoxes =>
      'Máximo de 30 caixas de texto atingido';

  @override
  String get addTextErrorBoxTooLong =>
      'A caixa de texto não pode exceder 2.000 caracteres';

  @override
  String get addTextPlaceholder => 'Digite o texto aqui';

  @override
  String get addTextSamplePreview => 'Prévia de exemplo';

  @override
  String addTextFontSizePt(int size) {
    return '$size pt';
  }

  @override
  String get premiumTitle => 'Doc View Premium';

  @override
  String get premiumSubtitle =>
      'Desbloqueie as ferramentas Anotar e Assinar e aproveite uma experiência totalmente sem anúncios.';

  @override
  String get premiumFeatureAllTools => 'Ferramentas Anotar e Assinar PDF';

  @override
  String get premiumFeatureAllToolsSub =>
      'Faça marcações, destaque documentos e assine PDFs sem esforço';

  @override
  String get premiumFeatureAdFree => 'Experiência 100% sem anúncios';

  @override
  String get premiumFeatureAdFreeSub =>
      'Sem banners, interrupções ou distrações em lugar nenhum';

  @override
  String get premiumFeatureUnlimitedConversions =>
      'Conversões locais ilimitadas';

  @override
  String get premiumFeatureUnlimitedConversionsSub =>
      'Converta documentos no dispositivo sem limite de arquivos';

  @override
  String get premiumFeaturePrivacyFirst => '100% privado e no dispositivo';

  @override
  String get premiumFeaturePrivacyFirstSub =>
      'Os arquivos são processados localmente e nunca enviados a nenhum servidor';

  @override
  String get premiumPlanYearly => 'Assinatura anual';

  @override
  String premiumPlanYearlyTrial(int days, String price) {
    return '$days dias grátis, depois $price/ano';
  }

  @override
  String get premiumPlanMonthly => 'Assinatura mensal';

  @override
  String premiumPlanMonthlySub(String price) {
    return '$price/mês';
  }

  @override
  String premiumPlanYearlySub(String price) {
    return '$price/ano';
  }

  @override
  String premiumPlanMonthlyTrial(int days, String price) {
    return '$days dias grátis, depois $price/mês';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Economize $percent%';
  }

  @override
  String get premiumSaveUnknown => 'Economize -%';

  @override
  String premiumActionStartTrial(int days) {
    return 'Iniciar teste grátis de $days dias';
  }

  @override
  String get premiumSubscriptionsAvailableSoon =>
      'As assinaturas estarão disponíveis em breve.';

  @override
  String get pagesEditPagesAction => 'Editar páginas';

  @override
  String get premiumCancelAnytime => 'Cancele quando quiser';

  @override
  String get premiumPendingStatus =>
      'Sua compra está sendo processada pelo Google Play. Os benefícios serão ativados após a confirmação.';

  @override
  String get premiumRenewalDisclosurePricingUnavailable =>
      'Renovação automática. O preço será confirmado pelo Google Play na finalização da compra. Cancele quando quiser nas Assinaturas do Google Play.';

  @override
  String get premiumActionSubscribe => 'Assinar';

  @override
  String get premiumActionRestore => 'Restaurar compras';

  @override
  String get premiumBillingDisclaimer =>
      'Renovação automática. Cancele quando quiser nas Assinaturas do Google Play.';

  @override
  String get premiumTerms => 'Termos de Serviço';

  @override
  String get premiumPrivacy => 'Política de Privacidade';

  @override
  String get premiumActiveStatus => 'Você é assinante Premium';

  @override
  String get premiumGraceStatus => 'Período de carência offline ativo';

  @override
  String get premiumExpiredStatus => 'Assinatura expirada';

  @override
  String get premiumRestoreSuccess => 'Compras restauradas com sucesso.';

  @override
  String get premiumRestoreNone => 'Nenhuma assinatura ativa encontrada.';

  @override
  String get premiumErrorGeneral =>
      'Não foi possível concluir a compra. Tente novamente.';

  @override
  String get premiumPagesGateTitle => 'Doc View Premium';

  @override
  String get premiumPagesGateBody =>
      'Reordenar, girar e excluir páginas requer uma assinatura Premium.';

  @override
  String get premiumPagesGateUpgrade => 'Assinar o Premium';

  @override
  String get premiumTooltip => 'Doc View Premium';

  @override
  String get premiumManageInPlay => 'Gerenciar';

  @override
  String get faqQuestion8 => 'O que está incluído no Doc View Premium?';

  @override
  String get faqAnswer8 =>
      'O Doc View Premium desbloqueia todas as ferramentas avançadas de edição de documentos, incluindo reordenação, rotação e exclusão de páginas PDF, conversão de PDF para Word, anotações, assinaturas e inserção de texto personalizado, além de eliminar completamente todos os anúncios no app. Todo o processamento de documentos continua 100% no dispositivo.';

  @override
  String get faqQuestion9 =>
      'Posso usar o Doc View Premium sem conexão com a internet?';

  @override
  String get faqAnswer9 =>
      'Sim. Após a ativação, o Doc View armazena com segurança o status da sua assinatura no dispositivo com um período de carência offline de até 7 dias consecutivos. Você pode continuar usando todas as ferramentas de edição offline durante esse período.';

  @override
  String get galleryDebugIapSectionTitle =>
      '15. Simulador de IAP e Premium (G7)';

  @override
  String get galleryDebugIapStateFree => 'Definir Gratuito';

  @override
  String get galleryDebugIapStateYearly => 'Definir Premium Anual';

  @override
  String get galleryDebugIapStateMonthly => 'Definir Premium Mensal';

  @override
  String get galleryDebugIapStateGrace => 'Definir Carência Offline (Ativa)';

  @override
  String get galleryDebugIapStateGraceExpired =>
      'Definir Carência Offline (Expirada)';

  @override
  String get galleryDebugOpenPremium => 'Abrir tela /premium';

  @override
  String get galleryDebugIapProductSeenTrue => 'Definir Produto Visto: Sim';

  @override
  String get galleryDebugIapProductSeenFalse => 'Definir Produto Visto: Não';

  @override
  String get addWidgetSheetTitle => 'Adicionar à tela inicial';

  @override
  String get addWidgetSheetSubtitle =>
      'Escolha um widget para adicionar à sua tela inicial';

  @override
  String get widgetRecentFilesTitle => 'Arquivos recentes';

  @override
  String get widgetRecentFilesBadge => '4 × 2';

  @override
  String get widgetRecentFilesDesc =>
      'Veja e abra os arquivos usados recentemente direto da tela inicial';

  @override
  String get widgetQuickToolsTitle => 'Ferramentas rápidas';

  @override
  String get widgetQuickToolsBadge => '4 × 1';

  @override
  String get widgetQuickToolsDesc =>
      'Acesse direto Digitalizar, Imagem para PDF, Pesquisar ou Importar';

  @override
  String get addWidgetButton => 'Adicionar widget';

  @override
  String get addWidgetManualTitle => 'Adicionar widget manualmente';

  @override
  String get addWidgetManualMessage =>
      'Toque e segure um espaço vazio na tela inicial, toque em Widgets, encontre o Doc View e arraste-o para a tela.';

  @override
  String get settingsQuickAccessNotificationTitle =>
      'Notificação de acesso rápido';

  @override
  String get settingsQuickAccessNotificationSubtitle =>
      'Mostrar ferramentas rápidas na barra de notificações';

  @override
  String get notificationPermissionDialogTitle => 'Permitir notificações';

  @override
  String get notificationPermissionDialogDesc =>
      'O Doc View precisa da permissão de notificações para exibir a barra de acesso rápido na sua central de notificações.';

  @override
  String get notificationTitle => 'Ferramentas rápidas do Doc View';

  @override
  String get notificationBody => 'Digitalize, converta ou pesquise documentos';

  @override
  String get notificationActionScan => 'Digitalizar';

  @override
  String get notificationActionImageToPdf => 'Imagem para PDF';

  @override
  String get notificationActionSearch => 'Pesquisar';

  @override
  String get settingsAdChoicesTitle => 'Preferências de anúncios';

  @override
  String get settingsAdChoicesSubtitle =>
      'Gerenciar escolhas de privacidade e publicidade';

  @override
  String get faqQuestion10 => 'Por que o Doc View exibe anúncios?';

  @override
  String get faqAnswer10 =>
      'Os anúncios mantêm o Doc View gratuito. O Premium os remove. Os anúncios são fornecidos pelo Google AdMob e nunca têm acesso aos seus documentos.';
}
