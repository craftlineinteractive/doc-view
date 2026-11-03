import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../data/models/doc_file.dart';
import '../providers/providers.dart';

/// In-app PDF viewer screen with minimal chrome, page jumping, password handling, and corrupt file fallback.
class PdfViewerScreen extends ConsumerStatefulWidget {
  const PdfViewerScreen({
    required this.file,
    super.key,
  });

  final DocFile file;

  @override
  ConsumerState<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends ConsumerState<PdfViewerScreen> {
  late final PdfViewerController _controller;
  int _currentPage = 1;
  int _pageCount = 0;
  bool _hasPromptedPasswordOnce = false;

  @override
  void initState() {
    super.initState();
    _controller = PdfViewerController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String?> _showPasswordDialog() async {
    final textController = TextEditingController();
    final isRetry = _hasPromptedPasswordOnce;
    _hasPromptedPasswordOnce = true;

    final password = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(
            isRetry ? 'Incorrect Password' : 'Password Protected PDF',
            style: theme.textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isRetry
                    ? 'The password was incorrect. Please try again.'
                    : 'This document is encrypted. Please enter the password to view it.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                obscureText: true,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(null),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(textController.text),
              child: const Text('Open'),
            ),
          ],
        );
      },
    );

    if (password == null && mounted) {
      Navigator.of(context).pop();
    }
    return password;
  }

  Future<void> _showGoToPageDialog() async {
    if (_pageCount <= 1) return;

    final textController =
        TextEditingController(text: _currentPage.toString());
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Go to page'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: textController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Page (1 - $_pageCount)',
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a page number';
                }
                final page = int.tryParse(value.trim());
                if (page == null || page < 1 || page > _pageCount) {
                  return 'Enter a page between 1 and $_pageCount';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                if (formKey.currentState?.validate() ?? false) {
                  final target = int.parse(textController.text.trim());
                  _controller.goToPage(pageNumber: target);
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final target = int.parse(textController.text.trim());
                  _controller.goToPage(pageNumber: target);
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Go'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorBanner(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
    PdfDocumentRef documentRef,
  ) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.broken_image_outlined,
              size: 56,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              'Cannot display PDF',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This PDF may be corrupted, invalid, or requires an external reader.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 48),
              ),
              onPressed: () async {
                final result = await OpenFilex.open(widget.file.path);
                if (result.type != ResultType.done && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No app found to open this file'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open in another app'),
            ),
          ],
        ),
      ),
    );
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
      body: Stack(
        children: [
          PdfViewer.file(
            widget.file.path,
            controller: _controller,
            passwordProvider: _showPasswordDialog,
            params: PdfViewerParams(
              backgroundColor: theme.scaffoldBackgroundColor,
              errorBannerBuilder: _buildErrorBanner,
              onViewerReady: (document, controller) {
                if (mounted) {
                  setState(() {
                    _pageCount = document.pages.length;
                  });
                }
              },
              onPageChanged: (pageNumber) {
                if (mounted && pageNumber != null) {
                  setState(() {
                    _currentPage = pageNumber;
                  });
                }
              },
            ),
          ),

          // Page indicator pill overlay at bottom
          if (_pageCount > 0)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Material(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _showGoToPageDialog,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Text(
                        '$_currentPage / $_pageCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
