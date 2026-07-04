import 'package:flutter/material.dart';
import 'package:party_planner/src/ui/widgets/typography/form_field.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const CustomSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      child: CustomFormField(
        fieldName: 'userSearch',
        hintText: 'Search for users',
        icon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
