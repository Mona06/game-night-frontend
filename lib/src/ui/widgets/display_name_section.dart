import 'package:flutter/material.dart';
import 'package:party_planner/src/ui/widgets/typography/text_field.dart';

class DisplayNameSection extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController? controller;
  final String? caption;

  const DisplayNameSection({
    super.key,
    required this.onChanged,
    this.controller,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (caption != null)
          Text(
            caption!,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 18.0),
          ),
        SizedBox(height: 8.0),
        GradientTextField(
          controller: controller,
          labelText: 'Display Name',
          maxLength: 30,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
