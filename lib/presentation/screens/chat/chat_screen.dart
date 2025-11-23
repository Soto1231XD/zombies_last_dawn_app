import 'package:flutter/material.dart';
import '../../../../services/chat_service.dart';
import '../../../../core/models/chat_message.dart';
import 'widget/message_bubble.dart';

// PALETA (igual que tu globals.css)
const Color kBg = Color(0xFF0B1220);
const Color kFg = Color(0xFFE5E7EB);
const Color kAccent = Color(0xFF22D3EE);
const Color kWarn = Color(0xFFF59E0B);
const Color kMuted = Color(0xFF94A3B8);
const Color kCard = Color(0xFF121A2B);

const Color kPrimaryForeground = Color(0xFF001116);
const Color kSecondary = Color(0xFF0E1626);
const Color kMutedForeground = Color(0xFFA8B3C7);
const Color kDestructive = Color(0xFFEF4444);
const Color kBorder = Color.fromRGBO(255, 255, 255, 0.12);
const Color kInput = Color.fromRGBO(255, 255, 255, 0.15);

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  // AHORA sin URL hardcodeada: se toma de EnvConfig.ragApiBaseUrl
  final ChatService _chatService = ChatService();

  bool _isLoading = false;
  bool _apiConnected = false;

  @override
  void initState() {
    super.initState();
    _checkApiConnection();
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

  void _addMessage(
    String content, {
    bool isUser = true,
    MessageType type = MessageType.text,
  }) {
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

    // Mensaje de carga
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
      final history = _messages
          .where((msg) =>
              msg.type != MessageType.loading &&
              msg.id != loadingMessage.id)
          .map(
            (msg) => ChatMessage(
              id: msg.id,
              content: msg.content,
              isUser: msg.isUser,
              timestamp: msg.timestamp,
              type: msg.type,
            ),
          )
          .toList();

      final response = await _chatService.sendMessage(
        message,
        history: history,
      );

      setState(() {
        _messages.removeWhere((msg) => msg.id == loadingMessage.id);
        _addMessage(response, isUser: false);
      });
    } catch (e) {
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
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Asistente del juego',
              style: TextStyle(
                color: kAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              _apiConnected ? Icons.check_circle : Icons.error,
              color: _apiConnected ? kAccent : kWarn,
              size: 16,
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          if (!_apiConnected)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: kWarn.withOpacity(0.12),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: kWarn, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'API no conectada - Ejecuta: uvicorn app:app --reload --port 8000',
                      style: TextStyle(
                        color: kWarn,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: kWarn, size: 16),
                    onPressed: _checkApiConnection,
                  ),
                ],
              ),
            ),
          Expanded(
            child: _messages.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: _messages[index]);
                    },
                  ),
          ),
          _InputBar(
            controller: _messageController,
            isLoading: _isLoading,
            apiConnected: _apiConnected,
            onSend: _sendMessage,
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

// -------------- SUBWIDGETS --------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book,
            size: 80,
            color: kAccent,
          ),
          SizedBox(height: 16),
          Text(
            'Asistente del juego',
            style: TextStyle(
              color: kFg,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pregunta sobre armas, misiones, zombies...',
            style: TextStyle(
              color: kMutedForeground,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final bool apiConnected;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.isLoading,
    required this.apiConnected,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = apiConnected && !isLoading;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: kSecondary,
        border: Border(
          top: BorderSide(color: kBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: kFg),
              decoration: InputDecoration(
                hintText: 'Pregunta sobre el juego...',
                hintStyle: const TextStyle(color: kMutedForeground),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: enabled
                    ? kInput.withOpacity(0.4)
                    : Colors.black.withOpacity(0.3),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => onSend(),
              enabled: enabled,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 24,
            backgroundColor:
                enabled ? kAccent : Colors.grey.withOpacity(0.6),
            child: IconButton(
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: kPrimaryForeground,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send, color: kPrimaryForeground),
              onPressed: enabled ? onSend : null,
            ),
          ),
        ],
      ),
    );
  }
}
