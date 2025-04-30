import 'package:flutter/material.dart';
import 'features/host/dashboard/host_dashboard.dart';
import 'features/guest/dashboard/guest_dashboard.dart';
import 'features/admin/dashboard/admin_dashboard.dart';
import 'features/auth/widgets/login_screen.dart';
import 'providers/session_provider.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sessionProvider = SessionProvider();
  await sessionProvider.loadSessionFromPrefs();

  runApp(
    ChangeNotifierProvider(
      create: (_) => sessionProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {


  const MyApp({
    super.key,
    
  });

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    Widget startWidget;
    if(!sessionProvider.isSessionLoaded){
      startWidget = const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    else if (sessionProvider.isLoggedIn && sessionProvider.email  != null && sessionProvider.rol != null) {
      switch (sessionProvider.rol){
      case 'admin' :
        startWidget = AdminDashboard(correo: sessionProvider.email! , rol: 'admin',);
        break;
      case  'huesped' :
        startWidget = GuestDashboard(correo: sessionProvider.email!, rol: 'huesped');
        break;
      case  'anfitrion' : 
        startWidget = HostDashboard(correo: sessionProvider.email!, rol: 'anfitrion', nombre: sessionProvider.fullName!,);
        break;
      default :
        startWidget = const LoginScreen();
    }

    } else {
      startWidget = const LoginScreen();
    }

    return MaterialApp(
    
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
