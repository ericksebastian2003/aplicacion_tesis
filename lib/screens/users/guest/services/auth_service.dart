import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class AuthService {
  Future<Map<String,dynamic>?> login(String email,String password) async{
    await Future.delayed(const Duration(seconds: 2));
    if(email == 'ericksebastian@mail.com' && password == '12345678'){
      return jsonDecode(
        '{"status" : "success", "rol" : "huesped"}');

    }
    else{
      return jsonDecode(
        '{"status" : "error","message" : "Credenciales incorrectas"}'
      );
    }
  }
  Future<Map<String,dynamic>?> register(Map<String , String> userData)async{
    try{
      if(userData.isEmpty || userData.isEmpty){
        return jsonDecode(
          '{"status" : "error","message":"Campos vacios",}');
      }
      final SharedPreferences data = await SharedPreferences.getInstance();
      await data.setString('user_email', userData['email']!);
      await data.setString('user_password', userData['password']!);

      return jsonDecode(
        '{"status" : "success","message" : "Registro exitoso"}');
    }
    catch(e){
      return jsonDecode(
        '{"status" : "error","message" : "Error al registrar usuario"}');
    }
    }

  }
  Future <Map<String,dynamic>?> getUser() async{
    final dataUser = await SharedPreferences.getInstance();
    String? email = dataUser.getString('user_email');
    String? password = dataUser.getString('user_password');
    if(email != null && password != null){
      return jsonDecode(
        '{"status" : "success",",email" : "$email" , "password" : "$password}');
    }
    else{
      return jsonDecode(
        '{"status" : "error","message" : "No se encontro el usuario registrado"}');
       
  }
  }
  //Fucnion para guardar el estado global de logged
  Future<void> saveSession(String correo,{required String rol}) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String , dynamic> sessionData = {
      'isLoggedIn': true,
      'userEmail' : correo,
      'userRole' :  rol,
    };
  await prefs.setString(
    'sessionData',
    jsonEncode(sessionData));
}
// VERIFICAR LA SESION INICADA
Future<bool> isLoggedIn() async{
  final prefs = await SharedPreferences.getInstance();
  String? sessionData = prefs.getString('sessionData');
  if(sessionData != null){
    Map<String,dynamic> session = jsonDecode(
      sessionData
    );
    return session['isLoggedIn'] ?? false;
  }
  return  false;
}

Future<String?> getLoggedUserEmail () async{
  final prefs = await SharedPreferences.getInstance();
  String? sessionData = prefs.getString(
    'sessionData'
  );
  if(sessionData != null){
    Map<String,dynamic> session = jsonDecode(
      sessionData
    );
    return session['userEmail'] ;
  }
  return null;
}
