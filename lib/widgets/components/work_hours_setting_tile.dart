import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_settings_provider.dart';
import 'work_hours_dialog.dart';

class WorkHoursSettingTile extends ConsumerWidget {
  const WorkHoursSettingTile({super.key});

  String _formatHours(double hours) {
    if (hours == hours.roundToDouble()) {
      return '${hours.toInt()} hours per day';
    } else {
      return '$hours hours per day';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);
    final appSettingsNotifier = ref.read(appSettingsProvider.notifier);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.schedule),
        title: const Text(
          'Standard Work Hours',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_formatHours(appSettings.standardWorkHours)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showWorkHoursDialog(context, appSettings, appSettingsNotifier),
      ),
    );
  }

  void _showWorkHoursDialog(
    BuildContext context,
    AppSettings settings,
    AppSettingsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => WorkHoursDialog(
        currentHours: settings.standardWorkHours,
        onSave: (newHours) {
          notifier.updateStandardWorkHours(newHours);
        },
      ),
    );
  }
} 