import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;

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
          color: task.completed ? Colors.green : Colors.black,
          decoration:
              task.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        value: task.completed,
        activeColor: Colors.green,
        onChanged: (_) => onToggle(),
      ),
    );
  }
}
