class CalendarState {
  const CalendarState({
    required this.selectedDate,
  });

  final DateTime? selectedDate;

  CalendarState copyWith({
    DateTime? selectedDate,
  }) {
    return CalendarState(selectedDate: selectedDate ?? this.selectedDate);
  }
}
