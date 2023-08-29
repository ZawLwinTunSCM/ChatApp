import 'package:chat/entities/messages.dart';
import 'package:chat/utils/converter/messages_converter.dart';
import 'package:chat/utils/converter/timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String chatId,
    @TimestampConverter() required DateTime? lastMessageTimestamp,
    @MessagesConverter() required List<Messages>? messages,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
