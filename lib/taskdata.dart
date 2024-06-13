import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseGroup {
  static final DataBaseGroup _instance = DataBaseGroup._internal();
  static Database? _database;

  factory DataBaseGroup() {
    return _instance;
  }

  DataBaseGroup._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE task_groups (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        group_id INTEGER,
        FOREIGN KEY(group_id) REFERENCES task_groups(id)
      )
    ''');
  }

  Future<int> insertTaskGroup(Map<String, dynamic> group) async {
    final db = await database;
    return await db.insert('task_groups', group);
  }

  Future<List<Map<String, dynamic>>> getTaskGroups() async {
    final db = await database;
    return await db.query('task_groups');
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getTasks(int groupId) async {
    final db = await database;
    return await db.query('tasks', where: 'group_id = ?', whereArgs: [groupId]);
  }
}
