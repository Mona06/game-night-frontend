import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:party_planner/src/core/models/user.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/features/register_form/cubit/register_cubit.dart';
import 'package:party_planner/src/ui/features/register_form/cubit/register_state.dart';

import 'register_cubit_test.mocks.dart';

@GenerateMocks([UserService])
void main() {
  late MockUserService mockUserService;

  setUp(() {
    mockUserService = MockUserService();
  });

  group('RegisterCubit', () {
    const initialRegisterState = RegisterState();

    blocTest<RegisterCubit, RegisterState>(
      'emits initial state',
      build: () => RegisterCubit(mockUserService),
      verify: (cubit) => expect(cubit.state, initialRegisterState),
    );

    group('updateUsername', () {
      blocTest<RegisterCubit, RegisterState>(
        'emits updated username and valid state when username is non-empty',
        build: () => RegisterCubit(mockUserService),
        act: (cubit) => cubit.updateUsername('validUsername'),
        expect: () => [
          initialRegisterState.copyWith(
            username: 'validUsername',
            isUsernameValid: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits updated username and invalid state when username is empty',
        build: () => RegisterCubit(mockUserService),
        act: (cubit) => cubit.updateUsername(''),
        expect: () => [
          initialRegisterState.copyWith(
            username: '',
            isUsernameValid: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('updateEmail', () {
      blocTest<RegisterCubit, RegisterState>(
        'emits updated email and valid state when email is valid',
        build: () => RegisterCubit(mockUserService),
        act: (cubit) => cubit.updateEmail('test@example.com'),
        expect: () => [
          initialRegisterState.copyWith(
            email: 'test@example.com',
            isEmailValid: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits updated email and invalid state when email is invalid',
        build: () => RegisterCubit(mockUserService),
        act: (cubit) => cubit.updateEmail('invalid-email'),
        expect: () => [
          initialRegisterState.copyWith(
            email: 'invalid-email',
            isEmailValid: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('updatePassword', () {
      blocTest<RegisterCubit, RegisterState>(
        'emits updated password and valid state when password is valid',
        build: () => RegisterCubit(mockUserService),
        act: (cubit) => cubit.updatePassword('Valid123'),
        expect: () => [
          initialRegisterState.copyWith(
            password: 'Valid123',
            isPasswordValid: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits updated password and invalid state when password is invalid',
        build: () => RegisterCubit(mockUserService),
        act: (cubit) => cubit.updatePassword('short'),
        expect: () => [
          initialRegisterState.copyWith(
            password: 'short',
            isPasswordValid: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('updateConfirmPassword', () {
      blocTest<RegisterCubit, RegisterState>(
        'emits updated confirmPassword and valid state when passwords match',
        build: () => RegisterCubit(mockUserService),
        seed: () => initialRegisterState.copyWith(password: 'Valid123'),
        act: (cubit) => cubit.updateConfirmPassword('Valid123'),
        expect: () => [
          initialRegisterState.copyWith(
            password: 'Valid123',
            confirmPassword: 'Valid123',
            isConfirmPasswordValid: true,
            errorMessage: null,
          ),
        ],
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits updated confirmPassword and invalid state when passwords do not match',
        build: () => RegisterCubit(mockUserService),
        seed: () => initialRegisterState.copyWith(password: 'Valid123'),
        act: (cubit) => cubit.updateConfirmPassword('Mismatch123'),
        expect: () => [
          initialRegisterState.copyWith(
            password: 'Valid123',
            confirmPassword: 'Mismatch123',
            isConfirmPasswordValid: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('submitForm', () {
      blocTest<RegisterCubit, RegisterState>(
        'emits success state when form submission succeeds',
        build: () => RegisterCubit(mockUserService),
        seed: () => initialRegisterState.copyWith(
          email: 'test@example.com',
          username: 'validUsername',
          password: 'Valid123',
          confirmPassword: 'Valid123',
          isEmailValid: true,
          isUsernameValid: true,
          isPasswordValid: true,
          isConfirmPasswordValid: true,
        ),
        setUp: () {
          when(
            mockUserService.register(
              'test@example.com',
              'validUsername',
              'Valid123',
            ),
          ).thenAnswer(
            (_) async => UserPublic(
              email: 'test@example.com',
              username: 'validUsername',
              id: -1,
              displayName: 'Valid123',
            ),
          );
        },
        act: (cubit) => cubit.submitForm(),
        expect: () => [
          initialRegisterState.copyWith(
            email: 'test@example.com',
            username: 'validUsername',
            password: 'Valid123',
            confirmPassword: 'Valid123',
            isEmailValid: true,
            isUsernameValid: true,
            isPasswordValid: true,
            isConfirmPasswordValid: true,
            isSubmitting: true,
            errorMessage: null,
          ),
          initialRegisterState.copyWith(
            email: 'test@example.com',
            username: 'validUsername',
            password: 'Valid123',
            confirmPassword: 'Valid123',
            isEmailValid: true,
            isUsernameValid: true,
            isPasswordValid: true,
            isConfirmPasswordValid: true,
            errorMessage: null,
            isSuccess: true,
          ),
        ],
        verify: (_) {
          verify(
            mockUserService.register(
              'test@example.com',
              'validUsername',
              'Valid123',
            ),
          ).called(1);
        },
      );

      blocTest<RegisterCubit, RegisterState>(
        'emits error state when form submission fails',
        build: () => RegisterCubit(mockUserService),
        seed: () => initialRegisterState.copyWith(
          email: 'test@example.com',
          username: 'validUsername',
          password: 'Valid123',
          confirmPassword: 'Valid123',
          isEmailValid: true,
          isUsernameValid: true,
          isPasswordValid: true,
          isConfirmPasswordValid: true,
        ),
        setUp: () {
          when(
            mockUserService.register(
              'test@example.com',
              'validUsername',
              'Valid123',
            ),
          ).thenThrow(Exception('Failed to register'));
        },
        act: (cubit) => cubit.submitForm(),
        expect: () => [
          initialRegisterState.copyWith(
            email: 'test@example.com',
            username: 'validUsername',
            password: 'Valid123',
            confirmPassword: 'Valid123',
            isEmailValid: true,
            isUsernameValid: true,
            isPasswordValid: true,
            isSubmitting: true,
            errorMessage: null,
            isConfirmPasswordValid: true,
          ),
          initialRegisterState.copyWith(
            email: 'test@example.com',
            username: 'validUsername',
            password: 'Valid123',
            confirmPassword: 'Valid123',
            isEmailValid: true,
            isUsernameValid: true,
            isPasswordValid: true,
            isSubmitting: false,
            errorMessage: 'Exception: Failed to register',
            isConfirmPasswordValid: true,
          ),
        ],
        verify: (_) {
          verify(
            mockUserService.register(
              'test@example.com',
              'validUsername',
              'Valid123',
            ),
          ).called(1);
        },
      );
    });
  });
}
