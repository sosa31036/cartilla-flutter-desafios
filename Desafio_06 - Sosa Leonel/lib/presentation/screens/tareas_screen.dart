import 'package:flutter/material.dart';
import '../../data/local/local_database.dart';
import '../../domain/entities/tarea.dart';
import 'configuracion_screen.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final LocalDatabase _db = LocalDatabase();
  final TextEditingController _tareaCtrl = TextEditingController();

  List<Tarea> _tareas = [];
  bool _cargando = true;
  String _filtro = 'todas'; // EXTRA: 'todas', 'pendientes' o 'completadas'

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  @override
  void dispose() {
    _tareaCtrl.dispose();
    super.dispose();
  }

  // Lee todas las tareas guardadas en SQLite
  Future<void> _cargarTareas() async {
    List<Tarea> lista = await _db.obtenerTodas();
    setState(() {
      _tareas = lista;
      _cargando = false;
    });
  }

  Future<void> _agregar() async {
    String texto = _tareaCtrl.text.trim();
    if (texto.isEmpty) return;

    // Guardamos la fecha como texto: '2026-11-05 15:30'
    String fecha = DateTime.now().toString().substring(0, 16);
    await _db.insertar(Tarea(titulo: texto, fecha: fecha));
    _tareaCtrl.clear();
    await _cargarTareas();
  }

  Future<void> _cambiarCompletada(Tarea tarea, bool valor) async {
    await _db.actualizar(tarea.copyWith(completada: valor));
    await _cargarTareas();
  }

  Future<void> _eliminar(Tarea tarea) async {
    // la sacamos de la lista en el momento para que Dismissible no dé error
    setState(() {
      _tareas.remove(tarea);
    });
    await _db.eliminar(tarea.id!);
  }

  // EXTRA: devuelve solo las tareas que coinciden con el filtro
  List<Tarea> _tareasFiltradas() {
    if (_filtro == 'pendientes') {
      return _tareas.where((t) => !t.completada).toList();
    } else if (_filtro == 'completadas') {
      return _tareas.where((t) => t.completada).toList();
    }
    return _tareas;
  }

  @override
  Widget build(BuildContext context) {
    List<Tarea> lista = _tareasFiltradas();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfiguracionScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // TextField + botón Agregar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tareaCtrl,
                    onSubmitted: (_) => _agregar(),
                    decoration: InputDecoration(
                      labelText: 'Nueva tarea',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _agregar,
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),

          // EXTRA: menú desplegable para filtrar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Text('Mostrar: '),
                DropdownButton<String>(
                  value: _filtro,
                  items: const [
                    DropdownMenuItem(value: 'todas', child: Text('Todas')),
                    DropdownMenuItem(value: 'pendientes', child: Text('Pendientes')),
                    DropdownMenuItem(value: 'completadas', child: Text('Completadas')),
                  ],
                  onChanged: (String? valor) {
                    setState(() {
                      _filtro = valor ?? 'todas';
                    });
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : lista.isEmpty
                    ? const Center(child: Text('No hay tareas'))
                    : ListView.builder(
                        itemCount: lista.length,
                        itemBuilder: (context, index) {
                          Tarea tarea = lista[index];
                          // Dismissible: deslizar hacia un costado para eliminar
                          return Dismissible(
                            key: ValueKey(tarea.id),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              _eliminar(tarea);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Tarea "${tarea.titulo}" eliminada')),
                              );
                            },
                            child: CheckboxListTile(
                              title: Text(
                                tarea.titulo,
                                style: TextStyle(
                                  decoration: tarea.completada
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(tarea.fecha),
                              value: tarea.completada,
                              onChanged: (bool? valor) {
                                _cambiarCompletada(tarea, valor ?? false);
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
