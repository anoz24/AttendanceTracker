import 'package:flutter/material.dart';
import 'report_animated_value.dart';

class ReportSummaryCard extends StatelessWidget {
  const ReportSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.numericValue,
    required this.previousValue,
    required this.icon,
    required this.color,
    required this.animation,
  });

  final String title;
  final String value;
  final num numericValue;
  final num previousValue;
  final IconData icon;
  final Color color;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: color,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
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
    );
  }
} 