// data/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/post.dart';

class ApiService {
  static const String _base = 'https://jsonplaceholder.typicode.com';

  // GET /posts — trae todos los posts
  Future<List<Post>> getPosts() async {
    final http.Response response;
    try {
      response = await http.get(Uri.parse('$_base/posts'));
    } catch (e) {
      // Si no hay internet o la URL está mal, llegamos acá
      throw Exception('Error de conexión: $e');
    }

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }
}
