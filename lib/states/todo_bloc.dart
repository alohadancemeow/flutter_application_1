import 'package:flutter_application_1/todo_item.dart';
import 'package:flutter_application_1/states/todo_event.dart';
import 'package:flutter_application_1/todo_provider.dart';
import 'package:flutter_application_1/states/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoProvider todoProvider = TodoProvider.instance;

  TodoBloc() : super(InitialTodoState()) {
    List<TodoItem> todos = [];

    on<AddTodoEvent>((event, emit) async => await todoProvider
        .insertTodo(TodoItem(event.id, event.title, event.notes, false)));

    on<UpdateTodoEvent>(
        (event, emit) async => await todoProvider.updateTodo(event.item));

    on<DeleteTodoEvent>(
        (event, emit) async => await todoProvider.deleteTodo(event.item));

    on<FetchTodoEvent>((event, emit) async {
      todos = await todoProvider.fetchTodos();
      emit(TodoListState(todos));
    });
  }
}
