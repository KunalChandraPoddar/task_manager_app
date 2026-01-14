import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_storage_service.dart';
import '../tabs/all_tasks_tab.dart';
import '../tabs/completed_tasks_tab.dart';
import '../tabs/add_task_tab.dart';
import '../tabs/stats_tab.dart';
import 'dart:async';
import '../services/notification_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Task> _tasks = [];
  bool _loading = true;
  Timer? _timer;


  @override
void initState() {
  super.initState();
  _loadTasks();
  _startNotificationChecker();
}
String formatDateTime12(DateTime dateTime) {
  return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
}


void _startNotificationChecker() {
  _timer = Timer.periodic(const Duration(minutes: 1), (_) {
    final now = DateTime.now();

    for (final task in _tasks) {
      if (!task.completed &&
          now.year == task.dateTime.year &&
          now.month == task.dateTime.month &&
          now.day == task.dateTime.day &&
          now.hour == task.dateTime.hour &&
          now.minute == task.dateTime.minute) {
        NotificationService.showNotification(task.title);
      }
    }
  });
}

@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}


  Future<void> _loadTasks() async {
    _tasks = await TaskStorageService.loadTasks();
    setState(() => _loading = false);
  }

  void _addTask(Task task) async {
    setState(() {
      _tasks.add(task);
    });
    await TaskStorageService.saveTasks(_tasks);
  }


  void _toggleTask(Task task) async {
  final now = DateTime.now();

  if (task.dateTime.isAfter(now)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("You can't complete a task before its scheduled time"),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  setState(() {
    task.completed = !task.completed;
  });

  await TaskStorageService.saveTasks(_tasks);
}


  Color _getSelectedColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.purple;
      case 3:
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
          AddTaskTab(onAddTask: _addTask),
          StatsTab(tasks: _tasks),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: _getSelectedColor(_currentIndex),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }
}
