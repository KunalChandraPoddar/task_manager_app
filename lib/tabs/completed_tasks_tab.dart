import 'package:flutter/material.dart';
import '../widgets/task_tile.dart';
import '../models/task_model.dart';

class CompletedTasksTab extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onToggle;

  const CompletedTasksTab({
    super.key,
    required this.tasks,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final completedTasks =
        tasks.where((t) => t.completed).toList();

    return ListView.builder(
      itemCount: completedTasks.length,
      itemBuilder: (context, index) {
        return TaskTile(
          task: completedTasks[index],
          onToggle: onToggle,
        );
      },
    );
  }
}
