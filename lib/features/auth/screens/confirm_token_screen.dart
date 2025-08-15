// lib/features/auth/screens/confirm_token_screen.dart

import 'package:first_version/core/theme/app_theme.dart';
import 'package:first_version/routes/app_routes.dart';
import 'package:first_version/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class ConfirmTokenScreen extends StatefulWidget {
  final String email;

  const ConfirmTokenScreen({super.key, required this.email});

  @override
  State<ConfirmTokenScreen> createState() => _ConfirmTokenScreenState();
}

class _ConfirmTokenScreenState extends State<ConfirmTokenScreen> {
  final TextEditingController _tokenController = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _verifyToken() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _authService.verifyRecoveryToken(
        widget.email,
        _tokenController.text,
      );

      if (!mounted) return;

      if (response['success'] == true) {
        developer.log('Token verified successfully.', name: 'ConfirmTokenScreen');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token verificado. Agora, crie um novo PIN.'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        // Navega para a tela de finalização, passando o userId
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.finalizePin,
          arguments: response['user_id'],
        );
      } else {
        String errorMessage = response['message'] ?? 'Falha ao verificar o token.';
        setState(() {
          _error = errorMessage;
        });
        developer.log('Token verification failed: $_error', name: 'ConfirmTokenScreen');
      }
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
      developer.log('Error during token verification: $_error', name: 'ConfirmTokenScreen', error: e);
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
        title: const Text('Confirmar Código'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Digite o código de 6 dígitos que foi enviado para ${widget.email}.',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _tokenController,
                decoration: const InputDecoration(
                  labelText: 'Código de Verificação',
                  hintText: 'Digite o código aqui',
                  prefixIcon: Icon(Icons.vpn_key),
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 6) {
                    return 'Por favor, insira um código de 6 dígitos.';
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
                onPressed: _isLoading ? null : _verifyToken,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Confirmar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}