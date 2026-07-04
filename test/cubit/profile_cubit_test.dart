import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:intl/intl.dart';
import 'package:party_planner/src/core/models/preference.dart';
import 'package:party_planner/src/core/models/ttrpg.dart';
import 'package:party_planner/src/core/models/user.dart';
import 'package:party_planner/src/core/models/user_profile.dart';
import 'package:party_planner/src/core/services/preference_service.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/features/user_profile/cubit/profile_cubit.dart';
import 'package:party_planner/src/ui/features/user_profile/cubit/profile_state.dart';

@GenerateMocks([
  UserService,
  PreferencesService,
])
import 'profile_cubit_test.mocks.dart';

void main() {
  late MockUserService mockUserService;
  late MockPreferencesService mockPreferencesService;
  late ProfileCubit profileCubit;

  // Test data
  final testDate = DateTime(1990, 1, 1);
  final formattedDate = DateFormat('yyyy-MM-dd').format(testDate);

  final testUser = UserPublic(
    id: 1,
    email: 'test@test.com',
    username: 'test_user',
    displayName: 'Test User',
  );

  final testProfile = ProfileRead(
    id: 1,
    userId: 1,
    shortBio: 'Test bio',
    birthday: testDate,
    city: 'Test City',
    country: 'Test Country',
    phoneNumber: '1234567890',
    discordTag: 'test#1234',
    languages: ['English', 'Spanish'],
  );

  final testPreferences = PreferenceRead(
    attendancePreference: AttendancePreference.online,
    rolePreference: RolePreference.gamemaster,
    ttrpgs: [TTRPGRead(name: 'D&D 5e', id: 1)],
    id: 1,
    userId: 1,
  );

  setUp(() {
    mockUserService = MockUserService();
    mockPreferencesService = MockPreferencesService();

    profileCubit = ProfileCubit(mockUserService, mockPreferencesService);
  });

  tearDown(() {
    profileCubit.close();
  });

  group('loadProfile', () {
    blocTest<ProfileCubit, ProfileState>(
      'loads current user profile successfully',
      build: () {
        when(mockUserService.getCurrentUser())
            .thenAnswer((_) async => testUser);
        when(mockUserService.getCurrentProfile())
            .thenAnswer((_) async => testProfile);
        when(mockPreferencesService.getCurrentUserPreferences())
            .thenAnswer((_) async => testPreferences);
        return profileCubit;
      },
      act: (cubit) => cubit.loadProfile(),
      verify: (_) {
        verify(mockUserService.getCurrentUser()).called(1);
        verify(mockUserService.getCurrentProfile()).called(1);
        verify(mockPreferencesService.getCurrentUserPreferences()).called(1);
      },
      expect: () => [
        predicate<ProfileState>(
          (state) =>
              state.displayName == testUser.displayName &&
              state.bio == testProfile.shortBio &&
              state.birthdate == formattedDate &&
              state.city == '${testProfile.city}, ${testProfile.country}' &&
              state.phoneNumber == testProfile.phoneNumber &&
              state.discordTag == testProfile.discordTag &&
              state.languages.length == testProfile.languages!.length &&
              state.attendancePreference ==
                  testPreferences.attendancePreference.name &&
              state.rolePreference == testPreferences.rolePreference.name &&
              state.ttrpgs.first == testPreferences.ttrpgs.first.name &&
              state.isOwnProfile == true,
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'loads other user profile successfully',
      build: () {
        when(mockUserService.getUserById(any))
            .thenAnswer((_) async => testUser);
        when(mockUserService.getUserProfile(any))
            .thenAnswer((_) async => testProfile);
        when(mockPreferencesService.getPreferencesByUserId(any))
            .thenAnswer((_) async => testPreferences);
        return profileCubit;
      },
      act: (cubit) => cubit.loadProfile(userId: 2),
      verify: (_) {
        verify(mockUserService.getUserById(2)).called(1);
        verify(mockUserService.getUserProfile(2)).called(1);
        verify(mockPreferencesService.getPreferencesByUserId(2)).called(1);
      },
      expect: () => [
        predicate<ProfileState>(
          (state) =>
              state.displayName == testUser.displayName &&
              state.bio == testProfile.shortBio &&
              state.birthdate == formattedDate &&
              state.city == '${testProfile.city}, ${testProfile.country}' &&
              state.phoneNumber == testProfile.phoneNumber &&
              state.discordTag == testProfile.discordTag &&
              state.languages.length == testProfile.languages!.length &&
              state.attendancePreference ==
                  testPreferences.attendancePreference.name &&
              state.rolePreference == testPreferences.rolePreference.name &&
              state.ttrpgs.first == testPreferences.ttrpgs.first.name &&
              state.isOwnProfile == false,
        ),
      ],
    );
  });

  group('updateBio', () {
    blocTest<ProfileCubit, ProfileState>(
      'updates bio in state',
      build: () => profileCubit,
      act: (cubit) => cubit.updateBio('New bio'),
      expect: () => [
        predicate<ProfileState>((state) => state.bio == 'New bio'),
      ],
    );
  });

  group('submitBio', () {
    blocTest<ProfileCubit, ProfileState>(
      'submits bio update successfully',
      build: () {
        when(mockUserService.getCurrentProfile())
            .thenAnswer((_) async => testProfile);
        when(mockUserService.updateProfile(any)).thenAnswer(
          (_) async => ProfileRead(
            userId: 1,
            id: 1,
          ),
        );
        return profileCubit;
      },
      act: (cubit) => cubit.submitBio('Updated bio'),
      verify: (_) {
        verify(mockUserService.getCurrentProfile()).called(1);
        verify(mockUserService.updateProfile(any)).called(1);
      },
    );
  });

  group('toggleFriendship', () {
    blocTest<ProfileCubit, ProfileState>(
      'toggles friendship status',
      build: () => profileCubit,
      act: (cubit) => cubit.toggleFriendship(),
      expect: () => [
        predicate<ProfileState>((state) => state.isFriend == true),
      ],
    );
  });
}
