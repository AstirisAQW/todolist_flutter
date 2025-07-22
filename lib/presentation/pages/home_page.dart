import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_flutter/domain/entities/todo.dart';
import 'package:todolist_flutter/presentation/bloc/todo_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clean To-Do List")),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoadInProgress || state is TodoInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TodoOperationFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          if (state is TodoLoadSuccess) {
            final todos = state.todos;
            if (todos.isEmpty) {
              return const Center(child: Text("No todos"));
            }
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.task),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _openTodoDialog(context, todo: todo),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<TodoBloc>()
                              .add(DeleteTodoRequested(todo.id!));
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Something went wrong."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openTodoDialog(BuildContext context, {Todo? todo}) {
    final textController = TextEditingController(text: todo?.task);
    final isEditing = todo != null;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isEditing ? "Edit Todo" : "Add Todo"),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Enter your task..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final task = textController.text.trim();
              if (task.isNotEmpty) {
                if (isEditing) {
                  // Create a new Todo object with the updated task
                  final updatedTodo = Todo(
                    id: todo.id,
                    task: task,
                    timestamp: todo.timestamp, // Keep original creation timestamp
                  );
                  context
                      .read<TodoBloc>()
                      .add(UpdateTodoRequested(updatedTodo));
                } else {
                  context.read<TodoBloc>().add(AddTodoRequested(task));
                }
                Navigator.pop(dialogContext);
              }
            },
            child: Text(isEditing ? "Update" : "Add"),
          ),
        ],
      ),
    );
  }
}