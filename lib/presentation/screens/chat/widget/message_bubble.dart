import 'package:flutter/material.dart';
import '../../../../core/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              backgroundColor: Colors.greenAccent,
              radius: 16,
              child: Icon(
                Icons.smart_toy,
                color: Colors.black,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Colors.greenAccent
                    : const Color(0xFF2D3748),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: message.isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
              ),
              child: message.type == MessageType.loading
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.greenAccent,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Pensando...',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    )
                  : Text(
                      message.content,
                      style: TextStyle(
                        color: message.isUser ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 16,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}