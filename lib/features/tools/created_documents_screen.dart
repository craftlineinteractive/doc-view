import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_icons.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/utils/format_utils.dart';
import '../../shared/widgets/buttons/doc_icon_button.dart';
import '../../shared/widgets/navigation/doc_app_bar.dart';
import '../../shared/widgets/navigation/doc_scaffold.dart';
import '../../shared/widgets/skeletons/skeleton_variants.dart';
import '../../shared/widgets/status/doc_status_widgets.dart';
import '../../shared/widgets/tiles/file_and_folder_rows.dart';
import '../files/open_document.dart';
import '../files/widgets/file_options_sheet.dart';
import '../providers/providers.dart';

/// Screen listing all documents created by Doc View tools, reusing the clean FileRow design.
class CreatedDocumentsScreen extends ConsumerWidget {
  const CreatedDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final createdFilesAsync = ref.watch(createdFilesProvider);

    return DocScaffold(
      showDockedBanner: true,
      isAdLoaded: true,
      appBar: DocSubAppBar(
        title: 'Created by you',
        actions: [
          DocIconButton(
            icon: AppIcons.search,
            tooltip: 'Search',
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: createdFilesAsync.when(
        loading: () => const SkeletonFileList(itemCount: 8),
        error: (err, _) => Center(
          child: Text(
            'Failed to load created files: $err',
            style: TextStyle(color: tokens.textSecondary),
          ),
        ),
        data: (files) {
          if (files.isEmpty) {
            return const DocEmptyState(
              icon: Icons.note_add_outlined,
              title: 'No created documents yet',
              message:
                  'Converted, scanned, or merged documents will appear here.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              return FileRow(
                title: file.name,
                metadata: FormatUtils.formatSubtitle(
                  file.modified,
                  file.sizeBytes,
                ),
                category: file.category,
                filePath: file.path,
                isBookmarked: file.isBookmarked,
                onTap: () => openDocument(context, ref, file),
                onToggleBookmark: () async {
                  await ref
                      .read(fileActionsControllerProvider)
                      .toggleBookmark(file);
                },
                onOptions: () {
                  FileOptionsSheet.show(context, file);
                },
              );
            },
          );
        },
      ),
    );
  }
}
