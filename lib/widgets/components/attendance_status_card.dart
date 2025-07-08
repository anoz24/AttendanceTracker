import 'package:flutter/material.dart';
import '../../providers/attendance_provider.dart';
import '../../utils/date_utils.dart';
import '../../config/theme.dart';

// Enum for attendance status
enum AttendanceStatus { notStarted, working, completed }

class AttendanceStatusCard extends StatelessWidget {
  const AttendanceStatusCard({
    super.key,
    required this.animation,
    required this.slideAnimation,
    required this.animationController,
    required this.attendanceTimes,
    required this.status,
  });

  final Animation<double> animation;
  final Animation<Offset> slideAnimation;
  final AnimationController animationController;
  final AttendanceTimes attendanceTimes;
  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slideAnimation,
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
                        AttendanceStatusBadge(status: status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateTimeUtils.formatFullDate(attendanceTimes.date),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
}

class AttendanceStatusBadge extends StatelessWidget {
  const AttendanceStatusBadge({super.key, required this.status});

  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    final (text, color) = switch (status) {
      AttendanceStatus.working => ('Working', AppTheme.getSuccessColor(context)),
      AttendanceStatus.completed => ('Completed', Theme.of(context).colorScheme.primary),
      AttendanceStatus.notStarted => ('Not Started', Theme.of(context).colorScheme.error),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 