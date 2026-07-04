import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:party_planner/src/core/models/token.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/features/login_form/cubit/login_cubit.dart';
import 'package:party_planner/src/ui/features/login_form/cubit/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([UserService, SharedPreferences])
void main() {
  late MockUserService mockUserService;

  setUp(() {
    mockUserService = MockUserService();
  });

  group('LoginCubit', () {
    const initialLoginState = LoginState();

    blocTest<LoginCubit, LoginState>(
      'emits initial state',
      build: () => LoginCubit(mockUserService),
      verify: (cubit) => expect(cubit.state, initialLoginState),
    );

    group('updateUsername', () {
      blocTest<LoginCubit, LoginState>(
        'emits updated username and valid state for valid input',
        build: () => LoginCubit(mockUserService),
        act: (cubit) => cubit.updateUsername('validUser'),
        expect: () => [
          initialLoginState.copyWith(
            username: 'validUser',
            isUsernameValid: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits updated username and invalid state for invalid input',
        build: () => LoginCubit(mockUserService),
        act: (cubit) => cubit.updateUsername('a'),
        expect: () => [
          initialLoginState.copyWith(
            username: 'a',
            isUsernameValid: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('updatePassword', () {
      blocTest<LoginCubit, LoginState>(
        'emits updated password and valid state for valid input',
        build: () => LoginCubit(mockUserService),
        act: (cubit) => cubit.updatePassword('validPass123'),
        expect: () => [
          initialLoginState.copyWith(
            password: 'validPass123',
            isPasswordValid: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits updated password and invalid state for invalid input',
        build: () => LoginCubit(mockUserService),
        act: (cubit) => cubit.updatePassword('123'),
        expect: () => [
          initialLoginState.copyWith(
            password: '123',
            isPasswordValid: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('signIn', () {
      blocTest<LoginCubit, LoginState>(
        'emits touched fields and error message when form is invalid',
        build: () => LoginCubit(mockUserService),
        act: (cubit) => cubit.signIn(),
        expect: () => [
          initialLoginState.copyWith(
            touchedFields: {'username', 'password'},
            errorMessage: 'Please fix the errors in the form',
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits submitting state and success state when login succeeds',
        build: () => LoginCubit(mockUserService),
        seed: () => initialLoginState.copyWith(
          username: 'validUser',
          password: 'validPass123',
          isUsernameValid: true,
          isPasswordValid: true,
        ),
        setUp: () {
          when(mockUserService.login('validUser', 'validPass123')).thenAnswer(
            (_) async => Token(
              accessToken: 'token',
              tokenType: 'bearer',
            ),
          );
        },
        act: (cubit) => cubit.signIn(),
        expect: () => [
          initialLoginState.copyWith(
            username: 'validUser',
            password: 'validPass123',
            isUsernameValid: true,
            isPasswordValid: true,
            isSubmitting: true,
            errorMessage: null,
          ),
          initialLoginState.copyWith(
            username: 'validUser',
            password: 'validPass123',
            isUsernameValid: true,
            isPasswordValid: true,
            isSubmitting: false,
            isSuccess: true,
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits submitting state and error message when login fails',
        build: () => LoginCubit(mockUserService),
        seed: () => initialLoginState.copyWith(
          username: 'validUser',
          password: 'validPass123',
          isUsernameValid: true,
          isPasswordValid: true,
        ),
        setUp: () {
          when(mockUserService.login('validUser', 'validPass123'))
              .thenThrow(Exception('Login failed'));
        },
        act: (cubit) => cubit.signIn(),
        expect: () => [
          initialLoginState.copyWith(
            username: 'validUser',
            password: 'validPass123',
            isUsernameValid: true,
            isPasswordValid: true,
            isSubmitting: true,
            errorMessage: null,
          ),
          initialLoginState.copyWith(
            username: 'validUser',
            password: 'validPass123',
            isUsernameValid: true,
            isPasswordValid: true,
            isSubmitting: false,
            errorMessage: 'Exception: Login failed',
          ),
        ],
      );
    });
  });
}
