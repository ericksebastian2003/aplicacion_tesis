import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:3000/users';
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final response = await http.get(Uri.parse('$baseUrl?correo=$email&contrasena=$password'));

    if (response.statusCode == 200) {
      final users = jsonDecode(response.body);
      if (users.isNotEmpty) {
        return users[0]; // Retorna el usuario si existe
      }
    }
    return null;
  }

  Future<void> saveSession(String email, {required String rol}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', email);
    await prefs.setString('rol', rol);
  }

  
  Future<Map<String, dynamic>> register(Map<String, String> userData) async {
    try {
      if (userData['email'] == null || userData['password'] == null) {
        return {'status': 'error', 'message': 'Campos vacíos'};
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        return {'status': 'success', 'message': 'Registro exitoso'};
      } else {
        return {'status': 'error', 'message': 'Error al registrar usuario'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Error: ${e.toString()}'};
    }
  }

  


  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionData = prefs.getString('sessionData');
    if (sessionData != null) {
      Map<String, dynamic> session = jsonDecode(sessionData);
      return session['isLoggedIn'] ?? false;
    }
    return false;
  }

  Future<String?> getLoggedUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionData = prefs.getString('sessionData');
    if (sessionData != null) {
      Map<String, dynamic> session = jsonDecode(sessionData);
      return session['userEmail'];
    }
    return null;
  }
  Future<String?> getLoggedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionData = prefs.getString('sessionData');
    if (sessionData != null) {
      Map<String, dynamic> session = jsonDecode(sessionData);
      return session['userName'];
    }
    return null;
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionData = prefs.getString('sessionData');
    if (sessionData != null) {
      Map<String, dynamic> session = jsonDecode(sessionData);
      return session['rol'];
    }
    return null;
  }
}
