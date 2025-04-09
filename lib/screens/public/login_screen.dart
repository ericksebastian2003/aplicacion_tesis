import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../admin/admin_dashboard.dart';
import '../users/widgets/user_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color colorPrimary = Color(0xFF001D5A);
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final authService = AuthService();
  bool loading = false;

  Future<void> saveEmail(String correo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('_correo', correo);
  }

  void login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    String? role = await authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => loading = false);
    if (role == 'user') {
      String correo = _emailController.text.trim();
      await saveEmail(correo);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserDashboard(correo: correo),
        ),
      );
    }
    else if(role=='admin'){
      String correo = _emailController.text.trim();
      await saveEmail(correo);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboard(correo: correo),
        ),
      );

    } 
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: 
            const Text(
              'Iniciar sesión',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            ),
            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Campo de Correo con efecto de etiqueta flotante personalizada
                  Stack(
                    children: [
                      TextFormField(
                        focusNode: _emailFocusNode,
                        controller: _emailController,
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
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          suffixIcon: Icon
                          (Icons.email,
                          size: 20,
                          color:  _emailFocusNode.hasFocus ? colorPrimary : Colors.grey,
                    ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                const BorderSide(color: Colors.white, width: 4),
                          ),
                          errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: colorPrimary , width: 2), // Borde con error (sin cambiar el border-radius)
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: colorPrimary , width: 2), // Borde enfocado con error
  ),
                          labelText: '', // se desactiva el label por defecto
                          errorStyle: const TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                      // Etiqueta personalizada animada (correo electrónico)
                      Positioned(
                        left: 20,
                        top: (_emailFocusNode.hasFocus ||
                                _emailController.text.isNotEmpty)
                            ? 6
                            : 22,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: (_emailFocusNode.hasFocus ||
                                    _emailController.text.isNotEmpty)
                                ? 12
                                : 16,
                    
                            color: Colors.black,
                          ),
                          child: const Text('Correo electrónico'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Campo de Contraseña con mismo efecto de etiqueta
                  Stack(
                    children: [
                      TextFormField(
                        focusNode: _passwordFocusNode,
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese la contraseña';
                          }
                          return null;
                        },
                    
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          suffixIcon:  Icon(
                            Icons.lock,
                            size: 20,
                            color: _passwordFocusNode.hasFocus ? colorPrimary : Colors.grey
                            ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                const BorderSide(color: Colors.white, width: 4),
                          ),
                          errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide:  BorderSide(color: colorPrimary, width: 2),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: colorPrimary, width: 2), 
  ),
                          labelText: '',
                          errorStyle: const TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      Positioned(
                        left:20,
                        top: (_passwordFocusNode.hasFocus ||
                                _passwordController.text.isNotEmpty)
                            ? 6
                            : 22,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: (_passwordFocusNode.hasFocus ||
                                    _passwordController.text.isNotEmpty)
                                ? 12
                                : 16,
                            color: Colors.black,
                          ),
                          child: const Text('Contraseña'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height:100),
                  Center(
                    child: loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 90, vertical: 18),
                              backgroundColor: const Color(0xFF021337),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Ingresar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 50),

                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Text(
                          'Si no tienes cuenta,',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 90, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child:  Text(
                            'Crear Cuenta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorPrimary
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
