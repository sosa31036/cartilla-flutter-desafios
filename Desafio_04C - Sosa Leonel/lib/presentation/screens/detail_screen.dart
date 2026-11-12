import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datos.dart';

class DetailScreen extends StatelessWidget {
  final int postId; // viene de la URL: /posts/:id

  const DetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    Post? post = buscarPost(postId);

    return Scaffold(
      appBar: AppBar(title: Text('Post $postId')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: post == null
            ? const Center(child: Text('Ese post no existe'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.titulo,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(post.cuerpo, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // si llegamos con push volvemos atrás, si no vamos a /posts
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/posts');
                      }
                    },
                    child: const Text('Volver'),
                  ),
                ],
              ),
      ),
    );
  }
}
