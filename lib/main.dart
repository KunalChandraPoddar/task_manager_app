import 'package:flutter/material.dart';
import 'package:task_manager_app/services/notification_service.dart';
import 'task_manager_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const TaskManagerApp());
}

