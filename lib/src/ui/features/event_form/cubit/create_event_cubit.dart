import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:party_planner/src/core/models/event.dart';
import 'package:party_planner/src/ui/features/event_form/cubit/create_event_state.dart';

import '../../../../core/services/calendar_service.dart';
import '../../../../core/services/event_service.dart';
import '../../../../core/services/ttrpg_service.dart';
import '../../../../ui/widgets/snackbar.dart';
import '../../../../core/models/ttrpg.dart';
import '../../../../core/models/user.dart';
import '../../../../core/services/user_service.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  final EventsService _eventService;
  final CalendarService _calendarService;
  final TTRPGService _ttrpgService;

  CreateEventCubit({
    required EventsService eventService,
    required TTRPGService ttrpgService,
    required UserService userService,
    required CalendarService calendarService,
  })  : _eventService = eventService,
        _ttrpgService = ttrpgService,
        _calendarService = calendarService,
        super(
          CreateEventState(
            isPublic: true,
            title: '',
            description: '',
            hostId: userService.currentUser!.id,
            startDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
            endDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
            invitees: [],
            tasks: [],
            image: null,
            openSpots: 0,
            syncToDeviceCalendar: false,
            selectedGame: null,
            numberOfParticipants: 0,
            attendanceFormat: AttendanceFormat.online,
          ),
        );

  Future<String> retrieveTTRPGs() async {
    final result =
        await Future.wait(_ttrpgService.getAllTTRPGs() as Iterable<Future>);
    final List games = result.map((ttrpg) {
      return ttrpg.name;
    }).toList();
    return games[0];
  }

  void updateVisibility(bool isPublic) {
    emit(state.copyWith(isPublic: isPublic));
  }

  void updateDescription(String updatedDescription) {
    emit(state.copyWith(description: updatedDescription));
  }

  void updateTitle(String updatedTitle) {
    emit(state.copyWith(title: updatedTitle));
  }

  void updateDateRange(DateTime updatedStartDate, DateTime updatedEndDate) {
    emit(state.copyWith(startDate: updatedStartDate, endDate: updatedEndDate));
  }

  void updateInvitees(List<UserPublic> updatedInvitees) {
    emit(state.copyWith(invitees: List.from(updatedInvitees)));
  }

  void updateTaskList(List<String> updatedTaskList) {
    emit(state.copyWith(tasks: List.from(updatedTaskList)));
  }

  void updateLocation(String? address, String? city, String? country) {
    emit(state.copyWith(address: address, country: country, city: city));
  }

  void updateNumberOfParticipants(double numberOfParticipants) {
    emit(state.copyWith(numberOfParticipants: numberOfParticipants.toInt()));
  }

  void updateImage(Uint8List? updatedImage) {
    emit(state.copyWith(image: updatedImage));
  }

  void toggleDeviceCalendarSync(bool syncToDeviceCalendar) {
    emit(state.copyWith(syncToDeviceCalendar: syncToDeviceCalendar));
  }

  void updateSelectedGame(String? game) {
    emit(state.copyWith(selectedGame: game));
  }

  void updateAttendanceFormat(String attendance) {
    AttendanceFormat attendanceFormat;
    if (attendance == AttendanceFormat.online.name) {
      attendanceFormat = AttendanceFormat.online;
    } else if (attendance == AttendanceFormat.onsite.name) {
      attendanceFormat = AttendanceFormat.onsite;
    } else {
      attendanceFormat = AttendanceFormat.both;
    }
    emit(state.copyWith(attendanceFormat: attendanceFormat));
  }

  Future<void> createEvent() async {
    try {
      final ttrpgs = await _ttrpgService.getAllTTRPGs();
      final selectedTTRPG = ttrpgs.firstWhereOrNull(
        (ttrpg) => ttrpg.name == state.selectedGame,
      );
      if (selectedTTRPG == null) {
        AppSnackBar.show(
          message: 'Game ${state.selectedGame} not found',
          type: SnackBarType.error,
        );
        return;
      }
      String? city;
      String? country;

      if (state.attendanceFormat != AttendanceFormat.online) {
        if (state.address == null ||
            state.city == null ||
            state.country == null) {
          throw Exception('Location required for onsite events');
        }
        city = state.city;
        country = state.country;
      }

      final eventCreate = EventCreate(
        ttrpgId: selectedTTRPG.id,
        attendanceFormat: state.attendanceFormat,
        maxParticipants: state.numberOfParticipants,
        title: state.title,
        description: state.description,
        tasks: state.isPublic ? null : state.tasks.map((t) => t).toList(),
        city: city,
        country: country,
        coverImage: state.image != null ? _convertUint8List() : '',
      );

      await _eventService.createEvent(eventCreate);
      emit(state.copyWith(isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSuccess: false));
    }
  }

  Future<void> createEventFloyd() async {
    emit(state.copyWith(isSubmitting: true));
    final ttrpgs = await _ttrpgService.getAllTTRPGs();
    final TTRPGRead? selectedTTRPG = ttrpgs.firstWhereOrNull(
      (ttrpg) => ttrpg.name == state.selectedGame,
    );
    if (selectedTTRPG == null) {
      AppSnackBar.show(
        message: 'Game ${state.selectedGame} not found',
        type: SnackBarType.error,
      );
      emit(state.copyWith(isSubmitting: false));
      return;
    }
    String? city;
    String? country;
    if (state.attendanceFormat != AttendanceFormat.online) {
      if (state.address == null ||
          state.city == null ||
          state.country == null) {
        AppSnackBar.show(
          message: 'Event creation failed because you are missing an address.',
          type: SnackBarType.error,
        );
        emit(state.copyWith(isSuccess: false, isSubmitting: false));
        return;
      }
      city = state.city;
      country = state.country;
    }

    final eventCreate = EventCreate(
      ttrpgId: selectedTTRPG.id,
      attendanceFormat: state.attendanceFormat,
      maxParticipants: state.numberOfParticipants,
      title: state.title,
      description: state.description,
      tasks: state.isPublic ? null : state.tasks.map((t) => t).toList(),
      city: city,
      country: country,
      coverImage: state.image != null ? _convertUint8List() : '',
    );

    // Create event in backend
    await _eventService.createEvent(eventCreate);

    // Submit event to google calendar
    await _submitToGoogleCalendar(eventCreate);

    emit(state.copyWith(isSuccess: true, isSubmitting: false));
  }

  Future<void> _submitToGoogleCalendar(EventCreate eventCreate) async {
    await _calendarService.addEvent(eventCreate);
  }

  String? _convertUint8List() {
    if (state.image == null) {
      return '';
    }
    return base64Encode(state.image!.toList());
  }
}
