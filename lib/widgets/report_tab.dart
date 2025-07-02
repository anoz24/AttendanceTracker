import 'package:flutter/material.dart';

class ReportTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Report Tab'),
      ),
    );
  }
}