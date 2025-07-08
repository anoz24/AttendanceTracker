import 'package:flutter/material.dart';
import '../../utils/report_helper_methods.dart';
import '../../config/theme.dart';
import 'report_summary_card.dart';

class ReportSummarySection extends StatelessWidget {
  const ReportSummarySection({
    super.key,
    required this.metrics,
    required this.previousMetrics,
    required this.animation,
  });

  final ReportMetrics metrics;
  final PreviousMetrics previousMetrics;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Summary',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width - 48) / 2,
                child: ReportSummaryCard(
                  title: 'Total Hours',
                  value: ReportHelper.formatDuration(metrics.totalMinutes),
                  numericValue: metrics.totalMinutes,
                  previousValue: previousMetrics.totalMinutes,
                  icon: Icons.access_time,
                  color: Theme.of(context).colorScheme.primary,
                  animation: animation,
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 48) / 2,
                child: ReportSummaryCard(
                  title: 'Attendance',
                  value: ReportHelper.formatPercentage(metrics.attendancePercentage),
                  numericValue: metrics.attendancePercentage,
                  previousValue: previousMetrics.attendancePercentage,
                  icon: Icons.check_circle,
                  color: ReportHelper.getAttendanceColor(context, metrics.attendancePercentage),
                  animation: animation,
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 48) / 2,
                child: ReportSummaryCard(
                  title: 'Days Attended',
                  value: ReportHelper.formatDaysRatio(metrics.attendedDays, metrics.workingDays),
                  numericValue: metrics.attendedDays,
                  previousValue: previousMetrics.attendedDays,
                  icon: Icons.event_available,
                  color: AppTheme.getSuccessColor(context),
                  animation: animation,
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 48) / 2,
                child: ReportSummaryCard(
                  title: 'Days Missed',
                  value: metrics.missedDays.toString(),
                  numericValue: metrics.missedDays,
                  previousValue: previousMetrics.missedDays,
                  icon: Icons.event_busy,
                  color: AppTheme.getErrorColor(context),
                  animation: animation,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 