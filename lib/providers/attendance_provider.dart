
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/attendance.dart';
import '../notifiers/attendance_notifier.dart';
import '../notifiers/auth_notifier.dart';
import '../services/attendance/attendance_services.dart';
import 'auth_provider.dart';

final attendanceServicesProvider = Provider<AttendanceServices>((ref) {
  return AttendanceServices();
});
final monthAttendanceProvider = FutureProvider.family<List<Attendance>, DateTime>((ref, month) async {
  final notifier = ref.read(attendanceNotifierProvider.notifier);
  return notifier.fetchMonthAttendance(month);
});

final attendanceNotifierProvider =
    StateNotifierProvider<AttendanceNotifier, Attendance?>((ref) {
      final notifier = AttendanceNotifier(ref.read(attendanceServicesProvider));

      ref.listen<AuthState>(authNotifierProvider, (previous, next) {
        unawaited(notifier.syncAsm(next.asmId));
      });

      unawaited(notifier.syncAsm(ref.read(authNotifierProvider).asmId));
      return notifier;
    });

final todaysAttendanceProvider = Provider.autoDispose<Attendance?>((ref) {
  return ref.watch(attendanceNotifierProvider);
});
