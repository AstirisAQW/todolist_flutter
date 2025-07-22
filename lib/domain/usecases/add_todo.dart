import 'package:todolist_flutter/domain/repositories/todo_repository.dart';

class AddTodo {
  final TodoRepository repository;

  AddTodo(this.repository);

  Future<void> call(String task) {
    return repository.addTodo(task);
  }
}