import 'package:todolist_flutter/data/datasources/todo_remote_data_source.dart';
import 'package:todolist_flutter/data/models/todo_model.dart';
import 'package:todolist_flutter/domain/entities/todo.dart';
import 'package:todolist_flutter/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Todo>> getTodos() {
    return remoteDataSource.getTodos();
  }

  @override
  Future<void> addTodo(String task) {
    return remoteDataSource.addTodo(task);
  }

  @override
  Future<void> updateTodo(Todo todo) {
    final todoModel = TodoModel(
      id: todo.id,
      task: todo.task,
      timestamp: DateTime.now(), // Update timestamp
    );
    return remoteDataSource.updateTodo(todoModel);
  }

  @override
  Future<void> deleteTodo(String id) {
    return remoteDataSource.deleteTodo(id);
  }
}