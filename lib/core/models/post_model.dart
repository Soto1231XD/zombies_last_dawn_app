class PostModel {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String categoryId;
  final String? categoryName;
  final String status;
  final DateTime createdAt;
  final int commentCount;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.categoryId,
    this.categoryName,
    required this.status,
    required this.createdAt,
    this.commentCount = 0,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['author_id'] as String,
      categoryId: json['category'] as String,
      categoryName: json['categories'] != null
          ? (json['categories'] as Map<String, dynamic>)['name'] as String
          : null,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      commentCount: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'author_id': authorId,
      'category': categoryId,
      'status': status,
    };
  }
  
  // Método copyWith para actualizar el commentCount
  PostModel copyWith({
    int? commentCount,
  }) {
    return PostModel(
      id: id,
      title: title,
      content: content,
      authorId: authorId,
      categoryId: categoryId,
      categoryName: categoryName,
      status: status,
      createdAt: createdAt,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}