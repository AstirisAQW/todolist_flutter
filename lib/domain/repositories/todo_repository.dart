import 'package:todolist_flutter/domain/entities/todo.dart';

abstract class TodoRepository {
  Stream<List<Todo>> getTodos();
  Future<void> addTodo(String task);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}