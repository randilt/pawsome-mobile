import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:pet_store_mobile_app/config/env_config.dart';
import 'auth_service.dart';

class BaseService {
  static final String baseUrl = EnvConfig.apiBaseUrl;
  static final String apiV = EnvConfig.apiVersion;
  final AuthService _authService = AuthService();

  Future<http.Response> get(String endpoint) async {
    final cookie = await _authService.getSessionCookie();
    return http.get(
      Uri.parse('$baseUrl/$apiV/$endpoint'),
      headers: !kIsWeb && cookie != null ? {'Cookie': cookie} : {},
    );
  }

  Future<http.Response> post(String endpoint, {Object? body}) async {
    final cookie = await _authService.getSessionCookie();
    return http.post(
      Uri.parse('$baseUrl/$endpoint'),
      body: body != null ? jsonEncode(body) : null,
      headers: {
        'Content-Type': 'application/json',
        if (!kIsWeb && cookie != null) 'Cookie': cookie,
      },
    );
  }
}
