import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../cards/attendance/calendar_card.dart';
import '../../cards/attendance/attendance_details_card.dart';
import '../../providers/attendance_provider.dart';

class MyAttendanceScreen extends ConsumerStatefulWidget {
  const MyAttendanceScreen({super.key});

  @override
  ConsumerState<MyAttendanceScreen> createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends ConsumerState<MyAttendanceScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final attendance = ref.watch(attendanceNotifierProvider);
    ref.read(attendanceNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'My Attendance',
        subtitleText: 'View your daily records',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: CalendarCard(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AttendanceDetailsCard(
                date: _selectedDate!,
                attendance: attendance,
              ),
            ),
        ],
      ),
    );
  }
}
