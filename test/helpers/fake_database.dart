import 'package:sqflite/sqflite.dart';

/// In-memory fake database implementing SQLite operations required by docview services and tests.
class FakeDatabase implements Database {
  FakeDatabase() {
    tables['files'] = [];
    tables['trash'] = [];
  }

  final Map<String, List<Map<String, dynamic>>> tables = {};
  bool _isOpen = true;

  @override
  bool get isOpen => _isOpen;

  @override
  String get path => ':memory:';

  @override
  Future<void> close() async {
    _isOpen = false;
  }

  @override
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final list = tables.putIfAbsent(table, () => []);
    final mutable = Map<String, dynamic>.from(values);
    if (!mutable.containsKey('id') || mutable['id'] == null) {
      mutable['id'] = list.length + 1;
    }
    list.add(mutable);
    return list.length;
  }

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final list = tables[table] ?? [];
    var results = list.map((e) => Map<String, Object?>.from(e)).toList();

    if (where != null && whereArgs != null) {
      if (where.contains('path = ?')) {
        final arg = whereArgs.first;
        results = results.where((r) => r['path'] == arg).toList();
      } else if (where.contains('id = ?')) {
        final arg = whereArgs.first;
        results = results.where((r) => r['id'] == arg).toList();
      } else if (where.contains('expires_ms <= ?')) {
        final arg = whereArgs.first as num;
        results = results.where((r) => (r['expires_ms'] as num) <= arg).toList();
      }
    }

    if (orderBy != null) {
      if (orderBy.contains('deleted_ms DESC')) {
        results.sort((a, b) {
          final da = (a['deleted_ms'] as num?) ?? 0;
          final db = (b['deleted_ms'] as num?) ?? 0;
          return db.compareTo(da);
        });
      }
    }

    if (limit != null && results.length > limit) {
      results = results.take(limit).toList();
    }

    return results;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final list = tables[table] ?? [];
    if (where == null) {
      final count = list.length;
      list.clear();
      return count;
    }

    var removed = 0;
    if (where.contains('id = ?') && whereArgs != null) {
      final arg = whereArgs.first;
      final before = list.length;
      list.removeWhere((r) => r['id'] == arg);
      removed = before - list.length;
    } else if (where.contains('expires_ms <= ?') && whereArgs != null) {
      final arg = whereArgs.first as num;
      final before = list.length;
      list.removeWhere((r) => (r['expires_ms'] as num) <= arg);
      removed = before - list.length;
    } else if (where.contains('path = ?') && whereArgs != null) {
      final arg = whereArgs.first;
      final before = list.length;
      list.removeWhere((r) => r['path'] == arg);
      removed = before - list.length;
    }
    return removed;
  }

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final list = tables[table] ?? [];
    var count = 0;
    for (final row in list) {
      if (where != null && where.contains('id = ?') && whereArgs != null) {
        if (row['id'] == whereArgs.first) {
          row.addAll(values);
          count++;
        }
      }
    }
    return count;
  }

  @override
  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) async {
    if (sql.contains('UPDATE trash') && sql.contains('expires_ms = expires_ms - ?')) {
      final offset = (arguments?.first as num?) ?? 0;
      final list = tables['trash'] ?? [];
      for (final row in list) {
        row['expires_ms'] = ((row['expires_ms'] as num?) ?? 0) - offset;
        row['deleted_ms'] = ((row['deleted_ms'] as num?) ?? 0) - offset;
      }
      return list.length;
    }
    return 0;
  }

  @override
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    if (sql.contains('COUNT(*) as count FROM trash')) {
      final count = tables['trash']?.length ?? 0;
      return [
        {'count': count}
      ];
    }
    return [];
  }

  @override
  Future<T> transaction<T>(
    Future<T> Function(Transaction txn) action, {
    bool? exclusive,
  }) async {
    final fakeTxn = FakeTransaction(this);
    return await action(fakeTxn);
  }

  @override
  Batch batch() => FakeBatch(this);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeTransaction implements Transaction {
  FakeTransaction(this._db);
  final FakeDatabase _db;

  @override
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) =>
      _db.insert(table, values,
          nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) =>
      _db.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) =>
      _db.delete(table, where: where, whereArgs: whereArgs);

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) =>
      _db.update(table, values,
          where: where,
          whereArgs: whereArgs,
          conflictAlgorithm: conflictAlgorithm);

  @override
  Batch batch() => FakeBatch(_db);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeBatch implements Batch {
  FakeBatch(this._db);
  final FakeDatabase _db;
  final List<Future<void> Function()> _operations = [];

  @override
  void delete(String table, {String? where, List<Object?>? whereArgs}) {
    _operations.add(() async => _db.delete(table, where: where, whereArgs: whereArgs));
  }

  @override
  Future<List<Object?>> commit({
    bool? exclusive,
    bool? noResult,
    bool? continueOnError,
  }) async {
    for (final op in _operations) {
      await op();
    }
    return [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
