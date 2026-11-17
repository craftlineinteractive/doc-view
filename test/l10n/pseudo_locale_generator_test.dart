import 'package:flutter_test/flutter_test.dart';
import '../../tool/pseudo_locale_engine.dart';

void main() {
  group('Pseudo-Locale Engine Unit Tests', () {
    test('transforms plain text with accented characters and expansion', () {
      const input = 'Doc View';
      final output = PseudoLocaleEngine.transform(input);

      // Must be wrapped in brackets
      expect(output.startsWith('['), isTrue);
      expect(output.endsWith(']'), isTrue);

      // Must contain accented characters
      expect(output.contains('Ð'), isTrue);
      expect(output.contains('ô'), isTrue);
      expect(output.contains('ç'), isTrue);
      expect(output.contains('Ṽ'), isTrue);

      // Must be roughly 30-50% longer than input
      expect(output.length, greaterThan((input.length * 1.3).floor()));
    });

    test('preserves simple placeholders untouched', () {
      const input = 'Page {page} of {total}';
      final output = PseudoLocaleEngine.transform(input);

      // Placeholders {page} and {total} must be present verbatim
      expect(output.contains('{page}'), isTrue);
      expect(output.contains('{total}'), isTrue);
      // Brackets around entire text
      expect(output.startsWith('['), isTrue);
      expect(output.endsWith(']'), isTrue);
    });

    test('preserves ICU plural structures and syntax', () {
      const icuInput =
          '{count, plural, =0{No files} =1{1 file} other{{count} files}}';
      final output = PseudoLocaleEngine.transform(icuInput);

      // Root ICU structure must be preserved
      expect(output.startsWith('{count, plural,'), isTrue);
      expect(output.endsWith('}'), isTrue);

      // Branches must exist
      expect(output.contains('=0{'), isTrue);
      expect(output.contains('=1{'), isTrue);
      expect(output.contains('other{'), isTrue);

      // The placeholder {count} inside other{} must be preserved intact
      expect(output.contains('{count}'), isTrue);

      // Inner branch content must be transformed with brackets and accents
      expect(output.contains('[Ñô'), isTrue);
    });

    test('handles empty and special characters safely', () {
      expect(PseudoLocaleEngine.transform(''), equals(''));
      const punctuation = '--- !!! ???';
      final output = PseudoLocaleEngine.transform(punctuation);
      expect(output.contains('--- !!! ???'), isTrue);
    });
  });
}
