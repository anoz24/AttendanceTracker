import 'package:flutter/material.dart';
import '../../utils/report_helper_methods.dart';

class ReportMonthSelector extends StatelessWidget {
  const ReportMonthSelector({
    super.key,
    required this.selectedDate,
    required this.currentMonthIndex,
    required this.availableMonths,
    required this.onMonthSelected,
    required this.onNavigateMonth,
  });

  final DateTime selectedDate;
  final int currentMonthIndex;
  final List<DateTime> availableMonths;
  final Function(int) onMonthSelected;
  final Function(bool) onNavigateMonth;

  @override
  Widget build(BuildContext context) {
    final canGoBack = ReportHelper.canNavigateBack(currentMonthIndex, availableMonths.length);
    final canGoForward = ReportHelper.canNavigateForward(currentMonthIndex);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              onPressed: canGoBack ? () => onNavigateMonth(false) : null,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous Month',
            ),
            Expanded(
              child: InkWell(
                onTap: () => ReportHelper.showMonthPicker(
                  context,
                  availableMonths,
                  selectedDate,
                  onMonthSelected,
                ),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ReportHelper.formatMonthYear(selectedDate),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${currentMonthIndex + 1}/${availableMonths.length})',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: canGoForward ? () => onNavigateMonth(true) : null,
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Next Month',
            ),
          ],
        ),
      ),
    );
  }
} 