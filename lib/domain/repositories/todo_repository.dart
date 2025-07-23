import 'package:todolist_flutter/domain/entities/todo.dart';

abstract class TodoRepository {
  /// Retrieves a stream of all To-Do items.
  Stream<List<Todo>> getTodos();

  /// Adds a new To-Do item with the given [task].
  Future<void> addTodo(String task);

  /// Updates an existing To-Do item.
  Future<void> updateTodo(Todo todo);

  /// Deletes a To-Do item by its [id].
  Future<void> deleteTodo(String id);
}