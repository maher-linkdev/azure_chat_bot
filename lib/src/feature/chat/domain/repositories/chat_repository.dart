import 'package:azure_chat_bot/src/feature/chat/domain/entities/conversation.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/usecases/send_message_usecase.dart';

abstract class ChatRepository {
  Future<String> sendMessage(SendMessageParams message);

  Future<Conversation> initializeConversation();
}
