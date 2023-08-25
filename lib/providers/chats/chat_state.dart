import 'package:chat/entities/chat.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    Chat? chat,
  }) = _ChatState;
}
