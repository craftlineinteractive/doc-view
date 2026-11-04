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
  const PageRangeParseException(this.message);

  final String message;

  @override
  String toString() => message;
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
    throw const PageRangeParseException('Document has no pages');
  }

  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    throw const PageRangeParseException('Page range cannot be empty');
  }

  final parts = trimmed.split(',');
  final ranges = <PageRange>[];

  for (final rawPart in parts) {
    final part = rawPart.trim();
    if (part.isEmpty) {
      throw const PageRangeParseException(
        'Empty range segment found. Remove extra commas.',
      );
    }

    if (part.contains('-')) {
      final rangeSegments = part.split('-');
      if (rangeSegments.length != 2) {
        throw PageRangeParseException("Invalid range format: '$part'");
      }
      final startStr = rangeSegments[0].trim();
      final endStr = rangeSegments[1].trim();

      if (startStr.isEmpty || endStr.isEmpty) {
        throw PageRangeParseException("Incomplete range: '$part'");
      }

      final start = int.tryParse(startStr);
      final end = int.tryParse(endStr);

      if (start == null || end == null) {
        throw PageRangeParseException(
          "Non-numeric values in range: '$part'",
        );
      }

      if (start < 1 || end < 1) {
        throw const PageRangeParseException(
          'Page numbers must be 1 or greater',
        );
      }

      if (start > end) {
        throw PageRangeParseException(
          "Reversed range '$part': start ($start) is greater than end ($end)",
        );
      }

      if (start > pageCount || end > pageCount) {
        throw PageRangeParseException(
          "Range '$part' exceeds total pages ($pageCount)",
        );
      }

      ranges.add(PageRange(start, end));
    } else {
      final page = int.tryParse(part);
      if (page == null) {
        throw PageRangeParseException("Invalid page number: '$part'");
      }

      if (page < 1) {
        throw const PageRangeParseException(
          'Page numbers must be 1 or greater',
        );
      }

      if (page > pageCount) {
        throw PageRangeParseException(
          "Page $page exceeds total pages ($pageCount)",
        );
      }

      ranges.add(PageRange(page, page));
    }
  }

  return ranges;
}

/// Helper returning an error message string if invalid, or null if valid.
String? validatePageRanges(String input, int pageCount) {
  try {
    parsePageRanges(input, pageCount);
    return null;
  } on PageRangeParseException catch (e) {
    return e.message;
  } catch (_) {
    return 'Invalid page range format';
  }
}

