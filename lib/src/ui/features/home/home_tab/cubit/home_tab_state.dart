import 'package:equatable/equatable.dart';
import '../../../../../core/models/event.dart';

enum HomeTabStatus { initial, loading, success, failure }

class HomeTabState extends Equatable {
  final List<EventRead> events;
  final HomeTabStatus status;
  final String? errorMessage;

  const HomeTabState({
    this.events = const [],
    this.status = HomeTabStatus.initial,
    this.errorMessage,
  });

  HomeTabState copyWith({
    List<EventRead>? events,
    HomeTabStatus? status,
    String? errorMessage,
  }) {
    return HomeTabState(
      events: events ?? this.events,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [events, status, errorMessage];
}
