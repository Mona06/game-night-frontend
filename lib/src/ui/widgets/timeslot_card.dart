import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/models/timeslot.dart';
import '../features/events/cubit/event_details_cubit.dart';

class TimeslotCard extends StatefulWidget {
  final TimeslotItem timeslot;
  final bool isSelected;

  // final VoidCallback onTap;

  const TimeslotCard({
    super.key,
    required this.timeslot,
    required this.isSelected,
    // required this.onTap,
  });

  @override
  State<TimeslotCard> createState() => _TimeslotCardState();
}

class _TimeslotCardState extends State<TimeslotCard> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    final eventDetailCubit = context.read<EventDetailCubit>();

    return GestureDetector(
      onTap: () {
        handleOnTap(eventDetailCubit);
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerLow,
          border: Border.all(
            color: _isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEEE').format(widget.timeslot.dateTime),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: _isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              DateFormat('d MMM').format(widget.timeslot.dateTime),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: _isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.timeslot.votes} votes',
              style: TextStyle(
                color: _isSelected
                    ? Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withValues(alpha: 0.8)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleOnTap(EventDetailCubit cubit) {
    setState(() {
      _isSelected = !_isSelected;
    });

    final updatedTimeslots = cubit.state.timeslots.map((timeslot) {
      if (timeslot.id == widget.timeslot.id) {
        return TimeslotItem(
          id: timeslot.id,
          dateTime: timeslot.dateTime,
          votes: _isSelected ? timeslot.votes + 1 : timeslot.votes - 1,
        );
      }
      return timeslot;
    }).toList();

    cubit.updateTimeslots(updatedTimeslots);
  }
}
