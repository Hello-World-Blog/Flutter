import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';
import 'package:path_provider/path_provider.dart';
//Import TaskModel

class DatabaseProvider {
  static final _databaseName = 'tasks_db.db';
  static final _databaseVersion = 1;
  static const TASKS_TABLE = 'tasks';
  static const COLUMN_ID = 'id';
  static const COLUMN_TITLE = 'title';
  static const COLUMN_START = 'start';
  static const COLUMN_END = 'end';
  static const COLUMN_PRIORITY = 'priority';
  static const COLUMN_DATE = 'date';
  static const COLUMN_COMPLETED = 'isCompleted';

  DatabaseProvider._private();

  static final DatabaseProvider db = DatabaseProvider._private();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory databasesPath = await getApplicationDocumentsDirectory();
    String path = join(databasesPath.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute("CREATE TABLE $TASKS_TABLE  ("
        "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$COLUMN_TITLE TEXT,"
        "$COLUMN_DATE TEXT,"
        "$COLUMN_START TEXT,"
        "$COLUMN_END TEXT,"
        "$COLUMN_COMPLETED INT,"
        "$COLUMN_PRIORITY INT"
        ")");
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    var tasks = await db.query(TASKS_TABLE);
    return List.generate(tasks.length, (index) {
      return TaskModel.fromMap(tasks[index]);
    });
  }

  Future<TaskModel> insert(TaskModel task) async {
    final db = await database;
    task.id = await db.insert(TASKS_TABLE, task.toMap());
    return task;
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(TASKS_TABLE, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(TaskModel task) async {
    final db = await database;
    return await db.update(TASKS_TABLE, task.toMap(),
        where: "id = ?", whereArgs: [task.id]);
  }

  Future<List<TaskModel>> getSortedtasks() async {
    final db = await database;
    var tasks = await db.rawQuery(
        'SELECT * FROM $TASKS_TABLE ORDER BY $COLUMN_DATE ASC,$COLUMN_START ASC');
    return List.generate(tasks.length, (index) {
      return TaskModel.fromMap(tasks[index]);
    });
  }

  toggleIsCompleted(TaskModel task) async {
    final db = await database;
    TaskModel completed = TaskModel(
        date: task.date,
        end: task.end,
        start: task.start,
        title: task.title,
        priority: task.priority,
        isCompleted: !task.isCompleted);
    var res = await db.update(TASKS_TABLE, completed.toMap(),
        where: "id = ?", whereArgs: [task.id]);
    return res;
  }
}
