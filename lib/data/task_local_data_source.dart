import '../../domain/entities/task.dart';

// In a real app, this would be a database (SQLite, Hive) or an API client.
abstract class TaskLocalDataSource {
  Future<List<Task>> getTask();
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {

  final List<Task> _task = [

  ];

  @override
  Future<List<Task>> getTask() async {
    return List.from(_task);
  }

  @override
  Future<void> addTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _task.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _task.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _task[index] = task;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _task.removeWhere((task) => task.id == id);
  }
}