import 'package:equatable/equatable.dart';

import '../../../../../core/models/preference.dart';

class AccountSettingsState extends Equatable {
  final String? displayName;
  final String? phoneNumber;
  final String? discordTag;
  final String? city;
  final String? country;
  final String? newPassword;
  final String? oldPassword;
  final bool isSubmitting;
  final bool isSuccess;
  final bool? obscureText;
  final bool eventUpdates;
  final bool reminders;
  final bool isLoading;
  final String? errorMessage;
  final Set<String> touchedFields;
  final bool isNewPasswordValid;
  final bool isOldPasswordValid;
  final List<String>? ttrpgs;
  final RolePreference? rolePreference;
  final AttendancePreference? attendancePreference;
  final String? shortBio;
  final bool hasLoggedOut;

  const AccountSettingsState({
    this.rolePreference,
    this.attendancePreference,
    this.displayName,
    this.city,
    this.country,
    this.phoneNumber,
    this.discordTag,
    this.oldPassword,
    this.newPassword,
    this.obscureText,
    this.isNewPasswordValid = true,
    this.isOldPasswordValid = true,
    this.eventUpdates = true,
    this.reminders = true,
    this.isLoading = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.hasLoggedOut = false,
    this.touchedFields = const {},
    this.errorMessage,
    this.ttrpgs,
    this.shortBio,
  });

  bool get isValid {
    return isNewPasswordValid &&
        isOldPasswordValid &&
        (newPassword == null || newPassword!.isNotEmpty) &&
        (oldPassword == null || oldPassword!.isNotEmpty);
  }

  @override
  List<Object?> get props => [
        newPassword,
        oldPassword,
        displayName,
        phoneNumber,
        discordTag,
        attendancePreference,
        eventUpdates,
        reminders,
        isLoading,
        isSubmitting,
        isSuccess,
        errorMessage,
        ttrpgs,
        rolePreference,
        city,
        country,
        isNewPasswordValid,
        isOldPasswordValid,
        isValid,
        touchedFields,
        shortBio,
        hasLoggedOut,
      ];

  AccountSettingsState copyWith({
    String? displayName,
    String? phoneNumber,
    String? discordTag,
    AttendancePreference? attendancePreference,
    String? oldPasswordFormFieldState,
    String? passwordFormFieldState,
    bool? isNewPasswordValid,
    bool? isOldPasswordValid,
    bool? eventUpdatesState,
    bool? remindersState,
    bool? isLoading,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    Set<String>? touchedFields,
    List<String>? ttrpgs,
    RolePreference? rolePreference,
    String? city,
    String? country,
    String? shortBio,
    bool? hasLoggedOut,
  }) {
    return AccountSettingsState(
      city: city ?? this.city,
      country: country ?? this.country,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      discordTag: discordTag ?? this.discordTag,
      oldPassword: oldPasswordFormFieldState ?? oldPassword,
      newPassword: passwordFormFieldState ?? newPassword,
      isNewPasswordValid: isNewPasswordValid ?? this.isNewPasswordValid,
      isOldPasswordValid: isOldPasswordValid ?? this.isOldPasswordValid,
      eventUpdates: eventUpdatesState ?? eventUpdates,
      reminders: remindersState ?? reminders,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      ttrpgs: ttrpgs ?? this.ttrpgs,
      touchedFields: touchedFields ?? this.touchedFields,
      attendancePreference: attendancePreference ?? this.attendancePreference,
      rolePreference: rolePreference ?? this.rolePreference,
      shortBio: shortBio ?? this.shortBio,
      hasLoggedOut: hasLoggedOut ?? this.hasLoggedOut,
    );
  }
}
