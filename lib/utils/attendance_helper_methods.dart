import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/attendance_provider.dart';
import '../widgets/components/attendance_status_card.dart';
import '../widgets/components/styled_time_picker.dart';
import '../widgets/components/top_snack_bar.dart';
import 'date_utils.dart';

class AttendanceHelper {
  // Helper Methods
  static AttendanceTimes getTodayRecord(List<AttendanceTimes> history) {
    final today = DateTime.now();
    return history.firstWhere(
      (record) => record.date != null && 
                  isSameDay(record.date!, today) &&
                  record.clockIn != null &&
                  record.clockOut != null,
      orElse: () => AttendanceTimes(),
    );
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  static bool isCompletedToday(AttendanceTimes todayRecord) {
    return todayRecord.clockIn != null && todayRecord.clockOut != null;
  }

  static AttendanceStatus getAttendanceStatus(
    AttendanceTimes currentAttendance, 
    bool isCompleted
  ) {
    if (isCompleted) return AttendanceStatus.completed;
    if (currentAttendance.clockIn != null && currentAttendance.clockOut == null) {
      return AttendanceStatus.working;
    }
    return AttendanceStatus.notStarted;
  }

  static List<AttendanceTimes> getRecentActivity(List<AttendanceTimes> history) {
    return history
        .where((record) => 
            record.date != null && 
            record.clockIn != null && 
            record.clockOut != null)
        .toList()
      ..sort((a, b) => b.date!.compareTo(a.date!));
  }

  // Time Selection Logic
  static Future<void> selectTime({
    required bool isClockIn,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final attendanceTimes = ref.read(attendanceTimesProvider);
    final history = ref.read(attendanceHistoryProvider);
    final todayRecord = getTodayRecord(history);
    
    if (isCompletedToday(todayRecord)) {
      showCompletionMessage(context);
      return;
    }

    final selectedTime = await showTimePicker(context, isClockIn);
    if (selectedTime == null) return;

    final selectedDateTime = createDateTime(selectedTime);

    // Check if context is still mounted before using it
    if (context.mounted) {
      if (isClockIn) {
        await handleClockIn(context, ref, selectedDateTime);
      } else {
        await handleClockOut(context, ref, attendanceTimes, selectedDateTime);
      }
    }
  }

  static Future<TimeOfDay?> showTimePicker(BuildContext context, bool isClockIn) {
    return isClockIn
        ? StyledTimePicker.showClockIn(context)
        : StyledTimePicker.showClockOut(context);
  }

  static DateTime createDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  static Future<void> handleClockIn(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDateTime,
  ) async {
    final attendanceTimes = ref.read(attendanceTimesProvider);
    
    ref.read(attendanceTimesProvider.notifier).state = attendanceTimes.copyWith(
      clockIn: selectedDateTime,
      clockOut: null,
    );
    
    showSuccessMessage(
      context,
      'Successfully clocked in!',
      Icons.login,
      const Duration(seconds: 2),
    );
  }

  static Future<void> handleClockOut(
    BuildContext context,
    WidgetRef ref,
    AttendanceTimes attendanceTimes, 
    DateTime selectedDateTime,
  ) async {
    if (attendanceTimes.clockIn == null || 
        !selectedDateTime.isAfter(attendanceTimes.clockIn!)) {
      showErrorMessage(context, 'Clock out time must be after clock in time');
      return;
    }

    // Update current attendance
    ref.read(attendanceTimesProvider.notifier).state = 
        attendanceTimes.copyWith(clockOut: selectedDateTime);

    // Add to history
    ref.read(attendanceHistoryProvider.notifier).addAttendanceRecord(
      date: attendanceTimes.date!,
      clockIn: attendanceTimes.clockIn!,
      clockOut: selectedDateTime,
    );

    // Reset for next day
    ref.read(attendanceTimesProvider.notifier).state = AttendanceTimes(
      date: DateTime.now(),
      clockIn: null,
      clockOut: null,
    );

    final workingHours = DateTimeUtils.calculateWorkingHours(
      attendanceTimes.clockIn,
      selectedDateTime,
    );
    
    showSuccessMessage(
      context,
      'Great work! You completed $workingHours today!',
      Icons.celebration,
      const Duration(seconds: 4),
    );
  }

  // UI Message Methods
  static void showCompletionMessage(BuildContext context) {
    TopSnackBar.show(
      context,
      message: 'Today\'s attendance is already completed!',
      type: TopSnackBarType.info,
      icon: Icons.check_circle,
      duration: const Duration(seconds: 3),
    );
  }

  static void showSuccessMessage(
    BuildContext context,
    String message, 
    IconData icon, 
    Duration duration,
  ) {
    TopSnackBar.show(
      context,
      message: message,
      type: TopSnackBarType.success,
      icon: icon,
      duration: duration,
    );
  }

  static void showErrorMessage(BuildContext context, String message) {
    TopSnackBar.show(
      context,
      message: message,
      type: TopSnackBarType.error,
      icon: Icons.access_time,
      duration: const Duration(seconds: 3),
    );
  }
} 