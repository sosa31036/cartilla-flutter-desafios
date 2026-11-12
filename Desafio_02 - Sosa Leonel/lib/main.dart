import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      home: const TarjetaScreen(),
    );
  }
}

// Es StatefulWidget porque el Switch cambia el color de fondo
class TarjetaScreen extends StatefulWidget {
  const TarjetaScreen({super.key});

  @override
  State<TarjetaScreen> createState() => _TarjetaScreenState();
}

class _TarjetaScreenState extends State<TarjetaScreen> {
  bool _fondoOscuro = false;

  @override
  Widget build(BuildContext context) {
    // Elegimos los colores según el valor del Switch
    Color colorFondo = _fondoOscuro ? Colors.blueGrey.shade900 : Colors.white;
    Color colorTexto = _fondoOscuro ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        title: const Text('Mi tarjeta personal'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Foto circular
              const CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage('https://github.com/sosa31036.png'),
              ),
              const SizedBox(height: 20),

              // Nombre completo
              Text(
                'Sosa Leonel',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorTexto,
                ),
              ),
              const SizedBox(height: 6),

              // Descripción en gris
              const Text(
                'Técnico en Informática',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Switch que cambia el fondo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Fondo oscuro', style: TextStyle(color: colorTexto)),
                  const SizedBox(width: 10),
                  Switch(
                    value: _fondoOscuro,
                    onChanged: (bool nuevoValor) {
                      setState(() {
                        _fondoOscuro = nuevoValor;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Botón que muestra un SnackBar
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Hola!')),
                  );
                },
                icon: const Icon(Icons.waving_hand),
                label: const Text('Saludar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
