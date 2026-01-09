import 'package:flutter/material.dart';
import '../models/task_model.dart';

class StatsTab extends StatelessWidget {
  final List<Task> tasks;

  const StatsTab({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.completed).length;
    final pending = total - completed;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _stat(
            label: 'Total Tasks',
            value: total,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _stat(
            label: 'Completed Tasks',
            value: completed,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          _stat(
            label: 'Pending Tasks',
            value: pending,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _stat({
    required String label,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
