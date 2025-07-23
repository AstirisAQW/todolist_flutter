import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String? id; // Can be Null for new todos that don't have an ID yet.
  final String task;
  final DateTime timestamp;

  const Todo({
    this.id,
    required this.task,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, task, timestamp];
}