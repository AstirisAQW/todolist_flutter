import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todolist_flutter/domain/entities/todo.dart';
import 'package:todolist_flutter/domain/usecases/add_todo.dart';
import 'package:todolist_flutter/domain/usecases/delete_todo.dart';
import 'package:todolist_flutter/domain/usecases/get_todos.dart';
import 'package:todolist_flutter/domain/usecases/update_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;

  StreamSubscription? _todosSubscription;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.updateTodo,
    required this.deleteTodo,
  }) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<_TodosUpdated>(_onTodosUpdated);
    on<AddTodoRequested>(_onAddTodoRequested);
    on<UpdateTodoRequested>(_onUpdateTodoRequested);
    on<DeleteTodoRequested>(_onDeleteTodoRequested);
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) {
    emit(TodoLoadInProgress());
    _todosSubscription?.cancel();
    _todosSubscription = getTodos().listen(
      (todos) => add(_TodosUpdated(todos)),
      onError: (_) => emit(const TodoOperationFailure("Failed to load todos")),
    );
  }

  void _onTodosUpdated(_TodosUpdated event, Emitter<TodoState> emit) {
    emit(TodoLoadSuccess(event.todos));
  }

  Future<void> _onAddTodoRequested(
      AddTodoRequested event, Emitter<TodoState> emit) async {
    try {
      await addTodo(event.task);
      // State will update automatically via the stream listener
    } catch (_) {
      emit(const TodoOperationFailure("Failed to add todo"));
    }
  }

  Future<void> _onUpdateTodoRequested(
      UpdateTodoRequested event, Emitter<TodoState> emit) async {
    try {
      await updateTodo(event.todo);
    } catch (_) {
      emit(const TodoOperationFailure("Failed to update todo"));
    }
  }

  Future<void> _onDeleteTodoRequested(
      DeleteTodoRequested event, Emitter<TodoState> emit) async {
    try {
      await deleteTodo(event.id);
    } catch (_) {
      emit(const TodoOperationFailure("Failed to delete todo"));
    }
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}