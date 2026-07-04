import 'package:flutter/material.dart';
import 'package:party_planner/src/ui/widgets/typography/styled_dropdown.dart';

class RoleSection extends StatefulWidget {
  final String? role;
  final Function(String?) onChanged;

  const RoleSection({
    super.key,
    required this.role,
    required this.onChanged,
  });

  @override
  RoleSectionState createState() => RoleSectionState();
}

class RoleSectionState extends State<RoleSection> {
  static const List<String> roleOptions = [
    'player',
    'gamemaster',
    'both',
  ];

  @override
  Widget build(BuildContext context) {
    final String? validatedRole =
        widget.role != null && roleOptions.contains(widget.role)
            ? widget.role
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Select your role',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StyledDropdown<String>(
          items: roleOptions,
          value: validatedRole,
          hint: 'Select your role',
          labelText: 'Game role',
          onChanged: (String? newRole) {
            widget.onChanged(newRole);
          },
          itemBuilder: (item) => Text(item),
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ],
    );
  }
}
