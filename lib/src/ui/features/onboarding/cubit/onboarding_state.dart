import 'package:equatable/equatable.dart';

import '../../../../core/models/preference.dart';

enum OnboardingStatus {
  onboarding,
  submitting,
  onboarded,
  failed,
  invalid,
}

class OnboardingState extends Equatable {
  const OnboardingState({
    required this.birthday,
    required this.country,
    required this.languages,
    required this.onboardingStatus,
    this.rolePreference,
    this.attendancePreference,
    this.displayName,
    this.bio,
    this.city,
    this.discordTag,
    this.phoneNumber,
    this.ttrpgs,
  });

  final OnboardingStatus onboardingStatus;
  final String? displayName;
  final DateTime birthday;
  final String? bio;
  final String? city;
  final String country;
  final List<String> languages;
  final String? discordTag;
  final String? phoneNumber;
  final List<String>? ttrpgs;
  final RolePreference? rolePreference;
  final AttendancePreference? attendancePreference;

  OnboardingState copyWith({
    OnboardingStatus? onboardingStatus,
    String? displayName,
    String? bio,
    String? city,
    String? country,
    List<String>? languages,
    DateTime? birthday,
    String? discordTag,
    String? phoneNumber,
    List<String>? ttrpgs,
    RolePreference? rolePreference,
    AttendancePreference? attendancePreference,
  }) {
    return OnboardingState(
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
      displayName: displayName ?? this.displayName,
      birthday: birthday ?? this.birthday,
      languages: languages ?? this.languages,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      country: country ?? this.country,
      discordTag: discordTag ?? this.discordTag,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      ttrpgs: ttrpgs ?? this.ttrpgs,
      rolePreference: rolePreference ?? this.rolePreference,
      attendancePreference: attendancePreference ?? this.attendancePreference,
    );
  }

  @override
  List<Object?> get props => [
        onboardingStatus,
        displayName,
        birthday,
        bio,
        city,
        country,
        languages,
        discordTag,
        phoneNumber,
        ttrpgs,
        rolePreference,
        attendancePreference,
      ];
}
