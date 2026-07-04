import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/user_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserService _userService;

  LoginCubit(this._userService) : super(LoginState());

  void fieldTouched(String fieldName) {
    final newTouchedFields = Set<String>.from(state.touchedFields)
      ..add(fieldName);
    emit(state.copyWith(touchedFields: newTouchedFields));
  }

  void updateUsername(String username) {
    final isValid = _isUsernameValid(username);
    emit(
      state.copyWith(
        username: username,
        isUsernameValid: isValid,
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
        errorMessage: null,
      ),
    );
  }

  String? getFieldError(String fieldName, bool isValid, String value) {
    if (!state.touchedFields.contains(fieldName) && value.isEmpty) {
      return null;
    }

    switch (fieldName) {
      case 'username':
        if (value.isEmpty) return 'Username is required';
        break;
      case 'password':
        if (value.isEmpty) return 'Password is required';
        // if (!isValid) return 'Password is incorrect';
        break;
    }
    return null;
  }

  Future<void> signIn() async {
    if (!state.isValid) {
      final allFields = {'username', 'password'};
      emit(
        state.copyWith(
          touchedFields: allFields,
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
      await _login(state.username, state.password);

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

  Future<void> navigate(BuildContext context) async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    // await instance.setBool('needsOnboarding', true);
    final bool needsOnboarding = instance.getBool('needsOnboarding') ?? true;
    if (needsOnboarding) {
      instance.setBool('needsOnboarding', false);
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }

      return;
    } else {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  bool _isUsernameValid(String username) {
    return username.length >= 3;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  Future<void> _login(String username, String password) async {
    try {
      await _userService.login(username, password);
    } catch (e) {
      throw Exception('Login failed');
    }
  }
}
