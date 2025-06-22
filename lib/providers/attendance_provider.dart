import 'package:flutter_riverpod/flutter_riverpod.dart';

final attendanceTimeProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});