import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/task_controller.dart';
import 'controllers/user_controller.dart';

import 'views/screens/login_screen.dart';
import 'views/screens/register_screen.dart';
import 'views/screens/task_list_screen.dart';
import 'views/screens/task_form_screen.dart';
import 'views/screens/task_detail_screen.dart';
import 'models/task_model.dart'; // Import Task model

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => TaskController()),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/tasks': (_) => const TaskListScreen(),
          '/task_form': (context) {
            final task = ModalRoute.of(context)?.settings.arguments as Task?;
            return TaskFormScreen(task: task);
          },
          '/task_detail': (context) => const TaskDetailScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}