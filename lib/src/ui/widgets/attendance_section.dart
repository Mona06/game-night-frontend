import 'package:flutter/material.dart';
import 'package:party_planner/src/ui/widgets/typography/styled_dropdown.dart';

class AttendanceSection extends StatefulWidget {
  final String? attendancePreference;
  final String text;
  final Function(String?) onChanged;

  const AttendanceSection({
    super.key,
    required this.attendancePreference,
    required this.onChanged,
    required this.text,
  });

  @override
  AttendanceSectionState createState() => AttendanceSectionState();
}

class AttendanceSectionState extends State<AttendanceSection> {
  static const List<String> availabilityOptions = [
    'online',
    'onsite',
    'both',
  ];

  @override
  Widget build(BuildContext context) {
    final String? validatedAvailability = widget.attendancePreference != null &&
            availabilityOptions.contains(widget.attendancePreference)
        ? widget.attendancePreference
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StyledDropdown<String>(
          items: availabilityOptions,
          value: validatedAvailability,
          hint: 'Select your attendance',
          labelText: 'Attendance',
          onChanged: (String? newAttendance) {
            widget.onChanged(newAttendance);
          },
          itemBuilder: (item) => Text(item),
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ],
    );
  }
}
