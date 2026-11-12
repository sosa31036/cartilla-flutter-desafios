import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datos.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Hola, $usuarioActual!',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Hay ${listaPosts.length} posts para leer'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/posts'),
              child: const Text('Ver posts'),
            ),
            const SizedBox(height: 8),
            // Ejemplo del EXTRA: abre la lista ya filtrada con la URL
            OutlinedButton(
              onPressed: () => context.go('/posts?search=flutter'),
              child: const Text('Buscar "flutter"'),
            ),
          ],
        ),
      ),
    );
  }
}
