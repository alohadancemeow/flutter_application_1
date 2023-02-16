import 'package:flutter_application_1/todo_item.dart';

abstract class TodoEvent {
  TodoEvent();
}

// Add todo
class AddTodoEvent extends TodoEvent {
  String id;
  String title;
  String notes;

  AddTodoEvent(this.id, this.title, this.notes);
}

// Fetch todo
class FetchTodoEvent extends TodoEvent {
  FetchTodoEvent();
}

// Update todo
class UpdateTodoEvent extends TodoEvent {
  TodoItem item;
  UpdateTodoEvent(this.item);
}

// Delete todo
class DeleteTodoEvent extends TodoEvent {
  TodoItem item;
  DeleteTodoEvent(this.item);
}
