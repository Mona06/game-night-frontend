import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/preference.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/services/preference_service.dart';
import '../../../../core/services/user_service.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final UserService _userService;
  final PreferencesService _preferencesService;
  final PageController controller = PageController();

  OnboardingCubit({
    required UserService userService,
    required PreferencesService preferencesService,
  })  : _userService = userService,
        _preferencesService = preferencesService,
        super(
          OnboardingState(
            onboardingStatus: OnboardingStatus.onboarding,
            birthday: DateTime.now(),
            country: '',
            languages: [],
          ),
        );

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }

  void updateDisplayName(String displayName) {
    emit(state.copyWith(displayName: displayName));
  }

  void updateBio(String bio) {
    emit(state.copyWith(bio: bio));
  }

  void updateCity(String city) {
    emit(state.copyWith(city: city));
  }

  void updateCountry(String country) {
    emit(state.copyWith(country: country));
  }

  Future<void> updateBirthDate(DateTime birthDate) async {
    emit(state.copyWith(birthday: birthDate));
  }

  void updateLanguages(List<String> languages) {
    emit(state.copyWith(languages: languages));
  }

  void updateDiscordTag(String discordTag) {
    emit(state.copyWith(discordTag: discordTag));
  }

  void updatePhoneNumber(String phoneNumber) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  void updateGamesList(List<String> ttrpgs) {
    emit(state.copyWith(ttrpgs: ttrpgs));
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

  bool validatePersonalInfoPage() {
    return _calculateAge(state.birthday) >= 13 &&
        state.country.isNotEmpty &&
        state.languages.isNotEmpty;
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void nextPage() {
    int currentPage = controller.page?.round() ?? 0;
    bool canProceed = false;

    switch (currentPage) {
      case 0:
        canProceed = validatePersonalInfoPage();
        break;
      case 1:
        canProceed = true;
        break;
      case 2:
        canProceed = true;
        break;
      default:
        canProceed = true;
    }

    if (canProceed) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showValidationError(currentPage);
    }
  }

  void _showValidationError(int page) {
    emit(state.copyWith(onboardingStatus: OnboardingStatus.invalid));
  }

  void previousPage() {
    controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void jumpToPage(int page) {
    controller.jumpToPage(page);
  }

  Future<void> submitOnboarding() async {
    if (!validatePersonalInfoPage()) {
      _showValidationError(2);
      return;
    }

    emit(state.copyWith(onboardingStatus: OnboardingStatus.submitting));

    try {
      final profileCreate = ProfileCreate(
        phoneNumber: state.phoneNumber,
        discordTag: state.discordTag,
        shortBio: state.bio,
        languages: state.languages,
        birthday: DateFormat('yyyy-MM-dd').format(state.birthday),
        city: state.city,
        country: state.country,
      );

      await _userService.createProfile(profileCreate);

      final preferencesCreate = PreferenceCreate(
        attendancePreference: state.attendancePreference!,
        rolePreference: state.rolePreference!,
        ttrpgs: state.ttrpgs!,
      );

      await _preferencesService.createPreference(preferencesCreate);

      emit(state.copyWith(onboardingStatus: OnboardingStatus.onboarded));
    } catch (e) {
      emit(state.copyWith(onboardingStatus: OnboardingStatus.failed));
    }
  }

  void resetStatus() {
    emit(
      state.copyWith(
        onboardingStatus: OnboardingStatus.onboarding,
      ),
    );
  }
}
