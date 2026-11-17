import 'package:path/path.dart' as p;

import '../errors/app_errors.dart';

/// Validates a candidate base file name without extension against filesystem and OS restrictions.
///
/// Returns null if valid, or a [FileNameValidationError] if invalid.
FileNameValidationError? validateFileName(String baseName) {
  final trimmed = baseName.trim();
  if (trimmed.isEmpty) {
    return FileNameValidationError.empty;
  }

  if (trimmed.length > 120) {
    return FileNameValidationError.tooLong;
  }

  if (trimmed == '.' || trimmed == '..') {
    return FileNameValidationError.reservedName;
  }

  if (trimmed.startsWith('.')) {
    return FileNameValidationError.startsWithDot;
  }

  // Illegal filesystem characters: / \ : * ? " < > | and ASCII control characters (0-31, 127)
  final illegalCharRegex = RegExp(r'[\/\\:\*\?"<>\|\x00-\x1F\x7F]');
  if (illegalCharRegex.hasMatch(trimmed)) {
    return FileNameValidationError.invalidCharacters;
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
