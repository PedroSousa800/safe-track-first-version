import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

// URL base do seu backend FastAPI
// Se estiver rodando localmente, use o IP do seu computador ou localhost
// Se estiver rodando em um emulador Android, '10.0.2.2' se refere ao seu computador
// Se estiver rodando em um simulador iOS, 'localhost' ou '127.0.0.1' funciona
const String baseUrl = 'http://10.0.2.2:8000'; // Exemplo para emulador Android

class AuthService {
  // Método para registrar um novo usuário
  Future<Map<String, dynamic>> registerUser(
      String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/register'); // Endpoint de registro
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      developer.log('Register API Response Status: ${response.statusCode}', name: 'AuthService');
      developer.log('Register API Response Body: ${response.body}', name: 'AuthService');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Sucesso
        return jsonDecode(response.body);
      } else {
        // Erro do servidor
        try {
          final errorBody = jsonDecode(response.body);
          return {'error': errorBody['detail'] ?? 'Falha no registro: ${response.statusCode}'};
        } catch (_) {
          return {'error': 'Falha no registro: ${response.body}'};
        }
      }
    } catch (e) {
      // Erro de rede ou outro
      developer.log('Erro de conexão ao registrar usuário: $e', name: 'AuthService');
      return {'error': 'Erro de conexão: $e'};
    }
  }

  // MÉTODO ATUALIZADO: Para finalizar o PIN do usuário
  // Agora retorna Map<String, dynamic> para consistência e para passar mensagens de erro/sucesso
  Future<Map<String, dynamic>> finalizePin(String userId, String pin) async {
    final url = Uri.parse('$baseUrl/finalize-pin/$userId'); // O userId ainda vai na URL
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId, // <-- ADICIONADO: userId também no corpo da requisição
          'pin': pin,
        }),
      );

      developer.log('AuthService: Finalize PIN API Response Status: ${response.statusCode}', name: 'AuthService');
      developer.log('AuthService: Finalize PIN API Response Body: ${response.body}', name: 'AuthService');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          return {'error': errorBody['detail'] ?? 'Falha ao finalizar PIN: ${response.statusCode}'};
        } catch (_) {
          return {'error': 'Falha ao finalizar PIN: ${response.body}'};
        }
      }
    } catch (e) {
      developer.log('AuthService: Erro de conexão ao finalizar PIN: $e', name: 'AuthService');
      return {'error': 'Erro de conexão: $e'};
    }
  }

  // NOVO MÉTODO: Para realizar o login do usuário
  Future<Map<String, dynamic>> loginUser(String email, String pin) async {
    final url = Uri.parse('$baseUrl/login'); // Endpoint de login
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'pin': pin,
        }),
      );

      developer.log('AuthService: Login API Response Status: ${response.statusCode}', name: 'AuthService');
      developer.log('AuthService: Login API Response Body: ${response.body}', name: 'AuthService');

      if (response.statusCode == 200) {
        // Sucesso
        return jsonDecode(response.body);
      } else {
        // Erro do servidor
        try {
          final errorBody = jsonDecode(response.body);
          return {'error': errorBody['detail'] ?? 'Falha no login: ${response.statusCode}'};
        } catch (_) {
          return {'error': 'Falha no login: ${response.body}'};
        }
      }
    } catch (e) {
      developer.log('AuthService: Erro de conexão ao fazer login: $e', name: 'AuthService');
      return {'error': 'Erro de conexão: $e'};
    }
  }
}