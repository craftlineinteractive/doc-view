import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/file_types.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../../shared/widgets/buttons/doc_icon_button.dart';
import '../../../shared/widgets/skeletons/shimmer.dart';
import '../../../shared/widgets/skeletons/skeleton_variants.dart';
import '../../../shared/widgets/tiles/file_thumbnail.dart';
import '../../providers/providers.dart';
import '../services/pdf_page_count_service.dart';

enum _PickerTab {
  all,
  recent,
  platformSource,
}

/// Unified, accessible PDF document picker used across all tool workflows.
///
/// Supports:
/// - Single-select or multi-select modes
/// - Source tabs: All PDFs, Recent, Downloads (Android) / iCloud Drive (iOS)
/// - Lazy page count loading with in-memory caching
/// - Inline filename search
/// - "Browse files" button via system picker
class ToolFilePickerScreen extends ConsumerStatefulWidget {
  const ToolFilePickerScreen({
    this.title,
    this.allowMultiple = false,
    this.minSelection = 1,
    this.actionLabel,
    super.key,
  });

  final String? title;
  final bool allowMultiple;
  final int minSelection;
  final String? actionLabel;

  /// Convenience helper to pick a single PDF document.
  static Future<DocFile?> pickSingle(
    BuildContext context, {
    String? title,
    String? actionLabel,
  }) async {
    final result = await Navigator.of(context).push<List<DocFile>>(
      MaterialPageRoute(
        builder: (context) => ToolFilePickerScreen(
          title: title,
          allowMultiple: false,
          minSelection: 1,
          actionLabel: actionLabel,
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  /// Convenience helper to pick multiple PDF documents.
  static Future<List<DocFile>?> pickMultiple(
    BuildContext context, {
    String? title,
    int minSelection = 2,
    String? actionLabel,
  }) {
    return Navigator.of(context).push<List<DocFile>>(
      MaterialPageRoute(
        builder: (context) => ToolFilePickerScreen(
          title: title,
          allowMultiple: true,
          minSelection: minSelection,
          actionLabel: actionLabel,
        ),
      ),
    );
  }

  @override
  ConsumerState<ToolFilePickerScreen> createState() =>
      _ToolFilePickerScreenState();
}

class _ToolFilePickerScreenState extends ConsumerState<ToolFilePickerScreen> {
  final Set<String> _selectedPaths = <String>{};
  final Map<String, DocFile> _selectedFilesMap = <String, DocFile>{};
  final List<DocFile> _importedBrowseFiles = <DocFile>[];

  _PickerTab _currentTab = _PickerTab.all;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _filterQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelect(DocFile file) {
    setState(() {
      if (widget.allowMultiple) {
        if (_selectedPaths.contains(file.path)) {
          _selectedPaths.remove(file.path);
          _selectedFilesMap.remove(file.path);
        } else {
          _selectedPaths.add(file.path);
          _selectedFilesMap[file.path] = file;
        }
      } else {
        if (_selectedPaths.contains(file.path)) {
          _selectedPaths.clear();
          _selectedFilesMap.clear();
        } else {
          _selectedPaths.clear();
          _selectedFilesMap.clear();
          _selectedPaths.add(file.path);
          _selectedFilesMap[file.path] = file;
        }
      }
    });
  }

  void _onConfirm() {
    final selectedList = _selectedPaths
        .map((p) => _selectedFilesMap[p])
        .whereType<DocFile>()
        .toList();
    Navigator.of(context).pop(selectedList);
  }

  Future<void> _onBrowseFiles() async {
    try {
      final pickedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (pickedFiles.isEmpty || !mounted) return;

      final newFiles = <DocFile>[];
      for (final pf in pickedFiles) {
        final path = pf.path;
        if (path == null) continue;
        final fileObj = File(path);
        if (!fileObj.existsSync()) continue;
        final stat = fileObj.statSync();
        final doc = DocFile(
          id: path.hashCode,
          path: path,
          name: pf.name,
          extension: '.pdf',
          sizeBytes: stat.size,
          modified: stat.modified,
          category: FileCategory.pdf,
        );
        newFiles.add(doc);
      }

      if (newFiles.isNotEmpty) {
        setState(() {
          _importedBrowseFiles.addAll(newFiles);
          if (!widget.allowMultiple) {
            _selectedPaths.clear();
            _selectedFilesMap.clear();
            _selectedPaths.add(newFiles.first.path);
            _selectedFilesMap[newFiles.first.path] = newFiles.first;
          } else {
            for (final f in newFiles) {
              _selectedPaths.add(f.path);
              _selectedFilesMap[f.path] = f;
            }
          }
        });
      }
    } catch (_) {}
  }

  List<DocFile> _filterFiles(List<DocFile> allFiles) {
    // Combine repository files with imported browse files
    final combined = <DocFile>[..._importedBrowseFiles];
    final existingPaths = combined.map((f) => f.path).toSet();
    for (final f in allFiles) {
      if (!existingPaths.contains(f.path)) {
        combined.add(f);
      }
    }

    Iterable<DocFile> filtered = combined;

    switch (_currentTab) {
      case _PickerTab.all:
        break;
      case _PickerTab.recent:
        final now = DateTime.now();
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        filtered = filtered.where((f) => f.modified.isAfter(sevenDaysAgo));
        break;
      case _PickerTab.platformSource:
        filtered = filtered.where((f) {
          final p = f.path.toLowerCase();
          return p.contains('download') || p.contains('icloud') || p.contains('documents');
        });
        break;
    }

    if (_filterQuery.isNotEmpty) {
      final query = _filterQuery.toLowerCase();
      filtered = filtered.where((f) => f.name.toLowerCase().contains(query));
    }

    final list = filtered.toList();
    list.sort((a, b) => b.modified.compareTo(a.modified));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final pdfsAsync = ref.watch(filesProvider(FileCategory.pdf));
    final defaultTitle = widget.allowMultiple
        ? context.l10n.toolPickerTitleSelectPdfs
        : context.l10n.toolPickerTitleSelectPdf;
    final titleText = widget.title ?? defaultTitle;

    return Scaffold(
      backgroundColor: tokens.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: tokens.surface,
              border: Border(
                bottom: BorderSide(color: tokens.hairline, width: 1),
              ),
            ),
            child: _isSearching
                ? Row(
                    children: [
                      DocIconButton(
                        icon: AppIcons.back,
                        tooltip: context.l10n.tooltipCloseSearch,
                        onPressed: () {
                          setState(() {
                            _isSearching = false;
                            _filterQuery = '';
                            _searchController.clear();
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: DocViewTypography.bodyMd.copyWith(
                            color: tokens.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: context.l10n.searchHint,
                            hintStyle: DocViewTypography.bodyMd.copyWith(
                              color: tokens.textSecondary,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            setState(() {
                              _filterQuery = val.trim();
                            });
                          },
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        DocIconButton(
                          icon: AppIcons.close,
                          tooltip: context.l10n.tooltipClearSearch,
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _filterQuery = '';
                            });
                          },
                        ),
                    ],
                  )
                : Row(
                    children: [
                      DocIconButton(
                        icon: AppIcons.back,
                        tooltip: context.l10n.tooltipBack,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          titleText,
                          style: DocViewTypography.headlineSm.copyWith(
                            fontWeight: FontWeight.bold,
                            color: tokens.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DocIconButton(
                        icon: AppIcons.search,
                        tooltip: context.l10n.tooltipSearch,
                        onPressed: () {
                          setState(() {
                            _isSearching = true;
                          });
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSourceTabs(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                key: const Key('tool_picker_browse_btn'),
                onPressed: _onBrowseFiles,
                icon: const Icon(Icons.folder_open_outlined, size: 18),
                label: Text(
                  context.l10n.toolPickerBrowseFiles,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(88, 40),
                  foregroundColor: tokens.primaryBlue,
                  side: BorderSide(color: tokens.hairline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: pdfsAsync.when(
              loading: () => const SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: SkeletonFileList(itemCount: 6),
              ),
              error: (err, _) => Center(
                child: Text(
                  context.l10n.importFailedError,
                  style: TextStyle(color: tokens.textSecondary),
                ),
              ),
              data: (files) {
                final displayFiles = _filterFiles(files);

                if (displayFiles.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: displayFiles.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: tokens.hairline,
                    indent: 72,
                  ),
                  itemBuilder: (context, index) {
                    final file = displayFiles[index];
                    final isSelected = _selectedPaths.contains(file.path);

                    // Trigger background page count calculation
                    PdfPageCountService.instance.loadPageCount(
                      file.path,
                      onLoaded: () {
                        if (mounted) setState(() {});
                      },
                    );

                    return _buildFileItem(context, file, isSelected);
                  },
                );
              },
            ),
          ),
          _buildBottomAction(context),
        ],
      ),
    );
  }

  Widget _buildSourceTabs(BuildContext context) {
    final tokens = context.tokens;
    final isIOS = !kIsWeb && Platform.isIOS;
    final platformSourceLabel = isIOS
        ? context.l10n.toolPickerTabICloud
        : context.l10n.toolPickerTabDownloads;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(
          bottom: BorderSide(color: tokens.hairline, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem(
            label: context.l10n.toolPickerTabAll,
            tab: _PickerTab.all,
          ),
          _buildTabItem(
            label: context.l10n.toolPickerTabRecent,
            tab: _PickerTab.recent,
          ),
          _buildTabItem(
            label: platformSourceLabel,
            tab: _PickerTab.platformSource,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String label,
    required _PickerTab tab,
  }) {
    final tokens = context.tokens;
    final isSelected = _currentTab == tab;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentTab = tab;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? tokens.primaryBlue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: DocViewTypography.labelMd.copyWith(
              color: isSelected ? tokens.primaryBlue : tokens.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildFileItem(BuildContext context, DocFile file, bool isSelected) {
    final tokens = context.tokens;
    final isError = PdfPageCountService.instance.isFlaggedError(file.path);
    final pageCount = PdfPageCountService.instance.getCachedCount(file.path);

    return InkWell(
      key: Key('picker_item_${file.path}'),
      onTap: () => _toggleSelect(file),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Checkbox or Radio selection indicator
            if (widget.allowMultiple)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  isSelected ? AppIcons.checkCircle : AppIcons.checkCircleOutline,
                  color: isSelected ? tokens.primaryBlue : tokens.textSecondary,
                  size: 22,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  isSelected ? AppIcons.radioChecked : AppIcons.radioUnchecked,
                  color: isSelected ? tokens.primaryBlue : tokens.textSecondary,
                  size: 22,
                ),
              ),

            // Thumbnail
            SizedBox(
              width: 44,
              height: 52,
              child: FileThumbnail(
                filePath: file.path,
                category: FileCategory.pdf,
              ),
            ),
            const SizedBox(width: 12),

            // File Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DocViewTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      Text(
                        '${FormatUtils.formatDate(file.modified)} · ${FormatUtils.formatFileSize(file.sizeBytes)}',
                        style: DocViewTypography.captionXs.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                      if (isError)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: tokens.error.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            context.l10n.toolsBadgeProtectedOrDamaged,
                            style: DocViewTypography.captionXs.copyWith(
                              fontSize: 10,
                              color: tokens.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else if (pageCount != null)
                        Text(
                          '· ${context.l10n.toolsPageCountPlural(pageCount)}',
                          style: DocViewTypography.captionXs.copyWith(
                            color: tokens.textSecondary,
                          ),
                        )
                      else
                        Shimmer(
                          child: Container(
                            width: 32,
                            height: 10,
                            decoration: BoxDecoration(
                              color: tokens.hairline,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.pdf,
              size: 48,
              color: tokens.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.toolsNoPdfsFound,
              style: DocViewTypography.headlineSm.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.toolPickerBrowseFiles,
              textAlign: TextAlign.center,
              style: DocViewTypography.bodySm.copyWith(
                color: tokens.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _onBrowseFiles,
              icon: const Icon(Icons.folder_open_outlined),
              label: Text(context.l10n.toolPickerBrowseFiles),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 48),
                backgroundColor: tokens.primaryBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    final tokens = context.tokens;
    final selectedCount = _selectedPaths.length;
    final canConfirm = selectedCount >= widget.minSelection;

    final defaultAction = widget.actionLabel ??
        (widget.allowMultiple
            ? context.l10n.toolPickerActionSelect
            : context.l10n.toolPickerActionSelect);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(
          top: BorderSide(color: tokens.hairline, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.toolsSelectedCount(selectedCount),
                  style: DocViewTypography.bodySm.copyWith(
                    fontWeight: FontWeight.w600,
                    color: tokens.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!canConfirm && widget.minSelection > 1)
                  Text(
                    context.l10n.toolsSelectAtLeast(widget.minSelection),
                    style: DocViewTypography.captionXs.copyWith(
                      color: tokens.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: ElevatedButton(
              key: const Key('tool_picker_confirm_btn'),
              onPressed: canConfirm ? _onConfirm : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(88, 44),
                backgroundColor: tokens.primaryBlue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: tokens.primaryBlue.withValues(alpha: 0.38),
                disabledForegroundColor: Colors.white.withValues(alpha: 0.6),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                defaultAction,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
