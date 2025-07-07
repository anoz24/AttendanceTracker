import 'package:flutter/material.dart';
import '../widgets/tabs/attendance_tab.dart';
import '../widgets/tabs/history_tab.dart';
import '../widgets/tabs/report_tab.dart';
import '../widgets/tabs/settings_tab.dart';
import '../widgets/common/floating_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _previousIndex = 0;

  final List<Widget> _tabs = const [
    AttendanceTab(),
    HistoryTab(),
    ReportTab(),
    SettingsTab(),
  ];

  final List<FloatingNavBarItem> _navItems = const [
    FloatingNavBarItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    FloatingNavBarItem(
      icon: Icons.work_outline,
      activeIcon: Icons.work,
      label: 'History',
    ),
    FloatingNavBarItem(
      icon: Icons.insert_drive_file_outlined,
      activeIcon: Icons.insert_drive_file,
      label: 'Reports',
    ),
    FloatingNavBarItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          final slideDirection = _currentIndex > _previousIndex ? 1.0 : -1.0;
          
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(slideDirection, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: _tabs[_currentIndex],
        ),
      ),
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _previousIndex = _currentIndex;
            _currentIndex = index;
          });
        },
        items: _navItems,
      ),
    );
  }
}




