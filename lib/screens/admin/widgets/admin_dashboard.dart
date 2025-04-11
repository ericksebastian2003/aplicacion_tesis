import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget{
  final String correo;
  const AdminDashboard({super.key,required this.correo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text('Bienvenido $correo'),
      ),
      body: const Center(child:
       Text('Bienvenido Admin')
       ),
    );
  }
}