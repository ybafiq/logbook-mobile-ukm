import 'package:logbook_ukm/models/logbookentry_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // ✅ Needed for join()
import 'dart:io';

class LogbookDatabaseHelper {
  static final LogbookDatabaseHelper _instance = LogbookDatabaseHelper._internal();
  factory LogbookDatabaseHelper() => _instance;
  LogbookDatabaseHelper._internal();

  static Database? _database;

  // Get or create the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'daily_logbook.db'); // ✅ Separate DB file
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _database!;
  }

  // Create logbook_entries table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE logbook_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        reflection TEXT,
        user_id TEXT
      )
    ''');
  }

  // ✅ Insert new logbook entry
  Future<int> insertLogbookEntry(LogbookEntry entry) async {
    final db = await database;
    return await db.insert('logbook_entries', entry.toMap());
  }

  // ✅ Get all logbook entries
  Future<List<LogbookEntry>> getLogbookEntries({required String userId}) async {
  final db = await database;
  final maps = await db.query(
    'logbook_entries',
    where: 'user_id = ?',
    whereArgs: [userId],
    orderBy: 'date DESC',
  );
  return maps.map((m) => LogbookEntry.fromMap(m)).toList();
}

  // ✅ Delete logbook entry by ID
  Future<int> deleteLogbookEntry(int id) async {
    final db = await database;
    return await db.delete(
      'logbook_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateLogbookEntry(LogbookEntry entry) async {
  final db = await database;

  await db.update(
    'project_entries', // <-- Make sure this matches your table name!
    entry.toMap(),
    where: 'id = ?',
    whereArgs: [entry.id],
  );
}
}

