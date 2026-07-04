import 'package:flutter/material.dart';
import 'package:party_planner/src/ui/widgets/typography/text_field.dart';

class LocationSectionField extends StatelessWidget {
  final Function(String) onCityChanged;
  final Function(String) onCountryChanged;
  final TextEditingController? countryController;
  final TextEditingController? cityController;

  const LocationSectionField({
    super.key,
    required this.onCityChanged,
    required this.onCountryChanged,
    this.countryController,
    this.cityController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientTextField(
          labelText: 'City',
          onChanged: onCityChanged,
          controller: cityController,
        ),
        const SizedBox(height: 8),
        GradientTextField(
          labelText: 'Country',
          onChanged: onCountryChanged,
          controller: countryController,
        ),
      ],
    );
  }
}
