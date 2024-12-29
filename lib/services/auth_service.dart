import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class AuthService {
  static const String baseUrl = 'http://localhost/pawsome/api';
  static const String sessionCookieKey = 'PHPSESSID';

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/user/login.php'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // for non-web platforms, manually handle the cookie
        if (!kIsWeb) {
          String? cookie = response.headers['set-cookie'];
          if (cookie != null) {
            final sessionId = cookie.split(';')[0];
            await saveSessionCookie(sessionId);
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<String?> getSessionCookie() async {
    // for web, we don't need to manually handle cookies so return null
    if (kIsWeb) return null;

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(sessionCookieKey);
  }

  Future<void> saveSessionCookie(String cookie) async {
    // only save cookie manually for non-web platforms
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(sessionCookieKey, cookie);
  }

  Future<void> clearSessionCookie() async {
    // only clear cookie manually for non-web platforms
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(sessionCookieKey);
  }

  Future<void> logout() async {
    try {
      final cookie = await getSessionCookie();
      if (cookie != null) {
        await http.post(
          Uri.parse('$baseUrl/auth/logout.php'),
          headers: {'Cookie': cookie},
        );
      }
      await clearSessionCookie();
    } catch (e) {
      print('Logout error: $e');
    }
  }
}
