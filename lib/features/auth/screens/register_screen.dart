import 'package:first_version/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'dart:developer' as developer;

import 'package:first_version/features/auth/screens/finalize_pin_screen.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _register() async {
    // Basic validation
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // --- LÓGICA DE REGISTRO REAL ---
    bool registrationSuccessful = false;
    String message = 'Erro ao registrar usuário. Tente novamente.';
    String? userId; 

    try {
      final response = await AuthService().registerUser(
        _usernameController.text, 
        _emailController.text,
        _passwordController.text,
      );

      if (response.containsKey('user_id') && response['user_id'] != null) {
        registrationSuccessful = true;
        message = response['message'] ?? 'Usuário registrado com sucesso!';
        userId = response['user_id']; 
      } else {
        message = response['error'] ?? 'Erro desconhecido ao registrar.';
        developer.log('Erro do backend: $message', name: 'RegisterScreen');
      }
    } catch (e) {
      message = 'Erro de conexão ou inesperado: $e';
      developer.log('Erro durante o registro: $e', name: 'RegisterScreen');
      registrationSuccessful = false;
    }
    // --- FIM DA LÓGICA DE REGISTRO REAL ---

    if (!mounted) return;

    if (registrationSuccessful) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      if (userId != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => FinalizePinScreen(
              userId: userId!,
              email: _emailController.text, // Passando o email
            ),
          ),
        );
      } else {
        Navigator.of(context).pop(); 
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    if (!mounted) return;
  
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Conta'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 48.0),
              Text(
                'Crie sua conta',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Preencha os campos abaixo para criar sua nova conta.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48.0),

              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nome de Usuário',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                  prefixIcon: Icon(Icons.lock_reset_outlined),
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _register(),
              ),
              const SizedBox(height: 32.0),

              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _register,
                      child: const Text('Registrar'),
                    ),

              const SizedBox(height: 24.0),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Já tem uma conta? Faça Login',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
