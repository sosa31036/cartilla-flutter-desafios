import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;

// ── CREATE ──────────────────────────────────────────────
Future<void> agregarTarea(String titulo) async {
  await db.collection('tareas').add({
    'titulo': titulo,
    'completada': false,
    'fechaCreacion': FieldValue.serverTimestamp(),
    // guardamos el id del usuario para mostrar solo sus tareas
    'userId': FirebaseAuth.instance.currentUser!.uid,
  });
}

// ── READ en tiempo real ─────────────────────────────────
// Solo las tareas del usuario actual
Stream<QuerySnapshot> tareasDelUsuario() {
  return db
      .collection('tareas')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
}

// ── UPDATE ──────────────────────────────────────────────
Future<void> actualizarTarea(String docId, bool completada) async {
  await db.collection('tareas').doc(docId).update({
    'completada': completada,
  });
}

// ── DELETE ──────────────────────────────────────────────
Future<void> eliminarTarea(String docId) async {
  await db.collection('tareas').doc(docId).delete();
}
