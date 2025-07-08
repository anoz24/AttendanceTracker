import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_settings_provider.dart';
import 'working_days_dialog.dart';

class WorkingDaysSettingTile extends ConsumerWidget {
  const WorkingDaysSettingTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettings = ref.watch(appSettingsProvider);
    final appSettingsNotifier = ref.read(appSettingsProvider.notifier);

    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_view_week),
        title: const Text(
          'Working Days',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(appSettingsNotifier.getWorkingDaysDisplayText()),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showWorkingDaysDialog(context, appSettings, appSettingsNotifier),
      ),
    );
  }

  void _showWorkingDaysDialog(
    BuildContext context,
    AppSettings settings,
    AppSettingsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => WorkingDaysDialog(
        currentWorkingDays: settings.workingDays,
        onSave: (newWorkingDays) {
          notifier.updateWorkingDays(newWorkingDays);
        },
      ),
    );
  }
} 