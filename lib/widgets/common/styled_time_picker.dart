import 'package:flutter/material.dart';

class StyledTimePicker {
  /// Shows a beautifully styled time picker dialog
  static Future<TimeOfDay?> show({
    required BuildContext context,
    TimeOfDay? initialTime,
    String? helpText,
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      helpText: helpText,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hourMinuteColor: Theme.of(context).colorScheme.primaryContainer,
              hourMinuteTextColor: Theme.of(context).colorScheme.onPrimaryContainer,
              dayPeriodColor: Theme.of(context).colorScheme.secondaryContainer,
              dayPeriodTextColor: Theme.of(context).colorScheme.onSecondaryContainer,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialBackgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              dialTextColor: Theme.of(context).colorScheme.onSurfaceVariant,
              entryModeIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
              helpTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              hourMinuteTextStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              dayPeriodTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.all(16),
              elevation: 8,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  /// Convenience method for clock in time picker
  static Future<TimeOfDay?> showClockIn(BuildContext context, {TimeOfDay? initialTime}) {
    return show(
      context: context,
      initialTime: initialTime,
      helpText: 'Select Clock In Time',
    );
  }

  /// Convenience method for clock out time picker
  static Future<TimeOfDay?> showClockOut(BuildContext context, {TimeOfDay? initialTime}) {
    return show(
      context: context,
      initialTime: initialTime,
      helpText: 'Select Clock Out Time',
    );
  }
} 