import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/file_types.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/doc_file.dart';
import '../../../shared/widgets/buttons/doc_buttons.dart';
import '../../../shared/widgets/tiles/doc_folded_icon.dart';
import '../../../shared/widgets/tiles/pdf_thumbnail_source.dart';
import '../open_document.dart';

/// Precision file details bottom sheet matching mockups.
/// Features a 120x150 preview, optional page count chip (only if known),
/// key-value metadata breakdown, copyable path pill, and primary Open CTA.
class FileDetailsSheet extends ConsumerWidget {
  final DocFile file;
  final int? pageCount;
  final bool showOpenButton;

  const FileDetailsSheet({
    super.key,
    required this.file,
    this.pageCount,
    this.showOpenButton = true,
  });

  /// Displays the [FileDetailsSheet] in a standard modal bottom sheet.
  static Future<void> show(
    BuildContext context,
    DocFile file, {
    int? pageCount,
    bool showOpenButton = true,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FileDetailsSheet(
        file: file,
        pageCount: pageCount,
        showOpenButton: showOpenButton,
      ),
    );
  }

  Widget _buildPreview(BuildContext context, DocViewTokens tokens) {
    Widget previewChild;

    if (file.category == FileCategory.image && File(file.path).existsSync()) {
      previewChild = Image.file(
        File(file.path),
        width: 120,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildFallbackIcon(tokens),
      );
    } else if (file.category == FileCategory.pdf &&
        File(file.path).existsSync()) {
      previewChild = FutureBuilder<ImageProvider?>(
        future: PdfThumbnailSource.instance.loadThumbnail(
          filePath: file.path,
          width: 120,
          height: 150,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image(
              image: snapshot.data!,
              width: 120,
              height: 150,
              fit: BoxFit.cover,
            );
          }
          return _buildFallbackIcon(tokens);
        },
      );
    } else {
      previewChild = _buildFallbackIcon(tokens);
    }

    return Center(
      child: Container(
        width: 120,
        height: 150,
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: tokens.hairline, width: 0.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13.5),
          child: Stack(
            fit: StackFit.expand,
            children: [
              previewChild,

              // "PG 1/N" chip overlaid at bottom-right if page count is known
              if (pageCount != null && pageCount! > 0)
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'PG 1/$pageCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(DocViewTokens tokens) {
    return Center(
      child: DocFoldedIcon(
        category: file.category,
        width: 56,
        height: 68,
        borderRadius: 8,
        foldSize: 16,
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required String value,
    required DocViewTokens tokens,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: DocViewTypography.bodySm.copyWith(
                color: tokens.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: DocViewTypography.bodyMd.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final formattedBytes = '${FormatUtils.formatFileSize(file.sizeBytes)} '
        '(${_formatBytesWithCommas(file.sizeBytes)} bytes)';

    final formattedDate =
        '${FormatUtils.formatDate(file.modified)} '
        '${file.modified.hour.toString().padLeft(2, '0')}:${file.modified.minute.toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? DocViewColors.backgroundDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
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

              // Title
              Text(
                'Document Details',
                style: DocViewTypography.headlineSm.copyWith(
                  color: tokens.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              // 120x150 Preview
              _buildPreview(context, tokens),
              const SizedBox(height: 18),

              // Key-value metadata rows
              _buildRow(label: 'Name', value: file.name, tokens: tokens),
              _buildRow(
                label: 'Type',
                value: '${file.category.label} (${file.extension.toUpperCase()})',
                tokens: tokens,
              ),
              _buildRow(label: 'Size', value: formattedBytes, tokens: tokens),
              _buildRow(label: 'Modified', value: formattedDate, tokens: tokens),
              _buildRow(
                label: 'Bookmarked',
                value: file.isBookmarked ? 'Yes' : 'No',
                tokens: tokens,
              ),

              const SizedBox(height: 6),

              // Location in selectable pill with copy button
              Text(
                'Location',
                style: DocViewTypography.bodySm.copyWith(
                  color: tokens.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: tokens.hairline, width: 0.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        file.path,
                        maxLines: 2,
                        style: DocViewTypography.bodySm.copyWith(
                          fontFamily: 'monospace',
                          color: tokens.textPrimary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy_rounded,
                        size: 18,
                        color: tokens.primaryBlue,
                      ),
                      tooltip: 'Copy path',
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: file.path));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Path copied to clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Primary CTA "Open file" (if enabled)
              if (showOpenButton)
                DocPrimaryButton(
                  label: 'Open file',
                  icon: const Icon(Icons.visibility_rounded, size: 20),
                  onPressed: () {
                    Navigator.of(context).pop();
                    openDocument(context, ref, file);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatBytesWithCommas(int bytes) {
    final str = bytes.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(',');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }
}

