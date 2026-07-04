import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:party_planner/src/core/models/user_profile.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/features/splash_screen/cubit/splash_screen_cubit.dart';
import 'package:party_planner/src/ui/features/splash_screen/cubit/splash_screen_state.dart';

import 'splash_screen_cubit_test.mocks.dart';

@GenerateMocks([UserService])
void main() {
  late MockUserService mockUserService;

  setUp(() async {
    mockUserService = MockUserService();
    when(mockUserService.loadToken()).thenAnswer((_) async => null);
    when(mockUserService.loadUser()).thenAnswer((_) async => null);
  });

  group('SplashScreenCubit', () {
    blocTest<SplashScreenCubit, SplashScreenState>(
      'emits splash action initially',
      build: () => SplashScreenCubit(userService: mockUserService),
      verify: (cubit) => expect(cubit.state.state, SplashAction.splash),
    );

    group('splash', () {
      blocTest<SplashScreenCubit, SplashScreenState>(
        'emits introduction state when needs introduction',
        build: () {
          SharedPreferences.setMockInitialValues({'needsIntroduction': true});
          return SplashScreenCubit(userService: mockUserService);
        },
        act: (cubit) => cubit.splash(),
        expect: () => [SplashScreenState(state: SplashAction.introduction)],
      );

      blocTest<SplashScreenCubit, SplashScreenState>(
        'emits unauthenticated when no token exists',
        build: () {
          SharedPreferences.setMockInitialValues({'needsIntroduction': false});
          when(mockUserService.token).thenReturn(null);
          return SplashScreenCubit(userService: mockUserService);
        },
        act: (cubit) => cubit.splash(),
        expect: () => [SplashScreenState(state: SplashAction.unauthenticated)],
        verify: (_) {
          verify(mockUserService.loadToken()).called(1);
        },
      );

      blocTest<SplashScreenCubit, SplashScreenState>(
        'emits onboarding when profile is incomplete',
        build: () {
          SharedPreferences.setMockInitialValues({'needsIntroduction': false});
          when(mockUserService.token).thenReturn('valid_token');
          when(mockUserService.getCurrentProfile()).thenAnswer(
            (_) async => ProfileRead(
              id: 1,
              userId: 1,
              birthday: null, // Incomplete profile
              country: null,
            ),
          );
          return SplashScreenCubit(userService: mockUserService);
        },
        act: (cubit) => cubit.splash(),
        expect: () => [SplashScreenState(state: SplashAction.onboarding)],
        verify: (_) {
          verify(mockUserService.loadToken()).called(1);
          verify(mockUserService.loadUser()).called(1);
          verify(mockUserService.getCurrentProfile()).called(1);
        },
      );

      blocTest<SplashScreenCubit, SplashScreenState>(
        'emits authenticated when profile is complete',
        build: () {
          SharedPreferences.setMockInitialValues({'needsIntroduction': false});
          when(mockUserService.token).thenReturn('valid_token');
          when(mockUserService.getCurrentProfile()).thenAnswer(
            (_) async => ProfileRead(
              id: 1,
              userId: 1,
              birthday: DateTime(1990, 1, 1),
              country: 'US',
              city: 'New York',
              phoneNumber: '+1234567890',
              discordTag: 'user#1234',
              shortBio: 'Test bio',
              languages: ['English', 'Spanish'],
            ),
          );
          return SplashScreenCubit(userService: mockUserService);
        },
        act: (cubit) => cubit.splash(),
        expect: () => [SplashScreenState(state: SplashAction.authenticated)],
        verify: (_) {
          verify(mockUserService.loadToken()).called(1);
          verify(mockUserService.loadUser()).called(1);
          verify(mockUserService.getCurrentProfile()).called(1);
        },
      );

      blocTest<SplashScreenCubit, SplashScreenState>(
        'emits unauthenticated when token is invalid',
        build: () {
          SharedPreferences.setMockInitialValues({'needsIntroduction': false});
          when(mockUserService.token).thenReturn('invalid_token');
          when(mockUserService.getCurrentProfile())
              .thenThrow(Exception('Invalid token'));
          return SplashScreenCubit(userService: mockUserService);
        },
        act: (cubit) => cubit.splash(),
        expect: () => [SplashScreenState(state: SplashAction.unauthenticated)],
        verify: (_) {
          verify(mockUserService.loadToken()).called(1);
          verify(mockUserService.loadUser()).called(1);
          verify(mockUserService.removeToken()).called(1);
        },
      );
    });

    group('isProfileIncomplete', () {
      blocTest<SplashScreenCubit, SplashScreenState>(
        'returns true when birthday is null',
        build: () => SplashScreenCubit(userService: mockUserService),
        act: (cubit) {
          final profile = ProfileRead(
            id: 1,
            userId: 1,
            birthday: null,
            country: 'US',
            city: 'New York',
            phoneNumber: '+1234567890',
            discordTag: 'user#1234',
            shortBio: 'Test bio',
            languages: ['English', 'Spanish'],
          );
          expect(cubit.isProfileIncomplete(profile), isTrue);
        },
      );

      blocTest<SplashScreenCubit, SplashScreenState>(
        'returns true when country is null',
        build: () => SplashScreenCubit(userService: mockUserService),
        act: (cubit) {
          final profile = ProfileRead(
            id: 1,
            userId: 1,
            birthday: DateTime(1990, 1, 1),
            country: null,
            city: 'New York',
            phoneNumber: '+1234567890',
            discordTag: 'user#1234',
            shortBio: 'Test bio',
            languages: ['English', 'Spanish'],
          );
          expect(cubit.isProfileIncomplete(profile), isTrue);
        },
      );

      blocTest<SplashScreenCubit, SplashScreenState>(
        'returns false when profile is complete',
        build: () => SplashScreenCubit(userService: mockUserService),
        act: (cubit) {
          final profile = ProfileRead(
            id: 1,
            userId: 1,
            birthday: DateTime(1990, 1, 1),
            country: 'US',
            city: 'New York',
            phoneNumber: '+1234567890',
            discordTag: 'user#1234',
            shortBio: 'Test bio',
            languages: ['English', 'Spanish'],
          );
          expect(cubit.isProfileIncomplete(profile), isFalse);
        },
      );
    });

    group('ProfileEmpty Getter', () {
      test('profile isEmpty getter works correctly', () {
        final emptyProfile = ProfileRead(
          id: 1,
          userId: 1,
        );
        expect(emptyProfile.isEmpty, isTrue);

        final filledProfile = ProfileRead(
          id: 1,
          userId: 1,
          birthday: DateTime(1990, 1, 1),
          country: 'US',
        );
        expect(filledProfile.isEmpty, isFalse);
      });
    });
  });
}
