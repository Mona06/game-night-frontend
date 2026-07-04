import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:party_planner/src/core/models/event.dart';
import 'package:party_planner/src/core/services/event_service.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/features/events/cubit/event_details_cubit.dart';
import 'package:party_planner/src/ui/features/events/cubit/event_details_state.dart';

import 'event_details_cubit_test.mocks.dart';

@GenerateMocks([EventsService, UserService])
void main() {
  late MockEventsService mockEventsService;

  setUp(() {
    mockEventsService = MockEventsService();
  });

  group('EventDetailCubit', () {
    const initialEventDetailState = EventDetailState(
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
    );

    blocTest<EventDetailCubit, EventDetailState>(
      'emits initial state',
      build: () => EventDetailCubit(mockEventsService),
      verify: (cubit) => expect(
        cubit.state,
        initialEventDetailState,
      ),
    );

    group('fetchEvent', () {
      const eventId = 1;

      blocTest<EventDetailCubit, EventDetailState>(
        'emits loading state and then event details when fetch succeeds',
        build: () => EventDetailCubit(mockEventsService),
        setUp: () {
          final event = EventReadDetailed(
            id: eventId,
            hostId: 42,
            ttrpgId: 1,
            attendanceFormat: AttendanceFormat.online,
            maxParticipants: 10,
            tasks: [],
            status: EventDetailStatus.recruiting,
            title: 'Sample Event',
            description: 'This is a test event.',
            participants: [],
          );

          when(mockEventsService.getEventById(eventId))
              .thenAnswer((_) async => event);
        },
        act: (cubit) => cubit.fetchEvent(eventId),
        expect: () => [
          initialEventDetailState.copyWith(isLoading: true, error: null),
          initialEventDetailState.copyWith(
            hostId: 42,
            coverImage: null,
            title: 'Sample Event',
            description: 'This is a test event.',
            tasks: [],
            numberOfParticipants: 10,
            status: EventDetailStatus.recruiting,
            openSpots: 0,
            participants: [],
            attendanceFormat: 'online',
            isLoading: false,
            error: null,
          ),
        ],
        verify: (_) {
          verify(mockEventsService.getEventById(eventId)).called(1);
        },
      );

      blocTest<EventDetailCubit, EventDetailState>(
        'emits loading state and then error state when fetch fails',
        build: () => EventDetailCubit(mockEventsService),
        setUp: () {
          when(mockEventsService.getEventById(eventId))
              .thenThrow(Exception('Failed to fetch event'));
        },
        act: (cubit) => cubit.fetchEvent(eventId),
        expect: () => [
          initialEventDetailState.copyWith(isLoading: true, error: null),
          initialEventDetailState.copyWith(
            isLoading: false,
            error: 'Failed to fetch event',
          ),
        ],
        verify: (_) {
          verify(mockEventsService.getEventById(eventId)).called(1);
        },
      );
    });

    group('toggleEditing', () {
      blocTest<EventDetailCubit, EventDetailState>(
        'toggles isEditing state on',
        build: () => EventDetailCubit(mockEventsService),
        act: (cubit) => cubit.toggleEditing(),
        expect: () => [
          initialEventDetailState.copyWith(isEditing: true),
        ],
      );

      blocTest<EventDetailCubit, EventDetailState>(
        'toggles isEditing state off',
        build: () => EventDetailCubit(mockEventsService),
        seed: () => initialEventDetailState.copyWith(isEditing: true),
        act: (cubit) => cubit.toggleEditing(),
        expect: () => [
          initialEventDetailState.copyWith(isEditing: false),
        ],
      );
    });
  });
}
