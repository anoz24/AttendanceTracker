import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
import 'styled_time_picker.dart';

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
      firstDate: DateTime(2020),
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

  void _saveMissedDay() {
    if (selectedDate != null && clockInTime != null && clockOutTime != null) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missed day added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            leading: const Icon(Icons.calendar_today),
            title: Text(selectedDate == null
                ? 'Select Date'
                : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'),
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
            leading: const Icon(Icons.access_time),
            title: Text(clockOutTime == null
                ? 'Select Clock-out Time'
                : clockOutTime!.format(context)),
            onTap: () => _selectTime(context, false),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (selectedDate != null &&
                    clockInTime != null &&
                    clockOutTime != null)
                ? _saveMissedDay
                : null,
            child: const Text('Save Missed Day'),
          ),
        ],
      ),
    );
  }
} 