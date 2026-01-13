import '../models/task_model.dart';
import '../services/task_storage_service.dart';

class TaskController {
  List<Task> tasks = [];

  Future<void> loadTasks() async {
    tasks = await TaskStorageService.loadTasks();
  }

  Future<void> addTask(Task task) async {
    tasks.add(task);
    await TaskStorageService.saveTasks(tasks);
  }

  Future<void> toggleTask(Task task) async {
    task.completed = !task.completed;
    await TaskStorageService.saveTasks(tasks);
  }

  int get total => tasks.length;
  int get completed => tasks.where((t) => t.completed).length;
  int get pending => total - completed;
}
