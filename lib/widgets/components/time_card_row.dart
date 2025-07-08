import 'package:flutter/material.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/app_settings_provider.dart';
import '../../utils/date_utils.dart';
import '../../config/theme.dart';

class TimeCardRow extends StatelessWidget {
  const TimeCardRow({
    super.key,
    required this.animation,
    required this.animationController,
    required this.attendanceTimes,
    required this.todayRecord,
    required this.isCompleted,
    required this.settings,
    required this.onClockIn,
    required this.onClockOut,
  });

  final Animation<double> animation;
  final AnimationController animationController;
  final AttendanceTimes attendanceTimes;
  final AttendanceTimes todayRecord;
  final bool isCompleted;
  final AppSettings settings;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;

  @override
  Widget build(BuildContext context) {
    final canClockIn = attendanceTimes.clockIn == null && 
                      attendanceTimes.clockOut == null && 
                      !isCompleted;
    
    final canClockOut = attendanceTimes.clockIn != null && 
                       attendanceTimes.clockOut == null && 
                       !isCompleted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          AttendanceTimeCard(
            animation: animation,
            animationController: animationController,
            title: "Clock In",
            time: isCompleted 
                ? DateTimeUtils.formatTime(todayRecord.clockIn, is24Hour: settings.is24HourFormat)
                : DateTimeUtils.formatTime(attendanceTimes.clockIn, is24Hour: settings.is24HourFormat),
            icon: Icons.login,
            onPressed: canClockIn ? onClockIn : null,
            buttonColor: AppTheme.getSuccessColor(context),
          ),
          const SizedBox(width: 16),
          AttendanceTimeCard(
            animation: animation,
            animationController: animationController,
            title: "Clock Out",
            time: isCompleted 
                ? DateTimeUtils.formatTime(todayRecord.clockOut, is24Hour: settings.is24HourFormat)
                : DateTimeUtils.formatTime(attendanceTimes.clockOut, is24Hour: settings.is24HourFormat),
            icon: Icons.logout,
            onPressed: canClockOut ? onClockOut : null,
            buttonColor: AppTheme.getErrorColor(context),
          ),
        ],
      ),
    );
  }
}

class AttendanceTimeCard extends StatelessWidget {
  const AttendanceTimeCard({
    super.key,
    required this.animation,
    required this.animationController,
    required this.title,
    required this.time,
    required this.icon,
    required this.onPressed,
    required this.buttonColor,
  });

  final Animation<double> animation;
  final AnimationController animationController;
  final String title;
  final String time;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return ScaleTransition(
            scale: animation,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AnimatedCardIcon(icon: icon),
                    const SizedBox(height: 8),
                    Text(title, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    AnimatedTimeText(time: time),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(title.split(' ')[0]),
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
}

class AnimatedCardIcon extends StatelessWidget {
  const AnimatedCardIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(
            icon, 
            size: 24, 
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}

class AnimatedTimeText extends StatelessWidget {
  const AnimatedTimeText({super.key, required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
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
    );
  }
} 