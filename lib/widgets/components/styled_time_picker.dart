import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_settings_provider.dart';

class StyledTimePicker {
  /// Shows a standard time picker dialog with user's preferred time format
  static Future<TimeOfDay?> show({
    required BuildContext context,
    TimeOfDay? initialTime,
    String? helpText,
    required bool use24HourFormat,
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      helpText: helpText,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: use24HourFormat,
          ),
          child: child!,
        );
      },
    );
  }

  /// Convenience method for clock in time picker
  static Future<TimeOfDay?> showClockIn(BuildContext context, {TimeOfDay? initialTime}) async {
    final container = ProviderScope.containerOf(context);
    final settings = container.read(appSettingsProvider);
    
    return show(
      context: context,
      initialTime: initialTime,
      helpText: 'Select Clock In Time',
      use24HourFormat: settings.is24HourFormat,
    );
  }

  /// Convenience method for clock out time picker
  static Future<TimeOfDay?> showClockOut(BuildContext context, {TimeOfDay? initialTime}) async {
    final container = ProviderScope.containerOf(context);
    final settings = container.read(appSettingsProvider);
    
    return show(
      context: context,
      initialTime: initialTime,
      helpText: 'Select Clock Out Time',
      use24HourFormat: settings.is24HourFormat,
    );
  }
} 