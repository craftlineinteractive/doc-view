import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart' as pdfrx;

import '../../core/constants/file_types.dart';
import '../../core/utils/format_utils.dart';
import '../../core/utils/page_range_parser.dart';
import '../../data/models/doc_file.dart';
import '../providers/providers.dart';
import 'widgets/tool_error_sheet.dart';
import 'widgets/tool_progress_dialog.dart';
import 'widgets/tool_result_sheet.dart';

/// Screen enabling users to inspect page counts, define custom page ranges with live validation,
/// and split a PDF document into multiple files.
class SplitScreen extends ConsumerStatefulWidget {
  const SplitScreen({
    required this.file,
    super.key,
  });

  /// The source PDF to split.
  final DocFile file;

  @override
  ConsumerState<SplitScreen> createState() => _SplitScreenState();
}

class _SplitScreenState extends ConsumerState<SplitScreen> {
  int? _pageCount;
  bool _isLoadingInfo = true;
  String? _infoError;

  late final TextEditingController _rangeController;
  late final TextEditingController _prefixController;
  String? _rangeError;
  bool _isSplitting = false;

  @override
  void initState() {
    super.initState();
    _rangeController = TextEditingController();
    final basePrefix = p.basenameWithoutExtension(widget.file.name);
    _prefixController = TextEditingController(text: basePrefix);
    _loadDocumentDetails();
  }

  @override
  void dispose() {
    _rangeController.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  Future<void> _loadDocumentDetails() async {
    try {
      final doc = await pdfrx.PdfDocument.openFile(widget.file.path);
      if (doc.isEncrypted) {
        await doc.dispose();
        if (mounted) {
          setState(() {
            _isLoadingInfo = false;
            _infoError = '${widget.file.name} is password-protected or damaged';
          });
        }
        return;
      }
      final count = doc.pages.length;
      await doc.dispose();

      if (mounted) {
        setState(() {
          _pageCount = count;
          _isLoadingInfo = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingInfo = false;
          _infoError = '${widget.file.name} is password-protected or damaged';
        });
      }
    }
  }

  void _onRangeChanged(String text) {
    if (_pageCount == null || _pageCount! < 1) return;
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      setState(() => _rangeError = null);
      return;
    }
    setState(() {
      _rangeError = validatePageRanges(trimmed, _pageCount!);
    });
  }

  Future<void> _splitPdf() async {
    final count = _pageCount;
    if (count == null || count < 1) return;

    final trimmedRange = _rangeController.text.trim();
    final validation = validatePageRanges(trimmedRange, count);
    if (validation != null) {
      setState(() => _rangeError = validation);
      return;
    }

    final ranges = parsePageRanges(trimmedRange, count);
    final prefix = _prefixController.text.trim().isEmpty
        ? p.basenameWithoutExtension(widget.file.name)
        : _prefixController.text.trim();

    setState(() => _isSplitting = true);

    var progressDone = 0;
    final total = ranges.length;
    StateSetter? dialogSetState;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            dialogSetState = setDialogState;
            final progressValue = total > 0 ? progressDone / total : 0.0;
            return ToolProgressDialog(
              title: 'Splitting PDF',
              message: 'Generating file $progressDone of $total...',
              progress: progressValue,
            );
          },
        );
      },
    );

    try {
      final createdFiles = await ref.read(pdfSplitServiceProvider).split(
            widget.file.path,
            ranges,
            namePrefix: prefix,
            onProgress: (done, tot) {
              progressDone = done;
              dialogSetState?.call(() {});
            },
          );

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() => _isSplitting = false);

        await ToolResultSheet.show(
          context,
          files: createdFiles,
          onDone: () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() => _isSplitting = false);
        await ToolErrorSheet.show(
          context,
          title: "Couldn't split PDF",
          errorMessage: e.toString(),
          onRetry: _splitPdf,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Split PDF'),
      ),
      body: _isLoadingInfo
          ? const Center(child: CircularProgressIndicator())
          : _infoError != null
              ? Center(
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
                          _infoError!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Document Summary Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: FileCategory.pdf.color
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                FileCategory.pdf.icon,
                                color: FileCategory.pdf.color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.file.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_pageCount ?? 0} ${_pageCount == 1 ? 'page' : 'pages'} · ${FormatUtils.formatFileSize(widget.file.sizeBytes)}',
                                    style:
                                        theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Page Range Input Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Page Ranges',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _rangeController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: 'e.g. 1-3, 5, 8-10',
                                errorText: _rangeError,
                                helperText:
                                    'Separate ranges with commas. Each range becomes a new PDF.',
                                helperMaxLines: 2,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: _onRangeChanged,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'File Name Prefix',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _prefixController,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: 'Prefix for generated files',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.call_split_rounded),
            label: const Text('Split PDF'),
            onPressed: _isLoadingInfo ||
                    _infoError != null ||
                    _isSplitting ||
                    _rangeController.text.trim().isEmpty ||
                    _rangeError != null
                ? null
                : _splitPdf,
          ),
        ),
      ),
    );
  }
}

