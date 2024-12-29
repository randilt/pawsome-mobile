import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost/pawsome/api';
  static const String sessionCookieKey = 'PHPSESSID';

  Future<String?> getSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(sessionCookieKey);
  }

  Future<void> saveSessionCookie(String cookie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(sessionCookieKey, cookie);
  }

  Future<void> clearSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(sessionCookieKey);
  }

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
        print('Login response: ${response.body}');
        print('Headers: ${response.headers}');
        String? cookie =
            response.headers['set-cookie'] ?? response.headers['Set-Cookie'];
        if (cookie != null) {
          print('Cookie: $cookie');
          final sessionId = cookie.split(';')[0];
          await saveSessionCookie(sessionId);
          print('Logged in with session ID: $sessionId');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
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
