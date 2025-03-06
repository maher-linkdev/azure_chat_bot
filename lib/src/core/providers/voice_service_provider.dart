import 'package:azure_chat_bot/src/core/services/voice_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final voiceServiceProvider = Provider<VoiceService>((ref) {
  final service = VoiceService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});
