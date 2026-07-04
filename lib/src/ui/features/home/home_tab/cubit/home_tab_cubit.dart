import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/event_service.dart';
import 'home_tab_state.dart';

class HomeTabCubit extends Cubit<HomeTabState> {
  final EventsService _eventService;

  HomeTabCubit({
    required EventsService eventService,
  })  : _eventService = eventService,
        super(const HomeTabState());

  Future<void> loadMatchingEvents() async {
    emit(state.copyWith(status: HomeTabStatus.loading));

    try {
      final events = await _eventService.getMatchingEvents();
      emit(
        state.copyWith(
          events: events,
          status: HomeTabStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeTabStatus.failure,
          errorMessage: 'Failed to load events',
        ),
      );
    }
  }
}
