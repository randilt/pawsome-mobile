import 'package:flutter/material.dart';
import 'package:pet_store_mobile_app/config/env_config.dart';
import 'package:pet_store_mobile_app/screens/home_screen.dart';
import 'package:pet_store_mobile_app/screens/login_screen.dart';
import 'package:pet_store_mobile_app/screens/my_profile_screen.dart';
import 'package:pet_store_mobile_app/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //load env variables
  await EnvConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawsome',
      debugShowCheckedModeBanner: false,
      // light theme configuration
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      // dark theme configuration
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      // make the app theme mode follow the system theme mode
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const MyProfileScreen(),
      },
    );
  }
}
