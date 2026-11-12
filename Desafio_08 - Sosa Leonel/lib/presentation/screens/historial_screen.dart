import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/services/asistencia_service.dart';
import 'lista_asistencias.dart';

// EXTRA: historial de asistencias de fechas anteriores
class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: StreamBuilder<QuerySnapshot>(
        stream: todasLasAsistencias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Armamos una lista de fechas sin repetir y contamos los presentes
          List<String> fechas = [];
          Map<String, int> cantidadPorFecha = {};
          for (final doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            String fecha = data['fecha'] ?? '';
            if (!fechas.contains(fecha)) {
              fechas.add(fecha);
              cantidadPorFecha[fecha] = 0;
            }
            cantidadPorFecha[fecha] = cantidadPorFecha[fecha]! + 1;
          }
          // Ordenar de la más nueva a la más vieja
          fechas.sort((a, b) => b.compareTo(a));

          if (fechas.isEmpty) {
            return const Center(child: Text('Todavía no hay registros'));
          }

          return ListView.builder(
            itemCount: fechas.length,
            itemBuilder: (context, i) {
              String fecha = fechas[i];
              return ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(fecha == fechaHoy() ? '$fecha (hoy)' : fecha),
                subtitle: Text('${cantidadPorFecha[fecha]} presentes'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(title: Text('Asistencias del $fecha')),
                        body: ListaAsistencias(fecha: fecha),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
