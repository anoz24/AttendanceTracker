import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/attendance_provider.dart';

class HistoryTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(attendanceHistoryProvider);

    String getDayName(DateTime? date) {
      if (date == null) return "";
      return DateFormat('EEEE').format(date);
    }

    String formatDate(DateTime? date) {
      if (date == null) return "";
      return "${date.day}-${date.month}-${date.year}";
    }

    String formatTime(DateTime? time) {
      if (time == null) return "--:--";
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? Center(child: Text('No history yet'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final record = history[history.length - 1 - index]; // latest first
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getDayName(record.date)} ${formatDate(record.date)}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "(${formatTime(record.clockIn)} - ${formatTime(record.clockOut)})",
                        style: TextStyle(fontSize: 16),
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
    );
  }
}