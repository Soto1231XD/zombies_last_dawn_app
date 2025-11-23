import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/category_model.dart';
import '../../../core/widgets/post_card.dart';
import '../../../services/post_service.dart';

class CategoryPostsScreen extends StatefulWidget {
  final Category category;

  const CategoryPostsScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryPostsScreen> createState() => _CategoryPostsScreenState();
}

class _CategoryPostsScreenState extends State<CategoryPostsScreen> {
  late final PostService _postService;
  List<PostModel> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _postService = PostService(Supabase.instance.client);
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await _postService.fetchPostsByCategory(widget.category.id);
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading category posts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b1220),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.category.name,
          style: TextStyle(
            color: widget.category.color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF22d3ee),
              ),
            )
          : _posts.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadPosts,
                  backgroundColor: const Color(0xFF0b1220),
                  color: widget.category.color,
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
                              color:
                                  widget.category.color.withOpacity(0.12),
                              blurRadius: 18,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: PostCard(
                          post: post,
                          // 👇 mantenemos el contador de comentarios en sincronía
                          onCommentCountChanged: (newCount) {
                            setState(() {
                              _posts[index] = _posts[index].copyWith(
                                commentCount: newCount,
                              );
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 80,
            color: widget.category.color.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay publicaciones en esta categoría todavía',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFA8B3C7),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sé el primero en compartir algo aquí 🧟‍♂️',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF94a3b8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
