import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../shared/widgets/buttons/doc_icon_button.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';
import 'image_list_editor_screen.dart';
import 'merge_screen.dart';
import 'split_screen.dart';
import 'widgets/created_by_you_section.dart';
import 'widgets/merge_pdf_picker_screen.dart';
import 'widgets/split_picker_screen.dart';
import 'widgets/tool_card.dart';

/// Tools hub organizing PDF creation and editing features in a clean,
/// accessible layout with strictly 4 tools and a "Created by you" section.
class ToolsScreen extends ConsumerWidget {
  const ToolsScreen({super.key});

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
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Document scanning cancelled or failed: $e')),
        );
      }
    }
  }

  Future<void> _onMergePdf(BuildContext context) async {
    final picked = await MergePdfPickerScreen.pick(
      context,
      title: 'Select PDFs',
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlineColor = isDark ? tokens.interactiveBlue : tokens.primaryBlue;
    final sectionColor = isDark ? tokens.sectionHeader : const Color(0xFF5A6275);

    return DocScaffold(
      applyHeaderGradient: true,
      showDockedBanner: true,
      isAdLoaded: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'WORKSPACE',
                      style: DocViewTypography.captionXs.copyWith(
                        color: overlineColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tools',
                      style: DocViewTypography.headlineLg.copyWith(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ],
                ),
                DocIconButton(
                  icon: AppIcons.search,
                  tooltip: 'Search documents',
                  onPressed: () => context.push('/search'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Convert & Create
            Text(
              'CONVERT & CREATE',
              style: DocViewTypography.captionXs.copyWith(
                color: sectionColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ToolCard(
                    key: const Key('tool_image_to_pdf'),
                    title: 'Image to PDF',
                    subtitle: 'Turn photos into one PDF',
                    icon: Icons.image_rounded,
                    gradientColors: const [
                      Color(0xFFFFB300),
                      Color(0xFFE02B2B),
                    ],
                    onTap: () => _onImageToPdf(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ToolCard(
                    key: const Key('tool_scan_to_pdf'),
                    title: 'Scan to PDF',
                    subtitle: 'Scan paper with camera',
                    icon: Icons.document_scanner_rounded,
                    gradientColors: const [
                      Color(0xFF00BCD4),
                      Color(0xFF009688),
                    ],
                    onTap: () => _onScanToPdf(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section 2: Edit & Manage
            Text(
              'EDIT & MANAGE',
              style: DocViewTypography.captionXs.copyWith(
                color: sectionColor,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ToolCard(
                    key: const Key('tool_merge_pdf'),
                    title: 'Merge PDF',
                    subtitle: 'Combine PDFs into one',
                    icon: Icons.call_merge_rounded,
                    gradientColors: const [
                      Color(0xFF2979FF),
                      Color(0xFF1565C0),
                    ],
                    onTap: () => _onMergePdf(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ToolCard(
                    key: const Key('tool_split_pdf'),
                    title: 'Split PDF',
                    subtitle: 'Extract pages or ranges',
                    icon: Icons.call_split_rounded,
                    gradientColors: const [
                      Color(0xFF1E9E4F),
                      Color(0xFF0E622F),
                    ],
                    onTap: () => _onSplitPdf(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Section 3: Created by you
            CreatedByYouSection(
              onSeeAll: () => context.push('/tools/created'),
            ),
          ],
        ),
      ),
    );
  }
}
