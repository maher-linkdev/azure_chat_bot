import 'package:azure_chat_bot/src/feature/chat/domain/usecases/send_message_usecase.dart';
import 'package:azure_chat_bot/src/feature/chat/presentation/provider/chat_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SendMessageUseCase(repository);
});
