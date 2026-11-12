import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp es StatefulWidget porque guarda si está el modo oscuro o no
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _modoOscuro = false;

  void _cambiarTema(bool valor) {
    setState(() {
      _modoOscuro = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Material 3 con colorSchemeSeed
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _modoOscuro ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        modoOscuro: _modoOscuro,
        onCambiarTema: _cambiarTema,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool modoOscuro;
  final Function(bool) onCambiarTema;

  const HomeScreen({
    super.key,
    required this.modoOscuro,
    required this.onCambiarTema,
  });

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

  void _abrirConfiguracion() {
    Navigator.pop(context); // primero cerramos el drawer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfiguracionScreen(
          modoOscuro: widget.modoOscuro,
          onCambiarTema: widget.onCambiarTema,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_seccion]),
        backgroundColor: cs.primaryContainer,
        foregroundColor: cs.onPrimaryContainer,
      ),

      // ── Drawer ─────────────────────────────────────────
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: cs.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage('https://github.com/sosa31036.png'),
                  ),
                  const SizedBox(height: 10),
                  Text('Sosa Leonel',
                      style: TextStyle(color: cs.onPrimary, fontSize: 16)),
                  Text('sosa31036@gmail.com',
                      style: TextStyle(color: cs.onPrimary, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: _seccion == 0,
              onTap: () {
                setState(() => _seccion = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis Tareas'),
              selected: _seccion == 1,
              onTap: () {
                setState(() => _seccion = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              selected: _seccion == 2,
              onTap: () {
                setState(() => _seccion = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: _abrirConfiguracion,
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: cs.error),
              title: Text('Cerrar sesión', style: TextStyle(color: cs.error)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: _pantallas[_seccion],

      // ── NavigationBar con 3 secciones ──────────────────
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

      // EXTRA: el FAB solo aparece en la sección Tareas
      floatingActionButton: _seccion == 1
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Agregar tarea nueva')),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// ── Pantalla de Inicio ─────────────────────────────────
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner con Container decorado
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Este es tu resumen de la semana',
                  style: TextStyle(color: cs.onPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Row con 3 estadísticas
          Row(
            children: [
              Expanded(child: Estadistica(numero: '12', texto: 'Tareas')),
              const SizedBox(width: 10),
              Expanded(child: Estadistica(numero: '8', texto: 'Hechas')),
              const SizedBox(width: 10),
              Expanded(child: Estadistica(numero: '4', texto: 'Pendientes')),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget reutilizable para cada estadística
class Estadistica extends StatelessWidget {
  final String numero;
  final String texto;

  const Estadistica({super.key, required this.numero, required this.texto});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            numero,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: cs.onSecondaryContainer,
            ),
          ),
          Text(texto, style: TextStyle(color: cs.onSecondaryContainer)),
        ],
      ),
    );
  }
}

// ── Pantalla de Tareas ─────────────────────────────────
class TareasScreen extends StatelessWidget {
  const TareasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    List<String> tareas = ['Estudiar Dart', 'Hacer el Desafío 3', 'Subir a GitHub'];

    return ListView.builder(
      itemCount: tareas.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: cs.tertiaryContainer,
            child: Text('${index + 1}',
                style: TextStyle(color: cs.onTertiaryContainer)),
          ),
          title: Text(tareas[index]),
        );
      },
    );
  }
}

// ── Pantalla de Perfil ─────────────────────────────────
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://github.com/sosa31036.png'),
          ),
          const SizedBox(height: 12),
          Text(
            'Sosa Leonel',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          Text('4t0 4ta - Informática', style: TextStyle(color: cs.outline)),
        ],
      ),
    );
  }
}

// ── Pantalla de Configuración ──────────────────────────
// Tiene su propia copia del valor para que el Switch se mueva al tocarlo
class ConfiguracionScreen extends StatefulWidget {
  final bool modoOscuro;
  final Function(bool) onCambiarTema;

  const ConfiguracionScreen({
    super.key,
    required this.modoOscuro,
    required this.onCambiarTema,
  });

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  late bool _oscuro;

  @override
  void initState() {
    super.initState();
    _oscuro = widget.modoOscuro;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Cambia el tema de la app'),
            value: _oscuro,
            onChanged: (bool nuevoValor) {
              setState(() {
                _oscuro = nuevoValor;
              });
              widget.onCambiarTema(nuevoValor); // avisa a MyApp
            },
          ),
        ],
      ),
    );
  }
}
