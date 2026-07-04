import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/models/token.dart';
import '../../core/models/user.dart';

class UserApiClient {
  final String baseUrl;

  UserApiClient(
    this.baseUrl,
  );

  Future<http.Response> get(String path, {Map<String, String>? headers}) async {
    final Uri url = Uri.parse('$baseUrl$path');
    return await http.get(url, headers: headers);
  }

  Future<http.Response> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    bool isFormUrlEncoded = false,
  }) async {
    final Uri url = Uri.parse('$baseUrl$path');
    final encodedBody = isFormUrlEncoded ? body : json.encode(body);
    return await http.post(
      url,
      headers: headers,
      body: encodedBody,
    );
  }

  Future<http.Response> patch(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final Uri url = Uri.parse('$baseUrl$path');
    return await http.patch(
      url,
      headers: headers,
      body: json.encode(body),
    );
  }

  Future<http.Response> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    final Uri url = Uri.parse('$baseUrl$path');
    return await http.delete(url, headers: headers);
  }

  // Auth-specific endpoints
  Future<Token> login(String username, String password) async {
    final response = await post(
      '/token/',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': '',
        'username': username,
        'password': password,
      },
      isFormUrlEncoded: true,
    );

    if (response.statusCode == 200) {
      return Token.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      final errorBody = json.decode(response.body);
      throw Exception(
        'Unauthorized: ${errorBody['detail'] ?? 'Invalid credentials'}',
      );
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  Future<UserPublic> register(
    String email,
    String username,
    String password,
  ) async {
    final response = await post(
      '/users/',
      headers: {'Content-Type': 'application/json'},
      body: {
        'email': email,
        'username': username,
        'displayname': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return UserPublic.fromJson(json.decode(response.body));
    } else {
      final errorData = json.decode(response.body);
      throw Exception(
        'Registration failed: ${response.statusCode} - ${errorData['detail']}',
      );
    }
  }
}
