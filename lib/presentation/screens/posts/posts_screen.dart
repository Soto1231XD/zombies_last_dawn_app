import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/widgets/post_card.dart';
import '../../../services/post_service.dart';
import 'create_post_screen.dart';
import '../../../core/models/post_model.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostService _postService = PostService(Supabase.instance.client);
  List<PostModel> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await _postService.fetchAllPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToCreatePost() async {
    try {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CreatePostScreen()),
      );

      if (result == true) {
        _loadPosts();
      }
    } catch (e) {
      print('Error en navegación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b1220), // bg

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Últimas Publicaciones',
          style: TextStyle(
            color: Color(0xFF22d3ee), // accent
            fontWeight: FontWeight.bold,
            fontSize: 21,
            letterSpacing: 0.6,
          ),
        ),
      ),

      // BOTÓN FLOTANTE
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePost,
        backgroundColor: const Color(0xFF22d3ee), // accent
        elevation: 6,
        child: const Icon(Icons.add, color: Color(0xFF001116)), // primary-foreground
      ),

      // CONTENIDO
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF22d3ee), // accent
              ),
            )
          : _posts.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadPosts,
                  backgroundColor: const Color(0xFF0b1220),
                  color: const Color(0xFF22d3ee),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF22d3ee).withOpacity(0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: PostCard(post: post),
                      );
                    },
                  ),
                ),
    );
  }

  // ESTADO VACÍO
  static Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum,
            size: 90,
            color: Color(0xFFA8B3C7),
          ),
          const SizedBox(height: 20),
          const Text(
            'Aún no hay publicaciones...',
            style: TextStyle(
              color: Color(0xFFA8B3C7),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sé el primero en compartir algo sobre el apocalipsis 🧟‍♂️',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF94a3b8),
              fontSize: 14,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
