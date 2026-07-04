import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:party_planner/src/core/models/event.dart';
import 'package:party_planner/src/core/models/ttrpg.dart';
import 'package:party_planner/src/core/models/user.dart';
import 'package:party_planner/src/core/services/calendar_service.dart';
import 'package:party_planner/src/core/services/event_service.dart';
import 'package:party_planner/src/core/services/ttrpg_service.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/features/event_form/cubit/create_event_cubit.dart';
import 'package:party_planner/src/ui/features/event_form/cubit/create_event_state.dart';
import 'package:party_planner/src/ui/features/events/cubit/event_details_state.dart';

import 'create_event_cubit_test.mocks.dart';

@GenerateMocks([EventsService, TTRPGService, CalendarService, UserService])
void main() {
  late MockEventsService mockEventsService;
  late MockTTRPGService mockTTRPGService;
  late MockCalendarService mockCalendarService;
  late MockUserService mockUserService;

  setUp(() {
    mockEventsService = MockEventsService();
    mockTTRPGService = MockTTRPGService();
    mockCalendarService = MockCalendarService();
    mockUserService = MockUserService();

    when(mockUserService.currentUser).thenReturn(
      UserPublic(
        username: 'alice',
        id: 1,
        displayName: 'Alice',
        email: 'alice@email.com',
      ),
    );
  });

  final initialState = CreateEventState(
    isPublic: true,
    title: '',
    description: '',
    hostId: 1,
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
  );

  group('CreateEventCubit', () {
    blocTest<CreateEventCubit, CreateEventState>(
      'initial state is correct',
      build: () => CreateEventCubit(
        eventService: mockEventsService,
        ttrpgService: mockTTRPGService,
        userService: mockUserService,
        calendarService: mockCalendarService,
      ),
      verify: (cubit) => expect(cubit.state, initialState),
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateTitle updates the title',
      build: () => CreateEventCubit(
        eventService: mockEventsService,
        ttrpgService: mockTTRPGService,
        userService: mockUserService,
        calendarService: mockCalendarService,
      ),
      act: (cubit) => cubit.updateTitle('New Event Title'),
      expect: () => [
        initialState.copyWith(title: 'New Event Title'),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateDescription updates the description',
      build: () => CreateEventCubit(
        eventService: mockEventsService,
        ttrpgService: mockTTRPGService,
        userService: mockUserService,
        calendarService: mockCalendarService,
      ),
      act: (cubit) => cubit.updateDescription('New Event Description'),
      expect: () => [
        initialState.copyWith(description: 'New Event Description'),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateVisibility updates isPublic',
      build: () => CreateEventCubit(
        eventService: mockEventsService,
        ttrpgService: mockTTRPGService,
        userService: mockUserService,
        calendarService: mockCalendarService,
      ),
      act: (cubit) => cubit.updateVisibility(false),
      expect: () => [
        initialState.copyWith(isPublic: false),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'updateDateRange updates startDate and endDate',
      build: () => CreateEventCubit(
        eventService: mockEventsService,
        ttrpgService: mockTTRPGService,
        userService: mockUserService,
        calendarService: mockCalendarService,
      ),
      act: (cubit) => cubit.updateDateRange(
        DateTime(2025, 1, 1),
        DateTime(2025, 1, 2),
      ),
      expect: () => [
        initialState.copyWith(
          startDate: DateTime(2025, 1, 1),
          endDate: DateTime(2025, 1, 2),
        ),
      ],
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'createEvent emits success when event is created successfully',
      build: () {
        when(mockTTRPGService.getAllTTRPGs())
            .thenAnswer((_) async => [TTRPGRead(id: 1, name: 'D&D')]);
        when(mockEventsService.createEvent(any)).thenAnswer(
          (_) async => EventRead(
            id: 1,
            hostId: 1,
            ttrpgId: 1,
            attendanceFormat: AttendanceFormat.online,
            maxParticipants: 5,
            status: EventDetailStatus.recruiting,
            title: 'Test Event',
            description: 'Test Description',
            coverImage: null,
            tasks: [],
            city: 'New York',
            country: 'USA',
          ),
        );
        return CreateEventCubit(
          eventService: mockEventsService,
          ttrpgService: mockTTRPGService,
          userService: mockUserService,
          calendarService: mockCalendarService,
        );
      },
      act: (cubit) async {
        cubit.updateSelectedGame('D&D');
        await cubit.createEvent();
      },
      expect: () => [
        initialState.copyWith(selectedGame: 'D&D'),
        initialState.copyWith(
          selectedGame: 'D&D',
          isSuccess: true,
        ),
      ],
      verify: (_) {
        verify(mockTTRPGService.getAllTTRPGs()).called(1);
        verify(mockEventsService.createEvent(any)).called(1);
      },
    );

    blocTest<CreateEventCubit, CreateEventState>(
      'createEvent emits failure when event creation fails',
      build: () {
        when(mockTTRPGService.getAllTTRPGs())
            .thenAnswer((_) async => [TTRPGRead(id: 1, name: 'D&D')]);
        when(mockEventsService.createEvent(any)).thenThrow(Exception('Error'));
        return CreateEventCubit(
          eventService: mockEventsService,
          ttrpgService: mockTTRPGService,
          userService: mockUserService,
          calendarService: mockCalendarService,
        );
      },
      act: (cubit) async {
        cubit.updateSelectedGame('D&D');
        await cubit.createEvent();
      },
      expect: () => [
        initialState.copyWith(selectedGame: 'D&D'),
      ],
      verify: (_) {
        verify(mockTTRPGService.getAllTTRPGs()).called(1);
        verify(mockEventsService.createEvent(any)).called(1);
      },
    );
  });
}
