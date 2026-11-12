// Datos de ejemplo de la app (todavía no usamos una API, eso es la Unidad 5)

// Sesión "falsa": guarda si el usuario inició sesión o no.
// Más adelante (Unidad 7) esto se reemplaza por FirebaseAuth.
bool sesionIniciada = false;
String usuarioActual = '';

class Post {
  final int id;
  final String titulo;
  final String cuerpo;

  Post({required this.id, required this.titulo, required this.cuerpo});
}

List<Post> listaPosts = [
  Post(id: 1, titulo: 'Qué es Flutter', cuerpo: 'Flutter es un framework de Google para crear apps.'),
  Post(id: 2, titulo: 'Widgets básicos', cuerpo: 'Text, Icon, ElevatedButton y Container son los más usados.'),
  Post(id: 3, titulo: 'Flutter y Material 3', cuerpo: 'Material 3 se activa con useMaterial3: true.'),
  Post(id: 4, titulo: 'Estado con setState', cuerpo: 'setState le avisa a Flutter que tiene que redibujar.'),
  Post(id: 5, titulo: 'Riverpod', cuerpo: 'Riverpod sirve para compartir el estado entre pantallas.'),
  Post(id: 6, titulo: 'Navegar con GoRouter', cuerpo: 'GoRouter usa URLs como /posts/1 para cada pantalla.'),
];

// Busca un post por id. Devuelve null si no existe.
Post? buscarPost(int id) {
  for (Post post in listaPosts) {
    if (post.id == id) {
      return post;
    }
  }
  return null;
}
