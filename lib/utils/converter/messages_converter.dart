
import 'package:chat/entities/messages.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class MessagesConverter
    implements JsonConverter<Messages, dynamic> {
  const MessagesConverter();
  @override
  Messages fromJson(dynamic data) {
    if (data == null) {
      return const Messages();
    }
    final json = data as Map<String, dynamic>;
    return Messages.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(Messages Messages) {
    return Messages.toJson();
  }
}
