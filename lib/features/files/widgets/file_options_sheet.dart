import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

import '../../../core/constants/file_types.dart';
import '../../../core/utils/file_name_utils.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../../data/services/file_operations_service.dart';
import '../../providers/providers.dart';
import '../open_document.dart';

/// Bottom sheet presenting contextual options for a single [DocFile].
class FileOptionsSheet extends ConsumerWidget {
  const FileOptionsSheet({
    required this.file,
    this.parentContext,
    super.key,
  });

  final DocFile file;
  final BuildContext? parentContext;

  /// Convenience method to show the file options bottom sheet.
  static Future<void> show(BuildContext context, DocFile file) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => FileOptionsSheet(
        file: file,
        parentContext: context,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final targetContext = parentContext ?? context;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header tile displaying file icon and metadata
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: file.category == FileCategory.image
                        ? SizedBox(
                            width: 48,
                            height: 48,
                            child: Image.file(
                              File(file.path),
                              width: 48,
                              height: 48,
                              cacheWidth: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _buildCategoryIconContainer(file),
                            ),
                          )
                        : _buildCategoryIconContainer(file),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          FormatUtils.formatSubtitle(file.modified, file.sizeBytes),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 16),

            // Action: Open
            _ActionTile(
              icon: Icons.visibility_outlined,
              label: 'Open',
              onTap: () {
                Navigator.of(context).pop();
                openDocument(targetContext, ref, file);
              },
            ),

            // Action: Share
            _ActionTile(
              icon: Icons.share_outlined,
              label: 'Share',
              onTap: () {
                final actionsController = ref.read(fileActionsControllerProvider);
                Navigator.of(context).pop();
                actionsController.shareFiles([file]);
              },
            ),

            // Action: Rename
            _ActionTile(
              icon: Icons.drive_file_rename_outline,
              label: 'Rename',
              onTap: () {
                Navigator.of(context).pop();
                _showRenameDialog(targetContext, file);
              },
            ),

            // Action: Bookmark toggle
            _ActionTile(
              icon: file.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              iconColor: file.isBookmarked ? colorScheme.primary : null,
              label: file.isBookmarked ? 'Remove bookmark' : 'Bookmark',
              onTap: () {
                final actionsController = ref.read(fileActionsControllerProvider);
                Navigator.of(context).pop();
                actionsController.toggleBookmark(file);
              },
            ),

            // Action: Open in another app
            _ActionTile(
              icon: Icons.launch_outlined,
              label: 'Open in another app',
              onTap: () async {
                Navigator.of(context).pop();
                final result = await OpenFilex.open(file.path);
                if (result.type != ResultType.done && targetContext.mounted) {
                  ScaffoldMessenger.of(targetContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        result.message.isNotEmpty
                            ? result.message
                            : 'Could not open in external application',
                      ),
                    ),
                  );
                }
              },
            ),

            // Action: Details
            _ActionTile(
              icon: Icons.info_outline,
              label: 'Details',
              onTap: () {
                Navigator.of(context).pop();
                _showDetailsSheet(targetContext, file);
              },
            ),

            // Action: Delete
            _ActionTile(
              icon: Icons.delete_outline,
              label: 'Delete',
              textColor: colorScheme.error,
              iconColor: colorScheme.error,
              onTap: () {
                Navigator.of(context).pop();
                _showDeleteConfirmDialog(targetContext, file);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIconContainer(DocFile file) {
    final color = file.category.color;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Icon(
        file.category.icon,
        color: color,
        size: 24,
      ),
    );
  }

  static void _showRenameDialog(
    BuildContext parentContext,
    DocFile file,
  ) {
    final messenger = ScaffoldMessenger.of(parentContext);
    final errorColor = Theme.of(parentContext).colorScheme.error;
    final ext = p.extension(file.path);
    var baseName = file.name;
    if (ext.isNotEmpty && baseName.toLowerCase().endsWith(ext.toLowerCase())) {
      baseName = baseName.substring(0, baseName.length - ext.length);
    }

    final controller = TextEditingController(text: baseName);
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: baseName.length,
    );

    showDialog<void>(
      context: parentContext,
      builder: (dialogContext) {
        String? errorMessage;

        return Consumer(
          builder: (consumerContext, ref, _) {
            return StatefulBuilder(
              builder: (stateContext, setState) {
                final currentText = controller.text.trim();
                final isValid = errorMessage == null &&
                    currentText.isNotEmpty &&
                    currentText != baseName;

                return AlertDialog(
                  title: const Text('Rename file'),
                  content: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'File name',
                      suffixText: ext.isNotEmpty ? ext : null,
                      errorText: errorMessage,
                    ),
                    onChanged: (value) {
                      setState(() {
                        errorMessage = validateFileName(value);
                      });
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: isValid
                          ? () async {
                              final newBaseName = controller.text.trim();
                              final actionsController =
                                  ref.read(fileActionsControllerProvider);
                              Navigator.of(dialogContext).pop();
                              final result = await actionsController
                                  .renameFile(file, newBaseName);

                              if (result is RenameSuccess) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Renamed to ${result.updatedFile.name}'),
                                  ),
                                );
                              } else if (result is RenameFailure) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(result.errorMessage),
                                    backgroundColor: errorColor,
                                  ),
                                );
                              }
                            }
                          : null,
                      child: const Text('Rename'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  static void _showDeleteConfirmDialog(
    BuildContext parentContext,
    DocFile file,
  ) {
    final messenger = ScaffoldMessenger.of(parentContext);
    final errorColor = Theme.of(parentContext).colorScheme.error;

    showDialog<void>(
      context: parentContext,
      builder: (dialogContext) {
        return Consumer(
          builder: (consumerContext, ref, _) {
            return AlertDialog(
              title: const Text('Delete file?'),
              content: Text('Delete "${file.name}"? This can\'t be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(parentContext).colorScheme.error,
                    foregroundColor: Theme.of(parentContext).colorScheme.onError,
                  ),
                  onPressed: () async {
                    final actionsController =
                        ref.read(fileActionsControllerProvider);
                    Navigator.of(dialogContext).pop();
                    final result = await actionsController.deleteFiles([file]);

                    if (result.hasDeletions) {
                      messenger.showSnackBar(
                        SnackBar(content: Text('Deleted "${file.name}"')),
                      );
                    } else {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            result.errorMessage ?? 'Failed to delete file',
                          ),
                          backgroundColor: errorColor,
                        ),
                      );
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void _showDetailsSheet(BuildContext parentContext, DocFile file) {
    final theme = Theme.of(parentContext);

    showModalBottomSheet<void>(
      context: parentContext,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'File Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _DetailRow(label: 'Name', value: file.name),
                _DetailRow(
                  label: 'Type',
                  value: '${file.category.label} (${file.extension.toUpperCase()})',
                ),
                _DetailRow(
                  label: 'Size',
                  value: '${FormatUtils.formatFileSize(file.sizeBytes)} (${file.sizeBytes} bytes)',
                ),
                _DetailRow(
                  label: 'Modified',
                  value: '${FormatUtils.formatDate(file.modified)} ${file.modified.hour.toString().padLeft(2, '0')}:${file.modified.minute.toString().padLeft(2, '0')}',
                ),
                _DetailRow(
                  label: 'Bookmarked',
                  value: file.isBookmarked ? 'Yes' : 'No',
                ),
                const SizedBox(height: 8),
                Text(
                  'Path',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        file.path,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      tooltip: 'Copy path',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: file.path));
                        ScaffoldMessenger.of(sheetContext).showSnackBar(
                          const SnackBar(content: Text('Path copied to clipboard')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: iconColor ?? theme.iconTheme.color?.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
