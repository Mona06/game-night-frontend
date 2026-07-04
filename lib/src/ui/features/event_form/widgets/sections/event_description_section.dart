import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/validator.dart';
import '../../../../widgets/typography/text_field.dart';
import '../../cubit/create_event_cubit.dart';
import '../../cubit/create_event_state.dart';

class EventDescriptionSection extends StatelessWidget with Validator {
  final Function(String) onChanged;

  const EventDescriptionSection({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (BuildContext context, CreateEventState state) {
        return GradientTextField(
          labelText: 'Description',
          maxLength: 150,
          onChanged: onChanged,
        );
      },
    );
  }
}
