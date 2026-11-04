import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';

import '../../core/constants/file_types.dart';
import '../../data/models/doc_file.dart';
import '../providers/providers.dart';
import 'image_viewer_screen.dart';
import 'office_viewer_screen.dart';
import 'pdf_viewer_screen.dart';
import 'txt_viewer_screen.dart';

/// Central dispatcher for the `/viewer` route.
///
/// Verifies file existence on disk, deletes missing files from the database with a notification,
/// routes supported formats (PDF, Image, TXT, and Office formats) to dedicated viewers, and
/// delegates unsupported formats (ODT, ODS, ODP, Other) to external system apps via [OpenFilex].
class ViewerScreen extends ConsumerStatefulWidget {
  const ViewerScreen({
    required this.file,
    super.key,
  });

  final DocFile file;

  @override
  ConsumerState<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends ConsumerState<ViewerScreen> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _verifyAndRoute());
  }

  Future<void> _verifyAndRoute() async {
    final fileOnDisk = File(widget.file.path);
    final exists = await fileOnDisk.exists();

    if (!exists) {
      if (widget.file.id != null) {
        await ref
            .read(fileActionsControllerProvider)
            .deleteFile(widget.file.id!);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File no longer exists')),
        );
        Navigator.of(context).pop();
      }
      return;
    }

    // Supported formats in-app: PDF, Image, TXT, and supported Office extensions
    final isSupportedInApp = widget.file.category == FileCategory.pdf ||
        widget.file.category == FileCategory.image ||
        widget.file.category == FileCategory.txt ||
        isOfficeViewerSupported(widget.file.path);

    if (!isSupportedInApp) {
      final result = await OpenFilex.open(widget.file.path);
      if (mounted) {
        Navigator.of(context).pop();
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No app found to open this file')),
          );
        }
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (isOfficeViewerSupported(widget.file.path)) {
      return OfficeViewerScreen(file: widget.file);
    }

    switch (widget.file.category) {
      case FileCategory.pdf:
        return PdfViewerScreen(file: widget.file);
      case FileCategory.image:
        return ImageViewerScreen(file: widget.file);
      case FileCategory.txt:
        return TxtViewerScreen(file: widget.file);
      case FileCategory.word:
      case FileCategory.excel:
      case FileCategory.ppt:
      case FileCategory.other:
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: const SizedBox.shrink(),
        );
    }
  }
}
