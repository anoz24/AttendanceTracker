import 'package:flutter/material.dart';
import '../components/add_missed_day_sheet.dart';

class HistoryFloatingActionButton extends StatelessWidget {
  const HistoryFloatingActionButton({super.key});

  void _showAddMissedDaySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddMissedDaySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 110),
      child: FloatingActionButton(
        onPressed: () => _showAddMissedDaySheet(context),
        tooltip: 'Add Missed Day',
        child: const Icon(Icons.add),
      ),
    );
  }
} 