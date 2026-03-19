import 'package:iconsax/iconsax.dart';
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

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPresent ? Iconsax.tick_circle : Iconsax.close_circle,
                    color: isPresent ? AppColors.success : AppColors.error,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Attendance Details',
                  style: AppTypography.h2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Icon(Iconsax.calendar, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text('Date: ${_formatDate(date)}', style: AppTypography.body),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Iconsax.status, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text('Status: $status', style: AppTypography.body),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Iconsax.login, color: AppColors.success, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text('Check In: ${_formatTime(checkIn)}', style: AppTypography.body),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Iconsax.logout, color: AppColors.error, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text('Check Out: ${_formatTime(checkOut)}', style: AppTypography.body),
              ],
            ),
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
