import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
import '../components/animated_app_bar.dart';
import '../../providers/app_settings_provider.dart';
import '../components/attendance_status_card.dart';
import '../components/today_hours_card.dart';
import '../components/time_card_row.dart';
import '../components/recent_activity_section.dart';
import '../../utils/attendance_helper_methods.dart';

class AttendanceTab extends ConsumerStatefulWidget {
  const AttendanceTab({super.key});

  @override
  ConsumerState<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends ConsumerState<AttendanceTab>
    with TickerProviderStateMixin {
  // Animation Controllers
  late final AnimationController _mainController;
  late final AnimationController _cardsController;
  late final AnimationController _activityController;
  
  // Animations
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  // Constants
  static const _animationDurations = {
    'main': Duration(milliseconds: 300),
    'cards': Duration(milliseconds: 500),
    'activity': Duration(milliseconds: 700),
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Initialize controllers
    _mainController = AnimationController(
      duration: _animationDurations['main']!,
      vsync: this,
    );
    
    _cardsController = AnimationController(
      duration: _animationDurations['cards']!,
      vsync: this,
    );
    
    _activityController = AnimationController(
      duration: _animationDurations['activity']!,
      vsync: this,
    );
    
    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardsController,
      curve: Curves.elasticOut,
    ));
  }
  
  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) _mainController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _cardsController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) _activityController.forward();
  }
  
  @override
  void dispose() {
    _mainController.dispose();
    _cardsController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceTimes = ref.watch(attendanceTimesProvider);
    final history = ref.watch(attendanceHistoryProvider);
    final settings = ref.watch(appSettingsProvider);
    
    final todayRecord = AttendanceHelper.getTodayRecord(history);
    final isCompleted = AttendanceHelper.isCompletedToday(todayRecord);
    final status = AttendanceHelper.getAttendanceStatus(attendanceTimes, isCompleted);
    final recentActivity = AttendanceHelper.getRecentActivity(history).take(3).toList();

    return Scaffold(
      appBar: const AnimatedAppBar(title: 'Attendance'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AttendanceStatusCard(
              animation: _fadeAnimation,
              slideAnimation: _slideAnimation,
              animationController: _mainController,
              attendanceTimes: attendanceTimes,
              status: status,
            ),
            TodayHoursCard(
              animation: _scaleAnimation,
              animationController: _cardsController,
              todayRecord: todayRecord,
              attendanceTimes: attendanceTimes,
              isCompleted: isCompleted,
            ),
            const SizedBox(height: 16),
            TimeCardRow(
              animation: _scaleAnimation,
              animationController: _cardsController,
              attendanceTimes: attendanceTimes,
              todayRecord: todayRecord,
              isCompleted: isCompleted,
              settings: settings,
              onClockIn: () => AttendanceHelper.selectTime(
                isClockIn: true,
                context: context,
                ref: ref,
              ),
              onClockOut: () => AttendanceHelper.selectTime(
                isClockIn: false,
                context: context,
                ref: ref,
              ),
            ),
            if (recentActivity.isNotEmpty)
              RecentActivitySection(
                animation: _activityController,
                recentActivity: recentActivity,
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
