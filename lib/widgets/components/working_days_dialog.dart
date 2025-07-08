import 'package:flutter/material.dart';

class WorkingDaysDialog extends StatefulWidget {
  final List<int> currentWorkingDays;
  final Function(List<int>) onSave;

  const WorkingDaysDialog({
    super.key,
    required this.currentWorkingDays,
    required this.onSave,
  });

  @override
  State<WorkingDaysDialog> createState() => _WorkingDaysDialogState();
}

class _WorkingDaysDialogState extends State<WorkingDaysDialog> {
  late List<int> _selectedDays;

  final List<MapEntry<int, String>> _daysOfWeek = [
    const MapEntry(DateTime.sunday, 'Sunday'),
    const MapEntry(DateTime.monday, 'Monday'),
    const MapEntry(DateTime.tuesday, 'Tuesday'),
    const MapEntry(DateTime.wednesday, 'Wednesday'),
    const MapEntry(DateTime.thursday, 'Thursday'),
    const MapEntry(DateTime.friday, 'Friday'),
    const MapEntry(DateTime.saturday, 'Saturday'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(widget.currentWorkingDays);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Working Days'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose which days of the week are working days:'),
            const SizedBox(height: 16),
            ..._daysOfWeek.map((dayEntry) {
              final dayNumber = dayEntry.key;
              final dayName = dayEntry.value;
              final isSelected = _selectedDays.contains(dayNumber);

              return CheckboxListTile(
                title: Text(dayName),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedDays.add(dayNumber);
                    } else {
                      _selectedDays.remove(dayNumber);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Mon-Fri'),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedDays = [DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday];
                      });
                    }
                  },
                ),
                FilterChip(
                  label: const Text('Sun-Thu'),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedDays = [DateTime.sunday, DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday];
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedDays.isNotEmpty
              ? () {
                  widget.onSave(_selectedDays);
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
} 