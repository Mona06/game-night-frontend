import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/models/event.dart';

class EventsApiClient {
  final String baseUrl;

  EventsApiClient(this.baseUrl);

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
    Object? body,
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
    Object? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.patch(
      url,
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
  }

  Future<http.Response> getAllEvents(Map<String, String> headers) async {
    return await get('/events/all', headers: headers);
  }

  Future<http.Response> createEvent(
    EventCreate event,
    Map<String, String> headers,
  ) async {
    return await post(
      '/events/',
      headers: headers,
      body: event.toJson(),
    );
  }

  Future<http.Response> getMyEvents(Map<String, String> headers) async {
    return await get('/events/my-events', headers: headers);
  }

  Future<http.Response> joinEvent(
    int eventId,
    Map<String, String> headers,
  ) async {
    return await post(
      '/events/$eventId/join',
      headers: headers,
    );
  }

  Future<http.Response> getMatchingEvents(Map<String, String> headers) async {
    return await get('/events/matching', headers: headers);
  }

  Future<http.Response> getEventById(
    int eventId,
    Map<String, String> headers,
  ) async {
    return await get('/events/$eventId', headers: headers);
  }

  Future<http.Response> finalizeEvent(
    int eventId,
    Map<String, String> headers,
  ) async {
    return await patch(
      '/events/$eventId/finalize',
      headers: headers,
    );
  }
}
