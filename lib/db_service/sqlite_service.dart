import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteService {
  static final SQLiteService _instance = SQLiteService._();
  static Database? _database;

  SQLiteService._();

  factory SQLiteService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE PersonalTask (id TEXT PRIMARY KEY, work TEXT, done INTEGER)',
        );
        await db.execute(
          'CREATE TABLE Done (id TEXT PRIMARY KEY, work TEXT)',
        );
      },
    );
  }

  Future<void> addPersonalTask(Map<String, dynamic> taskData) async {
    final db = await database;
    await db.insert('PersonalTask', taskData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchTasks(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<void> updateTask(String id, Map<String, dynamic> updatedData) async {
    final db = await database;
    await db.update('PersonalTask', updatedData, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteTask(String id, String tableName) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
