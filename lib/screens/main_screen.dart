// import 'package:flutter/material.dart';
import 'package:attendancetracker/widgets/attendance_tab.dart';
import 'package:attendancetracker/widgets/profile_tab.dart';
import 'package:flutter/cupertino.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return AttendanceTab();
          case 1:
            return ProfileTab();
          default:
            return Container();
        }
      },
    );
  }
}




