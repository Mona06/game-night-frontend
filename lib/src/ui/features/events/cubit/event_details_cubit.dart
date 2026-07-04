import 'package:bloc/bloc.dart';

import '../../../../core/models/event.dart';
import '../../../../core/models/timeslot.dart';
import '../../../../core/models/user.dart';
import '../../../../core/services/event_service.dart';
import 'event_details_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  final EventsService _eventService;

  EventDetailCubit(this._eventService)
      : super(
          const EventDetailState(
            coverImageBase64: null,
            isPublic: true,
            title: '',
            description: '',
            invitees: [],
            tasks: [],
            numberOfParticipants: 0,
            status: EventDetailStatus.recruiting,
            openSpots: 0,
            participants: [],
            timeslots: [],
            attendanceFormat: '',
            hostId: 0,
          ),
        );

  Future<void> fetchEvent(int eventId) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final event = await _eventService.getEventById(eventId);

      emit(
        EventDetailState(
          hostId: event.hostId,
          coverImageBase64: event.coverImage,
          isPublic: state.isPublic,
          title: event.title ?? '',
          description: event.description,
          invitees: [],
          tasks: event.tasks,
          numberOfParticipants: event.maxParticipants,
          status: event.status,
          openSpots: 0,
          participants: event.participants,
          isLoading: false,
          error: null,
          attendanceFormat: event.attendanceFormat.name,
          timeslots: [],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to fetch event',
        ),
      );
    }
  }

  void toggleEditing() {
    emit(state.copyWith(isEditing: !state.isEditing));
  }

  void updateAttendanceFormat(String attendanceFormat) {
    emit(state.copyWith(attendanceFormat: attendanceFormat));
  }

  void updateCoverImage(String coverImage) {
    emit(state.copyWith(coverImage: coverImage));
  }

  void updateTitle(String updatedTitle) {
    emit(state.copyWith(title: updatedTitle));
  }

  void updateDescription(String updatedDescription) {
    emit(state.copyWith(description: updatedDescription));
  }

  void updateDateTime(DateTime? updatedStartDateTime) {
    emit(state.copyWith(startDateTime: updatedStartDateTime));
  }

  void updateEndDateTime(DateTime? updatedEndTime) {
    emit(state.copyWith(endDateTime: updatedEndTime));
  }

  void updateInvitees(List<UserPublic> updatedInvitees) {
    emit(state.copyWith(invitees: updatedInvitees));
  }

  void updateTasks(List<String>? updatedTasks) {
    emit(state.copyWith(tasks: updatedTasks));
  }

  void updateNumberOfParticipants(int updatedNumber) {
    emit(state.copyWith(numberOfParticipants: updatedNumber));
  }

  void updateStatus(EventDetailStatus updatedStatus) {
    emit(state.copyWith(status: updatedStatus));
  }

  void updateOpenSpots(int updatedOpenSpots) {
    emit(state.copyWith(openSpots: updatedOpenSpots));
  }

  void updateParticipants(List<EventParticipantRead> updatedParticipants) {
    emit(state.copyWith(participants: updatedParticipants));
  }

  void updateTimeslots(List<TimeslotItem> updatedTimeslots) {
    emit(state.copyWith(timeslots: updatedTimeslots));
  }

  void setError(String error) {
    emit(state.copyWith(error: error));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  Future<void> joinEvent(int eventId) async {
    await _eventService.joinEvent(eventId);
  }

// void shareEvent(int eventId) async {
//   final event = await _eventService.getEvent(eventId);
//   final iCal = createICalEvent(
//     title: event.title,
//     description: event.description,
//     startDate: event.startDateTime,
//     endDate: event.endDateTime,
//     location: "${event.city}${event.country}",
//   );
//   await shareICalEvent(iCal);
// }
}
