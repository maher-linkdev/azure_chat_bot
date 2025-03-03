import 'dart:convert';

import 'package:azure_chat_bot/src/feature/chat/domain/entities/message.dart';
import 'package:azure_chat_bot/src/feature/chat/presentation/page/component/chat_initial_view.dart';
import 'package:azure_chat_bot/src/feature/chat/presentation/page/component/message_input.dart';
import 'package:azure_chat_bot/src/feature/chat/presentation/page/component/message_item.dart';
import 'package:azure_chat_bot/src/feature/chat/presentation/provider/chat_conversation_provider.dart';
import 'package:azure_chat_bot/src/feature/chat/presentation/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final meUserId = "6963";
  final TextEditingController _messageController = TextEditingController();
  WebSocketChannel? _webSocketChannel;

  bool _isWebSocketConnected = false;

  @override
  void initState() {
    super.initState();
  }

  void _connectToWebSocket(String streamUrl) {
    try {
      print('Connecting to WebSocket: $streamUrl');
      _webSocketChannel = WebSocketChannel.connect(Uri.parse(streamUrl));
      _webSocketChannel!.stream.listen(
        (dynamic message) {
          print("message is $message");
          if (message != null && message != '') {
            final Map<String, dynamic> data = jsonDecode(message);
            print("data from websocket is $data");
            print(
                "the coming id ${data['activities'][0]['from']['id']}, ${data['activities'][0]['from']['id'] != meUserId}");
            if (data['activities'][0]['from']['id'] != meUserId) {
              final botMessage = Message(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                text: data['activities'][0]['text'] ?? 'No message content',
                isUser: false,
                timestamp: DateTime.now(),
              );
              ref.read(chatProvider.notifier).addBotMessage(botMessage);
            }
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
        onDone: () {
          print('WebSocket connection closed');
          final conversation = ref.read(chatConversationProvider);
          if (conversation != null) {
            _connectToWebSocket(conversation.streamUrl);
          }
        },
      );

      _isWebSocketConnected = true;
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      _isWebSocketConnected = false;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _webSocketChannel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversation = ref.read(chatConversationProvider);
    final chatState = ref.watch(chatProvider.select((value) => value.chatState));
    final messages = ref.watch(chatProvider.select((value) => value.messages));
    final isLoading = chatState == ChatState.loading;
    if (conversation != null && _webSocketChannel == null) {
      _connectToWebSocket(conversation.streamUrl);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Bot'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const ChatInitialView()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      return MessageItem(message: messages[index]);
                    },
                  ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          MessageInput(controller: _messageController, meUserId: meUserId),
        ],
      ),
    );
  }
}
