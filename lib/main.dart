// lib/main.dart

import 'package:first_version/core/theme/app_theme.dart';
import 'package:first_version/features/auth/screens/home_screen.dart';
import 'package:first_version/features/auth/screens/login_screen.dart';
import 'package:first_version/features/auth/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:developer' as developer; // Para logging (boa prática)

void main() {
  runApp(const SafeTrackApp());
}

class SafeTrackApp extends StatelessWidget {
  const SafeTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeTrack',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Ou ThemeMode.light, ThemeMode.dark
      // Removendo as rotas nomeadas aqui, pois a navegação será controlada pela SplashScreen
      // com pushReplacement para maior controle do fluxo.
      home: const SplashScreen(), // Define SplashScreen como a rota inicial
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();
  bool _showClearButton = false; // Flag para controlar a visibilidade do botão "Limpar Dados"

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    developer.log('Verificando status de autenticação...', name: 'SplashScreen');
    try {
      String? token = await _storage.read(key: 'token');
      String? pin = await _storage.read(key: 'pin');
      developer.log('Token: $token, PIN: ${pin != null ? "******" : "null"}', name: 'SplashScreen');

      await Future.delayed(const Duration(seconds: 2)); // Atraso para a SplashScreen ser visível

      if (!mounted) return;

      if (token != null && !JwtDecoder.isExpired(token)) {
        // Token válido, navega para a HomeScreen
        developer.log('Token válido, navegando para HomeScreen.', name: 'SplashScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (pin != null && pin.isNotEmpty) {
        // PIN encontrado (mas sem token ou token expirado), navega para a LoginScreen (PIN pad)
        developer.log('PIN encontrado, navegando para LoginScreen (PIN).', name: 'SplashScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // Nenhum token nem PIN, navega para a RegisterScreen
        developer.log('Nenhum token ou PIN, navegando para RegisterScreen.', name: 'SplashScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
      }
    } on Exception catch (e) {
      developer.log('Erro ao verificar status de autenticação: $e', name: 'SplashScreen', error: e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados de autenticação: $e')),
      );
      // Em caso de erro, ainda permite a opção de limpar dados ou ir para registro
      setState(() {
        _showClearButton = true; // Permite que o botão de limpar dados apareça
      });
      // Permanece na SplashScreen e aguarda a interação do usuário para limpar dados/ir para registro
    }
  }

  // --- FUNÇÃO PARA LIMPAR DADOS ---
  Future<void> _clearAuthData() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'pin');
    developer.log('Dados de autenticação limpos!', name: 'SplashScreen');

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados de autenticação limpos!')),
    );
    // Após limpar, NAVEGA para a rota de registro
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }
  // --- FIM DA FUNÇÃO ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            // O botão só aparece se a flag _showClearButton for true
            if (_showClearButton) // Condicional para exibir o botão
              ElevatedButton(
                onPressed: _clearAuthData,
                child: const Text('Limpar Dados e Ir para Registro'),
              ),
          ],
        ),
      ),
    );
  }
}