import 'package:todolist_flutter/domain/repositories/todo_repository.dart';

class DeleteTodo {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<void> call(String id) {
    return repository.deleteTodo(id);
  }
}