import 'package:flutter_riverpod/legacy.dart';

import '../models/appointment.dart';
import '../services/appointment/appointment_services.dart';

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  AppointmentNotifier(this._appointmentServices) : super(const []);

  final AppointmentServices _appointmentServices;
  String? _activeAsmId;

  Future<void> syncAsm(String? asmId) async {
    final nextAsmId = asmId?.trim();
    if (nextAsmId == null || nextAsmId.isEmpty) {
      _activeAsmId = null;
      state = const [];
      return;
    }

    if (_activeAsmId == nextAsmId && state.isNotEmpty) {
      return;
    }

    _activeAsmId = nextAsmId;
    await loadAppointmentsByAsmId(nextAsmId);
  }

  Future<void> loadAppointmentsByAsmId(String asmId) async {
    final trimmedAsmId = asmId.trim();
    if (trimmedAsmId.isEmpty) {
      state = const [];
      return;
    }

    final appointments = await _appointmentServices.fetchAppointmentsByAsmId(
      trimmedAsmId,
    );
    state = appointments;
  }

  Future<void> addAppointment({
    required String asmId,
    required Appointment appointment,
    String? completionPhotoProofPath,
  }) async {
    final created = await _appointmentServices.createAppointment(
      asmId: asmId,
      appointment: appointment,
      completionPhotoProofPath: completionPhotoProofPath,
    );
    state = [...state, created];
  }

  Future<void> updateAppointment({
    required String asmId,
    required Appointment appointment,
    String? completionPhotoProofPath,
  }) async {
    final updated = await _appointmentServices.updateAppointmentById(
      appointmentId: appointment.id,
      appointment: appointment,
      completionPhotoProofPath: completionPhotoProofPath,
    );

    state = [
      for (final item in state)
        if (item.id == appointment.id) updated else item,
    ];

    if (!state.any((item) => item.id == updated.id)) {
      await loadAppointmentsByAsmId(asmId);
    }
  }

  Future<void> deleteAppointment({
    required String asmId,
    required String appointmentId,
  }) async {
    await _appointmentServices.deleteAppointmentById(appointmentId);
    state = state
        .where((appointment) => appointment.id != appointmentId)
        .toList();

    if (state.isEmpty) {
      await loadAppointmentsByAsmId(asmId);
    }
  }
}
