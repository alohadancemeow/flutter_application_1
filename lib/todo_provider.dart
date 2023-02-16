import 'package:flutter_application_1/todo_item.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class TodoProvider {
  static const todo_item_table = 'TodoItemTable';
  static TodoProvider instance = TodoProvider();

  // Open database
  Future<Database> database() async {
    return await openDatabase(p.join(await getDatabasesPath(), 'todo_item.db'),
        version: 1, onCreate: (db, version) async {
      const String sql =
          "CREATE TABLE $todo_item_table (id TEXT PRIMARY KEY, title TEXT, notes TEXT, done INTEGER)";
      await db.execute(sql);
    });
  }

  // get all todos
  Future<List<TodoItem>> fetchTodos() async {
    Database db = await database();
    List<Map<dynamic, dynamic>> todos = await db.query(todo_item_table);

    return todos.map((e) => TodoItem.fromMap(e)).toList();
  }

  // add todo
  Future<void> insertTodo(TodoItem item) async {
    Database db = await database();
    await db.insert(todo_item_table, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // update todo
  Future<void> updateTodo(TodoItem item) async {
    Database db = await database();
    await db.update(todo_item_table, item.toMap(),
        where: "id = ?",
        whereArgs: [item.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // delete todo
  Future<void> deleteTodo(TodoItem item) async {
    Database db = await database();
    await db.delete(todo_item_table, where: "id = ?", whereArgs: [item.id]);
  }
}
