import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:party_planner/src/core/models/preference.dart';
import 'package:party_planner/src/core/models/ttrpg.dart';
import 'package:party_planner/src/core/models/user.dart';
import 'package:party_planner/src/core/models/user_profile.dart';
import 'package:party_planner/src/core/services/preference_service.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/features/user_profile/cubit/settings/account_settings_cubit.dart';
import 'package:party_planner/src/ui/features/user_profile/cubit/settings/account_settings_state.dart';

import 'account_settings_cubit_test.mocks.dart';

@GenerateMocks([UserService, PreferencesService])
void main() {
  late MockUserService mockUserService;
  late MockPreferencesService mockPreferencesService;

  setUp(() {
    mockUserService = MockUserService();
    mockPreferencesService = MockPreferencesService();
    when(mockUserService.getCurrentProfile()).thenAnswer(
      (_) async => Future.value(
        ProfileRead(
          id: 1,
          userId: 1,
          discordTag: 'user#1234',
          phoneNumber: '+1234567890',
          city: 'New York',
          country: 'USA',
          birthday: DateTime.now(),
        ),
      ),
    );
    when(mockUserService.updateProfile(any)).thenAnswer(
      (_) async => Future.value(
        ProfileRead(
          id: 1,
          userId: 1,
          discordTag: 'user#1234',
          phoneNumber: '+1234567890',
          city: 'New York',
          country: 'USA',
          birthday: DateTime.now(),
        ),
      ),
    );
    when(mockPreferencesService.updatePreference(any, any)).thenAnswer(
      (_) async => Future.value(
        PreferenceRead(
          id: 1,
          userId: 1,
          ttrpgs: [TTRPGRead(name: 'D&D', id: 1)],
          attendancePreference: AttendancePreference.online,
          rolePreference: RolePreference.player,
        ),
      ),
    );
    when(mockUserService.getCurrentUser()).thenAnswer(
      (_) => Future.value(
        UserPublic(
          id: 1,
          displayName: 'Test User',
          email: 'test@email.com',
          username: 'test',
        ),
      ),
    );
    when(mockPreferencesService.getCurrentUserPreferences()).thenAnswer(
      (_) async => Future.value(
        PreferenceRead(
          id: 1,
          userId: 1,
          ttrpgs: [TTRPGRead(name: 'D&D', id: 1)],
          attendancePreference: AttendancePreference.online,
          rolePreference: RolePreference.player,
        ),
      ),
    );
  });

  group('AccountSettingsCubit', () {
    blocTest<AccountSettingsCubit, AccountSettingsState>(
      'emits correct initial state',
      build: () =>
          AccountSettingsCubit(mockUserService, mockPreferencesService),
      verify: (cubit) => expect(
        cubit.state,
        const AccountSettingsState(
          eventUpdates: true,
          reminders: true,
        ),
      ),
    );

    group('update methods', () {
      blocTest<AccountSettingsCubit, AccountSettingsState>(
        'updateDisplayName updates the state',
        build: () =>
            AccountSettingsCubit(mockUserService, mockPreferencesService),
        act: (cubit) => cubit.updateDisplayName('Test User'),
        expect: () => [
          const AccountSettingsState(
            displayName: 'Test User',
            eventUpdates: true,
            reminders: true,
          ),
        ],
      );

      blocTest<AccountSettingsCubit, AccountSettingsState>(
        'updatePhoneNumber updates the state',
        build: () =>
            AccountSettingsCubit(mockUserService, mockPreferencesService),
        act: (cubit) => cubit.updatePhoneNumber('+1234567890'),
        expect: () => [
          const AccountSettingsState(
            phoneNumber: '+1234567890',
            eventUpdates: true,
            reminders: true,
          ),
        ],
      );

      blocTest<AccountSettingsCubit, AccountSettingsState>(
        'updateDiscordTag updates the state',
        build: () =>
            AccountSettingsCubit(mockUserService, mockPreferencesService),
        act: (cubit) => cubit.updateDiscordTag('user#1234'),
        expect: () => [
          const AccountSettingsState(
            discordTag: 'user#1234',
            eventUpdates: true,
            reminders: true,
          ),
        ],
      );
    });

    group('loadSettings', () {
      blocTest<AccountSettingsCubit, AccountSettingsState>(
        'loads settings successfully',
        build: () {
          when(mockUserService.getCurrentUser()).thenAnswer(
            (_) async => UserPublic(
              id: 1,
              displayName: 'Test User',
              email: 'email@email.com',
              username: 'username',
            ),
          );
          when(mockUserService.getCurrentProfile()).thenAnswer(
            (_) async => ProfileRead(
              id: 1,
              userId: 1,
              city: 'New York',
              country: 'USA',
              phoneNumber: '+1234567890',
              discordTag: 'user#1234',
            ),
          );
          when(mockPreferencesService.getCurrentUserPreferences()).thenAnswer(
            (_) async => PreferenceRead(
              id: 1,
              ttrpgs: [TTRPGRead(name: 'D&D', id: 1)],
              attendancePreference: AttendancePreference.online,
              rolePreference: RolePreference.player,
              userId: 1,
            ),
          );
          return AccountSettingsCubit(mockUserService, mockPreferencesService);
        },
        act: (cubit) => cubit.loadSettings(),
        verify: (cubit) {
          verify(mockUserService.getCurrentUser()).called(1);
          verify(mockUserService.getCurrentProfile()).called(1);
          verify(mockPreferencesService.getCurrentUserPreferences()).called(1);
        },
        expect: () => [
          const AccountSettingsState(isLoading: true),
          AccountSettingsState(
            isLoading: false,
            displayName: 'Test User',
            city: 'New York',
            country: 'USA',
            phoneNumber: '+1234567890',
            discordTag: 'user#1234',
            ttrpgs: ['D&D'],
            attendancePreference: AttendancePreference.online,
            rolePreference: RolePreference.player,
          ),
        ],
      );

      blocTest<AccountSettingsCubit, AccountSettingsState>(
        'handles error during loadSettings',
        build: () {
          when(mockUserService.getCurrentUser())
              .thenThrow(Exception('Failed to load user'));
          return AccountSettingsCubit(mockUserService, mockPreferencesService);
        },
        act: (cubit) => cubit.loadSettings(),
        expect: () => [
          const AccountSettingsState(isLoading: true),
          const AccountSettingsState(
            isLoading: false,
            errorMessage: 'Failed to load user settings',
          ),
        ],
      );
    });

    group('logout', () {
      blocTest<AccountSettingsCubit, AccountSettingsState>(
        'emits state with hasLoggedOut as true',
        build: () =>
            AccountSettingsCubit(mockUserService, mockPreferencesService),
        act: (cubit) => cubit.logout(),
        verify: (cubit) => verify(mockUserService.logout()).called(1),
        expect: () => [
          const AccountSettingsState(hasLoggedOut: true),
        ],
      );
    });

    group('submitForm', () {
      blocTest<AccountSettingsCubit, AccountSettingsState>(
        'updates user profile successfully',
        build: () {
          when(mockUserService.updateProfile(any))
              .thenAnswer((_) async => ProfileRead(id: 1, userId: 1));
          return AccountSettingsCubit(mockUserService, mockPreferencesService);
        },
        act: (cubit) {
          cubit.displayNameController.text = 'Updated Name';
          return cubit.submitForm();
        },
        expect: () => [
          const AccountSettingsState(isSubmitting: true),
          const AccountSettingsState(isSubmitting: false, isSuccess: true),
        ],
      );
    });
  });
}
