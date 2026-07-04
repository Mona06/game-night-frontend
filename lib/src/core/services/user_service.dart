import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/clients/user_client.dart';
import '../models/token.dart';
import '../models/user.dart';
import '../models/user_profile.dart';

class UserService {
  final UserApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;
  String? token;
  UserPublic? currentUser;

  UserService._internal(this._apiClient)
      : _secureStorage = const FlutterSecureStorage();

  static UserService? _instance;

  factory UserService(UserApiClient apiClient) {
    _instance ??= UserService._internal(apiClient);
    return _instance!;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<ProfileRead> createProfile(ProfileCreate profile) async {
    final response = await _apiClient.post(
      '/users/me/profile',
      headers: _headers,
      body: profile.toJson(),
    );

    if (response.statusCode == 201) {
      return ProfileRead.fromJson(json.decode(response.body));
    } else {
      throw Exception('Profile creation failed');
    }
  }

  Future<ProfileRead> getCurrentProfile() async {
    final response =
        await _apiClient.get('/users/me/profile', headers: _headers);

    if (response.statusCode == 200) {
      return ProfileRead.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  Future<ProfileRead> getUserProfile(int userId) async {
    final response =
        await _apiClient.get('/users/$userId/profile', headers: _headers);

    if (response.statusCode == 200) {
      return ProfileRead.fromJson(json.decode(response.body));
    } else if (response.statusCode == 422) {
      throw Exception('Validation error: ${response.body}');
    } else {
      throw Exception(
        'Failed to fetch user profile. Status code: ${response.statusCode}',
      );
    }
  }

  Future<void> deleteUser(int userId) async {
    final response =
        await _apiClient.delete('users/$userId', headers: _headers);
    if (response.statusCode != 204) {
      throw Exception('User deletion failed');
    }
  }

  Future<UserPublic> updateUser(
    int id, {
    String? displayName,
    required String password,
  }) async {
    final response = await _apiClient.patch(
      '/users/$id',
      headers: _headers,
      body: {
        'displayname': displayName,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final user = UserPublic.fromJson(json.decode(response.body));
      saveUser(user);
      return user;
    } else if (response.statusCode == 422) {
      throw Exception('Validation error: ${response.body}');
    } else {
      throw Exception(
        'Failed to update user. Status code: ${response.statusCode}',
      );
    }
  }

  Future<ProfileRead> updateProfile(ProfileUpdate profile) async {
    final response = await _apiClient.patch(
      '/users/me/profile',
      headers: _headers,
      body: profile.toJson(),
    );

    if (response.statusCode == 200) {
      return ProfileRead.fromJson(json.decode(response.body));
    } else {
      throw Exception('Profile update failed');
    }
  }

  Future<void> saveUser(UserPublic user) async {
    currentUser = user;
    final userJson = jsonEncode(user.toJson());
    await _secureStorage.write(key: 'current_user', value: userJson);
  }

  Future<UserPublic?> loadUser() async {
    final userJson = await _secureStorage.read(key: 'current_user');
    if (userJson != null) {
      currentUser = UserPublic.fromJson(jsonDecode(userJson));
      return currentUser;
    }
    return null;
  }

  Future<void> removeUser() async {
    currentUser = null;
    await _secureStorage.delete(key: 'current_user');
  }

  Future<String?> loadToken() async {
    token = await _secureStorage.read(key: 'access_token');
    return token;
  }

  Future<void> saveToken(String newToken) async {
    token = newToken;
    await _secureStorage.write(key: 'access_token', value: newToken);
  }

  Future<void> removeToken() async {
    token = null;
    await _secureStorage.delete(key: 'access_token');
  }

  // User operations
  Future<List<UserPublic>> getUsers() async {
    try {
      final response = await _apiClient.get('/users/', headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = json.decode(response.body);
        return usersJson.map((json) => UserPublic.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Users not found');
      } else {
        throw Exception(
          'Failed to load users. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Future<UserPublic> getUserById(int userId) async {
    final response = await _apiClient.get('/users/$userId', headers: _headers);

    if (response.statusCode == 200) {
      return UserPublic.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch user: ${response.statusCode}');
    }
  }

  Future<UserPublic> getCurrentUser() async {
    final response = await _apiClient.get('/users/me', headers: _headers);

    if (response.statusCode == 200) {
      final user = UserPublic.fromJson(json.decode(response.body));
      await saveUser(user);
      return user;
    } else {
      throw Exception('Failed to fetch current user: ${response.statusCode}');
    }
  }

  Future<UserPublic> register(
    String email,
    String username,
    String password,
  ) async {
    final user = await _apiClient.register(email, username, password);
    await saveUser(user);
    return user;
  }

  Future<Token> login(String username, String password) async {
    final userToken = await _apiClient.login(username, password);
    await saveToken(userToken.accessToken);
    final user = await getCurrentUser();
    currentUser = user;
    saveUser(user);
    return userToken;
  }

  Future<void> logout() async {
    await removeToken();
    await removeUser();
  }
}
