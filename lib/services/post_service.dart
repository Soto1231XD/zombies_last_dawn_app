import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/models/category_model.dart';
import '../core/models/post_model.dart';

class TableNames {
  static const String categories = 'categories';
  static const String posts = 'posts';
  static const String comments = 'comments';
}

class PostService {
  final SupabaseClient _supabaseClient;

  PostService(this._supabaseClient);

  /// Obtiene todas las categorías
  Future<List<Category>> fetchAllCategories() async {
    try {
      final response = await _supabaseClient
          .from(TableNames.categories)
          .select()
          .order('name');

      final categories = response
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();

      return categories;
    } catch (e) {
      print('Error al obtener categorías: $e');
      rethrow;
    }
  }

  /// Obtiene todas las publicaciones con información de categoría y conteo de comentarios
 Future<List<PostModel>> fetchAllPosts() async {
  try {
    final response = await _supabaseClient
        .from(TableNames.posts)
        .select('''
          *,
          categories!inner(name),
          comments(count)
        ''')
        .order('created_at', ascending: false);

    final posts = response.map((json) {
      // ⭐ Extraer correctamente el count
      final commentCount = json['comments'] != null &&
              json['comments'].isNotEmpty &&
              json['comments'][0]['count'] != null
          ? json['comments'][0]['count'] as int
          : 0;

      return PostModel.fromJson(json as Map<String, dynamic>)
          .copyWith(commentCount: commentCount);
    }).toList();

    return posts;
  } catch (e) {
    print('Error al obtener publicaciones: $e');
    rethrow;
  }
}


  Future<bool> isUsernameAvailable(String username) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('username', username)
          .maybeSingle();

      return response == null;
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }

  /// Crea una nueva publicación
  Future<PostModel> createPost({
    required String title,
    required String content,
    required String categoryId,
    required String authorId,
  }) async {
    try {
      final newPostData = {
        'title': title,
        'content': content,
        'author_id': authorId,
        'category': categoryId,
        'status': 'published',
      };

      final response = await _supabaseClient
          .from(TableNames.posts)
          .insert(newPostData)
          .select('''
            *,
            categories!inner(name)
          ''')
          .single();

      final post = PostModel.fromJson(response as Map<String, dynamic>);
      return post;
    } catch (e) {
      print('Error al crear publicación: $e');
      rethrow;
    }
  }

  // dentro de PostService

Future<List<PostModel>> fetchPostsByCategory(String categoryId) async {
  try {
    final response = await _supabaseClient
        .from(TableNames.posts)
        .select('''
          *,
          categories!inner(name),
          comments(count)
        ''')
        .eq('category', categoryId) // 👈 filtra por categoría
        .order('created_at', ascending: false);

    final posts = response.map((json) {
      // 👇 mismo truco del count de comentarios
      final commentCount = json['comments'] != null &&
              (json['comments'] as List).isNotEmpty &&
              (json['comments'][0]['count'] != null)
          ? json['comments'][0]['count'] as int
          : 0;

      return PostModel.fromJson(json as Map<String, dynamic>)
          .copyWith(commentCount: commentCount);
    }).toList();

    return posts;
  } catch (e) {
    print('Error al obtener publicaciones por categoría: $e');
    rethrow;
  }
}

}