// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

class DateTimeService {
  /// Converts the given date to a UTC start and end of the day ISO 8601 range format.
  /// Example Output: `2024-12-06T18:30:00.000Z/2024-12-07T18:29:59.999Z`
  static String getIsoUtcDateRange(DateTime date) {
    // Convert local date to UTC
    final startOfDayUtc =
        DateTime(date.year, date.month, date.day, 0, 0, 0).toUtc();
    final endOfDayUtc =
        DateTime(date.year, date.month, date.day, 23, 59, 59, 999).toUtc();

    return '${startOfDayUtc.toIso8601String()}/${endOfDayUtc.toIso8601String()}';
  }

  static String getIsoUtcDayRange(DateTime fromDT, DateTime toDT) {
    final startUtc =
        DateTime(fromDT.year, fromDT.month, fromDT.day, 0, 0, 0).toUtc();
    final endUtc =
        DateTime(toDT.year, toDT.month, toDT.day, 23, 59, 59, 999).toUtc();
    return '${startUtc.toIso8601String()}/${endUtc.toIso8601String()}';
  }

  /// Converts a UTC DateTime to local time and returns only the time as a string.
  /// Example Output: "02:30 PM"
  static String formatUtcToLocalTime(DateTime? utcDateTime) {
    if (utcDateTime == null) {
      return "-"; // Return a placeholder for null values
    }

    final localDateTime = utcDateTime.toLocal();
    final hour = localDateTime.hour % 12 == 0 ? 12 : localDateTime.hour % 12;
    final minute = localDateTime.minute.toString().padLeft(2, '0');
    final period = localDateTime.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  static String formatUtcToLocalDateTime(DateTime? utcDateTime) {
    if (utcDateTime == null) {
      return "-"; // Return a placeholder for null values
    }

    final localDateTime = utcDateTime.toLocal();

    // Extract components
    final month =
        _getMonthName(localDateTime.month); // Helper to get month name
    final day = localDateTime.day;
    final year = localDateTime.year;

    final hour = localDateTime.hour % 12 == 0 ? 12 : localDateTime.hour % 12;
    final minute = localDateTime.minute.toString().padLeft(2, '0');
    final period = localDateTime.hour >= 12 ? 'PM' : 'AM';

    // Construct the formatted string
    return '$month $day, $year, $hour:$minute $period';
  }

  static String formatDuration(int minutes) {
    if (minutes <= 0) {
      return "-";
    }

    final int days = minutes ~/ (24 * 60); // Calculate days
    final int hours = (minutes % (24 * 60)) ~/ 60; // Calculate remaining hours
    final int remainingMinutes = minutes % 60; // Calculate remaining minutes

    String formattedTime = "";

    if (days > 0) {
      formattedTime += "${days}d ";
    }
    if (hours > 0) {
      formattedTime += "${hours}h ";
    }
    if (remainingMinutes > 0) {
      formattedTime += "${remainingMinutes}m";
    }

    return formattedTime.trim(); // Remove any trailing space
  }

  // Helper function to get month name
  static String _getMonthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1]; // Adjust index for 0-based array
  }
}
