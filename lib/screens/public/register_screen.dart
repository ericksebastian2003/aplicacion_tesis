import 'package:flutter/material.dart';
import 'package:hotels/screens/public/login_screen.dart';
import 'package:hotels/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Color colorPrimary = const Color(0xFF001D5A);
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'nombre': TextEditingController(),
    'apellido': TextEditingController(),
    'cedula': TextEditingController(),
    'telefono': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'diaNacimiento': TextEditingController(),
  };

  final Map<String, FocusNode> _focusNodes = {
    'nombre': FocusNode(),
    'apellido': FocusNode(),
    'cedula': FocusNode(),
    'telefono': FocusNode(),
    'email': FocusNode(),
    'password': FocusNode(),
    'diaNacimiento': FocusNode(),
  };

  bool _isPasswordVisible = false;
  bool loading = false;

  final authService = AuthService();

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _focusNodes.values.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    final userData = {
      'nombre': _controllers['nombre']!.text.trim(),
      'apellido': _controllers['apellido']!.text.trim(),
      'cedula': _controllers['cedula']!.text.trim(),
      'telefono': _controllers['telefono']!.text.trim(),
      'email': _controllers['email']!.text.trim(),
      'password': _controllers['password']!.text.trim(),
      'diaNacimiento': _controllers['diaNacimiento']!.text.trim(),
    };

    final response = await authService.register(userData);
    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response != null && response['message'] != null
            ? response['message']
            : 'Error desconocido'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Crear Cuenta',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: colorPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextFormField(
                              'nombre',
                              'Nombre',
                              icon: Icon(Icons.account_circle, color: colorPrimary),
                            ),
                            _buildTextFormField(
                              'apellido',
                              'Apellido',
                              icon: Icon(Icons.account_circle, color: colorPrimary),
                            ),
                            _buildTextFormField(
                              'cedula',
                              'Número de cédula',
                              icon: Icon(Icons.credit_card, color: colorPrimary),
                            ),
                            _buildTextFormField(
                              'telefono',
                              'Número de teléfono',
                              icon: Icon(Icons.phone, color: colorPrimary),
                            ),
                            _buildTextFormField(
                              'email',
                              'Correo electrónico',
                              focusNode: _focusNodes['email'],
                              icon: Icon(Icons.email, color: colorPrimary),
                            ),
                            _buildPasswordField(
                              'password',
                              'Contraseña',
                              icon: Icon(Icons.lock, color: colorPrimary),
                            ),
                            _buildTextFormField(
                              'diaNacimiento',
                              'Fecha de nacimiento',
                              icon: Icon(Icons.date_range, color: colorPrimary),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: loading
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: register,
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
                                        'Crear cuenta',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                onPressed: goToLogin,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 90, vertical: 18),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: colorPrimary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Cancelar',
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
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String key, String labelText,
      {FocusNode? focusNode, Icon? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controllers[key],
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: icon ?? Icon(
              Icons.person,
              size: 20,
              color: focusNode?.hasFocus ?? false ? colorPrimary : Colors.grey,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white, width: 4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: colorPrimary, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: colorPrimary, width: 2),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
          errorStyle: const TextStyle(color: Colors.white),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, complete el campo';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(String key, String labelText, {Icon? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controllers[key],
        focusNode: _focusNodes[key],
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: colorPrimary,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          prefixIcon: icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, ingrese una contraseña';
          }
          return null;
        },
      ),
    );
  }
}
