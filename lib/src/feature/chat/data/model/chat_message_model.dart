import 'package:azure_chat_bot/src/feature/chat/domain/entities/message.dart';

class ChatMessageModel extends Message {
  ChatMessageModel({
    required String id,
    required String text,
    required bool isUser,
    required DateTime timestamp,
  }) : super(
          id: id,
          text: text,
          isUser: isUser,
          timestamp: timestamp,
        );

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      isUser: json['isUser'] ?? false,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessageModel.fromMessage(Message message) {
    return ChatMessageModel(
      id: message.id,
      text: message.text,
      isUser: message.isUser,
      timestamp: message.timestamp,
    );
  }
}
