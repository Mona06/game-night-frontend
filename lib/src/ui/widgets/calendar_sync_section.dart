import 'package:flutter/material.dart';

class CalendarSyncSection extends StatelessWidget {
  final bool syncToDeviceCalendar;
  final Function(bool) onChanged;

  const CalendarSyncSection({
    super.key,
    required this.syncToDeviceCalendar,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: syncToDeviceCalendar,
          onChanged: (bool? value) {
            if (value != null) {
              onChanged;
            }
          },
        ),
        Expanded(
          child: Text(
            'Add session to device calendar',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
