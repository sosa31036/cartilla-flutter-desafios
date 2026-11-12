// EXTRA: Provider de Riverpod que guarda los posts ya cargados.
// Así, si se vuelve a abrir la pantalla, no hace falta llamar otra vez a la API.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/post.dart';

class PostsNotifier extends StateNotifier<List<Post>> {
  PostsNotifier() : super([]);

  void guardar(List<Post> posts) {
    state = posts;
  }

  void borrar() {
    state = [];
  }
}

final postsProvider = StateNotifierProvider<PostsNotifier, List<Post>>(
  (ref) => PostsNotifier(),
);
