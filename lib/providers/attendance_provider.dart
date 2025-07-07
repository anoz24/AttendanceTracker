import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

final attendanceTimesProvider = StateProvider<AttendanceTimes>((ref) {
  return AttendanceTimes(date: DateTime.now());
});

class AttendanceHistoryNotifier extends StateNotifier<List<AttendanceTimes>> {
  AttendanceHistoryNotifier() : super([]);

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
    
    final updatedList = [...state, newRecord];
    updatedList.sort((a, b) {
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1;
      if (b.date == null) return -1;
      return b.date!.compareTo(a.date!);
    });
    
    state = updatedList;
  }
}

final attendanceHistoryProvider =
    StateNotifierProvider<AttendanceHistoryNotifier, List<AttendanceTimes>>((ref) {
  return AttendanceHistoryNotifier();
});

