import 'package:azure_chat_bot/src/feature/chat/domain/entities/conversation.dart';
import 'package:azure_chat_bot/src/feature/chat/presentation/provider/chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatConversationProvider = Provider<Conversation?>((ref) {
  return ref
      .watch(chatProvider)
      .conversation;
});
