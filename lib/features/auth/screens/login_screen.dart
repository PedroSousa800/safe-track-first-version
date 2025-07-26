// lib/features/auth/screens/login_screen.dart

import 'package:first_version/features/auth/screens/profile_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:first_version/services/auth_service.dart';
import 'dart:developer' as developer;

import 'package:first_version/features/auth/screens/home_screen.dart';
import 'package:first_version/features/auth/widgets/custom_pin_pad.dart';
import 'package:first_version/core/theme/app_theme.dart'; // Mantemos o import de AppTheme
import 'package:first_version/features/auth/widgets/pin_input_display.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  final _storage = const FlutterSecureStorage();
  final _auth = LocalAuthentication();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;
  String? _storedEmail;
  bool _showEmailField = true;

  @override
  void initState() {
    super.initState();
    _checkStoredAuthData();
    _pinController.addListener(_onPinChanged);
    _pinFocusNode.addListener(() {
      if (_pinFocusNode.hasFocus) {
        developer.log('PIN TextField focused.', name: 'LoginScreen');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pinController.removeListener(_onPinChanged);
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _onPinChanged() {
    if (_pinController.text.length == 4 && !_isLoading) {
      _login();
    }
  }

  void _handleDigitPressed(String digit) {
    if (_pinController.text.length < 4) {
      setState(() {
        _pinController.text += digit;
      });
      developer.log('PIN updated: ${_pinController.text}', name: 'LoginScreen');
    }
  }

  void _handleBackspace() {
    if (_pinController.text.isNotEmpty) {
      setState(() {
        _pinController.text = _pinController.text.substring(0, _pinController.text.length - 1);
      });
      developer.log('PIN backspace. Current PIN: ${_pinController.text}', name: 'LoginScreen');
    }
  }

  Future<void> _handleBiometrics() async {
    developer.log('Attempting biometrics...', name: 'LoginScreen');
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
    developer.log('Can check biometrics: $canCheckBiometrics', name: 'LoginScreen');
    developer.log('Available biometrics: $availableBiometrics', name: 'LoginScreen');
    if (canCheckBiometrics) {
      try {
        bool authenticated = await _auth.authenticate(
          localizedReason: 'Autentique para acessar o SafeTrack',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        if (!mounted) return;
        if (authenticated) {
          developer.log('Biometric authentication successful.', name: 'LoginScreen');
          if (_storedEmail != null) {
            await _login(useBiometrics: true);
          } else {
            // Adicionar mounted check
            if (!mounted) return; // Add mounted check here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nenhum email armazenado para login biométrico.')),
            );
          }
        } else {
          developer.log('Biometric authentication failed.', name: 'LoginScreen');
          // Adicionar mounted check
          if (!mounted) return; // Add mounted check here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Autenticação biométrica falhou.')),
          );
        }
      } catch (e) {
        developer.log('Erro durante a autenticação biométrica: $e', name: 'LoginScreen');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro na autenticação biométrica: $e')),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometria não disponível ou configurada neste dispositivo.')),
      );
    }
  }

  Future<void> _checkStoredAuthData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _storedEmail = await _storage.read(key: 'email');
      developer.log('Stored Email: $_storedEmail', name: 'LoginScreen');

      if (_storedEmail != null) {
        _showEmailField = false;
        if (await _auth.canCheckBiometrics && await _auth.isDeviceSupported()) {
          developer.log('Biometrics available for stored user.', name: 'LoginScreen');
        }
      } else {
        _showEmailField = true;
      }
    } catch (e) {
      developer.log('Error reading stored data: $e', name: 'LoginScreen');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao ler dados armazenados: $e')),
      );
      _showEmailField = true;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _login({bool useBiometrics = false}) async {
    setState(() {
      _isLoading = true;
      _error = null; // Limpa qualquer erro anterior
    });

    String emailToUse = _showEmailField ? _emailController.text : (_storedEmail ?? '');

    if (emailToUse.isEmpty) {
      setState(() {
        _error = 'Por favor, insira seu email.';
        _isLoading = false;
      });
      return;
    }

    if (!useBiometrics && _pinController.text.length != 4) {
      setState(() {
        _error = 'O PIN deve ter 4 dígitos.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await _authService.loginUser(emailToUse, _pinController.text);

      if (!mounted) return;

      if (response['success'] == true) { // Verifica a chave 'success' retornada pelo AuthService
        developer.log('Login successful for user: $emailToUse', name: 'LoginScreen');
        if (_showEmailField) {
          await _storage.write(key: 'email', value: emailToUse);
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );

        // *** LÓGICA DE NAVEGAÇÃO CONDICIONAL AQUI ***
        final String? profileType = response['profile_type'];
        final String? userId = response['user_id']; // Obter userId da resposta do login

        if (!mounted) return; // Nova verificação de mounted antes da navegação

        if (profileType == null || profileType.isEmpty) {
          // Se o perfil não estiver definido, navega para ProfileSelectionScreen
          if (userId != null) { // Garante que temos um userId para passar
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSelectionScreen(
                  userId: userId,
                  initialProfileType: null, // Não há perfil inicial definido
                ),
              ),
            );
            developer.log('Navegando para ProfileSelectionScreen.', name: 'LoginScreen');
          } else {
            // Caso userId seja nulo, o que não deveria acontecer após login bem-sucedido
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro: ID do usuário não encontrado após login.')),
            );
            developer.log('Erro: userId nulo após login bem-sucedido.', name: 'LoginScreen');
          }
        } else {
          // Se o perfil já estiver definido, navega para HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          developer.log('Navegando para HomeScreen (perfil já definido: $profileType).', name: 'LoginScreen');
        }
      } else {
        // Login falhou, exibe a mensagem de erro do AuthService
        String errorMessage = response['message'] ?? 'Falha no login: Erro desconhecido.';
        setState(() {
          _error = errorMessage;
        });
        developer.log('Login failed: $_error', name: 'LoginScreen');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_error!)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
      developer.log('Login failed (exception): $_error', name: 'LoginScreen');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao logar: $_error')),
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
    // Acessar diretamente as cores estáticas de AppTheme
    final textTheme = Theme.of(context).textTheme;
    final headlineMediumStyle = textTheme.headlineMedium;

    return Scaffold(
      backgroundColor: AppTheme.alternateBrand,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'SafeTrack',
          style: headlineMediumStyle?.copyWith(
            color: AppTheme.alternateBrand, // Usar AppTheme diretamente
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_showEmailField) ...[
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Digite seu email',
                            prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.secondaryText), // Usar AppTheme diretamente
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: AppTheme.alternateBrand), // Usar AppTheme diretamente
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: AppTheme.alternateBrand), // Usar AppTheme diretamente
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: AppTheme.primaryBrand, width: 2.0), // Usar AppTheme diretamente
                            ),
                            filled: true,
                            fillColor: AppTheme.secondaryBackground, // Usar AppTheme diretamente
                            labelStyle: const TextStyle(color: AppTheme.primaryText), // Usar AppTheme diretamente
                            hintStyle: const TextStyle(color: AppTheme.secondaryText), // Usar AppTheme diretamente
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: AppTheme.primaryText), // Usar AppTheme diretamente
                        ),
                        const SizedBox(height: 24.0),
                      ],

                      Padding(
                        padding: const EdgeInsets.only(bottom: 35.0),
                        child: Text(
                          'Insira seu PIN',
                          textAlign: TextAlign.center,
                          style: headlineMediumStyle?.copyWith(
                            color: AppTheme.primaryText, // Usar AppTheme diretamente
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: PinInputDisplay(
                          pinLength: _pinController.text.length,
                          maxLength: 4,
                          filledColor: AppTheme.primaryBrand, // Usar AppTheme diretamente
                          emptyColor: AppTheme.infoColor, // Usar AppTheme diretamente
                        ),
                      ),

                      CustomPinPad(
                        onDigitPressed: _handleDigitPressed,
                        onBackspacePressed: _handleBackspace,
                        onBiometricsPressed: _handleBiometrics,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 24.0),
                      if (_error != null)
                        Text(
                          _error!,
                          style: const TextStyle(color: AppTheme.errorColor, fontSize: 16), // Usar AppTheme diretamente
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 24.0)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 1,
        height: 1,
        child: Opacity(
          opacity: 0.0,
          child: TextField(
            controller: _pinController,
            focusNode: _pinFocusNode,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            style: const TextStyle(color: Colors.transparent),
            readOnly: true,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}