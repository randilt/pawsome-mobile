import 'package:flutter/material.dart';
import 'package:pet_store_mobile_app/services/biometric_service.dart';

class BiometricAuthButton extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback? onFailure;
  final String buttonText;
  final bool isLoading;

  const BiometricAuthButton({
    Key? key,
    required this.onSuccess,
    this.onFailure,
    this.buttonText = 'Authenticate',
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<BiometricAuthButton> createState() => _BiometricAuthButtonState();
}

class _BiometricAuthButtonState extends State<BiometricAuthButton> {
  final BiometricService _biometricService = BiometricService();
  bool _isChecking = false;

  Future<void> _authenticate() async {
    if (widget.isLoading || _isChecking) return;

    setState(() => _isChecking = true);

    try {
      final isAvailable = await _biometricService.isBiometricAvailable();

      if (!isAvailable) {
        if (widget.onFailure != null) {
          widget.onFailure!();
        }
        return;
      }

      final authenticated = await _biometricService.authenticate();

      if (authenticated) {
        widget.onSuccess();
      } else if (widget.onFailure != null) {
        widget.onFailure!();
      }
    } catch (e) {
      if (widget.onFailure != null) {
        widget.onFailure!();
      }
    } finally {
      setState(() => _isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _authenticate,
      icon: _isChecking || widget.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.fingerprint),
      label: Text(widget.buttonText),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
