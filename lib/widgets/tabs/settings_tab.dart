import 'package:attendancetracker/providers/app_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../common/animated_app_bar.dart';
import '../common/theme_toggle_button.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final themeMode = ref.watch(themeProvider);

    String getThemeDescription() {
      switch (themeMode) {
        case ThemeMode.light:
          return 'Always use light theme';
        case ThemeMode.dark:
          return 'Always use dark theme';
        case ThemeMode.system:
          return 'Follows system dark/light mode';
      }
    }

    return Scaffold(
      appBar: const AnimatedAppBar(title: 'Settings'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            16, 16, 16, 100), // Extra bottom padding for floating nav bar
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(getThemeDescription()),
                trailing: const ThemeToggleButton(),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text(
                  'Time Format',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(settings.is24HourFormat
                    ? '24-hour (14:30)'
                    : '12-hour (2:30 PM)'),
                trailing: Switch(
                  value: settings.is24HourFormat,
                  onChanged: (value) {
                    ref
                        .read(appSettingsProvider.notifier)
                        .setClockFormat(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
