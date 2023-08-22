import 'package:logger/logger.dart';

// 参考（https://pub.dev/packages/logger）
final logger = Logger(
  printer: PrettyPrinter(
    printEmojis: false,
  ),
);
