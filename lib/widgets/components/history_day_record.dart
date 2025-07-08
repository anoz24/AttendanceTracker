import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/app_settings_provider.dart';
import '../../utils/history_helper_methods.dart';
import '../../config/theme.dart';

class HistoryDayRecord extends ConsumerWidget {
  const HistoryDayRecord({
    super.key,
    required this.record,
  });

  final AttendanceTimes record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    
    final workingDuration = HistoryHelper.calculateWorkingDuration(record);
    final status = HistoryHelper.getRecordStatus(record);
    final statusText = HistoryHelper.getStatusText(status, workingDuration);
    final statusColor = HistoryHelper.getStatusColor(context, status);
    final statusIcon = HistoryHelper.getStatusIcon(status);

    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Slidable(
          key: Key('record_${record.date?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch}'),
          startActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => HistoryHelper.showEditDialog(context, ref, record),
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(context).colorScheme.primary,
                icon: Icons.edit,
              ),
              SlidableAction(
                onPressed: (context) => HistoryHelper.showDeleteConfirmation(context, ref, record),
                backgroundColor: Colors.transparent,
                foregroundColor: AppTheme.getErrorColor(context),
                icon: Icons.delete,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  statusIcon,
                  color: statusColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.date != null
                            ? HistoryHelper.formatDate(record.date!)
                            : 'Unknown date',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (HistoryHelper.hasClockIn(record) || HistoryHelper.hasClockOut(record))
                        Text(
                          HistoryHelper.formatClockInOut(record, settings.is24HourFormat),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      statusText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.keyboard_arrow_left,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 