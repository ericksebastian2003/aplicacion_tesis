import 'package:flutter/material.dart';
import 'package:hotels/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Color colorPrimary = Color(0xFF001D5A);
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

  bool _isPasswordVisible = false;
  bool loading = false;
  final authService = AuthService();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _controllers.values.forEach((controller) {
      controller.dispose();
    });
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    final userData = {
      'nombre': _controllers['nombre']?.text.trim() ?? '',
      'apellido': _controllers['apellido']?.text.trim() ?? '',
      'cedula': _controllers['cedula']?.text.trim() ?? '',
      'telefono': _controllers['telefono']?.text.trim() ?? '',
      'email': _controllers['email']?.text.trim() ?? '',
      'password': _controllers['password']?.text.trim() ?? '',
      'diaNacimiento': _controllers['diaNacimiento']?.text.trim() ?? '',
    };

    var response = await authService.register(userData);
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Registrarse',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF001D5A),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextFormField('nombre', 'Nombre'),
              _buildTextFormField('apellido', 'Apellido'),
              _buildTextFormField('cedula', 'Número de cédula'),
              _buildTextFormField('telefono', 'Número de telefono'),
              _buildTextFormField('email', 'Correo electrónico', focusNode: _emailFocusNode),
              _buildFieldPassword('password', 'Contraseña'),
              _buildTextFormField('diaNacimiento', 'Fecha de Nacimiento'),
              const SizedBox(height: 20),
              Center(
                child: loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 18),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String key, String labelText, {FocusNode? focusNode, bool obscureText = false}) {
    return Stack(
      children: [
        TextFormField(
          controller: _controllers[key],
          focusNode: focusNode,
          obscureText: obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            suffixIcon: Icon(
              focusNode?.hasFocus ?? false ? Icons.email : Icons.person,
              size: 20,
              color: focusNode?.hasFocus ?? false ? colorPrimary : Colors.grey,
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
            labelText: '',
            errorStyle: const TextStyle(color: Colors.white),
          ),
        ),
        Positioned(
          left: 20,
          top: (focusNode?.hasFocus ?? false || _controllers[key]!.text.isNotEmpty)
              ? 6
              : 22,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: (focusNode?.hasFocus ?? false || _controllers[key]!.text.isNotEmpty) ? 12 : 16,
              color: Colors.black,
            ),
            child: Text(labelText),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldPassword(String key, String labelText) {
    return Stack(
      children: [
        TextFormField(
          controller: _controllers[key],
          obscureText: !_isPasswordVisible,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                size: 20,
                color: _isPasswordVisible ? colorPrimary : Colors.grey,
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
            labelText: '',
            errorStyle: const TextStyle(color: Colors.white),
          ),
        ),
        Positioned(
          left: 20,
          top: (_isPasswordVisible || _controllers[key]!.text.isNotEmpty) ? 6 : 22,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: (_isPasswordVisible || _controllers[key]!.text.isNotEmpty) ? 12 : 16,
              color: Colors.black,
            ),
            child: const Text('Contraseña'),
          ),
        ),
      ],
    );
  }
}
