import 'package:todolist_flutter/domain/entities/todo.dart';
import 'package:todolist_flutter/domain/repositories/todo_repository.dart';

class UpdateTodo {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  Future<void> call(Todo todo) {
    return repository.updateTodo(todo);
  }
}