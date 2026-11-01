import '../../core/constants/file_types.dart';

/// Represents a document or media file indexed in the database.
class DocFile {
  const DocFile({
    this.id,
    required this.path,
    required this.name,
    required this.extension,
    required this.sizeBytes,
    required this.modified,
    required this.category,
    this.isBookmarked = false,
    this.lastOpened,
    this.isImported = false,
  });

  final int? id;
  final String path;
  final String name;
  final String extension;
  final int sizeBytes;
  final DateTime modified;
  final FileCategory category;
  final bool isBookmarked;
  final DateTime? lastOpened;
  final bool isImported;

  /// Converts the [DocFile] instance to a SQLite-compatible map.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'path': path,
      'name': name,
      'extension': extension,
      'size_bytes': sizeBytes,
      'modified': modified.millisecondsSinceEpoch,
      'category': category.name,
      'is_bookmarked': isBookmarked ? 1 : 0,
      'last_opened': lastOpened?.millisecondsSinceEpoch,
      'is_imported': isImported ? 1 : 0,
    };
  }

  /// Creates a [DocFile] instance from a SQLite row map.
  factory DocFile.fromMap(Map<String, dynamic> map) {
    return DocFile(
      id: map['id'] as int?,
      path: map['path'] as String,
      name: map['name'] as String,
      extension: map['extension'] as String,
      sizeBytes: map['size_bytes'] as int,
      modified: DateTime.fromMillisecondsSinceEpoch(map['modified'] as int),
      category: FileCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => FileCategory.other,
      ),
      isBookmarked: (map['is_bookmarked'] as int? ?? 0) == 1,
      lastOpened: map['last_opened'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_opened'] as int)
          : null,
      isImported: (map['is_imported'] as int? ?? 0) == 1,
    );
  }

  /// Creates a copy with the given fields replaced.
  DocFile copyWith({
    int? id,
    String? path,
    String? name,
    String? extension,
    int? sizeBytes,
    DateTime? modified,
    FileCategory? category,
    bool? isBookmarked,
    DateTime? lastOpened,
    bool? isImported,
  }) {
    return DocFile(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      extension: extension ?? this.extension,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      modified: modified ?? this.modified,
      category: category ?? this.category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      lastOpened: lastOpened ?? this.lastOpened,
      isImported: isImported ?? this.isImported,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocFile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          path == other.path &&
          name == other.name &&
          extension == other.extension &&
          sizeBytes == other.sizeBytes &&
          modified == other.modified &&
          category == other.category &&
          isBookmarked == other.isBookmarked &&
          lastOpened == other.lastOpened &&
          isImported == other.isImported;

  @override
  int get hashCode =>
      id.hashCode ^
      path.hashCode ^
      name.hashCode ^
      extension.hashCode ^
      sizeBytes.hashCode ^
      modified.hashCode ^
      category.hashCode ^
      isBookmarked.hashCode ^
      lastOpened.hashCode ^
      isImported.hashCode;

  @override
  String toString() {
    return 'DocFile(id: $id, path: $path, name: $name, sizeBytes: $sizeBytes, category: ${category.name}, isBookmarked: $isBookmarked, isImported: $isImported)';
  }
}

