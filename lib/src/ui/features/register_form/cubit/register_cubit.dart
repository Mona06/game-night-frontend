import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_planner/src/ui/features/register_form/cubit/register_state.dart';

import '../../../../core/services/user_service.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final UserService _userService;
  RegisterCubit(this._userService) : super(RegisterState());

  void updateUsername(String username) {
    final isValid = username.isNotEmpty;
    emit(
      state.copyWith(
        username: username,
        isUsernameValid: isValid,
        errorMessage: null,
      ),
    );
  }

  void fieldTouched(String fieldName) {
    final newTouchedFields = Set<String>.from(state.touchedFields)
      ..add(fieldName);
    emit(state.copyWith(touchedFields: newTouchedFields));
  }

  String? getFieldError(String fieldName, bool isValid, String value) {
    if (!state.touchedFields.contains(fieldName) && value.isEmpty) {
      return null;
    }

    switch (fieldName) {
      case 'email':
        if (value.isEmpty) return 'Email is required';
        if (!isValid) return 'Please enter a valid email';
        break;
      case 'username':
        if (value.isEmpty) return 'Username is required';
        break;
      case 'password':
        if (value.isEmpty) return 'Password is required';
        if (!isValid) {
          return 'Password must contain at least 8 characters, including uppercase and a number';
        }
        break;
      case 'confirmPassword':
        if (value.isEmpty) return 'Please confirm your password';
        if (!isValid) return 'Passwords do not match';
        break;
    }
    return null;
  }

  void updateEmail(String email) {
    final isValid = _isEmailValid(email);
    emit(
      state.copyWith(
        email: email,
        isEmailValid: isValid,
        errorMessage: null,
      ),
    );
  }

  void updatePassword(String password) {
    final isValid = _isPasswordValid(password);
    emit(
      state.copyWith(
        password: password,
        isPasswordValid: isValid,
        isConfirmPasswordValid:
            state.confirmPassword.isEmpty || state.confirmPassword == password,
        errorMessage: null,
      ),
    );
  }

  void updateConfirmPassword(String confirmPassword) {
    final isValid = confirmPassword == state.password;
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isConfirmPasswordValid: isValid,
        errorMessage: null,
      ),
    );
  }

  Future<void> submitForm() async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          errorMessage: 'Please fix the errors in the form',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
      ),
    );

    try {
      await signUp();
      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  bool _isEmailValid(String email) {
    if (email.isEmpty) return false;
    final pattern = RegExp(
      r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return pattern.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    if (password.isEmpty) return false;
    final pattern = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$',
    );
    return pattern.hasMatch(password);
  }

  Future<void> signUp() async {
    try {
      await _userService.register(state.email, state.username, state.password);
    } catch (e) {
      throw Exception('Failed to register');
    }
  }
}
