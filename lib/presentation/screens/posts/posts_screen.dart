import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/widgets/post_card.dart';
import '../../../data/dummy_data/sample_posts.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Últimas Publicaciones',
          style: TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // acción para crear nueva publicación
        },
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: samplePosts.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: samplePosts.length,
              itemBuilder: (context, index) {
                final post = samplePosts[index];
                return PostCard(post: post)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: (index * 100).ms)
                    .slide(begin: const Offset(0, 0.2));
              },
            ),
    );
  }

  // 🔹 Vista cuando no hay publicaciones
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
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
