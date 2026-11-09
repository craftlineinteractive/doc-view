import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/doc_view_colors.dart';
import '../../core/theme/doc_view_tokens.dart';
import '../../core/theme/doc_view_typography.dart';
import '../../data/models/doc_file.dart';
import '../../shared/widgets/buttons/doc_buttons.dart';
import '../../shared/widgets/skeletons/shimmer.dart';
import '../providers/providers.dart';
import 'widgets/pdf_more_sheet.dart';

/// Data class holding processed text lines and truncation status.
class TxtContent {
  const TxtContent({
    required this.lines,
    required this.isTruncated,
  });

  final List<String> lines;
  final bool isTruncated;
}

/// Top-level synchronous worker function running inside an isolate.
/// Reads a text file safely capping reading to 1 MB with malformed UTF-8 tolerance.
TxtContent readTxtFileWorker(String filePath) {
  final file = File(filePath);
  if (!file.existsSync()) {
    return const TxtContent(lines: [], isTruncated: false);
  }

  final length = file.lengthSync();
  const maxBytes = 1024 * 1024; // 1 MB
  final isTruncated = length > maxBytes;

  List<int> bytes;
  if (isTruncated) {
    final raf = file.openSync(mode: FileMode.read);
    try {
      bytes = raf.readSync(maxBytes);
    } finally {
      raf.closeSync();
    }
  } else {
    bytes = file.readAsBytesSync();
  }

  final decoded = utf8.decode(bytes, allowMalformed: true);
  final lines = const LineSplitter().convert(decoded);
  return TxtContent(lines: lines, isTruncated: isTruncated);
}

/// Dispatches [readTxtFileWorker] in a background isolate via [Isolate.run].
Future<TxtContent> readTxtFileContent(String filePath) {
  return Isolate.run(() => readTxtFileWorker(filePath));
}

/// Content-first text document reader with isolate-backed decoding,
/// selectable text, persisted typography controls, and typography bottom sheet.
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

  late Future<TxtContent> _contentFuture;
  double _fontSize = 15.0;
  bool _isMonospace = false;
  bool _dismissedTruncationBanner = false;

  @override
  void initState() {
    super.initState();
    _contentFuture = readTxtFileContent(widget.file.path);
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
      _contentFuture = readTxtFileContent(widget.file.path);
    });
  }

  void _showTypographySheet(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? DocViewColors.backgroundDark : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: tokens.textSecondary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Typography',
                          style: DocViewTypography.headlineSm.copyWith(
                            color: tokens.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: tokens.primaryBlue.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_fontSize.round()} pt',
                            style: TextStyle(
                              color: tokens.primaryBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Font size slider
                    Row(
                      children: [
                        const Text(
                          'A',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Slider(
                            value: _fontSize,
                            min: 12.0,
                            max: 28.0,
                            divisions: 16,
                            activeColor: tokens.primaryBlue,
                            onChanged: (val) {
                              setSheetState(() {});
                              _setFontSize(val);
                            },
                          ),
                        ),
                        const Text(
                          'A',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Monospace toggle
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Monospace font',
                        style: DocViewTypography.bodyMd.copyWith(
                          color: tokens.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Fixed-width characters for code and logs',
                        style: DocViewTypography.captionXs.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                      value: _isMonospace,
                      activeThumbColor: tokens.primaryBlue,
                      onChanged: (val) {
                        setSheetState(() {});
                        _toggleMonospace();
                      },
                    ),
                    const SizedBox(height: 16),

                    // Live preview line
                    Text(
                      'Preview',
                      style: DocViewTypography.captionXs.copyWith(
                        color: tokens.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: tokens.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: tokens.hairline),
                      ),
                      child: Text(
                        'The quick brown fox jumps over the lazy dog.',
                        style: TextStyle(
                          fontSize: _fontSize,
                          fontFamily: _isMonospace ? 'monospace' : null,
                          height: 1.5,
                          color: tokens.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Watch filesProvider to reflect bookmark toggles in real-time
    final filesAsync = ref.watch(filesProvider(null));
    final currentFile = filesAsync.value
            ?.where((f) => f.path == widget.file.path)
            .firstOrNull ??
        widget.file;

    return Scaffold(
      backgroundColor: tokens.readerCanvas,
      appBar: AppBar(
        backgroundColor: isDark ? DocViewColors.backgroundDark : Colors.white,
        elevation: 0,
        leading: IconButton(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: Icon(Icons.arrow_back_rounded, color: tokens.textPrimary),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          widget.file.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DocViewTypography.titleMd.copyWith(
            color: tokens.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Text(
              'A-',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: _fontSize > 12.0
                    ? tokens.textPrimary
                    : tokens.textSecondary.withValues(alpha: 0.4),
              ),
            ),
            tooltip: 'Decrease font size',
            onPressed: _fontSize > 12.0
                ? () => _setFontSize(_fontSize - 2.0)
                : null,
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Text(
              'A+',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _fontSize < 28.0
                    ? tokens.textPrimary
                    : tokens.textSecondary.withValues(alpha: 0.4),
              ),
            ),
            tooltip: 'Increase font size',
            onPressed: _fontSize < 28.0
                ? () => _setFontSize(_fontSize + 2.0)
                : null,
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              Icons.tune_rounded,
              color: tokens.textPrimary,
              size: 20,
            ),
            tooltip: 'Typography settings',
            onPressed: () => _showTypographySheet(context),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(
              currentFile.isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: currentFile.isBookmarked
                  ? tokens.primaryBlue
                  : tokens.textPrimary,
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
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Icon(Icons.more_vert_rounded, color: tokens.textPrimary),
            tooltip: 'More options',
            onPressed: () {
              ViewerMoreSheet.show(
                context,
                file: currentFile,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<TxtContent>(
        future: _contentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeletonBody(tokens);
          }

          if (snapshot.hasError) {
            return _buildErrorBody(context, tokens);
          }

          final data = snapshot.data!;
          final lines = data.lines;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Truncation notice banner
              if (data.isTruncated && !_dismissedTruncationBanner)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  color: tokens.blueTint,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: tokens.primaryBlue,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Showing first 1 MB • Open in another app for full content',
                          style: DocViewTypography.bodySm.copyWith(
                            color: tokens.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _dismissedTruncationBanner = true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: tokens.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Text body with SelectionArea and 1.5 line height
              Expanded(
                child: SelectionArea(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    itemCount: lines.length,
                    itemBuilder: (context, index) {
                      return Text(
                        lines[index].isEmpty ? ' ' : lines[index],
                        style: TextStyle(
                          fontSize: _fontSize,
                          fontFamily: _isMonospace ? 'monospace' : null,
                          height: 1.5,
                          color: tokens.textPrimary,
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

  Widget _buildSkeletonBody(DocViewTokens tokens) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < 8; i++) ...[
            Shimmer(
              child: Container(
                width: i % 3 == 0
                    ? 180
                    : (i % 2 == 0 ? double.infinity : 280),
                height: 14,
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorBody(BuildContext context, DocViewTokens tokens) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: DocViewColors.pdfSolid.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: DocViewColors.pdfSolid,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Can't read this text file",
              textAlign: TextAlign.center,
              style: DocViewTypography.headlineSm.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The file format or encoding could not be parsed.',
              textAlign: TextAlign.center,
              style: DocViewTypography.bodyMd.copyWith(
                color: tokens.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            DocPrimaryButton(
              label: 'Open in another app',
              icon: const Icon(Icons.open_in_new_rounded, size: 20, color: Colors.white),
              onPressed: () {
                OpenFilex.open(widget.file.path);
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _retry,
              child: Text(
                'Retry',
                style: DocViewTypography.labelLg.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
