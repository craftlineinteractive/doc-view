import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/file_types.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../../shared/widgets/buttons/doc_buttons.dart';
import '../../../shared/widgets/tiles/doc_folded_icon.dart';
import '../../files/open_document.dart';

/// Modal bottom sheet presented upon successful PDF creation, merge, or split.
/// Conforms to Prompt R-E specifications with single and multi-file variants.
class ToolResultSheet extends ConsumerWidget {
  final List<DocFile> files;
  final VoidCallback? onDone;

  const ToolResultSheet({
    super.key,
    required this.files,
    this.onDone,
  });

  /// Displays the modal bottom sheet for [files].
  static Future<void> show(
    BuildContext context, {
    required List<DocFile> files,
    VoidCallback? onDone,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => ToolResultSheet(
        files: files,
        onDone: onDone,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isMultiple = files.length > 1;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surfaceAlt,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: tokens.hairline, width: 1)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.paddingOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: tokens.hairline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Success Header
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFF1FA971),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMultiple
                          ? '${files.length} PDFs Created'
                          : 'PDF Created',
                      style: DocViewTypography.headlineSm.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: tokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Saved to your Created folder',
                      style: DocViewTypography.bodySm.copyWith(
                        color: tokens.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // File Preview Card(s)
          if (!isMultiple && files.isNotEmpty)
            _SingleFilePreviewCard(file: files.first)
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: files.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return _SingleFilePreviewCard(
                    file: files[index],
                    compact: true,
                  );
                },
              ),
            ),

          const SizedBox(height: 24),

          // Actions
          if (!isMultiple && files.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: DocPrimaryButton(
                    label: 'Open',
                    icon: const Icon(Icons.visibility_outlined, size: 20, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                      openDocument(context, ref, files.first);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DocSecondaryButton(
                    label: 'Share',
                    icon: Icon(Icons.share_outlined, size: 20, color: tokens.textPrimary),
                    onPressed: () {
                      final xFiles = [XFile(files.first.path)];
                      SharePlus.instance.share(ShareParams(files: xFiles));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DocSecondaryButton(
              label: 'Done',
              onPressed: () {
                Navigator.of(context).pop();
                onDone?.call();
              },
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DocSecondaryButton(
                    label: 'Share All',
                    icon: Icon(Icons.share_outlined, size: 20, color: tokens.textPrimary),
                    onPressed: () {
                      final xFiles = files.map((f) => XFile(f.path)).toList();
                      SharePlus.instance.share(ShareParams(files: xFiles));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DocPrimaryButton(
                    label: 'Done',
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDone?.call();
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SingleFilePreviewCard extends StatelessWidget {
  final DocFile file;
  final bool compact;

  const _SingleFilePreviewCard({
    required this.file,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final sizeStr = FormatUtils.formatFileSize(file.sizeBytes);
    final dateStr = FormatUtils.formatDate(file.modified);

    return Container(
      padding: EdgeInsets.all(compact ? 12 : 14),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.hairline, width: 1),
      ),
      child: Row(
        children: [
          const DocFoldedIcon(
            category: FileCategory.pdf,
            width: 36,
            height: 42,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DocViewTypography.titleMd.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$sizeStr • $dateStr',
                  style: DocViewTypography.bodySm.copyWith(
                    color: tokens.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
