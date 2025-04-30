import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  //Verufucar la sesión
  bool _isSessionLoaded = false;
  String? _email;
  String? _rol;
  String? _fullName;

  bool get isLoggedIn => _isLoggedIn;
  bool get isSessionLoaded => _isSessionLoaded;
  String? get email => _email;
  String? get rol => _rol;
  String? get fullName => _fullName;

  void login(String email, String fullName , String rol) {
    _isLoggedIn = true;
    _email = email;
    _rol = rol;
    _fullName = fullName;
    saveSessionToPrefs(email,fullName, rol);
    notifyListeners();
  }

  Future<void>  loadSessionFromPrefs() async{
    final prefs = await SharedPreferences.getInstance();

    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _email = prefs.getString('userEmail');
    _fullName = prefs.getString('userName');
    _isSessionLoaded = true;
    _rol = rol;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _email = null;
    _fullName = null;
    _rol = null;
    clearSessionPrefs();
    notifyListeners();
  }

  Future<void> saveSessionToPrefs(String email, String nombre ,String rol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);
    await prefs.setString('userName', nombre);
    await prefs.setString('userRole', rol);
  }

  Future<void> clearSessionPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
