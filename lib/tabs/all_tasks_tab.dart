import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/task_tile.dart';

class AllTasksTab extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onToggle;

  const AllTasksTab({
    super.key,
    required this.tasks,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskTile(
          task: tasks[index],
          onToggle: onToggle,
        );
      },
    );
  }
}
