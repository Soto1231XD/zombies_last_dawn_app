import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/comment_model.dart';
import '../../../services/comment_service.dart';
import '../../../core/widgets/comment_card.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final CommentService _commentService = CommentService(Supabase.instance.client);
  final TextEditingController _commentController = TextEditingController();
  List<CommentModel> _comments = [];
  bool _isLoadingComments = true;
  bool _isSubmittingComment = false;

  // 👇 contador local que regresamos a la lista
  late int _commentCount;

  @override
  void initState() {
    super.initState();
    _commentCount = widget.post.commentCount; // valor inicial
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final comments = await _commentService.fetchComments(widget.post.id);
      setState(() {
        _comments = comments;
        _isLoadingComments = false;
        _commentCount = comments.length; // asegurar que coincida con la BD
      });
    } catch (e) {
      print('Error loading comments: $e');
      setState(() {
        _isLoadingComments = false;
      });
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isSubmittingComment = true;
    });

    try {
      final newComment = await _commentService.addComment(
        widget.post.id,
        _commentController.text.trim(),
      );
      setState(() {
        _comments.add(newComment);
        _commentController.clear();
        _commentCount++; // sumar al contador
      });
    } catch (e) {
      print('Error adding comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar comentario: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmittingComment = false;
      });
    }
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      await _commentService.deleteComment(commentId);
      setState(() {
        _comments.removeWhere((comment) => comment.id == commentId);
        if (_commentCount > 0) _commentCount--; // restar al contador
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comentario eliminado'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error deleting comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar comentario: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 👇 se llama cuando el usuario intenta salir (botón físico / gesto back)
  Future<bool> _onWillPop() async {
    Navigator.pop<int>(context, _commentCount);
    return false; // ya manejamos el pop manualmente
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFF0b1220),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Comentarios',
            style: TextStyle(
              color: Color(0xFF22d3ee),
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF22d3ee)),
            onPressed: () {
              Navigator.pop<int>(context, _commentCount);
            },
          ),
        ),
        body: Column(
          children: [
            // Header del post
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1e293b),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22d3ee).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.post.content,
                    style: const TextStyle(
                      color: Color(0xFF94a3b8),
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Lista de comentarios
            Expanded(
              child: _isLoadingComments
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF22d3ee),
                      ),
                    )
                  : _comments.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: Color(0xFFA8B3C7),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No hay comentarios aún',
                                style: TextStyle(
                                  color: Color(0xFFA8B3C7),
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Sé el primero en comentar',
                                style: TextStyle(
                                  color: Color(0xFF94a3b8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _comments.length,
                          itemBuilder: (context, index) {
                            final comment = _comments[index];
                            return CommentCard(
                              comment: comment,
                              onDelete: () => _deleteComment(comment.id),
                            );
                          },
                        ),
            ),

            // Input para nuevo comentario
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1e293b),
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF334155),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Escribe un comentario...',
                        hintStyle: const TextStyle(color: Color(0xFF94a3b8)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0b1220),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _isSubmittingComment
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFF22d3ee),
                            strokeWidth: 2,
                          ),
                        )
                      : IconButton(
                          onPressed: _addComment,
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFF22d3ee),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
