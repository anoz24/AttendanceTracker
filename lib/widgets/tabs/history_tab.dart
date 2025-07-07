import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
// import '../../utils/date_utils.dart';
import '../common/add_missed_day_sheet.dart';
import '../common/activity_card.dart';

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

  // Constants
  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Utility Methods
  String _getMonthName(int month) => _monthNames[month - 1];
  
  int _getMonthNumber(String monthName) => _monthNames.indexOf(monthName) + 1;

  String _formatMonthYear(DateTime date) => '${_getMonthName(date.month)} ${date.year}';

  int _calculateTotalHours(List<AttendanceTimes> records) {
    return records
        .where((record) => record.clockIn != null && record.clockOut != null)
        .fold(0, (total, record) {
          final minutes = record.clockOut!.difference(record.clockIn!).inMinutes;
          return total + minutes;
        }) ~/ 60;
  }

  Map<String, List<AttendanceTimes>> _groupRecordsByMonth(List<AttendanceTimes> records) {
    final Map<String, List<AttendanceTimes>> grouped = {};
    
    for (final record in records) {
      if (record.date != null) {
        final monthYear = _formatMonthYear(record.date!);
        grouped.putIfAbsent(monthYear, () => []).add(record);
      }
    }
    
    return grouped;
  }

  List<String> _sortMonthsChronologically(Map<String, List<AttendanceTimes>> groupedRecords) {
    return groupedRecords.keys.toList()
      ..sort((a, b) {
        final aParts = a.split(' ');
        final bParts = b.split(' ');
        
        final aYear = int.parse(aParts[1]);
        final bYear = int.parse(bParts[1]);
        
        if (aYear != bYear) return bYear.compareTo(aYear);
        
        final aMonth = _getMonthNumber(aParts[0]);
        final bMonth = _getMonthNumber(bParts[0]);
        return bMonth.compareTo(aMonth);
      });
  }

  void _showAddMissedDaySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddMissedDaySheet(),
    );
  }

  // UI Builders
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('History', style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _showAddMissedDaySheet,
          tooltip: 'Add Missed Day',
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'No history yet',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start tracking your attendance',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showAddMissedDaySheet,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Missed Day'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthCard({
    required String month,
    required List<AttendanceTimes> records,
    required int index,
    required bool isExpanded,
  }) {
    final totalHours = _calculateTotalHours(records);
    final delayedAnimation = _createDelayedAnimation(index);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => FadeTransition(
        opacity: delayedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(delayedAnimation),
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: isExpanded,
                leading: _buildMonthIcon(),
                title: Text(
                  month,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${records.length} days • ${totalHours}h total',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                children: records.map((record) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ActivityCard(record: record),
                )).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.calendar_month,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Animation<double> _createDelayedAnimation(int index) {
    final delay = (index * 100).clamp(0, 500);
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          delay / 600,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(attendanceHistoryProvider);
    final groupedRecords = _groupRecordsByMonth(history);

    if (groupedRecords.isEmpty) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: _buildEmptyState(),
      );
    }

    final sortedMonths = _sortMonthsChronologically(groupedRecords);

    return Scaffold(
      appBar: _buildAppBar(),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => FadeTransition(
          opacity: _fadeAnimation,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: sortedMonths.length,
            itemBuilder: (context, index) {
              final month = sortedMonths[index];
              final records = groupedRecords[month]!;
              
              return _buildMonthCard(
                month: month,
                records: records,
                index: index,
                isExpanded: index == 0, // Only expand the most recent month
              );
            },
          ),
        ),
      ),
    );
  }
}