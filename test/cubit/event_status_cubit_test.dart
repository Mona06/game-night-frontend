import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:party_planner/src/core/models/event.dart';
import 'package:party_planner/src/core/models/user.dart';
import 'package:party_planner/src/core/services/event_service.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/features/events/cubit/event_details_state.dart';
import 'package:party_planner/src/ui/features/events/cubit/event_status_cubit.dart';
import 'package:party_planner/src/ui/features/events/cubit/event_status_state.dart';

import 'event_status_cubit_test.mocks.dart';

@GenerateMocks([EventsService, UserService])
void main() {
  late MockEventsService mockEventsService;
  late MockUserService mockUserService;
  late EventStatusCubit eventStatusCubit;

  // Test data
  final currentUser =
      UserPublic(id: 1, username: 'test_user', email: 'test@test.com');
  final futureDate = DateTime.now().add(const Duration(days: 7));
  final pastDate = DateTime.now().subtract(const Duration(days: 7));

  final testEvents = [
    EventRead(
      id: 1,
      title: 'Recruiting Event',
      status: EventDetailStatus.recruiting,
      startDateTime: futureDate,
      hostId: 2,
      ttrpgId: 1,
      attendanceFormat: AttendanceFormat.online,
      maxParticipants: 5,
    ),
    EventRead(
      id: 2,
      title: 'Finalized Future Event',
      status: EventDetailStatus.finalized,
      startDateTime: futureDate,
      hostId: 2,
      ttrpgId: 1,
      attendanceFormat: AttendanceFormat.online,
      maxParticipants: 5,
    ),
    EventRead(
      id: 3,
      title: 'Finalized Past Event',
      status: EventDetailStatus.finalized,
      startDateTime: pastDate,
      hostId: 2,
      ttrpgId: 1,
      attendanceFormat: AttendanceFormat.online,
      maxParticipants: 5,
    ),
    EventRead(
      id: 4,
      title: 'Hosted Event',
      status: EventDetailStatus.recruiting,
      startDateTime: futureDate,
      hostId: 1,
      ttrpgId: 1,
      attendanceFormat: AttendanceFormat.online,
      maxParticipants: 5,
    ),
  ];

  setUp(() {
    mockEventsService = MockEventsService();
    mockUserService = MockUserService();

    when(mockUserService.currentUser).thenReturn(currentUser);
    eventStatusCubit = EventStatusCubit(mockEventsService, mockUserService);
  });

  tearDown(() {
    eventStatusCubit.close();
  });

  group('loadTentativeEvents', () {
    blocTest<EventStatusCubit, EventStatusState>(
      'emits [loading, loaded] with recruiting events',
      build: () {
        when(mockEventsService.getMyEvents())
            .thenAnswer((_) async => testEvents);
        return eventStatusCubit;
      },
      act: (cubit) => cubit.loadTentativeEvents(),
      expect: () => [
        isA<EventStatusLoading>(),
        predicate<EventStatusLoaded>((state) {
          final events = state.events;
          return events.length == 2 &&
              events.every(
                (event) => event.status == EventDetailStatus.recruiting,
              );
        }),
      ],
      verify: (_) {
        verify(mockEventsService.getMyEvents()).called(1);
      },
    );

    blocTest<EventStatusCubit, EventStatusState>(
      'emits [loading, error] when loading fails',
      build: () {
        when(mockEventsService.getMyEvents())
            .thenThrow(Exception('Network error'));
        return eventStatusCubit;
      },
      act: (cubit) => cubit.loadTentativeEvents(),
      expect: () => [
        isA<EventStatusLoading>(),
        predicate<EventStatusError>(
          (state) => state.message == 'Exception: Network error',
        ),
      ],
    );
  });

  group('loadConfirmedEvents', () {
    blocTest<EventStatusCubit, EventStatusState>(
      'emits [loading, loaded] with future finalized events',
      build: () {
        when(mockEventsService.getMyEvents())
            .thenAnswer((_) async => testEvents);
        return eventStatusCubit;
      },
      act: (cubit) => cubit.loadConfirmedEvents(),
      expect: () => [
        isA<EventStatusLoading>(),
        predicate<EventStatusLoaded>((state) {
          final events = state.events;
          return events.length == 1 &&
              events.every(
                (event) =>
                    event.status == EventDetailStatus.finalized &&
                    event.startDateTime!.isAfter(DateTime.now()),
              );
        }),
      ],
    );

    blocTest<EventStatusCubit, EventStatusState>(
      'emits [loading, error] when loading fails',
      build: () {
        when(mockEventsService.getMyEvents())
            .thenThrow(Exception('Network error'));
        return eventStatusCubit;
      },
      act: (cubit) => cubit.loadConfirmedEvents(),
      expect: () => [
        isA<EventStatusLoading>(),
        predicate<EventStatusError>(
          (state) => state.message == 'Exception: Network error',
        ),
      ],
    );
  });

  group('loadHostedEvents', () {
    blocTest<EventStatusCubit, EventStatusState>(
      'emits [loading, loaded] with future hosted events',
      build: () {
        when(mockEventsService.getMyEvents())
            .thenAnswer((_) async => testEvents);
        return eventStatusCubit;
      },
      act: (cubit) => cubit.loadHostedEvents(),
      expect: () => [
        isA<EventStatusLoading>(),
        predicate<EventStatusLoaded>((state) {
          final events = state.events;
          return events.length == 1 &&
              events.every(
                (event) =>
                    event.hostId == currentUser.id &&
                    event.startDateTime!.isAfter(DateTime.now()),
              );
        }),
      ],
      verify: (_) {
        verify(mockEventsService.getMyEvents()).called(1);
        verify(mockUserService.currentUser).called(1);
      },
    );

    blocTest<EventStatusCubit, EventStatusState>(
      'emits [loading, error] when loading fails',
      build: () {
        when(mockEventsService.getMyEvents())
            .thenThrow(Exception('Network error'));
        return eventStatusCubit;
      },
      act: (cubit) => cubit.loadHostedEvents(),
      expect: () => [
        isA<EventStatusLoading>(),
        predicate<EventStatusError>(
          (state) => state.message == 'Exception: Network error',
        ),
      ],
    );
  });
}
