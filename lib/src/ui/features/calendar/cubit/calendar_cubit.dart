import 'package:flutter_bloc/flutter_bloc.dart';

import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit()
      : super(
          CalendarState(
            selectedDate: DateTime.now(),
          ),
        );

  void updateDate(DateTime? date) {
    emit(state.copyWith(selectedDate: date));
  }
}
