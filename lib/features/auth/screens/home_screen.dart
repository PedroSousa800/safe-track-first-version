// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:first_version/services/auth_service.dart'; // Importa seu AuthService
import 'package:first_version/features/auth/screens/login_screen.dart'; // Importa sua LoginScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService(); // Instância do AuthService

    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeTrack - Início'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // NOVO: Botão de Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Exibe um AlertDialog de confirmação antes de deslogar
              final bool? confirmLogout = await showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Confirmar Logout'),
                    content: const Text('Tem certeza que deseja sair?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false), // Não
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true), // Sim
                        child: const Text('Sair'),
                      ),
                    ],
                  );
                },
              );

              if (confirmLogout == true) {
                await authService.logout(); // Chama o método de logout no AuthService
                // NOVO: Navega para a LoginScreen removendo todas as rotas anteriores
                if (context.mounted) { // Verifica se o widget ainda está montado
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              Text(
                'Bem-vindo ao SafeTrack!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // NOVO: Exibe o tipo de perfil do usuário
              FutureBuilder<String?>(
                future: authService.getProfileType(), // Obtém o tipo de perfil
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erro ao carregar perfil: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return Text(
                      'Seu perfil: ${snapshot.data == 'tutor' ? 'Tutor' : 'Monitorado'}', // Exibe formatado
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return Text(
                      'Perfil não definido',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Esta é a sua tela principal. Em breve, você verá o rastreamento aqui.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidade de rastreamento em desenvolvimento!')),
                  );
                },
                child: const Text('Iniciar Rastreamento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}