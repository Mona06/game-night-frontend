import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/models/preference.dart';

class PreferencesApiClient {
  final String baseUrl;

  PreferencesApiClient(this.baseUrl);

  // Base HTTP methods
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(url, headers: headers);
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
  }

  Future<http.Response> patch(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.patch(
      url,
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
  }

  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.delete(url, headers: headers);
  }

  // Preference-specific endpoints
  Future<http.Response> createPreference(
    PreferenceCreate preference,
    Map<String, String> headers,
  ) async {
    return await post(
      '/preferences/',
      headers: headers,
      body: preference.toJson(),
    );
  }

  Future<http.Response> getPreferenceById(
    int preferenceId,
    Map<String, String> headers,
  ) async {
    return await get(
      '/preferences/$preferenceId/',
      headers: headers,
    );
  }

  Future<http.Response> getCurrentUserPreferences(
    Map<String, String> headers,
  ) async {
    return await get(
      '/preferences/me',
      headers: headers,
    );
  }

  Future<http.Response> updatePreference(
    int preferenceId,
    PreferenceUpdate preference,
    Map<String, String> headers,
  ) async {
    return await patch(
      '/preferences/$preferenceId/',
      headers: headers,
      body: preference.toJson(),
    );
  }

  Future<http.Response> deletePreference(
    int preferenceId,
    Map<String, String> headers,
  ) async {
    return await delete(
      '/preferences/$preferenceId/',
      headers: headers,
    );
  }

  Future<http.Response> getPreferencesByUserId(
    int userId,
    Map<String, String> headers,
  ) async {
    return await get(
      '/preferences/by-user/$userId',
      headers: headers,
    );
  }
}
