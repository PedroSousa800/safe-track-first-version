// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SafeTrack')),
      body: const Center(
        child: Text(
          'Bem-vindo ao SafeTrack!',
          style: TextStyle(fontSize: 20),
        ),
      )
    );
  }
}
