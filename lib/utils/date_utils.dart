import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatTime(DateTime? time, {bool is24Hour = true}) {
    if (time == null) return "--:--";
    
    if (is24Hour) {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else {
      return DateFormat('h:mm a').format(time);
    }
  }

  static String getDayName(DateTime? date) {
    if (date == null) return "";
    return DateFormat('EEEE').format(date);
  }

  static String formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}-${date.month}-${date.year}";
  }

  static String formatFullDate(DateTime? date) {
    if (date == null) return "No date";
    return DateFormat('EEEE, MMMM d, y').format(date);
  }

  static String formatShortDate(DateTime? date) {
    if (date == null) return "Unknown Date";
    return DateFormat('EEEE, MMM d').format(date);
  }

  static String calculateWorkingHours(DateTime? clockIn, DateTime? clockOut) {
    if (clockIn == null || clockOut == null) return "0h 0m";
    final duration = clockOut.difference(clockIn);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return "${hours}h ${minutes}m";
  }

  static String getWeeklyHours(List<dynamic> history) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    int totalMinutes = 0;
    for (var record in history) {
      if (record.date != null && 
          record.clockIn != null && 
          record.clockOut != null &&
          record.date!.isAfter(weekStart.subtract(const Duration(days: 1)))) {
        totalMinutes += int.parse(record.clockOut!.difference(record.clockIn!).inMinutes);
      }
    }
    
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    return "${hours}h ${minutes}m";
  }
} 