// lib/features/auth/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:first_version/services/auth_service.dart';
import 'package:first_version/features/auth/screens/finalize_pin_screen.dart';
import 'package:first_version/features/auth/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // CORRIGIDO: Mudar de .register para .registerUser
      final response = await _authService.registerUser(
        _emailController.text,
        _passwordController.text,
        _usernameController.text, // O endpoint de registro deve aceitar username
      );

      if (!mounted) return;

      if (response.containsKey('success') && response['success'] == true) { // Verifique 'success' em vez de 'message' string literal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro realizado com sucesso! Prossiga para finalizar o PIN.')), // Mensagem mais clara
        );
        // Garanta que 'user_id' esteja sendo retornado pelo AuthService.registerUser
        // Se o seu backend não retorna user_id no registro, você precisará ajustar isso.
        // Ou, se o PIN for genérico ou gerado no cliente, ajuste a FinalizePinScreen para não precisar de userId no construtor.
        // Assumindo que o backend retorna 'user_id' e 'email' é o que o FinalizePinScreen precisa.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FinalizePinScreen(
              userId: response['user_id'] ?? '', // Forneça um fallback, se userId puder ser null
              email: _emailController.text,
            ),
          ),
        );
      } else {
        // Se a resposta do backend tiver uma chave 'message' ou 'error'
        String errorMessage = response['message'] ?? response['error'] ?? 'Falha no registro: Erro desconhecido.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar: $e')),
      );
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
        title: const Text('Registro de Usuário'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nome de Usuário',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Registrar'),
                    ),
              // NOVO: Adicionado um botão para ir para a tela de Login
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('Já tem uma conta? Faça login!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}