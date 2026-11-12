import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/file_types.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../providers/providers.dart';

import 'merge_pdf_picker_screen.dart';
import 'split_picker_screen.dart';

/// Reusable document picker that loads indexed PDFs from SQLite, supporting both
/// single-select (e.g. for Split PDF) and multi-select (e.g. for Merge PDF).
class LibraryPdfPickerScreen extends ConsumerStatefulWidget {
  const LibraryPdfPickerScreen({
    this.multiSelect = true,
    this.title,
    this.minSelection = 1,
    super.key,
  });

  /// Whether multiple PDFs can be selected simultaneously.
  final bool multiSelect;

  /// Optional app bar title override.
  final String? title;

  /// Minimum number of selected files required to proceed in multi-select mode.
  final int minSelection;

  /// Convenient static helper to push this picker and await user selection.
  static Future<List<DocFile>?> pick(
    BuildContext context, {
    bool multiSelect = true,
    String? title,
    int minSelection = 1,
  }) async {
    if (multiSelect) {
      return MergePdfPickerScreen.pick(
        context,
        title: title,
        minSelection: minSelection,
      );
    } else {
      final single = await SplitPickerScreen.pick(context);
      return single != null ? [single] : null;
    }
  }

  @override
  ConsumerState<LibraryPdfPickerScreen> createState() =>
      _LibraryPdfPickerScreenState();
}

class _LibraryPdfPickerScreenState
    extends ConsumerState<LibraryPdfPickerScreen> {
  final Set<String> _selectedPaths = <String>{};
  final Map<String, DocFile> _selectedFilesMap = <String, DocFile>{};

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _filterQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelection(DocFile file) {
    setState(() {
      if (_selectedPaths.contains(file.path)) {
        _selectedPaths.remove(file.path);
        _selectedFilesMap.remove(file.path);
      } else {
        _selectedPaths.add(file.path);
        _selectedFilesMap[file.path] = file;
      }
    });
  }

  void _onDone() {
    final selectedList = _selectedFilesMap.values.toList();
    Navigator.of(context).pop(selectedList);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pdfsAsync = ref.watch(filesProvider(FileCategory.pdf));

    final effectiveTitle = widget.title ??
        (widget.multiSelect ? 'Select PDF Files' : 'Select PDF File');

    return Scaffold(
      appBar: _isSearching
          ? AppBar(
              leading: IconButton(
                constraints:
                    const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Close search',
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _filterQuery = '';
                    _searchController.clear();
                  });
                },
              ),
              title: TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Search PDFs...',
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() => _filterQuery = val.trim().toLowerCase());
                },
              ),
              actions: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    constraints:
                        const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: const Icon(Icons.clear_rounded),
                    tooltip: 'Clear search',
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _filterQuery = '';
                      });
                    },
                  ),
              ],
            )
          : AppBar(
              title: Text(effectiveTitle),
              actions: [
                IconButton(
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'Search',
                  onPressed: () {
                    setState(() => _isSearching = true);
                  },
                ),
              ],
            ),
      body: pdfsAsync.when(
        data: (allFiles) {
          final filteredFiles = _filterQuery.isEmpty
              ? allFiles
              : allFiles
                  .where((f) => f.name.toLowerCase().contains(_filterQuery))
                  .toList();

          if (filteredFiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 56,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _filterQuery.isEmpty
                        ? 'No PDF documents found'
                        : 'No matches found',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filteredFiles.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 72,
            ),
            itemBuilder: (context, index) {
              final file = filteredFiles[index];
              final isSelected = _selectedPaths.contains(file.path);

              return ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: FileCategory.pdf.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    FileCategory.pdf.icon,
                    color: FileCategory.pdf.color,
                    size: 24,
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
                  FormatUtils.formatSubtitle(file.modified, file.sizeBytes),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
                trailing: widget.multiSelect
                    ? Checkbox(
                        value: isSelected,
                        onChanged: (_) => _toggleSelection(file),
                      )
                    : const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                onTap: () {
                  if (widget.multiSelect) {
                    _toggleSelection(file);
                  } else {
                    Navigator.of(context).pop([file]);
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading files: $err')),
      ),
      bottomNavigationBar: widget.multiSelect
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '${_selectedPaths.length} selected',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(120, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _selectedPaths.length >= widget.minSelection
                          ? _onDone
                          : null,
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

