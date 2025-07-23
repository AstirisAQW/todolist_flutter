import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_flutter/domain/entities/todo.dart';
import 'package:todolist_flutter/presentation/bloc/todo_bloc.dart';

/// The main UI screen of the application.
/// It's a StatelessWidget because all state is managed by the TodoBloc.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clean To-Do List")),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          // Handle the loading state
          if (state is TodoLoadInProgress || state is TodoInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          // Handle the error state
          if (state is TodoOperationFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          // Handle the success state
          if (state is TodoLoadSuccess) {
            final todos = state.todos;
            if (todos.isEmpty) {
              return const Center(
                child: Text("No todos yet. Add one!")
              );
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
                      // Edit button
                      IconButton(
                        onPressed: () => _openTodoDialog(context, todo: todo),
                        icon: const Icon(Icons.edit),
                      ),
                      // Delete button
                      IconButton(
                        onPressed: () {
                          // Dispatch a delete event to the BLoC
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
          // Fallback for any other unhandled state
          return const Center(child: Text("Something went wrong."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// A helper method to show the Add/Edit To-Do dialog.
  /// If a [todo] is provided, it populates the dialog for editing.
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
                    timestamp: todo.timestamp,
                  );
                  // Dispatch an update event to the BLoC
                  context
                      .read<TodoBloc>()
                      .add(UpdateTodoRequested(updatedTodo));
                } else {
                  // Dispatch an add event to the BLoC
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