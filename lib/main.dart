import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_flutter/presentation/bloc/todo_bloc.dart';
import 'package:todolist_flutter/presentation/pages/home_page.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as dependency_injector;

void main() async {
  // Ensure that Flutter bindings are initialized before calling native code.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase for the application.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize our dependencies using the GetIt service locator.
  await dependency_injector.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clean ToDo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // BlocProvider makes the TodoBloc available to all widgets in the subtree.
      // We create it here at the top of the widget tree.
      home: BlocProvider(
        create: (_) => dependency_injector.serviceLocator<TodoBloc>()..add(LoadTodos()),
        child: const HomePage(),
      ),
    );
  }
}