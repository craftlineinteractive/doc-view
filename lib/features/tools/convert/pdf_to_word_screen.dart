import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

import '../../../core/constants/file_types.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../../data/services/convert/pdf_to_word_service.dart';
import '../../../shared/widgets/buttons/doc_buttons.dart';
import '../../../shared/widgets/modals/doc_modals.dart';
import '../../../shared/widgets/status/doc_status_widgets.dart';
import '../../providers/providers.dart';

/// Screen managing client-side PDF to Word (.docx) document conversion.
class PdfToWordScreen extends ConsumerStatefulWidget {
  const PdfToWordScreen({
    this.initialFile,
    this.initialPassword,
    super.key,
  });

  final DocFile? initialFile;
  final String? initialPassword;

  @override
  ConsumerState<PdfToWordScreen> createState() => _PdfToWordScreenState();
}

class _PdfToWordScreenState extends ConsumerState<PdfToWordScreen> {
  DocFile? _selectedFile;
  String? _password;
  bool _insertPageBreaks = true;
  bool _isCheckingText = false;
  PdfTextPreflightResult? _preflight;

  @override
  void initState() {
    super.initState();
    if (widget.initialFile != null) {
      _selectedFile = widget.initialFile;
      _password = widget.initialPassword;
      _runPreflight();
    }
  }

  Future<void> _runPreflight() async {
    final file = _selectedFile;
    if (file == null) return;

    setState(() {
      _isCheckingText = true;
      _preflight = null;
    });

    try {
      final service = ref.read(pdfToWordServiceProvider);
      final result = await service.checkTextLayer(
        sourcePath: file.path,
        password: _password,
      );
      if (mounted) {
        setState(() {
          _preflight = result;
          _isCheckingText = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCheckingText = false;
        });
      }
    }
  }

  Future<void> _pickFile() async {
    final result = await context.push<DocFile?>(
      '/tools/pick',
      extra: {
        'title': context.l10n.toolPdfToWord,
        'category': FileCategory.pdf,
      },
    );

    if (result != null && mounted) {
      setState(() {
        _selectedFile = result;
      });
      await _runPreflight();
    }
  }

  Future<void> _executeConversion() async {
    final file = _selectedFile;
    if (file == null) return;

    final l10n = context.l10n;
    final totalPages = _preflight?.pageCount ?? 1;

    double currentProgress = 0.0;
    StateSetter? progressSetter;

    // Show determinate progress modal
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            progressSetter = setSheetState;
            final currentPage = (currentProgress * totalPages).ceil().clamp(1, totalPages);
            return Container(
              decoration: BoxDecoration(
                color: ctx.tokens.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ProgressSheet(
                title: l10n.pdfToWordConverting,
                statusText: l10n.pdfToWordConvertingProgress(currentPage, totalPages),
                progress: currentProgress,
                onCancel: () {
                  Navigator.of(ctx).pop();
                },
              ),
            );
          },
        );
      },
    );

    try {
      final service = ref.read(pdfToWordServiceProvider);
      final outputDir = await ref.read(pdfOutputServiceProvider).getOutputDir();
      final baseName = p.basenameWithoutExtension(file.path);
      var target = File(p.join(outputDir.path, '$baseName.docx'));
      var counter = 1;
      while (target.existsSync()) {
        target = File(p.join(outputDir.path, '$baseName ($counter).docx'));
        counter++;
      }

      final outputPath = await service.convertPdfToWord(
        sourcePath: file.path,
        outputPath: target.path,
        password: _password,
        insertPageBreaks: _insertPageBreaks,
        onProgress: (prog) {
          if (mounted && progressSetter != null) {
            progressSetter!(() {
              currentProgress = prog;
            });
          }
        },
      );

      // Close progress sheet
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      final convertedFile = File(outputPath);
      final stat = await convertedFile.stat();
      final convertedDoc = DocFile(
        path: outputPath,
        name: p.basename(outputPath),
        extension: 'docx',
        sizeBytes: stat.size,
        modified: stat.modified,
        category: FileCategory.word,
        isImported: true,
      );

      // Register in DB
      await ref.read(fileRepositoryProvider).upsertBatch([convertedDoc]);

      // Invalidate file cache so converted file appears immediately
      ref.read(fileActionsControllerProvider).invalidateAll();

      if (!mounted) return;

      // Show ResultSheet
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Container(
            decoration: BoxDecoration(
              color: ctx.tokens.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ResultSheet(
                    title: l10n.pdfToWordSuccess,
                    fileName: convertedDoc.name,
                    metadata: FormatUtils.formatFileSize(convertedDoc.sizeBytes),
                    onOpen: () {
                      Navigator.of(ctx).pop();
                      context.push('/viewer', extra: convertedDoc);
                    },
                    onShare: () {
                      ref.read(fileOperationsServiceProvider).share([convertedDoc]);
                    },
                    onClose: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        key: const Key('btn_open_with'),
                        icon: const Icon(Icons.open_in_new_rounded, size: 20),
                        label: Text(l10n.pdfToWordOpenWith),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          OpenFilex.open(convertedDoc.path);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      // Close progress sheet if still open
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (!mounted) return;

      String errorText = l10n.pdfToWordGeneralError;
      if (e is PdfToWordException) {
        switch (e.reason) {
          case PdfToWordErrorReason.encrypted:
            errorText = l10n.pdfToWordEncryptedError;
            break;
          case PdfToWordErrorReason.noTextFound:
            errorText = l10n.pdfToWordNoTextMessage;
            break;
          case PdfToWordErrorReason.pageLimitExceeded:
            errorText = l10n.pdfToWordPageLimitError;
            break;
          case PdfToWordErrorReason.textLimitExceeded:
            errorText = l10n.pdfToWordTextLimitError;
            break;
          default:
            errorText = l10n.pdfToWordGeneralError;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorText),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final file = _selectedFile;

    return Scaffold(
      backgroundColor: tokens.surfaceAlt,
      appBar: AppBar(
        title: Text(l10n.pdfToWordScreenTitle),
        elevation: 0,
        backgroundColor: tokens.surface,
        foregroundColor: tokens.textPrimary,
        centerTitle: false,
      ),
      body: file == null ? _buildEmptyPicker(tokens, l10n) : _buildMainContent(tokens, l10n, file),
    );
  }

  Widget _buildEmptyPicker(DocViewTokens tokens, dynamic l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: tokens.primaryBlue.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.word,
                size: 40,
                color: tokens.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.toolPdfToWord,
              style: DocViewTypography.headlineSm.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.toolPdfToWordSub,
              textAlign: TextAlign.center,
              style: DocViewTypography.bodyMd.copyWith(color: tokens.textSecondary),
            ),
            const SizedBox(height: 32),
            DocPrimaryButton(
              key: const Key('btn_select_pdf'),
              label: l10n.pdfToWordSelectPdf,
              icon: const Icon(Icons.file_open_outlined, color: Colors.white),
              onPressed: _pickFile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(DocViewTokens tokens, dynamic l10n, DocFile file) {
    final hasNoText = _preflight != null && !_preflight!.hasText && !_preflight!.isEncrypted;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 1. PDF File Card
              Container(
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: tokens.hairline),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: Color(0xFFE53935),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: DocViewTypography.titleMd.copyWith(
                              color: tokens.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            FormatUtils.formatFileSize(file.sizeBytes),
                            style: DocViewTypography.bodySm.copyWith(
                              color: tokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      key: const Key('btn_change_file'),
                      onPressed: _pickFile,
                      child: Text(l10n.pdfToWordChangeFile),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Non-Dismissible Advisory Banner
              InfoBanner(
                message: l10n.pdfToWordBannerText,
                icon: Icons.info_outline_rounded,
              ),
              const SizedBox(height: 16),

              // 3. Scanned PDF Warning / Empty State
              if (_isCheckingText) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(tokens.primaryBlue),
                    ),
                  ),
                ),
              ] else if (hasNoText) ...[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: DocViewColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: DocViewColors.warning.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 40,
                        color: DocViewColors.warning,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.pdfToWordNoTextTitle,
                        style: DocViewTypography.titleMd.copyWith(
                          color: tokens.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.pdfToWordNoTextMessage,
                        textAlign: TextAlign.center,
                        style: DocViewTypography.bodySm.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 4. Page Break Option Switch
              Material(
                color: tokens.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: tokens.hairline),
                ),
                child: SwitchListTile.adaptive(
                  key: const Key('switch_page_breaks'),
                  title: Text(
                    l10n.pdfToWordPageBreaks,
                    style: DocViewTypography.bodyMd.copyWith(
                      color: tokens.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    l10n.pdfToWordPageBreaksSubtitle,
                    style: DocViewTypography.bodySm.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                  value: _insertPageBreaks,
                  onChanged: (val) {
                    setState(() {
                      _insertPageBreaks = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // 5. Fixed Bottom Conversion Action Button
        Container(
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            12 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: tokens.surface,
            border: Border(top: BorderSide(color: tokens.hairline)),
          ),
          child: DocPrimaryButton(
            key: const Key('btn_convert_to_word'),
            label: l10n.pdfToWordConvertAction,
            icon: const Icon(Icons.transform_rounded, color: Colors.white),
            onPressed: (hasNoText || _isCheckingText) ? null : _executeConversion,
          ),
        ),
      ],
    );
  }
}
