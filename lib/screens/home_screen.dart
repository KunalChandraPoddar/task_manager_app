import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';
import '../tabs/all_tasks_tab.dart';
import '../tabs/completed_tasks_tab.dart';
import '../tabs/stats_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Task> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _tasks = await ApiService.fetchTasks();
    setState(() => _loading = false);
  }

  void _toggleTask(Task task) async {
    setState(() {
      task.completed = !task.completed;
    });

    await ApiService.updateTaskCompletion(
      task.id,
      task.completed,
    );
  }

  Color _getSelectedColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          AllTasksTab(tasks: _tasks, onToggle: _toggleTask),
          CompletedTasksTab(tasks: _tasks, onToggle: _toggleTask),
          StatsTab(tasks: _tasks),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: _getSelectedColor(_currentIndex),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
