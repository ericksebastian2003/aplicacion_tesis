import 'package:flutter/material.dart';


class SessionProvider with ChangeNotifier{
  bool _isLoggedIn = false;
  String? _email;
  String? _rol;
  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email ;
  String? get rol => _rol;
  void login(String email,String rol){
    _isLoggedIn = true;
    _email = email;
    _rol = rol;
    notifyListeners();
  }
  void logout(){
    _isLoggedIn = false;
    _email = null;
    _rol = null;
    notifyListeners();

}
}