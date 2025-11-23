import 'package:flutter/material.dart';
import '../../core/models/post_model.dart';
import '../../core/models/category_model.dart';
import '../../presentation/screens/posts/post_detail_screen.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  // 👇 callback opcional para avisar cuando cambie el número de comentarios
  final ValueChanged<int>? onCommentCountChanged;

  const PostCard({
    super.key,
    required this.post,
    this.onCommentCountChanged,
  });

  Category? _getCategoryInfo() {
    return Category(
      id: post.categoryId,
      name: post.categoryName ?? 'General',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  void _navigateToPostDetail(BuildContext context) async {
    final updatedCount = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: post),
      ),
    );

    if (updatedCount != null && onCommentCountChanged != null) {
      onCommentCountChanged!(updatedCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = _getCategoryInfo();

    return GestureDetector(
      onTap: () => _navigateToPostDetail(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F29),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⭐ CATEGORÍA
                if (category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: category.color.withOpacity(0.50),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category.icon,
                          size: 16,
                          color: category.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category.name,
                          style: TextStyle(
                            color: category.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // ⭐ TÍTULO
                Text(
                  post.title,
                  style: const TextStyle(
                    color: Color(0xFFA8B3C7),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // ⭐ CONTENIDO
                Text(
                  post.content,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.45,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 18),

                // ⭐ FOOTER
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.white54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(post.createdAt),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),

                    const Spacer(),

                    const Icon(
                      Icons.comment,
                      size: 15,
                      color: Colors.white54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post.commentCount.toString(),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Ahora mismo';
    }
  }
}
