import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTask {
  final TaskRepository repository;

  GetTask(this.repository);

  Future<List<Task>> call() {
    return repository.getTask();
  }
}