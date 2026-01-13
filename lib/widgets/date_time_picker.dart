import 'package:flutter/material.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime? date;
  final TimeOfDay? time;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  const DateTimePicker({
    super.key,
    required this.date,
    required this.time,
    required this.onPickDate,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPickDate,
          child: Text(
            date == null
                ? 'Select Date'
                : date!.toLocal().toString().split(' ')[0],
          ),
        ),
        ElevatedButton(
          onPressed: onPickTime,
          child: Text(
            time == null ? 'Select Time' : time!.format(context),
          ),
        ),
      ],
    );
  }
}
