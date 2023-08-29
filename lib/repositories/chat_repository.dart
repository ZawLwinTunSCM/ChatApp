import 'package:chat/entities/chat.dart';
import 'package:chat/entities/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chatRepositoryProvider = Provider.autoDispose<ChatRepositoryImpl>(
  (ref) => ChatRepositoryImpl(),
);

abstract class BaseChatRepository {
  Future<void> createChatRoom({required String chatId});
  Stream<List<Messages>?> fetchChatRoomMessages({required String chatId});
  Stream<List<Chat>> fetchAllChatRooms();
  Future<void> sendMessage({required String chatId, required Messages message});
  Future<bool> checkChatRoom({required String chatId});
}

class ChatRepositoryImpl implements BaseChatRepository {
  final _firestore = FirebaseFirestore.instance;

  final chatCol = 'chats';

  @override
  Future<void> createChatRoom({required String chatId}) async {
    // final List<Messages> msgList = [];
    // msgList.add(Messages(
    //     senderId: senderId, timestamp: DateTime.now(), text: 'testing'));
    final chat = Chat(
        chatId: chatId, lastMessageTimestamp: DateTime.now(), messages: null);
    await _firestore.collection(chatCol).doc(chatId).set(chat.toJson());
  }

  @override
  Stream<List<Messages>?> fetchChatRoomMessages({required String chatId}) {
    return _firestore.collection(chatCol).doc(chatId).snapshots().map((event) {
      final data = event.data();
      if (data == null || data['messages'] == null) {
        return [];
      }
      final List<dynamic> messagesData = data['messages'];
      return messagesData.map((messageData) {
        return Messages.fromJson(messageData);
      }).toList();
    });
  }

  @override
  Stream<List<Chat>> fetchAllChatRooms() {
    return _firestore.collection(chatCol).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Chat.fromJson(doc.data())).toList();
    });
  }

  // @override
  // Future<void> sendMessage(
  //     {required String chatId, required Messages message}) async {
  //   final List<Messages> messages = [];
  //   messages.add(message);
  //   final chat = Chat(
  //       chatId: chatId,
  //       lastMessageTimestamp: DateTime.now(),
  //       messages: messages);
  //   await _firestore.collection(chatCol).doc(chatCol).set(chat.toJson());
  // }

  @override
  Future<void> sendMessage({
    required String chatId,
    required Messages message,
  }) async {
    final chatDoc = await _firestore.collection(chatCol).doc(chatId).get();
    if (chatDoc.exists && Chat.fromJson(chatDoc.data()!).messages != null) {
      final existingChatData = Chat.fromJson(chatDoc.data()!);
      final updatedMessages =
          List<Messages>.from(existingChatData.messages as Iterable);
      updatedMessages.add(message);
      final updatedChat = existingChatData.copyWith(
        lastMessageTimestamp: DateTime.now(),
        messages: updatedMessages,
      );
      await _firestore
          .collection(chatCol)
          .doc(chatId)
          .set(updatedChat.toJson());
    } else {
      final chat = Chat(
        chatId: chatId,
        lastMessageTimestamp: DateTime.now(),
        messages: [message],
      );
      await _firestore.collection(chatCol).doc(chatId).set(chat.toJson());
    }
  }

  @override
  Future<bool> checkChatRoom({required String chatId}) async {
    final snapshot = await _firestore.collection(chatCol).doc(chatId).get();
    return snapshot.exists;
  }
}
