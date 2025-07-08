import 'package:flutter/material.dart';
import '../../providers/attendance_provider.dart';
import 'activity_card.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({
    super.key,
    required this.animation,
    required this.recentActivity,
  });

  final AnimationController animation;
  final List<AttendanceTimes> recentActivity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeIn),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
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
                    return AnimatedActivityCard(
                      record: record,
                      delay: Duration(milliseconds: 600 + (index * 200)),
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
}

class AnimatedActivityCard extends StatelessWidget {
  const AnimatedActivityCard({
    super.key,
    required this.record,
    required this.delay,
  });

  final AttendanceTimes record;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: delay,
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
  }
} 