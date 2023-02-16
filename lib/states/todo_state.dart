import 'package:flutter_application_1/todo_item.dart';

abstract class TodoState {
  TodoState();
}

class InitialTodoState extends TodoState {}

class TodoListState extends TodoState {
  List<TodoItem> todos;
  TodoListState(this.todos);
}
