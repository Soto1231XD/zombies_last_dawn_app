import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/widgets/post_card.dart';
import '../../../core/models/post_model.dart'; // Importar desde core/models

// Temporalmente comentamos samplePosts hasta que lo migres
// import '../../../data/dummy_data/sample_posts.dart';

class PostsContent extends StatelessWidget {
  final List<PostModel> posts; // Recibir posts como parámetro

  const PostsContent({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B0F16),
      child: posts.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(post: post)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: (index * 100).ms)
                    .slide(begin: const Offset(0, 0.2));
              },
            ),
    );
  }

  // Vista cuando no hay publicaciones
  static Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.white24,
            highlightColor: Colors.greenAccent.withOpacity(0.5),
            child: const Icon(Icons.forum, size: 90, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Aún no hay publicaciones...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sé el primero en compartir algo sobre el apocalipsis 🧟‍♂️',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }
}