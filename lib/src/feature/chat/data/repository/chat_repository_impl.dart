import 'dart:convert';

import 'package:azure_chat_bot/src/core/constants/api_constants.dart';
import 'package:azure_chat_bot/src/core/constants/environment_variables.dart';
import 'package:azure_chat_bot/src/feature/chat/data/model/chat_conversation_model.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/entities/conversation.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/repositories/chat_repository.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/usecases/send_message_usecase.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ChatRepositoryImpl implements ChatRepository {
  final http.Client client;
  final Uuid uuid;

  ChatRepositoryImpl({
    required this.client,
    required this.uuid,
  });

  @override
  Future<Conversation> initializeConversation() async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/v3/directline/conversations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${EnvironmentVariables.apiKey}',
        },
      );
      Map<String, dynamic> jsonMap = jsonDecode(response.body);

      ChatConversationModel conversation = ChatConversationModel.fromJson(jsonMap);
      return conversation;
    } catch (e) {
      throw Exception('Failed to initialize conversation: $e');
    }
  }

  @override
  Future<String> sendMessage(SendMessageParams params) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/v3/directline/conversations/${params.conversationId}/activities'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${EnvironmentVariables.apiKey}',
        },
        body: jsonEncode({
          "type": "message",
          "from": {"id": params.userId, "name": params.userName},
          "text": params.text,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['id'];
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
