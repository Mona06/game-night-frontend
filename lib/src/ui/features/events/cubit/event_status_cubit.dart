import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/event_service.dart';
import '../../../../core/services/user_service.dart';
import 'event_details_state.dart';
import 'event_status_state.dart';

class EventStatusCubit extends Cubit<EventStatusState> {
  final EventsService _eventsService;
  final UserService _userService;

  EventStatusCubit(this._eventsService, this._userService)
      : super(EventStatusLoading());

  Future<void> loadTentativeEvents() async {
    try {
      emit(EventStatusLoading());
      final events = await _eventsService.getMyEvents();

      final tentativeEvents = events
          .where((event) => event.status == EventDetailStatus.recruiting)
          .toList();

      emit(EventStatusLoaded(tentativeEvents));
    } catch (e) {
      emit(EventStatusError(e.toString()));
    }
  }

  Future<void> loadConfirmedEvents() async {
    try {
      emit(EventStatusLoading());
      final events = await _eventsService.getMyEvents();
      final confirmedEvents = events
          .where(
            (event) =>
                event.status == EventDetailStatus.finalized &&
                event.startDateTime!.isAfter(DateTime.now()),
          )
          .toList();

      emit(EventStatusLoaded(confirmedEvents));
    } catch (e) {
      emit(EventStatusError(e.toString()));
    }
  }

  Future<void> loadHostedEvents() async {
    try {
      emit(EventStatusLoading());
      final currentUserId = _userService.currentUser?.id;
      final events = await _eventsService.getMyEvents();
      final hostedEvents = events
          .where(
            (event) =>
                event.startDateTime!.isAfter(DateTime.now()) &&
                event.hostId == currentUserId,
          )
          .toList();

      emit(EventStatusLoaded(hostedEvents));
    } catch (e) {
      emit(EventStatusError(e.toString()));
    }
  }
}
