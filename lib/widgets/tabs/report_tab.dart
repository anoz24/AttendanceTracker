import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/app_settings_provider.dart';
import '../../utils/report_helper_methods.dart';
import '../components/animated_app_bar.dart';
import '../components/report_empty_state.dart';
import '../components/report_month_selector.dart';
import '../components/report_summary_section.dart';
import '../components/report_detailed_metrics.dart';

class ReportTab extends ConsumerStatefulWidget {
  const ReportTab({super.key});

  @override
  ConsumerState<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends ConsumerState<ReportTab>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _statsController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _statsAnimation;

  late DateTime _selectedDate;
  int _currentMonthIndex = 0;
  List<DateTime> _availableMonths = [];
  
  // Previous metrics for animation comparison
  PreviousMetrics _previousMetrics = const PreviousMetrics(
    totalMinutes: 0,
    attendancePercentage: 0.0,
    attendedDays: 0,
    missedDays: 0,
    avgDailyHours: 0.0,
    expectedMinutes: 0,
    overtimeMinutes: 0,
  );

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _statsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _statsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _statsController,
      curve: Curves.elasticOut,
    ));

    _statsController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _statsController.dispose();
    super.dispose();
  }

  void _updateAvailableMonths(List<AttendanceTimes> history) {
    _availableMonths = ReportHelper.getAvailableMonths(history);
    _currentMonthIndex = ReportHelper.findCurrentMonthIndex(_availableMonths, _selectedDate);
  }

  void _selectMonth(int index) {
    if (index < 0 || index >= _availableMonths.length) return;
    
    // Store current values as previous values for animation comparison
    final history = ref.read(attendanceHistoryProvider);
    final settings = ref.read(appSettingsProvider);
    final currentRecords = ReportHelper.getMonthRecords(history, _selectedDate);
    
    _previousMetrics = PreviousMetrics(
      totalMinutes: ReportHelper.calculateTotalMinutes(currentRecords),
      attendancePercentage: ReportHelper.calculateAttendancePercentage(currentRecords, _selectedDate, settings.workingDays),
      attendedDays: ReportHelper.calculateAttendedDays(currentRecords),
      missedDays: ReportHelper.calculateMissedDays(currentRecords, _selectedDate, settings.workingDays),
      avgDailyHours: ReportHelper.calculateAverageDailyHours(currentRecords),
      expectedMinutes: ReportHelper.calculateExpectedMinutes(ReportHelper.calculateAttendedDays(currentRecords), settings.standardWorkHours),
      overtimeMinutes: ReportHelper.calculateOvertimeMinutes(
        ReportHelper.calculateTotalMinutes(currentRecords),
        ReportHelper.calculateExpectedMinutes(ReportHelper.calculateAttendedDays(currentRecords), settings.standardWorkHours),
      ),
    );
    
    final direction = index > _currentMonthIndex ? 1 : -1;
    _currentMonthIndex = index;
    
    setState(() {
      _selectedDate = _availableMonths[index];
    });
    
    _animateSlide(direction);
    _animateStats();
  }

  void _navigateMonth(bool forward) {
    if (_availableMonths.isEmpty) return;
    
    final newIndex = ReportHelper.getNewIndex(_currentMonthIndex, forward, _availableMonths.length);
    if (newIndex != _currentMonthIndex) {
      _selectMonth(newIndex);
    }
  }

  void _animateSlide(int direction) {
    _slideAnimation = Tween<Offset>(
      begin: Offset(direction.toDouble(), 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    
    _slideController.reset();
    _slideController.forward();
  }

  void _animateStats() {
    _statsController.reset();
    _statsController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(attendanceHistoryProvider);
    final settings = ref.watch(appSettingsProvider);
    
    _updateAvailableMonths(history);
    
    if (_availableMonths.isEmpty) {
      return const ReportEmptyState();
    }

    final monthRecords = ReportHelper.getMonthRecords(history, _selectedDate);
    
    // Calculate current metrics
    final metrics = ReportMetrics(
      totalMinutes: ReportHelper.calculateTotalMinutes(monthRecords),
      attendedDays: ReportHelper.calculateAttendedDays(monthRecords),
      workingDays: ReportHelper.calculateWorkingDays(_selectedDate, settings.workingDays),
      missedDays: ReportHelper.calculateMissedDays(monthRecords, _selectedDate, settings.workingDays),
      attendancePercentage: ReportHelper.calculateAttendancePercentage(monthRecords, _selectedDate, settings.workingDays),
      avgDailyHours: ReportHelper.calculateAverageDailyHours(monthRecords),
      expectedMinutes: ReportHelper.calculateExpectedMinutes(ReportHelper.calculateAttendedDays(monthRecords), settings.standardWorkHours),
      overtimeMinutes: ReportHelper.calculateOvertimeMinutes(
        ReportHelper.calculateTotalMinutes(monthRecords),
        ReportHelper.calculateExpectedMinutes(ReportHelper.calculateAttendedDays(monthRecords), settings.standardWorkHours),
      ),
    );

    return Scaffold(
      appBar: const AnimatedAppBar(title: 'Reports'),
      body: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReportMonthSelector(
                selectedDate: _selectedDate,
                currentMonthIndex: _currentMonthIndex,
                availableMonths: _availableMonths,
                onMonthSelected: _selectMonth,
                onNavigateMonth: _navigateMonth,
              ),
              const SizedBox(height: 16),
              ReportSummarySection(
                metrics: metrics,
                previousMetrics: _previousMetrics,
                animation: _statsAnimation,
              ),
              const SizedBox(height: 12),
              ReportDetailedMetrics(
                metrics: metrics,
                previousMetrics: _previousMetrics,
                animation: _statsAnimation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}