import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(Task) onToggle;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration:
              task.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(task.dateTime.toString()),
      trailing: Checkbox(
        value: task.completed,
        activeColor: Colors.green,
        onChanged: (_) => onToggle(task),
      ),
    );
  }
}
