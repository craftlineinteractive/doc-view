import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/app_errors.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../data/services/billing/billing_providers.dart';
import '../../shared/widgets/buttons/doc_icon_button.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';
import '../providers/providers.dart';
import 'image_list_editor_screen.dart';
import 'merge_screen.dart';
import 'services/print_pdf_service.dart';
import 'split_screen.dart';
import 'tool_registry.dart';
import 'widgets/created_by_you_section.dart';
import 'widgets/merge_pdf_picker_screen.dart';
import 'widgets/split_picker_screen.dart';
import 'widgets/tool_file_picker_screen.dart';
import 'widgets/tool_grid_tile.dart';

/// Tools tab organizing PDF creation, manipulation, management, and auxiliary
/// tools in a reference-density 4-column responsive grid with localized headers.
class ToolsScreen extends ConsumerWidget {
  const ToolsScreen({super.key});

  int _calculateColumnCount(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final textScale = mediaQuery.textScaler.scale(1.0);
    if (textScale >= 2.0) {
      return 2;
    } else if (textScale > 1.3 || width < 340) {
      return 3;
    }
    return 4;
  }

  Future<void> _onImageToPdf(BuildContext context) async {
    final pickedFiles = await FilePicker.pickFiles(
      type: FileType.image,
    );

    if (pickedFiles.isNotEmpty && context.mounted) {
      final paths = pickedFiles
          .map((f) => f.path)
          .whereType<String>()
          .where((p) => p.isNotEmpty)
          .toList();
      if (paths.isNotEmpty) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImageListEditorScreen(
              initialImagePaths: paths,
              defaultNamePrefix: 'Images',
              isScannerSource: false,
            ),
          ),
        );
      }
    }
  }

  Future<void> _onScanToPdf(BuildContext context) async {
    try {
      // ignore: deprecated_member_use
      final scans = await CunningDocumentScanner.getPictures();
      if (scans != null && scans.isNotEmpty && context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImageListEditorScreen(
              initialImagePaths: scans,
              defaultNamePrefix: 'Scan',
              isScannerSource: true,
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.importFailedError)),
        );
      }
    }
  }

  Future<void> _onAnnotate(BuildContext context) async {
    final picked = await ToolFilePickerScreen.pickSingle(
      context,
      title: context.l10n.toolAnnotate,
    );

    if (picked != null && context.mounted) {
      context.push(
        '/tools/annotate',
        extra: {'filePath': picked.path},
      );
    }
  }

  Future<void> _onManagePages(BuildContext context) async {
    final picked = await ToolFilePickerScreen.pickSingle(
      context,
      title: context.l10n.toolPickerTitleSelectPdf,
      actionLabel: context.l10n.toolPickerActionManage,
    );

    if (picked != null && context.mounted) {
      context.push(
        '/pdf-pages',
        extra: picked,
      );
    }
  }

  Future<void> _onMergePdf(BuildContext context) async {
    final picked = await MergePdfPickerScreen.pick(
      context,
      title: context.l10n.toolPickerTitleSelectPdfs,
      minSelection: 2,
    );

    if (picked != null && picked.length >= 2 && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MergeScreen(initialFiles: picked),
        ),
      );
    }
  }

  Future<void> _onSplitPdf(BuildContext context) async {
    final picked = await SplitPickerScreen.pick(context);

    if (picked != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SplitScreen(file: picked),
        ),
      );
    }
  }

  Future<void> _onImportFiles(BuildContext context, WidgetRef ref) async {
    try {
      final count = await ref.read(importServiceProvider).importFiles();
      ref.invalidate(categoryCountsProvider);
      ref.invalidate(filesProvider);

      if (count > 0 && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.filesImportedSuccess(count)),
            action: SnackBarAction(
              label: context.l10n.toolsImportActionView,
              onPressed: () {
                if (context.mounted) {
                  context.go('/home');
                }
              },
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.importFailedError)),
        );
      }
    }
  }

  Future<void> _onPrintPdf(BuildContext context) async {
    final picked = await ToolFilePickerScreen.pickSingle(
      context,
      title: context.l10n.toolPickerTitleSelectPdf,
      actionLabel: context.l10n.toolPickerActionPrint,
    );

    if (picked != null && context.mounted) {
      try {
        const printService = PrintPdfService();
        await printService.printDocument(picked);
      } on PrintPdfException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.reason.localizedMessage(context))),
          );
        }
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.printPdfErrorFailed)),
          );
        }
      }
    }
  }

  void _handleToolTap(BuildContext context, WidgetRef ref, ToolDef tool) {
    final locksActive = ref.read(locksActiveProvider);
    final isPremium = ref.read(isPremiumProvider);
    if (tool.id != 'manage_pages' && tool.isPremium() && (locksActive && !isPremium)) {
      context.push('/premium');
      return;
    }

    switch (tool.id) {
      case 'image_to_pdf':
        _onImageToPdf(context);
        break;
      case 'scan_to_pdf':
        _onScanToPdf(context);
        break;
      case 'annotate':
        _onAnnotate(context);
        break;
      case 'manage_pages':
        _onManagePages(context);
        break;
      case 'merge_pdf':
        _onMergePdf(context);
        break;
      case 'split_pdf':
        _onSplitPdf(context);
        break;
      case 'import_files':
        _onImportFiles(context, ref);
        break;
      case 'print_pdf':
        _onPrintPdf(context);
        break;
      default:
        if (tool.route != null) {
          context.push(tool.route!);
        }
        break;
    }
  }

  Widget _buildSectionGrid(
    BuildContext context,
    WidgetRef ref,
    List<ToolDef> tools,
    int columnCount,
  ) {
    if (tools.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSpacing = (columnCount - 1) * 8.0;
        final itemWidth = (constraints.maxWidth - totalSpacing) / columnCount;

        return Wrap(
          spacing: 8,
          runSpacing: 12,
          children: tools.map((tool) {
            return SizedBox(
              width: itemWidth,
              child: ToolGridTile(
                key: Key('tool_${tool.id}'),
                tool: tool,
                onTap: () => _handleToolTap(context, ref, tool),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlineColor = isDark ? tokens.interactiveBlue : tokens.primaryBlue;
    final sectionColor = isDark ? tokens.sectionHeader : const Color(0xFF5A6275);
    final columnCount = _calculateColumnCount(context);

    final convertTools = getToolsForSection(ToolSection.convertAndCreate);
    final editTools = getToolsForSection(ToolSection.editAndManage);
    final otherTools = getToolsForSection(ToolSection.others);
    final isPremium = ref.watch(isPremiumProvider);
    final locksActive = ref.watch(locksActiveProvider);

    return DocScaffold(
      applyHeaderGradient: true,
      showDockedBanner: true,
      isAdLoaded: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        toolbarHeight: (kToolbarHeight * MediaQuery.textScalerOf(context).scale(1.0)).clamp(56.0, 96.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.toolsWorkspaceOverline,
              style: DocViewTypography.captionXs.copyWith(
                color: overlineColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              context.l10n.toolsTitle,
              style: DocViewTypography.headlineLg.copyWith(
                fontFamily: 'SpaceGrotesk',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: tokens.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          if (locksActive && !isPremium)
            DocIconButton(
              key: const Key('tools_crown_button'),
              icon: AppIcons.crown,
              color: tokens.premiumGold,
              tooltip: context.l10n.premiumTooltip,
              onPressed: () => context.push('/premium'),
            ),
          DocIconButton(
            icon: AppIcons.search,
            tooltip: context.l10n.tooltipSearch,
            onPressed: () => context.push('/search'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Convert & Create
            if (convertTools.isNotEmpty) ...[
              Text(
                getSectionHeaderTitle(ToolSection.convertAndCreate, context.l10n),
                style: DocViewTypography.captionXs.copyWith(
                  color: sectionColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              _buildSectionGrid(context, ref, convertTools, columnCount),
              const SizedBox(height: 24),
            ],

            // Section 2: Edit & Manage
            if (editTools.isNotEmpty) ...[
              Text(
                getSectionHeaderTitle(ToolSection.editAndManage, context.l10n),
                style: DocViewTypography.captionXs.copyWith(
                  color: sectionColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              _buildSectionGrid(context, ref, editTools, columnCount),
              const SizedBox(height: 24),
            ],

            // Section 3: Others
            if (otherTools.isNotEmpty) ...[
              Text(
                getSectionHeaderTitle(ToolSection.others, context.l10n),
                style: DocViewTypography.captionXs.copyWith(
                  color: sectionColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              _buildSectionGrid(context, ref, otherTools, columnCount),
              const SizedBox(height: 28),
            ],

            // Section 4: Created by you
            CreatedByYouSection(
              onSeeAll: () => context.push('/tools/created'),
            ),
          ],
        ),
      ),
    );
  }
}
