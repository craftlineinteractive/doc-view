import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/doc_file.dart';
import '../providers/providers.dart';

/// Data class holding processed text lines and truncation status.
class _TxtContent {
  const _TxtContent({
    required this.lines,
    required this.isTruncated,
  });

  final List<String> lines;
  final bool isTruncated;
}

/// Reads a text file off the main isolate, capping reading to 1 MB with malformed UTF-8 tolerance.
Future<_TxtContent> _readTxtFileIsolate(String filePath) async {
  return await Isolate.run(() async {
    final file = File(filePath);
    final length = await file.length();
    const maxBytes = 1024 * 1024; // 1 MB
    final isTruncated = length > maxBytes;

    List<int> bytes;
    if (isTruncated) {
      final raf = await file.open(mode: FileMode.read);
      try {
        bytes = await raf.read(maxBytes);
      } finally {
        await raf.close();
      }
    } else {
      bytes = await file.readAsBytes();
    }

    final decoded = utf8.decode(bytes, allowMalformed: true);
    final lines = const LineSplitter().convert(decoded);
    return _TxtContent(lines: lines, isTruncated: isTruncated);
  });
}

/// Content-first text document reader with isolate-backed decoding, selectable text, and dynamic typography controls.
class TxtViewerScreen extends ConsumerStatefulWidget {
  const TxtViewerScreen({
    required this.file,
    super.key,
  });

  final DocFile file;

  @override
  ConsumerState<TxtViewerScreen> createState() => _TxtViewerScreenState();
}

class _TxtViewerScreenState extends ConsumerState<TxtViewerScreen> {
  static const String _keyFontSize = 'txt_font_size';
  static const String _keyMonospace = 'txt_is_monospace';

  late Future<_TxtContent> _contentFuture;
  double _fontSize = 15.0;
  bool _isMonospace = false;

  @override
  void initState() {
    super.initState();
    _contentFuture = _readTxtFileIsolate(widget.file.path);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _fontSize = (prefs.getDouble(_keyFontSize) ?? 15.0).clamp(12.0, 28.0);
        _isMonospace = prefs.getBool(_keyMonospace) ?? false;
      });
    } catch (_) {}
  }

  Future<void> _setFontSize(double newSize) async {
    final clamped = newSize.clamp(12.0, 28.0);
    setState(() {
      _fontSize = clamped;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_keyFontSize, clamped);
    } catch (_) {}
  }

  Future<void> _toggleMonospace() async {
    final next = !_isMonospace;
    setState(() {
      _isMonospace = next;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyMonospace, next);
    } catch (_) {}
  }

  void _retry() {
    setState(() {
      _contentFuture = _readTxtFileIsolate(widget.file.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch filesProvider to reflect bookmark toggles in real-time
    final filesAsync = ref.watch(filesProvider(null));
    final currentFile = filesAsync.value
            ?.where((f) => f.path == widget.file.path)
            .firstOrNull ??
        widget.file;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
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
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Text(
              'A-',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            tooltip: 'Decrease font size',
            onPressed: _fontSize > 12.0
                ? () => _setFontSize(_fontSize - 2.0)
                : null,
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Text(
              'A+',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            tooltip: 'Increase font size',
            onPressed: _fontSize < 28.0
                ? () => _setFontSize(_fontSize + 2.0)
                : null,
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              _isMonospace
                  ? Icons.font_download
                  : Icons.font_download_outlined,
              size: 20,
              color: _isMonospace ? theme.colorScheme.primary : null,
            ),
            tooltip: 'Monospace toggle',
            onPressed: _toggleMonospace,
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              currentFile.isBookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: currentFile.isBookmarked
                  ? theme.colorScheme.primary
                  : null,
            ),
            tooltip:
                currentFile.isBookmarked ? 'Remove bookmark' : 'Bookmark',
            onPressed: () {
              ref
                  .read(fileActionsControllerProvider)
                  .toggleBookmark(currentFile);
            },
          ),
        ],
      ),
      body: FutureBuilder<_TxtContent>(
        future: _contentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
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
                    const SizedBox(height: 12),
                    Text(
                      'Failed to read text file',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;
          final lines = data.lines;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (data.isTruncated)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: Colors.amber.withValues(alpha: 0.15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Showing first 1 MB of file',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.amber[800] ?? Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: SelectionArea(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: lines.length,
                    itemBuilder: (context, index) {
                      return Text(
                        lines[index].isEmpty ? ' ' : lines[index],
                        style: TextStyle(
                          fontSize: _fontSize,
                          fontFamily: _isMonospace ? 'monospace' : null,
                          height: 1.45,
                          color: theme.colorScheme.onSurface,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
