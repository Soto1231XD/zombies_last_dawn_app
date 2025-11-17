import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/widgets/post_card.dart';
import '../../../core/models/post_model.dart';

class PostsContent extends StatelessWidget {
  final List<PostModel> posts;

  const PostsContent({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0b1220), // bg
      child: posts.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              physics: const BouncingScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22d3ee).withOpacity(0.10), // accent suave
                        blurRadius: 18,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: PostCard(post: post),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: (index * 90).ms)
                    .slide(begin: const Offset(0, 0.15));
              },
            ),
    );
  }

  // ESTADO VACÍO
  static Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: const Color(0xFFA8B3C7), // muted-foreground
            highlightColor: const Color(0xFF22d3ee), // accent
            child: const Icon(Icons.forum, size: 90, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Aún no hay publicaciones...',
            style: TextStyle(
              color: Color(0xFFA8B3C7), // muted-foreground
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sé el primero en compartir algo sobre el apocalipsis 🧟‍♂️',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF94a3b8), // muted
              fontSize: 14,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
