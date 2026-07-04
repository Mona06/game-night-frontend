import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  return date != null ? DateFormat('dd-MM-yyyy').format(date) : 'N/A';
}

DateTime join(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

extension DateTimeFormatExtension on DateTime {
  String getFormattedDate() {
    return DateFormat('dd-MM-yyyy HH:mm').format(this);
  }
}
