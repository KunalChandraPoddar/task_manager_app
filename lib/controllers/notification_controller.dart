import '../models/task_model.dart';
import '../services/notification_service.dart';

class NotificationController {
  static Future<void> init() async {
    await NotificationService.init();
  }

  static Future<void> showTaskNotification(Task task) async {
    await NotificationService.show(
      'Task Reminder',
      task.title,
    );
  }
}
