import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/widgets/login_screen.dart';
class AccountScreen extends StatefulWidget{
  final String nombre;
  final String rol;
  const AccountScreen({super.key , required this.rol ,required this.nombre});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>{
  late  String _rolActual;

  @override
  void initState(){
    super.initState();
    _rolActual = widget.rol;
  }
  
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
  //Cambiar de rol
  Future<void>  _cambiarRol()async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rolActual = _rolActual == 'huesped' ? 'anfitrion' : 'huesped';

    });
    await prefs.setString('rol', _rolActual);
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
             Text(
              'Rol actual : $_rolActual',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              
            ),
            const Divider(),     
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
              leading: Icon(Icons.home_repair_service_rounded),
              title: const Text(
                'Mis reservas',
              ),
            ),
            const Divider(),
            ListTile(
              leading:const Icon(Icons.account_balance_wallet),
              title: const Text('Métodos de pago'),
            ),
            ListTile(
              leading: const Icon(Icons.payments_rounded),
              title: const Text(
                'Mis pagos'
              ),
              
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              onTap: () => logout(context),
              title: Text(
                'Cerrar sesión'
              ),
            ),
            
          ],
          
        ),
          
        
      ),
      
      floatingActionButton : Stack(
        children: [
          Positioned(
            bottom: 20,
            child:FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))
              ),
              onPressed : _cambiarRol,
              foregroundColor: Colors.white,
              backgroundColor : colorPrimary,
              icon : const Icon(Icons.swap_horiz),
              label : Text('Cambiar a ${_rolActual == 'huesped' ? 'Anfitrión' : 'Huésped'}',
              ),
            ),
      
      )
      ],
      )
      );
      
  }

}