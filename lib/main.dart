// lib/main.dart

import 'package:first_version/core/theme/app_theme.dart';
import 'package:first_version/features/auth/screens/finalize_pin_screen.dart';
import 'package:first_version/features/auth/screens/home_screen.dart';
import 'package:first_version/features/auth/screens/login_screen.dart';
import 'package:first_version/features/auth/screens/register_screen.dart';
import 'package:first_version/features/auth/screens/profile_selection_screen.dart';
import 'package:first_version/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:developer' as developer;

import 'package:first_version/services/auth_service.dart';

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
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash, // Defina uma rota inicial
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.profileSelection: (context) {
          final userId = ModalRoute.of(context)?.settings.arguments as String?;
          return ProfileSelectionScreen(userId: userId ?? '');
          
        },
        AppRoutes.finalizePin: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
          final userId = args['user_id'] as String? ?? '';
          final email = args['email'] as String? ?? '';
          return FinalizePinScreen(userId: userId, email: email);
        }, // <-- Corrigido para passar os argumentos necessários!
        AppRoutes.home: (context) => const HomeScreen(),
        // Adicione outras rotas conforme necessário
      },
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
  final AuthService _authService = AuthService(); // Instância do AuthService

  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    developer.log('Verificando status de autenticação...',
        name: 'SplashScreen');

    // --- ADICIONE ESTA LINHA TEMPORARIAMENTE PARA TESTES ---
    await _authService
        .logout(); // Força o logout a cada inicialização para testes
    developer.log('Forçando logout para fins de teste.', name: 'SplashScreen');
    // --------------------------------------------------------

    try {
      // CORRIGIDO: Acessando as chaves estáticas públicas da classe AuthService
      String? token = await _storage.read(key: AuthService.tokenKey);
      String? userId = await _storage.read(key: AuthService.userIdKey);
      String? profileType =
          await _storage.read(key: AuthService.profileTypeKey);

      developer.log('Token: $token, UserId: $userId, ProfileType: $profileType',
          name: 'SplashScreen');

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      if (token != null && !JwtDecoder.isExpired(token)) {
        if (userId == null) {
          developer.log(
              'Token válido, mas userId ausente. Forçando reautenticação.',
              name: 'SplashScreen');
          await _authService.logout();
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, AppRoutes.register);
          return;
        }

        if (profileType == null || profileType.isEmpty) {
          developer.log(
              'Token e userId válidos, mas perfil não definido. Navegando para ProfileSelectionScreen.',
              name: 'SplashScreen');
          final userId = ModalRoute.of(context)!.settings.arguments as String;
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, AppRoutes.profileSelection,
              arguments: userId);
        } else {
          developer.log(
              'Token, userId e perfil válidos. Navegando para HomeScreen.',
              name: 'SplashScreen');
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else {
        // Se o token estiver ausente ou expirado, limpamos o userId e profileType do storage
        await _storage.delete(key: AuthService.tokenKey); // CORRIGIDO
        await _storage.delete(key: AuthService.userIdKey); // CORRIGIDO
        await _storage.delete(key: AuthService.profileTypeKey); // CORRIGIDO

        // Verifica se há um PIN para ir para LoginScreen ou RegisterScreen
        // Se você adicionou 'pinKey' no AuthService, use AuthService.pinKey aqui.
        String? pin = await _storage.read(
            key: 'pin'); // Mantenha como 'pin' ou mude para AuthService.pinKey
        if (pin != null && pin.isNotEmpty) {
          developer.log(
              'PIN encontrado (token ausente/expirado), navegando para LoginScreen.',
              name: 'SplashScreen');
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else {
          developer.log('Nenhum token nem PIN. Navegando para RegisterScreen.',
              name: 'SplashScreen');
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, AppRoutes.register);
        }
      }
    } on Exception catch (e) {
      developer.log('Erro ao verificar status de autenticação: $e',
          name: 'SplashScreen', error: e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados de autenticação: $e')),
      );
      setState(() {
        _showClearButton = true;
      });
    }
  }

  Future<void> _clearAuthData() async {
    await _authService.logout();
    developer.log('Dados de autenticação limpos!', name: 'SplashScreen');

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados de autenticação limpos!')),
    );
    Navigator.pushReplacementNamed(context, AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            if (_showClearButton)
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
