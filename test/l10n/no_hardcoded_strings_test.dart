// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

class _AllowlistEntry {
  final String path;
  final String pattern;
  final String reason;

  const _AllowlistEntry({
    required this.path,
    required this.pattern,
    required this.reason,
  });
}

class _PendingRewriteEntry {
  final String path;
  final String phase;
  final String reason;

  const _PendingRewriteEntry({
    required this.path,
    required this.phase,
    required this.reason,
  });
}

final List<RegExp> _hardcodedPatterns = <RegExp>[
  RegExp(r'''\bText\(\s*['"]([^'"\r\n]+)['"]'''),
  RegExp(r'''\bhintText:\s*['"]([^'"\r\n]+)['"]'''),
  RegExp(r'''\blabelText:\s*['"]([^'"\r\n]+)['"]'''),
  RegExp(r'''\btooltip:\s*['"]([^'"\r\n]+)['"]'''),
  RegExp(r'''\bsemanticsLabel:\s*['"]([^'"\r\n]+)['"]'''),
];

final RegExp _phasePattern = RegExp(r'^Phase\s+G\d+[a-z]?$');

List<_AllowlistEntry> _parseAllowlistLines(List<String> lines) {
  final entries = <_AllowlistEntry>[];
  for (final rawLine in lines) {
    final trimmed = rawLine.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final parts = trimmed.split('|').map((s) => s.trim()).toList();
    if (parts.length < 3 || parts[2].isEmpty) {
      throw FormatException(
        'Allowlist entry must have <path> | <pattern> | <reason>: $trimmed',
      );
    }
    entries.add(
      _AllowlistEntry(
        path: parts[0].replaceAll(r'\', '/'),
        pattern: parts[1],
        reason: parts[2],
      ),
    );
  }
  return entries;
}

List<_PendingRewriteEntry> _parsePendingLines(List<String> lines) {
  final entries = <_PendingRewriteEntry>[];
  for (final rawLine in lines) {
    final trimmed = rawLine.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final parts = trimmed.split('|').map((s) => s.trim()).toList();
    if (parts.length < 3) {
      throw FormatException(
        'Pending rewrite entry must have <path> | <phase> | <reason>: $trimmed',
      );
    }
    entries.add(
      _PendingRewriteEntry(
        path: parts[0].replaceAll(r'\', '/'),
        phase: parts[1],
        reason: parts[2],
      ),
    );
  }
  return entries;
}

List<String> _validatePendingEntries(
  List<_PendingRewriteEntry> entries, {
  bool Function(String path)? pathExists,
}) {
  final exists = pathExists ??
      (String p) => File(p).existsSync() || Directory(p).existsSync();
  final errors = <String>[];
  for (final entry in entries) {
    if (!_phasePattern.hasMatch(entry.phase)) {
      errors.add(
        'Pending entry "${entry.path}" must name a valid phase (e.g. "Phase G2"), got "${entry.phase}"',
      );
    }
    if (entry.reason.isEmpty) {
      errors.add('Pending entry "${entry.path}" must include a reason');
    }
    if (!exists(entry.path)) {
      errors.add(
        'Stale pending_rewrite.txt entry: "${entry.path}" no longer exists',
      );
    }
  }
  return errors;
}

/// Strips Dart string interpolations (`${...}` and `$ident`) to inspect only
/// the literal static text portion of a string expression.
String _stripInterpolations(String raw) {
  final withoutBraced = raw.replaceAll(RegExp(r'\$\{[^}]*\}'), '');
  return withoutBraced.replaceAll(RegExp(r'\$[a-zA-Z_][a-zA-Z0-9_]*'), '');
}

List<String> _scanSourceForViolations(
  String normPath,
  String content,
  List<String> fileAllowances,
) {
  if (fileAllowances.contains('ALL')) return const <String>[];
  final violations = <String>[];

  for (final regex in _hardcodedPatterns) {
    for (final match in regex.allMatches(content)) {
      final lineNum = '\n'.allMatches(content.substring(0, match.start)).length + 1;
      final lineStart = content.lastIndexOf('\n', match.start);
      final currentLinePrefix = content.substring(lineStart + 1, match.start).trimLeft();
      if (currentLinePrefix.startsWith('//') || currentLinePrefix.startsWith('///')) {
        continue;
      }

      final matchedString = match.group(1)!;
      final staticPortion = _stripInterpolations(matchedString).trim();

      // Skip empty, punctuation, numeric, or purely interpolated strings
      if (staticPortion.isEmpty) continue;
      if (!RegExp(r'[a-zA-Z]').hasMatch(staticPortion)) continue;

      bool isAllowed = false;
      for (final allowedPattern in fileAllowances) {
        if (matchedString == allowedPattern || matchedString.contains(allowedPattern)) {
          isAllowed = true;
          break;
        }
      }

      if (!isAllowed) {
        violations.add(
          '$normPath:$lineNum -> "$matchedString" (matched by ${regex.pattern})',
        );
      }
    }
  }
  return violations;
}

void main() {
  final allowlistFile = File('test/l10n/hardcoded_allowlist.txt');
  final pendingFile = File('test/l10n/pending_rewrite.txt');

  group('Inverted Guardrail: No Hardcoded Strings Across All lib/ Files', () {
    test('pending_rewrite.txt entries are valid, name a phase, and are not stale', () {
      expect(pendingFile.existsSync(), isTrue, reason: 'pending_rewrite.txt must exist');
      final pendingEntries = _parsePendingLines(pendingFile.readAsLinesSync());
      expect(pendingEntries, isNotEmpty);

      final errors = _validatePendingEntries(pendingEntries);
      expect(errors, isEmpty, reason: errors.join('\n'));
    });

    test('rejects stale pending_rewrite entry and entry missing a valid phase', () {
      final badEntries = _parsePendingLines([
        'lib/features/does_not_exist.dart | Phase G2 | Stale path',
        'lib/app.dart | soon | Missing valid phase token',
      ]);
      final errors = _validatePendingEntries(badEntries);
      expect(errors.length, 2);
      expect(errors[0], contains('Stale pending_rewrite.txt entry'));
      expect(errors[1], contains('must name a valid phase'));
    });

    test('detects hardcoded strings in files not listed in allowlist or pending_rewrite', () {
      final violations = _scanSourceForViolations(
        'lib/features/sample/sample_screen.dart',
        "Widget build(context) => const Text(\n  'Untranslated Heading',\n);",
        const <String>[],
      );
      expect(violations, hasLength(1));
      expect(violations.first, contains('Untranslated Heading'));
    });

    test('hardcoded_allowlist.txt entries exist and include reasons', () {
      expect(allowlistFile.existsSync(), isTrue, reason: 'hardcoded_allowlist.txt must exist');
      final allowlistEntries = _parseAllowlistLines(allowlistFile.readAsLinesSync());
      expect(allowlistEntries, isNotEmpty);

      for (final entry in allowlistEntries) {
        final existsAsFile = File(entry.path).existsSync();
        final existsAsDir = Directory(entry.path).existsSync();
        expect(
          existsAsFile || existsAsDir,
          isTrue,
          reason: 'Stale hardcoded_allowlist.txt entry: "${entry.path}" no longer exists',
        );
      }
    });

    test('scans ALL lib/ files by default and fails on any non-exempt hardcoded user-facing string', () {
      final allowlistEntries = _parseAllowlistLines(allowlistFile.readAsLinesSync());
      final pendingEntries = _parsePendingLines(pendingFile.readAsLinesSync());

      final allowlistByPath = <String, List<String>>{};
      for (final entry in allowlistEntries) {
        allowlistByPath.putIfAbsent(entry.path, () => []).add(entry.pattern);
      }

      bool isPendingRewrite(String normPath) {
        for (final entry in pendingEntries) {
          if (normPath == entry.path || normPath.startsWith('${entry.path}/')) {
            return true;
          }
        }
        return false;
      }

      final libDir = Directory('lib');
      expect(libDir.existsSync(), isTrue);

      final violations = <String>[];
      int scannedFiles = 0;

      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final normPath = entity.path.replaceAll(r'\', '/');

        // Exclude generated localizations and code-generated files
        if (normPath.startsWith('lib/l10n/') ||
            normPath.endsWith('.g.dart') ||
            normPath.endsWith('.freezed.dart')) {
          continue;
        }

        // Exclude pending rewrite files scheduled for G2/G3/G4
        if (isPendingRewrite(normPath)) continue;

        final fileAllowances = allowlistByPath[normPath] ?? const <String>[];
        if (fileAllowances.contains('ALL')) continue;

        scannedFiles++;
        final content = entity.readAsStringSync();
        violations.addAll(_scanSourceForViolations(normPath, content, fileAllowances));
      }

      print(
        'Inverted guardrail scan complete. Scanned $scannedFiles surviving lib/ files. Found ${violations.length} violations.',
      );
      if (violations.isNotEmpty) {
        print('--- VIOLATIONS LIST ---');
        for (final v in violations.take(30)) {
          print(v);
        }
        if (violations.length > 30) {
          print('... and ${violations.length - 30} more.');
        }
      }

      expect(scannedFiles, greaterThan(50));
      expect(violations, isEmpty);
    });
  });
}
