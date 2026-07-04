import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:party_planner/src/core/services/preference_service.dart';
import 'package:party_planner/src/ui/features/user_profile/cubit/profile_state.dart';

import '../../../../core/models/preference.dart';
import '../../../../core/models/user.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/services/user_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserService _userService;
  final PreferencesService _preferencesService;

  ProfileCubit(this._userService, this._preferencesService)
      : super(
          ProfileState(
            displayName: '',
            birthdate: '',
            city: '',
            phoneNumber: '',
            discordTag: '',
            bio: '',
            languages: [],
            attendancePreference: '',
            ttrpgs: [],
            rolePreference: '',
            attendanceStats: AttendanceStats(
              totalSessions: 0,
              presentSessions: 0,
              absentSessions: 0,
            ),
            isOwnProfile: true,
            isFriend: false,
            profileImageBase64: '',
          ),
        );

  Future<void> loadProfile({int? userId}) async {
    try {
      // emit(state.copyWith(isLoading: true, error: null));

      final attendanceStats = AttendanceStats(
        totalSessions: 0,
        presentSessions: 0,
        absentSessions: 0,
      );

      if (userId == null) {
        final results = await Future.wait([
          _userService.getCurrentUser(),
          _userService.getCurrentProfile(),
          _preferencesService.getCurrentUserPreferences(),
        ]);

        final UserPublic currentUser = results[0] as UserPublic;
        final ProfileRead userProfile = results[1] as ProfileRead;
        final PreferenceRead profilePreferences = results[2] as PreferenceRead;

        final languages = userProfile.languages ?? [];
        final gamesPreference =
            profilePreferences.ttrpgs.map((ttrpg) => ttrpg.name).toList();
        final attendancePreference =
            profilePreferences.attendancePreference.name;
        final rolePreference = profilePreferences.rolePreference.name;

        emit(
          state.copyWith(
            displayName: currentUser.displayName ?? currentUser.username,
            bio: userProfile.shortBio ?? '',
            birthdate: DateFormat('yyyy-MM-dd').format(userProfile.birthday!),
            cityState:
                '${userProfile.city ?? ''}, ${userProfile.country ?? 'Not provided'}',
            phoneNumber: userProfile.phoneNumber ?? 'Not provided',
            discordTag: userProfile.discordTag ?? '',
            languages: languages,
            locationPreference: attendancePreference,
            rolePreference: rolePreference,
            ttrpgs: gamesPreference,
            attendanceStats: attendanceStats,
            isOwnProfile: true,
          ),
        );
      } else {
        final results = await Future.wait([
          _userService.getUserById(userId),
          _userService.getUserProfile(userId),
          _preferencesService.getPreferencesByUserId(userId),
        ]);

        final UserPublic userPublic = results[0] as UserPublic;
        final ProfileRead userProfile = results[1] as ProfileRead;
        final PreferenceRead profilePreferences = results[2] as PreferenceRead;

        emit(
          state.copyWith(
            displayName: userPublic.displayName,
            bio: userProfile.shortBio ?? '',
            birthdate: DateFormat('yyyy-MM-dd').format(userProfile.birthday!),
            cityState:
                '${userProfile.city ?? 'Not provided'}, ${userProfile.country ?? 'Not provided'}',
            phoneNumber: userProfile.phoneNumber ?? 'Not provided',
            discordTag: userProfile.discordTag ?? '',
            languages: userProfile.languages,
            locationPreference: profilePreferences.attendancePreference.name,
            rolePreference: profilePreferences.rolePreference.name,
            ttrpgs:
                profilePreferences.ttrpgs.map((ttrpg) => ttrpg.name).toList(),
            attendanceStats: attendanceStats,
            isOwnProfile: false,
          ),
        );
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Future<void> updateProfileImage(String? imagePath) async {
    if (imagePath == null) return;

    try {
      // Read the file
      File imageFile = File(imagePath);
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Convert to base64 with proper formatting
      String base64Image = 'data:image/jpeg;base64,${base64Encode(imageBytes)}';

      // Update state with new image
      emit(state.copyWith(profileImageBase64: base64Image));

      // TODO: Make API call to update profile image on server
      // final userProfile = await _userService.getCurrentProfile();
      //
      // await _userService.updateProfile(ProfileUpdate(
      //   discordTag: userProfile.discordTag,
      //   shortBio: userProfile.shortBio,
      //   phoneNumber: userProfile.phoneNumber,
      //   languages: userProfile.languages,
      //   birthday: DateFormat('yyyy-MM-dd').format(userProfile.birthday!),
      //   city: userProfile.city,
      //   country: userProfile.country,
      //   profileImage: base64Image,
      // ),);
    } catch (e) {
      print('Error updating profile image: $e');
    }
  }

  void updateBio(String newBio) {
    emit(state.copyWith(bio: newBio));
  }

  Future<void> submitBio(String newBio) async {
    final userProfile = await _userService.getCurrentProfile();

    await _userService.updateProfile(
      ProfileUpdate(
        discordTag: userProfile.discordTag,
        shortBio: newBio,
        phoneNumber: userProfile.phoneNumber,
        languages: userProfile.languages,
        birthday: DateFormat('yyyy-MM-dd').format(userProfile.birthday!),
        city: userProfile.city,
        country: userProfile.country,
      ),
    );
  }

  void toggleFriendship() {
    final currentState = state;
    emit(currentState.copyWith(isFriend: !currentState.isFriend));
  }
}
