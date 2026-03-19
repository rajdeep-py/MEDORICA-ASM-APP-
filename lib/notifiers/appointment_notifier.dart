import 'package:flutter_riverpod/legacy.dart';

import '../models/appointment.dart';
import '../services/appointment/appointment_services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppointmentNotifier extends StateNotifier<AsyncValue<List<Appointment>>> {
  AppointmentNotifier(this._appointmentServices) : super(const AsyncValue.data([]));

  final AppointmentServices _appointmentServices;
  String? _activeAsmId;

  Future<void> syncAsm(String? asmId) async {
    final nextAsmId = asmId?.trim();
    if (nextAsmId == null || nextAsmId.isEmpty) {
      _activeAsmId = null;
      state = const AsyncValue.data([]);
      return;
    }

    if (_activeAsmId == nextAsmId && state.maybeWhen(data: (d) => d.isNotEmpty, orElse: () => false)) {
      return;
    }

    _activeAsmId = nextAsmId;
    await loadAppointmentsByAsmId(nextAsmId);
  }

  Future<void> loadAppointmentsByAsmId(String asmId) async {
    final trimmedAsmId = asmId.trim();
    if (trimmedAsmId.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final appointments = await _appointmentServices.fetchAppointmentsByAsmId(
        trimmedAsmId,
      );
      state = AsyncValue.data(appointments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAppointment({
    required String asmId,
    required Appointment appointment,
    String? completionPhotoProofPath,
  }) async {
    state = const AsyncValue.loading();
    try {
      final created = await _appointmentServices.createAppointment(
        asmId: asmId,
        appointment: appointment,
        completionPhotoProofPath: completionPhotoProofPath,
      );
      final current = state.maybeWhen(data: (d) => d, orElse: () => <Appointment>[]);
      state = AsyncValue.data([...current, created]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAppointment({
    required String asmId,
    required Appointment appointment,
    String? completionPhotoProofPath,
  }) async {
    state = const AsyncValue.loading();
    try {
      final updated = await _appointmentServices.updateAppointmentById(
        appointmentId: appointment.id,
        appointment: appointment,
        completionPhotoProofPath: completionPhotoProofPath,
      );
      final current = state.maybeWhen(data: (d) => d, orElse: () => <Appointment>[]);
      state = AsyncValue.data([
        for (final item in current)
          if (item.id == appointment.id) updated else item,
      ]);
      if (!current.any((item) => item.id == updated.id)) {
        await loadAppointmentsByAsmId(asmId);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAppointment({
    required String asmId,
    required String appointmentId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _appointmentServices.deleteAppointmentById(appointmentId);
      final current = state.maybeWhen(data: (d) => d, orElse: () => <Appointment>[]);
      final updated = current
          .where((appointment) => appointment.id != appointmentId)
          .toList();
      state = AsyncValue.data(updated);
      if (updated.isEmpty) {
        await loadAppointmentsByAsmId(asmId);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
