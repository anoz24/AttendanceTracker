import 'package:flutter/material.dart';
import 'theme_toggle_button.dart';

class AppearanceSettingTile extends StatelessWidget {
  const AppearanceSettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.palette),
        title: const Text('Theme',
            style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: const ThemeToggleButton(),
      ),
    );
  }
} 