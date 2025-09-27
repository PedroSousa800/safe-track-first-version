// lib/features/auth/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:first_version/services/auth_service.dart';
import 'package:first_version/routes/app_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para os campos de texto do formulário
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Chave para identificar e validar o estado do formulário
  final _formKey = GlobalKey<FormState>();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void dispose() {
    // É crucial liberar os controladores para evitar vazamentos de memória
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Função assíncrona para lidar com o processo de registro do usuário
  void _registerUser() async {
    // Garante que o widget ainda está montado antes de atualizar o estado
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    // Usa a validação do formulário para verificar se os campos são válidos
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // CORREÇÃO: Esta chamada à função está correta, pois precisa de 3 argumentos
      // (email, password e username). O problema é que a função em
      // 'auth_service.dart' provavelmente só aceita 2 argumentos.
      final response = await _authService.registerUser(
        _emailController.text,
        _passwordController.text,
        _usernameController.text,
      );

      if (!mounted) return;

      // Verifica se a resposta da API indica sucesso
      if (response.containsKey('success') && response['success'] == true) {

        await _storage.write(key: 'email', value: _emailController.text.trim());                

        if (!mounted) return; 
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registro realizado com sucesso! Prossiga para finalizar o PIN.')),
        );

        // Navega para a tela de finalização do PIN, passando os dados necessários
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.finalizePin,
          arguments: {
            'user_id': response['user_id'], // Chave retornada pela API
            'email': _emailController.text,
          },
        );
      } else {
        // Exibe mensagem de erro da API
        String errorMessage = response['message'] ??
            response['error'] ??
            'Falha no registro: Erro desconhecido.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Captura e exibe erros da chamada à API
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar: $e')),
      );
    } finally {
      // Garante que o estado de carregamento é desativado no final da operação
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Campo para o nome de usuário
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome de Usuário',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome de usuário.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo para o email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Digite seu email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu email.';
                    }
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Por favor, insira um email válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo para a senha
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha.';
                    }
                    if (value.length < 8) {
                      return 'A senha deve ter pelo menos 8 caracteres.';
                    }
                    if (!value.contains(RegExp(r'[A-Z]'))) {
                      return 'A senha deve conter pelo menos uma letra maiúscula.';
                    }
                    if (!value.contains(RegExp(r'[a-z]'))) {
                      return 'A senha deve conter pelo menos uma letra minúscula.';
                    }
                    if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'A senha deve conter pelo menos um número.';
                    }
                    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                      return 'A senha deve conter pelo menos um caractere especial.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Campo para confirmar a senha
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha.';
                    }
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Botão de registro com indicador de carregamento
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          // Ação do botão: aciona a validação do formulário
                          if (_formKey.currentState!.validate()) {
                            _registerUser();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Registrar'),
                      ),
                const SizedBox(height: 16),
                // Botão para navegar para a tela de login
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: const Text('Já tem uma conta? Faça login!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
