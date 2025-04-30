import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color colorPrimary = const Color(0xFF001D5A);
  final Map<String, TextEditingController> _controllers = {
    'nombre': TextEditingController(),
    'apellido': TextEditingController(),
    'cedula': TextEditingController(),
    'telefono': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  final Map<String, FocusNode> _focusNodes = {
    'nombre': FocusNode(),
    'apellido': FocusNode(),
    'cedula': FocusNode(),
    'telefono': FocusNode(),
    'email': FocusNode(),
    'password': FocusNode(),
  };

  DateTime? _dateSelected;
  bool loading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecciona tu fecha de nacimiento',
    );
    if (picked != null && picked != _dateSelected) {
      setState(() {
        _dateSelected = picked;
      });
    }
  }

  void register() {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta creada correctamente')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
               Text(
                'Crear Cuenta',
                style: TextStyle(
                  fontSize: 34,
                  color: colorPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(child: _buildPlainField('nombre', 'Nombres',Icon(Icons.person))),
                  const SizedBox(width: 10),
                  Expanded(child: _buildPlainField('apellido', 'Apellidos',Icon(Icons.person))),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildPlainField('cedula', 'Número de cédula',Icon(Icons.assignment_ind))),
                  const SizedBox(width: 10),
                  Expanded(child: _buildPlainField('telefono', 'Número de teléfono',Icon(Icons.numbers))),
                ],
              ),
              const SizedBox(height: 10),
              _buildPlainField('email', 'Correo electrónico',Icon(Icons.email)),
              const SizedBox(height: 10),
              _buildPasswordField('password', 'Contraseña',Icon(Icons.password)),
              const SizedBox(height: 10),
              _buildDateInputField(),
              const SizedBox(height: 30),
              Center(
                child: loading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: register,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlainField(String key, String hint , Icon? iconField) {
    return TextFormField(
      controller: _controllers[key],
      focusNode: _focusNodes[key],
      decoration: InputDecoration(
        prefixIcon: iconField,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
    );
  }

  Widget _buildPasswordField(String key, String hint , Icon? iconField) {
    return TextFormField(
      controller: _controllers[key],
      focusNode: _focusNodes[key],
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon:iconField,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
    );
  }

  Widget _buildDateInputField() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: 'Fecha de nacimiento',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                _dateSelected != null
                    ? DateFormat('dd/MM/yyyy').format(_dateSelected!)
                    : '',
                style: TextStyle(
                  fontSize: 16,
                  color: _dateSelected != null ? Colors.black : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
