import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:intl/intl.dart';

import 'package:party_planner/src/ui/features/event_form/widgets/sections/tasks_section.dart';
import 'package:party_planner/src/ui/widgets/timeslot_card.dart';
import 'package:party_planner/src/ui/widgets/typography/text_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/format.dart';
import '../../../../core/helpers/validator.dart';
import '../../../../core/models/event.dart';
import '../../../../core/services/event_service.dart';
import '../../../../ui/widgets/snackbar.dart';
import '../../../widgets/typography/btn.dart';
import '../../../../core/models/timeslot.dart';
import '../../../../core/models/user.dart';
import '../../../../core/services/user_service.dart';
import '../../event_form/widgets/sections/invitees_section.dart';
import '../cubit/event_details_cubit.dart';
import '../cubit/event_details_state.dart';

class EventDetailView extends StatelessWidget {
  final EventRead event;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  EventDetailView({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventDetailCubit(
        Ioc.container.get<EventsService>(),
      )..fetchEvent(event.id),
      child: Builder(
        builder: (context) {
          return BlocBuilder<EventDetailCubit, EventDetailState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final isHost = state.hostId ==
                  Ioc.container.get<UserService>().currentUser?.id;
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Session Details',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    if (isHost)
                      IconButton(
                        icon: Icon(
                          state.isEditing
                              ? Icons.check_outlined
                              : Icons.edit_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          if (state.isEditing) {
                            // context.read<EventDetailCubit>().updateEventDetails(
                            //       title: titleController.text,
                            //       description: descriptionController.text,
                            //     );
                          } else {
                            titleController.text = state.title;
                            descriptionController.text =
                                state.description ?? '';
                            context.read<EventDetailCubit>().toggleEditing();
                          }
                        },
                      ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // _buildCoverImage(),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: getImageData(state.coverImageBase64) != null
                            ? Image.memory(
                                getImageData(state.coverImageBase64)!,
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 300,
                                width: double.infinity,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            state.isEditing
                                ? GradientTextField(
                                    labelText: 'Title',
                                    controller: titleController,
                                  )
                                : Text(
                                    state.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                            const SizedBox(height: 16),
                            if (state.isEditing)
                              GradientTextField(
                                controller: descriptionController,
                                maxLines: null,
                              )
                            else if (state.description != null)
                              Text(
                                state.description!,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            const SizedBox(height: 16),
                            // if (state.description != null) ...[
                            //   Text(
                            //     state.description!,
                            //     style: Theme.of(context).textTheme.bodyLarge,
                            //   ),
                            //   const SizedBox(height: 16),
                            // ],
                            if (state.location != null) ...[
                              _buildLocationSection(context, state),
                              const SizedBox(height: 16),
                            ],
                            _buildAttendanceSection(context, state),
                            if (state.startDateTime != null) ...[
                              _buildDateTimeSection(context, state),
                              const SizedBox(height: 16),
                            ],
                            if (state.participants != null) ...[
                              _buildParticipantsSection(context, state),
                              const SizedBox(height: 16),
                            ],
                            if (!state.isPublic) ...[
                              EventTasksSection(
                                tasks: state.tasks,
                                deleteTask: (String task) {
                                  state.tasks?.remove(task);
                                  context
                                      .read<EventDetailCubit>()
                                      .updateTasks(state.tasks);
                                },
                                addTask: (String task) {
                                  state.tasks?.add(task);
                                  context
                                      .read<EventDetailCubit>()
                                      .updateTasks(state.tasks);
                                },
                                hostId: state.hostId,
                              ),
                              const SizedBox(height: 16),
                            ],
                            if (!state.isPublic)
                              InviteesSection(
                                invitees: state.invitees
                                    .where((user) => user.id != state.hostId)
                                    .toList(),
                                hostId: state.hostId,
                                title: 'Participants',
                                onDeleteUser: (UserPublic user) {
                                  final updatedParticipants =
                                      List<UserPublic>.from(state.invitees)
                                        ..remove(user);
                                  context
                                      .read<EventDetailCubit>()
                                      .updateInvitees(updatedParticipants);
                                },
                                onAddUser: (UserPublic user) {
                                  final updatedParticipants =
                                      List<UserPublic>.from(
                                    state.participants ?? [],
                                  )..add(user);
                                  context
                                      .read<EventDetailCubit>()
                                      .updateInvitees(updatedParticipants);
                                },
                              ),
                            if (!state.isPublic) ...[
                              _buildTimeslots(context, state),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: _buildBottomNavigationBar(context, state),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    EventDetailState state,
  ) {
    final isHost =
        state.hostId == Ioc.container.get<UserService>().currentUser?.id;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!state.isPublic && state.status == EventDetailStatus.recruiting)
            SolidPrimaryBtn(
              text: Text(
                'Save',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              onPressed: () {},
            ),
          if (!state.isPublic && state.status == EventDetailStatus.finalized)
            SolidPrimaryBtn(
              text: Text(
                'Attendance',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              onPressed: () {},
            ),
          if (state.isPublic &&
              state.status == EventDetailStatus.recruiting &&
              state.startDateTime != null &&
              state.endDateTime != null)
            SecondaryBtn(
              text: Text(
                'Share',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              onPressed: () {
                // context.read<EventDetailCubit>().shareEvent(event.id);
              },
            ),
          SizedBox(
            width: 10,
          ),
          if (state.isPublic &&
              state.status == EventDetailStatus.recruiting &&
              !isHost)
            SolidPrimaryBtn(
              text: Text(
                'Join',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              onPressed: () {
                context.read<EventDetailCubit>().joinEvent(event.id);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(
    BuildContext context,
    EventDetailState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            if (state.location != null)
              Expanded(
                child: Text(
                  state.location!.address,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            Spacer(),
            if (state.location?.longitude != null &&
                state.location?.latitude != null)
              TertiaryBtn(
                text: Text(
                  'Navigate',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                onPressed: () {
                  _navigateToLocation(context, state);
                },
              ),
            Expanded(
              child: Text(
                state.attendanceFormat,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildAttendanceSection(BuildContext context, EventDetailState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        const SizedBox(
          height: 8,
        ),
        if (state.attendanceFormat == 'both') Text('Online'),
        Text('Onsite'),
        if (state.attendanceFormat != 'both') Text(state.attendanceFormat),
        const SizedBox(height: 16.0),
      ],
    );
  }

  // Widget _buildTasksSection(BuildContext context, EventDetailState state) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             'Tasks',
  //             style: Theme.of(context).textTheme.displaySmall?.copyWith(
  //                   fontSize: 18,
  //                   color: Theme.of(context).colorScheme.onPrimaryContainer,
  //                 ),
  //           ),
  //           const SizedBox(height: 8),
  //           // _buildAddTaskButton(context),
  //         ],
  //       ),
  //       const SizedBox(height: 8),
  //       Wrap(
  //         spacing: 8,
  //         runSpacing: 8,
  //         children: state.tasks!.map((task) {
  //           return SecondaryBadge(
  //             label: task,
  //             onDelete: () {
  //               context.read<EventDetailCubit>().updateTasks(
  //                     state.tasks!.where((t) => t != task).toList(),
  //                   );
  //             },
  //           );
  //         }).toList(),
  //       ),
  //       const SizedBox(height: 16),
  //     ],
  //   );
  // }

  Widget _buildDateTimeSection(BuildContext context, EventDetailState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.access_time_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '${state.startDateTime?.day}/${state.startDateTime?.month}/${state.startDateTime?.year}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  void _showCreateTimeslotDialog(
    BuildContext context,
    EventDetailState state,
  ) {
    final eventDetailCubit = context.read<EventDetailCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return BlocProvider<EventDetailCubit>.value(
          value: eventDetailCubit,
          child: TimeslotPicker(
            onTimeslotCreated: (TimeslotItem newTimeslot) {
              state.timeslots.add(newTimeslot);
              context.read<EventDetailCubit>().updateTimeslots(
                    state.timeslots,
                  );
            },
          ),
        );
      },
    );
  }

  Widget _buildTimeslots(BuildContext context, EventDetailState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Timeslots',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            TertiaryBtn(
              icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
              text: Text(
                'New',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                _showCreateTimeslotDialog(context, state);
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.timeslots.length,
            itemBuilder: (context, index) {
              return TimeslotCard(
                isSelected: index == 0,
                timeslot: state.timeslots[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsSection(
    BuildContext context,
    EventDetailState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Participants',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '${state.participants?.length ?? 0} participants',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (state.openSpots > 0)
          Text(
            '${state.openSpots} spots remaining',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
      ],
    );
  }

  Future<void> _navigateToLocation(
    BuildContext context,
    EventDetailState state,
  ) async {
    if (state.location?.latitude == null || state.location?.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location not available')),
      );
      return;
    }
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${state.location?.latitude},${state.location?.longitude}';

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch navigation';
      }
    } catch (e) {
      AppSnackBar.show(
        message: 'Could not launch navigation',
        type: SnackBarType.error,
      );
    }
  }
}

class TimeslotPicker extends StatefulWidget {
  final Function(TimeslotItem) onTimeslotCreated;

  const TimeslotPicker({
    super.key,
    required this.onTimeslotCreated,
  });

  @override
  State<TimeslotPicker> createState() => _TimeslotPickerState();
}

class _TimeslotPickerState extends State<TimeslotPicker> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Add New Timeslot',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar
                  Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 5.0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      side: BorderSide(),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('MMMM yyyy').format(_selectedDate),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        CalendarDatePicker2(
                          config: CalendarDatePicker2Config(
                            calendarType: CalendarDatePicker2Type.single,
                            selectedDayHighlightColor:
                                Theme.of(context).primaryColor,
                          ),
                          value: [_selectedDate],
                          onValueChanged: (dates) {
                            if (dates.isNotEmpty && dates[0] != null) {
                              setState(() {
                                _selectedDate = DateTime(
                                  dates[0]!.year,
                                  dates[0]!.month,
                                  dates[0]!.day,
                                  _selectedDate.hour,
                                  _selectedDate.minute,
                                );
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      join(_selectedDate, _selectedTime).getFormattedDate(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextBtn(
                  text: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 16),
                SolidPrimaryBtn(
                  text: const Text('Create Timeslot'),
                  onPressed: () {
                    var selectedDateTime = join(_selectedDate, _selectedTime);
                    final timeslot = TimeslotItem(
                      id: '',
                      dateTime: selectedDateTime,
                      votes: 1,
                    );
                    print(timeslot.dateTime);
                    widget.onTimeslotCreated(timeslot);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
