import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.email = '',
    this.username = '',
    this.password = '',
    this.confirmPassword = '',
    this.isEmailValid = true,
    this.isUsernameValid = true,
    this.isPasswordValid = true,
    this.isConfirmPasswordValid = true,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.touchedFields = const {},
  });

  final String email;
  final String username;
  final String password;
  final String confirmPassword;
  final bool isEmailValid;
  final bool isUsernameValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final Set<String> touchedFields;

  bool get isValid =>
      isEmailValid &&
      isUsernameValid &&
      isPasswordValid &&
      isConfirmPasswordValid &&
      email.isNotEmpty &&
      username.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty;

  RegisterState copyWith({
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
    bool? isEmailValid,
    bool? isUsernameValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    Set<String>? touchedFields,
  }) {
    return RegisterState(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      touchedFields: touchedFields ?? this.touchedFields,
    );
  }

  @override
  List<Object?> get props => [
        email,
        username,
        password,
        confirmPassword,
        isEmailValid,
        isUsernameValid,
        isPasswordValid,
        isConfirmPasswordValid,
        isSubmitting,
        isSuccess,
        errorMessage,
        touchedFields,
      ];
}
