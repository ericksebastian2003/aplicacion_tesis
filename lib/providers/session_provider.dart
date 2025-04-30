import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;
  String? _rol;
  String? _name;
  String? _lastName;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;
  String? get rol => _rol;
  String? get name => _name;
  String? get lastName => _lastName;

  void login(String email, String name , String rol) {
    _isLoggedIn = true;
    _email = email;
    _rol = rol;
    _name = name;
    saveSessionToPrefs(email,name, rol);
    notifyListeners();
  }

  void loadSession(String name, String rol) {
    _isLoggedIn = true;
    _name = name;
    _rol = rol;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _email = null;
    _name = null;
    _rol = null;
    clearSessionPrefs();
    notifyListeners();
  }

  Future<void> saveSessionToPrefs(String email, String name ,String rol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);
    await prefs.setString('userName', name);
    await prefs.setString('userRole', rol);
  }

  Future<void> clearSessionPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
