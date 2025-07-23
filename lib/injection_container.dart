import 'package:get_it/get_it.dart';
import 'package:todolist_flutter/data/datasources/todo_remote_data_source.dart';
import 'package:todolist_flutter/data/repositories/todo_repository_impl.dart';
import 'package:todolist_flutter/domain/repositories/todo_repository.dart';
import 'package:todolist_flutter/domain/usecases/add_todo.dart';
import 'package:todolist_flutter/domain/usecases/delete_todo.dart';
import 'package:todolist_flutter/domain/usecases/get_todos.dart';
import 'package:todolist_flutter/domain/usecases/update_todo.dart';
import 'package:todolist_flutter/presentation/bloc/todo_bloc.dart';

// serviceLocator is a common abbreviation for Service Locator.
final serviceLocator = GetIt.instance;

/// Initializes and registers all the dependencies for the application.
/// This function is called once at startup in main.dart.
Future<void> init() async {
  // --- Presentation Layer ---
  // BLoCs are typically registered as 'factory' because we might want a new
  // instance for a feature that has its own BLoC.
  serviceLocator.registerFactory(
    () => TodoBloc(
      getTodos: serviceLocator(),
      addTodo: serviceLocator(),
      updateTodo: serviceLocator(),
      deleteTodo: serviceLocator(),
    ),
  );

  // --- Domain Layer (Use Cases) ---
  // Use cases are registered as 'lazySingleton' because they are simple,
  // stateless classes that can be shared across the app.
  serviceLocator.registerLazySingleton(() => GetTodos(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AddTodo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateTodo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteTodo(serviceLocator()));

  // --- Data Layer (Repositories and Data Sources) ---
  // Register the repository implementation against its abstract class.
  // This allows us to depend on the abstract TodoRepository in our use cases,
  // making them independent of the data source implementation.
  serviceLocator.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  // Register the data source.
  serviceLocator.registerLazySingleton<TodoRemoteDataSource>(
    () => TodoRemoteDataSourceImpl(),
  );
}