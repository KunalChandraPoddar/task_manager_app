import 'package:flutter/material.dart';
import 'package:task_manager_app/screens/connectivity_screen.dart';
import 'screens/home_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
      home: const HomeScreen(),
      // home: const ConnectivityScreen(),
    );
  }
}
