import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/animated_app_bar.dart';
import '../components/settings_section_header.dart';
import '../components/time_format_setting_tile.dart';
import '../components/working_days_setting_tile.dart';
import '../components/work_hours_setting_tile.dart';
import '../components/appearance_setting_tile.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const AnimatedAppBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120), // Extra bottom padding for floating nav bar
        children: const [

          // Time & Format Section
          SettingsSectionHeader(
            title: 'Time & Format',
            icon: Icons.access_time,
          ),
          TimeFormatSettingTile(),
          SizedBox(height: 24),

          // Work Configuration Section
          SettingsSectionHeader(
            title: 'Work Configuration',
            icon: Icons.work,
          ),
          WorkingDaysSettingTile(),
          SizedBox(height: 8),
          WorkHoursSettingTile(),
          SizedBox(height: 24),

          // Appearance Section
          SettingsSectionHeader(
            title: 'Appearance',
            icon: Icons.palette,
          ),
          AppearanceSettingTile(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
