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
}
