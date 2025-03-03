import 'package:flutter/material.dart';

class MessageItemAvatar extends StatelessWidget {
  final bool isUser;

  const MessageItemAvatar({super.key, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: isUser ? Colors.blue[700] : Colors.grey[300],
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        size: 20,
        color: isUser ? Colors.white : Colors.grey[700],
      ),
    );
  }
}
