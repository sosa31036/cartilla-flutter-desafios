import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/tareas_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;
  final List<String> _titulos = ['Inicio', 'Tareas', 'Perfil'];

  @override
  Widget build(BuildContext context) {
    final User? usuario = FirebaseAuth.instance.currentUser;
    final String email = usuario?.email ?? 'Sin email';

    final List<Widget> pantallas = [
      InicioSeccion(email: email),
      const TareasSeccion(),
      PerfilSeccion(email: email),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_seccion])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.orange),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Text(email[0].toUpperCase(), style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(height: 10),
                  Text(email, style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                setState(() => _seccion = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis tareas'),
              onTap: () {
                setState(() => _seccion = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                setState(() => _seccion = 2);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            // Cerrar sesión: el StreamBuilder de main.dart vuelve al Login solo
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await cerrarSesion();
              },
            ),
          ],
        ),
      ),
      body: pantallas[_seccion],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (int i) => setState(() => _seccion = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.task_outlined), selectedIcon: Icon(Icons.task_alt), label: 'Tareas'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

// ── Sección Inicio ──────────────────────────────────────
class InicioSeccion extends StatelessWidget {
  final String email;
  const InicioSeccion({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          '¡Bienvenido/a!\n$email',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ── Sección Tareas (Firestore en tiempo real) ───────────
class TareasSeccion extends StatefulWidget {
  const TareasSeccion({super.key});

  @override
  State<TareasSeccion> createState() => _TareasSeccionState();
}

class _TareasSeccionState extends State<TareasSeccion> {
  final TextEditingController _tareaCtrl = TextEditingController();

  @override
  void dispose() {
    _tareaCtrl.dispose();
    super.dispose();
  }

  void _agregar() {
    String texto = _tareaCtrl.text.trim();
    if (texto.isEmpty) return;
    agregarTarea(texto);
    _tareaCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tareaCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nueva tarea',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _agregar, child: const Text('Agregar')),
            ],
          ),
        ),
        Expanded(
          // StreamBuilder: se redibuja solo cuando cambia algo en Firestore
          child: StreamBuilder<QuerySnapshot>(
            stream: tareasDelUsuario(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Center(child: Text('Todavía no tenés tareas'));
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  final data = docs[i].data() as Map<String, dynamic>;
                  return ListTile(
                    leading: Checkbox(
                      value: data['completada'] ?? false,
                      onChanged: (valor) => actualizarTarea(docs[i].id, valor ?? false),
                    ),
                    title: Text(data['titulo'] ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => eliminarTarea(docs[i].id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Sección Perfil ──────────────────────────────────────
class PerfilSeccion extends StatelessWidget {
  final String email;
  const PerfilSeccion({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 45, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 12),
          Text(email, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            'ID: ${FirebaseAuth.instance.currentUser?.uid ?? '-'}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
