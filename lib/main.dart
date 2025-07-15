import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/bloc/task_bloc.dart';
import 'app/pages/task_list_page.dart';
import 'data/task_local_data_source.dart';
import 'data/task_repository_impl.dart';
import 'domain/repositories/task_repository.dart';
import 'domain/usecases/add_task.dart';
import 'domain/usecases/delete_task.dart';
import 'domain/usecases/get_task.dart';
import 'domain/usecases/update_task.dart';

void main() {
  // --- Dependency Injection Setup ---
  // For a larger app, consider using a service locator like get_it
  final TaskLocalDataSource taskLocalDataSource = TaskLocalDataSourceImpl();
  final TaskRepository taskRepository = TaskRepositoryImpl(localDataSource: taskLocalDataSource);

  final getTasks = GetTask(taskRepository);
  final addTask = AddTask(taskRepository);
  final updateTask = UpdateTask(taskRepository);
  final deleteTask = DeleteTask(taskRepository);
  // --- End of Dependency Injection ---

  runApp(MyApp(
    getTasks: getTasks,
    addTask: addTask,
    updateTask: updateTask,
    deleteTask: deleteTask,
  ));
}

class MyApp extends StatelessWidget {
  final GetTask getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  const MyApp({
    super.key,
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => TaskBloc(
          getTasks: getTasks,
          addTask: addTask,
          updateTask: updateTask,
          deleteTask: deleteTask,
        )..add(LoadTask()), // Initial event to load data
        child: const TaskListPage(),
      ),
    );
  }
}