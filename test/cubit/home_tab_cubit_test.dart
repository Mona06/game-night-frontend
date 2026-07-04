import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:party_planner/src/core/models/event.dart';
import 'package:party_planner/src/core/services/event_service.dart';
import 'package:party_planner/src/ui/features/events/cubit/event_details_state.dart';
import 'package:party_planner/src/ui/features/home/home_tab/cubit/home_tab_cubit.dart';
import 'package:party_planner/src/ui/features/home/home_tab/cubit/home_tab_state.dart';

import 'home_tab_cubit_test.mocks.dart';

@GenerateMocks([EventsService])
void main() {
  late MockEventsService mockEventsService;
  late HomeTabCubit homeTabCubit;

  group('HomeTabCubit', () {
    blocTest<HomeTabCubit, HomeTabState>(
      'emits loading and success states when events are loaded successfully',
      setUp: () {
        mockEventsService = MockEventsService();
        homeTabCubit = HomeTabCubit(eventService: mockEventsService);
        when(mockEventsService.getMatchingEvents()).thenAnswer(
          (_) async => [
            EventRead(
              id: 1,
              hostId: 1,
              ttrpgId: 1,
              attendanceFormat: AttendanceFormat.online,
              maxParticipants: 10,
              status: EventDetailStatus.recruiting,
            ),
          ],
        );
      },
      build: () => homeTabCubit,
      act: (cubit) => cubit.loadMatchingEvents(),
      expect: () => [
        const HomeTabState(status: HomeTabStatus.loading),
        HomeTabState(
          status: HomeTabStatus.success,
          events: [
            EventRead(
              id: 1,
              hostId: 1,
              ttrpgId: 1,
              attendanceFormat: AttendanceFormat.online,
              maxParticipants: 10,
              status: EventDetailStatus.recruiting,
            ),
          ],
          errorMessage: null,
        ),
      ],
      tearDown: () {
        homeTabCubit.close();
      },
    );

    blocTest<HomeTabCubit, HomeTabState>(
      'emits loading and failure states when an error occurs while loading events',
      setUp: () {
        mockEventsService = MockEventsService();
        homeTabCubit = HomeTabCubit(eventService: mockEventsService);
        when(mockEventsService.getMatchingEvents()).thenThrow(
          Exception('Failed to load events'),
        );
      },
      build: () => homeTabCubit,
      act: (cubit) => cubit.loadMatchingEvents(),
      expect: () => [
        const HomeTabState(status: HomeTabStatus.loading), // Loading state
        const HomeTabState(
          status: HomeTabStatus.failure,
          errorMessage: 'Failed to load events',
        ), // Failure state with error message
      ],
      tearDown: () {
        homeTabCubit.close();
      },
    );
  });
}
