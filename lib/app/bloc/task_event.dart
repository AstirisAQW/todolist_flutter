part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTask extends TaskEvent {}

class AddTaskRequested extends TaskEvent {
  final String title;

  const AddTaskRequested(this.title);

  @override
  List<Object> get props => [title];
}

class UpdateTaskToggled extends TaskEvent {
  final Task task;

  const UpdateTaskToggled(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTaskPressed extends TaskEvent {
  final String id;

  const DeleteTaskPressed(this.id);

  @override
  List<Object> get props => [id];
}