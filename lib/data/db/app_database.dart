import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// SQLite database singleton manager for caching indexed documents.
class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase instance = AppDatabase._internal();

  static const String databaseName = 'doc_reader.db';
  static const int databaseVersion = 2;

  static const String tableFiles = 'files';

  Database? _database;

  /// Returns the existing [Database] instance or initializes a new one.
  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, databaseName);

    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableFiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        extension TEXT NOT NULL,
        size_bytes INTEGER NOT NULL,
        modified INTEGER NOT NULL,
        category TEXT NOT NULL,
        is_bookmarked INTEGER DEFAULT 0,
        last_opened INTEGER,
        is_imported INTEGER DEFAULT 0
      )
    ''');

    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_files_category ON $tableFiles (category)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_files_name ON $tableFiles (name)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_files_bookmarked ON $tableFiles (is_bookmarked)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_files_last_opened ON $tableFiles (last_opened)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_files_bookmarked ON $tableFiles (is_bookmarked)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_files_last_opened ON $tableFiles (last_opened)',
      );
    }
  }

  /// Closes the database connection.
  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }
}
