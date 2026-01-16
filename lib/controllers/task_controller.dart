import '../models/task_model.dart';
import '../services/storage_service.dart';

class TaskController {
  List<Task> tasks = [];

  Future<void> loadTasks() async {
    tasks = await StorageService.loadTasks();
  }

  Future<void> addTask(Task task) async {
    tasks.add(task);
    await StorageService.saveTasks(tasks);
  }

  Future<void> toggleTask(Task task) async {
    task.completed = !task.completed;
    await StorageService.saveTasks(tasks);
  }

  int get total => tasks.length;
  int get completed => tasks.where((t) => t.completed).length;
  int get pending => total - completed;
}
