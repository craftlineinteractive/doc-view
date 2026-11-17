import 'package:intl/intl.dart';

/// Utility methods for formatting dates, file sizes, numbers, and strings with locale awareness.
class FormatUtils {
  const FormatUtils._();

  /// Formats a [DateTime] into `MM/dd/yyyy` (or per-locale format if specified).
  static String formatDate(DateTime date, [String? locale]) {
    try {
      return DateFormat('MM/dd/yyyy', locale).format(date);
    } catch (_) {
      // Fallback if locale data is not loaded in current environment
      return DateFormat('MM/dd/yyyy').format(date);
    }
  }

  /// Formats a number with locale-aware thousand and decimal separators (e.g. 1,234.5 in en vs 1.234,5 in de).
  static String formatNumber(num value, [String? locale]) {
    return NumberFormat.decimalPattern(locale).format(value);
  }

  /// Formats byte count into human-readable strings (e.g. 512 B, 2.4 KB, 14.8 MB) using the active [locale].
  static String formatFileSize(int bytes, [String? locale]) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) {
      final intFormatter = NumberFormat.decimalPattern(locale);
      return '${intFormatter.format(bytes)} B';
    }
    final formatter = NumberFormat('#,##0.0', locale);
    if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${formatter.format(kb)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      final mb = bytes / (1024 * 1024);
      return '${formatter.format(mb)} MB';
    }
    final gb = bytes / (1024 * 1024 * 1024);
    return '${formatter.format(gb)} GB';
  }

  /// Combines formatted date and file size as `MM/dd/yyyy · 1.2 MB` (using decimal comma where appropriate).
  static String formatSubtitle(DateTime date, int bytes, [String? locale]) {
    return '${formatDate(date, locale)} · ${formatFileSize(bytes, locale)}';
  }

  /// Formats a last scan [DateTime] with localized strings: e.g. "Last scan: today, 4:31 PM" or "Never scanned".
  static String formatLastScanTime(
    DateTime? date, {
    String? locale,
    String todayLabel = 'today',
    String yesterdayLabel = 'yesterday',
    String neverScannedLabel = 'Never scanned',
    String lastScanPrefix = 'Last scan:',
  }) {
    if (date == null) return neverScannedLabel;
    final now = DateTime.now();
    String timeStr;
    try {
      timeStr = DateFormat('h:mm a', locale).format(date);
    } catch (_) {
      timeStr = DateFormat('h:mm a').format(date);
    }
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return '$lastScanPrefix $todayLabel, $timeStr';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return '$lastScanPrefix $yesterdayLabel, $timeStr';
    }
    String dateStr;
    try {
      dateStr = DateFormat('MMM d', locale).format(date);
    } catch (_) {
      dateStr = DateFormat('MMM d').format(date);
    }
    return '$lastScanPrefix $dateStr, $timeStr';
  }
}

/// Escapes SQLite LIKE wildcards (`%`, `_`, and `\`) for safe literal matching.
String escapeLike(String input) {
  return input
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');
}
