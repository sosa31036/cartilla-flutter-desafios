// domain/entities/tarea.dart

class Tarea {
  final int? id; // null hasta que la BD lo asigna
  final String titulo;
  final bool completada;
  final String fecha;

  Tarea({
    this.id,
    required this.titulo,
    this.completada = false,
    required this.fecha,
  });

  // Dart -> SQLite (bool no existe en SQLite: true = 1, false = 0)
  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'completada': completada ? 1 : 0,
        'fecha': fecha,
      };

  // SQLite -> Dart
  factory Tarea.fromMap(Map<String, dynamic> map) => Tarea(
        id: map['id'],
        titulo: map['titulo'],
        completada: map['completada'] == 1,
        fecha: map['fecha'],
      );

  // Copia de la tarea cambiando solo si está completada
  Tarea copyWith({bool? completada}) => Tarea(
        id: id,
        titulo: titulo,
        completada: completada ?? this.completada,
        fecha: fecha,
      );
}
