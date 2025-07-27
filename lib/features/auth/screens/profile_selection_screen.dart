// lib/features/auth/screens/profile_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:first_version/services/auth_service.dart';
import 'package:first_version/routes/app_routes.dart'; // Importa as rotas do aplicativo

class ProfileSelectionScreen extends StatefulWidget {
  final String userId;
  final String? initialProfileType;

  const ProfileSelectionScreen({
    super.key,
    required this.userId,
    this.initialProfileType,
  });

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  final AuthService _authService = AuthService();
  String? _selectedProfile;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedProfile = widget.initialProfileType;
  }

  Future<void> _saveProfile() async {
    if (_selectedProfile == null) {
      setState(() {
        _errorMessage = 'Por favor, selecione um tipo de perfil.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.setProfileType(widget.userId, _selectedProfile!);

    // CORRIGIDO: Adicionado mounted check antes de usar o context para navegação
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      // Navegar para a HomeScreen
      Navigator.pushReplacementNamed(context, AppRoutes.home); // APONTANDO PARA A HOMESCREEN
    } else {
      setState(() {
        _errorMessage = result['message'] ?? 'Falha ao definir o tipo de perfil.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione seu Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Bem-vindo ao SafeTrack!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Para começar, por favor, selecione o tipo de perfil que melhor descreve seu papel no aplicativo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              _buildProfileOption(
                'Tutor',
                'Responsável por monitorar e gerenciar um ou mais indivíduos.',
                'tutor',
              ),
              const SizedBox(height: 20),
              _buildProfileOption(
                'Monitorado',
                'Indivíduo que será monitorado por um Tutor.',
                'monitorado',
              ),
              const SizedBox(height: 40),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Confirmar Seleção',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title, String description, String value) {
    return Card(
      elevation: _selectedProfile == value ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _selectedProfile == value ? Theme.of(context).primaryColor : Colors.grey.shade300,
          width: _selectedProfile == value ? 3 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedProfile = value;
            _errorMessage = null;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _selectedProfile == value ? Theme.of(context).primaryColor : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              if (_selectedProfile == value) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 30),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}