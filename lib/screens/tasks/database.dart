import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, name TEXT, description TEXT)',
        );
        await db.execute(
          'CREATE TABLE completed_tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, name TEXT, description TEXT, completion_date TEXT)',
        );
      },
      version: 3,
    );
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('tasks', task,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getTasksByDate(String date) async {
    final db = await database;
    return await db.query(
      'tasks',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  Future<int> insertCompletedTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('completed_tasks', task,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCompletedTasksByDate(
      String date) async {
    final db = await database;
    return await db.query(
      'completed_tasks',
      where: 'completion_date = ?',
      whereArgs: [date],
    );
  }

  Future<List<Map<String, dynamic>>> getAllCompletedTasks() async {
    final db = await database;
    return await db.query('completed_tasks');
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> moveTaskToCompleted(int taskId, String completionDate) async {
    final db = await database;
    final List<Map<String, dynamic>> tasks = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );

    if (tasks.isNotEmpty) {
      final task = tasks.first;
      task['completion_date'] = completionDate;
      await insertCompletedTask(task);
      return await deleteTask(taskId);
    }
    return 0;
  }
}
