import 'package:flutter/material.dart';
import 'presentation/router/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router() en lugar de MaterialApp()
    return MaterialApp.router(
      title: 'App con GoRouter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      // Ya no hay 'home:', GoRouter maneja la pantalla inicial
      routerConfig: appRouter,
    );
  }
}
