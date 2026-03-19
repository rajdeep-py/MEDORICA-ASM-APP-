import 'package:flutter_riverpod/legacy.dart';
import '../models/attendance.dart';
import '../services/attendance/attendance_services.dart';

class AttendanceNotifier extends StateNotifier<Attendance?> {
    Future<List<Attendance>> fetchMonthAttendance(DateTime month) async {
      if (_asmId == null || _asmId!.isEmpty) {
        return [];
      }
      final allRecords = await _attendanceServices.fetchAttendanceByAsmId(_asmId!);
      return allRecords.where((record) =>
        record.date.year == month.year && record.date.month == month.month
      ).toList();
    }
  AttendanceNotifier(this._attendanceServices) : super(null);

  final AttendanceServices _attendanceServices;
  String? _asmId;

  void clearAttendance() {
    _asmId = null;
    state = null;
  }

  Future<void> syncAsm(String? asmId) async {
    if (asmId == null || asmId.isEmpty) {
      clearAttendance();
      return;
    }

    _asmId = asmId;
    await loadTodaysAttendance();
  }

  Future<void> loadTodaysAttendance() async {
    if (_asmId == null || _asmId!.isEmpty) {
      state = null;
      return;
    }

    state = await _attendanceServices.fetchTodaysAttendance(asmId: _asmId!);
  }

  Future<void> checkIn({required String photoPath}) async {
    if (_asmId == null || _asmId!.isEmpty) {
      throw Exception('ASM not found in current session. Please log in again.');
    }

    if (state != null && state!.isCheckedIn) {
      return;
    }

    final now = DateTime.now();
    final attendanceDate = DateTime(now.year, now.month, now.day);
    state = await _attendanceServices.postAttendance(
      asmId: _asmId!,
      attendanceDate: attendanceDate,
      checkInTime: now,
      checkInSelfiePath: photoPath,
    );
  }

  Future<void> checkOut({required String photoPath}) async {
    if (_asmId == null || _asmId!.isEmpty) {
      throw Exception('ASM not found in current session. Please log in again.');
    }

    var current = state;
    if (current == null || !current.isCheckedIn) {
      throw Exception('Please check in before checking out.');
    }

    if (current.isCheckedOut) {
      return;
    }

    if (current.id == null) {
      current = await _attendanceServices.fetchTodaysAttendance(asmId: _asmId!);
      if (current == null || !current.isCheckedIn || current.id == null) {
        throw Exception('Unable to locate today attendance record.');
      }
    }

    state = await _attendanceServices.updateAttendance(
      asmId: _asmId!,
      attendanceId: current.id!,
      checkOutTime: DateTime.now(),
      checkOutSelfiePath: photoPath,
    );
  }
}
