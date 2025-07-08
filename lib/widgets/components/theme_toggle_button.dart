import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    IconData getThemeIcon() {
      switch (themeMode) {
        case ThemeMode.light:
          return Icons.light_mode;
        case ThemeMode.dark:
          return Icons.dark_mode;
        case ThemeMode.system:
          return Icons.brightness_auto;
      }
    }

    String getTooltip() {
      switch (themeMode) {
        case ThemeMode.light:
          return 'Light Mode (tap for Dark)';
        case ThemeMode.dark:
          return 'Dark Mode (tap for System)';
        case ThemeMode.system:
          return 'System Mode (tap for Light)';
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          themeNotifier.currentThemeName,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            getThemeIcon(),
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            themeNotifier.toggleTheme();
          },
          tooltip: getTooltip(),
        ),
      ],
    );
  }
} 