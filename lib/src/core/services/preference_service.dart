import 'dart:convert';

import 'package:party_planner/src/core/services/user_service.dart';

import '../../data/clients/preference_client.dart';
import '../models/preference.dart';

class PreferencesService {
  final PreferencesApiClient _apiClient;
  final UserService _userService;

  PreferencesService({
    required PreferencesApiClient apiClient,
    required UserService userService,
  })  : _apiClient = apiClient,
        _userService = userService;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_userService.token != null)
          'Authorization': 'Bearer ${_userService.token}',
      };

  Future<PreferenceRead> createPreference(PreferenceCreate preference) async {
    final response = await _apiClient.post(
      '/preferences/',
      headers: _headers,
      body: preference.toJson(),
    );

    if (response.statusCode == 201) {
      return PreferenceRead.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to create preference. Status code: ${response.statusCode}',
      );
    }
  }

  Future<PreferenceRead> getCurrentUserPreferences() async {
    final response = await _apiClient.get('/preferences/me', headers: _headers);

    if (response.statusCode == 200) {
      return PreferenceRead.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to fetch preferences. Status code: ${response.statusCode}',
      );
    }
  }

  Future<PreferenceRead> getPreferenceById(int preferenceId) async {
    final response = await _apiClient.get(
      '/preferences/$preferenceId/',
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return PreferenceRead.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Preference not found');
    } else {
      throw Exception(
        'Failed to fetch preference. Status code: ${response.statusCode}',
      );
    }
  }

  Future<PreferenceRead> updatePreference(
    int preferenceId,
    PreferenceUpdate preference,
  ) async {
    final response = await _apiClient.patch(
      '/preferences/$preferenceId/',
      headers: _headers,
      body: preference.toJson(),
    );

    if (response.statusCode == 200) {
      return PreferenceRead.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Preference not found');
    } else if (response.statusCode == 422) {
      throw Exception('Validation error: ${response.body}');
    } else {
      throw Exception(
        'Failed to update preference. Status code: ${response.statusCode}',
      );
    }
  }

  Future<void> deletePreference(int preferenceId) async {
    final response = await _apiClient.delete(
      '/preferences/$preferenceId/',
      headers: _headers,
    );

    if (response.statusCode != 204) {
      throw Exception(
        'Failed to delete preference. Status code: ${response.statusCode}',
      );
    }
  }

  Future<PreferenceRead> getPreferencesByUserId(int userId) async {
    final response = await _apiClient.get(
      '/preferences/by-user/$userId',
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return PreferenceRead.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Preferences not found');
    } else {
      throw Exception(
        'Failed to fetch preferences. Status code: ${response.statusCode}',
      );
    }
  }
}
