import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

import '../../../core/config/feature_flags.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/file_types.dart';
import '../../../core/errors/app_errors.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/utils/file_name_utils.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../../data/services/file_operations_service.dart';
import '../../providers/providers.dart';
import 'file_details_sheet.dart';
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
              label: context.l10n.actionOpen,
              onTap: () {
                Navigator.of(context).pop();
                openDocument(targetContext, ref, file);
              },
            ),

            // Action: Share
            _ActionTile(
              icon: Icons.share_outlined,
              label: context.l10n.actionShare,
              onTap: () {
                final actionsController = ref.read(fileActionsControllerProvider);
                Navigator.of(context).pop();
                actionsController.shareFiles([file]);
              },
            ),

            // Action: Rename
            _ActionTile(
              icon: Icons.drive_file_rename_outline,
              label: context.l10n.actionRename,
              onTap: () {
                Navigator.of(context).pop();
                _showRenameDialog(targetContext, file);
              },
            ),

            // Action: Bookmark toggle
            _ActionTile(
              icon: file.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              iconColor: file.isBookmarked ? colorScheme.primary : null,
              label: file.isBookmarked
                  ? context.l10n.actionRemoveBookmark
                  : context.l10n.actionBookmark,
              onTap: () {
                final actionsController = ref.read(fileActionsControllerProvider);
                Navigator.of(context).pop();
                actionsController.toggleBookmark(file);
              },
            ),

            // Action: Open in another app
            _ActionTile(
              icon: Icons.launch_outlined,
              label: context.l10n.actionOpenInAnotherApp,
              onTap: () async {
                Navigator.of(context).pop();
                final result = await OpenFilex.open(file.path);
                if (result.type != ResultType.done && targetContext.mounted) {
                  ScaffoldMessenger.of(targetContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        result.message.isNotEmpty
                            ? result.message
                            : targetContext.l10n.errorCouldNotOpenDocument(file.name),
                      ),
                    ),
                  );
                }
              },
            ),

            // Action: Details
            _ActionTile(
              icon: Icons.info_outline,
              label: context.l10n.actionDetails,
              onTap: () {
                Navigator.of(context).pop();
                FileDetailsSheet.show(targetContext, file);
              },
            ),

            // Action: Delete
            _ActionTile(
              icon: Icons.delete_outline,
              label: context.l10n.actionDelete,
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
        FileNameValidationError? validationError;

        return Consumer(
          builder: (consumerContext, ref, _) {
            return StatefulBuilder(
              builder: (stateContext, setState) {
                final currentText = controller.text.trim();
                final isValid = validationError == null &&
                    currentText.isNotEmpty &&
                    currentText != baseName;

                return AlertDialog(
                  title: Text(stateContext.l10n.renameFileTitle),
                  content: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: stateContext.l10n.renameFileNameLabel,
                      suffixText: ext.isNotEmpty ? ext : null,
                      errorText: validationError?.localizedMessage(stateContext),
                    ),
                    onChanged: (value) {
                      setState(() {
                        validationError = validateFileName(value);
                      });
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(stateContext.l10n.actionCancel),
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

                              if (!parentContext.mounted) return;

                              if (result is RenameSuccess) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      parentContext.l10n.renamedSuccess(
                                        result.updatedFile.name,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (result is RenameFailure) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      result.localizedMessage(parentContext),
                                    ),
                                    backgroundColor: errorColor,
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Text(stateContext.l10n.actionRename),
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
            if (recycleBinEnabled) {
              final isTooLarge = file.sizeBytes > AppConstants.trashMaxFileBytes;
              if (isTooLarge) {
                return AlertDialog(
                  title: Text(dialogContext.l10n.trashDialogTooLargeTitle),
                  content: Text(dialogContext.l10n.trashDialogTooLargeBody(file.name)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(dialogContext.l10n.actionCancel),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: errorColor,
                        foregroundColor: Theme.of(parentContext).colorScheme.onError,
                      ),
                      onPressed: () async {
                        final actionsController =
                            ref.read(fileActionsControllerProvider);
                        Navigator.of(dialogContext).pop();
                        final result = await actionsController.deleteFiles([file]);

                        if (!parentContext.mounted) return;

                        if (result.hasDeletions) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                parentContext.l10n.deletedFileSuccess(file.name),
                              ),
                            ),
                          );
                        } else {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                result.localizedMessage(parentContext) ??
                                    parentContext.l10n.filesDeleteFailed,
                              ),
                              backgroundColor: errorColor,
                            ),
                          );
                        }
                      },
                      child: Text(dialogContext.l10n.trashActionDeletePermanently),
                    ),
                  ],
                );
              }

              return AlertDialog(
                title: Text(dialogContext.l10n.trashDialogMoveTitle),
                content: Text(dialogContext.l10n.trashDialogMoveBody(1)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(dialogContext.l10n.actionCancel),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: errorColor,
                      foregroundColor: Theme.of(parentContext).colorScheme.onError,
                    ),
                    onPressed: () async {
                      final actionsController =
                          ref.read(fileActionsControllerProvider);
                      Navigator.of(dialogContext).pop();
                      final result = await actionsController.moveToTrash([file]);

                      if (!parentContext.mounted) return;

                      if (result.hasSuccesses) {
                        final trashedItem = result.successfulItems.first;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(parentContext.l10n.trashMovedSuccess(1)),
                            duration: const Duration(seconds: 6),
                            action: SnackBarAction(
                              label: parentContext.l10n.trashActionUndo,
                              onPressed: () async {
                                await actionsController.restoreFromTrash([trashedItem]);
                              },
                            ),
                          ),
                        );
                      } else {
                        if (result.firstErrorReason == TrashErrorReason.notEnoughSpace) {
                          showDialog<void>(
                            context: parentContext,
                            builder: (spaceCtx) => AlertDialog(
                              title: Text(parentContext.l10n.trashDialogNotEnoughSpaceTitle),
                              content: Text(parentContext.l10n.trashDialogNotEnoughSpaceBody),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(spaceCtx).pop(),
                                  child: Text(parentContext.l10n.actionCancel),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.of(spaceCtx).pop();
                                    parentContext.push('/tools/recycle-bin');
                                  },
                                  child: Text(parentContext.l10n.trashActionFreeUpSpace),
                                ),
                              ],
                            ),
                          );
                        } else if (result.firstErrorReason == TrashErrorReason.copyFailed ||
                            result.firstErrorReason == TrashErrorReason.verifyFailed) {
                          showDialog<void>(
                            context: parentContext,
                            builder: (copyFailContext) => AlertDialog(
                              title: Text(parentContext.l10n.trashDialogCopyFailedTitle),
                              content: Text(
                                parentContext.l10n.trashDialogCopyFailedBody(file.name),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(copyFailContext).pop(),
                                  child: Text(parentContext.l10n.actionCancel),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: errorColor,
                                    foregroundColor: Theme.of(parentContext).colorScheme.onError,
                                  ),
                                  onPressed: () async {
                                    Navigator.of(copyFailContext).pop();
                                    final delResult = await actionsController.deleteFiles([file]);
                                    if (!parentContext.mounted) return;
                                    if (delResult.hasDeletions) {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            parentContext.l10n.deletedFileSuccess(file.name),
                                          ),
                                        ),
                                      );
                                    } else {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            delResult.localizedMessage(parentContext) ??
                                                parentContext.l10n.filesDeleteFailed,
                                          ),
                                          backgroundColor: errorColor,
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(parentContext.l10n.trashActionDeletePermanently),
                                ),
                              ],
                            ),
                          );
                        } else {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                result.firstErrorDetails ??
                                    parentContext.l10n.filesDeleteFailed,
                              ),
                              backgroundColor: errorColor,
                            ),
                          );
                        }
                      }
                    },
                    child: Text(dialogContext.l10n.trashActionMove),
                  ),
                ],
              );
            }

            return AlertDialog(
              title: Text(dialogContext.l10n.deleteFileTitle),
              content: Text(dialogContext.l10n.deleteFileConfirmation(file.name)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(dialogContext.l10n.actionCancel),
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

                    if (!parentContext.mounted) return;

                    if (result.hasDeletions) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            parentContext.l10n.deletedFileSuccess(file.name),
                          ),
                        ),
                      );
                    } else {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            result.localizedMessage(parentContext) ??
                                parentContext.l10n.filesDeleteFailed,
                          ),
                          backgroundColor: errorColor,
                        ),
                      );
                    }
                  },
                  child: Text(dialogContext.l10n.actionDelete),
                ),
              ],
            );
          },
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
