import 'package:intl/intl.dart';

/// Utility methods for formatting dates, file sizes, and strings.
class FormatUtils {
  const FormatUtils._();

  static final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');

  /// Formats a [DateTime] into `MM/dd/yyyy`.
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Formats byte count into human-readable strings (e.g. 512 B, 2.4 KB, 14.8 MB).
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    }
    final gb = bytes / (1024 * 1024 * 1024);
    return '${gb.toStringAsFixed(1)} GB';
  }

  /// Combines formatted date and file size as `MM/dd/yyyy · 1.2 MB`.
  static String formatSubtitle(DateTime date, int bytes) {
    return '${formatDate(date)} · ${formatFileSize(bytes)}';
  }

  /// Formats a last scan [DateTime] into owner-specified string: "Last scan: today, 4:31 PM" or "Never scanned".
  static String formatLastScanTime(DateTime? date) {
    if (date == null) return 'Never scanned';
    final now = DateTime.now();
    final timeStr = DateFormat('h:mm a').format(date);
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Last scan: today, $timeStr';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Last scan: yesterday, $timeStr';
    }
    final dateStr = DateFormat('MMM d').format(date);
    return 'Last scan: $dateStr, $timeStr';
  }
}

/// Escapes SQLite LIKE wildcards (`%`, `_`, and `\`) for safe literal matching.
String escapeLike(String input) {
  return input
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');
}

