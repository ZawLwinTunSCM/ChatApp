import 'package:flutter/material.dart';

TextStyle commonTextStyle({double? size, Color? color, FontWeight? weight}) {
  return TextStyle(
    fontSize: size ?? 13,
    fontWeight: weight ?? FontWeight.normal,
    color: color ?? Colors.white,
  );
}

String generateChatId(String chatId) {
  List<String> userIds = chatId.split(',');
  userIds.sort();
  return userIds.join(',');
}
