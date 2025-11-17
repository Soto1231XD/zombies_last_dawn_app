// lib/core/models/chat_message.dart
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
  });

  // Constructor para crear desde JSON de la API
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: json['content'],
      isUser: json['role'] == 'user', // Mapea 'role' a isUser
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
    );
  }

  // Para enviar a tu API - usa el formato que espera tu backend
  Map<String, dynamic> toJson() {
    return {
      'role': isUser ? 'user' : 'assistant', // Formato que espera tu API
      'content': content,
      // 'timestamp' y 'id' son opcionales para el historial
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp.toIso8601String(),
    };
  }

  // Para mostrar en la UI
  Map<String, dynamic> toUiJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
    };
  }
}

enum MessageType {
  text,
  loading,
  error,
}