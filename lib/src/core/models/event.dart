import 'package:equatable/equatable.dart';

import '../../ui/features/events/cubit/event_details_state.dart';

enum AttendanceFormat { online, onsite, both }

enum EventStatus { recruiting, full, finalized }

class EventCreate extends Equatable {
  final int ttrpgId;
  final AttendanceFormat attendanceFormat;
  final int maxParticipants;
  final String? title;
  final String? description;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final String? coverImage;
  final List<String>? tasks;
  final String? city;
  final String? country;

  EventCreate({
    required this.ttrpgId,
    required this.attendanceFormat,
    required this.maxParticipants,
    this.title,
    this.description,
    this.startDateTime,
    this.endDateTime,
    this.coverImage,
    this.tasks,
    this.city,
    this.country,
  });

  @override
  List<Object?> get props => [
        ttrpgId,
        attendanceFormat,
        maxParticipants,
        title,
        description,
        startDateTime,
        endDateTime,
        coverImage,
        tasks,
        city,
        country,
      ];

  Map<String, dynamic> toJson() {
    return {
      'ttrpg_id': ttrpgId,
      'attendance_format': attendanceFormat.name.toUpperCase(),
      'max_participants': maxParticipants,
      'title': title,
      'description': description,
      'cover_image': coverImage,
      'tasks': tasks,
      'city': city,
      'country': country,
    }..removeWhere((key, value) => value == null);
  }
}

class EventRead extends Equatable {
  final int id;
  final int hostId;
  final int ttrpgId;
  final AttendanceFormat attendanceFormat;
  final int maxParticipants;
  final EventDetailStatus status;
  final String? title;
  final String? description;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final String? coverImage;
  final List<String>? tasks;
  final String? city;
  final String? country;

  EventRead({
    required this.id,
    required this.hostId,
    required this.ttrpgId,
    required this.attendanceFormat,
    required this.maxParticipants,
    required this.status,
    this.title,
    this.description,
    this.startDateTime,
    this.endDateTime,
    this.coverImage,
    this.tasks,
    this.city,
    this.country,
  });

  @override
  List<Object?> get props => [
        id,
        hostId,
        ttrpgId,
        attendanceFormat,
        maxParticipants,
        status,
        title,
        description,
        startDateTime,
        endDateTime,
        coverImage,
        tasks,
        city,
        country,
      ];

  factory EventRead.fromJson(Map<String, dynamic> json) {
    return EventRead(
      id: json['id'],
      hostId: json['host_id'],
      ttrpgId: json['ttrpg_id'],
      attendanceFormat: AttendanceFormat.values.firstWhere(
        (e) => e.name.toUpperCase() == json['attendance_format'],
      ),
      maxParticipants: json['max_participants'],
      status: EventDetailStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == json['status'],
      ),
      title: json['title'],
      description: json['description'],
      coverImage: json['cover_image'],
      tasks: json['tasks'] != null ? List<String>.from(json['tasks']) : null,
      city: json['city'],
      country: json['country'],
    );
  }
}

class EventReadDetailed extends EventRead {
  final List<EventParticipantRead> participants;

  EventReadDetailed({
    required super.id,
    required super.hostId,
    required super.ttrpgId,
    required super.attendanceFormat,
    required super.maxParticipants,
    required super.status,
    super.title,
    super.description,
    super.coverImage,
    super.tasks,
    super.city,
    super.country,
    required this.participants,
  });

  @override
  List<Object?> get props => super.props + [participants];

  factory EventReadDetailed.fromJson(Map<String, dynamic> json) {
    return EventReadDetailed(
      id: json['id'],
      hostId: json['host_id'],
      ttrpgId: json['ttrpg_id'],
      attendanceFormat: AttendanceFormat.values.firstWhere(
        (e) => e.name.toUpperCase() == json['attendance_format'],
      ),
      maxParticipants: json['max_participants'],
      status: EventDetailStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == json['status'],
      ),
      title: json['title'],
      description: json['description'],
      coverImage: json['cover_image'],
      tasks: json['tasks'] != null ? List<String>.from(json['tasks']) : null,
      city: json['city'],
      country: json['country'],
      participants: (json['participants'] as List)
          .map((p) => EventParticipantRead.fromJson(p))
          .toList(),
    );
  }
}

class EventParticipantRead extends Equatable {
  final int id;
  final int userId;

  EventParticipantRead({
    required this.id,
    required this.userId,
  });

  @override
  List<Object?> get props => [id, userId];

  factory EventParticipantRead.fromJson(Map<String, dynamic> json) {
    return EventParticipantRead(
      id: json['id'],
      userId: json['user_id'],
    );
  }
}
