import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback onDelete;

  const CommentCard({
    super.key,
    required this.comment,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final isAuthor = currentUser?.id == comment.authorId;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1e293b),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del comentario
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF22d3ee),
                child: Text(
                  comment.authorUsername?[0].toUpperCase() ?? 'U',
                  style: TextStyle(
                    color: Color(0xFF001116),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  comment.authorUsername ?? 'Usuario',
                  style: TextStyle(
                    color: Color(0xFF22d3ee),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if (isAuthor)
                IconButton(
                  icon: Icon(Icons.delete, size: 18),
                  color: Color(0xFFef4444),
                  onPressed: () {
                    _showDeleteDialog(context);
                  },
                ),
            ],
          ),
          SizedBox(height: 8),
          
          // Contenido del comentario
          Text(
            comment.content,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          
          // Fecha
          Text(
            _formatDate(comment.createdAt),
            style: TextStyle(
              color: Color(0xFF94a3b8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1e293b),
        title: Text(
          'Eliminar comentario',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar este comentario?',
          style: TextStyle(color: Color(0xFF94a3b8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar', style: TextStyle(color: Color(0xFF22d3ee))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            child: Text('Eliminar', style: TextStyle(color: Color(0xFFef4444))),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Ahora mismo';
    if (difference.inMinutes < 60) return 'Hace ${difference.inMinutes} min';
    if (difference.inHours < 24) return 'Hace ${difference.inHours} h';
    if (difference.inDays < 7) return 'Hace ${difference.inDays} d';
    
    return '${date.day}/${date.month}/${date.year}';
  }
}