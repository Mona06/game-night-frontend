import 'dart:convert';

import '../../data/clients/ttrpg_client.dart';
import '../models/ttrpg.dart';
import 'user_service.dart';

class TTRPGService {
  final TTRPGApiClient _apiClient;
  final UserService _userService;

  TTRPGService({
    required TTRPGApiClient apiClient,
    required UserService userService,
  })  : _apiClient = apiClient,
        _userService = userService;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_userService.token != null)
          'Authorization': 'Bearer ${_userService.token}',
      };

  Future<List<TTRPGRead>> getAllTTRPGs() async {
    final response = await _apiClient.get('/ttrpgs/', headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TTRPGRead.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to fetch TTRPGs. Status code: ${response.statusCode}',
      );
    }
  }

  Future<TTRPGRead> createTTRPG(TTRPGCreate ttrpg) async {
    final response = await _apiClient.post(
      '/ttrpgs/',
      headers: _headers,
      body: ttrpg.toJson(),
    );

    if (response.statusCode == 201) {
      return TTRPGRead.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to create TTRPG. Status code: ${response.statusCode}',
      );
    }
  }
}
