import '../../../../core/models/event.dart';

abstract class EventStatusState {
  const EventStatusState();
  List<EventRead> get events => [];
}

class EventStatusLoading extends EventStatusState {
  @override
  List<EventRead> get events => [];
}

class EventStatusLoaded extends EventStatusState {
  final List<EventRead> _events;

  const EventStatusLoaded(this._events);

  @override
  List<EventRead> get events => _events;
}

class EventStatusError extends EventStatusState {
  final String message;

  const EventStatusError(this.message);

  @override
  List<EventRead> get events => [];
}
