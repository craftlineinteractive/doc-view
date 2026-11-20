import 'package:docview/core/constants/file_types.dart';
import 'package:docview/data/models/trash_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrashItem Model Tests', () {
    final baseDeleted = DateTime(2026, 11, 20, 10, 0);
    final baseExpires = baseDeleted.add(const Duration(days: 30));

    final sample = TrashItem(
      id: 'uuid-1234',
      trashPath: '/app/support/recycle_bin/uuid-1234.pdf',
      originalPath: '/storage/documents/report.pdf',
      originalName: 'report.pdf',
      extension: 'pdf',
      sizeBytes: 1024 * 50,
      category: FileCategory.pdf,
      originalModifiedMs: baseDeleted.millisecondsSinceEpoch - 100000,
      deletedMs: baseDeleted.millisecondsSinceEpoch,
      expiresMs: baseExpires.millisecondsSinceEpoch,
      wasBookmarked: true,
      wasImported: false,
      lastOpenedMs: baseDeleted.millisecondsSinceEpoch - 50000,
    );

    test('serializes to Map and deserializes back correctly', () {
      final map = sample.toMap();
      expect(map['id'], 'uuid-1234');
      expect(map['trash_path'], '/app/support/recycle_bin/uuid-1234.pdf');
      expect(map['original_path'], '/storage/documents/report.pdf');
      expect(map['original_name'], 'report.pdf');
      expect(map['extension'], 'pdf');
      expect(map['size_bytes'], 1024 * 50);
      expect(map['category'], 'pdf');
      expect(map['was_bookmarked'], 1);
      expect(map['was_imported'], 0);
      expect(map['last_opened_ms'], sample.lastOpenedMs);

      final restored = TrashItem.fromMap(map);
      expect(restored.id, sample.id);
      expect(restored.trashPath, sample.trashPath);
      expect(restored.originalPath, sample.originalPath);
      expect(restored.originalName, sample.originalName);
      expect(restored.extension, sample.extension);
      expect(restored.sizeBytes, sample.sizeBytes);
      expect(restored.category, sample.category);
      expect(restored.wasBookmarked, isTrue);
      expect(restored.wasImported, isFalse);
      expect(restored.lastOpenedMs, sample.lastOpenedMs);
    });

    test('daysLeft calculates remaining days accurately', () {
      // Exactly at deletion time: 30 days left
      expect(sample.daysLeft(now: baseDeleted), 30);

      // 10 days later: 20 days left
      expect(sample.daysLeft(now: baseDeleted.add(const Duration(days: 10))), 20);

      // 29 days later: 1 day left
      expect(sample.daysLeft(now: baseDeleted.add(const Duration(days: 29))), 1);

      // 29 days and 23 hours later: still 1 day left (rounded up)
      expect(
        sample.daysLeft(now: baseDeleted.add(const Duration(days: 29, hours: 23))),
        1,
      );

      // Exactly at expiration time: 0 days left
      expect(sample.daysLeft(now: baseExpires), 0);

      // Past expiration: 0 days left
      expect(sample.daysLeft(now: baseExpires.add(const Duration(days: 2))), 0);
    });

    test('isExpired and isExpiringSoon predicates behave correctly', () {
      // 10 days left: not expiring soon, not expired
      final atDay10 = baseDeleted.add(const Duration(days: 10));
      expect(sample.isExpiringSoon(now: atDay10), isFalse);
      expect(sample.isExpired(now: atDay10), isFalse);

      // 3 days left: expiring soon
      final atDay27 = baseDeleted.add(const Duration(days: 27));
      expect(sample.isExpiringSoon(now: atDay27), isTrue);
      expect(sample.isExpired(now: atDay27), isFalse);

      // 1 day left: expiring soon
      final atDay29 = baseDeleted.add(const Duration(days: 29));
      expect(sample.isExpiringSoon(now: atDay29), isTrue);
      expect(sample.isExpired(now: atDay29), isFalse);

      // At expiration: expired
      expect(sample.isExpired(now: baseExpires), isTrue);
    });

    test('copyWith updates properties while retaining others', () {
      final updated = sample.copyWith(
        wasBookmarked: false,
        sizeBytes: 9999,
      );
      expect(updated.id, sample.id);
      expect(updated.wasBookmarked, isFalse);
      expect(updated.sizeBytes, 9999);
      expect(updated.trashPath, sample.trashPath);
    });
  });
}
