import 'package:flutter/material.dart';

class WorkHoursDialog extends StatefulWidget {
  final double currentHours;
  final Function(double) onSave;

  const WorkHoursDialog({
    super.key,
    required this.currentHours,
    required this.onSave,
  });

  @override
  State<WorkHoursDialog> createState() => _WorkHoursDialogState();
}

class _WorkHoursDialogState extends State<WorkHoursDialog> {
  late double _selectedHours;

  @override
  void initState() {
    super.initState();
    // Ensure the current hours are within the valid range (4-12)
    _selectedHours = widget.currentHours.clamp(4.0, 12.0);
  }

  String _formatHours(double hours) {
    if (hours == hours.roundToDouble()) {
      return '${hours.toInt()}h';
    } else {
      return '${hours}h';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Standard Work Hours'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select the expected number of hours per working day:'),
          const SizedBox(height: 32),
          
          // Current selection display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _formatHours(_selectedHours),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              thumbColor: Theme.of(context).colorScheme.primary,
              overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              valueIndicatorColor: Theme.of(context).colorScheme.primary,
              valueIndicatorTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Slider(
              value: _selectedHours,
              min: 4.0,
              max: 12.0,
              divisions: 16, // (12 - 4) * 2 = 16 divisions for 0.5 increments
              label: _formatHours(_selectedHours),
              onChanged: (value) {
                setState(() {
                  _selectedHours = value;
                });
              },
            ),
          ),
          
          // Min and max labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '4h',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  '12h',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_selectedHours);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
} 