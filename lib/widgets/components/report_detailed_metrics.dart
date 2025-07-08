import 'package:flutter/material.dart';
import '../../utils/report_helper_methods.dart';
import 'report_animated_value.dart';

class ReportDetailedMetrics extends StatelessWidget {
  const ReportDetailedMetrics({
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
          'Detailed Metrics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetricRow(
                  context,
                  'Average Daily Hours',
                  ReportHelper.formatHours(metrics.avgDailyHours),
                  metrics.avgDailyHours,
                  previousMetrics.avgDailyHours,
                  Icons.schedule,
                  Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                _buildMetricRow(
                  context,
                  'Expected Hours',
                  ReportHelper.formatDuration(metrics.expectedMinutes),
                  metrics.expectedMinutes,
                  previousMetrics.expectedMinutes,
                  Icons.task_alt,
                  Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                _buildMetricRow(
                  context,
                  ReportHelper.formatOvertimeLabel(metrics.overtimeMinutes),
                  ReportHelper.formatDuration(metrics.overtimeMinutes.abs()),
                  metrics.overtimeMinutes,
                  previousMetrics.overtimeMinutes,
                  ReportHelper.getOvertimeIcon(metrics.overtimeMinutes),
                  ReportHelper.getOvertimeColor(context, metrics.overtimeMinutes),
                ),
                const SizedBox(height: 16),
                _buildMetricRow(
                  context,
                  'Working Days',
                  '${metrics.workingDays} days',
                  metrics.workingDays,
                  metrics.workingDays, // Same value, no animation needed
                  Icons.business,
                  Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(
    BuildContext context,
    String label,
    String value,
    num numericValue,
    num previousValue,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              ReportAnimatedValue(
                currentValue: value,
                currentNumericValue: numericValue,
                previousNumericValue: previousValue,
                baseColor: color,
                animation: animation,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 