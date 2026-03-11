import 'package:flutter_riverpod/legacy.dart';
import '../models/doctor.dart';
import '../services/doctor_network/doctor_network_services.dart';

class DoctorState {
  final List<Doctor> doctors;
  final bool isLoading;
  final String? error;

  const DoctorState({
    this.doctors = const [],
    this.isLoading = false,
    this.error,
  });

  DoctorState copyWith({
    List<Doctor>? doctors,
    bool? isLoading,
    String? error,
  }) {
    return DoctorState(
      doctors: doctors ?? this.doctors,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DoctorNotifier extends StateNotifier<DoctorState> {
  DoctorNotifier(this._doctorNetworkServices) : super(const DoctorState());

  final DoctorNetworkServices _doctorNetworkServices;
  String? _activeAsmId;

  Future<void> syncAsm(String? asmId) async {
    final nextAsmId = asmId?.trim();
    if (nextAsmId == null || nextAsmId.isEmpty) {
      _activeAsmId = null;
      state = const DoctorState();
      return;
    }

    if (_activeAsmId == nextAsmId &&
        (state.doctors.isNotEmpty || state.isLoading)) {
      return;
    }

    _activeAsmId = nextAsmId;
    await loadDoctorsByAsmId(nextAsmId);
  }

  Future<void> loadDoctorsByAsmId(String asmId) async {
    final trimmedAsmId = asmId.trim();
    if (trimmedAsmId.isEmpty) {
      state = const DoctorState(error: 'ASM ID is required to load doctors.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final doctors = await _doctorNetworkServices.fetchDoctorsByAsmId(
        trimmedAsmId,
      );
      state = state.copyWith(doctors: doctors, isLoading: false, error: null);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        doctors: const [],
        error: _readErrorMessage(error),
      );
    }
  }

  Future<void> addDoctor({
    required String asmId,
    required Doctor doctor,
    String? doctorPhotoPath,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _doctorNetworkServices.createDoctor(
        asmId: asmId,
        doctor: doctor,
        doctorPhotoPath: doctorPhotoPath,
      );
      await loadDoctorsByAsmId(asmId);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      rethrow;
    }
  }

  Future<void> updateDoctor({
    required String asmId,
    required String doctorId,
    required Doctor doctor,
    String? doctorPhotoPath,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _doctorNetworkServices.updateDoctorByAsmAndDoctorId(
        asmId: asmId,
        doctorId: doctorId,
        doctor: doctor,
        doctorPhotoPath: doctorPhotoPath,
      );
      await loadDoctorsByAsmId(asmId);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      rethrow;
    }
  }

  Future<void> deleteDoctor({
    required String asmId,
    required String doctorId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _doctorNetworkServices.deleteDoctorByDoctorId(doctorId);
      await loadDoctorsByAsmId(asmId);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      rethrow;
    }
  }

  // Get a doctor by id
  Doctor? getDoctorById(String id) {
    try {
      return state.doctors.firstWhere((doctor) => doctor.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search doctors
  List<Doctor> searchDoctors(String query) {
    if (query.isEmpty) return state.doctors;
    final lowerQuery = query.toLowerCase();
    return state.doctors
        .where(
          (doctor) =>
              doctor.name.toLowerCase().contains(lowerQuery) ||
              doctor.specialization.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  // Filter by specialization
  List<Doctor> filterBySpecialization(String specialization) {
    if (specialization.isEmpty) return state.doctors;
    return state.doctors
        .where((doctor) => doctor.specialization == specialization)
        .toList();
  }

  // Get all specializations
  List<String> getAllSpecializations() {
    return state.doctors
        .map((doctor) => doctor.specialization)
        .toSet()
        .toList();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _readErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }
}
