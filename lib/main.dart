import 'package:flutter/material.dart';
import 'package:flutter_application_1/states/todo_bloc.dart';
import 'package:flutter_application_1/states/todo_event.dart';
import 'package:flutter_application_1/todo_item.dart';
import 'package:flutter_application_1/add_todo_page.dart';
import 'package:flutter_application_1/todo_provider.dart';
import 'package:flutter_application_1/states/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => TodoBloc())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          textTheme: GoogleFonts.jetBrainsMonoTextTheme(),
          useMaterial3: true,
          // appBarTheme: const AppBarTheme(foregroundColor: Color(0xFFFFFFFF)),
        ),
        home: const MyHomePage(title: 'My todo app'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TodoProvider todoProvider = TodoProvider.instance;

  // push to addTodoPage
  void _onFabCliked() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddTodoPage()))
        .then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
        if (state is InitialTodoState) {
          context.read<TodoBloc>().add(FetchTodoEvent());
        }

        if (state is TodoListState) {
          var items = state.todos;
          return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var todoItem = items[index];

                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(),
                  secondaryBackground: Container(color: Colors.red),
                  onDismissed: (direction) {
                    // delete and fetch state
                    context.read<TodoBloc>().add(DeleteTodoEvent(items[index]));
                    context.read<TodoBloc>().add(FetchTodoEvent());
                  },
                  child: ListTile(
                    title: Text(todoItem.title),
                    subtitle: Text(todoItem.notes),
                    leading: Checkbox(
                      value: todoItem.done,
                      onChanged: (value) {
                        TodoItem updatedItem = TodoItem(todoItem.id,
                            todoItem.title, todoItem.notes, value ?? false);

                        // update and fetch state
                        context
                            .read<TodoBloc>()
                            .add(UpdateTodoEvent(updatedItem));
                        context.read<TodoBloc>().add(FetchTodoEvent());
                      },
                    ),
                  ),
                );
              });
        }

        return const Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabCliked,
        tooltip: 'add todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
