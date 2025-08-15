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
import 'package:first_version/features/auth/screens/forgot_pin_screen.dart';
import 'package:first_version/features/auth/screens/confirm_token_screen.dart';
import 'package:flutter/foundation.dart'; 

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
          // A rota final pode receber o userId (do fluxo de recuperação)
          // ou um mapa com userId e email (do fluxo de registro).
          final args = ModalRoute.of(context)?.settings.arguments;
          String? userId;
          String? email;

          if (args is String) {
            userId = args; // Fluxo de recuperação
          } else if (args is Map<String, dynamic>) {
            userId = args['user_id'] as String?;
            email = args['email'] as String?; // Fluxo de registro
          }

          if (userId == null) {
            // Redireciona para o login se o userId for nulo, pois é essencial.
            return const LoginScreen();
          }

          return FinalizePinScreen(userId: userId, email: email ?? '');
        },
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.forgotPin: (context) => const ForgotPinScreen(),
        AppRoutes.confirmToken: (context) {
          final email = ModalRoute.of(context)?.settings.arguments as String?;
          return ConfirmTokenScreen(email: email ?? '');
        },
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
  final AuthService _authService = AuthService();

  // Removemos a flag _showClearButton e vamos usar kDebugMode
  // bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    developer.log('Verificando status de autenticação...',
        name: 'SplashScreen');

    try {
      String? token = await _storage.read(key: AuthService.tokenKey);
      String? userId = await _storage.read(key: AuthService.userIdKey);
      String? profileType =
          await _storage.read(key: AuthService.profileTypeKey);
      String? pin = await _storage.read(key: AuthService.pinKey);

      developer.log('Token: $token, UserId: $userId, ProfileType: $profileType',
          name: 'SplashScreen');

      await Future.delayed(const Duration(seconds: 4));

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
        await _authService.logout();
        if (!mounted) return;

        if (pin != null && pin.isNotEmpty) {
          developer.log(
              'PIN encontrado (token ausente/expirado), navegando para LoginScreen.',
              name: 'SplashScreen');
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else {
          developer.log('Nenhum token nem PIN. Navegando para RegisterScreen.',
              name: 'SplashScreen');
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
      // Removemos a atualização do estado
      // setState(() {
      //   _showClearButton = true;
      // });
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
            // Adicionamos um botão de debug que só aparece em modo de depuração
            if (kDebugMode) // kDebugMode é uma constante booleana do Flutter
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