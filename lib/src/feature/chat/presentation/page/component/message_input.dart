import 'package:azure_chat_bot/src/feature/chat/presentation/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageInput extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String meUserId;

  const MessageInput({super.key, required this.controller, required this.meUserId});

  @override
  ConsumerState<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends ConsumerState<MessageInput> {
  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider.select((value) => value.chatState));
    final isLoading = chatState == ChatState.loading;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(isLoading ? Icons.hourglass_top : Icons.send_rounded),
                color: Colors.white,
                onPressed: isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (widget.controller.text.trim().isEmpty) return;
    ref.read(chatProvider.notifier).sendMessage(widget.controller.text, widget.meUserId);
    widget.controller.clear();
  }
}
