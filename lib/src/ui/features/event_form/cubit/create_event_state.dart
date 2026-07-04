import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../../core/models/event.dart';
import '../../../../core/models/location.dart';
import '../../../../core/models/user.dart';

class CreateEventState extends Equatable {
  const CreateEventState({
    required this.isPublic,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.invitees,
    required this.tasks,
    required this.hostId,
    // required this.status,
    required this.openSpots,
    required this.syncToDeviceCalendar,
    required this.numberOfParticipants,
    required this.attendanceFormat,
    this.selectedGame,
    this.image,
    this.city,
    this.country,
    this.address,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  final bool isPublic;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String? city;
  final int hostId;
  final String? country;
  final String? address;
  final Uint8List? image;
  final int numberOfParticipants;
  final List<UserPublic> invitees;
  final List<String> tasks;
  final String? selectedGame;
  final AttendanceFormat attendanceFormat;
  final bool isSubmitting;
  final bool isSuccess;

  // final EventStatus status;
  final int openSpots;
  final bool syncToDeviceCalendar;

  CreateEventState copyWith({
    bool? isPublic,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    LocationItem? location,
    Uint8List? image,
    int? numberOfParticipants,
    List<UserPublic>? invitees,
    List<String>? tasks,
    bool? syncToDeviceCalendar,
    AttendanceFormat? attendanceFormat,
    String? selectedGame,
    String? address,
    int? hostId,
    String? city,
    String? country,
    bool? isSubmitting,
    bool? isSuccess,
    // EventStatus? status,
  }) {
    return CreateEventState(
      hostId: hostId ?? this.hostId,
      isPublic: isPublic ?? this.isPublic,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      // location: location ?? this.location,
      image: image ?? this.image,
      invitees: invitees ?? this.invitees,
      tasks: tasks ?? this.tasks,
      numberOfParticipants: numberOfParticipants ?? this.numberOfParticipants,
      // status: status ?? this.status,
      syncToDeviceCalendar: syncToDeviceCalendar ?? this.syncToDeviceCalendar,
      attendanceFormat: attendanceFormat ?? this.attendanceFormat,
      openSpots: openSpots,
      selectedGame: selectedGame ?? this.selectedGame,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  bool get isValid {
    final bool areSharedStateValuesValid =
        title.isNotEmpty && selectedGame != null;

    if (isPublic) {
      return areSharedStateValuesValid;
    }
    return areSharedStateValuesValid && invitees.isNotEmpty && tasks.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        isPublic,
        title,
        description,
        city,
        hostId,
        startDate,
        endDate,
        country,
        address,
        image,
        numberOfParticipants,
        invitees,
        tasks,
        selectedGame,
        attendanceFormat,
        isSubmitting,
        isSuccess,
      ];
}
