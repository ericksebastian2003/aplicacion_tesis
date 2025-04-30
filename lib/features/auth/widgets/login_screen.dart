import 'package:flutter/material.dart';
import 'package:hotels/features/host/dashboard/host_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../../admin/dashboard/admin_dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../guest/dashboard/guest_dashboard.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color colorPrimary = const Color(0xFF001D5A);
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  //WhatshApp
  final String phoneNumber = '593969939834';
  final String message = 'Necesito información de este alojamiento';


  final authService = AuthService();


  bool loading = false;
  bool _obscurePassword = true;
  
  
  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> saveEmail(String correo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('_correo', correo);
  }
  /*Future<void> _openWhatsApp() async {
  final String phoneNumber = '593987654321';
  final String message = 'Necesito información de este alojamiento';
  
  final urlString = 'https://api.whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}';
  print('URL generada: $urlString');
  
  final url = Uri.parse(urlString);
  
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir WhatsApp')),
    );
  }
}
*/


  void handleLoginSuccess(String correo, String rol , String nombreCompleto) async {
    await saveEmail(correo);
    await authService.saveSession(correo, rol: rol , nombre : nombreCompleto);

    Widget destination;
    if (rol == 'admin') {
      destination = AdminDashboard(correo: correo , rol : rol);
    } else if (rol == 'huesped'){
      destination = GuestDashboard(correo: correo, rol: rol);
    }
    else if( rol == 'anfitrion'){
      destination = HostDashboard(correo: correo, rol: rol , nombre: nombreCompleto);
    }
    else{
      destination = LoginScreen();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

void login() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => loading = true);

  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  final user = await authService.loginUser(email, password);

  if (user != null) {
    final rol = user['rol'];
    saveEmail(email);
    final nombreCompleto = '${user['nombre']} ${user['apellido']}';
    await authService.saveSession(email,rol: rol,nombre : nombreCompleto);
    handleLoginSuccess(email, rol , nombreCompleto);
  } else {
    setState(() => loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario o contraseña incorrectos')),
    );
  }
}


  Widget buildFloatingLabel({required String text, required bool isActive}) {
    return Positioned(
      left: 20,
      top: isActive ? 6 : 22,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          fontSize: isActive ? 12 : 16,
          color: Colors.black,
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            Center(
              child: Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: colorPrimary,
                ),
              ),
            ),
            const SizedBox(height: 100),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese su correo electrónico';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Correo inválido';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          suffixIcon: Icon(Icons.email, size: 20, color: _emailFocusNode.hasFocus ? colorPrimary : Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF727374), width: 2)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF727374), width: 3)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorPrimary, width: 2)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorPrimary, width: 2)),
                          labelText: '',
                        ),
                      ),
                      buildFloatingLabel(
                        text: 'Correo electrónico',
                        isActive: _emailFocusNode.hasFocus || _emailController.text.isNotEmpty,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: _obscurePassword,
                        validator: (value) => value == null || value.isEmpty ? 'Por favor, ingrese la contraseña' : null,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.lock : Icons.lock_open, size: 20, color: _passwordFocusNode.hasFocus ? colorPrimary : Colors.grey),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF727374), width: 2)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF727374), width: 3)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorPrimary, width: 2)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: colorPrimary, width: 2)),
                          labelText: '',
                        ),
                      ),
                      buildFloatingLabel(
                        text: 'Contraseña',
                        isActive: _passwordFocusNode.hasFocus || _passwordController.text.isNotEmpty,
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),

                  // Login button
                  loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Ingresar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                ],
              ),
            ),

             /*ElevatedButton.icon(
              onPressed: _openWhatsApp,
              icon: Icon(Icons.chat),
              label: Text('Contactarse'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),                )

              ), 
              ),
              */
            const Spacer(),

            // Register option
            Column(
              children: [
                Text('Si no tienes cuenta,', style: TextStyle(fontSize: 16, color: colorPrimary)),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorPrimary, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Crear Cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorPrimary)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
