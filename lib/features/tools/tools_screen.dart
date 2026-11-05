import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'image_list_editor_screen.dart';
import 'merge_screen.dart';
import 'split_screen.dart';
import 'widgets/library_pdf_picker_screen.dart';

/// Tools hub organizing PDF creation and editing features in a clean, accessible 4-column grid.
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
    final picked = await LibraryPdfPickerScreen.pick(
      context,
      multiSelect: true,
      title: 'Select PDFs to Merge',
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
    final picked = await LibraryPdfPickerScreen.pick(
      context,
      multiSelect: false,
      title: 'Select PDF to Split',
    );

    if (picked != null && picked.isNotEmpty && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SplitScreen(file: picked.first),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final childAspectRatio =
        textScale > 1.4 ? 0.60 : (textScale > 1.1 ? 0.72 : 0.88);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Convert & Create
            _SectionHeader(
              title: 'Convert & Create',
              subtitle: 'Generate standard PDF documents from images or scans',
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: childAspectRatio,
              children: [
                _ToolTile(
                  key: const Key('tool_image_to_pdf'),
                  label: 'Image to PDF',
                  icon: Icons.image_rounded,
                  color: const Color(0xFFF57C00),
                  onTap: () => _onImageToPdf(context),
                ),
                _ToolTile(
                  key: const Key('tool_scan_to_pdf'),
                  label: 'Scan to PDF',
                  icon: Icons.document_scanner_rounded,
                  color: const Color(0xFF00897B),
                  onTap: () => _onScanToPdf(context),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Section 2: Edit & Manage
            _SectionHeader(
              title: 'Edit & Manage',
              subtitle: 'Reorganize, combine, and divide existing PDF documents',
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: childAspectRatio,
              children: [
                _ToolTile(
                  key: const Key('tool_merge_pdf'),
                  label: 'Merge PDF',
                  icon: Icons.call_merge_rounded,
                  color: const Color(0xFF1E88E5),
                  onTap: () => _onMergePdf(context),
                ),
                _ToolTile(
                  key: const Key('tool_split_pdf'),
                  label: 'Split PDF',
                  icon: Icons.call_split_rounded,
                  color: const Color(0xFF8E24AA),
                  onTap: () => _onSplitPdf(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
