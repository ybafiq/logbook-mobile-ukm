import 'package:logbook_ukm/models/projectentry_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class ProjectDatabaseHelper {
  static final ProjectDatabaseHelper _instance = ProjectDatabaseHelper._internal();
  factory ProjectDatabaseHelper() => _instance;
  ProjectDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'project_logbook.db');
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _database!;
  }
  
  get projectId => null;

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE project_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        activity TEXT NOT NULL,
        comment TEXT,
        date TEXT NOT NULL,
        improvement TEXT,
        user_id TEXT
      )
    ''');
  }

  // ✅ Insert new project entry
  Future<int> insertProjectEntry(ProjectEntry entry) async {
    final db = await database;
    return await db.insert('project_entries', entry.toMap());
  }

  // ✅ Get all project entries (fixed)
  Future<List<ProjectEntry>> getProjectEntries({required String userId}) async {
  final db = await database;
  final maps = await db.query(
    'project_entries',
    where: 'user_id = ?',
    whereArgs: [userId],
    orderBy: 'date DESC',
  );
  return maps.map((m) => ProjectEntry.fromMap(m)).toList();
}

  // ✅ Delete project entry by ID
  Future<int> deleteProjectEntry(int id) async {
    final db = await database;
    return await db.delete(
      'project_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateProjectEntry(ProjectEntry entry) async {
  final db = await database;

  await db.update(
    'project_entries', // <-- Make sure this matches your table name!
    entry.toMap(),
    where: 'id = ?',
    whereArgs: [entry.id],
  );
}

}

