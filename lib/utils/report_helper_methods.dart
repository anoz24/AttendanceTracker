import 'package:flutter/material.dart';
import '../providers/attendance_provider.dart';
import '../utils/attendance_utils.dart';
import '../config/theme.dart';

class ReportHelper {
  // Data Calculation Methods
  static List<DateTime> getAvailableMonths(List<AttendanceTimes> history) {
    final monthsSet = <DateTime>{};
    
    for (final record in history) {
      if (record.date != null) {
        final monthKey = DateTime(record.date!.year, record.date!.month);
        monthsSet.add(monthKey);
      }
    }
    
    return monthsSet.toList()..sort((a, b) => b.compareTo(a)); // Latest first
  }
  
  static int findCurrentMonthIndex(List<DateTime> availableMonths, DateTime selectedDate) {
    for (int i = 0; i < availableMonths.length; i++) {
      if (availableMonths[i].year == selectedDate.year && 
          availableMonths[i].month == selectedDate.month) {
        return i;
      }
    }
    return 0;
  }
  
  static List<AttendanceTimes> getMonthRecords(
    List<AttendanceTimes> history, 
    DateTime selectedDate
  ) {
    return AttendanceUtils.getRecordsForMonth(
      history,
      selectedDate.year,
      selectedDate.month,
    );
  }
  
  // Month Navigation Methods
  static bool canNavigateBack(int currentIndex, int totalMonths) {
    return currentIndex < totalMonths - 1;
  }
  
  static bool canNavigateForward(int currentIndex) {
    return currentIndex > 0;
  }
  
  static int getNewIndex(int currentIndex, bool forward, int totalMonths) {
    final newIndex = forward ? currentIndex - 1 : currentIndex + 1;
    if (newIndex < 0 || newIndex >= totalMonths) return currentIndex;
    return newIndex;
  }
  
  // Statistics Calculation Methods
  static int calculateTotalMinutes(List<AttendanceTimes> records) {
    return AttendanceUtils.calculateTotalMinutes(records);
  }
  
  static int calculateAttendedDays(List<AttendanceTimes> records) {
    return AttendanceUtils.getTotalAttendedDays(records);
  }
  
  static int calculateWorkingDays(DateTime selectedDate, List<int> workingDays) {
    return AttendanceUtils.getWorkingDaysInMonth(selectedDate, workingDays);
  }
  
  static int calculateMissedDays(
    List<AttendanceTimes> records, 
    DateTime selectedDate, 
    List<int> workingDays
  ) {
    return AttendanceUtils.getMissedDaysInMonth(records, selectedDate, workingDays);
  }
  
  static double calculateAttendancePercentage(
    List<AttendanceTimes> records, 
    DateTime selectedDate, 
    List<int> workingDays
  ) {
    return AttendanceUtils.getAttendancePercentage(records, selectedDate, workingDays);
  }
  
  static double calculateAverageDailyHours(List<AttendanceTimes> records) {
    return AttendanceUtils.calculateAverageDailyHours(records);
  }
  
  static int calculateExpectedMinutes(int attendedDays, double standardWorkHours) {
    return (attendedDays * standardWorkHours * 60).round();
  }
  
  static int calculateOvertimeMinutes(int totalMinutes, int expectedMinutes) {
    return totalMinutes - expectedMinutes;
  }
  
  // Color Helper Methods
  static Color getAttendanceColor(BuildContext context, double percentage) {
    return percentage >= 80 
        ? AppTheme.getSuccessColor(context)
        : AppTheme.getWarningColor(context);
  }
  
  static Color getOvertimeColor(BuildContext context, int overtimeMinutes) {
    return overtimeMinutes >= 0 
        ? AppTheme.getSuccessColor(context)
        : AppTheme.getErrorColor(context);
  }
  
  // Animation Helper Methods
  static void animateSlide(AnimationController controller, int direction) {
    final slideAnimation = Tween<Offset>(
      begin: Offset(direction.toDouble(), 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
    
    controller.reset();
    controller.forward();
  }
  
  static void animateStats(AnimationController controller) {
    controller.reset();
    controller.forward();
  }
  
  // Value Comparison Methods
  static bool isValueIncreasing(num current, num previous) {
    return current > previous;
  }
  
  static bool isValueDecreasing(num current, num previous) {
    return current < previous;
  }
  
  // Format Helper Methods
  static String formatMonthYear(DateTime date) {
    return AttendanceUtils.formatMonthYear(date);
  }
  
  static String formatDuration(int minutes) {
    return AttendanceUtils.formatDuration(minutes);
  }
  
  static String formatHours(double hours) {
    return '${hours.toStringAsFixed(1)}h';
  }
  
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }
  
  static String formatDaysRatio(int attended, int total) {
    return '$attended/$total';
  }
  
  static String formatOvertimeLabel(int overtimeMinutes) {
    return overtimeMinutes >= 0 ? 'Overtime' : 'Undertime';
  }
  
  static IconData getOvertimeIcon(int overtimeMinutes) {
    return overtimeMinutes >= 0 ? Icons.trending_up : Icons.trending_down;
  }
  
  // Month Picker Helper
  static void showMonthPicker(
    BuildContext context,
    List<DateTime> availableMonths,
    DateTime selectedDate,
    Function(int) onMonthSelected,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Select Month',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: availableMonths.length,
                itemBuilder: (context, index) {
                  final month = availableMonths[index];
                  final isSelected = month.year == selectedDate.year && 
                                   month.month == selectedDate.month;
                  
                  return ListTile(
                    title: Text(formatMonthYear(month)),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    selected: isSelected,
                    onTap: () {
                      Navigator.pop(context);
                      onMonthSelected(index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data class for storing current metrics
class ReportMetrics {
  final int totalMinutes;
  final int attendedDays;
  final int workingDays;
  final int missedDays;
  final double attendancePercentage;
  final double avgDailyHours;
  final int expectedMinutes;
  final int overtimeMinutes;
  
  const ReportMetrics({
    required this.totalMinutes,
    required this.attendedDays,
    required this.workingDays,
    required this.missedDays,
    required this.attendancePercentage,
    required this.avgDailyHours,
    required this.expectedMinutes,
    required this.overtimeMinutes,
  });
}

// Data class for storing previous metrics for animation comparison
class PreviousMetrics {
  final int totalMinutes;
  final double attendancePercentage;
  final int attendedDays;
  final int missedDays;
  final double avgDailyHours;
  final int expectedMinutes;
  final int overtimeMinutes;
  
  const PreviousMetrics({
    required this.totalMinutes,
    required this.attendancePercentage,
    required this.attendedDays,
    required this.missedDays,
    required this.avgDailyHours,
    required this.expectedMinutes,
    required this.overtimeMinutes,
  });
} 