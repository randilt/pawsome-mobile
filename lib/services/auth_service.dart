import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/env_config.dart';
import '../models/user.dart';

class AuthService {
  static final String baseUrl = EnvConfig.apiBaseUrl;
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  // Save token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  // Save user data
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  // Get stored user
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(userKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Clear stored data
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(userKey);
  }

  // Register user
  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save token and user data
        if (responseData['token'] != null) {
          await saveToken(responseData['token']);
        }
        if (responseData['user'] != null) {
          final user = User.fromJson(responseData['user']);
          await saveUser(user);
        }

        return {
          'success': true,
          'message': 'Registration successful',
          'user': responseData['user'],
          'token': responseData['token'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      print('Registration error: $e');
      return {
        'success': false,
        'message': 'An error occurred during registration: $e',
      };
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Save token and user data
        if (responseData['token'] != null) {
          await saveToken(responseData['token']);
        }
        if (responseData['user'] != null) {
          final user = User.fromJson(responseData['user']);
          await saveUser(user);
        }

        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      final token = await getToken();

      print('Starting logout process...');
      print('Token: $token');

      if (token != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        print('Logout response status: ${response.statusCode}');
        print('Logout response body: ${response.body}');
      }

      // Clear local data regardless of API response
      await clearAuthData();
      return true;
    } catch (e) {
      print('Logout error: $e');
      // Still clear local data even if API call fails
      await clearAuthData();
      return true; // Return true to allow logout even if API fails
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  // Get current user info from API
  Future<User?> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        final user = User.fromJson(userData);
        await saveUser(user); // Update local user data
        return user;
      }
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  // Get authorization headers
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> debugAuthStatus() async {
    final token = await getToken();
    final user = await getUser();

    print('=== AUTH DEBUG ===');
    print('Token exists: ${token != null}');
    print('Token: ${token?.substring(0, 20)}...');
    print('User exists: ${user != null}');
    print('User name: ${user?.name}');
    print('==================');
  }
}
