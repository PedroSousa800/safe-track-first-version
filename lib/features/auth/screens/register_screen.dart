// lib/features/auth/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:local_auth/local_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pinController = TextEditingController();

  final _storage = const FlutterSecureStorage();
  final _auth = LocalAuthentication();

  bool _isLoading = false;

  Future<void> _checkBiometricsAndRedirect() async {
    final canCheckBiometrics = await _auth.canCheckBiometrics;
    final storedToken = await _storage.read(key: 'token');

    if (storedToken != null && canCheckBiometrics) {
      final authenticated = await _auth.authenticate(
        localizedReason: 'Autentique-se para continuar',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else if (storedToken != null) {
      final pin = await _storage.read(key: 'pin');
      if (pin != null && mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final url = Uri.parse('https://safe-track-firstapi-production.up.railway.app/auth/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final loginUrl = Uri.parse('https://safe-track-firstapi-production.up.railway.app/auth/login');
      final loginResponse = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (loginResponse.statusCode == 200) {
        final data = jsonDecode(loginResponse.body);
        await _storage.write(key: 'pin', value: _pinController.text);
        await _storage.write(key: 'token', value: data['access_token']);

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao autenticar após o registro.')),
        );
      }
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao registrar usuário.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBiometricsAndRedirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Informe o email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Informe a senha' : null,
              ),
              TextFormField(
                controller: _pinController,
                decoration: const InputDecoration(labelText: 'PIN (4 dígitos)'),
                keyboardType: TextInputType.number,
                maxLength: 4,
                validator: (value) =>
                    value!.length != 4 ? 'PIN deve ter 4 dígitos' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      child: const Text('Registrar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
