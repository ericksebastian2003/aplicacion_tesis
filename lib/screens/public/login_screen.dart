import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../admin/widgets/admin_dashboard.dart';
import '../users/widgets/user_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color colorPrimary = const Color(0xFF001D5A);
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final authService = AuthService();
  bool loading = false;
  bool _obscurePassword = true; // Variable para controlar la visibilidad de la contraseña

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
    if (role == 'huesped') {
      String correo = _emailController.text.trim();
      final auth = AuthService();
      await saveEmail(correo);
      await auth.saveSession(correo, role: 'huesped');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserDashboard(correo: correo),
        ),
      );
    }
     if (role == 'anfitrion') {
      String correo = _emailController.text.trim();
      final auth = AuthService();
      await saveEmail(correo);
      await auth.saveSession(correo, role: 'anfitrion');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserDashboard(correo: correo),
        ),
      );
    }  
    else if (role == 'admin') {
      String correo = _emailController.text.trim();
      await saveEmail(correo);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboard(correo: correo),
        ),
      );
    } else {
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
                        style: TextStyle(color: colorPrimary),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          suffixIcon: Icon(
                            Icons.email,
                            size: 20,
                            color: _emailFocusNode.hasFocus ? colorPrimary : Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF727374), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color:  Color(0xFF727374), width: 3),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: colorPrimary, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: colorPrimary, width: 2),
                          ),
                          labelText: '',
                          errorStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: (_emailFocusNode.hasFocus || _emailController.text.isNotEmpty) ? 6 : 22,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: (_emailFocusNode.hasFocus || _emailController.text.isNotEmpty) ? 12 : 16,
                            color: Colors.black,
                          ),
                          child: const Text('Correo electrónico'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      TextFormField(
                        focusNode: _passwordFocusNode,
                        controller: _passwordController,
                        obscureText: _obscurePassword, // Cambiar visibilidad de la contraseña
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.lock : Icons.lock_open, // Cambiar el ícono según la visibilidad
                              size: 20,
                              color: _passwordFocusNode.hasFocus ? colorPrimary : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword; // Alternar visibilidad
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: const Color(0xFF727374), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: const Color(0xFF727374), width: 3),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: colorPrimary, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: colorPrimary, width: 2),
                          ),
                          labelText: '',
                          errorStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: (_passwordFocusNode.hasFocus || _passwordController.text.isNotEmpty) ? 6 : 22,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: (_passwordFocusNode.hasFocus || _passwordController.text.isNotEmpty) ? 12 : 16,
                            color: Colors.black,
                          ),
                          child: const Text('Contraseña'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  'Si no tienes cuenta,',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: colorPrimary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Crear Cuenta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height:20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
