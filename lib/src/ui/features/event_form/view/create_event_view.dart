import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:party_planner/src/ui/features/event_form/cubit/create_event_state.dart';
import 'package:party_planner/src/ui/features/event_form/widgets/sections/event_title_section.dart';
import 'package:party_planner/src/ui/features/event_form/widgets/sections/invitees_section.dart';
import 'package:party_planner/src/ui/features/event_form/widgets/sections/location_section.dart';
import 'package:party_planner/src/ui/features/event_form/widgets/sections/tasks_section.dart';
import 'package:party_planner/src/ui/widgets/attendance_section.dart';

import '../../../../core/services/calendar_service.dart';
import '../../../../core/services/event_service.dart';
import '../../../../core/services/ttrpg_service.dart';
import '../../../widgets/calendar_sync_section.dart';
import '../../../../core/models/event.dart';
import '../../../widgets/event_game_section.dart';
import '../../../widgets/nav_bar.dart';
import '../../../../ui/widgets/snackbar.dart';
import '../../../widgets/typography/btn.dart';
import '../../../../core/models/user.dart';
import '../../../../core/services/user_service.dart';
import '../cubit/create_event_cubit.dart';
import '../widgets/sections/event_description_section.dart';
import '../widgets/sections/event_visibility_section.dart';
import '../widgets/sections/image_section.dart';
import '../widgets/sections/slider_section.dart';

class CreateEventView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: TopNavigationBar(),
      body: BlocProvider<CreateEventCubit>(
        create: (BuildContext context) {
          return CreateEventCubit(
            eventService: Ioc.container.get<EventsService>(),
            ttrpgService: Ioc.container.get<TTRPGService>(),
            userService: Ioc.container.get<UserService>(),
            calendarService: Ioc.container.get<CalendarService>(),
          );
        },
        child: Builder(
          builder: (context) {
            return BlocConsumer<CreateEventCubit, CreateEventState>(
              listenWhen: (previous, current) =>
                  previous.isSuccess && !current.isSuccess,
              listener: (BuildContext context, CreateEventState state) {
                AppSnackBar.show(
                  message: 'Failed to create event',
                  type: SnackBarType.error,
                );
              },
              builder: (BuildContext context, CreateEventState state) {
                print(state.isPublic);
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventVisibilitySection(),
                      const SizedBox(
                        height: 16.0,
                      ),
                      if (state.isPublic) SliderSection(),
                      const SizedBox(
                        height: 16.0,
                      ),
                      EventTitleSection(
                        onChanged: context.read<CreateEventCubit>().updateTitle,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      EventDescriptionSection(
                        onChanged:
                            context.read<CreateEventCubit>().updateDescription,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      AttendanceSection(
                        attendancePreference: state.attendanceFormat.name,
                        onChanged: (value) {
                          context
                              .read<CreateEventCubit>()
                              .updateAttendanceFormat(value!);
                        },
                        text: 'Select attendance',
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      if (state.attendanceFormat != AttendanceFormat.online)
                        LocationSection(),
                      const SizedBox(
                        height: 16.0,
                      ),
                      if (!state.isPublic) ...[
                        InviteesSection(
                          invitees: state.invitees,
                          onDeleteUser: (UserPublic user) {
                            final updatedInvitees =
                                List<UserPublic>.from(state.invitees)
                                  ..remove(user);
                            context
                                .read<CreateEventCubit>()
                                .updateInvitees(updatedInvitees);
                          },
                          onAddUser: (UserPublic user) {
                            final updatedInvitees =
                                List<UserPublic>.from(state.invitees)
                                  ..add(user);
                            context
                                .read<CreateEventCubit>()
                                .updateInvitees(updatedInvitees);
                          },
                          hostId: state.hostId,
                        ),
                        EventTasksSection(
                          tasks: state.tasks,
                          deleteTask: (String task) {
                            state.tasks.remove(task);
                            context
                                .read<CreateEventCubit>()
                                .updateTaskList(state.tasks);
                          },
                          addTask: (String task) {
                            state.tasks.add(task);
                            context
                                .read<CreateEventCubit>()
                                .updateTaskList(state.tasks);
                          },
                          hostId: state.hostId,
                        ),
                      ],
                      const SizedBox(height: 16.0),
                      EventGameSection(),
                      const SizedBox(
                        height: 16.0,
                      ),
                      ImageSection(),
                      SizedBox(
                        height: 16.0,
                      ),
                      CalendarSyncSection(
                        syncToDeviceCalendar: state.syncToDeviceCalendar,
                        onChanged: context
                            .read<CreateEventCubit>()
                            .toggleDeviceCalendarSync,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Center(
                        child: GradientPrimaryBtn(
                          text: Text(
                            state.isSubmitting ? 'Saving...' : 'Save',
                            // 'Submit event',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: state.isValid
                              ? () {
                                  handleSubmit(context);
                                  AppSnackBar.show(
                                    message: 'Session submitted successfully',
                                    type: SnackBarType.success,
                                  );
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void handleSubmit(BuildContext context) {
    final cubit = context.read<CreateEventCubit>();
    cubit.createEvent();
  }
}
