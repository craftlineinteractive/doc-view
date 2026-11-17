// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'pseudo_locale_engine.dart';

void main() {
  final enFile = File('lib/l10n/app_en.arb');
  if (!enFile.existsSync()) {
    stderr.writeln('Error: lib/l10n/app_en.arb not found.');
    exit(1);
  }

  final content = enFile.readAsStringSync();
  final Map<String, dynamic> data = json.decode(content) as Map<String, dynamic>;
  final Map<String, dynamic> pseudoData = {};

  for (final entry in data.entries) {
    final key = entry.key;
    final value = entry.value;

    if (key == '@@locale') {
      pseudoData[key] = 'en_XA';
    } else if (key.startsWith('@')) {
      // Metadata object: copy as is
      pseudoData[key] = value;
    } else if (value is String) {
      pseudoData[key] = PseudoLocaleEngine.transform(value);
    } else {
      pseudoData[key] = value;
    }
  }

  final outFile = File('lib/l10n/app_en_XA.arb');
  const encoder = JsonEncoder.withIndent('  ');
  outFile.writeAsStringSync('${encoder.convert(pseudoData)}\n');
  print('Successfully generated lib/l10n/app_en_XA.arb with ${pseudoData.length} entries.');
}
