import 'package:logger/logger.dart';

final logger = Logger(
  filter:
      DevelopmentFilter(), // 💡 Use this to auto-disable logs in release mode
  printer: PrettyPrinter(
    methodCount: 0,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);
