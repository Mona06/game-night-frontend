import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/create_event_cubit.dart';
import '../../cubit/create_event_state.dart';

class SliderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (BuildContext context, CreateEventState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number of participants',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            Slider(
              activeColor: Theme.of(context).colorScheme.primary,
              value: state.numberOfParticipants.toDouble(), // Use state value
              min: 0,
              max: 20,
              divisions: 20,
              label: state.numberOfParticipants.toString(),
              onChanged: (double value) {
                context
                    .read<CreateEventCubit>()
                    .updateNumberOfParticipants(value);
              },
            ),
          ],
        );
      },
    );
  }
}
