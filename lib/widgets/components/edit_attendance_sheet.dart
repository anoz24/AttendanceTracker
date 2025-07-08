import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
import 'styled_time_picker.dart';
import 'top_snack_bar.dart';

class EditAttendanceSheet extends ConsumerStatefulWidget {
  final AttendanceTimes record;
  final int recordIndex;

  const EditAttendanceSheet({
    super.key,
    required this.record,
    required this.recordIndex,
  });

  @override
  ConsumerState<EditAttendanceSheet> createState() => _EditAttendanceSheetState();
}

class _EditAttendanceSheetState extends ConsumerState<EditAttendanceSheet> {
  late DateTime selectedDate;
  late TimeOfDay clockInTime;
  late TimeOfDay clockOutTime;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.record.date ?? DateTime.now();
    clockInTime = widget.record.clockIn != null 
        ? TimeOfDay.fromDateTime(widget.record.clockIn!)
        : TimeOfDay.now();
    clockOutTime = widget.record.clockOut != null
        ? TimeOfDay.fromDateTime(widget.record.clockOut!)
        : TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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
        ? await StyledTimePicker.showClockIn(context, initialTime: isClockIn ? clockInTime : clockOutTime)
        : await StyledTimePicker.showClockOut(context, initialTime: isClockIn ? clockInTime : clockOutTime);
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

  void _saveChanges() {
    final clockInDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      clockInTime.hour,
      clockInTime.minute,
    );
    
    final clockOutDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      clockOutTime.hour,
      clockOutTime.minute,
    );

    if (clockOutDateTime.isAfter(clockInDateTime)) {
      ref.read(attendanceHistoryProvider.notifier).editAttendanceRecord(
        widget.recordIndex,
        date: selectedDate,
        clockIn: clockInDateTime,
        clockOut: clockOutDateTime,
      );

      Navigator.pop(context);
      TopSnackBar.show(
        context,
        message: 'Attendance record updated successfully',
        type: TopSnackBarType.success,
        icon: Icons.edit,
        duration: const Duration(seconds: 2),
      );
    } else {
      TopSnackBar.show(
        context,
        message: 'Clock out time must be after clock in time',
        type: TopSnackBarType.error,
        icon: Icons.access_time,
        duration: const Duration(seconds: 3),
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
            'Edit Attendance Record',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(
              '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
            ),
            subtitle: const Text('Date'),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(clockInTime.format(context)),
            subtitle: const Text('Clock-in Time'),
            onTap: () => _selectTime(context, true),
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(clockOutTime.format(context)),
            subtitle: const Text('Clock-out Time'),
            onTap: () => _selectTime(context, false),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 