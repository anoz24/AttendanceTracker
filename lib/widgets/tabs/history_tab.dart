import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
import '../components/animated_app_bar.dart';
import '../components/history_empty_state.dart';
import '../components/history_list.dart';
import '../components/history_floating_action_button.dart';

class HistoryTab extends ConsumerStatefulWidget {
  const HistoryTab({super.key});

  @override
  ConsumerState<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends ConsumerState<HistoryTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(attendanceHistoryProvider);

    return Scaffold(
      appBar: const AnimatedAppBar(title: 'History'),
      floatingActionButton: const HistoryFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: history.isEmpty
          ? HistoryEmptyState(
              animation: _animationController,
              fadeAnimation: _fadeAnimation,
              slideAnimation: _slideAnimation,
            )
          : HistoryList(
              animation: _animationController,
              fadeAnimation: _fadeAnimation,
              slideAnimation: _slideAnimation,
              history: history,
            ),
    );
  }
}