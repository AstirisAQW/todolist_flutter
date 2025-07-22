import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_flutter/data/models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Stream<List<TodoModel>> getTodos();
  Future<void> addTodo(String task);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final CollectionReference _todoCollection =
      FirebaseFirestore.instance.collection('todos');

  @override
  Stream<List<TodoModel>> getTodos() {
    return _todoCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TodoModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Future<void> addTodo(String task) {
    final newTodo = TodoModel(task: task, timestamp: DateTime.now());
    return _todoCollection.add(newTodo.toFirestore());
  }

  @override
  Future<void> updateTodo(TodoModel todo) {
    return _todoCollection.doc(todo.id).update(todo.toFirestore());
  }

  @override
  Future<void> deleteTodo(String id) {
    return _todoCollection.doc(id).delete();
  }
}