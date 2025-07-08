import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_settings_provider.dart';

class TimeFormatSettingTile extends ConsumerWidget {
  const TimeFormatSettingTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.access_time),
        title: const Text(
          'Time Format',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(appSettings.is24HourFormat
            ? '24-hour (14:30)'
            : '12-hour (2:30 PM)'),
        trailing: Switch(
          value: appSettings.is24HourFormat,
          onChanged: (value) {
            ref
                .read(appSettingsProvider.notifier)
                .setClockFormat(value);
          },
        ),
      ),
    );
  }
} 