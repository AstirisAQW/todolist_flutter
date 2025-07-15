import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_task.dart';
import '../../domain/usecases/update_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTask getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final Uuid uuid;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  })  : uuid = const Uuid(),
        super(TaskInitial()) {
    on<LoadTask>(_onLoadTasks);
    on<AddTaskRequested>(_onAddTaskRequested);
    on<UpdateTaskToggled>(_onUpdateTaskToggled);
    on<DeleteTaskPressed>(_onDeleteTaskPressed);
  }

  Future<void> _onLoadTasks(LoadTask event, Emitter<TaskState> emit) async {
    emit(TaskLoadInProgress());
    try {
      final tasks = await getTasks();
      emit(TaskLoadSuccess(tasks));
    } catch (e) {
      emit(TaskLoadFailure(e.toString()));
    }
  }

  Future<void> _onAddTaskRequested(AddTaskRequested event, Emitter<TaskState> emit) async {
    if (state is TaskLoadSuccess) {
      final newTask = Task(id: uuid.v4(), title: event.title);
      await addTask(newTask);
      add(LoadTask()); // Reload the list
    }
  }

  Future<void> _onUpdateTaskToggled(UpdateTaskToggled event, Emitter<TaskState> emit) async {
    if (state is TaskLoadSuccess) {
      final updatedTask = event.task.copyWith(isCompleted: !event.task.isCompleted);
      await updateTask(updatedTask);
      add(LoadTask()); // Reload the list
    }
  }

  Future<void> _onDeleteTaskPressed(DeleteTaskPressed event, Emitter<TaskState> emit) async {
    if (state is TaskLoadSuccess) {
      await deleteTask(event.id);
      add(LoadTask()); // Reload the list
    }
  }
}