import 'package:flutter/material.dart';
import '../users/guest/services/auth_service.dart'; // Servicio de autenticación
import '../admin/widgets/admin_dashboard.dart';     // Pantalla para el rol admin
import '../users/guest/widgets/user_dashboard.dart'; // Pantalla para los roles huesped y anfitrión
import 'package:shared_preferences/shared_preferences.dart'; // Para guardar datos localmente
import 'register_screen.dart'; // Pantalla de registro

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Colores y controladores
  final Color colorPrimary = const Color(0xFF001D5A);
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>(); // Clave para validar el formulario
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final authService = AuthService(); // Instancia del servicio de autenticación
  bool loading = false; // Muestra cargando mientras se hace login
  bool _obscurePassword = true; // Ocultar o mostrar contraseña

  // Guarda el correo en SharedPreferences
  Future<void> saveEmail(String correo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('_correo', correo);
  }

  // Función de inicio de sesión
  void login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    // Llamada al servicio de autenticación
    String? rol = await authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => loading = false);

    if (rol == 'huesped') {
      String correo = _emailController.text.trim();
      final auth = AuthService();
      await saveEmail(correo);
      await auth.saveSession(correo, rol: 'huesped');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserDashboard(correo: correo, rol: 'huesped'),
        ),
      );
    }

    if (rol == 'anfitrion') {
      String correo = _emailController.text.trim();
      final auth = AuthService();
      await saveEmail(correo);
      await auth.saveSession(correo, rol: 'anfitrion');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserDashboard(correo: correo, rol: 'anfitrion'),
        ),
      );
    }

    else if (rol == 'admin') {
      String correo = _emailController.text.trim();
      await saveEmail(correo);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboard(correo: correo),
        ),
      );
    } else {
      // En caso de error de autenticación
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
    // Listeners para que la animación del label reaccione al enfoque
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
                  // Campo de correo electrónico
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
                            borderSide: const BorderSide(color: Color(0xFF727374), width: 3),
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
                      // Animación del texto flotante
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

                  // Campo de contraseña
                  Stack(
                    children: [
                      TextFormField(
                        focusNode: _passwordFocusNode,
                        controller: _passwordController,
                        obscureText: _obscurePassword,
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
                              _obscurePassword ? Icons.lock : Icons.lock_open,
                              size: 20,
                              color: _passwordFocusNode.hasFocus ? colorPrimary : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
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
                          errorStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
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

                  // Botón de ingreso o cargando
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

            // Opción para crear cuenta
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
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
