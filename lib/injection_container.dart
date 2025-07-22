import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/data/datasources/todo_remote_data_source.dart';
import 'package:todolist_flutter/data/repositories/todo_repository_impl.dart';
import 'package:todolist_flutter/domain/repositories/todo_repository.dart';
import 'package:todolist_flutter/domain/usecases/add_todo.dart';
import 'package:todolist_flutter/domain/usecases/delete_todo.dart';
import 'package:todolist_flutter/domain/usecases/get_todos.dart';
import 'package:todolist_flutter/domain/usecases/update_todo.dart';
import 'package:todolist_flutter/presentation/bloc/todo_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => TodoBloc(
      getTodos: sl(),
      addTodo: sl(),
      updateTodo: sl(),
      deleteTodo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetTodos(sl()));
  sl.registerLazySingleton(() => AddTodo(sl()));
  sl.registerLazySingleton(() => UpdateTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(),
  );
}