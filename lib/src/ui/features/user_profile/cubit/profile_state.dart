import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String profileImageBase64;
  final String displayName;
  final String birthdate;
  final String? city;
  final String? phoneNumber;
  final String discordTag;
  final String bio;
  final List<String> languages;
  final String attendancePreference;
  final String? rolePreference;
  final List<String> ttrpgs;
  final AttendanceStats attendanceStats;
  final bool isOwnProfile;
  final bool isFriend;

  const ProfileState({
    required this.profileImageBase64,
    required this.displayName,
    required this.birthdate,
    required this.discordTag,
    required this.bio,
    required this.languages,
    required this.attendancePreference,
    required this.attendanceStats,
    required this.ttrpgs,
    this.city,
    this.phoneNumber,
    this.rolePreference,
    required this.isOwnProfile,
    required this.isFriend,
  });

  @override
  List<Object?> get props => [
        displayName,
        birthdate,
        city,
        phoneNumber,
        discordTag,
        bio,
        languages,
        attendancePreference,
        ttrpgs,
        rolePreference,
        attendanceStats,
        profileImageBase64,
      ];

  ProfileState copyWith({
    String? displayName,
    String? birthdate,
    String? cityState,
    String? phoneNumber,
    String? discordTag,
    String? bio,
    List<String>? languages,
    String? locationPreference,
    List<String>? ttrpgs,
    String? rolePreference,
    AttendanceStats? attendanceStats,
    bool? isOwnProfile,
    bool? isFriend,
    String? profileImageBase64,
  }) {
    return ProfileState(
      displayName: displayName ?? this.displayName,
      birthdate: birthdate ?? this.birthdate,
      city: cityState ?? city,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      discordTag: discordTag ?? this.discordTag,
      bio: bio ?? this.bio,
      languages: languages ?? this.languages,
      attendancePreference: locationPreference ?? attendancePreference,
      attendanceStats: attendanceStats ?? this.attendanceStats,
      rolePreference: rolePreference ?? this.rolePreference,
      ttrpgs: ttrpgs ?? this.ttrpgs,
      profileImageBase64: profileImageBase64 ?? this.profileImageBase64,
      isOwnProfile: isOwnProfile ?? this.isOwnProfile,
      isFriend: isFriend ?? this.isFriend,
    );
  }
}

class AttendanceStats {
  final int totalSessions;
  final int presentSessions;
  final int absentSessions;

  const AttendanceStats({
    required this.totalSessions,
    required this.presentSessions,
    required this.absentSessions,
  });
}
