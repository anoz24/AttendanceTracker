import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
import '../../config/theme.dart';
import '../../utils/date_utils.dart';
import '../common/animated_app_bar.dart';
import '../common/activity_card.dart';
import '../common/styled_time_picker.dart';
import '../../providers/app_settings_provider.dart';

class AttendanceTab extends ConsumerStatefulWidget {
  const AttendanceTab({super.key});

  @override
  ConsumerState<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends ConsumerState<AttendanceTab>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _cardsController;
  late AnimationController _activityController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _activityController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    
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
    
    _startAnimations();
  }
  
  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _mainController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _cardsController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _activityController.forward();
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

    Future<void> selectTime({required bool isClockIn}) async {
      final TimeOfDay? selectedTime = isClockIn
          ? await StyledTimePicker.showClockIn(context)
          : await StyledTimePicker.showClockOut(context);

      if (selectedTime != null) {
        final now = DateTime.now();
        final selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        if (isClockIn) {
          // Clock In
          ref.read(attendanceTimesProvider.notifier).state =
              attendanceTimes.copyWith(
            clockIn: selectedDateTime,
            clockOut: null,
          );
        } else {
          // Clock Out
          if (attendanceTimes.clockIn != null &&
              selectedDateTime.isAfter(attendanceTimes.clockIn!)) {
            ref.read(attendanceTimesProvider.notifier).state =
                attendanceTimes.copyWith(clockOut: selectedDateTime);

            ref.read(attendanceHistoryProvider.notifier).addAttendanceRecord(
              date: attendanceTimes.date!,
              clockIn: attendanceTimes.clockIn!,
              clockOut: selectedDateTime,
            );

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Great Work!"),
                content: Text(
                    "You completed ${DateTimeUtils.calculateWorkingHours(attendanceTimes.clockIn, selectedDateTime)} today!"),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Clock out time must be after clock in time'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }

    Widget buildStatusCard() {
      final isWorking = attendanceTimes.clockIn != null && attendanceTimes.clockOut == null;
      final hasCompletedToday = attendanceTimes.clockIn != null && attendanceTimes.clockOut != null;
      
      return AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateTimeUtils.getDayName(attendanceTimes.date),
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isWorking 
                                  ? AppTheme.getSuccessColor(context)
                                  : hasCompletedToday
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).iconTheme.color!,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isWorking 
                                  ? "Working"
                                  : hasCompletedToday
                                      ? "Completed"
                                      : "Not Started",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateTimeUtils.formatFullDate(attendanceTimes.date),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    Widget buildTimeCard(String title, String time, IconData icon, VoidCallback? onPressed, {Color? buttonColor}) {
      return Expanded(
        child: AnimatedBuilder(
          animation: _cardsController,
          builder: (context, child) {
            return ScaleTransition(
              scale: _scaleAnimation,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(title, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 4),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Text(
                              time,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: ElevatedButton(
                            onPressed: onPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(title.split(' ')[0]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    Widget buildStatsRow() {
      return AnimatedBuilder(
        animation: _cardsController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _scaleAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-0.3, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _cardsController,
                curve: Curves.easeOutCubic,
              )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 1000),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Transform.rotate(
                              angle: value * 2 * 3.14159, // Full rotation
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.access_time,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's Hours", 
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 1200),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Text(
                                      DateTimeUtils.calculateWorkingHours(attendanceTimes.clockIn, attendanceTimes.clockOut),
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    Widget buildRecentActivity() {
      final recentActivity = history.take(3).toList();
      
      if (recentActivity.isEmpty) {
        return const SizedBox.shrink();
      }

      return AnimatedBuilder(
        animation: _activityController,
        builder: (context, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: _activityController, curve: Curves.easeIn),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _activityController,
                curve: Curves.easeOutCubic,
              )),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Activity',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...recentActivity.asMap().entries.map((entry) {
                      final index = entry.key;
                      final record = entry.value;
                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 600 + (index * 200)),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, (1 - value) * 50),
                            child: Opacity(
                              opacity: value,
                              child: CompactActivityCard(record: record),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: const AnimatedAppBar(title: 'Attendance'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildStatusCard(),
            buildStatsRow(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  buildTimeCard(
                    "Clock In",
                    DateTimeUtils.formatTime(attendanceTimes.clockIn, is24Hour: settings.is24HourFormat),
                    Icons.login,
                    (attendanceTimes.clockIn == null && attendanceTimes.clockOut == null)
                        ? () => selectTime(isClockIn: true)
                        : null,
                    buttonColor: AppTheme.getSuccessColor(context),
                  ),
                  const SizedBox(width: 16),
                  buildTimeCard(
                    "Clock Out",
                    DateTimeUtils.formatTime(attendanceTimes.clockOut, is24Hour: settings.is24HourFormat),
                    Icons.logout,
                    (attendanceTimes.clockIn != null && attendanceTimes.clockOut == null)
                        ? () => selectTime(isClockIn: false)
                        : null,
                    buttonColor: AppTheme.getErrorColor(context),
                  ),
                ],
              ),
            ),
            buildRecentActivity(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
