import 'package:flutter/material.dart';
import 'package:pet_store_mobile_app/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String _passwordStrength = '';
  Color _passwordStrengthColor = Colors.grey;

  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.length < 6) {
        _passwordStrength = 'Weak';
        _passwordStrengthColor = Colors.red;
      } else if (password.length < 10) {
        _passwordStrength = 'Medium';
        _passwordStrengthColor = Colors.orange;
      } else {
        _passwordStrength = 'Strong';
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final registrationResult = await _authService.register(
          _emailController.text,
          _passwordController.text,
        );

        if (registrationResult['success']) {
          // Registration successful, now log in
          final loginSuccess = await _authService.login(
            _emailController.text,
            _passwordController.text,
          );

          if (loginSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login after registration failed')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(registrationResult['message'])),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred during registration')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.pets,
                        size: 80,
                        color: Color(0xFF1565C0),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Create Your PawSome Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 48),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          prefixIcon:
                              Icon(Icons.person, color: Color(0xFF1565C0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF1565C0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF1565C0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Color(0xFF1565C0), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon:
                              Icon(Icons.email, color: Color(0xFF1565C0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF1565C0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF1565C0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Color(0xFF1565C0), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // You can add more sophisticated email validation here
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon:
                              Icon(Icons.lock, color: Color(0xFF1565C0)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xFF1565C0),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF1565C0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF1565C0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Color(0xFF1565C0), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        onChanged: _checkPasswordStrength,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Password Strength: $_passwordStrength',
                        style: TextStyle(color: _passwordStrengthColor),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Confirm your password',
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Color(0xFF1565C0)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xFF1565C0),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF1565C0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFF1565C0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Color(0xFF1565C0), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color(0xFF1565C0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Register',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Go back to login screen
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Color(0xFF1565C0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
