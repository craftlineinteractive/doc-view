import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../files/open_document.dart';

/// Shared bottom sheet displaying created PDF results with Open, Share, and Done actions.
class ToolResultBottomSheet extends ConsumerWidget {
  const ToolResultBottomSheet({
    required this.files,
    this.onDone,
    super.key,
  });

  /// The list of created [DocFile] records.
  final List<DocFile> files;

  /// Optional callback invoked when the user taps Done.
  final VoidCallback? onDone;

  /// Shows the modal bottom sheet for [files].
  static Future<void> show(
    BuildContext context, {
    required List<DocFile> files,
    VoidCallback? onDone,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ToolResultBottomSheet(
        files: files,
        onDone: onDone,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isMultiple = files.length > 1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
                  color: theme.dividerColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header with success icon and title
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isMultiple
                            ? '${files.length} PDFs Created'
                            : 'PDF Created Successfully',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isMultiple
                            ? 'Saved to Created folder'
                            : FormatUtils.formatFileSize(files.first.sizeBytes),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // File list
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: files.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final file = files[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: Colors.redAccent,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      FormatUtils.formatFileSize(file.sizeBytes),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                    trailing: isMultiple
                        ? IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded,
                                size: 16),
                            tooltip: 'Open',
                            onPressed: () {
                              Navigator.of(context).pop();
                              openDocument(context, ref, file);
                            },
                          )
                        : null,
                    onTap: () {
                      Navigator.of(context).pop();
                      openDocument(context, ref, file);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                // Open button
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.visibility_rounded, size: 20),
                    label: Text(isMultiple ? 'Open First' : 'Open'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      openDocument(context, ref, files.first);
                    },
                  ),
                ),
                const SizedBox(width: 10),

                // Share button
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.share_rounded, size: 20),
                    label: const Text('Share'),
                    onPressed: () {
                      final xFiles =
                          files.map((f) => XFile(f.path)).toList();
                      SharePlus.instance.share(ShareParams(files: xFiles));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Done button
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
                onDone?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}

