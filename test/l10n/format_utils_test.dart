// ignore_for_file: avoid_print
import 'package:docview/core/utils/format_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('FormatUtils Locale-Aware Unit Tests', () {
    test('formats file size in en (period) and de (decimal comma)', () {
      const bytes = 1450000; // ~1.4 MB
      final enSize = FormatUtils.formatFileSize(bytes, 'en');
      final deSize = FormatUtils.formatFileSize(bytes, 'de');

      expect(enSize, equals('1.4 MB'));
      expect(deSize, equals('1,4 MB'));
    });

    test('formats dates with locale awareness', () {
      final date = DateTime(2026, 11, 17, 10, 30);
      final enDate = FormatUtils.formatDate(date, 'en');
      final deDate = FormatUtils.formatDate(date, 'de');

      expect(enDate, equals('11/17/2026'));
      expect(deDate, isNotEmpty);
    });

    test('formats numbers with decimal comma in de_DE', () {
      const number = 1234567.8;
      final enNum = FormatUtils.formatNumber(number, 'en');
      final deNum = FormatUtils.formatNumber(number, 'de_DE');

      expect(enNum, equals('1,234,567.8'));
      expect(deNum, equals('1.234.567,8'));
    });

    test('behavior of Arabic digits in intl', () {
      const number = 1234.5;
      final arFormatted = NumberFormat.decimalPattern('ar').format(number);
      print('Arabic decimalPattern("ar") output: "$arFormatted"');
      // In intl 0.20+, Arabic formatting for numbers uses Eastern Arabic numerals (١٬٢٣٤٫٥) or standard Arabic symbols
      expect(arFormatted, isNotEmpty);
    });
  });
}
