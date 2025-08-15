// lib/features/auth/screens/forgot_pin_screen.dart

import 'package:first_version/core/theme/app_theme.dart';
import 'package:first_version/routes/app_routes.dart';
import 'package:first_version/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class ForgotPinScreen extends StatefulWidget {
  const ForgotPinScreen({super.key});

  @override
  State<ForgotPinScreen> createState() => _ForgotPinScreenState();
}

class _ForgotPinScreenState extends State<ForgotPinScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendRecoveryEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // >>> ALTERAÇÃO AQUI: Agora esperamos um retorno do método startPinRecovery
      final response = await _authService.startPinRecovery(_emailController.text);

      if (!mounted) return;

      if (response['success'] == true) {
        developer.log('PIN recovery request successful.', name: 'ForgotPinScreen');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Um código foi enviado para o seu e-mail.'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.confirmToken,
          arguments: _emailController.text, // Passa o email para a próxima tela
        );
      } else {
        String errorMessage = response['message'] ?? 'Falha ao solicitar recuperação.';
        setState(() {
          _error = errorMessage;
        });
        developer.log('PIN recovery request failed: $_error', name: 'ForgotPinScreen');
      }
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
      developer.log('Erro na requisição: $_error', name: 'ForgotPinScreen', error: e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esqueceu o PIN?'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Insira o e-mail da sua conta para receber um código de recuperação.',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Digite seu e-mail',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um e-mail.';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor, insira um e-mail válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: AppTheme.errorColor),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendRecoveryEmail,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Enviar Código de Recuperação'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar para o Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}