import 'package:flutter/material.dart';
import 'package:task_manager_app/controllers/notification_controller.dart';
import 'package:task_manager_app/services/storage_service.dart';
import '../models/task_model.dart';
import '../services/connectivity_service.dart';
import '../tabs/all_tasks_tab.dart';
import '../tabs/completed_tasks_tab.dart';
import '../tabs/add_task_tab.dart';
import '../tabs/stats_tab.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  IconData _connectionIcon = Icons.wifi;
  Color _connectionColor = Colors.green;
  Timer? _timer;

  int _currentIndex = 0;
  List<Task> _tasks = [];
  bool _loading = true;

  late final ConnectivityService _connectivityService;

  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();
    _loadTasks();
    _listenConnectivity();
    _startNotificationChecker();
  }

  void _startNotificationChecker() {
  _timer?.cancel();

  _timer = Timer.periodic(const Duration(seconds: 30), (_) {
    final now = DateTime.now();

    for (final task in _tasks) {
      if (!task.completed &&
          !task.notified &&
          now.isAfter(task.dateTime)) {
        NotificationController.showTaskNotification(task);

        setState(() {
          task.notified = true;
        });

        StorageService.saveTasks(_tasks);
      }
    }
  });
}

  void _listenConnectivity() {
    _connectivityService.stream.listen((status) {
      String message;

      switch (status) {
        case ConnectionStatus.wifiOn:
          message = 'Wi-Fi turned ON';
          _connectionIcon = Icons.wifi;
          _connectionColor = Colors.green;
          break;

        case ConnectionStatus.wifiOff:
          message = 'Wi-Fi turned OFF';
          _connectionIcon = Icons.wifi_off;
          _connectionColor = Colors.red;
          break;

        case ConnectionStatus.mobileOn:
          message = 'Mobile data turned ON';
          _connectionIcon = Icons.signal_cellular_alt;
          _connectionColor = Colors.green;
          break;

        case ConnectionStatus.mobileOff:
          message = 'Mobile data turned OFF';
          _connectionIcon = Icons.signal_cellular_off;
          _connectionColor = Colors.red;
          break;

        case ConnectionStatus.offline:
          message = 'No internet connection';
          _connectionIcon = Icons.cloud_off;
          _connectionColor = Colors.red;
          break;
      }

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: _connectionColor,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await StorageService.loadTasks();
      setState(() {
        _tasks = tasks;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      setState(() {
        _tasks = [];
        _loading = false;
      });
    }
  }

  @override
void dispose() {
  _timer?.cancel();
  _connectivityService.dispose();
  super.dispose();
}


  void _addTask(Task task) async {
    setState(() {
      _tasks.add(task);
      _currentIndex = 0;
    });
    await StorageService.saveTasks(_tasks);
  }

  void _toggleTask(Task task) async {
    if (DateTime.now().isBefore(task.dateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot complete task before scheduled time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => task.completed = !task.completed);
    await StorageService.saveTasks(_tasks);
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(_connectionIcon, color: _connectionColor),
          ),
        ],
      ),

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
            icon: Icon(Icons.check_circle),
            label: 'Completed',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }
}
