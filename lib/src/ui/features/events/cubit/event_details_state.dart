import 'package:equatable/equatable.dart';
import 'package:party_planner/src/core/models/timeslot.dart';
import '../../../../core/models/event.dart';
import '../../../../core/models/location.dart';
import '../../../../core/models/user.dart';

enum EventDetailStatus { recruiting, full, finalized }

class EventDetailState extends Equatable {
  final int hostId;
  final String? coverImageBase64;
  final LocationItem? location;
  final String attendanceFormat;
  final bool isPublic;
  final String title;
  final String? description;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final List<UserPublic> invitees;
  final List<String>? tasks;
  final int? numberOfParticipants;
  final EventDetailStatus status;
  final int openSpots;
  final List<EventParticipantRead>? participants;
  final List<TimeslotItem> timeslots;
  final bool isEditing;
  final bool isLoading;
  final String? error;

  const EventDetailState({
    required this.hostId,
    required this.isPublic,
    required this.title,
    required this.description,
    required this.invitees,
    required this.tasks,
    required this.numberOfParticipants,
    required this.status,
    required this.openSpots,
    required this.participants,
    required this.attendanceFormat,
    required this.timeslots,
    this.coverImageBase64,
    this.startDateTime,
    this.endDateTime,
    this.location,
    this.isLoading = false,
    this.isEditing = false,
    this.error,
  });

  EventDetailState copyWith({
    int? hostId,
    String? title,
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    List<UserPublic>? invitees,
    List<String>? tasks,
    int? numberOfParticipants,
    EventDetailStatus? status,
    int? openSpots,
    List<EventParticipantRead>? participants,
    List<TimeslotItem>? timeslots,
    LocationItem? location,
    String? attendanceFormat,
    String? coverImage,
    bool? isLoading,
    bool? isEditing,
    String? error,
  }) {
    return EventDetailState(
      hostId: hostId ?? this.hostId,
      coverImageBase64: coverImage ?? coverImageBase64,
      location: location,
      attendanceFormat: attendanceFormat ?? this.attendanceFormat,
      isPublic: isPublic,
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      invitees: invitees ?? this.invitees,
      tasks: tasks ?? this.tasks,
      numberOfParticipants: numberOfParticipants ?? this.numberOfParticipants,
      status: status ?? this.status,
      openSpots: openSpots ?? this.openSpots,
      participants: participants ?? this.participants,
      timeslots: timeslots ?? this.timeslots,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        hostId,
        coverImageBase64,
        location,
        attendanceFormat,
        isPublic,
        title,
        description,
        startDateTime,
        endDateTime,
        invitees,
        tasks,
        numberOfParticipants,
        status,
        openSpots,
        participants,
        timeslots,
        isEditing,
        isLoading,
        error,
      ];
}
