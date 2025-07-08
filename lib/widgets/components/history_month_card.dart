import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/app_settings_provider.dart';
import '../../utils/history_helper_methods.dart';
import 'history_day_record.dart';

class HistoryMonthCard extends ConsumerWidget {
  const HistoryMonthCard({
    super.key,
    required this.month,
    required this.records,
  });

  final String month;
  final List<AttendanceTimes> records;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    
    final totalWorkedHours = HistoryHelper.calculateTotalWorkedHours(records);
    final attendancePercentage = HistoryHelper.calculateAttendancePercentage(records, month, settings.workingDays);
    final sortedRecords = HistoryHelper.sortRecordsByDate(records);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: EdgeInsets.zero,
          collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          title: Text(
            month,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$totalWorkedHours total',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: HistoryHelper.getAttendancePercentageColor(context, attendancePercentage),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${attendancePercentage.toStringAsFixed(1)}% attendance',
                    style: TextStyle(
                      color: HistoryHelper.getAttendancePercentageColor(context, attendancePercentage),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Records:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Swipe right on any record to edit or delete →',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...sortedRecords.map((record) => HistoryDayRecord(record: record)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 