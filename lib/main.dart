import 'package:azure_chat_bot/src/app_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: AppRoot()),
  );
}
