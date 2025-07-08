import 'package:flutter/material.dart';
import '../../providers/attendance_provider.dart';
import '../../utils/history_helper_methods.dart';
import 'history_month_card.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({
    super.key,
    required this.animation,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.history,
  });

  final AnimationController animation;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final List<AttendanceTimes> history;

  @override
  Widget build(BuildContext context) {
    final groupedHistory = HistoryHelper.groupHistoryByMonth(history);
    final sortedMonths = HistoryHelper.getSortedMonths(groupedHistory);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            itemCount: sortedMonths.length,
            itemBuilder: (context, index) {
              final month = sortedMonths[index];
              final monthRecords = groupedHistory[month]!;
              return HistoryMonthCard(
                month: month,
                records: monthRecords,
              );
            },
          ),
        ),
      ),
    );
  }
} 