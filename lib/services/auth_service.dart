import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String?> login(String email,String password) async{
    await Future.delayed(const Duration(seconds: 2));
    if(email == 'ericksebastian@mail.com' && password == '12345678'){
      return 'user';

    }
    else{
      return null;
    }
  }
  Future<Map?> register(Map<String , String> userData)async{
    try{
      if(userData.isEmpty || userData.isEmpty){
        return {
          'status' : 'error',
          'message' : 'Campos vacios',
        };
      }
      final SharedPreferences data = await SharedPreferences.getInstance();
      await data.setString('user_email', userData['email']!);
      await data.setString('user_password', userData['password']!);

      return {
        'status' : 'success',
        'message' : 'Registro exitoso',
      };
    }
    catch(e){
      return {
        'status' : 'error',
        'message' : 'Error al regstrar usuario',
      };
    }

  }
  Future <Map?> getUser() async{
    final dataUser = await SharedPreferences.getInstance();
    String? email = dataUser.getString('user_email');
    String? password = dataUser.getString('user_password');
    if(email != null && password != null){
      return {
        'status' : 'success',
        'email' : email,
        'password' : password,
      };
    }
    else{
      return {
        'status' : 'error',
        'message' : 'no se encontro el usuario registrado',
      };
    }
  }
}