part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoadInProgress extends TodoState {}

class TodoLoadSuccess extends TodoState {
  final List<Todo> todos;

  const TodoLoadSuccess([this.todos = const []]);

  @override
  List<Object> get props => [todos];
}

class TodoOperationFailure extends TodoState {
  final String error;

  const TodoOperationFailure(this.error);

  @override
  List<Object> get props => [error];
}