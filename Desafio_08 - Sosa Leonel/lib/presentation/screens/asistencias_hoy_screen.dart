import 'package:flutter/material.dart';
import '../../data/services/asistencia_service.dart';
import 'lista_asistencias.dart';

class AsistenciasHoyScreen extends StatelessWidget {
  const AsistenciasHoyScreen({super.key});

  // Pide confirmación antes de borrar
  void _confirmarLimpieza(BuildContext context) {
    showDialog(
      context: context,
      builder: (contextDialogo) => AlertDialog(
        title: const Text('Limpiar registro'),
        content: const Text('¿Seguro que querés borrar todas las asistencias de hoy?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextDialogo),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(contextDialogo);
              await limpiarRegistroDelDia();
            },
            child: const Text('Borrar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asistencias de hoy (${fechaHoy()})')),
      body: Column(
        children: [
          Expanded(child: ListaAsistencias(fecha: fechaHoy())),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmarLimpieza(context),
                icon: const Icon(Icons.delete_sweep, color: Colors.red),
                label: const Text('Limpiar registro del día'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
