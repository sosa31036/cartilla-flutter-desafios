import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/services/asistencia_service.dart';

// Widget que muestra las asistencias de una fecha en tiempo real.
// Lo usan la pantalla de "Hoy" y el historial.
class ListaAsistencias extends StatelessWidget {
  final String fecha;

  const ListaAsistencias({super.key, required this.fecha});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: asistenciasDeFecha(fecha),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('No hay asistencias registradas'));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            return ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text(data['nombre'] ?? ''),
              subtitle: Text('Fecha: ${data['fecha']}'),
              trailing: Text(
                data['hora'] ?? '',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
    );
  }
}
