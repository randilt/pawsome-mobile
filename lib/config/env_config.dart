import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ??
      'https://pawsome-app-production.up.railway.app/api';

  static String get apiVersion => dotenv.env['API_VERSION'] ?? '';

  static Future<void> initialize() async {
    // load the default .env file
    await dotenv.load(fileName: ".env");

    // load based on the environment
    // await dotenv.load(fileName: kReleaseMode ? ".env.production" : ".env");
  }
}
