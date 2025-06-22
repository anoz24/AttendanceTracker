import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/attendance_provider.dart';

class AttendanceTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(attendanceTimeProvider);

    String time = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            'Attendance',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 110),
            Text(
              time,
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            CupertinoButton(
              onPressed: () {
                ref.read(attendanceTimeProvider.notifier).state = DateTime.now();
              },
              child: Text("Clock in"),
            ),
            SizedBox(height: 20),
            CupertinoButton(
              onPressed: () {},
              child: Text(
                "Clock out",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}