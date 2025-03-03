import 'package:azure_chat_bot/src/feature/chat/domain/entities/conversation.dart';

class ChatConversationModel extends Conversation {
  final String conversationId;
  final String token;
  final int expiresIn;
  final String streamUrl;

  ChatConversationModel({
    required this.conversationId,
    required this.token,
    required this.expiresIn,
    required this.streamUrl,
  }) : super(
          conversationId: conversationId,
          token: token,
          expiresIn: expiresIn,
          streamUrl: streamUrl,
        );

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      conversationId: json['conversationId'] as String,
      token: json['token'] as String,
      expiresIn: json['expires_in'] as int,
      streamUrl: json['streamUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'token': token,
      'expires_in': expiresIn,
      'streamUrl': streamUrl,
    };
  }
}
