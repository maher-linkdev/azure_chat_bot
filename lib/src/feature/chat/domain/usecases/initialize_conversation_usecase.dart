import 'package:azure_chat_bot/src/core/usecase/usecase.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/entities/conversation.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/repositories/chat_repository.dart';

class InitializeConversationUseCase implements UseCase<Conversation, NoParams> {
  final ChatRepository repository;

  InitializeConversationUseCase(this.repository);

  @override
  Future<Conversation> call(NoParams params) {
    return repository.initializeConversation();
  }
}
