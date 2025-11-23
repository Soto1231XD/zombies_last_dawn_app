import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _supabase;

  ProfileService(this._supabase);

  // Obtener el perfil del usuario actual
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return response;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Obtener perfil por ID
  Future<Map<String, dynamic>?> getProfileById(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return response;
    } catch (e) {
      print('Error fetching profile by ID: $e');
      return null;
    }
  }

  // Actualizar el perfil del usuario
  Future<void> updateProfile({
    required String username,
    String? avatarUrl,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      await _supabase
          .from('profiles')
          .update({
            'username': username,
            'avatar_url': avatarUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Verificar si un username está disponible
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final response = await _supabase
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
}