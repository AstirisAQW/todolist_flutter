import 'package:todolist_flutter/domain/entities/todo.dart';
import 'package:todolist_flutter/domain/repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Stream<List<Todo>> call() {
    return repository.getTodos();
  }
}