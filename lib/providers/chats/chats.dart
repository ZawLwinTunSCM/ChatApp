import 'package:chat/entities/chat.dart';
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

class ChatStateNotifier extends StateNotifier<ChatState> {
  ChatStateNotifier(this._repository) : super(const ChatState());

  final BaseChatRepository _repository;

  Future<void> createChatRoom(
      {required String senderId, required String receiverId}) async {
    await _repository.createChatRoom(
        senderId: senderId, receiverId: receiverId);
  }

  Stream<Chat?> fetchChatRoom({required String chatId}) {
    return _repository.fetchChatRoom(chatId: chatId);
  }
}
