// lib/presentation/screens/chat/widget/message_bubble.dart
import 'package:flutter/material.dart';
import '../../../../core/models/chat_message.dart';

// misma paleta que en chat_screen
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

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  bool get _isError => message.type == MessageType.error;
  bool get _isLoading => message.type == MessageType.loading;

  @override
  Widget build(BuildContext context) {
    // Colores según tipo / emisor
    final bool isUser = message.isUser;

    Color bubbleColor;
    Color textColor;

    if (_isError) {
      bubbleColor = kDestructive.withOpacity(0.18);
      textColor = kDestructive;
    } else if (isUser) {
      bubbleColor = kAccent;
      textColor = kPrimaryForeground;
    } else {
      bubbleColor = kCard;
      textColor = kFg;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              backgroundColor: kAccent,
              radius: 16,
              child: Icon(
                Icons.smart_toy,
                color: kPrimaryForeground,
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
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft:
                      isUser ? const Radius.circular(20) : const Radius.circular(4),
                  bottomRight:
                      isUser ? const Radius.circular(4) : const Radius.circular(20),
                ),
                border: _isError
                    ? Border.all(color: kDestructive.withOpacity(0.6))
                    : Border.all(color: kBorder),
              ),
              child: _buildContent(textColor),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: kAccent,
              radius: 16,
              child: Icon(
                Icons.person,
                color: kPrimaryForeground,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    if (_isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: kAccent,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Pensando...',
            style: TextStyle(color: kMutedForeground),
          ),
        ],
      );
    }

    return Text(
      message.content,
      style: TextStyle(
        color: textColor,
        fontSize: 15,
        height: 1.4,
      ),
    );
  }
}
