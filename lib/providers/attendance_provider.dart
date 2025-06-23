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