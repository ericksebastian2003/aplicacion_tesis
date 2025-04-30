import 'package:flutter/material.dart';
import 'features/host/dashboard/host_dashboard.dart';
import 'features/guest/dashboard/guest_dashboard.dart';
import 'features/admin/dashboard/admin_dashboard.dart';
import 'features/auth/widgets/login_screen.dart';
import 'providers/session_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async {
  //await dotenv.load(fileName: ".env"); 
  //assert(dotenv.env['WHATSAPP_NUMBER'] != null, 'WHATSAPP_NUMBER no está definido');

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
    final sessionProvider = Provider.of<SessionProvider>(context);
    if (isLoggedIn && sessionProvider.email != null && sessionProvider.rol != null) {
      if (sessionProvider.rol == 'admin') {
        startWidget = AdminDashboard(correo: sessionProvider.email! , rol: 'admin',);
      } else if(sessionProvider.rol == 'huesped') {
        startWidget = GuestDashboard(correo: sessionProvider.email!, rol: 'huesped');
      }
      else if(sessionProvider.rol == 'anfitrion') {
        startWidget = HostDashboard(correo: sessionProvider.email!, rol: 'anfitrion');
      }
      else {
      startWidget = const LoginScreen();
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
