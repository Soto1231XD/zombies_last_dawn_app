// lib/presentation/screens/chat/chat_screen.dart
import 'package:flutter/material.dart';
import '../../../../services/chat_service.dart';
import '../../../../core/models/chat_message.dart';
import 'widget/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService(
    // baseUrl: 'http://10.0.2.2:8000', // Para Android emulator
    // baseUrl: 'http://localhost:8000', // Para iOS simulator
    baseUrl: 'http://192.168.0.104:8000', // Para dispositivo físico
  );

  bool _isLoading = false;
  bool _apiConnected = false;

  @override
  void initState() {
    super.initState();
    _checkApiConnection();
    // Mensaje de bienvenida
    _addMessage(
      '¡Hola! Soy tu asistente de Zombies: Last Dawn. ¿En qué puedo ayudarte sobre el juego?',
      isUser: false,
    );
  }

  Future<void> _checkApiConnection() async {
    final connected = await _chatService.checkHealth();
    setState(() {
      _apiConnected = connected;
    });
    
    if (!connected) {
      _addMessage(
        ' No puedo conectarme con el servidor. Asegúrate de que tu RAG_API esté ejecutándose en el puerto 8000.',
        isUser: false,
        type: MessageType.error,
      );
    }
  }

  void _addMessage(String content, {bool isUser = true, MessageType type = MessageType.text}) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: isUser,
      timestamp: DateTime.now(),
      type: type,
    );

    setState(() {
      _messages.add(message);
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading || !_apiConnected) return;

    _messageController.clear();
    _addMessage(message);

    setState(() {
      _isLoading = true;
    });

    // Agregar mensaje de carga
    final loadingMessage = ChatMessage(
      id: 'loading-${DateTime.now().millisecondsSinceEpoch}',
      content: 'Buscando en la información del juego...',
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.loading,
    );

    setState(() {
      _messages.add(loadingMessage);
    });

    try {
      // Preparar historial excluyendo el mensaje de carga actual
      final history = _messages
          .where((msg) => msg.type != MessageType.loading && msg.id != loadingMessage.id)
          .map((msg) => ChatMessage(
                id: msg.id,
                content: msg.content,
                isUser: msg.isUser,
                timestamp: msg.timestamp,
              ))
          .toList();

      final response = await _chatService.sendMessage(
        message, 
        history: history,
      );
      
      // Remover mensaje de loading y agregar respuesta
      setState(() {
        _messages.removeWhere((msg) => msg.id == loadingMessage.id);
        _addMessage(response, isUser: false);
      });
    } catch (e) {
      // Remover mensaje de loading y agregar error
      setState(() {
        _messages.removeWhere((msg) => msg.id == loadingMessage.id);
        _addMessage(
          ' Error al conectar con el asistente: $e\n\nAsegúrate de que:\n• Tu RAG_API esté ejecutándose\n• La URL sea correcta\n• El puerto 8000 esté disponible',
          isUser: false,
          type: MessageType.error,
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Asistente del juego',
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              _apiConnected ? Icons.check_circle : Icons.error,
              color: _apiConnected ? Colors.greenAccent : Colors.orange,
              size: 16,
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.greenAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Banner de estado de conexión
          if (!_apiConnected)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.orange.withOpacity(0.2),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'API no conectada - Ejecuta: uvicorn app:app --reload --port 8000',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.orange, size: 16),
                    onPressed: _checkApiConnection,
                  ),
                ],
              ),
            ),
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book,
                          size: 80,
                          color: Colors.greenAccent,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Asistente del juego',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Pregunta sobre armas, misiones, zombies...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: _messages[index]);
                    },
                  ),
          ),
          // Input de mensaje
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1A1F29),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Pregunta sobre el juego...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: _apiConnected 
                          ? const Color(0xFF2D3748) 
                          : Colors.grey.shade800,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    enabled: _apiConnected && !_isLoading,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: _apiConnected && !_isLoading
                      ? Colors.greenAccent
                      : Colors.grey,
                  child: IconButton(
                    icon: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          )
                        : const Icon(Icons.send, color: Colors.black),
                    onPressed: _apiConnected && !_isLoading ? _sendMessage : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}