import 'package:chat/entities/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chatRepositoryProvider = Provider.autoDispose<ChatRepositoryImpl>(
  (ref) => ChatRepositoryImpl(),
);

abstract class BaseChatRepository {
  Future<void> createChatRoom({required String senderId, required receiverId});
  Stream<Chat?> fetchChatRoom({required String chatId});
  Stream<List<Chat>> fetchAllChatRooms();
}

class ChatRepositoryImpl implements BaseChatRepository {
  final _firestore = FirebaseFirestore.instance;

  final chatCol = 'chats';

  @override
  Future<void> createChatRoom(
      {required String senderId, required receiverId}) async {
    final contacts = [senderId.toString(), receiverId.toString()];
    // final List<Messages> msgList = [];
    // msgList.add(Messages(
    //     senderId: senderId, timestamp: DateTime.now(), text: 'testing'));
    final chat = Chat(
        chatId: '$senderId,$receiverId',
        contacts: contacts,
        lastMessageTimestamp: DateTime.now(),
        messages: null);
    await _firestore
        .collection(chatCol)
        .doc('$senderId,$receiverId')
        .set(chat.toJson());
  }

  @override
  Stream<Chat?> fetchChatRoom({required String chatId}) {
    return _firestore.collection(chatCol).doc(chatId).snapshots().map((event) {
      final data = event.data();
      if (data == null) {
        return null;
      }
      return Chat.fromJson(data);
    });
  }

  @override
  Stream<List<Chat>> fetchAllChatRooms() {
    return _firestore.collection(chatCol).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Chat.fromJson(doc.data())).toList();
    });
  }
}
