class Conversation {
  final String conversationId;
  final String token;
  final int expiresIn;
  final String streamUrl;

  Conversation({
    required this.conversationId,
    required this.token,
    required this.expiresIn,
    required this.streamUrl,
  });
}
