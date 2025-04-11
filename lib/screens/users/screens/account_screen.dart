import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../public/login_screen.dart';
class AccountScreen extends StatefulWidget{
  final String nombre;
  const AccountScreen({super.key , required this.nombre});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>{
  final Color colorPrimary = const Color(0xFF001D5A);
  Future<void> logout(BuildContext context) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_)=> const LoginScreen()),
        (route) => false,
      );

  }
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
              fontSize: 22,
              fontWeight: FontWeight.bold,

            )),
            const SizedBox(height: 20),
            const Text('Opciones de Usuario',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Editar Perfil'),
              onTap: (){
                print('Cuenta');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Cambiar contraseña'),
              onTap: (){
                print("Contraseña");
              },
            ),
            const SizedBox(height: 10),
            const Text('Opciones de pago',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            ),
            const Divider(),
            ListTile(
              leading:const Icon(Icons.account_balance_wallet),
              title: const Text('Métodos de pago'),
            ),
            
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              onTap: () => logout(context),
              title: Text(
                'Cerrar sesión'
              ),
            )
          ],
        ),
      ),
      );
  }

}