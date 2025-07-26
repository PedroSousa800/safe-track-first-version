// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Ajuste o _baseUrl conforme o seu backend, porta 8000 é comum para Python/Django/FastAPI
  // 'http://10.0.2.2:8000' é para Android Emulator. Para iOS Simulator/Real Device use 'http://localhost:8000'
  // Para um dispositivo Android real, você precisará do IP da sua máquina na rede local (ex: 'http://192.168.1.XX:8000')
  final String _baseUrl = 'http://10.0.2.2:8000'; 

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String profileTypeKey = 'profile_type';
  static const String pinKey = 'user_pin'; // Chave para armazenar o PIN

  Future<Map<String, dynamic>> loginUser(String email, String pin) async {
    final url = Uri.parse('$_baseUrl/login'); // O endpoint de login é /login
    try {
      final response = await http.post(
        url,
        // CORRIGIDO: Content-Type para form-urlencoded para o OAuth2PasswordRequestForm do FastAPI
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        // CORRIGIDO: Body em formato url-encoded, usando 'username' para email e 'password' para PIN
        body: 'username=${Uri.encodeComponent(email)}&password=${Uri.encodeComponent(pin)}',
      );

      final responseBody = json.decode(response.body);
      developer.log('Login Response: $responseBody', name: 'AuthService');
      developer.log('Login Status Code: ${response.statusCode}', name: 'AuthService');

      if (response.statusCode == 200) {
        await _storage.write(key: tokenKey, value: responseBody['access_token']);
        await _storage.write(key: userIdKey, value: responseBody['user_id']);
        await _storage.write(key: pinKey, value: pin); // Armazena o PIN para uso futuro (biometria, etc.)

        if (responseBody.containsKey('profile_type') && responseBody['profile_type'] != null) {
          await _storage.write(key: profileTypeKey, value: responseBody['profile_type']);
        } else {
          await _storage.delete(key: profileTypeKey); // Limpa se não houver profile_type
        }

        return {'success': true, 'message': 'Login bem-sucedido.', 'profile_type': responseBody['profile_type'], 'user_id': responseBody['user_id']};
      } else {
        // Se o status não for 200, assume-se que é um erro do backend
        // O 'detail' é comum em erros 422 do FastAPI, 'message' é mais genérico
        return {'success': false, 'message': responseBody['detail'] ?? responseBody['message'] ?? 'Erro desconhecido ao logar.'};
      }
    } catch (e) {
      developer.log('Erro no login: $e', name: 'AuthService', error: e);
      return {'success': false, 'message': 'Não foi possível conectar ao servidor. Verifique sua conexão ou tente novamente.'};
    }
  }

  // MÉTODO registerUser (já estava corrigido, incluído para completude)
  Future<Map<String, dynamic>> registerUser(String email, String password, String username) async {
    final url = Uri.parse('$_baseUrl/register'); // O endpoint de registro é /register
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password, 'username': username}), 
      );

      final responseBody = json.decode(response.body);
      developer.log('Register Response: $responseBody', name: 'AuthService');
      developer.log('Register Status Code: ${response.statusCode}', name: 'AuthService');

      // Considera qualquer status code na faixa 2xx (200, 201, 202, etc.) como potencial sucesso.
      if (response.statusCode >= 200 && response.statusCode < 300) { 
        // Agora, verifica o 'status' dentro do corpo da resposta JSON do backend.
        // O backend retorna {"status": "new_user_registered"} para sucesso.
        if (responseBody.containsKey('status') && responseBody['status'] == 'new_user_registered') {
          return {
            'success': true, 
            'message': responseBody['message'] ?? 'Registro bem-sucedido.', 
            'user_id': responseBody['user_id'] // Garante que o user_id é retornado
          };
        } else {
          // Se o status code for 2xx, mas o 'status' no corpo não for 'new_user_registered'
          return {
            'success': false, 
            'message': responseBody['message'] ?? 'Falha no registro: Status inesperado do backend.'
          };
        }
      } else {
        // Trata outros status codes de erro (4xx, 5xx)
        return {'success': false, 'message': responseBody['message'] ?? 'Erro desconhecido ao registrar.'};
      }
    } catch (e) {
      developer.log('Erro no registro: $e', name: 'AuthService', error: e);
      return {'success': false, 'message': 'Não foi possível conectar ao servidor. Verifique sua conexão ou tente novamente.'};
    }
  }

  // MÉTODO finalizePin CORRIGIDO
  Future<Map<String, dynamic>> finalizePin(String userId, String pin) async {
    // CORRIGIDO: Use a URL correta do backend e o verbo HTTP POST
    final url = Uri.parse('$_baseUrl/finalize-pin'); // AGORA CORRETO: "/finalize-pin" (conforme seu main.py)
    
    try {
      final response = await http.post( // CORRIGIDO: Agora é POST, não PATCH (conforme seu main.py)
        url,
        headers: {'Content-Type': 'application/json'},
        // CORRIGIDO: Envia userId e pin, conforme o modelo UserFinalizePin do backend ({"user_id": ..., "pin": ...})
        body: json.encode({'user_id': userId, 'pin': pin}),
      );

      final responseBody = json.decode(response.body);
      developer.log('FinalizePin Response: $responseBody', name: 'AuthService');
      developer.log('FinalizePin Status Code: ${response.statusCode}', name: 'AuthService');

      // Seu backend retorna um 'status': 'success' no corpo para este endpoint
      if (response.statusCode >= 200 && response.statusCode < 300) { // Aceita 2xx como sucesso
        if (responseBody.containsKey('status') && responseBody['status'] == 'success') {
           // Armazena o novo PIN APENAS se o backend confirmou o sucesso
          await _storage.write(key: pinKey, value: pin); 
          return {'success': true, 'message': responseBody['message'] ?? 'PIN configurado com sucesso!'};
        } else {
          return {'success': false, 'message': responseBody['message'] ?? 'Falha ao configurar PIN: Status inesperado.'};
        }
      } else {
        // Trata outros status codes de erro (4xx, 5xx), incluindo 'detail' de HTTPException do FastAPI
        return {'success': false, 'message': responseBody['detail'] ?? responseBody['message'] ?? 'Falha ao configurar PIN.'};
      }
    } catch (e) {
      developer.log('Erro ao finalizar PIN: $e', name: 'AuthService', error: e);
      return {'success': false, 'message': 'Não foi possível conectar ao servidor para configurar o PIN. Verifique sua conexão ou tente novamente.'};
    }
  }

  // MÉTODO setProfileType (já estava correto, incluído para completude)
  Future<Map<String, dynamic>> setProfileType(String userId, String profileType) async {
    final url = Uri.parse('$_baseUrl/users/$userId/profile_type');
    String? token = await getToken();

    if (token == null) {
      developer.log('SetProfileType: Token de autenticação não encontrado.', name: 'AuthService');
      return {'success': false, 'message': 'Token de autenticação não encontrado. Faça login novamente.'};
    }

    try {
      final response = await http.patch( // PATCH é o verbo correto para atualização parcial
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'profile_type': profileType}),
      );

      final responseBody = json.decode(response.body);
      developer.log('Set Profile Type Response: $responseBody', name: 'AuthService');
      developer.log('Set Profile Type Status Code: ${response.statusCode}', name: 'AuthService');


      if (response.statusCode == 200) {
        await _storage.write(key: profileTypeKey, value: profileType);
        return {'success': true, 'message': responseBody['message'] ?? 'Tipo de perfil definido com sucesso.'};
      } else {
        return {'success': false, 'message': responseBody['message'] ?? responseBody['detail'] ?? 'Falha ao definir o tipo de perfil.'};
      }
    } catch (e) {
      developer.log('Erro ao definir o tipo de perfil: $e', name: 'AuthService', error: e);
      return {'success': false, 'message': 'Não foi possível conectar ao servidor. Verifique sua conexão ou tente novamente.'};
    }
  }

  // Métodos auxiliares (já estavam corretos, incluídos para completude)
  Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: userIdKey);
  }

  Future<String?> getProfileType() async {
    return await _storage.read(key: profileTypeKey);
  }

  Future<void> logout() async {
    await _storage.delete(key: tokenKey);
    await _storage.delete(key: userIdKey);
    await _storage.delete(key: profileTypeKey);
    await _storage.delete(key: pinKey);
    developer.log('User logged out, all secure storage cleared.', name: 'AuthService');
  }
}