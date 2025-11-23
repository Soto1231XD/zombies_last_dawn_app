import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/models/comment_model.dart';

class CommentService {
  final SupabaseClient _supabase;

  CommentService(this._supabase);

  // Obtener comentarios - VERSIÓN ROBUSTA
  Future<List<CommentModel>> fetchComments(String postId) async {
    try {
      // Primero obtener todos los comentarios
      final commentsResponse = await _supabase
          .from('comments')
          .select()
          .eq('post_id', postId)
          .order('created_at', ascending: true);

      if (commentsResponse.isEmpty) {
        return [];
      }

      // Obtener información de autores
      final authorIds = commentsResponse.map((c) => c['author_id'] as String).toSet().toList();
      final profiles = await _getProfilesByIds(authorIds);

      // Combinar comentarios con información de autores
      final List<CommentModel> comments = [];
      for (final comment in commentsResponse) {
        final authorId = comment['author_id'] as String;
        final authorProfile = profiles[authorId];
        
        comments.add(CommentModel.fromJson({
          ...comment,
          'profiles': authorProfile
        }));
      }

      return comments;
    } catch (e) {
      print('Error fetching comments: $e');
      rethrow;
    }
  }

  // Obtener perfiles por IDs - CONSULTAS INDIVIDUALES
  Future<Map<String, Map<String, dynamic>>> _getProfilesByIds(List<String> userIds) async {
    if (userIds.isEmpty) return {};
    
    final Map<String, Map<String, dynamic>> profileMap = {};
    
    for (String userId in userIds) {
      try {
        final profile = await _supabase
            .from('profiles')
            .select('id, username, avatar_url')
            .eq('id', userId)
            .maybeSingle();
        
        if (profile != null) {
          profileMap[userId] = {
            'username': profile['username'] ?? 'Usuario',
            'avatar_url': profile['avatar_url']
          };
        } else {
          // Si no se encuentra, usar fallback
          profileMap[userId] = await _getUserFallbackProfile(userId);
        }
      } catch (e) {
        print('Error getting profile for user $userId: $e');
        profileMap[userId] = await _getUserFallbackProfile(userId);
      }
    }
    
    return profileMap;
  }

  // Obtener perfil de fallback para un usuario
  Future<Map<String, dynamic>> _getUserFallbackProfile(String userId) async {
    try {
      // Intentar obtener el email del usuario
      final userResponse = await _supabase.auth.admin.getUserById(userId);
      final user = userResponse.user;
      
      String username = 'Usuario';
      if (user?.email != null) {
        final emailPrefix = user!.email!.split('@')[0];
        username = _capitalize(emailPrefix);
      }
      
      return {
        'username': username,
        'avatar_url': null
      };
    } catch (e) {
      return {
        'username': 'Usuario',
        'avatar_url': null
      };
    }
  }

  // Agregar un comentario
  Future<CommentModel> addComment(String postId, String content) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Insertar comentario
      final commentResponse = await _supabase
          .from('comments')
          .insert({
            'post_id': postId,
            'author_id': user.id,
            'content': content,
          })
          .select()
          .single();

      // Obtener perfil del autor
      final authorProfile = await _getProfilesByIds([user.id]);
      
      return CommentModel.fromJson({
        ...commentResponse,
        'profiles': authorProfile[user.id] ?? {'username': 'Usuario', 'avatar_url': null}
      });
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }

  // Eliminar un comentario
  Future<void> deleteComment(String commentId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _supabase
          .from('comments')
          .delete()
          .eq('id', commentId)
          .eq('author_id', user.id);
    } catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}