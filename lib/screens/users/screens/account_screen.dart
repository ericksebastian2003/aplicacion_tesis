import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget{
  final String nombre;
  const AccountScreen({super.key , required this.nombre});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>{
  final Color colorPrimary = const Color(0xFF001D5A);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          title: Text(
            'Cuenta',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.transparent,
    ),
    body:  SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bienvenido/a ${widget.nombre}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,

            )),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Editar Perfil'),
              onTap: (){
                print('Cuenta');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Cambiar contraseña'),
              onTap: (){
                print("Contraseña");
              },
            )
          ],
        ),
      ),
      );
  }

}