// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeTrack - Início'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Geralmente não há botão de voltar na tela inicial
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
              Text(
                'Esta é a sua tela principal. Em breve, você verá o rastreamento aqui.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Exemplo: Botão para fazer logout (se você tiver uma função de logout)
                  // Navigator.of(context).pushReplacementNamed('/login');
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
