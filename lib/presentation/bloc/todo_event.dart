part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodoRequested extends TodoEvent {
  final String task;

  const AddTodoRequested(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTodoRequested extends TodoEvent {
  final Todo todo;

  const UpdateTodoRequested(this.todo);

  @override
  List<Object> get props => [todo];
}

class DeleteTodoRequested extends TodoEvent {
  final String id;

  const DeleteTodoRequested(this.id);

  @override
  List<Object> get props => [id];
}

// Internal event to update the BLoC state when the stream emits new data
class _TodosUpdated extends TodoEvent {
  final List<Todo> todos;

  const _TodosUpdated(this.todos);

  @override
  List<Object> get props => [todos];
}