import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/doc_view_colors.dart';
import '../../../core/theme/doc_view_tokens.dart';
import '../../../core/theme/doc_view_typography.dart';

/// "Go to page" jump dialog with inline validation (1 to N) and clean styling.
class PdfGoToPageDialog extends StatefulWidget {
  final int currentPage;
  final int pageCount;

  const PdfGoToPageDialog({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  static Future<int?> show(
    BuildContext context, {
    required int currentPage,
    required int pageCount,
  }) {
    return showDialog<int?>(
      context: context,
      builder: (context) => PdfGoToPageDialog(
        currentPage: currentPage,
        pageCount: pageCount,
      ),
    );
  }

  @override
  State<PdfGoToPageDialog> createState() => _PdfGoToPageDialogState();
}

class _PdfGoToPageDialogState extends State<PdfGoToPageDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentPage.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorText = 'Enter a page number';
      });
      return;
    }

    final page = int.tryParse(text);
    if (page == null || page < 1 || page > widget.pageCount) {
      setState(() {
        _errorText = 'Enter a page between 1 and ${widget.pageCount}';
      });
      return;
    }

    Navigator.of(context).pop(page);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? DocViewColors.backgroundDark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Title & page count pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Go to page',
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
                    color: tokens.blueTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '1 — ${widget.pageCount}',
                    style: DocViewTypography.labelXs.copyWith(
                      color: tokens.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Number field
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _errorText != null
                      ? const Color(0xFFE5484D)
                      : tokens.hairline,
                  width: _errorText != null ? 1.5 : 0.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                  color: tokens.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter a page between 1 and ${widget.pageCount}',
                  hintStyle: TextStyle(
                    color: tokens.textSecondary.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (_) {
                  if (_errorText != null) {
                    setState(() {
                      _errorText = null;
                    });
                  }
                },
                onSubmitted: (_) => _submit(),
              ),
            ),

            // Inline error
            if (_errorText != null) ...[
              const SizedBox(height: 6),
              Text(
                _errorText!,
                style: const TextStyle(
                  color: Color(0xFFE5484D),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Actions: Cancel & Go
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: tokens.textPrimary,
                        side: BorderSide(color: tokens.hairline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: tokens.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Go'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

