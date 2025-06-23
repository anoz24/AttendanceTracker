// import 'package:flutter/material.dart';
import 'package:attendancetracker/widgets/attendance_tab.dart';
import 'package:attendancetracker/widgets/history_tab.dart';
import 'package:attendancetracker/widgets/report_tab.dart';
import 'package:flutter/cupertino.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _tabs = [
    AttendanceTab(),
    HistoryTab(),
    ReportTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.time),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bag),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.paperclip),
            label: 'Report',
          ),
        ],
      ),
      tabBuilder: (context, index) => _tabs[index],
    );
  }
}




