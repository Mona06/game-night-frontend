import 'package:flutter/material.dart';
import 'package:party_planner/src/ui/widgets/typography/text_field.dart';

class BioSection extends StatelessWidget {
  final Function(String) onChanged;

  const BioSection({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientTextField(
          labelText: 'Bio',
          hint: 'Tell us about yourself...',
          maxLength: 500,
          maxLines: 3,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
