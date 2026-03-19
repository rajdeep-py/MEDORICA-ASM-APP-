import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/attendance.dart';

class AttendanceDetailsCard extends StatelessWidget {
  final DateTime date;
  final Attendance? attendance;

  const AttendanceDetailsCard({super.key, required this.date, this.attendance});

  @override
  Widget build(BuildContext context) {
    final isPresent = attendance?.isCheckedIn == true && attendance?.date == date;
    final checkIn = attendance?.checkIn;
    final checkOut = attendance?.checkOut;
    final status = attendance?.status ?? (isPresent ? 'Present' : 'Absent');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.lg)),
      elevation: AppElevation.md,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Details',
              style: AppTypography.h3.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Date: ${_formatDate(date)}', style: AppTypography.body),
            const SizedBox(height: AppSpacing.sm),
            Text('Status: $status', style: AppTypography.body),
            const SizedBox(height: AppSpacing.sm),
            Text('Check In: ${_formatTime(checkIn)}', style: AppTypography.body),
            const SizedBox(height: AppSpacing.sm),
            Text('Check Out: ${_formatTime(checkOut)}', style: AppTypography.body),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }

  String _formatTime(DateTime? t) {
    if (t == null) return '-';
    final localTime = t.toLocal();
    final h = localTime.hour.toString().padLeft(2, '0');
    final m = localTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
