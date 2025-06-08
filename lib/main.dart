import 'package:flutter/material.dart';
import 'package:pet_store_mobile_app/config/env_config.dart';
import 'package:pet_store_mobile_app/screens/cart_screen.dart';
import 'package:pet_store_mobile_app/screens/home_screen.dart';
import 'package:pet_store_mobile_app/screens/login_screen.dart';
import 'package:pet_store_mobile_app/screens/my_profile_screen.dart';
import 'package:pet_store_mobile_app/screens/orders_screen.dart';
import 'package:pet_store_mobile_app/screens/register_screen.dart';
import 'package:pet_store_mobile_app/screens/favorites_screen.dart';
import 'package:pet_store_mobile_app/services/auth_service.dart';

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
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
        cardTheme: const CardTheme(
          color: Colors.white,
          elevation: 2,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
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
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        cardTheme: CardTheme(
          color: Colors.grey[900],
          elevation: 2,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      // make the app theme mode follow the system theme mode
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const MyProfileScreen(),
        '/cart': (context) => const CartScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      setState(() {
        _isAuthenticated = isAuthenticated;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _isAuthenticated ? const HomeScreen() : const LoginScreen();
  }
}
