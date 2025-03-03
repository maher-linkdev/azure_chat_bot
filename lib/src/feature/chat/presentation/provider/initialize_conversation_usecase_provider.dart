import 'package:azure_chat_bot/src/feature/chat/domain/usecases/initialize_conversation_usecase.dart';
import 'package:azure_chat_bot/src/feature/chat/presentation/provider/chat_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initializeConversationUseCaseProvider = Provider<InitializeConversationUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return InitializeConversationUseCase(repository);
});
