import 'package:chat/entities/chat.dart';
import 'package:chat/entities/messages.dart';
import 'package:chat/providers/chats/chat_state.dart';
import 'package:chat/repositories/chat_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chatStateNotifierProvider =
    StateNotifierProvider.autoDispose<ChatStateNotifier, ChatState>(
  (ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatStateNotifier(chatRepository);
  },
);

final chatStreamProvider = StreamProvider.autoDispose<List<Chat>>(
  (ref) => ref.watch(chatRepositoryProvider).fetchAllChatRooms(),
);

final emojiProvider = StateProvider.autoDispose<bool>((ref) => true);

class ChatStateNotifier extends StateNotifier<ChatState> {
  ChatStateNotifier(this._repository) : super(const ChatState());

  final BaseChatRepository _repository;

  Future<void> createChatRoom({required String chatId}) async {
    await _repository.createChatRoom(chatId: chatId);
  }

  Stream<List<Messages>?> fetchChatRoomMessages({required String chatId}) {
    return _repository.fetchChatRoomMessages(chatId: chatId);
  }

  Future<void> sendMessages(
      {required String chatId, required Messages message}) async {
    await _repository.sendMessage(chatId: chatId, message: message);
  }

  Future<bool> checkChatRoom({required String chatId}) async {
    return await _repository.checkChatRoom(chatId: chatId);
  }
}
