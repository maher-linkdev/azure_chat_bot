import 'package:azure_chat_bot/src/core/usecase/usecase.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/entities/conversation.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/entities/message.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/usecases/initialize_conversation_usecase.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/usecases/send_message_usecase.dart';
import 'package:azure_chat_bot/src/feature/chat/presentation/provider/initialize_conversation_usecase_provider.dart';
import 'package:azure_chat_bot/src/feature/chat/presentation/provider/send_message_usecase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

enum ChatState {
  initial,
  loading,
  loaded,
  error,
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatProviderState>((ref) {
  final sendMessageUseCase = ref.watch(sendMessageUseCaseProvider);
  final initializeConversationUseCase = ref.watch(initializeConversationUseCaseProvider);

  return ChatNotifier(
    sendMessageUseCase: sendMessageUseCase,
    initializeConversationUseCase: initializeConversationUseCase,
  );
});

class ChatNotifier extends StateNotifier<ChatProviderState> {
  final SendMessageUseCase _sendMessageUseCase;
  final InitializeConversationUseCase _initializeConversationUseCase;
  final Uuid _uuid = const Uuid();

  ChatNotifier({
    required SendMessageUseCase sendMessageUseCase,
    required InitializeConversationUseCase initializeConversationUseCase,
  })  : _sendMessageUseCase = sendMessageUseCase,
        _initializeConversationUseCase = initializeConversationUseCase,
        super(const ChatProviderState(
          messages: [],
          chatState: ChatState.initial,
          conversation: null,
        ));

  Conversation? _conversation;

  Future<void> initializeConversation() async {
    state = state.copyWith(chatState: ChatState.loading);

    try {
      final newConversation = await _initializeConversationUseCase(NoParams());
      _conversation = newConversation;
      print("newConversation id is ${newConversation.conversationId}");

      state = state.copyWith(
        messages: [
          Message(
            id: _uuid.v4(),
            text: "Hello! I'm your Azure Chat Bot assistant. How can I help you today?",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ],
        chatState: ChatState.loaded,
        conversation: newConversation,
      );
    } catch (e) {
      state = state.copyWith(
        chatState: ChatState.error,
        error: e.toString(),
      );
    }
  }

  Future<void> sendMessage(String text, userId) async {
    if (_conversation?.conversationId == null) {
      state = state.copyWith(
        chatState: ChatState.error,
        error: "No Conversation",
      );

      // Add error message
      state = state.copyWith(
        messages: [
          ...state.messages,
          Message(
            id: _uuid.v4(),
            text: "Sorry, couldn't process your request. No associated conversation!",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ],
      );
      return;
    }
    final userMessage = Message(
      id: _uuid.v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final params = SendMessageParams(
      conversationId: _conversation!.conversationId,
      text: text,
      userId: userId,
      userName: "Maher-static-name",
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      chatState: ChatState.loading,
    );

    try {
      _sendMessageUseCase(params);

      state = state.copyWith(
        chatState: ChatState.loaded,
      );
    } catch (e) {
      state = state.copyWith(
        chatState: ChatState.error,
        error: e.toString(),
      );
      state = state.copyWith(
        messages: [
          ...state.messages,
          Message(
            id: _uuid.v4(),
            text: "Sorry, I couldn't process your request. Please try again later.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ],
      );
    }
  }

  void addBotMessage(Message message) {
    state = state.copyWith(
      messages: [...state.messages, message],
      chatState: ChatState.loaded,
    );
  }

  void clearMessages() {
    state = state.copyWith(
      messages: [],
      chatState: ChatState.initial,
      conversation: null,
    );
  }
}

class ChatProviderState {
  final List<Message> messages;
  final ChatState chatState;
  final String? error;
  final Conversation? conversation;

  const ChatProviderState({
    required this.messages,
    required this.chatState,
    this.error,
    this.conversation,
  });

  ChatProviderState copyWith({
    List<Message>? messages,
    ChatState? chatState,
    String? error,
    Conversation? conversation,
  }) {
    return ChatProviderState(
      messages: messages ?? this.messages,
      chatState: chatState ?? this.chatState,
      error: error ?? this.error,
      conversation: conversation ?? this.conversation,
    );
  }
}
