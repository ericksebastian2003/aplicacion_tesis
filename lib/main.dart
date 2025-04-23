import 'package:flutter/material.dart';
import 'package:hotels/screens/users/guest/widgets/user_dashboard.dart';
import 'package:hotels/screens/admin/widgets/admin_dashboard.dart';
import 'package:hotels/screens/public/login_screen.dart';
import 'package:hotels/providers/session_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import ''
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String? email = prefs.getString('userEmail');
  final String? role = prefs.getString('userRole');

  runApp(
    ChangeNotifierProvider(
      create: (_) => SessionProvider()
        ..loadSession(email ?? '', role ?? ''), // Carga valores si existen
      child: MyApp(isLoggedIn: isLoggedIn, email: email, role: role),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? email;
  final String? role;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    Widget startWidget;

    if (isLoggedIn && email != null && role != null) {
      if (role == 'admin') {
        startWidget = AdminDashboard(correo: email!);
      } else {
        startWidget = UserDashboard(correo: email!);
      }
    } else {
      startWidget = const LoginScreen();
    }

    return MaterialApp(
      title: 'Hotel App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 13, 40, 199),
        ),
        useMaterial3: true,
      ),
      home: startWidget,
    );
  }
}
