import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import './task_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getTask() {
    return localDataSource.getTask();
  }
  
  @override
  Future<void> addTask(Task task) {
    return localDataSource.addTask(task);
  }

  @override
  Future<void> updateTask(Task task) {
    return localDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) {
    return localDataSource.deleteTask(id);
  }
}