import 'package:flutter/material.dart';

class DateTimeUtils {
  static String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static String formatTime(BuildContext context, TimeOfDay time) {
    return time.format(context);
  }
}
