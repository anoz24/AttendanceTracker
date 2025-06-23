import 'package:flutter/material.dart';
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
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    AttendanceTab(),
    HistoryTab(),
    ReportTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.transparent,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
      tabBuilder: (context, index) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          child: _tabs[_currentIndex],
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}




