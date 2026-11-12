import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'presentation/screens/tareas_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar Hive y abrir la caja de preferencias antes de runApp()
  await Hive.initFlutter();
  await Hive.openBox('preferencias');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos la caja: si cambia 'modoOscuro', se redibuja toda la app
    return ValueListenableBuilder(
      valueListenable: Hive.box('preferencias').listenable(),
      builder: (context, box, _) {
        final bool oscuro = box.get('modoOscuro', defaultValue: false);

        return MaterialApp(
          title: 'Tareas SQLite + Hive',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.green,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.green,
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          themeMode: oscuro ? ThemeMode.dark : ThemeMode.light,
          home: const TareasScreen(),
        );
      },
    );
  }
}
