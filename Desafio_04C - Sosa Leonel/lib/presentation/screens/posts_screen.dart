import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datos.dart';

class PostsScreen extends StatefulWidget {
  final String busqueda; // viene de la URL: /posts?search=...

  const PostsScreen({super.key, required this.busqueda});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final TextEditingController _buscarCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _buscarCtrl.text = widget.busqueda;
  }

  @override
  void didUpdateWidget(PostsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // si cambió la URL, actualizamos el texto del buscador
    if (oldWidget.busqueda != widget.busqueda) {
      _buscarCtrl.text = widget.busqueda;
    }
  }

  @override
  void dispose() {
    _buscarCtrl.dispose();
    super.dispose();
  }

  void _buscar(String texto) {
    if (texto.trim().isEmpty) {
      context.go('/posts');
    } else {
      // encodeComponent cambia los espacios y símbolos para que la URL sea válida
      context.go('/posts?search=${Uri.encodeComponent(texto.trim())}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtramos los posts según la búsqueda de la URL
    List<Post> posts = listaPosts
        .where((p) => p.titulo.toLowerCase().contains(widget.busqueda.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _buscarCtrl,
              textInputAction: TextInputAction.search,
              onSubmitted: _buscar,
              decoration: InputDecoration(
                hintText: 'Buscar por título...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: posts.isEmpty
                ? const Center(child: Text('No se encontraron posts'))
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      Post post = posts[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${post.id}')),
                        title: Text(post.titulo),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        // push apila la pantalla: se puede volver atrás
                        onTap: () => context.push('/posts/${post.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
