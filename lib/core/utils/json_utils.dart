import 'package:maintboard/core/utils/logger.dart';

/// Throws and logs a clear error if the required field is missing from the JSON.
T requireField<T>(Map json, String key) {
  if (!json.containsKey(key)) {
    final trace = StackTrace.current.toString().split('\n')[1];
    final fileMatch = RegExp(r'#1\s+.*\((.*?):(\d+):\d+\)').firstMatch(trace);

    final fileInfo = fileMatch != null
        ? '${fileMatch.group(1)} at line ${fileMatch.group(2)}'
        : 'Unknown location';

    final message = 'Missing required field: "$key" in $fileInfo';
    logger.e(message);
    throw Exception(message);
  }

  return json[key];
}
