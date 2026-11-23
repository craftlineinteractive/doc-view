import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../data/services/pdf/pdf_annotation_service.dart';
import '../../../shared/widgets/navigation/doc_scaffold.dart';

/// Shared editor shell used by both [AnnotateScreen] and [SignScreen].
///
/// Provides the standardized ad-free layout, navigation app bar with Undo/Redo/Save actions,
/// signed document warning banner, unsaved changes discard confirmation, and save modal logic.
class PdfEditorShell extends StatelessWidget {
  const PdfEditorShell({
    required this.filePath,
    required this.isDirty,
    required this.canUndo,
    required this.canRedo,
    required this.canSave,
    required this.onUndo,
    required this.onRedo,
    required this.onSave,
    required this.documentInfo,
    required this.body,
    this.changesCount,
    this.bottomBar,
    this.onBack,
    super.key,
  });

  final String filePath;
  final bool isDirty;
  final bool canUndo;
  final bool canRedo;
  final bool canSave;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onSave;
  final PdfDocumentInfo? documentInfo;
  final Widget body;
  final int? changesCount;
  final Widget? bottomBar;
  final VoidCallback? onBack;

  /// Shows the standard confirmation dialog when user attempts to leave with unsaved changes.
  static Future<bool> showDiscardDialog(BuildContext context) async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.annotateDiscardDialogTitle),
        content: Text(context.l10n.annotateDiscardDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(context.l10n.annotateDiscardDialogActionKeep),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(context.l10n.annotateDiscardDialogActionDiscard),
          ),
        ],
      ),
    );

    return discard ?? false;
  }

  /// Displays the modal bottom sheet offering "Save as new file" or "Replace original".
  static Future<String?> showSaveOptionsSheet(
    BuildContext context, {
    required bool isSigned,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.tokens.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.annotateSaveTitle,
                style: DocViewTypography.headlineSm.copyWith(
                  color: context.tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: Text(context.l10n.annotateActionSaveNew),
                onTap: () => Navigator.of(ctx).pop('new'),
              ),
              ListTile(
                leading: const Icon(Icons.save_outlined),
                title: Text(context.l10n.annotateActionReplace),
                enabled: !isSigned,
                subtitle: isSigned
                    ? Text(
                        context.l10n.annotateSignedReplaceBlocked,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      )
                    : null,
                onTap: isSigned ? null : () => Navigator.of(ctx).pop('replace'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isSigned = documentInfo?.hasDigitalSignature ?? false;
    final fileName = p.basename(filePath);

    return PopScope(
      canPop: !isDirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldDiscard = await showDiscardDialog(context);
        if (shouldDiscard && context.mounted) {
          if (onBack != null) {
            onBack!();
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: DocScaffold(
        showDockedBanner: false,
        isAdLoaded: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: tokens.surface,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              key: const Key('annotate_back_button'),
              icon: const Icon(Icons.arrow_back),
              tooltip: context.l10n.tooltipBack,
              onPressed: () async {
                if (isDirty) {
                  final discard = await showDiscardDialog(context);
                  if (discard && context.mounted) {
                    if (onBack != null) {
                      onBack!();
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                } else {
                  if (onBack != null) {
                    onBack!();
                  } else {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DocViewTypography.headlineSm.copyWith(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (changesCount != null && changesCount! > 0)
                  Text(
                    context.l10n.annotateChangesCount(changesCount!),
                    style: TextStyle(
                      color: tokens.textSecondary,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            actions: [
              IconButton(
                key: const Key('annotate_action_undo'),
                icon: const Icon(Icons.undo),
                tooltip: context.l10n.annotateTooltipUndo,
                onPressed: canUndo ? onUndo : null,
              ),
              IconButton(
                key: const Key('annotate_action_redo'),
                icon: const Icon(Icons.redo),
                tooltip: context.l10n.annotateTooltipRedo,
                onPressed: canRedo ? onRedo : null,
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilledButton(
                  key: const Key('annotate_action_save'),
                  onPressed: canSave ? onSave : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(64, 36),
                  ),
                  child: Text(context.l10n.annotateTooltipSave),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                if (isSigned)
                  Container(
                    key: const Key('annotate_signed_banner'),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.amber.shade100,
                    child: Row(
                      children: [
                        Icon(Icons.verified_outlined, size: 20, color: Colors.amber.shade900),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.annotateSignedBanner,
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(child: body),
              ],
            ),
            if (bottomBar != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: bottomBar!,
              ),
          ],
        ),
      ),
    );
  }
}
