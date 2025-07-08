// Settings Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final bool is24HourFormat;
  final List<int> workingDays;
  final double standardWorkHours;

  const AppSettings({
    this.is24HourFormat = true, // Default to 24-hour format
    required this.workingDays,
    this.standardWorkHours = 8.0,
  });

  AppSettings copyWith({
    bool? is24HourFormat,
    List<int>? workingDays,
    double? standardWorkHours,
  }) {
    return AppSettings(
      is24HourFormat: is24HourFormat ?? this.is24HourFormat,
      workingDays: workingDays ?? this.workingDays,
      standardWorkHours: standardWorkHours ?? this.standardWorkHours,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  static const String _is24HourFormatKey = 'is_24_hour_format';
  static const String _workingDaysKey = 'working_days';
  static const String _standardWorkHoursKey = 'standard_work_hours';

  AppSettingsNotifier() : super(const AppSettings(
    is24HourFormat: true,
    workingDays: [DateTime.sunday, DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday], // Sunday to Thursday
    standardWorkHours: 8.0,
  )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load time format preference
    final is24HourFormat = prefs.getBool(_is24HourFormatKey) ?? state.is24HourFormat;
    
    // Load working days
    final workingDaysString = prefs.getStringList(_workingDaysKey);
    List<int> workingDays = state.workingDays;
    if (workingDaysString != null) {
      workingDays = workingDaysString.map((e) => int.parse(e)).toList();
    }

    // Load standard work hours (support both int and double for backward compatibility)
    double standardWorkHours = state.standardWorkHours;
    final storedHours = prefs.getDouble(_standardWorkHoursKey);
    if (storedHours != null) {
      standardWorkHours = storedHours;
    } else {
      // Fallback to int if double doesn't exist (backward compatibility)
      final intHours = prefs.getInt(_standardWorkHoursKey);
      if (intHours != null) {
        standardWorkHours = intHours.toDouble();
      }
    }

    state = AppSettings(
      is24HourFormat: is24HourFormat,
      workingDays: workingDays,
      standardWorkHours: standardWorkHours,
    );
  }

  Future<void> toggleClockFormat() async {
    await setClockFormat(!state.is24HourFormat);
  }

  Future<void> setClockFormat(bool is24Hour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_is24HourFormatKey, is24Hour);
    
    state = state.copyWith(is24HourFormat: is24Hour);
  }

  Future<void> updateWorkingDays(List<int> workingDays) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_workingDaysKey, workingDays.map((e) => e.toString()).toList());
    
    state = state.copyWith(workingDays: workingDays);
  }

  Future<void> updateStandardWorkHours(double hours) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_standardWorkHoursKey, hours);
    
    state = state.copyWith(standardWorkHours: hours);
  }

  // Helper methods
  String getWorkingDaysDisplayText() {
    final dayNames = {
      DateTime.monday: 'Monday',
      DateTime.tuesday: 'Tuesday',
      DateTime.wednesday: 'Wednesday',
      DateTime.thursday: 'Thursday',
      DateTime.friday: 'Friday',
      DateTime.saturday: 'Saturday',
      DateTime.sunday: 'Sunday',
    };

    if (state.workingDays.length == 7) return 'All days';
    if (state.workingDays.isEmpty) return 'No working days';

    final sortedDays = List<int>.from(state.workingDays)..sort();
    final dayNamesList = sortedDays.map((day) => dayNames[day]!).toList();

    if (dayNamesList.length <= 3) {
      return dayNamesList.join(', ');
    } else {
      return '${dayNamesList.take(2).join(', ')} + ${dayNamesList.length - 2} more';
    }
  }

  bool isWorkingDay(DateTime date) {
    return state.workingDays.contains(date.weekday);
  }
}

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});