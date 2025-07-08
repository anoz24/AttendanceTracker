import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AttendanceTimes {
  final DateTime? date;
  final DateTime? clockIn;
  final DateTime? clockOut;

  AttendanceTimes({this.date, this.clockIn, this.clockOut});

  AttendanceTimes copyWith({DateTime? date, DateTime? clockIn, DateTime? clockOut}) {
    return AttendanceTimes(
      date: date ?? this.date,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'clockIn': clockIn?.toIso8601String(),
      'clockOut': clockOut?.toIso8601String(),
    };
  }

  factory AttendanceTimes.fromJson(Map<String, dynamic> json) {
    return AttendanceTimes(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      clockIn: json['clockIn'] != null ? DateTime.parse(json['clockIn']) : null,
      clockOut: json['clockOut'] != null ? DateTime.parse(json['clockOut']) : null,
    );
  }
}

final attendanceTimesProvider = StateProvider<AttendanceTimes>((ref) {
  return AttendanceTimes(date: DateTime.now());
});

class AttendanceHistoryNotifier extends StateNotifier<List<AttendanceTimes>> {
  static const String _attendanceDataKey = 'attendance_history_data';
  
  AttendanceHistoryNotifier() : super([]) {
    _loadAttendanceData();
  }
  
  // Load attendance data from SharedPreferences
  Future<void> _loadAttendanceData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? attendanceDataJson = prefs.getString(_attendanceDataKey);
      
      if (attendanceDataJson != null) {
        final List<dynamic> decodedData = json.decode(attendanceDataJson);
        final List<AttendanceTimes> loadedRecords = decodedData
            .map((json) => AttendanceTimes.fromJson(json))
            .toList();
        
        state = loadedRecords;
      }
    } catch (e) {
      // Handle error silently, start with empty list
      state = [];
    }
  }

  // Save attendance data to SharedPreferences
  Future<void> _saveAttendanceData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String attendanceDataJson = json.encode(
        state.map((record) => record.toJson()).toList(),
      );
      await prefs.setString(_attendanceDataKey, attendanceDataJson);
    } catch (e) {
      // Handle error silently
    }
  }

  void addAttendanceRecord({
    required DateTime date,
    required DateTime clockIn,
    required DateTime clockOut,
  }) {
    final newRecord = AttendanceTimes(
      date: date,
      clockIn: clockIn,
      clockOut: clockOut,
    );
    state = [newRecord, ...state];
    _saveAttendanceData();
  }

  void editAttendanceRecord(int index, {
    DateTime? date,
    DateTime? clockIn,
    DateTime? clockOut,
  }) {
    if (index >= 0 && index < state.length) {
      final updatedRecord = state[index].copyWith(
        date: date,
        clockIn: clockIn,
        clockOut: clockOut,
      );
      final updatedList = [...state];
      updatedList[index] = updatedRecord;
      state = updatedList;
      _saveAttendanceData();
    }
  }

  void deleteAttendanceRecord(int index) {
    if (index >= 0 && index < state.length) {
      final updatedList = [...state];
      updatedList.removeAt(index);
      state = updatedList;
      _saveAttendanceData();
    }
  }

  void deleteAttendanceRecordByDate(DateTime date) {
    state = state.where((record) => 
        record.date == null || !isSameDay(record.date!, date)).toList();
    _saveAttendanceData();
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}

final attendanceHistoryProvider = 
    StateNotifierProvider<AttendanceHistoryNotifier, List<AttendanceTimes>>((ref) {
  return AttendanceHistoryNotifier();
});

