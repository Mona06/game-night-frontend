import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState({
    this.username = '',
    this.password = '',
    this.isUsernameValid = true,
    this.isPasswordValid = true,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.touchedFields = const {},
  });

  final String username;
  final String password;
  final bool isUsernameValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final Set<String> touchedFields;

  bool get isValid =>
      isUsernameValid &&
      isPasswordValid &&
      username.isNotEmpty &&
      password.isNotEmpty;

  LoginState copyWith({
    String? username,
    String? password,
    bool? isUsernameValid,
    bool? isPasswordValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    Set<String>? touchedFields,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      touchedFields: touchedFields ?? this.touchedFields,
    );
  }

  @override
  List<Object?> get props => [
        username,
        password,
        isUsernameValid,
        isPasswordValid,
        isSubmitting,
        isSuccess,
        errorMessage,
        touchedFields,
      ];
}
