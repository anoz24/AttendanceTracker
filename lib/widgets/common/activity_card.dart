import 'package:attendancetracker/providers/app_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/date_utils.dart';
// import '../../providers/attendance_provider.dart';

class ActivityCard extends ConsumerWidget {
  final dynamic record;
  final EdgeInsets? margin;
  final EdgeInsets? contentPadding;
  final double? iconSize;
  final double? titleFontSize;
  final double? subtitleFontSize;
  final double? badgeFontSize;

  const ActivityCard({
    super.key,
    required this.record,
    this.margin,
    this.contentPadding,
    this.iconSize,
    this.titleFontSize,
    this.subtitleFontSize,
    this.badgeFontSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    
    return Card(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.work_outline,
            color: Theme.of(context).colorScheme.primary,
            size: iconSize ?? 24,
          ),
        ),
        title: Text(
          DateTimeUtils.formatShortDate(record.date),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: titleFontSize,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "${DateTimeUtils.formatTime(record.clockIn, is24Hour: settings.is24HourFormat)} - ${DateTimeUtils.formatTime(record.clockOut, is24Hour: settings.is24HourFormat)}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: subtitleFontSize ?? 14,
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            DateTimeUtils.calculateWorkingHours(record.clockIn, record.clockOut),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: badgeFontSize ?? 13,
            ),
          ),
        ),
      ),
    );
  }
}

// Compact version for home page recent activity
class CompactActivityCard extends ConsumerWidget {
  final dynamic record;

  const CompactActivityCard({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActivityCard(
      record: record,
      margin: const EdgeInsets.only(bottom: 8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      iconSize: 20,
      titleFontSize: 14,
      subtitleFontSize: 12,
      badgeFontSize: 11,
    );
  }
} 