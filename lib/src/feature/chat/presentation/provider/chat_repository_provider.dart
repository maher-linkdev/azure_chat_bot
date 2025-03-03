import 'package:azure_chat_bot/src/feature/chat/data/repository/chat_repository_impl.dart';
import 'package:azure_chat_bot/src/feature/chat/domain/repositories/chat_repository.dart';
import 'package:azure_chat_bot/src/feature/common/provider/http_client_provider.dart';
import 'package:azure_chat_bot/src/feature/common/provider/uuid_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final uuid = ref.watch(uuidProvider);

  return ChatRepositoryImpl(
    client: httpClient,
    uuid: uuid,
  );
});
