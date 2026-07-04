import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:party_planner/src/core/services/user_service.dart';

import '../../data/clients/event_client.dart';
import '../models/event.dart';

class EventsService {
  final EventsApiClient _apiClient;
  final UserService _userService;

  EventsService({
    required EventsApiClient apiClient,
    required userService,
  })  : _apiClient = apiClient,
        _userService = userService;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_userService.token != null)
          'Authorization': 'Bearer ${_userService.token}',
      };

  Future<List<EventRead>> getAllEvents() async {
    final response = await _apiClient.getAllEvents(_headers);

    if (response.statusCode == 200) {
      final List<dynamic> eventsJson = json.decode(response.body);
      return eventsJson.map((json) => EventRead.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      throw Exception('Events not found');
    } else {
      throw Exception(
        'Failed to load events. Status code: ${response.statusCode}',
      );
    }
  }

  Future<EventRead> createEvent(EventCreate event) async {
    final response = await _apiClient.createEvent(event, _headers);

    if (response.statusCode == 201) {
      return EventRead.fromJson(json.decode(response.body));
    } else if (response.statusCode == 422) {
      throw Exception('Validation error: ${response.body}');
    } else {
      throw Exception(
        'Failed to create event. Status code: ${response.statusCode}',
      );
    }
  }

  Future<List<EventRead>> getMyEvents() async {
    final response = await _apiClient.getMyEvents(_headers);

    if (response.statusCode == 200) {
      final List<dynamic> eventsJson = json.decode(response.body);
      return eventsJson.map((json) => EventRead.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      throw Exception('Events not found');
    } else {
      throw Exception(
        'Failed to load your events. Status code: ${response.statusCode}',
      );
    }
  }

  Future<void> joinEvent(int eventId) async {
    final response = await _apiClient.joinEvent(eventId, _headers);

    debugPrint('Response ${response.body}');

    if (response.statusCode != 200) {
      if (response.statusCode == 404) {
        throw Exception('Event not found');
      } else {
        throw Exception(
          'Failed to join event. Status code: ${response.statusCode}',
        );
      }
    }
  }

  Future<List<EventRead>> getMatchingEvents() async {
    final response = await _apiClient.getMatchingEvents(_headers);

    if (response.statusCode == 200) {
      final List<dynamic> eventsJson = json.decode(response.body);
      return eventsJson.map((json) => EventRead.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      throw Exception('No matching events found');
    } else {
      throw Exception(
        'Failed to load matching events. Status code: ${response.statusCode}',
      );
    }
  }

  Future<EventReadDetailed> getEventById(int eventId) async {
    final response = await _apiClient.getEventById(eventId, _headers);

    if (response.statusCode == 200) {
      return EventReadDetailed.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Event not found');
    } else {
      throw Exception(
        'Failed to load event details. Status code: ${response.statusCode}',
      );
    }
  }

  Future<EventRead> finalizeEvent(int eventId) async {
    final response = await _apiClient.finalizeEvent(eventId, _headers);

    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return EventRead.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Event not found');
    } else {
      throw Exception(
        'Failed to finalize event. Status code: ${response.statusCode}',
      );
    }
  }
}
