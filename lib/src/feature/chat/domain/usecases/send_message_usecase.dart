import 'package:azure_chat_bot/src/core/usecase/usecase.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/repositories/chat_repository.dart';

class SendMessageUseCase implements UseCase<String, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<String> call(SendMessageParams params) {
    return repository.sendMessage(params);
  }
}

class SendMessageParams {
  final String conversationId;
  final String userName;
  final String userId;
  final String text;

  SendMessageParams({required this.conversationId, required this.userId, required this.text, required this.userName});
}
