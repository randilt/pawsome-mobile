import 'dart:convert';

import 'package:http/http.dart' as http;
import 'auth_service.dart';

class BaseService {
  static const String baseUrl = 'http://localhost/pawsome/api';
  final AuthService _authService = AuthService();

  Future<http.Response> get(String endpoint) async {
    final cookie = await _authService.getSessionCookie();
    return http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: cookie != null ? {'Cookie': cookie} : {},
    );
  }

  Future<http.Response> post(String endpoint, {Object? body}) async {
    final cookie = await _authService.getSessionCookie();
    return http.post(
      Uri.parse('$baseUrl/$endpoint'),
      body: body != null ? jsonEncode(body) : null,
      headers: {
        'Content-Type': 'application/json',
        if (cookie != null) 'Cookie': cookie,
      },
    );
  }
}
