import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

// Fecha de hoy como texto: '2026-11-05'
String fechaHoy() {
  return DateTime.now().toString().substring(0, 10);
}

// Hora actual como texto: '08:15'
String horaActual() {
  return DateTime.now().toString().substring(11, 16);
}

// Devuelve true si el alumno ya tiene asistencia registrada hoy
Future<bool> yaRegistradoHoy(String nombre) async {
  final resultado = await db
      .collection('asistencias')
      .where('nombre', isEqualTo: nombre)
      .where('fecha', isEqualTo: fechaHoy())
      .get();
  return resultado.docs.isNotEmpty;
}

// Guarda la asistencia con nombre, fecha y hora
Future<void> registrarAsistencia(String nombre) async {
  await db.collection('asistencias').add({
    'nombre': nombre,
    'fecha': fechaHoy(),
    'hora': horaActual(),
  });
}

// Stream con las asistencias de una fecha (para el StreamBuilder)
Stream<QuerySnapshot> asistenciasDeFecha(String fecha) {
  return db.collection('asistencias').where('fecha', isEqualTo: fecha).snapshots();
}

// Stream con todas las asistencias (para el historial)
Stream<QuerySnapshot> todasLasAsistencias() {
  return db.collection('asistencias').snapshots();
}

// Borra todos los registros del día de hoy
Future<void> limpiarRegistroDelDia() async {
  final resultado = await db
      .collection('asistencias')
      .where('fecha', isEqualTo: fechaHoy())
      .get();
  for (final doc in resultado.docs) {
    await doc.reference.delete();
  }
}
