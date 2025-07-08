import '../providers/attendance_provider.dart';

class AttendanceUtils {
  // Constants
  static const List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  /// Get month name from month number (1-12)
  static String getMonthName(int month) => monthNames[month - 1];
  
  /// Get month number from month name
  static int getMonthNumber(String monthName) => monthNames.indexOf(monthName) + 1;

  /// Format date as "Month Year" (e.g., "January 2024")
  static String formatMonthYear(DateTime date) => '${getMonthName(date.month)} ${date.year}';

  /// Calculate total hours from attendance records
  static int calculateTotalHours(List<AttendanceTimes> records) {
    return records
        .where((record) => record.clockIn != null && record.clockOut != null)
        .fold(0, (total, record) {
          final minutes = record.clockOut!.difference(record.clockIn!).inMinutes;
          return total + minutes;
        }) ~/ 60;
  }

  /// Calculate total minutes from attendance records
  static int calculateTotalMinutes(List<AttendanceTimes> records) {
    return records
        .where((record) => record.clockIn != null && record.clockOut != null)
        .fold(0, (total, record) {
          final minutes = record.clockOut!.difference(record.clockIn!).inMinutes;
          return total + minutes;
        });
  }

  /// Group attendance records by month-year
  static Map<String, List<AttendanceTimes>> groupRecordsByMonth(List<AttendanceTimes> records) {
    final Map<String, List<AttendanceTimes>> grouped = {};
    
    for (final record in records) {
      if (record.date != null) {
        final monthYear = formatMonthYear(record.date!);
        grouped.putIfAbsent(monthYear, () => []).add(record);
      }
    }
    
    // Sort records within each month by date (latest first)
    for (final monthRecords in grouped.values) {
      monthRecords.sort((a, b) => b.date!.compareTo(a.date!));
    }
    
    return grouped;
  }

  /// Sort months chronologically (most recent first)
  static List<String> sortMonthsChronologically(Map<String, List<AttendanceTimes>> groupedRecords) {
    return groupedRecords.keys.toList()
      ..sort((a, b) {
        final aParts = a.split(' ');
        final bParts = b.split(' ');
        
        final aYear = int.parse(aParts[1]);
        final bYear = int.parse(bParts[1]);
        
        if (aYear != bYear) return bYear.compareTo(aYear);
        
        final aMonth = getMonthNumber(aParts[0]);
        final bMonth = getMonthNumber(bParts[0]);
        return bMonth.compareTo(aMonth);
      });
  }

  /// Format duration in hours and minutes
  static String formatDuration(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    
    if (hours == 0) {
      return '${minutes}m';
    } else if (minutes == 0) {
      return '${hours}h';
    } else {
      return '${hours}h ${minutes}m';
    }
  }

  /// Get working days count in a month (with configurable working days)
  static int getWorkingDaysInMonth(DateTime date, List<int> workingDays) {
    // final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    
    int workingDaysCount = 0;
    for (int day = 1; day <= lastDay.day; day++) {
      final currentDay = DateTime(date.year, date.month, day);
      if (workingDays.contains(currentDay.weekday)) {
        workingDaysCount++;
      }
    }
    
    return workingDaysCount;
  }

  /// Check if a date is a working day (with configurable working days)
  static bool isWorkingDay(DateTime date, List<int> workingDays) {
    return workingDays.contains(date.weekday);
  }

  /// Get attendance percentage for a list of records (with configurable working days)
  static double getAttendancePercentage(List<AttendanceTimes> records, DateTime monthDate, List<int> workingDays) {
    final workingDaysCount = getWorkingDaysInMonth(monthDate, workingDays);
    final attendedDays = records.where((record) => 
        record.clockIn != null && record.clockOut != null).length;
    
    if (workingDaysCount == 0) return 0.0;
    return (attendedDays / workingDaysCount) * 100;
  }

  /// Calculate average daily hours for a list of records
  static double calculateAverageDailyHours(List<AttendanceTimes> records) {
    final totalMinutes = calculateTotalMinutes(records);
    final attendedDays = records.where((record) => 
        record.clockIn != null && record.clockOut != null).length;
    
    if (attendedDays == 0) return 0.0;
    return (totalMinutes / attendedDays) / 60;
  }

  /// Get total attended days count
  static int getTotalAttendedDays(List<AttendanceTimes> records) {
    return records.where((record) => 
        record.clockIn != null && record.clockOut != null).length;
  }

  /// Get missed days count for a month (with configurable working days)
  static int getMissedDaysInMonth(List<AttendanceTimes> records, DateTime monthDate, List<int> workingDays) {
    final workingDaysCount = getWorkingDaysInMonth(monthDate, workingDays);
    final attendedDays = getTotalAttendedDays(records);
    return workingDaysCount - attendedDays;
  }

  /// Check if a record is a full day (complete clock in and clock out)
  static bool isCompleteRecord(AttendanceTimes record) {
    return record.clockIn != null && record.clockOut != null;
  }

  /// Group records by week
  static Map<String, List<AttendanceTimes>> groupRecordsByWeek(List<AttendanceTimes> records) {
    final Map<String, List<AttendanceTimes>> grouped = {};
    
    for (final record in records) {
      if (record.date != null) {
        final date = record.date!;
        final weekStart = date.subtract(Duration(days: date.weekday - 1));
        final weekKey = 'Week of ${weekStart.day}/${weekStart.month}/${weekStart.year}';
        grouped.putIfAbsent(weekKey, () => []).add(record);
      }
    }
    
    return grouped;
  }

  /// Get the current month's records
  static List<AttendanceTimes> getCurrentMonthRecords(List<AttendanceTimes> records) {
    final now = DateTime.now();
    return records.where((record) => 
        record.date != null &&
        record.date!.year == now.year &&
        record.date!.month == now.month).toList();
  }

  /// Get records for a specific month and year
  static List<AttendanceTimes> getRecordsForMonth(List<AttendanceTimes> records, int year, int month) {
    return records.where((record) => 
        record.date != null &&
        record.date!.year == year &&
        record.date!.month == month).toList();
  }

  /// Calculate working hours for a single record
  static String calculateSingleRecordWorkingHours(AttendanceTimes record) {
    if (record.clockIn == null || record.clockOut == null) return "0h 0m";
    
    final minutes = record.clockOut!.difference(record.clockIn!).inMinutes;
    return formatDuration(minutes);
  }

  /// Sort attendance records by date in descending order (latest first)
  static List<AttendanceTimes> sortRecordsByDate(List<AttendanceTimes> records) {
    final sortedRecords = [...records];
    sortedRecords.sort((a, b) {
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1;
      if (b.date == null) return -1;
      return b.date!.compareTo(a.date!);
    });
    return sortedRecords;
  }

} 