import 'package:flutter/material.dart';
import 'package:hotels/screens/users/widgets/user_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/public/login_screen.dart';
import 'screens/admin/widgets/admin_dashboard.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final startWidget = await checkSession();
  runApp( MyApp(
    startWidget : startWidget
    ));
}
Future<Widget> checkSession() async{
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final correo = prefs.getString('userEmail');
  final role = prefs.getString('userRole');

  if(isLoggedIn && correo != null){
    if(role == 'user'){
    return UserDashboard(correo: correo);
    }
    else if(role== 'admin'){
      return AdminDashboard(correo: correo);
    }
  }
    return const LoginScreen();
  
}
class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({super.key , required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 13, 40, 199)),
          useMaterial3: true,
      ),
      home: startWidget,
    );
  }
}
