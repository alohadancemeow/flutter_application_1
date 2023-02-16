import 'package:flutter/material.dart';
import 'package:flutter_application_1/todo_item.dart';
import 'package:flutter_application_1/states/todo_bloc.dart';
import 'package:flutter_application_1/states/todo_event.dart';
import 'package:flutter_application_1/states/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // handle close page
  void closePage(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add todo')),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: _notesController,
                ),
                BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () async {
                      TodoItem newItem = TodoItem(const Uuid().v4(),
                          _titleController.text, _notesController.text, false);

                      // add todo and fetch state
                      context.read<TodoBloc>().add(AddTodoEvent(
                          newItem.id, newItem.title, newItem.notes));
                      context.read<TodoBloc>().add(FetchTodoEvent());

                      if (!mounted) return;
                      closePage(context);
                    },
                    child: const Text('Add'),
                  );
                })
              ],
            )),
      ),
    );
  }
}
