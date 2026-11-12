// Desafío 1 — Registro de alumnos (Dart puro, sin Flutter)
// Para ejecutarlo: dart run registro_alumnos.dart  (o pegarlo en dartpad.dev)

class Alumno {
  final String nombre;
  final String apellido;
  final int edad;
  final List<double> notas; // las 3 notas del alumno

  Alumno({
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.notas,
  });

  // Suma las 3 notas y divide por la cantidad
  double calcularPromedio() {
    double suma = 0;
    for (double nota in notas) {
      suma = suma + nota;
    }
    return suma / notas.length;
  }

  // 6 o más: aprobado | de 4 a 6: recuperatorio | menos de 4: desaprobado
  String estadoFinal() {
    double promedio = calcularPromedio();
    if (promedio >= 6) {
      return 'Aprobado';
    } else if (promedio >= 4) {
      return 'Recuperatorio';
    } else {
      return 'Desaprobado';
    }
  }

  @override
  String toString() {
    String promedio = calcularPromedio().toStringAsFixed(2);
    return '$nombre $apellido ($edad años) -- Promedio: $promedio -- ${estadoFinal()}';
  }
}

void main() {
  // 1. Lista de 5 alumnos distintos
  List<Alumno> alumnos = [
    Alumno(nombre: 'Sofía', apellido: 'Mamani', edad: 17, notas: [8, 9, 7.5]),
    Alumno(nombre: 'Lucas', apellido: 'Pérez', edad: 16, notas: [4, 5, 3]),
    Alumno(nombre: 'Ana', apellido: 'Martínez', edad: 18, notas: [10, 9.5, 9]),
    Alumno(nombre: 'Mateo', apellido: 'López', edad: 17, notas: [2, 3.5, 4]),
    Alumno(nombre: 'Valentina', apellido: 'Ruiz', edad: 16, notas: [6, 7, 6.5]),
  ];

  // 2. Mostrar el estado de cada alumno
  print('===== ESTADO DE LOS ALUMNOS =====');
  for (Alumno alumno in alumnos) {
    print(alumno);
  }

  // 3. Buscar el alumno con el promedio más alto
  Alumno mejorAlumno = alumnos[0];
  for (Alumno alumno in alumnos) {
    if (alumno.calcularPromedio() > mejorAlumno.calcularPromedio()) {
      mejorAlumno = alumno;
    }
  }
  print('');
  print('Mejor promedio: ${mejorAlumno.nombre} ${mejorAlumno.apellido} '
      'con ${mejorAlumno.calcularPromedio().toStringAsFixed(2)}');

  // 4. Contar aprobados y desaprobados
  // (los que están en recuperatorio se cuentan aparte)
  int aprobados = 0;
  int desaprobados = 0;
  int recuperatorio = 0;
  for (Alumno alumno in alumnos) {
    String estado = alumno.estadoFinal();
    if (estado == 'Aprobado') {
      aprobados++;
    } else if (estado == 'Desaprobado') {
      desaprobados++;
    } else {
      recuperatorio++;
    }
  }
  print('');
  print('Aprobados: $aprobados');
  print('Desaprobados: $desaprobados');
  print('En recuperatorio: $recuperatorio');

  // 5. EXTRA: ordenar de mayor a menor promedio con list.sort()
  alumnos.sort((a, b) => b.calcularPromedio().compareTo(a.calcularPromedio()));
  print('');
  print('===== RANKING (mayor a menor promedio) =====');
  for (int i = 0; i < alumnos.length; i++) {
    print('${i + 1}. ${alumnos[i]}');
  }
}
