import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:party_planner/src/core/models/preference.dart';
import 'package:party_planner/src/core/models/user_profile.dart';
import 'package:party_planner/src/core/services/preference_service.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:party_planner/src/ui/features/onboarding/cubit/onboarding_state.dart';

import 'onboarding_cubit_test.mocks.dart';

@GenerateMocks([UserService, PreferencesService])
void main() {
  group('OnboardingCubit', () {
    late OnboardingCubit onboardingCubit;
    late MockUserService mockUserService;
    late MockPreferencesService mockPreferencesService;

    setUp(() {
      mockUserService = MockUserService();
      mockPreferencesService = MockPreferencesService();
      onboardingCubit = OnboardingCubit(
        userService: mockUserService,
        preferencesService: mockPreferencesService,
      );
    });

    test('initial state is correct', () {
      expect(
        onboardingCubit.state.onboardingStatus,
        equals(OnboardingStatus.onboarding),
      );
      expect(onboardingCubit.state.country, isEmpty);
      expect(onboardingCubit.state.languages, isEmpty);
    });

    group('Personal Info Updates', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'emits new state when display name is updated',
        build: () => onboardingCubit,
        act: (cubit) => cubit.updateDisplayName('John Doe'),
        expect: () => [
          predicate<OnboardingState>(
            (state) => state.displayName == 'John Doe',
          ),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits new state when birthday is updated',
        build: () => onboardingCubit,
        act: (cubit) => cubit.updateBirthDate(DateTime(2000, 1, 1)),
        expect: () => [
          predicate<OnboardingState>(
            (state) => state.birthday == DateTime(2000, 1, 1),
          ),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits new state when languages are updated',
        build: () => onboardingCubit,
        act: (cubit) => cubit.updateLanguages(['English', 'Spanish']),
        expect: () => [
          predicate<OnboardingState>(
            (state) =>
                state.languages.length == 2 &&
                state.languages.contains('English') &&
                state.languages.contains('Spanish'),
          ),
        ],
      );
    });

    group('Preferences Updates', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'emits new state when role preference is updated to player',
        build: () => onboardingCubit,
        act: (cubit) => cubit.updateRolePreference('player'),
        expect: () => [
          predicate<OnboardingState>(
            (state) => state.rolePreference == RolePreference.player,
          ),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits new state when attendance preference is updated to online',
        build: () => onboardingCubit,
        act: (cubit) => cubit.updateAttendancePreference('online'),
        expect: () => [
          predicate<OnboardingState>(
            (state) =>
                state.attendancePreference == AttendancePreference.online,
          ),
        ],
      );
    });

    group('Validation', () {
      test('validatePersonalInfoPage returns true for valid data', () {
        onboardingCubit
          ..updateBirthDate(DateTime(2000, 1, 1))
          ..updateCountry('USA')
          ..updateLanguages(['English']);

        expect(onboardingCubit.validatePersonalInfoPage(), isTrue);
      });

      test('validatePersonalInfoPage returns false for underage user', () {
        onboardingCubit
          ..updateBirthDate(DateTime.now())
          ..updateCountry('USA')
          ..updateLanguages(['English']);

        expect(onboardingCubit.validatePersonalInfoPage(), isFalse);
      });
    });

    group('Form Submission', () {
      setUp(() {
        // Set up valid state
        onboardingCubit
          ..updateDisplayName('John Doe')
          ..updateBirthDate(DateTime(2000, 1, 1))
          ..updateCountry('USA')
          ..updateLanguages(['English'])
          ..updateRolePreference('player')
          ..updateAttendancePreference('online')
          ..updatePhoneNumber('+1234567890')
          ..updateDiscordTag('john#1234')
          ..updateGamesList(['D&D 5e']);

        when(mockUserService.createProfile(any))
            .thenAnswer((_) => Future.value(ProfileRead(id: 1, userId: 1)));
        when(mockPreferencesService.createPreference(any)).thenAnswer(
          (_) => Future.value(
            PreferenceRead(
              id: 1,
              userId: 1,
              attendancePreference: AttendancePreference.online,
              rolePreference: RolePreference.gamemaster,
              ttrpgs: [],
            ),
          ),
        );
      });

      blocTest<OnboardingCubit, OnboardingState>(
        'emits [submitting, onboarded] when submission is successful',
        build: () => onboardingCubit,
        act: (cubit) => cubit.submitOnboarding(),
        expect: () => [
          predicate<OnboardingState>(
            (state) => state.onboardingStatus == OnboardingStatus.submitting,
          ),
          predicate<OnboardingState>(
            (state) => state.onboardingStatus == OnboardingStatus.onboarded,
          ),
        ],
        verify: (_) {
          verify(mockUserService.createProfile(any)).called(1);
          verify(mockPreferencesService.createPreference(any)).called(1);
        },
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'emits [submitting, failed] when submission fails',
        build: () => onboardingCubit,
        setUp: () {
          when(mockUserService.createProfile(any))
              .thenThrow(Exception('Failed to create profile'));
        },
        act: (cubit) => cubit.submitOnboarding(),
        expect: () => [
          predicate<OnboardingState>(
            (state) => state.onboardingStatus == OnboardingStatus.submitting,
          ),
          predicate<OnboardingState>(
            (state) => state.onboardingStatus == OnboardingStatus.failed,
          ),
        ],
      );
    });
  });
}
