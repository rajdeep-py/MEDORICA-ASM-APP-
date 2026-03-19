import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/app_theme.dart';
import '../../providers/attendance_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CalendarCard extends ConsumerWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarCard({super.key, this.selectedDate, required this.onDateSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final month = DateTime(today.year, today.month);
    final monthAttendanceAsync = ref.watch(monthAttendanceProvider(month));
    final presentDates = <DateTime>[];
    final absentDates = <DateTime>[];
    monthAttendanceAsync.whenData((records) {
      for (final record in records) {
        if (record.isCheckedIn) {
          presentDates.add(record.date);
        } else {
          absentDates.add(record.date);
        }
      }
    });

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.lg)),
      elevation: AppElevation.md,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: TableCalendar(
          firstDay: DateTime(today.year, today.month - 2, 1),
          lastDay: DateTime(today.year, today.month + 2, 31),
          focusedDay: selectedDate ?? today,
          selectedDayPredicate: (day) => selectedDate != null && isSameDay(day, selectedDate),
          calendarFormat: CalendarFormat.month,
          onDaySelected: (selected, _) => onDateSelected(selected),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (presentDates.any((d) => isSameDay(d, date))) {
                return _buildDot(AppColors.success);
              } else if (absentDates.any((d) => isSameDay(d, date))) {
                return _buildDot(AppColors.error);
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
