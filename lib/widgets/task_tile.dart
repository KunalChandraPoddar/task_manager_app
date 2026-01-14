// import 'package:flutter/material.dart';
// import '../models/task_model.dart';

// class TaskTile extends StatelessWidget {
//   final Task task;
//   final Function(Task) onToggle;

//   const TaskTile({super.key, required this.task, required this.onToggle});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(
//         task.title,
//         style: TextStyle(
//           decoration: task.completed ? TextDecoration.lineThrough : null,
//         ),
//       ),
//       subtitle: Text(task.dateTime.toString()),
//       trailing: Checkbox(
//         value: task.completed,
//         activeColor: Colors.green,
//         onChanged: (_) {
//           if (DateTime.now().isBefore(task.dateTime)) {
//             // Show warning
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   'You cannot complete this task before its scheduled time ⏳',
//                 ),
//                 backgroundColor: Colors.red,
//               ),
//             );
//             return;
//           }
//           onToggle(task);
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final bool isFutureTask = task.dateTime.isAfter(DateTime.now());

    return Opacity(
      opacity: isFutureTask ? 0.5 : 1.0,
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
                task.completed ? TextDecoration.lineThrough : null,
          ),
        ),

        subtitle: Text(
          DateFormat('dd MMM yyyy, hh:mm a').format(task.dateTime),
          style: TextStyle(
            color: isFutureTask ? Colors.red : Colors.grey,
          ),
        ),

        trailing: Checkbox(
          value: task.completed,
          onChanged: isFutureTask
              ? null
              : (_) => onToggle(task),
        ),

        onTap: isFutureTask
            ? null
            : () => onToggle(task),
      ),
    );
  }
}
