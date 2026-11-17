import 'package:flutter/widgets.dart';

import '../errors/app_errors.dart';

/// Representation of an inclusive 1-based page range.
class PageRange {
  const PageRange(this.start, this.end)
      : assert(start >= 1, 'start must be >= 1'),
        assert(end >= start, 'end must be >= start');

  /// 1-based start page index (inclusive).
  final int start;

  /// 1-based end page index (inclusive).
  final int end;

  /// Total number of pages included in this range.
  int get pageCount => end - start + 1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageRange &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => start == end ? '$start' : '$start-$end';
}

/// Thrown when parsing page ranges fails validation.
class PageRangeParseException implements Exception {
  final PageRangeErrorReason reason;
  final String? token;
  final int? start;
  final int? end;
  final int? totalPages;

  const PageRangeParseException(
    this.reason, {
    this.token,
    this.start,
    this.end,
    this.totalPages,
  });

  /// Backward-compatible string message.
  String get message => reason.name;

  String localizedMessage(BuildContext context) =>
      reason.localizedMessage(
        context,
        token: token,
        start: start,
        end: end,
        totalPages: totalPages,
      );

  @override
  String toString() =>
      'PageRangeParseException: $reason (token: $token, range: $start-$end, total: $totalPages)';
}

/// Parses a page range string such as "1-3, 5, 8-10" against a document's [pageCount].
///
/// Rules:
/// - Rejects empty input or empty segments (e.g. trailing comma).
/// - Rejects 0 or negative numbers.
/// - Rejects reversed ranges (e.g. "5-2").
/// - Rejects pages exceeding [pageCount].
/// - Rejects non-numeric tokens.
/// - Preserves user's exact order and does not merge overlapping ranges.
List<PageRange> parsePageRanges(String input, int pageCount) {
  if (pageCount < 1) {
    throw const PageRangeParseException(PageRangeErrorReason.documentHasNoPages);
  }

  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    throw const PageRangeParseException(PageRangeErrorReason.empty);
  }

  final parts = trimmed.split(',');
  final ranges = <PageRange>[];

  for (final rawPart in parts) {
    final part = rawPart.trim();
    if (part.isEmpty) {
      throw const PageRangeParseException(PageRangeErrorReason.emptySegment);
    }

    if (part.contains('-')) {
      final rangeSegments = part.split('-');
      if (rangeSegments.length != 2) {
        throw PageRangeParseException(
          PageRangeErrorReason.invalidFormat,
          token: part,
        );
      }
      final startStr = rangeSegments[0].trim();
      final endStr = rangeSegments[1].trim();

      if (startStr.isEmpty || endStr.isEmpty) {
        throw PageRangeParseException(
          PageRangeErrorReason.incompleteRange,
          token: part,
        );
      }

      final start = int.tryParse(startStr);
      final end = int.tryParse(endStr);

      if (start == null || end == null) {
        throw PageRangeParseException(
          PageRangeErrorReason.nonNumeric,
          token: part,
        );
      }

      if (start < 1 || end < 1) {
        throw const PageRangeParseException(PageRangeErrorReason.belowMinimum);
      }

      if (start > end) {
        throw PageRangeParseException(
          PageRangeErrorReason.reversedRange,
          token: part,
          start: start,
          end: end,
        );
      }

      if (start > pageCount || end > pageCount) {
        throw PageRangeParseException(
          PageRangeErrorReason.exceedsPageCount,
          token: part,
          totalPages: pageCount,
        );
      }

      ranges.add(PageRange(start, end));
    } else {
      final page = int.tryParse(part);
      if (page == null) {
        throw PageRangeParseException(
          PageRangeErrorReason.invalidPageNumber,
          token: part,
        );
      }

      if (page < 1) {
        throw const PageRangeParseException(PageRangeErrorReason.belowMinimum);
      }

      if (page > pageCount) {
        throw PageRangeParseException(
          PageRangeErrorReason.exceedsPageCount,
          token: part,
          totalPages: pageCount,
        );
      }

      ranges.add(PageRange(page, page));
    }
  }

  return ranges;
}

/// Helper returning a [PageRangeParseException] if invalid, or null if valid.
PageRangeParseException? validatePageRanges(String input, int pageCount) {
  try {
    parsePageRanges(input, pageCount);
    return null;
  } on PageRangeParseException catch (e) {
    return e;
  } catch (_) {
    return const PageRangeParseException(PageRangeErrorReason.invalidFormat);
  }
}

