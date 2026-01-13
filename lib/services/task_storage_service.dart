import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskStorageService {
  static const _key = 'tasks';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final data = tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(_key, data);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data
        .map((e) => Task.fromJson(jsonDecode(e)))
        .toList();
  }
}