import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_document_viewer/offline_document_viewer.dart';
import 'package:open_filex/open_filex.dart';

import '../../data/models/doc_file.dart';
import '../providers/providers.dart';

/// Full-featured, offline Office document viewer supporting Word, Excel, and PowerPoint files.
///
/// Wraps [DocumentView] from `offline_document_viewer`, providing search with match counters,
/// document outlines (sheets, headings, slides), legacy text-only indicators, truncation notices,
/// and external app fallbacks.
class OfficeViewerScreen extends ConsumerStatefulWidget {
  const OfficeViewerScreen({
    required this.file,
    super.key,
  });

  final DocFile file;

  @override
  ConsumerState<OfficeViewerScreen> createState() => _OfficeViewerScreenState();
}

class _OfficeViewerScreenState extends ConsumerState<OfficeViewerScreen> {
  late final DocumentViewController _controller;
  late DocumentSource _source;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isSearching = false;
  DocumentInfo? _lastInfo;
  int _lastSearchHits = 0;

  @override
  void initState() {
    super.initState();
    _source = DocumentSource.file(widget.file.path);
    _controller = DocumentViewController();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(OfficeViewerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.path != widget.file.path) {
      _source = DocumentSource.file(widget.file.path);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    debugPrint(
      'OfficeViewerController status: ${_controller.status}, '
      'failure: ${_controller.failure}, '
      'info: ${_controller.info != null}',
    );
    if (!mounted) return;
    if (_controller.info != _lastInfo ||
        _controller.searchHits != _lastSearchHits) {
      _lastInfo = _controller.info;
      _lastSearchHits = _controller.searchHits;
      setState(() {});
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _stopSearch() {
    _searchController.clear();
    _controller.search('');
    setState(() {
      _isSearching = false;
    });
  }

  void _onSearchSubmitted(String query) {
    _controller.search(query.trim());
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _controller.search('');
    }
  }

  void _showOutlineBottomSheet(BuildContext context, List<String> outline) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.list_alt_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Document Outline (${outline.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: outline.length,
                  itemBuilder: (context, index) {
                    final title = outline[index].trim();
                    return ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              theme.colorScheme.primary.withValues(alpha: 0.15),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        title: Text(
                          title.isEmpty ? 'Item ${index + 1}' : title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                        onTap: () {
                          _controller.goTo(index);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch filesProvider to reflect bookmark state in real-time
    final filesAsync = ref.watch(filesProvider(null));
    final currentFile = filesAsync.value
            ?.where((f) => f.path == widget.file.path)
            .firstOrNull ??
        widget.file;

    final outline = _controller.info?.outline ?? const <String>[];
    final isTruncated = _controller.info?.truncated ?? false;

    final ext = widget.file.name.contains('.')
        ? widget.file.name.split('.').last.toLowerCase()
        : '';
    final isLegacyFormat = ext == 'doc' || ext == 'ppt';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _isSearching
          ? AppBar(
              leading: IconButton(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Exit search',
                onPressed: _stopSearch,
              ),
              title: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                textInputAction: TextInputAction.search,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Search in document...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onSubmitted: _onSearchSubmitted,
                onChanged: _onSearchChanged,
              ),
              actions: [
                if (_controller.searchHits > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_controller.searchHits} matches',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    constraints:
                        const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: const Icon(Icons.clear_rounded),
                    tooltip: 'Clear search',
                    onPressed: () {
                      _searchController.clear();
                      _controller.search('');
                    },
                  ),
              ],
            )
          : AppBar(
              title: Text(
                widget.file.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'Search document',
                  onPressed: _startSearch,
                ),
                if (outline.isNotEmpty)
                  IconButton(
                    constraints:
                        const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: const Icon(Icons.list_alt_rounded),
                    tooltip: 'Outline',
                    onPressed: () => _showOutlineBottomSheet(context, outline),
                  ),
                IconButton(
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(
                    currentFile.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: currentFile.isBookmarked
                        ? theme.colorScheme.primary
                        : null,
                  ),
                  tooltip: currentFile.isBookmarked
                      ? 'Remove bookmark'
                      : 'Bookmark',
                  onPressed: () {
                    ref
                        .read(fileActionsControllerProvider)
                        .toggleBookmark(currentFile);
                  },
                ),
              ],
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLegacyFormat)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.amber.withValues(alpha: 0.15),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Legacy format: text only',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.amber[800] ?? Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (isTruncated)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.blue.withValues(alpha: 0.15),
              child: Row(
                children: [
                  Icon(
                    Icons.table_rows_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Large spreadsheet: showing the first 3000 rows',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: DocumentView(
              source: _source,
              controller: _controller,
              onReady: (info) {
                debugPrint('OfficeViewer onReady: ${info.format.name}, outline: ${info.outline.length}');
              },
              onFailure: (failure) {
                debugPrint('OfficeViewer onFailure: $failure');
              },
              placeholderBuilder: (context) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Opening document...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                );
              },
              errorBuilder: (context, failure) {
                final String message = switch (failure) {
                  EncryptedDocumentFailure() =>
                    "Password-protected files can't be opened here",
                  TooLargeFailure() => 'File too large to preview',
                  UnsupportedFormatFailure() =>
                    "This format isn't supported",
                  _ => "Couldn't open this document",
                };

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(180, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.open_in_new_rounded),
                          label: const Text('Open in another app'),
                          onPressed: () {
                            OpenFilex.open(widget.file.path);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
