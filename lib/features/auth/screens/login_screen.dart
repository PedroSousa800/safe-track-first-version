// lib/features/auth/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pinController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final _auth = LocalAuthentication();

  String? _storedPin;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStoredPin();
  }

  Future<void> _loadStoredPin() async {
    final pin = await _storage.read(key: 'pin');
    setState(() {
      _storedPin = pin;
      _isLoading = false;
    });
    if (pin != null) _authenticateWithBiometrics();
  }

  Future<void> _authenticateWithBiometrics() async {
    final canCheckBiometrics = await _auth.canCheckBiometrics;
    if (!canCheckBiometrics) return;

    final authenticated = await _auth.authenticate(
      localizedReason: 'Use a biometria para entrar',
      options: const AuthenticationOptions(biometricOnly: true),
    );

    if (authenticated && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _verifyPin() async {
    if (_pinController.text == _storedPin) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _error = 'PIN incorreto');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'PIN',
                errorText: _error,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyPin,
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _authenticateWithBiometrics,
              child: const Text('Ou usar biometria'),
            ),
          ],
        ),
      ),
    );
  }
}
