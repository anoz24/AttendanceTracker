import 'package:flutter/material.dart';
import '../../providers/attendance_provider.dart';
import '../../utils/date_utils.dart';

class TodayHoursCard extends StatelessWidget {
  const TodayHoursCard({
    super.key,
    required this.animation,
    required this.animationController,
    required this.todayRecord,
    required this.attendanceTimes,
    required this.isCompleted,
  });

  final Animation<double> animation;
  final AnimationController animationController;
  final AttendanceTimes todayRecord;
  final AttendanceTimes attendanceTimes;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final displayHours = isCompleted
        ? DateTimeUtils.calculateWorkingHours(todayRecord.clockIn, todayRecord.clockOut)
        : DateTimeUtils.calculateWorkingHours(attendanceTimes.clockIn, attendanceTimes.clockOut);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-0.3, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animationController,
              curve: Curves.easeOutCubic,
            )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const RotatingClockIcon(),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Hours",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedHoursText(hours: displayHours),
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
}

class RotatingClockIcon extends StatelessWidget {
  const RotatingClockIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.access_time,
              size: 28,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class AnimatedHoursText extends StatelessWidget {
  const AnimatedHoursText({super.key, required this.hours});

  final String hours;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Text(
            hours,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
} 