
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/session_provider.dart'; // ajusta la ruta si es necesario
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido ${userProvider.email}'),
      ),
      body: const Center(
        child: Text('Bienvenido Admin'),
      ),
    );
  }
}
