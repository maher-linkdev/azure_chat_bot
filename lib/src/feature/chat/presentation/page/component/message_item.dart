import 'package:azure_chat_bot/src/feature/chat/domain/entities/message.dart';
import 'package:azure_chat_bot/src/feature/chat/presentation/page/component/message_item_avatar.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) MessageItemAvatar(isUser: message.isUser),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? Theme.of(context).colorScheme.primary : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (message.isUser) MessageItemAvatar(isUser: message.isUser),
        ],
      ),
    );
  }
}
