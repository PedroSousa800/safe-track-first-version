import 'package:flutter/material.dart';
// ATENÇÃO: Verifique o caminho da importação do tema novamente.
// A forma recomendada é:
// import 'package:safe_track_first_version/core/theme/app_theme.dart';
// Se o erro "Target of URI doesn't exist" ou "isn't a dependency" persistir,
// verifique o nome do seu projeto no pubspec.yaml e execute 'flutter clean'/'flutter pub get'.
// Caso contrário, o caminho relativo correto para sua estrutura seria:
import '../../../core/theme/app_theme.dart'; // <<< CAMINHO RELATIVO PROVÁVEL PARA SUA ESTRUTURA
import 'dart:developer' as developer;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  void _register() async {
    // Basic validation
    if (_emailController.text.isEmpty ||
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

    // --- LÓGICA DE REGISTRO REAL E REMOÇÃO DO "DEAD CODE" ---
    bool registrationSuccessful = false; // Variável para controlar o sucesso
    try {
      // Simulação de um delay para registro
      await Future.delayed(const Duration(seconds: 2));

      // >>> SUBSTITUA O CONTEÚDO DESTE BLOCO PELA SUA CHAMADA DE BACKEND REAL <<<
      // Exemplo:
      // final response = await AuthService().register(_emailController.text, _passwordController.text);
      // if (response.statusCode == 200) { // Exemplo de verificação de sucesso
      //   registrationSuccessful = true;
      // } else {
      //   // Lógica para lidar com erros da API
      //   registrationSuccessful = false;
      // }

      // TEMPORÁRIO PARA REMOVER O AVISO DE DEAD CODE, SE AINDA NÃO TEM BACKEND
      registrationSuccessful = true; // Define como sucesso para testes visuais
                                    // Mude para 'false' para testar a mensagem de erro
    } catch (e) {
      // Lidar com erros de rede ou exceções do serviço
      developer.log('Erro durante o registro: $e', name: 'RegisterScreen');
      registrationSuccessful = false;
    }
    // --- FIM DA LÓGICA DE REGISTRO REAL ---


    if (!mounted) return; // Verifica se o widget ainda está montado APÓS o await

    // A condição agora usa a variável 'registrationSuccessful', tornando o bloco 'else' alcançável.
    if (registrationSuccessful) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário ${_emailController.text} registrado com sucesso!')),
      );
      Navigator.of(context).pop();
    } else {
      // Este 'else' não será "dead code" quando a condição acima for dinâmica
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao registrar usuário. Tente novamente.')),
      );
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
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