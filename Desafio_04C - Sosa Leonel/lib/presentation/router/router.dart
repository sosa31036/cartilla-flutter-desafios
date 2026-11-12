import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datos.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/posts_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',

  // Redirección: si no hay sesión, mandamos al usuario a /login
  redirect: (BuildContext context, GoRouterState state) {
    final bool esRutaLogin = state.uri.path == '/login';

    if (!sesionIniciada && !esRutaLogin) {
      return '/login';
    }
    if (sesionIniciada && esRutaLogin) {
      return '/';
    }
    return null; // navegar normalmente
  },

  routes: [
    // ShellRoute: estas pantallas comparten el NavigationBar
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/posts',
          builder: (context, state) {
            // EXTRA: parámetro de búsqueda en la URL -> /posts?search=flutter
            final String busqueda = state.uri.queryParameters['search'] ?? '';
            return PostsScreen(busqueda: busqueda);
          },
          routes: [
            // Sub-ruta /posts/:id
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final int id = int.parse(state.pathParameters['id']!);
                return DetailScreen(postId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // Fuera del shell (sin NavigationBar)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Página no encontrada: ${state.uri}')),
  ),
);
