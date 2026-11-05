import 'package:path/path.dart' as p;

/// Validates a candidate base file name without extension against filesystem and OS restrictions.
///
/// Returns null if valid, or a user-friendly error message if invalid.
String? validateFileName(String baseName) {
  final trimmed = baseName.trim();
  if (trimmed.isEmpty) {
    return 'File name cannot be empty';
  }

  if (trimmed.length > 120) {
    return 'File name cannot exceed 120 characters';
  }

  if (trimmed == '.' || trimmed == '..') {
    return "File name cannot be '.' or '..'";
  }

  if (trimmed.startsWith('.')) {
    return 'File name cannot start with a dot';
  }

  // Illegal filesystem characters: / \ : * ? " < > | and ASCII control characters (0-31, 127)
  final illegalCharRegex = RegExp(r'[\/\\:\*\?"<>\|\x00-\x1F\x7F]');
  if (illegalCharRegex.hasMatch(trimmed)) {
    return 'File name contains invalid characters';
  }

  return null;
}

/// Constructs a new path in the same parent directory with [newBaseName],
/// strictly preserving the original file's extension.
String buildRenamedPath(String oldPath, String newBaseName) {
  final isPosix = !oldPath.contains(r'\');
  final context = isPosix ? p.posix : p.windows;
  final dir = context.dirname(oldPath);
  final ext = context.extension(oldPath);
  var cleanBase = newBaseName.trim();

  // Strip trailing extension if the user happened to type it
  if (ext.isNotEmpty && cleanBase.toLowerCase().endsWith(ext.toLowerCase())) {
    cleanBase = cleanBase.substring(0, cleanBase.length - ext.length).trim();
  }

  final newFileName = ext.isEmpty ? cleanBase : '$cleanBase$ext';
  return context.join(dir, newFileName);
}
