import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AddTaskTab extends StatefulWidget {
  final Function(Task) onAddTask;

  const AddTaskTab({super.key, required this.onAddTask});

  @override
  State<AddTaskTab> createState() => _AddTaskTabState();
}

class _AddTaskTabState extends State<AddTaskTab> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _submit() {
    if (_controller.text.trim().isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      _showError('All fields are required');
      return;
    }

    Future<void> _pickTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),

        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );

      if (picked != null) {
        setState(() => _selectedTime = picked);
      }
    }

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    widget.onAddTask(
      Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _controller.text.trim(),
        dateTime: dateTime,
      ),
    );

    _controller.clear();
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task added successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Task Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                initialDate: DateTime.now(),
              );
              if (date != null) setState(() => _selectedDate = date);
            },
            child: Text(
              _selectedDate == null
                  ? 'Select Date'
                  : _selectedDate!.toLocal().toString().split(' ')[0],
            ),
          ),

          const SizedBox(height: 8),

          ElevatedButton(
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) setState(() => _selectedTime = time);
            },
            child: Text(
              _selectedTime == null
                  ? 'Select Time'
                  : _selectedTime!.format(context),
            ),
          ),

          const Spacer(),

          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Add Task',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
