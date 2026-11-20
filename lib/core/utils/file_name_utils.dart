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

/// Resolves a non-colliding destination path when restoring a file from Recycle bin.
///
/// If [originalPath] is free per [existsCheck], returns [originalPath].
/// Otherwise generates `<name> (restored).<ext>`, then `<name> (restored 2).<ext>`,
/// incrementing the counter until an available path is found.
String buildRestorePath(
  String originalPath,
  bool Function(String path) existsCheck,
) {
  if (!existsCheck(originalPath)) {
    return originalPath;
  }
  final isPosix = !originalPath.contains(r'\');
  final context = isPosix ? p.posix : p.windows;
  final dir = context.dirname(originalPath);
  final ext = context.extension(originalPath);
  final baseNameWithoutExt = context.basenameWithoutExtension(originalPath);

  // Candidate 1: "<name> (restored).<ext>"
  final candidate1 = context.join(dir, '$baseNameWithoutExt (restored)$ext');
  if (!existsCheck(candidate1)) {
    return candidate1;
  }

  // Candidate 2+: "<name> (restored 2).<ext>", "<name> (restored 3).<ext>", etc.
  var counter = 2;
  while (true) {
    final candidate =
        context.join(dir, '$baseNameWithoutExt (restored $counter)$ext');
    if (!existsCheck(candidate)) {
      return candidate;
    }
    counter++;
  }
}

