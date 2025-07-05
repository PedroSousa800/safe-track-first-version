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
      routes: {
        '/': (context) => const SplashScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final _storage = const FlutterSecureStorage();
  bool _showClearButton = false; // Nova flag para controlar a visibilidade do botão

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeSplash(); // Chama uma nova função de inicialização
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAuthStatus();
    }
  }

  // Nova função para gerenciar o fluxo da splash screen
  Future<void> _initializeSplash() async {
    // Dê um pequeno delay para a UI renderizar o CircularProgressIndicator e o botão
    await Future.delayed(const Duration(milliseconds: 500)); // Ajuste o tempo conforme necessário

    // Define que o botão de limpeza pode ser exibido (se quisermos que ele esteja lá)
    setState(() {
      _showClearButton = true;
    });

    // Agora sim, verifica o status de autenticação
    _checkAuthStatus();
  }


  Future<void> _checkAuthStatus() async {
    final token = await _storage.read(key: 'token');
    final pin = await _storage.read(key: 'pin');

    String route;
    if (token != null && !JwtDecoder.isExpired(token)) {
      developer.log('Token encontrado e válido. Navegando para /home', name: 'SplashScreen');
      route = '/home';
    } else if (pin != null) {
      developer.log('PIN encontrado. Navegando para /login', name: 'SplashScreen');
      route = '/login';
    } else {
      developer.log('Nenhum token ou PIN. Navegando para /register', name: 'SplashScreen');
      route = '/register';
    }

    if (!mounted) return;
    // Só navega se a rota não for a tela de registro E o botão de limpeza não for para ser visível.
    // Ou, para fins de teste de limpeza, você pode deixar o botão sempre visível e apenas navegar para o registro.
    // A lógica abaixo garantirá que você veja o botão, mesmo que haja um PIN/token.
    // Você pode comentar esta navegação automática para testar o botão de limpeza.
    // Navigator.pushReplacementNamed(context, route); // Se você comentar esta linha, você terá que navegar manualmente.

    // NOVO: Adicionei uma condição para que a navegação automática só aconteça
    // se não for para a tela de registro, permitindo que você veja o botão de limpeza.
    // Ou, uma alternativa mais simples para o teste: remova o Navigator.pushReplacementNamed
    // e apenas chame o _checkAuthStatus() quando o botão de limpeza for clicado.
    // Vou manter a navegação automática mas com o botão visível.

    // A navegação automática deve ser a última coisa.
    // Se o objetivo é sempre mostrar o botão de limpeza na SplashScreen para testes,
    // então a navegação DEPOIS da limpeza é mais importante.
    // Se você quer que a SplashScreen *sempre* mostre o botão para limpar (para desenvolvimento),
    // você pode comentar o Navigator.pushReplacementNamed(context, route); aqui
    // e fazer a navegação APENAS dentro do _clearAuthData.
    // Para manter o fluxo normal e ainda permitir o teste, vamos deixar o botão visível.

    // Esta parte do código ainda é responsável pela navegação automática.
    // Para *forçar* a SplashScreen a mostrar o botão antes de qualquer navegação,
    // é melhor não navegar aqui inicialmente, e sim só quando o botão for clicado,
    // ou após um delay maior e se nenhum botão for clicado.

    // Para fins de DEPURACAO e forçar a visualização do botão de limpeza:
    // Comente a linha abaixo e faça a navegação para '/home' ou '/login'
    // manualmente, ou crie outro botão para "Continuar".
    // Ou, simplesmente use o botão de limpeza e ele irá para '/register'.
    // A maneira mais fácil de testar o registro é limpar e navegar.
    if (!mounted) return;
    if (route != '/register') { // Se não for para o registro, navega. Se for, o botão de limpeza já navega.
      Navigator.pushReplacementNamed(context, route);
    }
    // Se a rota for '/register', não navegamos automaticamente aqui.
    // O usuário terá que clicar no botão de limpeza, que por sua vez, navegará para /register.
    // Ou, se não houver token/pin, ele fica na SplashScreen até clicar no botão.
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
    Navigator.pushReplacementNamed(context, '/register');
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
                child: const Text('Limpar Dados de Autenticação'),
              ),
          ],
        ),
      ),
    );
  }
}