import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
import 'styled_time_picker.dart';
import 'top_snack_bar.dart';

class AddMissedDaySheet extends ConsumerStatefulWidget {
  const AddMissedDaySheet({super.key});

  @override
  ConsumerState<AddMissedDaySheet> createState() => _AddMissedDaySheetState();
}

class _AddMissedDaySheetState extends ConsumerState<AddMissedDaySheet> {
  DateTime? selectedDate;
  TimeOfDay? clockInTime;
  TimeOfDay? clockOutTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isClockIn) async {
    final TimeOfDay? picked = isClockIn
        ? await StyledTimePicker.showClockIn(context)
        : await StyledTimePicker.showClockOut(context);
    if (picked != null) {
      setState(() {
        if (isClockIn) {
          clockInTime = picked;
        } else {
          clockOutTime = picked;
        }
      });
    }
  }

  bool _isDateAlreadyExists() {
    if (selectedDate == null) return false;
    
    final history = ref.read(attendanceHistoryProvider);
    return history.any((record) {
      if (record.date == null) return false;
      return record.date!.year == selectedDate!.year &&
             record.date!.month == selectedDate!.month &&
             record.date!.day == selectedDate!.day;
    });
  }

  bool _isValidTimeRange() {
    if (clockInTime == null || clockOutTime == null) return false;
    
    // Convert TimeOfDay to minutes for comparison
    final clockInMinutes = clockInTime!.hour * 60 + clockInTime!.minute;
    final clockOutMinutes = clockOutTime!.hour * 60 + clockOutTime!.minute;
    
    return clockOutMinutes > clockInMinutes;
  }

  String? _getValidationError() {
    if (selectedDate == null) return 'Please select a date';
    if (clockInTime == null) return 'Please select clock-in time';
    if (clockOutTime == null) return 'Please select clock-out time';
    
    if (_isDateAlreadyExists()) {
      return 'An attendance record already exists for this date';
    }
    
    if (!_isValidTimeRange()) {
      return 'Clock-out time must be after clock-in time';
    }
    
    return null;
  }

  void _saveMissedDay() {
    final error = _getValidationError();
    
    if (error != null) {
      TopSnackBar.show(
        context,
        message: error,
        type: TopSnackBarType.error,
        icon: Icons.error_outline,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final clockInDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      clockInTime!.hour,
      clockInTime!.minute,
    );
    
    final clockOutDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      clockOutTime!.hour,
      clockOutTime!.minute,
    );

    ref.read(attendanceHistoryProvider.notifier).addAttendanceRecord(
      date: selectedDate!,
      clockIn: clockInDateTime,
      clockOut: clockOutDateTime,
    );

    Navigator.pop(context);
    TopSnackBar.show(
      context,
      message: 'Missed day added successfully',
      type: TopSnackBarType.success,
      icon: Icons.event_available,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final error = _getValidationError();
    final isDateExists = _isDateAlreadyExists();
    final isInvalidTimeRange = clockInTime != null && clockOutTime != null && !_isValidTimeRange();

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add Missed Day',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(
              Icons.calendar_today,
              color: isDateExists 
                  ? Theme.of(context).colorScheme.error 
                  : null,
            ),
            title: Text(selectedDate == null
                ? 'Select Date'
                : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'),
            subtitle: isDateExists 
                ? Text(
                    'Date already exists',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  )
                : null,
            onTap: () => _selectDate(context),
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(clockInTime == null
                ? 'Select Clock-in Time'
                : clockInTime!.format(context)),
            onTap: () => _selectTime(context, true),
          ),
          ListTile(
            leading: Icon(
              Icons.access_time,
              color: isInvalidTimeRange 
                  ? Theme.of(context).colorScheme.error 
                  : null,
            ),
            title: Text(clockOutTime == null
                ? 'Select Clock-out Time'
                : clockOutTime!.format(context)),
            subtitle: isInvalidTimeRange 
                ? Text(
                    'Must be after clock-in time',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  )
                : null,
            onTap: () => _selectTime(context, false),
          ),
          if (error != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: error == null ? _saveMissedDay : null,
            child: const Text('Save Missed Day'),
          ),
        ],
      ),
    );
  }
} 