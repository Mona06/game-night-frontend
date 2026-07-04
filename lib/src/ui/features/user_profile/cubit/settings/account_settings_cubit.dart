import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/preference.dart';
import '../../../../../core/models/user.dart';
import '../../../../../core/models/user_profile.dart';
import '../../../../../core/services/preference_service.dart';
import '../../../../../core/services/user_service.dart';
import 'account_settings_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  final UserService _userService;
  final PreferencesService _preferencesService;
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final displayNameController = TextEditingController();
  final discordTagController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  AccountSettingsCubit(this._userService, this._preferencesService)
      : super(
          const AccountSettingsState(
            eventUpdates: true,
            reminders: true,
          ),
        );

  @override
  Future<void> close() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    displayNameController.dispose();
    discordTagController.dispose();
    phoneNumberController.dispose();
    cityController.dispose();
    countryController.dispose();
    return super.close();
  }

  void updateOldPassword(String oldPassword) {
    emit(
      state.copyWith(
        oldPasswordFormFieldState: oldPassword,
        isOldPasswordValid: oldPassword.isEmpty,
        errorMessage: null,
      ),
    );
  }

  void updateNewPassword(String newPassword) {
    emit(
      state.copyWith(
        passwordFormFieldState: newPassword,
        isNewPasswordValid:
            newPassword.isEmpty || _isPasswordValid(newPassword),
        errorMessage: null,
      ),
    );
  }

  void updateDisplayName(String? name) {
    emit(state.copyWith(displayName: name));
  }

  void updatePhoneNumber(String? phone) {
    emit(state.copyWith(phoneNumber: phone));
  }

  void updateDiscordTag(String? tag) {
    emit(state.copyWith(discordTag: tag));
  }

  void updateGamesList(List<String> games) {
    emit(state.copyWith(ttrpgs: List.from(games)));
  }

  void updateAttendancePreference(String attendancePreference) {
    AttendancePreference preference;
    if (attendancePreference == AttendancePreference.online.name) {
      preference = AttendancePreference.online;
    } else if (attendancePreference == AttendancePreference.onsite.name) {
      preference = AttendancePreference.onsite;
    } else {
      preference = AttendancePreference.both;
    }
    emit(state.copyWith(attendancePreference: preference));
  }

  void updateRolePreference(String role) {
    RolePreference preference;
    if (role == RolePreference.player.name) {
      preference = RolePreference.player;
    } else if (role == RolePreference.gamemaster.name) {
      preference = RolePreference.gamemaster;
    } else {
      preference = RolePreference.both;
    }
    emit(state.copyWith(rolePreference: preference));
  }

  void updateCity(String? city) {
    emit(state.copyWith(city: city));
  }

  void updateCountry(String? country) {
    emit(state.copyWith(country: country));
  }

  void updateEventUpdates(bool eventUpdates) {
    emit(state.copyWith(eventUpdatesState: eventUpdates));
  }

  void updateReminders(bool reminders) {
    emit(state.copyWith(remindersState: reminders));
  }

  Future<void> loadSettings() async {
    try {
      emit(state.copyWith(isLoading: true));

      final results = await Future.wait([
        _userService.getCurrentUser(),
        _userService.getCurrentProfile(),
        _preferencesService.getCurrentUserPreferences(),
      ]);

      final UserPublic currentUser = results[0] as UserPublic;
      final ProfileRead userProfile = results[1] as ProfileRead;
      final PreferenceRead profilePreferences = results[2] as PreferenceRead;

      final List<String> gamesPreference =
          profilePreferences.ttrpgs.map((ttrpg) {
        return ttrpg.name;
      }).toList();
      final attendancePreference = profilePreferences.attendancePreference;
      final rolePreference = profilePreferences.rolePreference;

      final newState = state.copyWith(
        displayName: currentUser.displayName,
        phoneNumber: userProfile.phoneNumber,
        discordTag: userProfile.discordTag,
        shortBio: userProfile.shortBio,
        attendancePreference: attendancePreference,
        rolePreference: rolePreference,
        ttrpgs: gamesPreference,
        city: userProfile.city,
        country: userProfile.country,
        eventUpdatesState: true,
        remindersState: true,
        isLoading: false,
      );
      emit(newState);

      displayNameController.text = newState.displayName ?? '';
      phoneNumberController.text = newState.phoneNumber ?? '';
      discordTagController.text = newState.discordTag ?? '';
      cityController.text = newState.city ?? '';
      countryController.text = newState.country ?? '';
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load user settings',
        ),
      );
    }
  }

  Future<void> deleteProfile() async {
    UserPublic currentUser = await _userService.getCurrentUser();
    await _userService.deleteUser(
      currentUser.id,
    );
  }

  Future<void> logout() async {
    await _userService.logout();
    emit(state.copyWith(hasLoggedOut: true));
  }

  Future<void> submitForm() async {
    emit(
      state.copyWith(
        isSubmitting: true,
        errorMessage: null,
      ),
    );

    try {
      bool passwordUpdateNeeded = newPasswordController.text.isNotEmpty;
      bool passwordValid = _isPasswordValid(newPasswordController.text);
      bool oldPasswordProvided = oldPasswordController.text.isNotEmpty;

      if (passwordUpdateNeeded) {
        if (!passwordValid) {
          emit(state.copyWith(errorMessage: 'Invalid password format'));
          return;
        }

        if (!oldPasswordProvided) {
          emit(
            state.copyWith(
              errorMessage: 'Old password is required when changing password',
            ),
          );
          return;
        }

        await _userService.updateUser(
          (await _userService.getCurrentUser()).id,
          displayName: displayNameController.text.isNotEmpty
              ? displayNameController.text
              : null,
          password: newPasswordController.text,
        );
      } else {
        var userProfile = await _userService.getCurrentProfile();
        final profileUpdate = ProfileUpdate(
          shortBio: userProfile.shortBio,
          phoneNumber: phoneNumberController.text.isNotEmpty
              ? phoneNumberController.text
              : null,
          discordTag: discordTagController.text.isNotEmpty
              ? discordTagController.text
              : null,
          city: cityController.text.isNotEmpty ? cityController.text : null,
          country:
              countryController.text.isNotEmpty ? countryController.text : null,
          birthday: DateFormat('yyyy-MM-dd').format(userProfile.birthday!),
        );

        await _userService.updateProfile(profileUpdate);

        final preferenceUpdate = PreferenceUpdate(
          attendancePreference: state.attendancePreference,
          rolePreference: state.rolePreference,
          ttrpgs: state.ttrpgs,
        );

        await _preferencesService.updatePreference(
          (await _preferencesService.getCurrentUserPreferences()).id,
          preferenceUpdate,
        );
      }

      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: e.toString(),
        ),
      );
      rethrow;
    }
  }

  void fieldTouched(String fieldName) {
    final updatedTouchedFields = Set<String>.from(state.touchedFields)
      ..add(fieldName);
    emit(state.copyWith(touchedFields: updatedTouchedFields));
  }

  bool _isPasswordValid(String password) {
    if (password.isEmpty) return false;
    final pattern = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$',
    );
    return pattern.hasMatch(password);
  }

  String? getFieldError(String fieldName, bool isValid, String? value) {
    if (!state.touchedFields.contains(fieldName)) {
      return null;
    }

    switch (fieldName) {
      case 'oldPassword':
        if (newPasswordController.text.isNotEmpty && (value?.isEmpty ?? true)) {
          return 'Old password is required when changing password';
        }
        break;
      case 'newPassword':
        if (!isValid) {
          return 'Password must contain at least 8 characters, including uppercase and a number';
        }
        break;
    }
    return null;
  }
}
