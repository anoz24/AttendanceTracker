// Settings Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  final bool is24HourFormat;

  const AppSettings({
    this.is24HourFormat = true, // Default to 24-hour format
  });

  AppSettings copyWith({
    bool? is24HourFormat,
  }) {
    return AppSettings(
      is24HourFormat: is24HourFormat ?? this.is24HourFormat,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(const AppSettings());

  void toggleClockFormat() {
    state = state.copyWith(is24HourFormat: !state.is24HourFormat);
  }

  void setClockFormat(bool is24Hour) {
    state = state.copyWith(is24HourFormat: is24Hour);
  }
}

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});