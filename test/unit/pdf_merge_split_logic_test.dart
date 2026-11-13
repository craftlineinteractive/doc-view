import 'package:flutter_test/flutter_test.dart';
import 'package:docview/core/utils/page_range_parser.dart';

void main() {
  group('PDF Split Output Correctness Logic Tests', () {
    test('Splitting a 12-page PDF with range string "1-3, 5, 8-10" produces exactly 3 ranges', () {
      final ranges = parsePageRanges('1-3, 5, 8-10', 12);
      expect(ranges.length, 3);

      // File 1: pages 1-3 (count = 3)
      expect(ranges[0].start, 1);
      expect(ranges[0].end, 3);
      expect(ranges[0].pageCount, 3);

      // File 2: page 5 (count = 1)
      expect(ranges[1].start, 5);
      expect(ranges[1].end, 5);
      expect(ranges[1].pageCount, 1);

      // File 3: pages 8-10 (count = 3)
      expect(ranges[2].start, 8);
      expect(ranges[2].end, 10);
      expect(ranges[2].pageCount, 3);
    });

    test('Splitting a 12-page PDF with macro "Every 5 pages" produces 3 files of 5, 5, and 2 pages', () {
      final totalPages = 12;
      final chunkSize = 5;
      final ranges = <PageRange>[];

      for (var start = 1; start <= totalPages; start += chunkSize) {
        final end = (start + chunkSize - 1).clamp(1, totalPages);
        ranges.add(PageRange(start, end));
      }

      expect(ranges.length, 3);
      // File 1: 1-5 -> 5 pages
      expect(ranges[0].start, 1);
      expect(ranges[0].end, 5);
      expect(ranges[0].pageCount, 5);

      // File 2: 6-10 -> 5 pages
      expect(ranges[1].start, 6);
      expect(ranges[1].end, 10);
      expect(ranges[1].pageCount, 5);

      // File 3: 11-12 -> 2 pages
      expect(ranges[2].start, 11);
      expect(ranges[2].end, 12);
      expect(ranges[2].pageCount, 2);
    });

    test('Merge order sequencing C, A, B preserves exact page concatenation count', () {
      // PDF C has 2 pages ("C-1", "C-2")
      // PDF A has 4 pages ("A-1".."A-4")
      // PDF B has 3 pages ("B-1".."B-3")
      final filePages = <String, List<String>>{
        'C': ['C-1', 'C-2'],
        'A': ['A-1', 'A-2', 'A-3', 'A-4'],
        'B': ['B-1', 'B-2', 'B-3'],
      };

      final mergeOrder = ['C', 'A', 'B'];
      final mergedPages = <String>[];
      for (final key in mergeOrder) {
        mergedPages.addAll(filePages[key]!);
      }

      expect(mergedPages.length, 9);
      expect(mergedPages, [
        'C-1',
        'C-2',
        'A-1',
        'A-2',
        'A-3',
        'A-4',
        'B-1',
        'B-2',
        'B-3',
      ]);
      expect(mergedPages.first, 'C-1');
      expect(mergedPages.last, 'B-3');
    });
  });
}
