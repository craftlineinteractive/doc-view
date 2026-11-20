import '../../core/constants/file_types.dart';

/// Represents a document moved to the Recycle bin.
class TrashItem {
  final String id;
  final String trashPath;
  final String originalPath;
  final String originalName;
  final String extension;
  final int sizeBytes;
  final FileCategory category;
  final int originalModifiedMs;
  final int deletedMs;
  final int expiresMs;
  final bool wasBookmarked;
  final bool wasImported;
  final int? lastOpenedMs;

  const TrashItem({
    required this.id,
    required this.trashPath,
    required this.originalPath,
    required this.originalName,
    required this.extension,
    required this.sizeBytes,
    required this.category,
    required this.originalModifiedMs,
    required this.deletedMs,
    required this.expiresMs,
    required this.wasBookmarked,
    required this.wasImported,
    this.lastOpenedMs,
  });

  /// Calculates remaining retention days before auto-purge.
  /// Partial days round up to 1 day. Expired items return 0.
  int daysLeft({DateTime? now}) {
    final currentMs = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final diffMs = expiresMs - currentMs;
    if (diffMs <= 0) return 0;
    return (diffMs / (24 * 60 * 60 * 1000)).ceil();
  }

  /// Whether this item has passed its expiration timestamp.
  bool isExpired({DateTime? now}) {
    final currentMs = (now ?? DateTime.now()).millisecondsSinceEpoch;
    return currentMs >= expiresMs;
  }

  /// Whether this item has 3 or fewer days remaining before permanent deletion.
  bool isExpiringSoon({DateTime? now}) => daysLeft(now: now) <= 3;

  /// Serialization to SQLite map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trash_path': trashPath,
      'original_path': originalPath,
      'original_name': originalName,
      'extension': extension,
      'size_bytes': sizeBytes,
      'category': category.name,
      'original_modified_ms': originalModifiedMs,
      'deleted_ms': deletedMs,
      'expires_ms': expiresMs,
      'was_bookmarked': wasBookmarked ? 1 : 0,
      'was_imported': wasImported ? 1 : 0,
      'last_opened_ms': lastOpenedMs,
    };
  }

  /// Deserialization from SQLite map.
  factory TrashItem.fromMap(Map<String, dynamic> map) {
    return TrashItem(
      id: map['id'] as String,
      trashPath: map['trash_path'] as String,
      originalPath: map['original_path'] as String,
      originalName: map['original_name'] as String,
      extension: map['extension'] as String,
      sizeBytes: (map['size_bytes'] as num).toInt(),
      category: FileCategory.values.byName(map['category'] as String),
      originalModifiedMs: (map['original_modified_ms'] as num).toInt(),
      deletedMs: (map['deleted_ms'] as num).toInt(),
      expiresMs: (map['expires_ms'] as num).toInt(),
      wasBookmarked: (map['was_bookmarked'] as int? ?? 0) == 1,
      wasImported: (map['was_imported'] as int? ?? 0) == 1,
      lastOpenedMs: (map['last_opened_ms'] as num?)?.toInt(),
    );
  }

  TrashItem copyWith({
    String? id,
    String? trashPath,
    String? originalPath,
    String? originalName,
    String? extension,
    int? sizeBytes,
    FileCategory? category,
    int? originalModifiedMs,
    int? deletedMs,
    int? expiresMs,
    bool? wasBookmarked,
    bool? wasImported,
    int? lastOpenedMs,
  }) {
    return TrashItem(
      id: id ?? this.id,
      trashPath: trashPath ?? this.trashPath,
      originalPath: originalPath ?? this.originalPath,
      originalName: originalName ?? this.originalName,
      extension: extension ?? this.extension,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      category: category ?? this.category,
      originalModifiedMs: originalModifiedMs ?? this.originalModifiedMs,
      deletedMs: deletedMs ?? this.deletedMs,
      expiresMs: expiresMs ?? this.expiresMs,
      wasBookmarked: wasBookmarked ?? this.wasBookmarked,
      wasImported: wasImported ?? this.wasImported,
      lastOpenedMs: lastOpenedMs ?? this.lastOpenedMs,
    );
  }
}
