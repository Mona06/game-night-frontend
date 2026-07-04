import 'package:party_planner/src/core/models/ttrpg.dart';

enum AttendancePreference { online, onsite, both }

enum RolePreference { player, gamemaster, both }

class PreferenceCreate {
  final AttendancePreference attendancePreference;
  final RolePreference rolePreference;
  final List<String> ttrpgs;

  PreferenceCreate({
    required this.attendancePreference,
    required this.rolePreference,
    required this.ttrpgs,
  });

  Map<String, dynamic> toJson() {
    return {
      'attendance_preference': attendancePreference.name,
      'role_preference': rolePreference.name,
      'ttrpgs': ttrpgs,
    };
  }
}

class PreferenceRead {
  final int id;
  final int userId;
  final AttendancePreference attendancePreference;
  final RolePreference rolePreference;
  final List<TTRPGRead> ttrpgs;

  PreferenceRead({
    required this.id,
    required this.userId,
    required this.attendancePreference,
    required this.rolePreference,
    required this.ttrpgs,
  });

  factory PreferenceRead.fromJson(Map<String, dynamic> json) {
    return PreferenceRead(
      id: json['id'],
      userId: json['user_id'],
      attendancePreference: AttendancePreference.values.firstWhere(
        (e) => e.name == json['attendance_preference'],
      ),
      rolePreference: RolePreference.values.firstWhere(
        (e) => e.name == json['role_preference'],
      ),
      ttrpgs: (json['ttrpgs'] as List)
          .map((ttrpg) => TTRPGRead.fromJson(ttrpg))
          .toList(),
    );
  }
}

class PreferenceUpdate {
  final AttendancePreference? attendancePreference;
  final RolePreference? rolePreference;
  final List<String>? ttrpgs;

  PreferenceUpdate({
    this.attendancePreference,
    this.rolePreference,
    this.ttrpgs,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (attendancePreference != null) {
      json['attendance_preference'] = attendancePreference!.name;
    }
    if (rolePreference != null) {
      json['role_preference'] = rolePreference!.name;
    }
    if (ttrpgs != null) {
      json['ttrpgs'] = ttrpgs;
    }
    return json;
  }
}
