import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';

class SupabaseService {
  // Singleton
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  /// Inicializa Supabase usando las variables del .env
  Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
  }

  SupabaseClient get client => Supabase.instance.client;

  // ---------------- AUTH ----------------

  Future<AuthResponse> signUp(String email, String password) async {
    final authResponse = await client.auth.signUp(
      email: email,
      password: password,
    );

    if (authResponse.user != null) {
      await createUserProfile(authResponse.user!);
    }

    return authResponse;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  // ---------------- PERFIL / ROLES ----------------

  Future<void> createUserProfile(User user) async {
    final username = user.email?.split('@').first ?? 'user';

    await client.from('profiles').upsert({
      'id': user.id,
      'username': username,
      'role': 'user', // rol por defecto
    });
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final response = await client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return response;
  }

  Future<String> getUserRole() async {
    final profile = await getUserProfile();
    return profile?['role'] ?? 'user';
  }

  Future<bool> isAdmin() async {
    final role = await getUserRole();
    return role == 'admin';
  }

  // ---------------- POSTS ----------------

  Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await client
        .from('posts')
        .select('*, profiles(username)')
        .order('created_at', ascending: false);

    return response;
  }

  Future<Map<String, dynamic>> createPost({
    required String title,
    required String content,
    required String category,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final response = await client
        .from('posts')
        .insert({
          'title': title,
          'content': content,
          'author_id': user.id,
          'category': category,
          'status': 'published',
        })
        .select('*, profiles(username)')
        .single();

    return response;
  }

  Future<void> deletePost(String postId) async {
    await client.from('posts').delete().eq('id', postId);
  }

  // ---------------- ADMIN / STATS ----------------

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    if (!await isAdmin()) {
      throw Exception('No tienes permisos de administrador');
    }

    final response = await client
        .from('profiles')
        .select('*')
        .order('created_at', ascending: false);

    return response;
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    if (!await isAdmin()) {
      throw Exception('No tienes permisos de administrador');
    }

    await client
        .from('profiles')
        .update({'role': newRole})
        .eq('id', userId);
  }

  Future<Map<String, dynamic>> getAdminStats() async {
    if (!await isAdmin()) {
      throw Exception('No tienes permisos de administrador');
    }

    try {
      final profiles = await client.from('profiles').select();
      final posts = await client.from('posts').select();

      final totalUsers = profiles.length;
      final totalAdmins =
          profiles.where((p) => p['role'] == 'admin').length;
      final totalPosts = posts.length;

      // Placeholder: podrías calcular activos por fecha
      final activeToday = totalUsers;

      return {
        'totalUsers': totalUsers,
        'totalAdmins': totalAdmins,
        'totalPosts': totalPosts,
        'activeToday': activeToday,
      };
    } catch (e) {
      print('Error getting admin stats: $e');
      return {
        'totalUsers': 0,
        'totalAdmins': 0,
        'totalPosts': 0,
        'activeToday': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsersDetailed() async {
    if (!await isAdmin()) {
      throw Exception('No tienes permisos de administrador');
    }

    final response = await client
        .from('profiles')
        .select('*')
        .order('created_at', ascending: false);

    return response;
  }

  Future<List<Map<String, dynamic>>> getPostsWithAuthors() async {
    final response = await client
        .from('posts')
        .select('*, profiles(username)')
        .order('created_at', ascending: false);

    return response;
  }

  Future<void> updateProfileAvatar(String avatarUrl) async {
    final user = currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    await client
        .from('profiles')
        .update({'avatar_url': avatarUrl})
        .eq('id', user.id);
  }
}
