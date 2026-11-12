// presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/api_service.dart';
import '../../domain/entities/post.dart';
import '../providers/posts_provider.dart';
import 'detalle_screen.dart';

// ConsumerStatefulWidget: tiene setState y también ref (Riverpod)
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Post>> _postsFuture;
  String _busqueda = '';

  @override
  void initState() {
    super.initState();
    _postsFuture = _cargarPosts(false);
  }

  // Si el provider ya tiene posts los usa; si no, llama a la API y los guarda
  Future<List<Post>> _cargarPosts(bool forzar) async {
    List<Post> guardados = ref.read(postsProvider);
    if (guardados.isNotEmpty && !forzar) {
      return guardados;
    }
    List<Post> posts = await _apiService.getPosts();
    ref.read(postsProvider.notifier).guardar(posts);
    return posts;
  }

  void _recargar() {
    setState(() {
      _postsFuture = _cargarPosts(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Buscador dentro del AppBar
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Buscar por título...',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
          onChanged: (texto) {
            setState(() {
              _busqueda = texto;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _recargar,
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // ── ESTADO 1: cargando ──────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando noticias...'),
                ],
              ),
            );
          }

          // ── ESTADO 2: error ─────────────────────────────
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 64),
                    const SizedBox(height: 16),
                    const Text('Error al cargar los datos'),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _recargar,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── ESTADO 3: datos listos ──────────────────────
          final List<Post> todos = snapshot.data!;

          // Filtramos por título según lo escrito en el buscador
          final List<Post> posts = todos
              .where((p) => p.title.toLowerCase().contains(_busqueda.toLowerCase()))
              .toList();

          if (posts.isEmpty) {
            return const Center(child: Text('No hay posts con ese título'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${post.id}')),
                title: Text(post.title),
                subtitle: Text(
                  post.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalleScreen(post: post),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
