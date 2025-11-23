class CommentModel {
  final String id;
  final String postId;
  final String authorId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String authorUsername;
  final String? authorAvatarUrl;

  CommentModel({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.authorUsername,
    this.authorAvatarUrl,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    // Manejar diferentes formatos de respuesta
    String username = 'Usuario';
    String? avatarUrl;

    if (json['profiles'] != null) {
      final profilesData = json['profiles'];
      if (profilesData is Map<String, dynamic>) {
        username = profilesData['username'] as String? ?? 'Usuario';
        avatarUrl = profilesData['avatar_url'] as String?;
      }
    }

    return CommentModel(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      authorId: json['author_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      authorUsername: username,
      authorAvatarUrl: avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'author_id': authorId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}