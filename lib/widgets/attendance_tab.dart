import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_provider.dart';

class AttendanceTab extends ConsumerWidget {
  const AttendanceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceTimes = ref.watch(attendanceTimesProvider);

    String formatTime(DateTime? time) {
      if (time == null) return "00:00";
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }

    String getDayName(DateTime? date) {
      if (date == null) return "";
      return DateFormat('EEEE').format(date);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 40),
            Text(
              attendanceTimes.date != null
                  ? getDayName(attendanceTimes.date)
                  : "",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10),
            Text(
              attendanceTimes.date != null
                  ? "${attendanceTimes.date!.day}-${attendanceTimes.date!.month}-${attendanceTimes.date!.year}"
                  : "No date",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 40),
            Text(
              formatTime(attendanceTimes.clockIn),
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (attendanceTimes.clockIn == null &&
                      attendanceTimes.clockOut == null)
                  ? () {
                      ref.read(attendanceTimesProvider.notifier).state =
                          attendanceTimes.copyWith(
                        clockIn: DateTime.now(),
                        clockOut: null,
                      );
                    }
                  : null,
              child: Text("Clock in"),
            ),
            SizedBox(height: 40),
            Text(
              formatTime(attendanceTimes.clockOut),
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: (attendanceTimes.clockIn != null &&
                      attendanceTimes.clockOut == null)
                  ? () {
                      final now = DateTime.now();
                      if (attendanceTimes.clockIn != null &&
                          now.isAfter(attendanceTimes.clockIn!)) {
                        ref.read(attendanceTimesProvider.notifier).state =
                            attendanceTimes.copyWith(clockOut: now);

                        final historyNotifier =
                            ref.read(attendanceHistoryProvider.notifier);
                        historyNotifier.state = [
                          ...historyNotifier.state,
                          AttendanceTimes(
                            date: attendanceTimes.date,
                            clockIn: attendanceTimes.clockIn,
                            clockOut: now,
                          ),
                        ];

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Success"),
                            content: Text("You Completed Work Today Yaay"),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  : null,
              child: Text("Clock out"),
            ),
          ],
        ),
      ),
    );
  }
}
