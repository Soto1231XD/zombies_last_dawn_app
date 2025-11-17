import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/models/category_model.dart';
import '../core/models/post_model.dart';

class TableNames {
  static const String categories = 'categories';
  static const String posts = 'posts';
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

      final categories = (response as List<dynamic>)
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();

      return categories;
    } catch (e) {
      print('Error al obtener categorías: $e');
      rethrow;
    }
  }

  /// Obtiene todas las publicaciones con información de categoría
  Future<List<PostModel>> fetchAllPosts() async {
    try {
      final response = await _supabaseClient
          .from(TableNames.posts)
          .select('''
            *,
            categories!inner(name)
          ''')
          .order('created_at', ascending: false);

      final posts = (response as List<dynamic>)
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return posts;
    } catch (e) {
      print('Error al obtener publicaciones: $e');
      rethrow;
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
}