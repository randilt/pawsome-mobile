import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';
import 'auth_service.dart';

class BaseService {
  static final String baseUrl = EnvConfig.apiBaseUrl;
  final AuthService _authService = AuthService();

  Future<http.Response> get(String endpoint) async {
    final headers = await _authService.getAuthHeaders();
    final url = endpoint.startsWith('http') ? endpoint : '$baseUrl/$endpoint';

    return http.get(
      Uri.parse(url),
      headers: headers,
    );
  }

  Future<http.Response> post(String endpoint, {Object? body}) async {
    final headers = await _authService.getAuthHeaders();
    final url = endpoint.startsWith('http') ? endpoint : '$baseUrl/$endpoint';

    return http.post(
      Uri.parse(url),
      body: body != null ? jsonEncode(body) : null,
      headers: headers,
    );
  }

  Future<http.Response> put(String endpoint, {Object? body}) async {
    final headers = await _authService.getAuthHeaders();
    final url = endpoint.startsWith('http') ? endpoint : '$baseUrl/$endpoint';

    return http.put(
      Uri.parse(url),
      body: body != null ? jsonEncode(body) : null,
      headers: headers,
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final headers = await _authService.getAuthHeaders();
    final url = endpoint.startsWith('http') ? endpoint : '$baseUrl/$endpoint';

    return http.delete(
      Uri.parse(url),
      headers: headers,
    );
  }
}
