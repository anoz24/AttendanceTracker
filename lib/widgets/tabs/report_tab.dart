import 'package:flutter/material.dart';
import '../common/animated_app_bar.dart';

class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AnimatedAppBar(title: 'Reports'),
      body: const Padding(
        padding: EdgeInsets.only(bottom: 100), // Extra padding for floating nav bar
        child: Center(
          child: Text('Reports coming soon!'),
        ),
      ),
    );
  }
}