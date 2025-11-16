// lib/services/chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/models/chat_message.dart';

class ChatService {
  final String baseUrl;

  ChatService({required this.baseUrl});

  Future<String> sendMessage(String message, {List<ChatMessage>? history}) async {
    try {
      print('🟡 Enviando mensaje a la API: $message');
      
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
          'history': history?.map((msg) => msg.toJson()).toList() ?? [],
        }),
      );

      print('🟢 Respuesta de la API: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final answer = data['answer'] ?? 'No response from AI';
        print('🟢 Respuesta del asistente: $answer');
        return answer;
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('🔴 Error en ChatService: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  // Método para verificar que la API esté funcionando
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      print('🔴 Health check failed: $e');
      return false;
    }
  }
}