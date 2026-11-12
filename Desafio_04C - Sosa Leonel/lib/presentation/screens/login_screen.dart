import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datos.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nombreCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  void _ingresar() {
    String nombre = _nombreCtrl.text.trim();
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribí tu nombre para entrar')),
      );
      return;
    }
    sesionIniciada = true;
    usuarioActual = nombre;
    // go reemplaza la pantalla: no se puede volver atrás al login
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_outline, size: 80),
            const SizedBox(height: 20),
            TextField(
              controller: _nombreCtrl,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _ingresar,
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
