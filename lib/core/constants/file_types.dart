import 'package:flutter/material.dart';

/// Categories of supported document and media files.
enum FileCategory {
  pdf,
  word,
  excel,
  ppt,
  txt,
  image,
  other;

  /// Human-readable label for UI displays.
  String get label {
    switch (this) {
      case FileCategory.pdf:
        return 'PDF';
      case FileCategory.word:
        return 'Word';
      case FileCategory.excel:
        return 'Excel';
      case FileCategory.ppt:
        return 'PPT';
      case FileCategory.txt:
        return 'TXT';
      case FileCategory.image:
        return 'Image';
      case FileCategory.other:
        return 'Other';
    }
  }

  /// Distinct icon per file category.
  IconData get icon {
    switch (this) {
      case FileCategory.pdf:
        return Icons.picture_as_pdf_rounded;
      case FileCategory.word:
        return Icons.description_rounded;
      case FileCategory.excel:
        return Icons.table_chart_rounded;
      case FileCategory.ppt:
        return Icons.slideshow_rounded;
      case FileCategory.txt:
        return Icons.text_snippet_rounded;
      case FileCategory.image:
        return Icons.image_rounded;
      case FileCategory.other:
        return Icons.insert_drive_file_rounded;
    }
  }

  /// Theme color per category.
  Color get color {
    switch (this) {
      case FileCategory.pdf:
        return const Color(0xFFE53935); // Red
      case FileCategory.word:
        return const Color(0xFF1E88E5); // Blue
      case FileCategory.excel:
        return const Color(0xFF43A047); // Green
      case FileCategory.ppt:
        return const Color(0xFFFB8C00); // Orange
      case FileCategory.txt:
        return const Color(0xFF607D8B); // Grey-Blue
      case FileCategory.image:
        return const Color(0xFFFBC02D); // Yellow / Gold
      case FileCategory.other:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
}

/// Mapping from lowercase file extensions to their corresponding [FileCategory].
const Map<String, FileCategory> _extensionToCategoryMap = {
  // PDF
  'pdf': FileCategory.pdf,

  // Word
  'doc': FileCategory.word,
  'docx': FileCategory.word,
  'odt': FileCategory.word,
  'rtf': FileCategory.word,

  // Excel
  'xls': FileCategory.excel,
  'xlsx': FileCategory.excel,
  'csv': FileCategory.excel,
  'ods': FileCategory.excel,

  // PPT
  'ppt': FileCategory.ppt,
  'pptx': FileCategory.ppt,
  'odp': FileCategory.ppt,

  // TXT
  'txt': FileCategory.txt,
  'md': FileCategory.txt,
  'log': FileCategory.txt,

  // Image
  'jpg': FileCategory.image,
  'jpeg': FileCategory.image,
  'png': FileCategory.image,
  'webp': FileCategory.image,
  'gif': FileCategory.image,
  'bmp': FileCategory.image,
};

/// All supported extensions recognized by the scanner and picker.
final Set<String> supportedFileExtensions =
    Set<String>.unmodifiable(_extensionToCategoryMap.keys);

/// File extensions supported by the in-app Office viewer.
const Set<String> officeViewerExtensions = {
  'docx',
  'docm',
  'xlsx',
  'xlsm',
  'pptx',
  'pptm',
  'xls',
  'csv',
  'tsv',
  'rtf',
  'doc',
  'ppt',
};

/// Returns whether [path] has an extension supported by the in-app Office viewer.
bool isOfficeViewerSupported(String path) {
  final lastDot = path.lastIndexOf('.');
  if (lastDot == -1 || lastDot == path.length - 1) {
    return false;
  }
  final ext = path.substring(lastDot + 1).toLowerCase();
  return officeViewerExtensions.contains(ext);
}

/// Resolves a [FileCategory] from a file path or file name.
/// Returns `null` for unsupported file extensions so they are ignored.
FileCategory? categoryFromPath(String path) {
  final lastDot = path.lastIndexOf('.');
  if (lastDot == -1 || lastDot == path.length - 1) {
    return null;
  }

  // If path starts with dot and has no other dot (e.g. ".gitignore"), ignore
  final lastSeparator = path.lastIndexOf(RegExp(r'[/\\]'));
  if (lastSeparator != -1 && lastDot == lastSeparator + 1) {
    return null;
  }

  final ext = path.substring(lastDot + 1).toLowerCase();
  return _extensionToCategoryMap[ext];
}
