import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/iap_config.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/constants/file_types.dart';
import '../../data/models/doc_file.dart';
import '../../data/models/spreadsheet_data.dart';
import '../../data/services/billing/billing_providers.dart';
import '../premium/premium_screen.dart';
import '../providers/providers.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../shared/widgets/ads/ad_placeholders.dart';
import '../../shared/widgets/buttons/doc_buttons.dart';
import '../../shared/widgets/buttons/doc_icon_button.dart';
import '../../shared/widgets/inputs/doc_inputs.dart';
import '../../shared/widgets/modals/doc_modals.dart';
import '../../shared/widgets/navigation/doc_app_bar.dart';
import '../../shared/widgets/navigation/doc_bottom_nav_bar.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';
import '../../shared/widgets/reader/reader_bottom_row.dart';
import '../../shared/widgets/reader/reader_search_bar.dart';
import '../../shared/widgets/skeletons/skeleton_variants.dart';
import '../../shared/widgets/spreadsheet/formula_bar.dart';
import '../../shared/widgets/spreadsheet/sheet_tab_bar.dart';
import '../../shared/widgets/spreadsheet/spreadsheet_grid.dart';
import '../../shared/widgets/spreadsheet/zoom_pill.dart';
import '../../shared/widgets/status/doc_status_widgets.dart';
import '../../shared/widgets/tabs/doc_tabs_and_filters.dart';
import '../../shared/widgets/tiles/category_tile.dart';
import '../../shared/widgets/tiles/file_and_folder_rows.dart';
import '../../shared/widgets/tiles/file_type_badge.dart';
import '../../shared/widgets/tools/doc_tool_widgets.dart';
import '../../data/models/pdf_markup.dart';
import '../../data/models/pdf_text_box.dart';
import '../../data/models/placed_signature.dart';
import '../../data/services/pdf/pdf_annotation_service.dart';
import '../../data/services/trash_service.dart';
import '../tools/annotate/annotate_session_notifier.dart';
import '../tools/annotate/widgets/annotate_toolbar.dart';
import '../tools/annotate/widgets/selection_menu.dart';
import '../../data/services/notifications/quick_access_notification_service.dart';
import '../settings/widgets/add_widget_bottom_sheet.dart';
import '../../data/services/ads/consent_gateway.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Debug-only Component Gallery showcasing the entire Doc View component library.
/// Only available in [kDebugMode], accessible via long-press on Settings version row.
class ComponentGalleryScreen extends ConsumerStatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  ConsumerState<ComponentGalleryScreen> createState() =>
      _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends ConsumerState<ComponentGalleryScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showOnlyIapSection = false;
  bool _showOnlyAdsSection = false;
  DebugGeography? _debugGeography;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      try {
        final actionFile = File('/data/user/0/com.craftlineinteractive.docview/files/debug_action.txt');
        if (actionFile.existsSync()) {
          final content = actionFile.readAsStringSync().trim();
          if (content == 'show_iap_simulator') {
            _showOnlyIapSection = true;
          } else if (content == 'show_ads_section') {
            _showOnlyAdsSection = true;
          }
        }
      } catch (_) {}
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkAutoAction());
    }
  }

  Future<void> _checkAutoAction() async {
    try {
      final file = File('/data/user/0/com.craftlineinteractive.docview/files/debug_action.txt');
      if (await file.exists()) {
        final action = (await file.readAsString()).trim();
        await file.delete();
        debugPrint('[AUTO_ACTION] Executing: $action');
        if (action == 'move_190mb') {
          TrashService.slowCopyThrottleEnabled = true;
          await _executeMove190Mb();
        } else if (action == 'restore_190mb') {
          TrashService.slowCopyThrottleEnabled = true;
          await _executeRestore190Mb();
        } else if (action == 'empty_trash') {
          TrashService.slowCopyThrottleEnabled = true;
          await _executeEmptyTrash();
        } else if (action == 'prep_empty_trash') {
          await _executePrepEmptyTrash();
        } else if (action == 'check_consistency') {
          await ref.read(trashPurgeServiceProvider).checkConsistency();
        } else if (action == 'save_annotate') {
          await _executeSaveAnnotate();
        } else if (action == 'save_sign') {
          await _executeSaveSign();
        } else if (action == 'save_text') {
          await _executeSaveText();
        } else if (action == 'open_pdf_to_word_20p') {
          final f = File('/sdcard/Documents/sample_20p.pdf');
          final stat = await f.stat();
          final doc = DocFile(
            path: f.path,
            name: 'sample_20p.pdf',
            extension: 'pdf',
            sizeBytes: stat.size,
            modified: stat.modified,
            category: FileCategory.pdf,
          );
          if (mounted) context.push('/tools/pdf-to-word', extra: doc);
        } else if (action == 'open_pdf_to_word_scanned') {
          final f = File('/sdcard/Documents/sample_scanned.pdf');
          final stat = await f.stat();
          final doc = DocFile(
            path: f.path,
            name: 'sample_scanned.pdf',
            extension: 'pdf',
            sizeBytes: stat.size,
            modified: stat.modified,
            category: FileCategory.pdf,
          );
          if (mounted) context.push('/tools/pdf-to-word', extra: doc);
        } else if (action == 'open_viewer_20p') {
          final f = File('/sdcard/Documents/sample_20p.pdf');
          final stat = await f.stat();
          final doc = DocFile(
            path: f.path,
            name: 'sample_20p.pdf',
            extension: 'pdf',
            sizeBytes: stat.size,
            modified: stat.modified,
            category: FileCategory.pdf,
          );
          if (mounted) context.push('/viewer', extra: doc);
        } else if (action == 'open_converted_docx') {
          final outputDir = await ref.read(pdfOutputServiceProvider).getOutputDir();
          final f = File('${outputDir.path}/sample_20p.docx');
          final fallback = File('/sdcard/Documents/sample_20p.docx');
          final target = await f.exists() ? f : fallback;
          final stat = await target.stat();
          final doc = DocFile(
            path: target.path,
            name: 'sample_20p.docx',
            extension: 'docx',
            sizeBytes: stat.size,
            modified: stat.modified,
            category: FileCategory.word,
          );
          if (mounted) context.push('/viewer', extra: doc);
        } else if (action == 'show_converting_progress') {
          if (mounted) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (ctx) => Container(
                decoration: BoxDecoration(
                  color: ctx.tokens.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(
                  child: ProgressSheet(
                    title: context.l10n.pdfToWordConverting,
                    statusText: context.l10n.pdfToWordConvertingProgress(9, 20),
                    progress: 0.45,
                  ),
                ),
              ),
            );
          }
        } else if (action == 'show_conversion_result') {
          if (mounted) {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (ctx) => Container(
                decoration: BoxDecoration(
                  color: ctx.tokens.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ResultSheet(
                        title: context.l10n.pdfToWordSuccess,
                        fileName: 'sample_20p.docx',
                        metadata: '5.3 KB',
                        onOpen: () => Navigator.pop(ctx),
                        onShare: () => Navigator.pop(ctx),
                        onClose: () => Navigator.pop(ctx),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            key: const Key('btn_open_with'),
                            icon: const Icon(Icons.open_in_new_rounded, size: 20),
                            label: Text(context.l10n.pdfToWordOpenWith),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        } else if (action == 'show_iap_simulator') {
          setState(() => _showOnlyIapSection = true);
        } else if (action == 'show_premium_subscribed' || action == 'set_premium_yearly_and_open') {
          ref.read(premiumControllerProvider).setSimulatedState(
            isPremium: true,
            isGracePeriod: false,
            activeProductId: IapConfig.subscriptionProductId,
            activeBasePlanId: IapConfig.yearlyBasePlanId,
            verifiedAt: DateTime.now(),
          );
          await Future.delayed(const Duration(milliseconds: 600));
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PremiumScreen()),
            );
          }
        }
        }
      }
    } catch (e) {
      debugPrint('[AUTO_ACTION] Error: $e');
    }
  }

  Future<void> _executeMove190Mb() async {
    const testFilePath = '/sdcard/Documents/kill_test_190mb.pdf';
    final testFile = File(testFilePath);
    if (!await testFile.exists()) return;
    final stat = await testFile.stat();
    final doc = DocFile(
      path: testFilePath,
      name: 'kill_test_190mb.pdf',
      extension: 'pdf',
      sizeBytes: stat.size,
      modified: stat.modified,
      category: FileCategory.pdf,
    );
    debugPrint('[KILL_TEST] Starting move to trash at ${DateTime.now().toIso8601String()}');
    try {
      await ref.read(trashServiceProvider).moveSingleToTrash(doc);
      debugPrint('[KILL_TEST] Finished move to trash at ${DateTime.now().toIso8601String()}');
    } catch (e) {
      debugPrint('[KILL_TEST] Failed move to trash: $e');
    }
  }

  Future<void> _executeRestore190Mb() async {
    final items = await ref.read(trashServiceProvider).getAllTrashItems();
    if (items.isEmpty) return;
    final target = items.first;
    debugPrint('[KILL_TEST] Starting restore at ${DateTime.now().toIso8601String()}');
    try {
      await ref.read(trashServiceProvider).restoreItem(target);
      debugPrint('[KILL_TEST] Finished restore at ${DateTime.now().toIso8601String()}');
    } catch (e) {
      debugPrint('[KILL_TEST] Restore failed: $e');
    }
  }

  Future<void> _executeEmptyTrash() async {
    debugPrint('[KILL_TEST] Starting empty trash at ${DateTime.now().toIso8601String()}');
    try {
      final count = await ref.read(trashServiceProvider).emptyTrash();
      debugPrint('[KILL_TEST] Finished empty trash ($count items) at ${DateTime.now().toIso8601String()}');
    } catch (e) {
      debugPrint('[KILL_TEST] Empty trash failed: $e');
    }
  }

  Future<void> _executePrepEmptyTrash() async {
    TrashService.slowCopyThrottleEnabled = false;
    final f1 = File('/sdcard/Documents/trash_test_1.pdf');
    final f2 = File('/sdcard/Documents/trash_test_2.pdf');
    if (!await f1.exists()) await f1.writeAsBytes(List.filled(1024 * 50, 65));
    if (!await f2.exists()) await f2.writeAsBytes(List.filled(1024 * 50, 66));
    
    final doc1 = DocFile(
      path: f1.path,
      name: 'trash_test_1.pdf',
      extension: 'pdf',
      sizeBytes: await f1.length(),
      modified: DateTime.now(),
      category: FileCategory.pdf,
    );
    final doc2 = DocFile(
      path: f2.path,
      name: 'trash_test_2.pdf',
      extension: 'pdf',
      sizeBytes: await f2.length(),
      modified: DateTime.now(),
      category: FileCategory.pdf,
    );
    await ref.read(trashServiceProvider).moveSingleToTrash(doc1);
    await ref.read(trashServiceProvider).moveSingleToTrash(doc2);
    debugPrint('[KILL_TEST] Prep empty trash completed: 2 items in trash');
  }

  Future<void> _executeSaveAnnotate() async {
    const filePath = '/sdcard/Documents/sample_100p.pdf';
    debugPrint('[KILL_TEST] Starting save annotate at ${DateTime.now().toIso8601String()}');
    try {
      await const PdfAnnotationService().saveAnnotations(
        sourcePath: filePath,
        outputPath: filePath,
        replaceOriginal: true,
        markups: [
          TextMarkup(
            id: 'm1',
            pageIndex: 0,
            type: TextMarkupType.highlight,
            colorValue: AnnotateColors.yellow.toARGB32(),
            lineRects: [const Rect.fromLTWH(50, 100, 200, 20)],
            text: 'Sample Marked Text',
            createdAtMs: DateTime.now().millisecondsSinceEpoch,
          ),
        ],
      );
      debugPrint('[KILL_TEST] Finished save annotate at ${DateTime.now().toIso8601String()}');
    } catch (e) {
      debugPrint('[KILL_TEST] Save annotate error: $e');
    }
  }

  Future<void> _executeSaveSign() async {
    const filePath = '/sdcard/Documents/sample_100p.pdf';
    debugPrint('[KILL_TEST] Starting save sign at ${DateTime.now().toIso8601String()}');
    try {
      await const PdfAnnotationService().saveAnnotations(
        sourcePath: filePath,
        outputPath: filePath,
        replaceOriginal: true,
        signatures: [
          PlacedSignature(
            id: 's1',
            pageIndex: 0,
            bounds: const Rect.fromLTWH(100, 200, 150, 50),
            timestampMs: DateTime.now().millisecondsSinceEpoch,
          ),
        ],
      );
      debugPrint('[KILL_TEST] Finished save sign at ${DateTime.now().toIso8601String()}');
    } catch (e) {
      debugPrint('[KILL_TEST] Save sign error: $e');
    }
  }

  Future<void> _executeSaveText() async {
    const filePath = '/sdcard/Documents/sample_100p.pdf';
    debugPrint('[KILL_TEST] Starting save text at ${DateTime.now().toIso8601String()}');
    try {
      await const PdfAnnotationService().saveAnnotations(
        sourcePath: filePath,
        outputPath: filePath,
        replaceOriginal: true,
        textBoxes: [
          PdfTextBox(
            id: 't1',
            pageIndex: 0,
            bounds: const Rect.fromLTWH(100, 300, 200, 40),
            text: 'Sample Add Text Annotation',
            fontSize: 14,
            lines: [
              PdfTextLine(
                text: 'Sample Add Text Annotation',
                dx: 0,
                dy: 0,
                width: 200,
                height: 18,
                baseline: 14,
              ),
            ],
          ),
        ],
      );
      debugPrint('[KILL_TEST] Finished save text at ${DateTime.now().toIso8601String()}');
    } catch (e) {
      debugPrint('[KILL_TEST] Save text error: $e');
    }
  }

  bool _isDark = false;
  double _textScale = 1.0;
  bool _usePseudoLocale = false;
  bool _isRtl = false;
  int _selectedNavTab = 0;
  int _selectedUnderlineTab = 0;
  FileCategory? _selectedCategory;
  int _segmentedIndex = 0;
  bool _checkboxVal = true;
  int _radioVal = 1;
  bool _switchVal = true;
  bool _adLoaded = true;
  int _gallerySheetIndex = 0;
  SpreadsheetSelection _gallerySpreadsheetSelection = const SpreadsheetSelection.cell(0, 0);
  double _galleryGridZoom = 1.0;
  final SheetData _gallerySheetData = SheetData(
    name: 'Q1 Forecast',
    rowCount: 4,
    columnCount: 3,
    cells: {
      const CellCoordinate(0, 0): const SpreadsheetCell(rawValue: 'Region', style: CellStyleData(isBold: true)),
      const CellCoordinate(0, 1): const SpreadsheetCell(rawValue: 'Revenue', style: CellStyleData(isBold: true, textAlign: TextAlign.right)),
      const CellCoordinate(0, 2): const SpreadsheetCell(rawValue: 'Growth', style: CellStyleData(isBold: true, textAlign: TextAlign.right)),
      const CellCoordinate(1, 0): const SpreadsheetCell(rawValue: 'North America'),
      const CellCoordinate(1, 1): const SpreadsheetCell(rawValue: '1250000', type: CellDataType.number),
      const CellCoordinate(1, 2): const SpreadsheetCell(rawValue: '0.12', type: CellDataType.number),
      const CellCoordinate(2, 0): const SpreadsheetCell(rawValue: 'Europe'),
      const CellCoordinate(2, 1): const SpreadsheetCell(rawValue: '850000', type: CellDataType.number),
      const CellCoordinate(2, 2): const SpreadsheetCell(rawValue: '0.08', type: CellDataType.number),
      const CellCoordinate(3, 0): const SpreadsheetCell(rawValue: 'Total', style: CellStyleData(isBold: true)),
      const CellCoordinate(3, 1): const SpreadsheetCell(rawValue: '2100000', formula: '=SUM(B2:B3)', type: CellDataType.number, style: CellStyleData(isBold: true)),
    },
  );

  final TextEditingController _searchCtrl = TextEditingController(text: 'Quarterly Report');
  final TextEditingController _textCtrl = TextEditingController(text: 'Annual_Budget_2026');
  final TextEditingController _pwdCtrl = TextEditingController(text: 'secret123');

  @override
  void dispose() {
    _scrollController.dispose();
    _searchCtrl.dispose();
    _textCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Theme(
      data: theme,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(_textScale),
        ),
        child: Directionality(
          textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Localizations.override(
            context: context,
            locale: _usePseudoLocale ? const Locale('en', 'XA') : const Locale('en'),
            child: Builder(
              builder: (themedContext) {
                final tokens = themedContext.tokens;

                return DocScaffold(
                  applyHeaderGradient: true,
                  appBar: DocSubAppBar(
                    title: 'Component Gallery',
                    actions: [
                      DocIconButton(
                        icon: Icons.language,
                        tooltip: _usePseudoLocale
                            ? 'Switch to English'
                            : 'Switch to Pseudo-locale (en_XA)',
                        color: _usePseudoLocale
                            ? tokens.primaryBlue
                            : tokens.textSecondary,
                        onPressed: () =>
                            setState(() => _usePseudoLocale = !_usePseudoLocale),
                      ),
                      DocIconButton(
                        icon: Icons.format_textdirection_r_to_l,
                        tooltip: _isRtl ? 'Switch to LTR' : 'Switch to RTL',
                        color: _isRtl ? tokens.primaryBlue : tokens.textSecondary,
                        onPressed: () => setState(() => _isRtl = !_isRtl),
                      ),
                      DocIconButton(
                        icon: _isDark ? Icons.light_mode : Icons.dark_mode,
                        tooltip: _isDark ? 'Switch to Light' : 'Switch to Dark',
                        onPressed: () => setState(() => _isDark = !_isDark),
                      ),
                      DocIconButton(
                        icon: Icons.text_fields,
                        tooltip: 'Text scale: ${_textScale}x (tap to toggle)',
                        onPressed: () => setState(
                          () => _textScale = _textScale == 1.0 ? 2.0 : 1.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  body: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 40),
                    children: [
                      if (_showOnlyAdsSection) ...[
                        const SectionHeader(title: '17. Google Mobile Ads & UMP Consent (G9)'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Simulate consent states, UMP dialogs, and AdMob integration.',
                                style: DocViewTypography.bodyMd,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  FilledButton.tonal(
                                    key: const Key('gallery_geo_eea'),
                                    onPressed: () {
                                      setState(() => _debugGeography = DebugGeography.debugGeographyEea);
                                      ref.read(consentGatewayProvider).requestConsentInfoUpdate(debugGeography: _debugGeography);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Debug Geography set to EEA & update requested')),
                                      );
                                    },
                                    child: const Text('Set EEA Geography'),
                                  ),
                                  FilledButton.tonal(
                                    key: const Key('gallery_geo_other'),
                                    onPressed: () {
                                      setState(() => _debugGeography = DebugGeography.debugGeographyOther);
                                      ref.read(consentGatewayProvider).requestConsentInfoUpdate(debugGeography: _debugGeography);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Debug Geography set to Other & update requested')),
                                      );
                                    },
                                    child: const Text('Set Non-EEA Geography'),
                                  ),
                                  FilledButton.tonal(
                                    key: const Key('gallery_geo_disabled'),
                                    onPressed: () {
                                      setState(() => _debugGeography = DebugGeography.debugGeographyDisabled);
                                      ref.read(consentGatewayProvider).requestConsentInfoUpdate(debugGeography: _debugGeography);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Debug Geography disabled & update requested')),
                                      );
                                    },
                                    child: const Text('Disable Debug Geography'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  FilledButton(
                                    key: const Key('gallery_request_consent_update'),
                                    onPressed: () async {
                                      final gateway = ref.read(consentGatewayProvider);
                                      await gateway.requestConsentInfoUpdate(debugGeography: _debugGeography);
                                      final canRequest = await gateway.canRequestAds();
                                      final privacyReq = await gateway.isPrivacyOptionsRequired();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('canRequestAds: $canRequest, privacyOptionsRequired: $privacyReq')),
                                        );
                                      }
                                    },
                                    child: const Text('Request Consent Info'),
                                  ),
                                  FilledButton(
                                    key: const Key('gallery_show_consent_form'),
                                    onPressed: () async {
                                      final gateway = ref.read(consentGatewayProvider);
                                      final shown = await gateway.showConsentFormIfRequired();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Consent form shown / completed: $shown')),
                                        );
                                      }
                                    },
                                    child: const Text('Show Consent Form'),
                                  ),
                                  FilledButton(
                                    key: const Key('gallery_show_privacy_options'),
                                    onPressed: () async {
                                      final gateway = ref.read(consentGatewayProvider);
                                      await gateway.showPrivacyOptionsForm();
                                    },
                                    child: const Text('Show Privacy Options Form'),
                                  ),
                                  FilledButton.tonal(
                                    key: const Key('gallery_reset_consent'),
                                    onPressed: () async {
                                      final gateway = ref.read(consentGatewayProvider);
                                      await gateway.reset();
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Consent state reset')),
                                        );
                                      }
                                    },
                                    child: const Text('Reset Consent'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              FilledButton.icon(
                                key: const Key('gallery_simulate_interstitial'),
                                onPressed: () async {
                                  await InterstitialPlaceholder.show(context, ref: ref);
                                },
                                icon: const Icon(Icons.fullscreen),
                                label: const Text('Simulate Interstitial Ad'),
                              ),
                              const SizedBox(height: 16),
                              const Text('Native Ad Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              const NativeAdRow(),
                              const SizedBox(height: 16),
                              const Text('Adaptive Banner Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              const AdBannerSlot(),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ] else ...[
                        if (!_showOnlyIapSection) ...[
                        // --- Section 0: Environment Controls ---
                      const SectionHeader(title: '0. Environment Controls'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          color: tokens.surface,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: tokens.hairline),
                          ),
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: const Text('Pseudo-locale (en_XA)'),
                                subtitle: Text(_usePseudoLocale
                                    ? 'Active: [!!! Hêéllôö wôörld !!!] (+40% expansion)'
                                    : 'Standard English (en)'),
                                value: _usePseudoLocale,
                                onChanged: (val) {
                                  setState(() => _usePseudoLocale = val);
                                  ref
                                      .read(settingsProvider.notifier)
                                      .setLocaleCode(val ? 'en_XA' : null);
                                },
                              ),
                              Divider(color: tokens.hairline, height: 1),
                              SwitchListTile(
                                title: const Text('Force RTL'),
                                subtitle: Text(_isRtl
                                    ? 'Right-to-Left layout active'
                                    : 'Left-to-Right layout active'),
                                value: _isRtl,
                                onChanged: (val) {
                                  setState(() => _isRtl = val);
                                  ref
                                      .read(debugForceRtlProvider.notifier)
                                      .setForceRtl(val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // --- Section 1: Typography & Tokens ---
                      const SectionHeader(title: '1. Typography & Tokens'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Space Grotesk Headline XL', style: DocViewTypography.headlineXl.copyWith(color: tokens.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Space Grotesk Headline LG', style: DocViewTypography.headlineLg.copyWith(color: tokens.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Space Grotesk Headline SM', style: DocViewTypography.headlineSm.copyWith(color: tokens.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Inter Title MD (Bold)', style: DocViewTypography.titleMd.copyWith(color: tokens.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Inter Body LG (Medium)', style: DocViewTypography.bodyLg.copyWith(color: tokens.textSecondary)),
                        const SizedBox(height: 4),
                        Text('Inter Body MD (Regular)', style: DocViewTypography.bodyMd.copyWith(color: tokens.textSecondary)),
                        const SizedBox(height: 12),
                        const Text('FileTypeBadges (Small, Medium, Large):'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            const FileTypeBadge(category: FileCategory.pdf, size: BadgeSize.small),
                            const FileTypeBadge(category: FileCategory.word, size: BadgeSize.medium),
                            const FileTypeBadge(category: FileCategory.excel, size: BadgeSize.large),
                            const FileTypeBadge(category: FileCategory.ppt, size: BadgeSize.medium),
                            const FileTypeBadge(category: FileCategory.txt, size: BadgeSize.small),
                            const FileTypeBadge(category: FileCategory.image, size: BadgeSize.large),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- Section 2: Buttons ---
                  const SectionHeader(title: '2. Button Family'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        DocPrimaryButton(label: 'Primary Button (56pt)', onPressed: () {}),
                        const SizedBox(height: 10),
                        DocSecondaryButton(label: 'Secondary Button', onPressed: () {}),
                        const SizedBox(height: 10),
                        DocTonalButton(label: 'Tonal Button', onPressed: () {}),
                        const SizedBox(height: 10),
                        DocDestructiveButton(label: 'Destructive Button', onPressed: () {}),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DocIconButton(icon: AppIcons.search, tooltip: 'Search', onPressed: () {}),
                            DocIconButton(icon: AppIcons.bookmark, tooltip: 'Bookmark', color: DocViewColors.warning, onPressed: () {}),
                            DocIconButton(icon: AppIcons.delete, tooltip: 'Delete', color: DocViewColors.error, onPressed: () {}),
                            DocFab(icon: AppIcons.add, tooltip: 'FAB Button', onPressed: () {}),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- Section 3: Inputs & Form Controls ---
                  const SectionHeader(title: '3. Input & Form Family'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        DocSearchField(controller: _searchCtrl),
                        const SizedBox(height: 12),
                        DocTextField(
                          controller: _textCtrl,
                          label: 'Document Rename (Locked Suffix)',
                          lockedSuffix: '.pdf',
                        ),
                        const SizedBox(height: 12),
                        DocTextField(
                          controller: _pwdCtrl,
                          label: 'Password Protected',
                          isPassword: true,
                        ),
                        const SizedBox(height: 12),
                        DocSegmentedControl<int>(
                          options: const {0: 'A4 Page', 1: 'Fit to Image'},
                          selectedValue: _segmentedIndex,
                          onValueChanged: (val) => setState(() => _segmentedIndex = val),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            DocCheckbox(
                              value: _checkboxVal,
                              label: 'Checkbox',
                              onChanged: (val) => setState(() => _checkboxVal = val ?? false),
                            ),
                            const Spacer(),
                            DocRadio<int>(
                              value: 1,
                              groupValue: _radioVal,
                              label: 'Radio A',
                              onChanged: (v) => setState(() => _radioVal = v),
                            ),
                            const Spacer(),
                            DocSwitch(
                              value: _switchVal,
                              onChanged: (v) => setState(() => _switchVal = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // --- Section 4: Tabs, Filters, Breadcrumbs ---
                  const SectionHeader(title: '4. Tabs & Navigation Primitives'),
                  DocUnderlineTabs(
                    selectedIndex: _selectedUnderlineTab,
                    recentCount: 14,
                    bookmarksCount: 3,
                    onTabSelected: (i) => setState(() => _selectedUnderlineTab = i),
                  ),
                  const SizedBox(height: 8),
                  DocFilterChipRow(
                    selectedCategory: _selectedCategory,
                    counts: const {
                      FileCategory.pdf: 92,
                      FileCategory.word: 45,
                      FileCategory.excel: 18,
                    },
                    onSelected: (cat) => setState(() => _selectedCategory = cat),
                  ),
                  const SizedBox(height: 8),
                  DocBreadcrumbBar(
                    pathSegments: const ['Root', 'Internal Storage', 'Download', 'PDFs'],
                    onSegmentTap: (_) {},
                  ),

                  // --- Section 5: Tiles & Rows ---
                  const SectionHeader(title: '5. Tiles & Rows'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.78,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        CategoryTile(
                          category: FileCategory.pdf,
                          label: 'PDF',
                          icon: AppIcons.pdf,
                          count: 92,
                          onTap: () {},
                        ),
                        CategoryTile(
                          category: FileCategory.word,
                          label: 'Word',
                          icon: AppIcons.word,
                          count: 45,
                          onTap: () {},
                        ),
                        CategoryTile(
                          category: FileCategory.excel,
                          label: 'Excel',
                          icon: AppIcons.excel,
                          count: 18,
                          onTap: () {},
                        ),
                        CategoryTile(
                          label: 'Directories',
                          icon: AppIcons.folderFilled,
                          count: 8,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FileRow(
                    title: 'Q3_Financial_Analysis_Report.pdf',
                    metadata: 'Oct 24, 2026 • 2.4 MB',
                    category: FileCategory.pdf,
                    filePath: '/storage/sample.pdf',
                    isBookmarked: true,
                    onTap: () {},
                    onToggleBookmark: () {},
                    onOptions: () {},
                  ),
                  FileRow(
                    title: 'Sprint_32_User_Stories.docx',
                    metadata: 'Yesterday • 450 KB',
                    category: FileCategory.word,
                    filePath: '/storage/sample.docx',
                    isBookmarked: false,
                    isSelected: true,
                    isSelectionMode: true,
                    onTap: () {},
                  ),
                  FolderRow(
                    folderName: 'Download',
                    subtitle: '12 items • Modified 2 hours ago',
                    onTap: () {},
                  ),

                  // --- Section 6: Skeletons & Shimmer ---
                  const SectionHeader(title: '6. Shimmer & Skeletons'),
                  const SkeletonFileRow(),
                  const SkeletonFolderRow(),
                  const SkeletonToolCard(),

                  // --- Section 7: Ad Placeholders ---
                  SectionHeader(title: '7. Ad Placeholders (Loaded: $_adLoaded)'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _adLoaded = !_adLoaded),
                          child: Text(_adLoaded ? 'Simulate NO_FILL (Collapse)' : 'Simulate Load Ad'),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(themedContext).push(
                              MaterialPageRoute(
                                builder: (_) => InterstitialPlaceholder(
                                  onDismiss: () => Navigator.of(themedContext).pop(),
                                ),
                              ),
                            );
                          },
                          child: const Text('Show Interstitial'),
                        ),
                      ],
                    ),
                  ),
                  AdBannerSlot(isLoaded: _adLoaded),
                  const SizedBox(height: 8),
                  NativeAdRow(isLoaded: _adLoaded),

                  // --- Section 8: Status & Info Widgets ---
                  const SectionHeader(title: '8. Status & Info'),
                  const InfoBanner(
                    message: 'Background indexing in progress (48/120 files)',
                    icon: AppIcons.refresh,
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: PageNumberPill(currentPage: 4, totalPages: 12),
                  ),
                  const SizedBox(height: 12),
                  const ExpandableFaqCard(
                    question: 'Can I view password-protected PDFs?',
                    answer: 'Yes! Doc View prompts for the document password in-app and renders securely without saving passwords to disk.',
                  ),

                  // --- Section 9: Tool Widgets ---
                  const SectionHeader(title: '9. Tool Components'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ToolCard(
                          title: 'Image to PDF',
                          description: 'Convert JPG, PNG, WEBP into standard PDF',
                          icon: AppIcons.image,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        ToolCard(
                          title: 'Scan to PDF',
                          description: 'Capture documents with edge detection',
                          icon: AppIcons.scanner,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        ToolCard(
                          title: 'Merge PDF',
                          description: 'Combine multiple documents into one',
                          icon: AppIcons.merge,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1A66E8), Color(0xFF1557C0)],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        ToolCard(
                          title: 'Split PDF',
                          description: 'Extract ranges or divide by page count',
                          icon: AppIcons.split,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        DashedAddCard(
                          label: 'Add more files',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        const OnboardingPageIndicator(currentPage: 0, totalPages: 3),
                      ],
                    ),
                  ),

                  // --- Section 10: Modal Sheets Trigger ---
                  const SectionHeader(title: '10. Modals & Sheets'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: DocTonalButton(
                            label: 'Options Sheet',
                            height: 48,
                            onPressed: () {
                              DocBottomSheet.show(
                                context: themedContext,
                                title: 'Document Options',
                                child: Column(
                                  children: [
                                    OptionsListTile(
                                      icon: AppIcons.openWith,
                                      label: 'Open Document',
                                      onTap: () {},
                                    ),
                                    OptionsListTile(
                                      icon: AppIcons.share,
                                      label: 'Share File',
                                      onTap: () {},
                                    ),
                                    OptionsListTile(
                                      icon: AppIcons.rename,
                                      label: 'Rename Document',
                                      onTap: () {},
                                    ),
                                    OptionsListTile(
                                      icon: AppIcons.delete,
                                      label: 'Delete Document',
                                      isDestructive: true,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DocTonalButton(
                            label: 'Result Sheet',
                            height: 48,
                            onPressed: () {
                              DocBottomSheet.show(
                                context: themedContext,
                                child: ResultSheet(
                                  fileName: 'Combined_Invoices.pdf',
                                  metadata: '12 Pages • 3.4 MB',
                                  onOpen: () => Navigator.of(themedContext).pop(),
                                  onShare: () => Navigator.of(themedContext).pop(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Section 11: Reader Components ---
                  const SectionHeader(title: '11. Reader Components'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const ReaderSearchBar(
                          totalMatches: 14,
                          currentMatchIndex: 1,
                        ),
                        const SizedBox(height: 8),
                        const ReaderSearchBar(
                          totalMatches: 0,
                          hasNoTextLayer: true,
                        ),
                        const SizedBox(height: 12),
                        ReaderBottomRow(
                          items: [
                            ReaderBottomRowItem(
                              icon: Icons.swap_horiz_rounded,
                              label: 'Horizontal',
                              onTap: () {},
                            ),
                            ReaderBottomRowItem(
                              icon: Icons.screen_rotation_outlined,
                              label: 'Rotate',
                              onTap: () {},
                            ),
                            ReaderBottomRowItem(
                              icon: Icons.search_rounded,
                              label: 'Search',
                              onTap: () {},
                            ),
                            ReaderBottomRowItem(
                              icon: Icons.invert_colors_rounded,
                              label: 'Invert',
                              isSelected: true,
                              onTap: () {},
                            ),
                            ReaderBottomRowItem(
                              icon: Icons.share_outlined,
                              label: 'Share',
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const ReaderBottomRow(
                          isLoading: true,
                          items: [],
                        ),
                      ],
                    ),
                  ),

                  // --- Section 12: Spreadsheet Components ---
                  const SectionHeader(title: '12. Spreadsheet Grid & Controls'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FormulaBar(
                          sheet: _gallerySheetData,
                          selection: _gallerySpreadsheetSelection,
                        ),
                        const SizedBox(height: 8),
                        SheetTabBar(
                          sheetNames: const ['Q1 Forecast', 'Q2 Plan', 'Consolidated'],
                          activeIndex: _gallerySheetIndex,
                          onSheetSelected: (index) => setState(() => _gallerySheetIndex = index),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ZoomPill(
                              scale: _galleryGridZoom,
                              onReset: () => setState(() => _galleryGridZoom = 1.0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 180,
                          child: SpreadsheetGrid(
                            sheet: _gallerySheetData,
                            selection: _gallerySpreadsheetSelection,
                            zoomScale: _galleryGridZoom,
                            onZoomChanged: (z) => setState(() => _galleryGridZoom = z),
                            onSelectionChanged: (sel) => setState(() => _gallerySpreadsheetSelection = sel),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Section 13: Recycle Bin Debug Controls ---
                  const SectionHeader(title: '13. Recycle Bin Debug Controls'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SwitchListTile.adaptive(
                          title: Text(themedContext.l10n.galleryDebugSlowCopy),
                          subtitle: Text(themedContext.l10n.galleryDebugSlowCopySubtitle),
                          value: TrashService.slowCopyThrottleEnabled,
                          onChanged: (val) {
                            setState(() {
                              TrashService.slowCopyThrottleEnabled = val;
                            });
                          },
                        ),
                        SwitchListTile.adaptive(
                          title: Text(themedContext.l10n.galleryDebugSlowSave),
                          subtitle: Text(themedContext.l10n.galleryDebugSlowSaveSubtitle),
                          value: PdfAnnotationService.slowSaveThrottleEnabled,
                          onChanged: (val) {
                            setState(() {
                              PdfAnnotationService.slowSaveThrottleEnabled = val;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () async {
                            final count = await ref
                                .read(trashPurgeServiceProvider)
                                .ageAllTrashItems(days: 29);
                            ref.invalidate(trashItemsProvider);
                            ref.invalidate(trashCountProvider);
                            if (themedContext.mounted) {
                              ScaffoldMessenger.of(themedContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    themedContext.l10n
                                        .galleryDebugAgeTrashSuccess(count),
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.history_toggle_off),
                          label: Text(
                            themedContext.l10n.galleryDebugAgeTrash,
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          key: const Key('btn_test_move_190mb'),
                          onPressed: () async {
                            const testFilePath = '/sdcard/Documents/kill_test_190mb.pdf';
                            final testFile = File(testFilePath);
                            if (!await testFile.exists()) {
                              if (themedContext.mounted) {
                                ScaffoldMessenger.of(themedContext).showSnackBar(
                                  const SnackBar(content: Text('kill_test_190mb.pdf not found on disk')),
                                );
                              }
                              return;
                            }
                            final stat = await testFile.stat();
                            final doc = DocFile(
                              path: testFilePath,
                              name: 'kill_test_190mb.pdf',
                              extension: 'pdf',
                              sizeBytes: stat.size,
                              modified: stat.modified,
                              category: FileCategory.pdf,
                            );
                            debugPrint('[KILL_TEST] Starting move to trash at ${DateTime.now().toIso8601String()}');
                            try {
                              await ref.read(trashServiceProvider).moveSingleToTrash(doc);
                              debugPrint('[KILL_TEST] Finished move to trash at ${DateTime.now().toIso8601String()}');
                              ref.invalidate(trashItemsProvider);
                              ref.invalidate(trashCountProvider);
                              if (themedContext.mounted) {
                                ScaffoldMessenger.of(themedContext).showSnackBar(
                                  const SnackBar(content: Text('Successfully moved 190MB to trash')),
                                );
                              }
                            } catch (e) {
                              debugPrint('[KILL_TEST] Failed move to trash: $e');
                              if (themedContext.mounted) {
                                ScaffoldMessenger.of(themedContext).showSnackBar(
                                  SnackBar(content: Text('Move failed: $e')),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.delete_sweep),
                          label: Text(themedContext.l10n.galleryDebugMove190Mb),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          key: const Key('btn_test_restore_last'),
                          onPressed: () async {
                            final items = await ref.read(trashServiceProvider).getAllTrashItems();
                            if (items.isEmpty) {
                              if (themedContext.mounted) {
                                ScaffoldMessenger.of(themedContext).showSnackBar(
                                  const SnackBar(content: Text('Trash is empty')),
                                );
                              }
                              return;
                            }
                            final target = items.first;
                            debugPrint('[KILL_TEST] Starting restore at ${DateTime.now().toIso8601String()}');
                            try {
                              await ref.read(trashServiceProvider).restoreItem(target);
                              debugPrint('[KILL_TEST] Finished restore at ${DateTime.now().toIso8601String()}');
                              ref.invalidate(trashItemsProvider);
                              ref.invalidate(trashCountProvider);
                              if (themedContext.mounted) {
                                ScaffoldMessenger.of(themedContext).showSnackBar(
                                  SnackBar(content: Text('Restored ${target.originalName}')),
                                );
                              }
                            } catch (e) {
                              debugPrint('[KILL_TEST] Restore failed: $e');
                            }
                          },
                          icon: const Icon(Icons.restore),
                          label: Text(themedContext.l10n.galleryDebugRestoreLastTrash),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          key: const Key('btn_test_empty_trash'),
                          onPressed: () async {
                            debugPrint('[KILL_TEST] Starting empty trash at ${DateTime.now().toIso8601String()}');
                            final count = await ref.read(trashServiceProvider).emptyTrash();
                            debugPrint('[KILL_TEST] Finished empty trash ($count items) at ${DateTime.now().toIso8601String()}');
                            ref.invalidate(trashItemsProvider);
                            ref.invalidate(trashCountProvider);
                            if (themedContext.mounted) {
                              ScaffoldMessenger.of(themedContext).showSnackBar(
                                SnackBar(content: Text('Emptied $count items')),
                              );
                            }
                          },
                          icon: const Icon(Icons.delete_forever),
                          label: Text(themedContext.l10n.galleryDebugEmptyTrash),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          key: const Key('btn_test_save_annotate'),
                          onPressed: () async {
                            const filePath = '/sdcard/Documents/sample_100p.pdf';
                            debugPrint('[KILL_TEST] Starting save annotate at ${DateTime.now().toIso8601String()}');
                            try {
                              await const PdfAnnotationService().saveAnnotations(
                                sourcePath: filePath,
                                outputPath: filePath,
                                replaceOriginal: true,
                                markups: [
                                  TextMarkup(
                                    id: 'm1',
                                    pageIndex: 0,
                                    type: TextMarkupType.highlight,
                                    colorValue: AnnotateColors.yellow.toARGB32(),
                                    lineRects: [const Rect.fromLTWH(50, 100, 200, 20)],
                                    text: 'Sample Marked Text',
                                    createdAtMs: DateTime.now().millisecondsSinceEpoch,
                                  ),
                                ],
                              );
                              debugPrint('[KILL_TEST] Finished save annotate at ${DateTime.now().toIso8601String()}');
                            } catch (e) {
                              debugPrint('[KILL_TEST] Save annotate error: $e');
                            }
                          },
                          icon: const Icon(Icons.highlight),
                          label: Text(themedContext.l10n.galleryDebugSaveAnnotate),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.amber.shade800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          key: const Key('btn_test_save_sign'),
                          onPressed: () async {
                            const filePath = '/sdcard/Documents/sample_100p.pdf';
                            debugPrint('[KILL_TEST] Starting save sign at ${DateTime.now().toIso8601String()}');
                            try {
                              await const PdfAnnotationService().saveAnnotations(
                                sourcePath: filePath,
                                outputPath: filePath,
                                replaceOriginal: true,
                                signatures: [
                                  PlacedSignature(
                                    id: 's1',
                                    pageIndex: 0,
                                    bounds: const Rect.fromLTWH(100, 200, 150, 50),
                                    timestampMs: DateTime.now().millisecondsSinceEpoch,
                                  ),
                                ],
                              );
                              debugPrint('[KILL_TEST] Finished save sign at ${DateTime.now().toIso8601String()}');
                            } catch (e) {
                              debugPrint('[KILL_TEST] Save sign error: $e');
                            }
                          },
                          icon: const Icon(Icons.draw),
                          label: Text(themedContext.l10n.galleryDebugSaveSign),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          key: const Key('btn_test_save_text'),
                          onPressed: () async {
                            const filePath = '/sdcard/Documents/sample_100p.pdf';
                            debugPrint('[KILL_TEST] Starting save text at ${DateTime.now().toIso8601String()}');
                            try {
                              await const PdfAnnotationService().saveAnnotations(
                                sourcePath: filePath,
                                outputPath: filePath,
                                replaceOriginal: true,
                                textBoxes: [
                                  PdfTextBox(
                                    id: 't1',
                                    pageIndex: 0,
                                    bounds: const Rect.fromLTWH(100, 300, 200, 40),
                                    text: 'Sample Add Text Annotation',
                                    fontSize: 14,
                                    lines: [
                                      PdfTextLine(
                                        text: 'Sample Add Text Annotation',
                                        dx: 0,
                                        dy: 0,
                                        width: 200,
                                        height: 18,
                                        baseline: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                              debugPrint('[KILL_TEST] Finished save text at ${DateTime.now().toIso8601String()}');
                            } catch (e) {
                              debugPrint('[KILL_TEST] Save text error: $e');
                            }
                          },
                          icon: const Icon(Icons.text_fields),
                          label: Text(themedContext.l10n.galleryDebugSaveText),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // --- Section 14: PDF Annotation (G5a) ---
                  const SectionHeader(title: '14. PDF Annotation Components (G5a)'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SelectionMenu(
                          onCopy: () {},
                          onHighlight: () {},
                          onUnderline: () {},
                          onStrikethrough: () {},
                        ),
                        const SizedBox(height: 12),
                        AnnotateToolbar(
                          selectedTool: TextMarkupType.highlight,
                          selectedColor: AnnotateColors.yellow,
                          onToolSelected: (_) {},
                          onColorSelected: (_) {},
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  ],

                  // --- Section 15: IAP & Premium Simulator (G7) ---
                  SectionHeader(title: themedContext.l10n.galleryDebugIapSectionTitle),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final controller = ref.watch(premiumControllerProvider);
                        final asyncState = ref.watch(premiumStateStreamProvider);
                        final pState = asyncState.asData?.value ?? controller.state;
                        final statusLabel = pState.isPremium
                            ? (pState.isGracePeriod ? 'Grace Active' : 'Premium Active')
                            : 'Free (Unsubscribed)';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: tokens.surfaceAlt,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: tokens.hairline),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    AppIcons.crown,
                                    color: pState.isPremium
                                        ? tokens.premiumGold
                                        : tokens.textSecondary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '$statusLabel (${pState.activeProductId ?? "none"})',
                                      style: DocViewTypography.bodyMd.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: tokens.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                FilledButton.tonal(
                                  key: const Key('gallery_set_free'),
                                  onPressed: () {
                                    controller.setSimulatedState(
                                      isPremium: false,
                                      isGracePeriod: false,
                                      activeProductId: null,
                                    );
                                  },
                                  child: Text(themedContext.l10n.galleryDebugIapStateFree),
                                ),
                                FilledButton.tonal(
                                  key: const Key('gallery_set_yearly'),
                                  onPressed: () {
                                    controller.setSimulatedState(
                                      isPremium: true,
                                      isGracePeriod: false,
                                      activeProductId: IapConfig.subscriptionProductId,
                                      activeBasePlanId: IapConfig.yearlyBasePlanId,
                                      verifiedAt: DateTime.now(),
                                    );
                                  },
                                  child: Text(themedContext.l10n.galleryDebugIapStateYearly),
                                ),
                                FilledButton.tonal(
                                  key: const Key('gallery_set_monthly'),
                                  onPressed: () {
                                    controller.setSimulatedState(
                                      isPremium: true,
                                      isGracePeriod: false,
                                      activeProductId: IapConfig.subscriptionProductId,
                                      activeBasePlanId: IapConfig.monthlyBasePlanId,
                                      verifiedAt: DateTime.now(),
                                    );
                                  },
                                  child: Text(themedContext.l10n.galleryDebugIapStateMonthly),
                                ),
                                FilledButton.tonal(
                                  key: const Key('gallery_set_grace'),
                                  onPressed: () {
                                    controller.setSimulatedState(
                                      isPremium: true,
                                      isGracePeriod: true,
                                      activeProductId: IapConfig.subscriptionProductId,
                                      activeBasePlanId: IapConfig.yearlyBasePlanId,
                                      verifiedAt: DateTime.now().subtract(const Duration(days: 3)),
                                    );
                                  },
                                  child: Text(themedContext.l10n.galleryDebugIapStateGrace),
                                ),
                                FilledButton.tonal(
                                  key: const Key('gallery_set_expired'),
                                  onPressed: () {
                                    controller.setSimulatedState(
                                      isPremium: false,
                                      isGracePeriod: false,
                                      activeProductId: IapConfig.subscriptionProductId,
                                      activeBasePlanId: IapConfig.yearlyBasePlanId,
                                      verifiedAt: DateTime.now().subtract(const Duration(days: 8)),
                                    );
                                  },
                                  child: Text(themedContext.l10n.galleryDebugIapStateGraceExpired),
                                ),
                                FilledButton.tonal(
                                  key: const Key('gallery_set_product_seen_true'),
                                  onPressed: () {
                                    controller.setSimulatedState(
                                      isPremium: pState.isPremium,
                                      isGracePeriod: pState.isGracePeriod,
                                      activeProductId: pState.activeProductId,
                                      activeBasePlanId: pState.activeBasePlanId,
                                      iapProductSeen: true,
                                    );
                                  },
                                  child: Text(themedContext.l10n.galleryDebugIapProductSeenTrue),
                                ),
                                FilledButton.tonal(
                                  key: const Key('gallery_set_product_seen_false'),
                                  onPressed: () {
                                    controller.setSimulatedState(
                                      isPremium: pState.isPremium,
                                      isGracePeriod: pState.isGracePeriod,
                                      activeProductId: pState.activeProductId,
                                      activeBasePlanId: pState.activeBasePlanId,
                                      iapProductSeen: false,
                                    );
                                  },
                                  child: Text(themedContext.l10n.galleryDebugIapProductSeenFalse),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              key: const Key('gallery_open_premium_screen'),
                              onPressed: () => context.push('/premium'),
                              icon: const Icon(AppIcons.crown),
                              label: Text(themedContext.l10n.galleryDebugOpenPremium),
                              style: FilledButton.styleFrom(
                                backgroundColor: tokens.premiumGold,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ),

                  // --- Section 16: Native App Widgets & Notification (G8) ---
                  const SectionHeader(title: '16. Native App Widgets & Notification (G8)'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton.icon(
                          key: const Key('gallery_open_add_widget_sheet'),
                          onPressed: () => AddWidgetBottomSheet.show(themedContext),
                          icon: const Icon(Icons.widgets_outlined),
                          label: const Text('Open Add Widget Sheet'),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.tonal(
                          key: const Key('gallery_open_settings_widgets'),
                          onPressed: () => context.push('/settings-widgets'),
                          child: const Text('Open Settings (Widgets Enabled)'),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.tonal(
                          key: const Key('gallery_toggle_quick_access_notif'),
                          onPressed: () async {
                            final service = ref.read(quickAccessNotificationServiceProvider);
                            final enabled = await service.isEnabled();
                            await service.setEnabled(!enabled);
                          },
                          child: const Text('Toggle Quick Access Notification'),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '17. Google Mobile Ads & UMP Consent (G9)',
                          style: DocViewTypography.headlineSm,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Simulate consent states, UMP dialogs, and AdMob integration.',
                          style: DocViewTypography.bodyMd,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton.tonal(
                              key: const Key('gallery_geo_eea'),
                              onPressed: () {
                                setState(() => _debugGeography = DebugGeography.debugGeographyEea);
                                ref.read(consentGatewayProvider).requestConsentInfoUpdate(debugGeography: _debugGeography);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Debug Geography set to EEA & update requested')),
                                );
                              },
                              child: const Text('Set EEA Geography'),
                            ),
                            FilledButton.tonal(
                              key: const Key('gallery_geo_other'),
                              onPressed: () {
                                setState(() => _debugGeography = DebugGeography.debugGeographyOther);
                                ref.read(consentGatewayProvider).requestConsentInfoUpdate(debugGeography: _debugGeography);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Debug Geography set to Other & update requested')),
                                );
                              },
                              child: const Text('Set Non-EEA Geography'),
                            ),
                            FilledButton.tonal(
                              key: const Key('gallery_geo_disabled'),
                              onPressed: () {
                                setState(() => _debugGeography = DebugGeography.debugGeographyDisabled);
                                ref.read(consentGatewayProvider).requestConsentInfoUpdate(debugGeography: _debugGeography);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Debug Geography disabled & update requested')),
                                );
                              },
                              child: const Text('Disable Debug Geography'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton(
                              key: const Key('gallery_request_consent_update'),
                              onPressed: () async {
                                final gateway = ref.read(consentGatewayProvider);
                                await gateway.requestConsentInfoUpdate(debugGeography: _debugGeography);
                                final canRequest = await gateway.canRequestAds();
                                final privacyReq = await gateway.isPrivacyOptionsRequired();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('canRequestAds: $canRequest, privacyOptionsRequired: $privacyReq')),
                                  );
                                }
                              },
                              child: const Text('Request Consent Info'),
                            ),
                            FilledButton(
                              key: const Key('gallery_show_consent_form'),
                              onPressed: () async {
                                final gateway = ref.read(consentGatewayProvider);
                                final shown = await gateway.showConsentFormIfRequired();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Consent form shown / completed: $shown')),
                                  );
                                }
                              },
                              child: const Text('Show Consent Form'),
                            ),
                            FilledButton(
                              key: const Key('gallery_show_privacy_options'),
                              onPressed: () async {
                                final gateway = ref.read(consentGatewayProvider);
                                await gateway.showPrivacyOptionsForm();
                              },
                              child: const Text('Show Privacy Options Form'),
                            ),
                            FilledButton.tonal(
                              key: const Key('gallery_reset_consent'),
                              onPressed: () async {
                                final gateway = ref.read(consentGatewayProvider);
                                await gateway.reset();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Consent state reset')),
                                  );
                                }
                              },
                              child: const Text('Reset Consent'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          key: const Key('gallery_simulate_interstitial'),
                          onPressed: () async {
                            await InterstitialPlaceholder.show(context, ref: ref);
                          },
                          icon: const Icon(Icons.fullscreen),
                          label: const Text('Simulate Interstitial Ad'),
                        ),
                        const SizedBox(height: 16),
                        const Text('Native Ad Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const NativeAdRow(),
                        const SizedBox(height: 16),
                        const Text('Adaptive Banner Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const AdBannerSlot(),
                        const SizedBox(height: 24),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ],
            ),
              bottomNavigationBar: DocBottomNavBar(
                currentIndex: _selectedNavTab,
                onTap: (i) => setState(() => _selectedNavTab = i),
              ),
            );
          },
        ),
      ),
    ),
  ),
);
  }
}

