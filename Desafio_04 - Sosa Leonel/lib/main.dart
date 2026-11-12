import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tasks_provider.dart';

void main() {
  // ProviderScope va por encima de toda la app
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ── Pantalla principal con NavigationBar y Drawer ─────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  final List<String> _titulos = ['Inicio', 'Tareas', 'Perfil'];

  final List<Widget> _pantallas = [
    const InicioScreen(),
    const TareasScreen(),
    const PerfilScreen(),
  ];

  void _irASeccion(int indice) {
    setState(() => _seccion = indice);
    Navigator.pop(context); // cerrar el drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_seccion])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage('https://github.com/sosa31036.png'),
                  ),
                  SizedBox(height: 10),
                  Text('Sosa Leonel',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('sosa31036@gmail.com',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () => _irASeccion(0),
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis Tareas'),
              onTap: () => _irASeccion(1),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () => _irASeccion(2),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('App de tareas - Desafío 4')),
                );
              },
            ),
          ],
        ),
      ),
      body: _pantallas[_seccion],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (int indice) {
          setState(() => _seccion = indice);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// ── Inicio: muestra el contador con ref.watch ─────────────
class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Tareas pendientes', style: TextStyle(fontSize: 20)),
          Text(
            '${state.pendientes}',
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
          ),
          Text('Completadas: ${state.completadas} de ${state.tareas.length}'),
        ],
      ),
    );
  }
}

// ── Tareas: TextField para agregar + lista ────────────────
// Usa ConsumerStatefulWidget porque necesita el controlador del TextField
// y la prioridad elegida (estado local) además de Riverpod
class TareasScreen extends ConsumerStatefulWidget {
  const TareasScreen({super.key});

  @override
  ConsumerState<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends ConsumerState<TareasScreen> {
  final TextEditingController _tareaCtrl = TextEditingController();
  String _prioridad = 'media';

  @override
  void dispose() {
    _tareaCtrl.dispose();
    super.dispose();
  }

  void _agregarTarea() {
    String texto = _tareaCtrl.text.trim();
    if (texto.isEmpty) {
      return; // no agregamos tareas vacías
    }
    ref.read(tasksProvider.notifier).agregar(texto, _prioridad);
    _tareaCtrl.clear();
  }

  // EXTRA: color según la prioridad
  Color _colorPrioridad(String prioridad) {
    if (prioridad == 'alta') {
      return Colors.red;
    } else if (prioridad == 'media') {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tasksProvider);

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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // EXTRA: elegir prioridad
              DropdownButton<String>(
                value: _prioridad,
                items: const [
                  DropdownMenuItem(value: 'alta', child: Text('Alta')),
                  DropdownMenuItem(value: 'media', child: Text('Media')),
                  DropdownMenuItem(value: 'baja', child: Text('Baja')),
                ],
                onChanged: (String? valor) {
                  setState(() {
                    _prioridad = valor ?? 'media';
                  });
                },
              ),
              IconButton.filled(
                onPressed: _agregarTarea,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: state.tareas.isEmpty
              ? const Center(child: Text('No hay tareas todavía'))
              : ListView.builder(
                  itemCount: state.tareas.length,
                  itemBuilder: (context, i) {
                    Tarea tarea = state.tareas[i];
                    return ListTile(
                      leading: Checkbox(
                        value: tarea.completada,
                        onChanged: (valor) {
                          ref.read(tasksProvider.notifier).toggleCompletada(i);
                        },
                      ),
                      title: Text(
                        tarea.titulo,
                        style: TextStyle(
                          decoration: tarea.completada
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        'Prioridad ${tarea.prioridad}',
                        style: TextStyle(color: _colorPrioridad(tarea.prioridad)),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ref.read(tasksProvider.notifier).eliminar(i);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ── Perfil ────────────────────────────────────────────────
class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://github.com/sosa31036.png'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sosa Leonel',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text('Tareas cargadas: ${state.tareas.length}'),
        ],
      ),
    );
  }
}
