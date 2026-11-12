// data/local/local_database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/tarea.dart';

class LocalDatabase {
  // Una sola instancia de la base de datos para toda la app (Singleton)
  static Database? _instance;

  Future<Database> get database async {
    if (_instance != null) return _instance!;
    _instance = await _abrirBD();
    return _instance!;
  }

  Future<Database> _abrirBD() async {
    final directorio = await getDatabasesPath();
    final ruta = join(directorio, 'desafio6_tareas.db');

    return openDatabase(
      ruta,
      version: 1,
      // onCreate se ejecuta solo la primera vez
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE tareas (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo     TEXT NOT NULL,
            completada INTEGER NOT NULL DEFAULT 0,
            fecha      TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // ── CREATE ────────────────────────────────────────────
  Future<int> insertar(Tarea tarea) async {
    final db = await database;
    return await db.insert(
      'tareas',
      tarea.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ── READ ──────────────────────────────────────────────
  Future<List<Tarea>> obtenerTodas() async {
    final db = await database;
    final maps = await db.query('tareas', orderBy: 'id DESC');
    return maps.map((map) => Tarea.fromMap(map)).toList();
  }

  // ── UPDATE ────────────────────────────────────────────
  Future<int> actualizar(Tarea tarea) async {
    final db = await database;
    return await db.update(
      'tareas',
      tarea.toMap(),
      where: 'id = ?',
      whereArgs: [tarea.id],
    );
  }

  // ── DELETE ────────────────────────────────────────────
  Future<int> eliminar(int id) async {
    final db = await database;
    return await db.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
