import 'package:flutter/material.dart';
import '../components/animated_app_bar.dart';

class ReportEmptyState extends StatelessWidget {
  const ReportEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AnimatedAppBar(title: 'Reports'),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No attendance data available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Start tracking your attendance to see reports',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
} 