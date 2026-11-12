import 'package:flutter_riverpod/flutter_riverpod.dart';

// Cada tarea tiene un título, si está completada y su prioridad (EXTRA)
class Tarea {
  final String titulo;
  final bool completada;
  final String prioridad; // 'alta', 'media' o 'baja'

  const Tarea({
    required this.titulo,
    this.completada = false,
    this.prioridad = 'media',
  });
}

// Estructura del estado
class TasksState {
  final List<Tarea> tareas;

  const TasksState({this.tareas = const []});

  // Getters calculados
  int get completadas => tareas.where((t) => t.completada).length;
  int get pendientes => tareas.length - completadas;
}

// El Notifier guarda el estado y tiene los métodos para modificarlo
class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier() : super(const TasksState());

  void agregar(String titulo, String prioridad) {
    state = TasksState(
      tareas: [...state.tareas, Tarea(titulo: titulo, prioridad: prioridad)],
    );
  }

  void eliminar(int indice) {
    final nuevas = [...state.tareas];
    nuevas.removeAt(indice);
    state = TasksState(tareas: nuevas);
  }

  // Cambia la tarea de pendiente a completada (o al revés)
  void toggleCompletada(int indice) {
    final nuevas = [...state.tareas];
    Tarea vieja = nuevas[indice];
    nuevas[indice] = Tarea(
      titulo: vieja.titulo,
      completada: !vieja.completada,
      prioridad: vieja.prioridad,
    );
    state = TasksState(tareas: nuevas);
  }
}

// Provider global
final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(),
);
