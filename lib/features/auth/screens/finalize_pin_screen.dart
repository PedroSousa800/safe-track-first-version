import 'package:flutter/material.dart';
import 'package:first_version/services/auth_service.dart';
import 'dart:developer' as developer; // ESTA LINHA DEVE ESTAR PRESENTE
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:first_version/features/auth/screens/login_screen.dart'; // IMPORTANTE: Adicione este import

class FinalizePinScreen extends StatefulWidget {
  final String userId;
  final String email;

  const FinalizePinScreen({super.key, required this.userId, required this.email});

  @override
  State<FinalizePinScreen> createState() => _FinalizePinScreenState();
}

class _FinalizePinScreenState extends State<FinalizePinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

 void _finalizePin() async {
    developer.log('TESTE DE LOG: Início de _finalizePin(). Este log deve aparecer!', name: 'FinalizePinScreen');
    developer.log('FinalizePinScreen: Início de _finalizePin().', name: 'FinalizePinScreen');

    // Validação básica do PIN
    if (_pinController.text.isEmpty || _confirmPinController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha ambos os campos de PIN.')),
      );
      developer.log('FinalizePinScreen: Validação falhou - campos vazios.', name: 'FinalizePinScreen');
      return;
    }

    if (_pinController.text != _confirmPinController.text) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Os PINs não coincidem.')),
      );
      developer.log('FinalizePinScreen: Validação falhou - PINs não coincidem.', name: 'FinalizePinScreen');
      return;
    }

    if (_pinController.text.length != 4) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O PIN deve ter 4 dígitos.')),
      );
      developer.log('FinalizePinScreen: Validação falhou - PIN não tem 4 dígitos.', name: 'FinalizePinScreen');
      return;
    }

    setState(() {
      _isLoading = true;
    });
    developer.log('FinalizePinScreen: _isLoading set to true.', name: 'FinalizePinScreen');

    try {
      final authService = AuthService();
      developer.log('FinalizePinScreen: Chamando authService.finalizePin() com userId: ${widget.userId}, pin: ${_pinController.text}.', name: 'FinalizePinScreen');
      final response = await authService.finalizePin(
        widget.userId,
        _pinController.text,
      );
      
      // *** LOGS CRUCIAIS AQUI ***
      developer.log('FinalizePinScreen: Resposta completa da API finalizePin: $response', name: 'FinalizePinScreen');
      developer.log('FinalizePinScreen: Valor de response[\'message\']: ${response['message']}', name: 'FinalizePinScreen');


      // Verificação de 'mounted' após a chamada assíncrona
      if (!mounted) {
        developer.log('FinalizePinScreen: Widget unmounted after API call.', name: 'FinalizePinScreen');
        return;
      }

      // ** MUDANÇA NA CONDIÇÃO DE SUCESSO AQUI **
      // Vamos ser mais flexíveis ou verificar se o 'error' não está presente
      if (response.containsKey('message') && response['message'] != null) { // Se tem a chave 'message' e ela não é nula
        // Poderíamos também verificar se a mensagem 'message' contém uma substring de sucesso
        // Ex: if (response['message'].toString().contains('sucesso')) { ... }
        
        developer.log('FinalizePinScreen: PIN configurado com sucesso (mensagem recebida: ${response['message']}) para o usuário: ${widget.userId}', name: 'FinalizePinScreen');
        
        // Tenta salvar o email localmente
        await _storage.write(key: 'email', value: widget.email);
        developer.log('FinalizePinScreen: Email armazenado localmente com sucesso.', name: 'FinalizePinScreen');

        if (!mounted) {
          developer.log('FinalizePinScreen: Widget unmounted before showing SnackBar or navigating.', name: 'FinalizePinScreen');
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN configurado com sucesso!')),
        );
        developer.log('FinalizePinScreen: SnackBar de sucesso mostrada. Tentando navegar para LoginScreen...', name: 'FinalizePinScreen');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        developer.log('FinalizePinScreen: Navegação para LoginScreen iniciada.', name: 'FinalizePinScreen');

      } else {
        // Se a resposta não tem 'message' ou tem um 'error', tratamos como falha
        setState(() {
          _isLoading = false;
        });
        String errorMessage = response['error'] ?? 'Falha desconhecida ao configurar PIN.';
        developer.log('FinalizePinScreen: Falha ao configurar PIN. Mensagem de erro recebida: $errorMessage', name: 'FinalizePinScreen');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      // Log para erros de conexão ou exceções inesperadas
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      developer.log('FinalizePinScreen: Erro capturado ao configurar PIN: $e', name: 'FinalizePinScreen');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao configurar PIN: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      developer.log('FinalizePinScreen: _isLoading definido como false no bloco finally.', name: 'FinalizePinScreen');
    }
  }
  
  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Registro'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Defina seu PIN',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: _pinController,
                decoration: const InputDecoration(
                  labelText: 'PIN',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _confirmPinController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar PIN',
                  prefixIcon: Icon(Icons.lock_reset_outlined),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _finalizePin(),
              ),
              const SizedBox(height: 32.0),

              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _finalizePin,
                      child: const Text('Finalizar Registro'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}