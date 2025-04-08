import 'package:flutter/material.dart';
import 'package:hotels/screens/public/login_screen.dart';
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
  
  final Map<String, FocusNode> _focusNodes = {
    'nombre': FocusNode(),
    'apellido': FocusNode(),
    'cedula': FocusNode(),
    'telefono': FocusNode(),
    'email': FocusNode(),
    'password': FocusNode(),
    'fechaNacimiento': FocusNode(),
  };

  bool _isPasswordVisible = false;
  bool loading = false;
  final authService = AuthService();

  @override
  void dispose() {
    _controllers.values.forEach((controller) {
      controller.dispose();
    });
    _focusNodes.values.forEach((focusNode) {
      focusNode.dispose();
    });
    super.dispose();
  }
  void goToLogin(){
    
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Registrarse',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: colorPrimary ,                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextFormField('nombre', 'Nombre',icon: Icon(Icons.account_circle, color: colorPrimary)),
                  _buildTextFormField('apellido', 'Apellido',icon: Icon(Icons.account_circle, color: colorPrimary)),
                  _buildTextFormField('cedula', 'Número de cédula',icon: Icon(Icons.numbers, color: colorPrimary)),
                  _buildTextFormField('telefono', 'Número de teléfono',icon: Icon(Icons.numbers, color: colorPrimary)),
                  _buildTextFormField('email', 'Correo electrónico', focusNode: _focusNodes['email'],icon: Icon(Icons.email, color: colorPrimary)),
                  _buildPasswordField('password', 'Contraseña'),
                  _buildTextFormField('diaNacimiento', 'Fecha de Nacimiento',icon: Icon(Icons.date_range, color: colorPrimary)),
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
                  SizedBox(height: 40),
                  Center(
  child: ElevatedButton(
    onPressed: goToLogin,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 18),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: colorPrimary, // Color del borde
          width: 2, // Ancho del borde
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

                  
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildTextFormField(
  String key, 
  String labelText, 
  {FocusNode? focusNode, 
   Icon? icon}) {  // Icono personalizado como parámetro
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0), // Espaciado entre los campos
    child: TextFormField(
      controller: _controllers[key],
      focusNode: focusNode,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Ajusta el padding para alinear el icono
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10), // Ajusta el icono en relación con el borde
          child: icon ?? Icon( // Si no se pasa un icono, se usa uno predeterminado
            Icons.person,
            size: 20,
            color: focusNode?.hasFocus ?? false ? colorPrimary : Colors.grey, // Cambiar color según el foco
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
        labelStyle: TextStyle(color: Colors.black, fontSize: 16),
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

  Widget _buildPasswordField(String key, String labelText) {
    return _buildTextFormField(key, labelText, focusNode: _focusNodes[key]);
  }
}
