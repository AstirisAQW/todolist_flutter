import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_flutter/domain/entities/todo.dart';

/// methods for converting to and from Firestore's data format. This keeps the
class TodoModel extends Todo {
  const TodoModel({
    String? id,
    required String task,
    required DateTime timestamp,
  }) : super(id: id, task: task, timestamp: timestamp);

  /// Creates a [TodoModel] instance from a Firestore [DocumentSnapshot].
  factory TodoModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TodoModel(
      id: doc.id,
      task: data['task'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  /// Converts this [TodoModel] instance into a Map suitable for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'task': task,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}