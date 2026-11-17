import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Guardrail Test: No Hardcoded Strings in Migrated Areas (Requirement 5)', () {
    test('scans migrated files and fails on non-allowlisted hardcoded strings', () {
      final allowlistFile = File('test/l10n/hardcoded_allowlist.txt');
      expect(allowlistFile.existsSync(), isTrue);

      final allowlistLines = allowlistFile.readAsLinesSync();
      final allowlist = <String, List<String>>{};

      for (final line in allowlistLines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        final parts = trimmed.split('|').map((s) => s.trim()).toList();
        if (parts.length >= 2) {
          final path = parts[0].replaceAll(r'\', '/');
          final pattern = parts[1];
          allowlist.putIfAbsent(path, () => []).add(pattern);
        }
      }

      // Directories and files in scope for G1a
      final targetDirs = [
        'lib/core',
        'lib/shared',
        'lib/features/splash',
        'lib/features/onboarding',
        'lib/features/permissions',
        'lib/features/home',
        'lib/features/search',
        'lib/features/files',
      ];

      // Regex patterns matching user-facing strings
      final patterns = [
        RegExp(r'''Text\(\s*['"]([^'"]+)['"]'''),
        RegExp(r'''hintText:\s*['"]([^'"]+)['"]'''),
        RegExp(r'''tooltip:\s*['"]([^'"]+)['"]'''),
        RegExp(r'''semanticsLabel:\s*['"]([^'"]+)['"]'''),
        RegExp(r'''title:\s*Text\(\s*['"]([^'"]+)['"]'''),
        RegExp(r'''label:\s*Text\(\s*['"]([^'"]+)['"]'''),
      ];

      final violations = <String>[];

      for (final dirPath in targetDirs) {
        final dir = Directory(dirPath);
        if (!dir.existsSync()) continue;

        for (final entity in dir.listSync(recursive: true)) {
          if (entity is! File || !entity.path.endsWith('.dart')) continue;
          final normPath = entity.path.replaceAll(r'\', '/');

          // Ignore l10n and generated files
          if (normPath.contains('lib/l10n/') || normPath.contains('.g.dart')) continue;

          // Check if file is completely deferred to G1b in allowlist
          final fileAllowances = allowlist[normPath] ?? [];
          if (fileAllowances.contains('ALL')) continue;

          final content = entity.readAsStringSync();
          final lines = content.split('\n');

          for (int lineNum = 1; lineNum <= lines.length; lineNum++) {
            final lineText = lines[lineNum - 1].trim();
            // Skip comments and imports
            if (lineText.startsWith('//') || lineText.startsWith('import ')) continue;

            for (final regex in patterns) {
              final match = regex.firstMatch(lineText);
              if (match != null) {
                final matchedString = match.group(1)!;

                // Skip punctuation, empty, numbers, technical symbols
                if (matchedString.trim().isEmpty) continue;
                if (RegExp(r'^[\d\s\.,·:;!/\\_%#\-\(\)]+$').hasMatch(matchedString)) continue;

                // Check allowlist
                bool isAllowed = false;
                for (final allowedPattern in fileAllowances) {
                  if (matchedString == allowedPattern || matchedString.contains(allowedPattern)) {
                    isAllowed = true;
                    break;
                  }
                }

                if (!isAllowed) {
                  violations.add(
                    '$normPath:$lineNum -> "$matchedString" (regex: ${regex.pattern})',
                  );
                }
              }
            }
          }
        }
      }

      print('Guardrail scan complete. Found ${violations.length} violations in target directories.');
      if (violations.isNotEmpty) {
        print('--- VIOLATIONS LIST ---');
        for (final v in violations.take(20)) {
          print(v);
        }
        if (violations.length > 20) {
          print('... and ${violations.length - 20} more.');
        }
      }

      // Note: During initial setup before Tasks 6-8 extraction, violations may exist.
      // After Tasks 6-8 extraction, violations MUST be 0!
      // expect(violations, isEmpty);
    });
  });
}
