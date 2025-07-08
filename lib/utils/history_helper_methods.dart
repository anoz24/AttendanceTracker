import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/attendance_provider.dart';
import '../utils/attendance_utils.dart';
import '../config/theme.dart';
import '../widgets/components/edit_attendance_sheet.dart';
import '../widgets/components/top_snack_bar.dart';

class HistoryHelper {
  // Data Processing Methods
  static Map<String, List<AttendanceTimes>> groupHistoryByMonth(List<AttendanceTimes> history) {
    return AttendanceUtils.groupRecordsByMonth(history);
  }
  
  static List<String> getSortedMonths(Map<String, List<AttendanceTimes>> groupedHistory) {
    return AttendanceUtils.sortMonthsChronologically(groupedHistory);
  }
  
  static List<AttendanceTimes> sortRecordsByDate(List<AttendanceTimes> records) {
    return AttendanceUtils.sortRecordsByDate(records);
  }
  
  // Calculation Methods
  static String calculateTotalWorkedHours(List<AttendanceTimes> records) {
    return AttendanceUtils.formatDuration(
      AttendanceUtils.calculateTotalMinutes(records)
    );
  }
  
  static double calculateAttendancePercentage(
    List<AttendanceTimes> records, 
    String month, 
    List<int> workingDays
  ) {
    final monthParts = month.split(' ');
    final monthNumber = AttendanceUtils.getMonthNumber(monthParts[0]);
    final year = int.parse(monthParts[1]);
    final monthDate = DateTime(year, monthNumber);
    
    return AttendanceUtils.getAttendancePercentage(records, monthDate, workingDays);
  }
  
  // Record Analysis Methods
  static bool hasClockIn(AttendanceTimes record) {
    return record.clockIn != null;
  }
  
  static bool hasClockOut(AttendanceTimes record) {
    return record.clockOut != null;
  }
  
  static int calculateWorkingDuration(AttendanceTimes record) {
    if (hasClockIn(record) && hasClockOut(record)) {
      return record.clockOut!.difference(record.clockIn!).inMinutes;
    }
    return 0;
  }
  
  static RecordStatus getRecordStatus(AttendanceTimes record) {
    final hasIn = hasClockIn(record);
    final hasOut = hasClockOut(record);
    
    if (hasIn && hasOut) {
      return RecordStatus.completed;
    } else if (hasIn && !hasOut) {
      return RecordStatus.incomplete;
    } else {
      return RecordStatus.noRecord;
    }
  }
  
  static String getStatusText(RecordStatus status, int workingMinutes) {
    switch (status) {
      case RecordStatus.completed:
        return AttendanceUtils.formatDuration(workingMinutes);
      case RecordStatus.incomplete:
        return 'Not clocked out';
      case RecordStatus.noRecord:
        return 'No record';
    }
  }
  
  static Color getStatusColor(BuildContext context, RecordStatus status) {
    switch (status) {
      case RecordStatus.completed:
        return AppTheme.getSuccessColor(context);
      case RecordStatus.incomplete:
        return AppTheme.getWarningColor(context);
      case RecordStatus.noRecord:
        return AppTheme.getErrorColor(context);
    }
  }
  
  static IconData getStatusIcon(RecordStatus status) {
    switch (status) {
      case RecordStatus.completed:
        return Icons.check_circle;
      case RecordStatus.incomplete:
        return Icons.warning;
      case RecordStatus.noRecord:
        return Icons.cancel;
    }
  }
  
  // Time Formatting Methods
  static String formatTime(DateTime time, bool is24HourFormat) {
    if (is24HourFormat) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
      final amPm = time.hour >= 12 ? 'PM' : 'AM';
      return '${hour.toString()}:${time.minute.toString().padLeft(2, '0')} $amPm';
    }
  }
  
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  static String formatClockInOut(AttendanceTimes record, bool is24HourFormat) {
    final hasIn = hasClockIn(record);
    final hasOut = hasClockOut(record);
    
    final clockInText = hasIn ? 'In: ${formatTime(record.clockIn!, is24HourFormat)}' : 'No clock in';
    final clockOutText = hasOut ? 'Out: ${formatTime(record.clockOut!, is24HourFormat)}' : 'No clock out';
    
    return '$clockInText • $clockOutText';
  }
  
  // Dialog and Sheet Methods
  static void showEditDialog(BuildContext context, WidgetRef ref, AttendanceTimes record) {
    final allHistory = ref.read(attendanceHistoryProvider);
    final recordIndex = allHistory.indexOf(record);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditAttendanceSheet(
        record: record,
        recordIndex: recordIndex,
      ),
    );
  }
  
  static void showDeleteConfirmation(BuildContext context, WidgetRef ref, AttendanceTimes record) {
    final allHistory = ref.read(attendanceHistoryProvider);
    final recordIndex = allHistory.indexOf(record);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: Text(
          'Are you sure you want to delete the attendance record for ${record.date != null ? formatDate(record.date!) : 'this date'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(attendanceHistoryProvider.notifier).deleteAttendanceRecord(recordIndex);
              Navigator.pop(context);
              
              if (context.mounted) {
                TopSnackBar.show(
                  context,
                  message: 'Attendance record deleted successfully',
                  type: TopSnackBarType.success,
                  icon: Icons.delete_outline,
                  duration: const Duration(seconds: 2),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.getErrorColor(context)),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  // Attendance Percentage Color Helper
  static Color getAttendancePercentageColor(BuildContext context, double percentage) {
    return percentage >= 80 
        ? AppTheme.getSuccessColor(context) 
        : AppTheme.getWarningColor(context);
  }
}

// Enum for record status
enum RecordStatus { completed, incomplete, noRecord } 