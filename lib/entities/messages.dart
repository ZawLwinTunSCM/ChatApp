import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../utils/converter/timestamp_converter.dart';

part 'messages.freezed.dart';
part 'messages.g.dart';

@freezed
class Messages with _$Messages {
  const factory Messages({
    @Default('') String senderId,
    @Default('') String text,
    @Default('') @TimestampConverter() DateTime timestamp,
  }) = _Messages;

  factory Messages.fromJson(Map<String, dynamic> json) =>
      _$MessagesFromJson(json);
}
