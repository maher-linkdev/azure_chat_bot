import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum VoiceState {
  idle,
  listening,
  speaking,
  error,
}

class VoiceService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();

  final ValueNotifier<VoiceState> voiceState = ValueNotifier(VoiceState.idle);
  final ValueNotifier<String> recognizedText = ValueNotifier('');
  final ValueNotifier<bool> isInitialized = ValueNotifier(false);

  Function(String)? onSpeechResult;

  VoiceService() {
    print("init VoiceService");
    _initTts();
    _initSpeechToText();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      _tts.setStartHandler(() {
        voiceState.value = VoiceState.speaking;
      });

      _tts.setCompletionHandler(() {
        voiceState.value = VoiceState.idle;
      });

      _tts.setErrorHandler((message) {
        voiceState.value = VoiceState.error;
        if (kDebugMode) {
          print('TTS Error: $message');
        }
      });

      isInitialized.value = true;
    } catch (e) {
      if (kDebugMode) {
        print('TTS initialization error: $e');
      }
      voiceState.value = VoiceState.error;
    }
  }

  Future<void> _initSpeechToText() async {
    try {
      bool available = await _speechToText.initialize(
        onError: (error) {
          print('STT Error: $error');

          voiceState.value = VoiceState.error;
        },
        onStatus: (status) {
          print('STT Status: $status');

          if (status == 'done') {
            voiceState.value = VoiceState.idle;
          }
        },
      );

      if (!available) {
        print('Speech recognition not available on this device');

        voiceState.value = VoiceState.error;
      }
    } catch (e) {
      print('STT initialization error: $e');

      voiceState.value = VoiceState.error;
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    if (_speechToText.isListening) {
      await stopListening();
    }

    try {
      voiceState.value = VoiceState.speaking;
      await _tts.speak(text);
    } catch (e) {
      print('TTS speak error: $e');

      voiceState.value = VoiceState.error;
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
      voiceState.value = VoiceState.idle;
    } catch (e) {
      print('TTS stop speaking error: $e');
    }
  }

  Future<void> startListening({Function(String)? onResult}) async {
    if (voiceState.value == VoiceState.speaking) {
      await stopSpeaking();
    }

    try {
      recognizedText.value = '';
      onSpeechResult = onResult;

      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        localeId: 'en_US',
      );

      voiceState.value = VoiceState.listening;
    } catch (e) {
      print('STT starting listening error: $e');
      voiceState.value = VoiceState.error;
    }
  }

  Future<void> stopListening() async {
    try {
      await _speechToText.stop();
      voiceState.value = VoiceState.idle;
    } catch (e) {
      print('STT stop error: $e');
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    recognizedText.value = result.recognizedWords;
    if (result.finalResult && onSpeechResult != null) {
      onSpeechResult!(result.recognizedWords);
    }
  }

  void dispose() {
    _tts.stop();
    _speechToText.cancel();
    voiceState.dispose();
    recognizedText.dispose();
    isInitialized.dispose();
  }
}
