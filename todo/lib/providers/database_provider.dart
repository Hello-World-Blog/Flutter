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
  static const COLUMN_ARCHIVED = 'isArchived';
  static const COLUMN_DELETED = 'isDeleted';
  static const COLUMN_CATEGORY = 'categoryId';
  static const CATEGORY_TABLE = "categories";
  static const CATEGORY_ID = "id";
  static const CATEGORY_NAME= "categoryName";
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
    await db.execute('''CREATE TABLE $CATEGORY_TABLE ( 
        $CATEGORY_ID INTEGER PRIMARY KEY,
        $CATEGORY_NAME TEXT
        )'''
        );
    await db.execute("CREATE TABLE $TASKS_TABLE  ("
        "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$COLUMN_TITLE TEXT,"
        "$COLUMN_DATE TEXT,"
        "$COLUMN_START INT,"
        "$COLUMN_END INT,"
        "$COLUMN_COMPLETED INT,"
        "$COLUMN_ARCHIVED INT,"
        "$COLUMN_DELETED INT,"
        "$COLUMN_PRIORITY INT,"
        "$COLUMN_CATEGORY INT,"
        "FOREIGN KEY ($COLUMN_CATEGORY) REFERENCES $CATEGORY_TABLE (id)"
        ")");
    await db.insert(CATEGORY_TABLE, {DatabaseProvider.CATEGORY_ID:1,DatabaseProvider.CATEGORY_NAME:"Personal"});
    await db.insert(CATEGORY_TABLE, {DatabaseProvider.CATEGORY_ID:2,DatabaseProvider.CATEGORY_NAME:"Social"});
    await db.insert(CATEGORY_TABLE, {DatabaseProvider.CATEGORY_ID:3,DatabaseProvider.CATEGORY_NAME:"Work"});
    await db.insert(CATEGORY_TABLE, {DatabaseProvider.CATEGORY_ID:4,DatabaseProvider.CATEGORY_NAME:"Family"});
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
    print(tasks);
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
        isArchived: task.isArchived,
        isDeleted: task.isDeleted,
        categoryId: task.categoryId,
        isCompleted: !task.isCompleted);
    var res = await db.update(TASKS_TABLE, completed.toMap(),
        where: "id = ?", whereArgs: [task.id]);
    return res;
  }
}
