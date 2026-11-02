/// Sort field enum for ordering files in the database.
enum SortField {
  date,
  name,
  size,
}

/// Sort direction enum.
enum SortDirection {
  asc,
  desc,
}

/// Model encapsulating file sorting criteria and SQL order clause generation.
class SortOption {
  const SortOption({
    required this.field,
    required this.direction,
  });

  final SortField field;
  final SortDirection direction;

  /// Default sorting option: newest modified date first.
  static const defaultOption = SortOption(
    field: SortField.date,
    direction: SortDirection.desc,
  );

  /// Returns a whitelisted SQL ORDER BY clause. User strings are never interpolated.
  String toOrderBy() {
    final dir = direction == SortDirection.asc ? 'ASC' : 'DESC';
    switch (field) {
      case SortField.date:
        return 'modified $dir';
      case SortField.name:
        return 'name COLLATE NOCASE $dir';
      case SortField.size:
        return 'size_bytes $dir';
    }
  }

  /// Creates a copy with the given fields replaced.
  SortOption copyWith({
    SortField? field,
    SortDirection? direction,
  }) {
    return SortOption(
      field: field ?? this.field,
      direction: direction ?? this.direction,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortOption &&
          runtimeType == other.runtimeType &&
          field == other.field &&
          direction == other.direction;

  @override
  int get hashCode => field.hashCode ^ direction.hashCode;

  @override
  String toString() =>
      'SortOption(field: ${field.name}, direction: ${direction.name})';
}

