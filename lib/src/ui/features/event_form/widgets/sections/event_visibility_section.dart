import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_planner/src/ui/features/event_form/cubit/create_event_cubit.dart';

import '../../cubit/create_event_state.dart';

class EventVisibilitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (BuildContext context, CreateEventState state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Private',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Switch(
              value: state.isPublic,
              onChanged: (bool value) {
                context.read<CreateEventCubit>().updateVisibility(value);
              },
            ),
            Text(
              'Public',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        );
      },
    );
  }
}
